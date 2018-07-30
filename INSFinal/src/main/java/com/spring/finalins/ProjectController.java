package com.spring.finalins;

import java.util.HashMap;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.finalins.model.CardVO;
import com.spring.finalins.model.ListVO;
import com.spring.finalins.model.MemberVO;
import com.spring.finalins.model.TeamMemberVO;
import com.spring.finalins.service.InterProjectService;

@Controller
@Component
/* XML에서 빈을 만드는 대신에 클래스명 앞에 @Component 어노테이션을 적어주면
     해당 클래스는 bean으로 자동 등록된다.
     그리고 bean의 이름(첫글자는 소문자)은 해당 클래스명(지금은 BoardController)이 된다.
     지금은 bean의 이름은 boardController 이 된다. */
public class ProjectController {
	
	@Autowired
	private InterProjectService service;

	//로그인 처리를 하는 메소드
	@RequestMapping(value="loginEnd.action", method= {RequestMethod.POST})
	public String loginEnd(HttpServletRequest request) {
		String userid = request.getParameter("userid");
		String pwd = request.getParameter("pwd");
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("userid", userid);
		map.put("pwd", pwd);
		
		MemberVO loginuser = service.getLogin(map);
		
		if(loginuser != null) {
			HttpSession session = request.getSession();
			session.setAttribute("loginuser", loginuser);
			
			//로그인 가능한 유저인 경우 유저의 팀리스트를 select해서 세션에 담아 보내준다.
			List<HashMap<String, String>> teamList = service.getTeamList(userid);
			
			//로그인한 유저의 프로젝트리스트를 select해서 세션으로 보내준다.
			List<HashMap<String, String>> projectList = service.getProjectList(userid);

			//프로젝트 생성을 위해 배경이미지 테이블의 데이터를 받아와 세션으로 보내준다.
			List<HashMap<String, String>> imageList = service.getProjectImg();
			
			session.setAttribute("imageList", imageList);
			session.setAttribute("projectList", projectList);
			session.setAttribute("teamList", teamList);
		}
		return "login/loginEnd.tiles";
	} // end of loginEnd(HttpServletRequest request)
	
	
	//로그아웃 처리를 하는 메소드 logout.action
	@RequestMapping(value="logout.action", method= {RequestMethod.GET})
	public String logout(HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.invalidate(); //세션에 저장된 모든 데이터를 삭제하고 세션 초기화
		return "login/logout.tiles";
	} // end of logout(HttpServletRequest request)
		
	
	//회원가입 폼을 띄우는 메소드
	@RequestMapping(value="signup.action", method= {RequestMethod.GET})
	public String signup() {
		return "login/signup.tiles";
	} // end of signup() 
	
	 
	//회원가입 요청을 처리하는 메소드  
	@RequestMapping(value="signupEnd.action", method= {RequestMethod.POST})
	public String signupEnd(HttpServletRequest request, MemberVO mvo) {
		/*String bday = mvo.getBirthday();
		System.out.println("생일값 확인: " + bday);*/
		
		int n = service.signupEnd(mvo);
		
		request.setAttribute("n", n);
		return "login/signupEnd.tiles";
	} // end of signupEnd(HttpServletRequest request)
	
	
	//회원가입시 아이디 중복체크하는 함수 
	@RequestMapping(value="idcheck.action", method= {RequestMethod.GET})
	public String idcheck(HttpServletRequest request) {
		String useridCheck = request.getParameter("useridCheck");
		
		String msg = "";
		int n = service.idcheck(useridCheck);
		if(n != 0) {
			msg = "*이미 사용중인 아이디입니다.";
		}
		else if(n == 0) {
			msg = "*사용 가능한 아이디입니다.";
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("msg", msg);
		jsonObj.put("n", n);
		jsonObj.put("useridCheck", useridCheck);
		
		String str_jsonObj = jsonObj.toString();
		request.setAttribute("str_jsonObj", str_jsonObj);
		request.setAttribute("n", n);
		request.setAttribute("useridCheck", useridCheck);
	//	System.out.println("확인용: " + str_jsonObj);
		return "login/idcheckJSON";
	} // end of idcheck(HttpServletRequest request)
	
	
	//회원가입시 이메일 중복체크하는 메소드 emailcheck.action
	@RequestMapping(value="emailcheck.action", method= {RequestMethod.GET})
	public String emailcheck(HttpServletRequest request) {
		String emailCheck = request.getParameter("emailCheck");
		String Classification = request.getParameter("Classification");
		
		
		JSONObject jsonObj = new JSONObject();
		
		int n = service.signupEmailcheck(emailCheck);
		jsonObj.put("n", n);
		jsonObj.put("emailCheck", emailCheck);
		
		if(Classification.equals("Signup")) { //회원가입페이지에서 email체크하는 경우
			String str_jsonObj = jsonObj.toString();
			request.setAttribute("str_jsonObj", str_jsonObj);
			return "login/emailcheckJSON";
		}
		else{ //ID찾기에서 email체크하는 경우
			String resultid = service.getuserID(emailCheck);
			
			jsonObj.put("resultid", resultid);
			String str_jsonObj = jsonObj.toString();
			request.setAttribute("str_jsonObj", str_jsonObj);
			return "login/emailcheckJSON";
		}
	} // end of emailcheck(HttpServletRequest request)
	
	
	//팀idx의 가져와서 프로젝트 노출도 리스트를 보여주는 메소드
	@RequestMapping(value="getTeamVS.action", method= {RequestMethod.GET})
	public String getTeamVS(HttpServletRequest request) {
		String teamIDX = request.getParameter("teamIDX");
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String userid = loginuser.getUserid();
		
		HashMap<String, String> userInfo = new HashMap<String, String>();
		userInfo.put("teamIDX", teamIDX);
		userInfo.put("userid", userid);
		
		HashMap<String, String> teamInfo = service.getTeamVS(userInfo);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("visibility_status", teamInfo.get("visibility_status"));
		jsonObj.put("admin_status", teamInfo.get("admin_status"));
		
		String str_jsonObj = jsonObj.toString();
		
		request.setAttribute("str_jsonObj", str_jsonObj);
		return "main/getTeamVSJSON";
	} // end of getTeamVS(HttpServletRequest request)
	
	
	//프로젝트를 생성하는 메소드
	@RequestMapping(value="insertProject.action", method= {RequestMethod.POST})
	public String insertProject(HttpServletRequest request) {
		String userid = request.getParameter("PJuserid");
		String project_name = request.getParameter("project_name");
		String pjst = request.getParameter("pjst");
		String team_idx = request.getParameter("team");
		String image_idx = request.getParameter("image_idx");
		
		HashMap<String, String> project_info = new HashMap<String, String>();
		project_info.put("userid", userid);
		project_info.put("project_name", project_name);
		project_info.put("pjst", pjst);
		project_info.put("team_idx", team_idx);
		project_info.put("image_idx", image_idx);
		
		int result = 0;
		
		//선택된 팀 멤버를 프로젝트 멤버에 함께 insert하기 위해 받아온 팀멤버 아이디
		String checkedID = request.getParameter("checkedID"); 
		
		if(checkedID.length() > 0 || checkedID != "") {
			System.out.println("substring확인용: " + checkedID.substring(0, checkedID.length()-1));
		//	checkedID.substring(0, checkedID.length()-1);
			String[] memberIdArr = checkedID.substring(0, checkedID.length()-1).split(",");
			
			for(int i=0; i<memberIdArr.length; i++) {
				System.out.println("memberID 스플리트확인: " + memberIdArr[i]);
			}
			System.out.println("================================멤버아이디 있는 경우");
			result = service.insertProject(project_info, memberIdArr);
		}
		else {
			System.out.println("================================멤버아이디 없는 경우");
			result = service.insertProject(project_info);
		}
		
		request.setAttribute("project_info", project_info);
		request.setAttribute("result", result);
		return "main/insertProjectEnd.tiles";
	} // end of insertProject(HttpServletRequest request) 
	
	
	//생성된 프로젝트 페이지로 이동하는 메소드
	@RequestMapping(value="project.action", method= {RequestMethod.GET})
	public String showProjectPage(HttpServletRequest request) {
		String project_name = request.getParameter("project_name");
		String project_idx= request.getParameter("projectIDX");

		HttpSession session = request.getSession();
		session.removeAttribute("projectInfo");
//		List<HashMap<String, String>> teamList = (List<HashMap<String, String>>)session.getAttribute("teamList");
		
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(loginuser != null) {
			String userid = loginuser.getUserid();
			
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("userid", userid);
			map.put("project_idx", project_idx);
			map.put("project_name", project_name);
			
			/*System.out.println("userid확인: " + userid);
			System.out.println("project_idx확인: " + project_idx);
			System.out.println("project_name확인: " + project_name);*/
			//project_idx로 배경이미지 테이블에서 프로젝트의 배경이미지명을 가져오는 메소드
			String project_image_name = service.getBackgroundIMG(project_idx);
			
			//유저가 접속한 프로젝트의 정보를 가져오는 메소드
			HashMap<String, String> projectInfo = service.getProjectInfo(map);
			
			if(projectInfo == null) {
				String msg = "접근권한이 없습니다.";
				request.setAttribute("msg", msg);
				return "main/error";
			}
			
			//프로젝트의 리스트 목록을 가져오는 메소드
			List<ListVO> listvo = null;
			listvo = service.getListInfo(project_idx);
			
			for(int i=0; i<listvo.size(); i++) {
				//프로젝트에 포함된 리스트의 카드목록을 가져오는 메소드
				List<CardVO> cardlist = service.getCardInfo(listvo.get(i).getList_idx());
				
				if(cardlist != null) {
					listvo.get(i).setCardlist(cardlist);
				}
				// listvo for문 돌면서 cardVo 담기 
			}
			
			//프로젝트에 소속되어 있는 프로젝트 멤버의 정보를 가져오는 메소드
			List<HashMap<String, String>> memberInfo = service.getProjectMemberInfo(project_idx);
			
			session.setAttribute("projectInfo", projectInfo);
			request.setAttribute("project_image_name", project_image_name);
			request.setAttribute("listvo", listvo);
			request.setAttribute("memberInfo", memberInfo);
		}
		else if(loginuser == null) {
			return "login/logincheck";
		}
		return "project/project.tiles";
	} // end of showProjectPage(HttpServletRequest request)
	
	
	//프로젝트의 즐겨찾기 상태를 변경하는 메소드
	@RequestMapping(value="updateFavoriteStatus.action", method= {RequestMethod.POST})
	public String updateFavoriteStatus(HttpServletRequest request) {
		String userid = request.getParameter("userid");
		String favorite_status = request.getParameter("favorite_status");
		String project_idx = request.getParameter("project_idx");
		
		HttpSession session = request.getSession();
		session.removeAttribute("projectInfo");
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("userid", userid);
		map.put("favorite_status", favorite_status);
		map.put("project_idx", project_idx);
		
		int result = service.updateFavoriteStatus(map);
		String msg = "";
		JSONObject jsonObj = new JSONObject();
		
		if(result == 1) { //update 성공한 경우
			msg = "즐겨찾기 설정이 변경되었습니다!";
			
			if(favorite_status.equals("1")) {
				favorite_status = "0";
			}
			else if(favorite_status.equals("0")) {
				favorite_status = "1";
			}
		}
		else {
			msg = "즐겨찾기 설정이 변경에 실패했습니다!!";
		}
		
		HashMap<String, String> projectInfo = service.getProjectInfo(map);
		
		jsonObj.put("msg", msg);
		jsonObj.put("result", result);
		jsonObj.put("favorite_status", favorite_status);
		jsonObj.put("project_idx", projectInfo.get("project_idx"));
		jsonObj.put("project_name", projectInfo.get("project_name"));
		jsonObj.put("project_visibility", projectInfo.get("project_visibility"));
		jsonObj.put("project_favorite", projectInfo.get("project_favorite"));
		jsonObj.put("project_member_idx", projectInfo.get("project_member_idx"));
		jsonObj.put("member_id", projectInfo.get("member_id"));
		jsonObj.put("project_admin", projectInfo.get("project_admin"));
		
		String str_jsonObj = jsonObj.toString();
		
		session.setAttribute("projectInfo", projectInfo);
		request.setAttribute("str_jsonObj", str_jsonObj);
		
	//	System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~str_jsonObj => " + str_jsonObj);
		
		return "project/updateFavoriteStatusJSON";
	} // end of updateFavoriteStatus(HttpServletRequest request)
	
	
	//비밀번호찾기에서 이메일과 id로 일치하는 회원이 있는지 확인하는 메소드
	@RequestMapping(value="emailCheck.action", method= {RequestMethod.POST})
	public String emailCheck(HttpServletRequest request) {
		String userid = request.getParameter("userid");
		String email = request.getParameter("email");
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("userid", userid);
		map.put("email", email);
		
		int n = service.emailCheck(map);
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		String msg = "";
		if(n==1) {
			msg = "회원정보가 일치합니다. 위 메일로 인증코드를 발송합니다.";
		}
		else {
			msg = "일치하는 회원정보가 없습니다.";
		}
		jsonObj.put("msg", msg);

		String str_jsonObj = jsonObj.toString();
		request.setAttribute("str_jsonObj", str_jsonObj);
		return "project/emailCheckJSON";
	} // end of emailCheck(HttpServletRequest request)
	
	
	//비밀번호 찾기를 위해 메일로 인증코드 발송하는 메소드 
	@RequestMapping(value="findPassword.action", method= {RequestMethod.POST})
	public String findPassword(HttpServletRequest request) {
		String email = request.getParameter("email");
		
		GoogleMail mail = new GoogleMail();
		Random rnd = new Random();
		
		String certificationCode = "";// 인증코드 => 문자 5글자 숫자 7글자를 조합해서 보내준다.
		char randcher = ' ';
		
		//랜덤 인증코드 생성
		for(int i=0; i<5; i++) { // 문자 5개
			randcher = (char)(rnd.nextInt('z'-'a'+1)+'a');// char, short 타입은 연산이 되면서 int 타입으로 변함
			certificationCode += randcher;
		}// end of for()-----------------------
		
		int randnum=0;
		for(int i=0; i<7; i++) { // 숫자 7개
			randnum = (rnd.nextInt(10-0+1)+0);
			certificationCode +=randnum;
		}// end of for()-----------------------
		
		JSONObject jsonObj = new JSONObject();
		try {
			mail.sendmail(email, certificationCode);// 인증키는 랜덤으로 가져온다.
			jsonObj.put("certificationCode", certificationCode);
			
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("sendFailmsg", "메일발송에 실패했습니다.");
		}// end of try-------------------
		
		String str_jsonObj = jsonObj.toString();
		request.setAttribute("str_jsonObj", str_jsonObj);
		
		return "project/findPasswordJSON";
	} // end of findPassword(HttpServletRequest request)
	
	
	@RequestMapping(value="changePwd.action", method= {RequestMethod.GET})
	public String changePwd() {
		return "login/changePwd";
	}
	
	
	//리스트를 생성하는 메소드 
	@RequestMapping(value="addList.action", method= {RequestMethod.POST})
	public String addList(HttpServletRequest request) {
		String list_name = request.getParameter("list_name");
		String project_idx = request.getParameter("project_idx");
		String userid = request.getParameter("userid");
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("list_name", list_name);
		map.put("project_idx", project_idx);
		map.put("userid", userid);
		
		int result = service.addList(map);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);
		
		if(result == 2) {
			ListVO listvo = service.getListOne(map);
			
			jsonObj.put("list_idx", listvo.getList_idx());
			jsonObj.put("fk_project_idx", listvo.getFk_project_idx());
			jsonObj.put("list_name", listvo.getList_name());
			jsonObj.put("list_delete_status", listvo.getList_delete_status());
			jsonObj.put("list_userid", listvo.getList_userid());
		}
		
		String str_jsonObj = jsonObj.toString();
		request.setAttribute("str_jsonObj", str_jsonObj);
	//	System.out.println("json데이터 확인: " + str_jsonObj);
		return "project/addListJSON";
	} // end of addList(HttpServletRequest request) 
	
	
	//카드를 생성하는 메소드 
	@RequestMapping(value="addCard.action", method= {RequestMethod.POST})
	public String addCard(HttpServletRequest request) {
		String userid = request.getParameter("userid");
		String list_idx = request.getParameter("list_idx");
		String card_title = request.getParameter("card_title");
	/*	System.out.println("카트인서트 아이디체크: " + userid);
		System.out.println("카트인서트 리스트idx체크: " + list_idx);
		System.out.println("카트인서트 카드제목체크: " + card_title);*/
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("userid", userid);
		map.put("list_idx", list_idx);
		map.put("card_title", card_title);
		
		int result = service.addCard(map);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);
		jsonObj.put("card_idx", map.get("card_idx"));
		
		String str_jsonObj = jsonObj.toString();
		request.setAttribute("str_jsonObj", str_jsonObj);
		
		return "project/addListJSON";
	} // end of addCard(HttpServletRequest request)
	
	
	//메인페이지에서 비밀번호 변경하는 메소드 
	@RequestMapping(value="changePassword.action", method= {RequestMethod.POST})
	public String changePassword(HttpServletRequest request) {
		String userid = request.getParameter("userid");
		String password = request.getParameter("password");
		
//		System.out.println("아이디확인: " + userid + "  비밀번호확인: " + password);
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("userid", userid);
		map.put("password", password);
		
		int result = service.changePassword(map);
		
		String msg = "";
		if(result == 1) {
			msg = "비밀번호가 변경되었습니다!";
		}
		else {
			msg = "비밀번호 변경에 실패했습니다. 다시 시도해주세요.";
		}
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);
		jsonObj.put("msg", msg);
		
		String str_jsonObj = jsonObj.toString();
		request.setAttribute("str_jsonObj", str_jsonObj);
		return "main/changePasswordJSON";
	} // end of changePassword(HttpServletRequest request)
	
	
	//리스트 제목을 변경하는 메소드 
	@RequestMapping(value="updateListTitle.action", method= {RequestMethod.POST})
	public String updateListTitle(HttpServletRequest request) {
		String newtitle = request.getParameter("newtitle");
		String oldtitle = request.getParameter("oldtitle");
		String list_idx = request.getParameter("list_idx");

		System.out.println("변경할 타이틀 확인: " + newtitle + "  이전타이틀 확인: " + oldtitle);
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("newtitle", newtitle);
		map.put("oldtitle", oldtitle);
		map.put("list_idx", list_idx);
		
		String resultTitle = service.updateListTitle(map);
		System.out.println("타이틀 업데이트 확인용: " + resultTitle);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("resultTitle", resultTitle);
		
		String str_jsonObj = jsonObj.toString();
		request.setAttribute("str_jsonObj", str_jsonObj);
		return "project/titleUpdateJSON";
	} // end of updateListTitle(HttpServletRequest request)
	
	
	//팀 idx를 받아와서 팀멤버vo 정보를 불러오는 메소드 
	@RequestMapping(value="getTeamMemberInfo.action", method= {RequestMethod.POST})
	public String getTeamMemberInfo(HttpServletRequest request) {
		String team_idx = request.getParameter("teamIDX");
		String userid = request.getParameter("userid");
		
		System.out.println("팀 idx: " + team_idx);
		System.out.println("userid: " + userid);
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("team_idx", team_idx);
		map.put("userid", userid);
		
		List<TeamMemberVO> voList = service.getTeamMemberInfo(map); 
		
		JSONArray jsonArr = new JSONArray();
		for(int i=0; i<voList.size(); i++) {
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("fk_team_idx", voList.get(i).getFk_team_idx());
			jsonObj.put("team_userid", voList.get(i).getTeam_userid());
			jsonObj.put("team_member_admin_status", voList.get(i).getTeam_member_admin_status());
			
			jsonArr.put(jsonObj);
		}
		String str_jsonArr = jsonArr.toString();
		System.out.println("jsonArr확인용: " + str_jsonArr);
		
		request.setAttribute("str_jsonArr", str_jsonArr);
		return "main/getTeamMemberInfoJSON";
	} // end of getTeamMemberInfo(HttpServletRequest request)
	
	
	@RequestMapping(value="updateListDeleteStatus.action", method= {RequestMethod.POST})
	public String updateListDeleteStatus(HttpServletRequest request) {
		String project_idx = request.getParameter("project_idx");
		String list_idx = request.getParameter("list_idx");
		String delete_type = request.getParameter("delete_type");

		HashMap<String, String> map = new HashMap<String, String>();
		map.put("project_idx", project_idx);
		map.put("list_idx", list_idx);
		map.put("delete_type", delete_type);
		
		int result = service.updateListDeleteStatus(map);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);
		
		String str_jsonObj = jsonObj.toString();
		request.setAttribute("str_jsonObj", str_jsonObj);
		
		return "project/addListJSON";
	} // end of updateListTitle(HttpServletRequest request)
	
	
	@RequestMapping(value="getArchive.action", method= {RequestMethod.POST})
	public String getArchive(HttpServletRequest request) {
		String project_idx = request.getParameter("project_idx");

		List<HashMap<String, String>> voList = service.getArchive(project_idx); 
		
		JSONArray jsonArr = new JSONArray();
		for(int i=0; i<voList.size(); i++) {
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("ARCHIVE_IDX", voList.get(i).get("ARCHIVE_IDX"));
			jsonObj.put("ARCHIVE_INSERT_TIME", voList.get(i).get("ARCHIVE_INSERT_TIME"));
			jsonObj.put("list_idx", voList.get(i).get("list_idx"));
			jsonObj.put("list_name", voList.get(i).get("list_name"));
			jsonArr.put(jsonObj);
		}
		String str_jsonArr = jsonArr.toString();
		request.setAttribute("str_jsonObj", str_jsonArr);
		return "project/addListJSON";
	} // end of updateListTitle(HttpServletRequest request)
}
