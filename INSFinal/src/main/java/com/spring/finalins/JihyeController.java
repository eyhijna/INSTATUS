package com.spring.finalins;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
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
import com.spring.finalins.service.InterJihyeService;
import com.spring.finalins.service.JihyeService;
import com.spring.finalins.model.TeamVO;

@Controller
public class JihyeController {
	
	// ======  의존객체 주입하기(DI: Dependency Injection) ========
	@Autowired
	private InterJihyeService service;


	// ====== #132. 파일업로드 및 다운로드를 해주는 FileManager 클래스 의존객체 주입하기(DI: Dependency Injection) ========
	/*
	   이전에 파일 업로드는 cos.jar를 사용하였지만 
	   이제부터 FileManager.java를 사용할 것이다.
	  smart editor에서 사용할 것이다.
	 */
	@Autowired
	public FileManager fileManager;
	
	
  // my-1. 로그인을 해야만 마이페이지로 이동(requiredLogin)
	@RequestMapping(value="/mypage.action", method= {RequestMethod.GET})
	public String requireLogin_mypage(HttpServletRequest req, HttpServletResponse res){
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		String userid = null;

		if (loginuser != null) {
			userid = loginuser.getUserid();
		}
		
		if(!userid.equalsIgnoreCase("admin")) {
		
	// ============ 내가 속한 팀목록 보여주기  ///////////////////////////////////////////////////////////////////////////////////////// 
	    List<TeamVO> teamList = service.getTeamList(userid);
	    
	///////////////////////////////////////////////////////////////////////////////////////////////////   
           List<HashMap<String,String>> myRecordList = null;
		
		
		HashMap<String, String> map = new HashMap<String, String>();
	    
	 // ===== #110. 페이징 처리 하기 =====
		String str_currentShowPageNo = req.getParameter("currentShowPageNo");

		int totalCount = 0; // 총 게시물 건 수 알기
		int sizePerPage = 5; // 한 페이지당 보여줄 게시물 건수
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기값은 1페이지로 설정함.
		int totalPage = 0; // 총페이지수(웹브라우저상에 보여줄 총 페이지 갯수)

		int startRno = 0;// 시작행 번호
		int endRno = 0;// 끝행 번호

		int blockSize = 1;// "페이지바" 에 보여줄 페이지의 갯수

		/*
		 * ==== 총 페이지 수 구하기 ==== 검색 조건이 없을 때의 총 페이지 수와 검색 조건이 있을 때의 총 페이지 수를 구해야 한다.
		 * 
		 * 검색 조건이 없을 때의 총 페이지 수 ==> colname과 search가 null 인 것이고, 검색 조건이 있을 때의 총 페이지 수
		 * ==> colname과 search가 null 이 아닌 것이다.
		 */
		map.put("userid", userid);
		
		totalCount = service.getRecordTotalCount(map); // 검색어가 없는 총 게시물 건수
		
		System.out.println("총 게시물 수"+totalCount);

		// 구해온 totalCount로 totalPage를 만든다.
		// 정수 / 정수 (정수 나누기 정수는 실수) ==> 형번환 해준다.
		totalPage = (int)Math.ceil((double)totalCount / sizePerPage);
		
		System.out.println("총 페이지 수"+totalPage);


		// 맨 처음에 목록보기를 눌렀을 때
		// 뷰단에서 자바로 넘어올 때 get방식이라서 장난치는 것을 다 막아줘야 한다. get방식의 주소창은 다 드러나기 때문에 유효성 검사
		if (str_currentShowPageNo == null) {
			// 게시판 초기 화면에 보여지는 것은
			// req.getParameter("currentShowPageNo"); 값이 없으므로
			// str_currentShowPageNo 은 null 이 된다.

			currentShowPageNo = 1;
		} else { // null이 아니라면 int로 바꿔주는데 존재하지 않는 음수 페이지거나 토탈페이지보다 더 많으면 currentShowPageNo = 1; 로
					// 설정하겠다.
			try { // 숫자만 Integer로 바꿀 수 있고 똘똘이와 같은 건 안되기 때문에 numberformat exception이 발생
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);

				if (currentShowPageNo < 1 || currentShowPageNo > totalPage) { // ==> 존재하지 않는 페이지가 있다면
					currentShowPageNo = 1;
				}

			} catch (NumberFormatException e) {
				currentShowPageNo = 1;
			}
		}

		// **** 가져올 게시글의 범위를 구한다.(공식임!!) ****
		/*
		 * // 1페이지당 5개씩 보여준다고 가정한다면 currentShowPageNo startRno endRno
		 * ------------------------------------------------ 1 page ==> 1 5 2 page ==> 6
		 * 10 3 page ==> 11 15 4 page ==> 16 20 5 page ==> 21 25 6 page ==> 26 30 7 page
		 * ==> 31 35
		 */

		// ****** 공식!공식!공식! *******
		startRno = (currentShowPageNo - 1) * sizePerPage + 1;
		endRno = startRno + sizePerPage - 1;

		// totalCount 는 검색어의 유무에 따라 게시물의 총 갯수가 달라진다
		// ===== #111. 페이징 처리를 위한 startRno, endRno 를 map에 추가하여
		// 파라미터로 넘겨서 select 되도록 한다.
		// --> totalCount 구하기(DB에서 데이터 갯수 알아오기)

		// 처음에 검색도 안했을때 현재 페이지는 1이고 페이지에서 시작값은 1이고 마지막 값은 5이다. 그것을 map에 넣어준다.

		map.put("startRno", String.valueOf(startRno));
		map.put("endRno", String.valueOf(endRno));
		
		map.put("userid", userid);
		
		myRecordList = service.getMyRecordList(map);

		// =====  페이지바 만들기(먼저, 페이지바에 나타낼 총 페이지 갯수(totalPage) 구해야 한다.) =====
		String pagebar = "<ul>";
		pagebar += MyUtil.getSearchPageBar("mypage.action", currentShowPageNo, sizePerPage, totalPage, blockSize,
				map.get("colname"), map.get("search"), null); // period는 없으니까 null 을 넣어준다.
		pagebar += "</ul>";

		req.setAttribute("pagebar", pagebar);
		req.setAttribute("myRecordList", myRecordList);
///////////////////////////////////////////////////////////////////////
		req.setAttribute("teamList", teamList);
	
		}
		else if(userid.equalsIgnoreCase("admin")){
			/*String msg ="접근이 불가합니다.";
			String loc ="index.action";
			
			req.setAttribute("msg", msg);
			req.setAttribute("loc", loc);*/
			
			return "jihye/adminChart.tiles";
		}
		
		return "jihye/mypage.tiles";
	}
	
	
	// 내가 활동한 기록 더보기 버튼 만들기
/*	@RequestMapping(value="myRecordListJSON.action", method = {RequestMethod.POST})
	public String requireLogin_myRecordListJSON(HttpServletRequest req, HttpServletResponse res) {
		
		String start = req.getParameter("start");
		String length = req.getParameter("length");
		
		if(start == null || start.trim().isEmpty()) {
			start = "1";
		}
		if(length == null || length.trim().isEmpty()) {
			length = "2";
		}
		
					
		
     	int startRno = Integer.parseInt(start);
		int endRno = Integer.parseInt(start) + Integer.parseInt(length) - 1;
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		String userid = null;

		if (loginuser != null) {
			userid = loginuser.getUserid();
		}
		
		
		
		HashMap<String,String> btnmoreMap = new HashMap<String,String>();
		btnmoreMap.put("userid", userid);
		btnmoreMap.put("startRno",  String.valueOf(startRno));
		btnmoreMap.put("endRno", String.valueOf(endRno));
		
		List<HashMap<String,String>> myRecordList = service.getMyRecordList(btnmoreMap);
		
		 JSONArray jsonArr = new JSONArray();  //아무것도 안 넣으면 []
         
         for(HashMap<String, String> map : myRecordList) {
            JSONObject jsonObj = new JSONObject();

            //밑에 것은 json에 대한 키값이다.
            jsonObj.put("project_Name", map.get("PROJECT_NAME"));  // map.get("키값")은 xml에 있는 키값이다!!! 차트용
            jsonObj.put("list_name", map.get("LIST_NAME"));  // 남/녀의 실제 인원수도 구할 것이다. 나중에 테이블 하나 만들려고 한 것이다.
            jsonObj.put("card_title", map.get("CARD_TITLE")); // 남/녀의 비율 
            jsonObj.put("record_userid", map.get("RECORD_USERID")); 
            jsonObj.put("project_record_time", map.get("PROJECT_RECORD_TIME")); 
            jsonObj.put("record_dml_status", map.get("RECORD_DML_STATUS")); 
      
            jsonArr.put(jsonObj);
         }

         String str_jsonArr = jsonArr.toString();
         
         System.out.println("str_jsonArr"+ str_jsonArr);
         
         req.setAttribute("str_jsonArr", str_jsonArr);
       //  req.setAttribute("myRecordList",myRecordList);
		
		
		return "jihye/myRecordListJSON";
	}*/
	
	
	
	
	
	
	// my-2. 개인정보 수정을 위한 (로그인한) 유저의 정보를 불러오기
	@RequestMapping(value="/editMember.action", method= {RequestMethod.GET})
	public String requireLogin_edit(HttpServletRequest req, HttpServletResponse res) {

		// 1. 기본정보를 불러 온다. 패스워드 빼고는 전부 기본정보가 입력이 되어야 한다. 
	    // --> 그러기 위해선 로그인한 멤버의 정보를 우선적으로 불러오고 그것을 edit.jsp로 보내준다.
		// AOP 처리한 requriedLogin 붙여주기(로그인 확인여부)
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		String userid = null;

		if (loginuser != null) {
			userid = loginuser.getUserid();
		}
		
		MemberVO membervo = service.getMyProfile(userid);
		
		String goBackURL = "mypage.action";
		
		// 회원정보 수정시 생년월일만 글자를 잘라서 보내야 웹브라우저에 값이 나타난다.
		String birthday = membervo.getBirthday().substring(0, 10); 
		req.setAttribute("birthday", birthday);
		
		req.setAttribute("membervo", membervo);
		req.setAttribute("goBackURL", goBackURL);
		
		return "jihye/editMember.tiles";
	}
	
	
	
	// my-3. 회원정보수정 업데이트 하기
    @RequestMapping(value="/memberEditEnd.action", method= {RequestMethod.POST})
	public String requireLogin_memberEditEnd(HttpServletRequest req, HttpServletResponse res) {
			
		// 1.불러온 정보를 업데이트(update) 해주기!! 변경한 회원정보만 update 해주면 되지만 
    	// loginuser에서 변경되지 않은 값도 동시에 보내줘야 하기때문에 변경되지 않은 정보도 보내줌.(update는 안함)
    	 String userid = req.getParameter("userid");
    	 String name = req.getParameter("name");
    	 String pwd = req.getParameter("pwd");
    	 String nickname = req.getParameter("nickname");
    	 String email = req.getParameter("email");
		 String tel1 = req.getParameter("tel1");
		 String tel2 = req.getParameter("tel2");
		 String tel3 = req.getParameter("tel3");
		 String job = req.getParameter("job");
		 
		 MemberVO membervo = new MemberVO();
		    membervo.setUserid(userid);
		    membervo.setName(name);
			membervo.setPwd(pwd);
			membervo.setNickname(nickname);
			membervo.setEmail(email);
			membervo.setTel1(tel1);
			membervo.setTel2(tel2);
			membervo.setTel3(tel3);
			membervo.setJob(job);
			
		int n = service.updateMyProfile(membervo);
		
		String msg = null;
		String loc = null;
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");	
		
		if(n==1) {// 회원정소 수정이 성공했다면 n은 1이다.
			
		// top.jsp에서 개인정보도 변경 시켜줘야 하기 때문에 loginuser에 속성값을 집어 넣어주었다.
	    // (top.jsp는 edit.action등 tap으로 링크되는 페이지에 include 되어있다.)
		loginuser.setNickname(nickname);
		loginuser.setPwd(pwd);
		loginuser.setTel1(tel1);
		loginuser.setTel2(tel2);
		loginuser.setTel3(tel3);
		loginuser.setJob(job);
						
		req.setAttribute("membervo", membervo);
		
		req.setAttribute("loginuser", loginuser);
		
		msg = "회원정보를 성공적으로 수정하였습니다,";
		loc = "mypage.action";
		
		}
		else {
			msg = "회원정보수정에 실패하였습니다.";
			loc = "mypage.action";
		}		
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
			
		// return 값에 바로 mypage.tiles를 주면 페이지 이동은 되지만 url에 memberEditEnd.action이 남기 때문에 
		// msg.notiles로 가서 msg를 띄우고 mypage.action 경로로 가는 것을 설정했따. 
		return "msg.notiles";
		 
	}
    
    
    
    // 회원정보 수정 페이지에서 회원 탈퇴를 누를 수 있다. 
    // 회원 탈퇴 버튼을 누르면 ins_member의 leave_status 값을 0에서 1로 바꾸어준다. 
    // 회원 탈퇴시 회원정보를 삭제하면 그 회원이 작성했던 모든 작업들이 삭제되기 때문에 그러면 오류가 발생하여 업데이트로 변경하였다. 
    
    // my_4. 회원탈퇴(leave_status 업데이트 하기)
    @RequestMapping(value="/memberDeleteAccount.action", method= {RequestMethod.POST})
   	public String requiredLogin_memberDelete(HttpServletRequest req, HttpServletResponse res) {
    	
    	HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");	
	
		String userid = null;

		if (loginuser != null) {
			userid = loginuser.getUserid();
		}
		
		int n = service.deleteMyAccount(userid);
		
		String msg = null;
		String loc = null;

		  if(n==1) {
			
		   // 세션에 저장해 놓은 모든 값을 없앤다.	
		   session.invalidate();
			  
			msg = "회원탈퇴 하셨습니다.";
			loc = "index.action";
		  }
		  else {
				msg = "회원탈퇴에 실패하셨습니다..";
				loc = "mypage.action";
		   }

		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
	
		return "msg.notiles";

    }

    
	   @RequestMapping(value="/test.action", method= {RequestMethod.POST})
	   public String requireLogin_test(MultipartHttpServletRequest req, HttpServletResponse res,MemberVO membervo) {  
		   
		   
		   String goBackURL = req.getParameter("goBackURL");

	        System.out.println("오리지널파일명  :"+ membervo.getAttach().getOriginalFilename());
	        System.out.println("파일용량  :"+membervo.getAttach().getSize());
	        try {
	         System.out.println("실제파일객체  :"+membervo.getAttach().getBytes().toString());
	        } catch (IOException e1) {
	         // TODO Auto-generated catch block
	         e1.printStackTrace();
	        }
	         
  
	        HttpSession session = req.getSession();
	        MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");   
	        String userid = loginuser.getUserid();
	        
	        
	      if(!membervo.getAttach().isEmpty()) {   
	   
	          String root = session.getServletContext().getRealPath("/");
	          String path = root + "resources" + File.separator + "files"; //File.separator => 운영체제가 Windows라면 "\" 이고 UNIX, Linux라면 "/" 이다.
	             
	            System.out.println("확인용 path: " + path);
	         // 확인용 path: C:\finalINS\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\INSFinal\resources\files
	          
	          //2. 파일첨부를 위한 변수의 설정 및 값을 초기화한 후 파일올리기
	           String newFileName = ""; //WAS 디스크에 저장될 파일명
	           byte[] bytes = null; //첨부파일을 WAS 디스크에 저장할 때 사용되는 용도. 실제파일이 저장된다.
	           long fileSize = 0; //파일크기를 읽어오기 위한 용도
	     
	          try {
	                bytes = membervo.getAttach().getBytes();   
	                //getBytes()는 첨부된 파일을 바이트단위로 읽어오는 것이다.
	                
	           //    newFileName = fileManager.doFileUpload(bytes, membervo.getAttach().getOriginalFilename(), path);
	               
	               newFileName = fileManager.doFileUpload(bytes, membervo.getAttach().getOriginalFilename(), path);
	               
	                  // 파일을 업로드 한 후 현재시간+ 나노타임. 확장자로 되어진 파일명을
	                  //   리턴받아 nameFileName으로 저장한다.
	                  //   boardvo.getAttach().getOriginalFilename()은 첨부된 파일의 실제 파일명(문자열)을 얻어오는것이다.
	                  //  System.out.println("newFileName : "+newFileName); 
	                 
	        
	                  membervo.setServer_filename(newFileName);
	                  //newFileName 이 WAS(톰캣)에 저장될 파일명(201806283213123213213213.png)
	                  //System.out.println("serverfilename"+membervo.getServer_filename());
	                  
	                  
	                  membervo.setOrg_filename(membervo.getAttach().getOriginalFilename());
	                  // boardvo.getAttach().getOriginalFilename() 은 진짜 파일명 (강아지.png)
	                  // 사용자가 파일을 다운로드 할때 사용되어지는 파일명
	                 // System.out.println("Org_filename>>>>>"+membervo.getOrg_filename());
	                  
	          
	                   fileSize = membervo.getAttach().getSize();
	                   // 첨부한 파일의 크기를 알아온다.
	                   // 타입은 long이다.   
	                   //System.out.println("fileSize>>>>>"+fileSize);
	                   
	                  membervo.getServer_filename();
	                        
	                   if(!newFileName.isEmpty()) {
	                 
	                 String org_filename = membervo.getOrg_filename();
	                 String server_filename = newFileName;
	                 String file_size = String.valueOf(fileSize);
	                 
	            //     System.out.println("server_filename"+server_filename);

	                  HashMap<String,String> map = new HashMap<String,String>();
	                  
	                    map.put("server_filename", server_filename);
	                    map.put("org_filename", org_filename);
	                    map.put("file_size", file_size);
	                    map.put("userid",userid);

	                 int n2 = service.updateProfileImg(map);
	                 
	                 loginuser.setServer_filename(server_filename);
	                 loginuser.setOrg_filename(org_filename);
	                 req.setAttribute("loginuser", loginuser);
	                 req.setAttribute("membervo", membervo);
	                    
	                     System.out.println(">>>>>>>>>>>>>>>"+loginuser.getServer_filename());
	                 
	                   }
	                  
	             } catch (Exception e) {
	                      e.printStackTrace();
	              }
	          
	      } else {   
	    	  
	    	 String gobackURL = (String) session.getAttribute("gobackURL"); 
	    	 String msg = "첨부된 파일이 없습니다.";
	    	 String loc = gobackURL;
	    	 
	    	 req.setAttribute("msg", msg);
	    	 req.setAttribute("loc", loc);
	         return "msg.notiles";
	      }
	      
	      
	         String url = req.getParameter("url");

			System.out.println(">> 확인용 현재 페이지 URL : "+url);
			
			session.setAttribute("gobackURL", url); // 세션에 url 정보를 저장시켜둔다
	      
	        String gobackURL = (String) session.getAttribute("gobackURL");
	        System.out.println("gobackurl"+gobackURL);
	        String loc = gobackURL;
	        String msg = "프로필 사진을 업데이트하셧습니다.";
	        
		//	req.setAttribute("gobackURL", gobackURL);
	        req.setAttribute("msg", msg);
			req.setAttribute("loc", loc);
		//	session.removeAttribute("gobakcURL");
	      

	      return "msg.notiles";

	   }
	   
	   
	   // setting page 
	   @RequestMapping(value="/mySetting.action", method= {RequestMethod.GET})
	   public String requireLogin_setting(HttpServletRequest req, HttpServletResponse res) {
		return "jihye/mySetting.tiles";  
		   
		   
	   }
	   
	   // setting page 
	   @RequestMapping(value="/mySettingJSON.action", method= {RequestMethod.GET})
	   public String requireLogin_settingJSON(HttpServletRequest req, HttpServletResponse res) {  
		   
		   
		   HttpSession session = req.getSession();
	       MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
	       
	       String userid = null;

			if (loginuser != null) {
				userid = loginuser.getUserid();
			}
	
		   // ==== 팀에서 초대할 경우 초대 수락/거절 버튼 만들기
		   // 1) 우선 나를 초대한 팀명 불러오기
			List<HashMap<String, String>> teamName = service.getInviteTeamName(userid);
			
			JSONArray jsonArr = new JSONArray();  //아무것도 안 넣으면 []
	          
	          for(HashMap<String, String> map2 : teamName) {
	             JSONObject jsonObj = new JSONObject();

	             //밑에 것은 json에 대한 키값이다.
	             jsonObj.put("FK_TEAM_IDX", map2.get("FK_TEAM_IDX")); 
	             jsonObj.put("TEAM_NAME", map2.get("TEAM_NAME")); 
	             jsonObj.put("TEAM_USERID", map2.get("TEAM_USERID"));
	             jsonObj.put("TEAM_MEMBER_ADMIN_STATUS", map2.get("TEAM_MEMBER_ADMIN_STATUS"));

	             
	             jsonArr.put(jsonObj);
	          }

	          String str_jsonArr = jsonArr.toString();
	          
	       //   System.out.println("str+jsonArr"+ str_jsonArr);
	          
	          req.setAttribute("str_jsonArr", str_jsonArr);
	          
	          
			
			
			
			
/*		for(int i=0; i<teamName.size(); i++) {	
		 
		   System.out.println("fk_team_idx"+teamName.get(i).get("fk_team_idx"));
		
		}
		   
		   req.setAttribute("teamName", teamName);*/
		   
	      return "jihye/mySettingJSON";
	   }
	   
	   
	   // 2) 팀초대 승인할 경우 / 팀 초대 거절할 경우.
	   @RequestMapping(value="/approveTeamJSON.action", method= {RequestMethod.GET})
	   public String requireLogin_approveTeam(HttpServletRequest req, HttpServletResponse res) {  
		   
		   String approve =req.getParameter("approve");
		   String deny = req.getParameter("deny");
		   String fk_team_idx = req.getParameter("fk_team_idx");
		   
		   System.out.println("approve>>>"+approve);
		   System.out.println("deny>>>"+deny);
		   
		   HttpSession session = req.getSession();
	       MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
	       
	       String userid = null;

			if (loginuser != null) {
				userid = loginuser.getUserid();
			}
			
		 HashMap<String,String> map = new HashMap<String,String>();	
		 map.put("userid", userid);
		 map.put("fk_team_idx", fk_team_idx);
			
		 
		 System.out.println("fk_team_idx"+fk_team_idx);
			
		 int n =0;
		 
          if(!userid.equalsIgnoreCase("admin")) {
					
			if(approve != null && deny == null) {
			n = service.approveTeam(map);
				
			}
			if(approve == null && deny != null){
			 n = service.denyTeam(map);
			}
	          
          } else if(userid.equalsIgnoreCase("admin")) {
          	String msg ="접근이 불가합니다.";
			String loc ="index.action";
			
			req.setAttribute("msg", msg);
			req.setAttribute("loc", loc);
			
			return "msg.notiles";
			
		}	
			
			if(n >0) {
				
				
				 List<HashMap<String, String>> teamName = service.getInviteTeamName(userid);
		          
		          JSONArray jsonArr = new JSONArray();  //아무것도 안 넣으면 []
		          
		          for(HashMap<String, String> map2 : teamName) {
		             JSONObject jsonObj = new JSONObject();

		             //밑에 것은 json에 대한 키값이다.
		             jsonObj.put("FK_TEAM_IDX", map2.get("FK_TEAM_IDX")); 
		             jsonObj.put("TEAM_NAME", map2.get("TEAM_NAME")); 
		             jsonObj.put("TEAM_USERID", map2.get("TEAM_USERID"));
		             jsonObj.put("TEAM_MEMBER_ADMIN_STATUS", map2.get("TEAM_MEMBER_ADMIN_STATUS"));

		             
		             jsonArr.put(jsonObj);
		          }

		          String str_jsonArr = jsonArr.toString();
		          req.setAttribute("str_jsonArr", str_jsonArr);
				   
				
			}
          
        
     
			
			return "jihye/mySettingJSON";
	   }
	   
	   
	   
	   
	   
	   
	   
	     // admin 차트 그리기
	   // ========> 차트그리기 <=============
	   	@RequestMapping(value="/adminChart.action", method= {RequestMethod.GET})
	   public String requireLogin_adminChart(HttpServletRequest req, HttpServletResponse res) {  
	   		HttpSession session = req.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			
			String userid = null;

			if (loginuser != null) {
				userid = loginuser.getUserid();
			}
			
			if(!userid.equalsIgnoreCase("admin")) {
				
				String msg ="접근이 불가합니다.";
				String loc ="index.action";
				
				req.setAttribute("msg", msg);
				req.setAttribute("loc", loc);
				
				return "msg.notiles";
				
			}
		   
	      return "jihye/adminChart.tiles";
	   }

	      
         
         // 직업별 인원수
         @RequestMapping(value="/adminChartJSON_job.action", method={RequestMethod.GET}) 
         public String adminChartJSON_job(HttpServletRequest req) {
            // 넘어올 form값이 없다.
            // DB에서 select 되어진 값이 넘어와야 한다.

             List<HashMap<String, String>> jobList = service.getChartJSON_job();
             
             JSONArray jsonArr = new JSONArray();  //아무것도 안 넣으면 []
                  
            for(HashMap<String, String> map : jobList) {
               JSONObject jsonObj = new JSONObject();

               //밑에 것은 json에 대한 키값이다.
               jsonObj.put("job", map.get("JOB"));  // map.get("키값")은 xml에 있는 키값이다!!! 차트용
               jsonObj.put("cnt", map.get("CNT"));  // 남/녀의 실제 인원수도 구할 것이다. 나중에 테이블 하나 만들려고 한 것이다.
               jsonObj.put("percent", map.get("PERCENT")); // 남/녀의 비율 
                           
               jsonArr.put(jsonObj);
            }

            String str_jsonArr = jsonArr.toString();
            
            System.out.println("str_jsonArr"+ str_jsonArr);
            
            req.setAttribute("str_jsonArr", str_jsonArr);

            return "jihye/adminChartJSON_job";
         }// end of mybatisTest16JSON_gender()
        
         
         
        
         // 연령대별 인원수
         @RequestMapping(value="/adminChartJSON_ageline.action", method={RequestMethod.GET}) 
         public String adminChartJSON_ageline(HttpServletRequest req) {
            // 넘어올 form값이 없다.
            // DB에서 select 되어진 값이 넘어와야 한다.

             List<HashMap<String, String>> agelineList = service.adminChartJSON_ageline();
             
             JSONArray jsonArr = new JSONArray();  //아무것도 안 넣으면 []
                  
            for(HashMap<String, String> map : agelineList) {
               JSONObject jsonObj = new JSONObject();

               //밑에 것은 json에 대한 키값이다.
               jsonObj.put("ageline", map.get("AGELINE"));  // map.get("키값")은 xml에 있는 키값이다!!! 차트용
               jsonObj.put("cnt", map.get("CNT"));  // 남/녀의 실제 인원수도 구할 것이다. 나중에 테이블 하나 만들려고 한 것이다.
 
               
               jsonArr.put(jsonObj);
            }

            String str_jsonArr = jsonArr.toString();
            
         //   System.out.println("str+jsonArr"+ str_jsonArr);
            
            req.setAttribute("str_jsonArr", str_jsonArr);

            return "jihye/adminChartJSON_ageline";
         }// end of mybatisTest16JSON_gender()
         
     
	/////////////////////////////////////////////////////////////////////////////////////
    // 이중 차트
        @RequestMapping(value="/rankShowJSON.action", method={RequestMethod.GET})
     	public String rankShowJSON(HttpServletRequest req) {
     		
     		String str_jsonarray = service.rankShowJSON();
     		
     		req.setAttribute("str_jsonArr", str_jsonarray);
     		
     		return "jihye/rankShowJSON";
     	}
     	
     	
     	@RequestMapping(value="/jobAgelineRankShowJSON.action", method={RequestMethod.GET})
     	public String jepumdetailnameRankShowJSON(HttpServletRequest req) {
     		
     		String job = req.getParameter("job");
     		
     		System.out.println("성공성공");
     		
     		String str_jsonarray = service.jobAgelineRankShowJSON(job);
     		
     		req.setAttribute("str_jsonArr", str_jsonarray);
     		
     		return "jihye/jobAgelineRankShowJSON"; 
     	}
         
         
         
        // 프로젝트 페이지에서 내가 활동한 기록을 보여주기 /안보여주기 를 위해 switch값을 넘긴다.    	
//     	@RequestMapping(value="/swichMyRecordJSON.action", method={RequestMethod.POST})
//     	public String requireLogin_swichMyRecord(HttpServletRequest req, HttpServletResponse res) {
//     		 
//     		HttpSession session = req.getSession();
//			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
//			
//			String userid = null;
//
//			if (loginuser != null) {
//				userid = loginuser.getUserid();
//			}
//     		 
//     		 String switchVal = req.getParameter("switchVal");
//     		
//     		int n =0;
//     		 if(switchVal.equalsIgnoreCase("1")) {    			 
//     			 n = service.updateIns_personal_alarm(userid);    			 
//     		 }
//     		 
//     		 if(n==1) {
//     			MemberVO str_jsonarray =service.getMyProfile(userid);
//         		
//         		req.setAttribute("str_jsonArr", str_jsonarray);
//         		
//     		 }
//     		 
//     		 return "jihye/swichMyRecordJSON";
//     		 
//     	}
         
	

	
}
