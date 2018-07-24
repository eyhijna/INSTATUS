package com.spring.finalins;

import java.util.HashMap;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.finalins.model.CardVO;
import com.spring.finalins.model.ListVO;
import com.spring.finalins.model.MemberVO;
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
		
	//	System.out.println("image_idx확인용: " + image_idx);

		HashMap<String, String> project_info = new HashMap<String, String>();
		project_info.put("userid", userid);
		project_info.put("project_name", project_name);
		project_info.put("pjst", pjst);
		project_info.put("team_idx", team_idx);
		project_info.put("image_idx", image_idx);
		
		int result = service.insertProject(project_info);
		
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
			
			//project_idx로 배경이미지 테이블에서 프로젝트의 배경이미지명을 가져오는 메소드
			String project_image_name = service.getBackgroundIMG(project_idx);
			
			//유저가 접속한 프로젝트의 정보를 가져오는 메소드
			HashMap<String, String> projectInfo = service.getProjectInfo(map);
			
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
			//	System.out.println("확인용 " + i + "번째 리스트 제목: " + listvo.get(i).getList_name());
			//	System.out.println("카드vo확인용: " + listvo.get(i).getCardvo().getCard_title());
			}
			
			session.setAttribute("projectInfo", projectInfo);
			request.setAttribute("project_image_name", project_image_name);
			request.setAttribute("listvo", listvo);
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
		
		System.out.println("리스트명 확인: " + list_name);
		System.out.println("idx 확인: " + project_idx);
		System.out.println("유저 확인: " + userid);
		//2018.07.20 리스트생성 메소드 작업중
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("list_name", list_name);
		map.put("project_idx", project_idx);
		map.put("userid", userid);
		
		int result = service.addList(map);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);
		
		String str_jsonObj = jsonObj.toString();
		request.setAttribute("str_jsonObj", str_jsonObj);
		
		return "project/addListJSON";
	} // end of addList(HttpServletRequest request) 
	
	
	//카드를 생성하는 메소드 
	@RequestMapping(value="addCard.action", method= {RequestMethod.POST})
	public String addCard(HttpServletRequest request) {
		String userid = request.getParameter("userid");
		String list_idx = request.getParameter("list_idx");
		String card_title = request.getParameter("card_title");
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("userid", userid);
		map.put("list_idx", list_idx);
		map.put("card_title", card_title);
		
		int result = service.addCard(map);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);
		
		String str_jsonObj = jsonObj.toString();
		request.setAttribute("str_jsonObj", str_jsonObj);
		
		return "project/addListJSON";
	} // end of addCard(HttpServletRequest request)
}
