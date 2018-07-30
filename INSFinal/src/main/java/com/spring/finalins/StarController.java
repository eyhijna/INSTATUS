package com.spring.finalins;

import java.io.File;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.finalins.common.FileManager;
import com.spring.finalins.common.MyUtil;
import com.spring.finalins.model.MemberVO;
import com.spring.finalins.model.ProjectVO;
import com.spring.finalins.model.TeamMemberVO;
import com.spring.finalins.model.TeamVO;
import com.spring.finalins.service.InterStarService;

@Component
@Controller
public class StarController {

	 
	  @Autowired
	  private InterStarService service;
	  
	  @Autowired
	  private FileManager fileManager;
	 /* 
	  // 팀을 만드는 페이지로 이동 
	  @RequestMapping(value="/main.action", method={RequestMethod.GET})
	  public String requireLogin_main(HttpServletRequest req, HttpServletResponse res) {
		  
		   HttpSession session = req.getSession();
		   MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		   
		   int n = service.getcountTeam(loginuser.getUserid()); // 가입된 팀 갯수알아오기  
		   req.setAttribute("countTeam", n);
		   
		   return "main.tiles2";
	  }*/
	  
	  // 가입된 팀 목록을 보여주는 메소드 JSON
	  @RequestMapping(value="/showTeamList.action", method={RequestMethod.GET})
	  public String showTeamList(HttpServletRequest req) {
		  
		   HttpSession session = req.getSession();
		   MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		    
		   String str_jsonArray = service.getTeamListJSON(loginuser.getUserid()); // 가입된 팀 목록가져오기
		   
		   System.out.println("확인용 teamList JSON "+str_jsonArray);
		    
		   req.setAttribute("str_jsonArray", str_jsonArray); 
		   
		   return "teamListJSON.notiles";
	  }
	  
	  // 팀생성하기 
	  @RequestMapping(value="/createTeam.action", method={RequestMethod.POST})
	  public String requireLogin_createTeam(HttpServletRequest req, HttpServletResponse res) {
		  
		   HttpSession session = req.getSession(); 
		   session.setAttribute("createTeam", "yes");
		   
		   String team_name = req.getParameter("new_team_name");

		   MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		   
		   HashMap<String, String> map = new HashMap<String, String>(); 
		   
		   map.put("team_name", team_name);
		   map.put("userid", loginuser.getUserid());
		   
		   int n = service.createTeam(map);
		   //팀생성하기
		   if(n == 0) {
			   String msg = " 팀생성 에러발생 ";
			   String loc = "javascript:history.back();";
			   
			   req.setAttribute("msg", msg);
			   req.setAttribute("loc", loc);
			   return "msg.notiles";  
	       }
		   TeamVO teamvo = service.myTeamInfo(map);
		   //팀정보 가져오기 
		   
		   req.setAttribute("teamvo", teamvo);
		   
		   return "star/checkName.tiles";
	  }
	   // 팀목록에서 내가 팀을 선택해서 들어갔을때 보여주는 페이지
	   @RequestMapping(value="/showTeam.action", method={RequestMethod.GET})
	   public String showTeam(HttpServletRequest req) {
			  
		  String team_idx = req.getParameter("team_idx");
		  System.out.println("확인용 team_idx(showTeam.action) :"+team_idx);
		 
		  HttpSession session = req.getSession();
		  MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		    
		  String msg = "";
	      String loc = "";
		  if(loginuser == null) {
			   msg = "로그인이 필요한 메뉴입니다.";
			   loc = "/finalins/index.action";
			  
			  req.setAttribute("msg", msg);
			  req.setAttribute("loc", loc);
			  
			  return "msg.notiles";
		  }
		  
		  TeamVO teamvo = service.teamInfoVO(team_idx);
		   
		  String nav = "1"; 
		  req.setAttribute("nav", nav);
	      req.setAttribute("team_idx", team_idx);
	   	  req.setAttribute("teamvo", teamvo); 
	   	  
	   	  if("0".equals(teamvo.getTeam_delete_status())) {
	   		  
	   		   msg = "삭제된 팀입니다.";
	   		   loc = "javascript:history.back();";
	   		   
	   		   req.setAttribute("loc", loc);
	   		   req.setAttribute("msg", msg);
	   		   
	   		   return "msg.notiles";
	   	  }
	      List<TeamMemberVO> memberList = service.teamMemberList(team_idx); // 팀의 회원정보들을 불러오는 메소드
	   	  req.setAttribute("memberList", memberList);
	   	  
	   	  HashMap<String, String> map = new HashMap<String, String>();
	   	  map.put("login_userid", loginuser.getUserid());
	   	  map.put("team_idx", team_idx);
	   	  
	   	  int n = service.checkMemberExist(map); //내가 회원에 존재하는지 체크 
	      if(n>0) { 
	    	 TeamMemberVO myinfo = service.teamMemberInfo(map); //존재한다면 나의 status 를 가져온다.
	    	 if( ("3".equals(myinfo.getTeam_member_admin_status()) || "4".equals(myinfo.getTeam_member_admin_status()) )
	    			  && "0".equals(teamvo.getTeam_visibility_status())) { // 승락을 받지않은 회원이면서 팀이 비공개라면 막아준다 
	    		 msg = "권한이 없습니다.";
		    	 loc = "javascript:history.back();";
		    	 
		    	 req.setAttribute("msg", msg);
		    	 req.setAttribute("loc", loc);
		    	 
		    	 return "msg.notiles"; 
	    	 }
	    	 else req.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
	    	  
	      } 
	      else if(n==0 && "0".equals(teamvo.getTeam_visibility_status())) { // 팀원이아니면서 팀이비공개라면 막아준다.
	    	 msg = "권한이 없습니다.";
	    	 loc = "javascript:history.back();";
	    	 
	    	 req.setAttribute("msg", msg);
	    	 req.setAttribute("loc", loc);
	    	 
	    	 return "msg.notiles"; 
	      }
	      return "star/myTeamInfo.tiles"; 
	   }
	  // 팀 생성 버튼을 눌렀을때 이동되는 페이지 
	  @RequestMapping(value="/myTeamInfo.action", method={RequestMethod.GET})
	  public String loginAndInsert_myTeamInfo(HttpServletRequest req, HttpServletResponse res, TeamVO teamvo) {
		    
		    
			String goBackURL = MyUtil.getCurrentURL(req);
			req.setAttribute("goBackURL", goBackURL);  
			
			req.setAttribute("teamvo", teamvo);
			System.out.println("확인용 VO : "+teamvo.getTeam_name());
			 
			HttpSession session = req.getSession(); 
			if("yes".equals(session.getAttribute("createTeam"))) {
				// 팀 생성하기 버튼을 누르고 들어왔을때 
				System.out.println("세션확인용");
				teamvo = service.teamInfoVO(teamvo.getTeam_idx());
				session.setAttribute("teamvo", teamvo); 
			}   
			
			req.setAttribute("team_idx", teamvo.getTeam_idx());  
			return "star/myTeamInfo.tiles"; 
	  }
	  
	  // 팀명을 바꿀때 호출되는 메소드
	  @RequestMapping(value="/EditEnd.action", method={RequestMethod.POST})
	  public String requireLogin_EditEnd(HttpServletRequest req, HttpServletResponse res) {
		   
		   String team_idx = req.getParameter("team_idx");
	       System.out.println("확인용 "+team_idx);
		   
	       String team_name = req.getParameter("team_name");
		   System.out.println(team_name);
		  
		   HttpSession session = req.getSession();
		   MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		   String login_userid = loginuser.getUserid(); 
			  
		   HashMap<String, String> map = new HashMap<String, String>();
		   
		   map.put("team_name", team_name);
		   map.put("team_idx", team_idx);
		   map.put("login_userid", login_userid);
		   
		   TeamMemberVO tmembervo = service.teamMemberInfo(map);
		   TeamVO teamvo = service.teamInfoVO(team_idx);
		   System.out.println("확인용 로그인유저아이디"+loginuser.getUserid());
		   System.out.println("tmembervo adminstatus "+tmembervo.getTeam_member_admin_status());
		 
		   String msg ="";
		     
		   List<TeamMemberVO> memberList = service.teamMemberList(team_idx);	  
		   
		    int n = service.editTeam(map); //팀 명 변경 
			   
			if(n == 0) {
				  msg = "팀명변경 에러";  
				  String nav = "1"; 
				  req.setAttribute("msg", msg);
				    
				  req.setAttribute("nav", nav);
				  req.setAttribute("team_idx", team_idx);
				  req.setAttribute("teamvo", teamvo); 	  
				  return "star/myTeamInfo.tiles";  
		    }

		   String nav = "1"; 
		    
		   int m = service.checkMemberExist(map); //내가 회원에 존재하는지 체크 
		   if(m>0) { 
		         TeamMemberVO myinfo = service.teamMemberInfo(map); //존재한다면 나의 status 를 가져온다. 	    	 
		    	 req.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
		   }
		   req.setAttribute("nav", nav);
		   req.setAttribute("team_idx", team_idx);
		   req.setAttribute("teamvo", teamvo); 
		   req.setAttribute("memberList", memberList);
		   
		   return "star/myTeamInfo.tiles";  
	  }
	   
	  // 디폴트인 팀명을 보여주는 뷰단 메소드 (AJAX)
	  @RequestMapping(value="/TeamInfoTop.action", method={RequestMethod.GET})
	  public String TeamInfoTop(HttpServletRequest req) {
		   
		   String team_idx =  req.getParameter("team_idx");
		   System.out.println("확인용team_idx"+team_idx);

		   String str_json = service.getInfoTeam(team_idx); // 변경완료된 팀정보 가져오기
		   
		   System.out.println("확인용 str_json : " +str_json);
		   req.setAttribute("str_json", str_json); 
		   
		   return "editTeamJSON.notiles";   
	  }
	  
	  // 팀정보에서 Setting 버튼을 눌렀을때 호출되는 메소드 
	  @RequestMapping(value="/teamSetting.action", method={RequestMethod.GET})
	  public String teamSetting(HttpServletRequest req) {

		    HttpSession session = req.getSession(); 
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			if(loginuser == null) {
				
				String msg = "로그인이 필요한 메뉴입니다.";
				String loc = "/finalins/index.action";
				
				req.setAttribute("msg", msg);
				req.setAttribute("loc", loc);
				
				return "msg.notiles";
			}
			String team_idx = req.getParameter("team_idx");
			
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("login_userid", loginuser.getUserid());
			map.put("team_idx", team_idx); 
			
			int joinMemberCnt = service.joinMemberCount(team_idx);
			
			TeamVO tvo = service.teamInfoVO(team_idx);
			TeamMemberVO tmember = service.teamMemberInfo(map);   // 팀멤버테이블 정보 가져오기 
			
		    System.out.println("확인용 tmvo" +tmember.getFk_team_idx());
		     
		   	int n = service.checkMemberExist(map); //내가 회원에 존재하는지 체크 
		    if(n>0) {
		        TeamMemberVO myinfo = service.teamMemberInfo(map); //존재한다면 나의 status 를 가져온다.
		        req.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
		    } 
		   	  
		    req.setAttribute("joinMemberCnt", joinMemberCnt);
		    req.setAttribute("tmember", tmember);
		    req.setAttribute("tvo", tvo);
		   
		    return "setting.notiles";   
	  }
	  
	  // 팀공개컬럼 업데이트해주는 메소드
	  @RequestMapping(value="/changeView.action", method={RequestMethod.POST})
	  public String requireLogin_changeView(HttpServletRequest req, HttpServletResponse res) {

		    String team_idx = req.getParameter("team_idx");
		    
		    TeamVO teamvo = service.teamInfoVO(team_idx);
		    HttpSession session = req.getSession();
		    MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		    String msg ="";
		    String loc ="";
		    
		    HashMap<String, String> map = new HashMap<String, String>();
			map.put("login_userid", loginuser.getUserid());
			map.put("team_idx", team_idx);
			   	  
			int n = service.checkMemberExist(map); //내가 회원에 존재하는지 체크 
			if(n>0) { 
			         TeamMemberVO myinfo = service.teamMemberInfo(map); //존재한다면 나의 status 를 가져온다. 	    	 
			    	 req.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
			}
			
		    List<TeamMemberVO> memberList = service.teamMemberList(team_idx);
		    if(!loginuser.getUserid().equals(teamvo.getAdmin_userid())) {
		    	// 상태를 변경하려는 유저가 admin이 아니라면 막아준다.
		    	 msg = "권한이 없습니다."; 
		    	 String nav = "3";    
				 req.setAttribute("nav", nav);   
			     req.setAttribute("teamvo", teamvo);
				 req.setAttribute("team_idx", team_idx); 
		    	 req.setAttribute("msg", msg);  
		    	 req.setAttribute("memberList", memberList);
		    	
		    	 return "star/myTeamInfo.tiles"; 
		    }
		    
		    String team_visibility_status = req.getParameter("team_visibility_status");
		    System.out.println("확인용 team_visibility_status"+team_visibility_status);
		    
		    HashMap<String, String> map1 = new HashMap<String, String>();
		    map1.put("team_idx", team_idx);
		    map1.put("team_visibility_status", team_visibility_status); 
		    
		    int m = service.updateViewStatus(map1);
		    //team_visibility_status 업데이트
		    if(m == 0) {
				    msg = "업데이트 에러발생 ";  
				    String nav = "3";   
				    req.setAttribute("msg", msg);  
				    req.setAttribute("nav", nav);   
				    req.setAttribute("teamvo", teamvo);
				    req.setAttribute("team_idx", team_idx); 
			    	req.setAttribute("msg", msg);  
			    	req.setAttribute("memberList", memberList);
			    	
			    	return "star/myTeamInfo.tiles"; 
		    } 
		    
		    String nav = "3";    
		    req.setAttribute("nav", nav);   
		    req.setAttribute("teamvo", teamvo);
		    req.setAttribute("team_idx", team_idx);
		    req.setAttribute("memberList", memberList);
		    
		    return "star/myTeamInfo.tiles";   
	  }
	  
	  
	  // 팀정보에서 Member 버튼을 눌렀을때 호출되는 메소드 
	  @RequestMapping(value="/teamMember.action", method={RequestMethod.GET})
	  public String teamMember(HttpServletRequest req) {

		    HttpSession session = req.getSession(); 
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			if(loginuser == null) {
				String msg = "로그인이 필요한 메뉴입니다.";
				String loc = "/finalins/index.action";
				
				req.setAttribute("msg", msg);
				req.setAttribute("loc", loc);
				
				return "msg.notiles";
			}
			else{
			String team_idx = req.getParameter("team_idx");
			 
			TeamVO teamvo = service.teamInfoVO(team_idx);
			
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("login_userid", loginuser.getUserid());
			map.put("team_idx", team_idx);
			
			int memberCnt = service.countMember(map); // 나를 제외한 멤버가 몇명있는지 count해오는 메소드
			int secondAdminCnt = service.count2Admin(team_idx); // 부운영자 갯수를 가져오는 메소드 
			List<TeamMemberVO> memberList = service.teamMemberList(team_idx);
			
			System.out.println("확인용 부관리자 갯수 "+secondAdminCnt);
			
		   	int n = service.checkMemberExist(map); //내가 회원에 존재하는지 체크 
		    if(n>0) {
		        TeamMemberVO myinfo = service.teamMemberInfo(map); //존재한다면 나의 status 를 가져온다.
		        req.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
		    } 
		    
			req.setAttribute("secondAdminCnt", secondAdminCnt);
			req.setAttribute("memberCnt", memberCnt);
			req.setAttribute("team_idx", team_idx); 
			req.setAttribute("teamvo", teamvo); 
			req.setAttribute("memberList", memberList);
			
		    return "member.notiles";   
	     }
	  }
	  
	  
	  // 팀에 포함된 멤버들 JSON으로 가져오기 
	  @RequestMapping(value="/getMembers.action", method={RequestMethod.GET})
	  public String getMembers(HttpServletRequest req) {
 
			String str_team_idx = req.getParameter("team_idx");
			String start = req.getParameter("start");
			String len = req.getParameter("len");
			 
			 if(start == null || start.trim().isEmpty()) { // 초기값을 준다 
					start ="1";
			 }
			 if(len == null || len.trim().isEmpty()) {
					len = "10";
			 }
		     int team_idx = Integer.parseInt(str_team_idx);
		     
			 int startRno = Integer.parseInt(start);
				// 시작 행번호 ( 1, 4, 7, 10...)
				
			 int endRno = startRno + Integer.parseInt(len) - 1;
				// 끝 행번호 
				// !!!!  공식 !!!! 
				// 끝행번호 = 시작행번호 + 보여줄상품길이(len) - 1  
			 
			int totalCount = service.totalMemberCount(str_team_idx); // 나 자신을 포함한 팀원의 총 갯수를 가져오는 메소드
		 
			HashMap<String, Integer> map = new HashMap<String, Integer>();
			map.put("team_idx", team_idx);
			map.put("startRno", startRno);
			map.put("endRno", endRno);
			map.put("totalCount", totalCount);
			
			String str_jsonArray = service.getMembersJSON(map);
			// 팀에 포함된 멤버들 정보 가져오기
			   
			TeamVO teamvo = service.teamInfoVO(str_team_idx);// 팀의 admin정보를 가져온다 
			req.setAttribute("teamvo", teamvo);
					
			System.out.println("확인용 >> 팀멤버들을 가져오는 JSONArray "+str_jsonArray);
			req.setAttribute("str_jsonArray", str_jsonArray);
			
		    return "getmembersJSON.notiles";   
	  }
	   
	  
	  // 검색했을때 검색어에 해당되는 회원들의 정보를 가져옴(관리자가 아닌 회원이 자신의 팀내에서 멤버검색)
	  @RequestMapping(value="/myTmemberSearchJSON.action", method={RequestMethod.GET})
	  public String myTmemberSearchJSON(HttpServletRequest req) {
	  
			String searchMyTmember = req.getParameter("searchMyTmember"); 
			String team_idx = req.getParameter("team_idx");
			     
		    String str_jsonArray = null; 
			   
			     
		    if(!searchMyTmember.trim().isEmpty()) {  
				HashMap<String, String> map = new HashMap<String, String>();
		        map.put("searchMyTmember", searchMyTmember); 
				map.put("team_idx", team_idx);
				
				str_jsonArray = service.getSearchMyTMember(map); // 검색결과를 받아옴(페이징처리O)  
		    }//end of if
				  
		   System.out.println(">> 확인용 searchMyTeamMember 의 str_jsonArray : "+str_jsonArray);
				  
		   req.setAttribute("str_jsonArray", str_jsonArray);
				  
		   return "searchMyTmemberJSON.notiles";   
	   }
	  // 검색했을때 검색어에 해당되는 회원들의 정보를 가져옴(멤버가 없을시 관리자가 전체회원을 조회하는 검색창)
	  @RequestMapping(value="/wordSearchJSON.action", method={RequestMethod.GET})
	  public String wordSearchJSON(HttpServletRequest req) {
  
		     String searchWord = req.getParameter("searchWord"); 
		     String team_idx = req.getParameter("team_idx");
		     System.out.println("wordSearch team_idx확인용 :"+team_idx);
		      
		     String str_jsonArray = null; 
		  
		     HttpSession session = req.getSession();
		     MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		     
		     
			 if(!searchWord.trim().isEmpty()) {  
				HashMap<String, String> map = new HashMap<String, String>();
			    map.put("searchWord", searchWord); 
			    map.put("team_idx", team_idx);
			    map.put("login_userid", loginuser.getUserid());
				str_jsonArray = service.getSearchMember(map); // 검색결과를 받아옴(페이징처리O)  
			 }//end of if
			  
			 System.out.println(">> 확인용 SearchMember 의 str_jsonArray : "+str_jsonArray);
			  
			 req.setAttribute("str_jsonArray", str_jsonArray);
			  
		     return "wordSearchJSON.notiles";   
	  }
	   
	  // 검색했을때 검색어에 해당되는 회원들의 정보를 가져옴(멤버가 존재하고 그외의 회원들을 관리자가 조회하는 검색창)
	  @RequestMapping(value="/wordSearchJSON2.action", method={RequestMethod.GET})
	  public String wordSearchJSON2(HttpServletRequest req) {
	  
			  String searchWord = req.getParameter("searchWord"); 
			  String team_idx = req.getParameter("team_idx");
			  
		      String str_jsonArray = null; 
			  
			  HttpSession session = req.getSession();
			  MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			     
			     
			  if(!searchWord.trim().isEmpty()) {  
				 HashMap<String, String> map = new HashMap<String, String>();
				 map.put("searchWord", searchWord); 
				 map.put("login_userid", loginuser.getUserid());
				 map.put("team_idx", team_idx);
				 
				 str_jsonArray = service.getSearchExceptTeamMember(map); // 검색결과를 받아옴(페이징처리O)  
			  }//end of if
				  
			  System.out.println(">> 확인용 SearchMember 의 str_jsonArray : "+str_jsonArray);
				  
			  req.setAttribute("str_jsonArray", str_jsonArray);
				  
			  return "wordSearchJSON2.notiles";   
	  }
	  
	   // 팀을 탈퇴시켜주는 메소드 
	  @RequestMapping(value="/leaveTeam.action", method={RequestMethod.POST})
      public String requireLogin_leaveTeam(HttpServletRequest req, HttpServletResponse res) {
			   
			String userid = req.getParameter("userid");
			String team_idx = req.getParameter("team_idx");
			
			TeamVO teamvo = service.teamInfoVO(team_idx);

			String msg ="";
			String loc ="";
		  
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("userid", userid);
			map.put("team_idx", team_idx);
			
			int n = service.leaveTeam(map); 
			List<TeamMemberVO> memberList = service.teamMemberList(team_idx);
			if(n != 1) {

				   msg = "탈퇴가 실패하였습니다. ";
				   String nav = "2";
				  
				   req.setAttribute("msg", msg); 
				   req.setAttribute("nav", nav);
				   req.setAttribute("team_idx", team_idx);
				   req.setAttribute("teamvo", teamvo);
				   req.setAttribute("memberList", memberList);
				   
				   return "star/myTeamInfo.tiles";    
			}  
		    req.setAttribute("teamvo", teamvo); 
		    return "main/index.tiles";   
	     } 
	  
	  // 회원 권한을 관리자로 바꾸는 메소드 
	  @RequestMapping(value="/cngToAdmin.action", method={RequestMethod.POST})
	  public String Change_cngToAdmin(HttpServletRequest req, HttpServletResponse res) {
		  
		   String team_idx = req.getParameter("team_idx");
		   String userid = req.getParameter("userid");
		   String admin_userid = req.getParameter("admin_userid");
			   
		   HashMap<String, String> map = new HashMap<String, String>(); 
		   map.put("team_idx", team_idx);
		   map.put("userid", userid);
		 
		   int n = service.chgToAdmin(map); //운영자로 update해주는 메소드
		   
		   TeamVO teamvo = service.teamInfoVO(team_idx);
		   req.setAttribute("teamvo", teamvo);
		   List<TeamMemberVO> memberList = service.teamMemberList(team_idx);
		   
		   HttpSession session = req.getSession();
		   MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		   
		   HashMap<String, String> map1 = new HashMap<String, String>();
		   map1.put("login_userid", loginuser.getUserid());
		   map1.put("team_idx", team_idx);
			   	  
		   int m = service.checkMemberExist(map1); //내가 회원에 존재하는지 체크 
		   if(m > 0) { 
			    TeamMemberVO myinfo = service.teamMemberInfo(map1); //존재한다면 나의 status 를 가져온다. 	    	 
			    req.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
		   }
		   
		   if(n == 0) {
			   
			   String msg = "업데이트 에러 발생 ! ";    
			   String nav = "2";   
			    req.setAttribute("msg", msg);  
			    req.setAttribute("nav", nav);   
			    req.setAttribute("teamvo", teamvo);
			    req.setAttribute("team_idx", team_idx);  
			    req.setAttribute("memberList", memberList);
			    
		    	return "star/myTeamInfo.tiles"; 
				   
		   }
            
		   session.setAttribute("oldAdminStatus", "0");
		   req.setAttribute("userid", userid);
		    
		   String nav = "2"; 
		   req.setAttribute("nav", nav);
		   req.setAttribute("team_idx", team_idx);
		   req.setAttribute("teamvo", teamvo);
		   req.setAttribute("memberList", memberList);
		   
		   return "star/myTeamInfo.tiles";     
     } 
	  
	  
	  
	 // 회원 권한을 부관리자로 바꾸는 메소드 
	 @RequestMapping(value="/cngTo2ndAdmin.action", method={RequestMethod.POST})
	 public String cngTo2ndAdmin(HttpServletRequest req, HttpServletResponse res) {
	  
		   String team_idx = req.getParameter("team_idx");
		   String userid = req.getParameter("userid");
		   String admin_userid = req.getParameter("admin_userid"); 
		    
		   TeamVO teamvo = service.teamInfoVO(team_idx);
		   req.setAttribute("teamvo", teamvo);
		   
		   System.out.println("확인용 userid 와 admin_userid"+userid+""+admin_userid);
		   HashMap<String, String> map = new HashMap<String, String>(); 
		   map.put("team_idx", team_idx);
		   map.put("userid", userid);
		   
		   List<TeamMemberVO> memberList = service.teamMemberList(team_idx);
		   
		   HttpSession session = req.getSession();
		   MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		   
		   HashMap<String, String> map1 = new HashMap<String, String>();
		   map1.put("login_userid", loginuser.getUserid());
	       map1.put("team_idx", team_idx);
			   	  
		   int m = service.checkMemberExist(map1); //내가 회원에 존재하는지 체크 
		   if(m > 0) { 
			         TeamMemberVO myinfo = service.teamMemberInfo(map1); //존재한다면 나의 status 를 가져온다. 	    	 
			    	 req.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
	       }
		   int n = service.chgTo2ndAdmin(map); // 세컨어드민으로 변경시킴 
			   
		   if(n == 0) {
					   
					   String msg = "업데이트 에러 발생 ! ";  
					   String nav = "2";   
					    req.setAttribute("msg", msg);  
					    req.setAttribute("nav", nav);   
					    req.setAttribute("teamvo", teamvo);
					    req.setAttribute("team_idx", team_idx);  
					    req.setAttribute("memberList", memberList);
					    
				    	return "star/myTeamInfo.tiles"; 
		   }
		   
		   req.setAttribute("userid", userid); 
		   
		   String nav = "2"; 
		   req.setAttribute("nav", nav);
		   req.setAttribute("team_idx", team_idx);
		   req.setAttribute("teamvo", teamvo);
		   req.setAttribute("memberList", memberList);
		   
		   return "star/myTeamInfo.tiles";     
	 }
	 
	  // 회원 권한을  일반사용자로 바꾸는 메소드 
	  @RequestMapping(value="/cngToNormal.action", method={RequestMethod.POST})
	  public String cngToNormal(HttpServletRequest req, HttpServletResponse res) {
		  
		   String team_idx = req.getParameter("team_idx");
		   String userid = req.getParameter("userid");
		   String admin_userid = req.getParameter("admin_userid");
		    
		   TeamVO teamvo = service.teamInfoVO(team_idx);
		   req.setAttribute("teamvo", teamvo);
		   
		   List<TeamMemberVO> memberList = service.teamMemberList(team_idx);
		   req.setAttribute("memberList", memberList);
		   
		   HttpSession session = req.getSession();
		   MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		   
		   HashMap<String, String> map = new HashMap<String, String>();
		   map.put("login_userid", loginuser.getUserid());
	       map.put("team_idx", team_idx);
			   	  
		   int n = service.checkMemberExist(map); //내가 회원에 존재하는지 체크 
		   if(n > 0) { 
			         TeamMemberVO myinfo = service.teamMemberInfo(map); //존재한다면 나의 status 를 가져온다. 	    	 
			    	 req.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
	       } 
		   
		   HashMap<String, String> map1 = new HashMap<String, String>(); 
		   map1.put("team_idx", team_idx);
		   map1.put("userid", userid); 
			   
		   int m=0;
		  
		   m = service.chgToNormal(map1); 
		   if(m == 0) {
					   
					   String msg = "업데이트 에러 발생 ! ";  
					   String nav = "2";   
					    req.setAttribute("msg", msg);  
					    req.setAttribute("nav", nav);   
					    req.setAttribute("teamvo", teamvo);
					    req.setAttribute("team_idx", team_idx);   
					    
				    	return "star/myTeamInfo.tiles"; 
	
		   }  
		   
		   req.setAttribute("userid", userid); 
		   
		   String nav = "2"; 
		   req.setAttribute("nav", nav);
		   req.setAttribute("team_idx", team_idx);
		   req.setAttribute("teamvo", teamvo); 
		   
		   return "star/myTeamInfo.tiles";     
    } 
	  
	  // 검색한 멤버를 초대하는 메소드 
	  @RequestMapping(value="/inviteMember.action", method={RequestMethod.POST})
	  public String requireLogin_inviteMember(HttpServletRequest req, HttpServletResponse res) {
  
		 String inviteUser = req.getParameter("inviteUser");
		 String team_idx = req.getParameter("team_idx");
		 System.out.println("확인용 team_idx 와 inviteUser "+team_idx+""+inviteUser);
		 
		 HashMap<String, String> map = new HashMap<String, String>();
		 map.put("inviteUser", inviteUser);
		 map.put("team_idx", team_idx);
		 
		 List<TeamMemberVO> memberList = service.teamMemberList(team_idx);
		 req.setAttribute("memberList", memberList);
		   
		 HttpSession session = req.getSession();
		 MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		   
		 HashMap<String, String> map1 = new HashMap<String, String>();
		 map1.put("login_userid", loginuser.getUserid());
	     map1.put("team_idx", team_idx);
			   	  
		 int m = service.checkMemberExist(map1); //내가 회원에 존재하는지 체크 
		 if(m > 0) { 
			         TeamMemberVO myinfo = service.teamMemberInfo(map1); //존재한다면 나의 status 를 가져온다. 	    	 
			    	 req.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
	     }
		 
		 int n = service.inviteMember(map);
		 String msg = "";
		 String loc = "";
		 if(n>0) {
			  msg = "초대가 성공적으로 완료되었습니다."; 
		 }
		 else {
			  msg = "초대가 실패하였습니다."; 
		 } 
		 
		 String nav = "2";
		 req.setAttribute("msg", msg); 
		 req.setAttribute("nav", nav);
         req.setAttribute("team_idx", team_idx);
         
         TeamVO teamvo = service.teamInfoVO(team_idx);
		 req.setAttribute("teamvo", teamvo);   
		 
		 return "star/myTeamInfo.tiles"; 
	  }	  
	  

	  // 팀 가입을 요청한 회원들의 정보를 가져온다.
	  @RequestMapping(value="/joinMemberListJSON.action", method={RequestMethod.GET})
	  public String joinMemberListJSON(HttpServletRequest req) {
		  
		    String str_team_idx = req.getParameter("team_idx");
			String start = req.getParameter("start");
			String len = req.getParameter("len");

			System.out.println("확인용 idx"+str_team_idx);
			
			 if(start == null || start.trim().isEmpty()) { // 초기값을 준다 
					start ="1";
			 }
			 if(len == null || len.trim().isEmpty()) {
					len = "10";
			 }
		     int team_idx = Integer.parseInt(str_team_idx);
		     
			 int startRno = Integer.parseInt(start);
				// 시작 행번호 ( 1, 4, 7, 10...)
				
			 int endRno = startRno + Integer.parseInt(len) - 1;
				// 끝 행번호 
				// !!!!  공식 !!!! 
				// 끝행번호 = 시작행번호 + 보여줄상품길이(len) - 1   
			 int totalCount = service.joinMemberCount(str_team_idx); // 가입신청을 한 멤버의갯수를 가져온다 
			 
			 HashMap<String, Integer> map = new HashMap<String, Integer>(); 
			    map.put("team_idx", team_idx);
				map.put("startRno", startRno);
				map.put("endRno", endRno);
				map.put("totalCount", totalCount); 
				
			 String str_jsonArray = service.joinMemberList(map);
			 System.out.println("확인용 JsonArray" + str_jsonArray); 

			 System.out.println("확인용 startRno + endRno " +startRno+""+endRno);
			 req.setAttribute("str_jsonArray", str_jsonArray); 
			  
		     return "joinMemberListJSON.notiles";   
	  }	  
	   
	  // 팀가입 신청을 수락하는 메소드 
	  @RequestMapping(value="/acceptMember.action", method={RequestMethod.POST})
	  public String requireLogin__acceptMember(HttpServletRequest req, HttpServletResponse res) {
     
		 String userid = req.getParameter("userid");  
		 String team_idx = req.getParameter("team_idx");
		 
		 List<TeamMemberVO> memberList = service.teamMemberList(team_idx);
		 req.setAttribute("memberList", memberList);
		   
		 HttpSession session = req.getSession();
		 MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		   
		 HashMap<String, String> map1 = new HashMap<String, String>();
		 map1.put("login_userid", loginuser.getUserid());
	     map1.put("team_idx", team_idx);
			   	  
		 int m = service.checkMemberExist(map1); //내가 회원에 존재하는지 체크 
		 if(m > 0) { 
			   TeamMemberVO myinfo = service.teamMemberInfo(map1); //존재한다면 나의 status 를 가져온다. 	    	 
			   req.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
	     }
		 
		 HashMap<String, String> map = new HashMap<String, String>();
		 map.put("userid", userid);
		 map.put("team_idx", team_idx);
		  
		 int n = service.acceptMember(map);
		  
		 String msg ="";
		 String loc ="";
		 
		 if(n>0) {
			  msg = "승인이 완료되었습니다.";  
		      req.setAttribute("msg", msg);  
			  
		 }
		 else {
			  msg = "승인이 실패하였습니다."; 
			  req.setAttribute("msg", msg);
		 }  
		 TeamVO teamvo = service.teamInfoVO(team_idx); 
         
		 String nav = "3"; 
		 req.setAttribute("nav", nav);
		 req.setAttribute("team_idx", team_idx);
		 req.setAttribute("teamvo", teamvo); 
	   	 return "star/myTeamInfo.tiles";      
	  }	  
	  
	  // 팀 가입을 원한 멤버의 요청을 거절하는 메소드
	  @RequestMapping(value="/declineMember.action", method={RequestMethod.POST})
	  public String requireLogin_declineMember(HttpServletRequest req, HttpServletResponse res) {
     
		 String userid = req.getParameter("userid");  
		 String team_idx = req.getParameter("team_idx");
		 
		 List<TeamMemberVO> memberList = service.teamMemberList(team_idx);
		 req.setAttribute("memberList", memberList);
		   
		 HttpSession session = req.getSession();
		 MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		   
		 HashMap<String, String> map1 = new HashMap<String, String>();
		 map1.put("login_userid", loginuser.getUserid());
	     map1.put("team_idx", team_idx);
			   	  
		 int m = service.checkMemberExist(map1); //내가 회원에 존재하는지 체크 
		 if(m > 0) { 
			   TeamMemberVO myinfo = service.teamMemberInfo(map1); //존재한다면 나의 status 를 가져온다. 	    	 
			   req.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
	     }
		  
		 HashMap<String, String> map = new HashMap<String, String>();
		 map.put("userid", userid);
		 map.put("team_idx", team_idx);
		  
		 int n = service.declineMember(map);
		  
		 String msg ="";
		 String loc ="";
		 
		 if(n>0) {
			  msg = "거절이 완료되었습니다."; 
			   
		 }
		 else {
			  msg = "거절이 실패하였습니다."; 
		 }  
		 TeamVO teamvo = service.teamInfoVO(team_idx); 
		 String nav = "3";
		 req.setAttribute("msg", msg); 
	     req.setAttribute("nav", nav);
		 req.setAttribute("team_idx", team_idx);
		 req.setAttribute("teamvo", teamvo); 
	   	 return "star/myTeamInfo.tiles";    
	  }	  
	  
	  
	  // 파일을 추가하는 메소드 
	  @RequestMapping(value="/addFile.action", method={RequestMethod.POST})
	  public String requireLogin_addFile(HttpServletRequest req, HttpServletResponse res,TeamVO teamvo, MultipartHttpServletRequest filereq, HttpSession session) {
       
		System.out.println("teamvo 확인용 >> "+teamvo.getTeam_name());
		/////////// === 첨부파일이 있으면 파일업로드 하기 시작  === ////////
		if(!teamvo.getAttach().isEmpty()) {
		    // attach가 비어있지 않다면(즉, 첨부파일이 있는 경우라면)
			
			/*
			   ==> 1. 사용자가 보낸 파일을 WAS(톰캣)의 특정 경로 폴더에 저장해주어야 한다.
			    >>>> 파일이 업로드 되어질 특정 경로(폴더)지정해주기
			       우리는  WAS(톰캣)의 webapp/resources/files 라는 폴더로 지정해주겠다.
			*/
			
			// WAS(톰캣)의 webapp 의 절대경로를 알아와야 한다.
			String root = session.getServletContext().getRealPath("/"); 
			String path = root + "resources" + File.separator + "files";
			// File.separator ==> 운영체제가 Windows 이라면 "\" 이고,
			//                ==> 운영체제가 UNIX, Linux 이라면 "/" 이다.
			
			System.out.println(">>>>> 확인용 path ==> " + path);
			// >>>>> 확인용 path ==> C:\springworkspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\Board\resources\files 
			
			/*
			  ==> 2. 파일첨부를 위한 변수의 설정 및 값을 초기화한 후 파일올리기
			*/
			String newFileName = "";
			// WAS(톰캣) 디스크에 저장할 파일명.
			
			byte[] bytes = null;
			// 첨부파일을  WAS(톰캣) 디스크에 저장할때 사용되는 용도.
			
			long fileSize = 0;
			// 파일크기를 읽어오기 위한 용도.
			
			try {
				bytes = teamvo.getAttach().getBytes();
				// getBytes()는 첨부된 파일을 바이트단위로 파일을 다 읽어오는 것이다.
				
				newFileName = fileManager.doFileUpload(bytes, teamvo.getAttach().getOriginalFilename(), path);
				// 파일을 업로드 한후   현재시간+나노타임.확장자로 되어진 파일명을
				// 리턴받아 newFileName 으로 저장한다.
				// teamvo.getAttach().getOriginalFilename() 은 첨부된 파일의 실제 파일명(문자열)을 얻어오는 것이다. 
				
				teamvo.setServer_filename(newFileName);
				// newFileName 이 WAS(톰캣)에 저장될 파일명(20180628324234324324322324324.png)
				
				teamvo.setOrg_filename(teamvo.getAttach().getOriginalFilename());
				// teamvo.getAttach().getOriginalFilename() 은 진짜 파일명(강아지.png) 
				// 사용자가 파일을 다운로드할때 사용되어지는 파일명  
				
				fileSize = teamvo.getAttach().getSize();
				// teamvo.getAttach().getSize() 은 첨부한 파일의 크기를 말한다.
				// 타입은 long 이다.
				
				teamvo.setFile_size(String.valueOf(fileSize));
				
			} catch (Exception e) {
				
			}
			
		}
       ///////// === 첨부파일이 있으면 파일업로드 하기 끝  === ////////
		 
		int n = 0;
		
		if(!teamvo.getAttach().isEmpty()) {
			// 파일첨부가 있다라면
			n = service.updateTeamPic(teamvo);
		}   
		
		req.setAttribute("n", n);
		req.setAttribute("loc", "javascript:history.back(-1);");
		
		req.setAttribute("teamvo", teamvo);
		req.setAttribute("team_idx", teamvo.getTeam_idx()); 
		
		return "star/addEnd.tiles";
		
	  }	  
	  
	  // 부관리자가 2명이상일때 부관리자 목록을 가져오는 메소드
	  @RequestMapping(value="/SecondAdminListJSON", method={RequestMethod.GET})
	  public String SecondAdminListJSON(HttpServletRequest req) {
      
		 String team_idx = req.getParameter("team_idx");
		  
		 String str_jsonArray = service.myTeamMemberList(team_idx);
		 
		 req.setAttribute("str_jsonArray", str_jsonArray);
		 System.out.println("확인용 str_jsonArray" +str_jsonArray);
		 
		 return "secondAdminListJSON.notiles";
	  }	
	  
	 
	  // 부관리자가 여러명일시 한명을 선택해서 관리자로 임명해주는 메소드
	  @RequestMapping(value="/giveAdmin.action", method={RequestMethod.POST})
	  public String Change_giveAdmin(HttpServletRequest req, HttpServletResponse res) {
	      
		 String chguser =  req.getParameter("chguser");
		 String team_idx = req.getParameter("team_idx"); 
		 String status = req.getParameter("status");
		 System.out.println("status 확인용 :"+status);
		 
		 System.out.println("확인용  chguser "+chguser+"/ team_idx :"+team_idx+"status:"+status); 
		 
		 List<TeamMemberVO> memberList = service.teamMemberList(team_idx);
		 req.setAttribute("memberList", memberList);
		   
		 HttpSession session = req.getSession();
		 MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		   
		 HashMap<String, String> map1 = new HashMap<String, String>();
		 map1.put("login_userid", loginuser.getUserid());
	     map1.put("team_idx", team_idx);
			   	  
		 int m = service.checkMemberExist(map1); //내가 회원에 존재하는지 체크 
		 if(m > 0) { 
			   TeamMemberVO myinfo = service.teamMemberInfo(map1); //존재한다면 나의 status 를 가져온다. 	    	 
			   req.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
	     }
		 
		 
		 HashMap<String, String> map = new HashMap<String, String>();
		 map.put("userid", chguser);
		 map.put("team_idx", team_idx);
		 
		 int n = service.chgToAdmin(map); // 선택한 부관리자를 admin으로 update
		 
		 TeamVO teamvo = service.teamInfoVO(team_idx);
		 req.setAttribute("teamvo", teamvo);  
		 String msg = "";
		 if(n==0) { 
			 msg = "변경 실패"; 
		 }
		 else if(n == 1) {
			 msg = "변경 성공"; 
		 }  
		 session.setAttribute("oldAdminStatus", status);
		 
		 String nav = "2";
	     req.setAttribute("msg", msg); 
		 req.setAttribute("nav", nav);
		 req.setAttribute("team_idx", team_idx);
		 req.setAttribute("teamvo", teamvo);
		 
	   	 return "star/myTeamInfo.tiles";       
	 }	
	  
	  // 팀이미지를 가져오는 AJAX 
	  @RequestMapping(value="/getTeamImage.action", method={RequestMethod.GET})
	  public String getTeamImage(HttpServletRequest req) {
	     
		 String team_idx = req.getParameter("team_idx");
		 
		 String str_jsonObj = service.getInfoTeam(team_idx);
		 req.setAttribute("str_jsonObj", str_jsonObj);
		 System.out.println("확인용이미지 AJAX "+str_jsonObj);
		 
		 return "getTeamImage.notiles";     
	 }	
	  
	  
	  // Board버튼을 눌렀을때 호출되는 메소드
	  @RequestMapping(value="/teamBoard.action", method={RequestMethod.GET})
	  public String teamBoard(HttpServletRequest req) {
		  
		 HttpSession session =  req.getSession();
		 MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		 
		 String team_idx = req.getParameter("team_idx");
		 
		 if(loginuser == null) {
				String msg = "로그인이 필요한 메뉴입니다.";
				String loc = "/finalins/index.action";
				
				req.setAttribute("msg", msg);
				req.setAttribute("loc", loc);
				
				return "msg.notiles";
		 }
		 else {
			  List<TeamMemberVO> memberList = service.teamMemberList(team_idx);
			  
			  HashMap<String, String> map = new HashMap<String, String>();
		   	  map.put("login_userid", loginuser.getUserid());
		   	  map.put("team_idx", team_idx);
		   	  
		   	  int n = service.checkMemberExist(map); //내가 회원에 존재하는지 체크 
		      if(n>0) { 
		    	 TeamMemberVO myinfo = service.teamMemberInfo(map); //존재한다면 나의 status 를 가져온다. 	    	 
		    	 req.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
		      }
		     
			  req.setAttribute("memberList", memberList);
			  req.setAttribute("team_idx", team_idx);
			 
			  return "board.notiles";     
		}
	 }	
	  
	  
	  // 팀 해체버튼을 눌렀을때 호출되는 메소드
	  @RequestMapping(value="/breakTeam.action", method={RequestMethod.POST})
	  public String requireLogin_breakTeam(HttpServletRequest req, HttpServletResponse res) {
			
		  String team_idx = req.getParameter("team_idx");
		  
		  int m = service.breakTeam(team_idx); // 팀 delete status 를 update해주는 메소드
		  
		  
		  String msg = "";
		  if(m == 0) {
			   msg = "팀이 해체가 실패하였습니다."; 
			   String nav = "3";
		       req.setAttribute("msg", msg); 
		   	   req.setAttribute("nav", nav);
			   req.setAttribute("team_idx", team_idx);
			   
			   TeamVO teamvo = (TeamVO)service.teamInfoVO(team_idx);
			   req.setAttribute("teamvo", teamvo);
				
			   List<TeamMemberVO> memberList = service.teamMemberList(team_idx);
			   req.setAttribute("memberList", memberList);
				   
			   HttpSession session = req.getSession();
		       MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
				   
			   HashMap<String, String> map1 = new HashMap<String, String>();
		       map1.put("login_userid", loginuser.getUserid());
			   map1.put("team_idx", team_idx);
					   	  
			   int n = service.checkMemberExist(map1); //내가 회원에 존재하는지 체크 
			   if(n > 0) { 
					  TeamMemberVO myinfo = service.teamMemberInfo(map1); //존재한다면 나의 status 를 가져온다. 	    	 
					  req.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
			   }
			   return "star/myTeamInfo.tiles";  
		  } 
		  
		  HttpSession session = req.getSession();
		  MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		  
		  int n = service.getcountTeam(loginuser.getUserid()); // 가입된 팀 갯수알아오기  
		  req.setAttribute("countTeam", n);
		   
		  return "/main.tiles2";        
  	  }
	  
	  
	 // 팀에서 생성한 프로젝트를 가져오는 JSON 
	 @RequestMapping(value="/projectDisplayJSON.action", method={RequestMethod.GET})
	 public String projectDisplay(HttpServletRequest req) {
			  
			String start = req.getParameter("start"); // 맨 처음에는 초계치 1이 들어온다. 
			String len = req.getParameter("len"); // 3
			String team_idx = req.getParameter("team_idx");  
			
			if(start == null || start.trim().isEmpty()) { // 초기값을 준다 
				start ="1";
			}
			if(len == null || len.trim().isEmpty()) {
				len = "3";
			} 
			
			System.out.println(" ===> 확인용 projectDisplayJSON  start, len, team_idx =  start"+start+" len "+len+" team_idx "+team_idx);
			 
			
			int startRno = Integer.parseInt(start);
			// 시작 행번호 ( 1, 4, 7, 10...)
			
			int endRno = startRno + Integer.parseInt(len) - 1;
			// 끝 행번호 
			// !!!!  공식 !!!! 
			// 끝행번호 = 시작행번호 + 보여줄상품길이(len) - 1 
			// 1+3-1 = 3, 6, 9, ... 
			HttpSession session = req.getSession();
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			
			HashMap<String, String> map1 = new HashMap<String, String>();
			map1.put("team_idx", team_idx);
			map1.put("login_userid", loginuser.getUserid());
			
			int totalCount = service.projectCnt(map1); // 내가 포함된 팀 프로젝트 총 갯수 가져오기 
			String str_totalCount = String.valueOf(totalCount);
			String str_startRno = String.valueOf(startRno);
			String str_endRno = String.valueOf(endRno);
			
			HashMap<String, String> map2 = new HashMap<String, String>();
			map2.put("team_idx", team_idx);
			map2.put("login_userid", loginuser.getUserid());
			map2.put("totalCount", str_totalCount);
			map2.put("startRno", str_startRno);
			map2.put("endRno", str_endRno);
			
			String str_jsonArray = service.getProjectList(map2);
			System.out.println("확인용 jsonArray"+str_jsonArray);
	        req.setAttribute("str_jsonArray", str_jsonArray);	 
	        
		    return "projectDisplayJSON.notiles";
	 }
	  
	 // 회원이 팀가입을 요청할때
	 @RequestMapping(value="/wantJoinTeam.action", method={RequestMethod.POST})
	 public String requireLogin_wantJoinTeam(HttpServletRequest req, HttpServletResponse res) {
			  
			HttpSession session = req.getSession();
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			
			String team_idx = req.getParameter("team_idx");
			 
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("team_idx", team_idx);
			map.put("login_userid", loginuser.getUserid());
			
			String msg = "";
			String loc = "";
			
			int m = service.checkMemberExist(map);//멤버테이블에 존재하는지 확인 
			if(m>0) { // 팀내에 존재한다면(이미 신청했다면)
				msg = "You already send request.";
				loc = "javascript:history.back(-2);";
				 
			}
			else {
				int n = service.wantJoinTeam(map);   
				
				if(n>0) {
					msg = "Success!";
					loc = "javascript:history.back(-2);"; 
				}
				else if(n==0) {
					msg = "The request is failed. Please try again";
					loc = "javascript:history.back(-2);";
				} 
			}

			req.setAttribute("loc", loc);
			req.setAttribute("msg", msg);
		    return "msg.notiles";
		    
	 }
	  
	// 팀에서 생성한 프로젝트(=public인것)를 가져오는 JSON -- 팀에 포함이안된 회원이 팀페이지에 들어왔을때 
	 @RequestMapping(value="/projectPublicJSON.action", method={RequestMethod.GET})
     public String projectPublicJSON(HttpServletRequest req) {
				  
		 String start = req.getParameter("start"); // 맨 처음에는 초계치 1이 들어온다. 
		 String len = req.getParameter("len"); // 3
		 String team_idx = req.getParameter("team_idx");  
				
		 if(start == null || start.trim().isEmpty()) { // 초기값을 준다 
			  start ="1";
		 }
		 if(len == null || len.trim().isEmpty()) {
			  len = "3";
		 } 
				
		 System.out.println(" ===> 확인용 projectPublicJSON.action => start, len, team_idx =  start"+start+" len "+len+" team_idx "+team_idx);
				  
		 int startRno = Integer.parseInt(start);
		 // 시작 행번호 ( 1, 4, 7, 10...)
				
		 int endRno = startRno + Integer.parseInt(len) - 1;
		 // 끝 행번호 
		 // !!!!  공식 !!!! 
		 // 끝행번호 = 시작행번호 + 보여줄상품길이(len) - 1 
		 // 1+3-1 = 3, 6, 9, ... 
		 HttpSession session = req.getSession();
		 MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
				  
		 int totalCount = service.publicProjectCnt(team_idx); // public인 프로젝트 갯수알아오기 
		 String str_totalCount = String.valueOf(totalCount);
		 String str_startRno = String.valueOf(startRno);
		 String str_endRno = String.valueOf(endRno);
				
		 HashMap<String, String> map2 = new HashMap<String, String>();
		 map2.put("team_idx", team_idx); 
		 map2.put("totalCount", str_totalCount);
		 map2.put("startRno", str_startRno);
		 map2.put("endRno", str_endRno);
				
		 String str_jsonArray = service.getPublicProjectList(map2); // public인 프로젝트를 가져온다.
		 System.out.println("public project List 확인용 jsonArray"+str_jsonArray);
		 req.setAttribute("str_jsonArray", str_jsonArray);	 
		        
		 return "projectPublicJSON.notiles";
	 }
}//end of class
