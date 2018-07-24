package com.spring.finalins;


import java.util.HashMap;
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

import com.spring.finalins.model.CardVO;
import com.spring.finalins.model.ListVO;
import com.spring.finalins.model.MemberVO;
import com.spring.finalins.model.ProjectMemeberVO;
import com.spring.finalins.model.ProjectVO;
import com.spring.finalins.model.TeamVO;
import com.spring.finalins.service.InterMinjaeServie;

@Controller
@Component
public class MINJAEController {

	@Autowired
	private InterMinjaeServie service;
	
	
	// mj_project.jsp 페이지를 여는 메소드
	@RequestMapping(value="/mj_project.action", method= {RequestMethod.GET})
	public String requireLogin_mj_project(HttpServletRequest req,  HttpServletResponse res) {
		
		return "minjae/mj_project.tiles";
				
	}
	
	// 유저의 teamlist를 json 으로 불러 오는 메소드
	@RequestMapping(value="/teamlist.action", method= {RequestMethod.GET})
	public String teamlist(HttpServletRequest req,  HttpServletResponse res) {
		
		System.out.println("list.action 확인>>>>>>>>>>>>>>>>");
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		System.out.println("controller loginuser : " + loginuser.getUserid());
		
		// 로그인한 userid의 팀의 목록을 갖고 옴
		List<TeamVO> teamList = service.getTeamList(loginuser.getUserid());
		
		for(int i=0; i<teamList.size(); i++) {
			System.out.println(teamList.get(i).getTeam_name());
		}
		
		JSONArray jsonArr = new JSONArray();
		
		if(teamList.size() > 0) {
			for(TeamVO teamvo:teamList) {
				JSONObject jsonObj = new JSONObject();
				
				jsonObj.put("team_idx", teamvo.getTeam_idx());
				jsonObj.put("admin_userid", teamvo.getAdmin_userid());
				jsonObj.put("team_name", teamvo.getTeam_name());
				jsonObj.put("team_delete_status", teamvo.getTeam_delete_status());
				jsonObj.put("team_visibility_status", teamvo.getTeam_visibility_status());
				jsonObj.put("server_filename", teamvo.getServer_filename());
				jsonObj.put("file_size", teamvo.getFile_size());
				jsonObj.put("org_filename", teamvo.getOrg_filename());
				
				jsonArr.put(jsonObj);
				
			}
		}
		
		String str_jsonArr = jsonArr.toString();
		req.setAttribute("str_jsonArr", str_jsonArr);
		
		return "teamlist.notiles";
		
	}
	
	// 유저의 projectlist를 json 으로 불러 오는 메소드
	@RequestMapping(value="/projectlist.action", method= {RequestMethod.GET})
	public String header(HttpServletRequest req,  HttpServletResponse res) {
		
		System.out.println("projectlist.action 확인>>>>>>>>>>>>>>>>");
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		System.out.println("controller loginuser : " + loginuser.getUserid());
		
		String fk_team_idx = req.getParameter("fk_team_idx");
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("fk_team_idx", fk_team_idx);
		map.put("userid", loginuser.getUserid());
		
		// 해당하는 팀의 프로젝트 목록을 갖고 옴
		List<ProjectVO> projectList = service.getProjectList(map);
		
		for(int i=0; i<projectList.size(); i++) {
			System.out.println(projectList.get(i).getProject_name());
		}
		
		JSONArray jsonArr = new JSONArray();
		
		if(projectList.size() > 0) {
			for(ProjectVO projectvo:projectList) {
				JSONObject jsonObj = new JSONObject();
				
				jsonObj.put("project_idx", projectvo.getProject_idx());
				jsonObj.put("fk_team_idx", projectvo.getFk_team_idx());
				jsonObj.put("project_name", projectvo.getProject_name());
				jsonObj.put("project_visibility_st", projectvo.getProject_visibility_st());
				jsonObj.put("project_delete_status", projectvo.getProject_delete_status());
				jsonObj.put("fk_project_image_idx", projectvo.getFk_project_image_idx());
				
				jsonArr.put(jsonObj);
				
			}
		}
		
		String str_jsonArr = jsonArr.toString();
		System.out.println("project jsonArr ::::::::::::::::: " + str_jsonArr);
		
		req.setAttribute("str_jsonArr", str_jsonArr);
		
		
		return "projectlist.notiles";
		
	}

	// header : 검색을 위해 teamList 를 얻음
	@RequestMapping(value="/teamSearch.action", method= {RequestMethod.GET})
	public String teamSearch(HttpServletRequest req,  HttpServletResponse res) {
	
		String search_input = req.getParameter("search_input");
		
		if(!search_input.trim().isEmpty()) {
			
			List<TeamVO> teamList = service.getSearch_team(search_input);
			
			JSONArray jsonArr = new JSONArray();
			
			if(teamList != null && teamList.size() > 0) {
				for(TeamVO teamvo :teamList) {
				
					JSONObject jsonObj = new JSONObject();
					
					jsonObj.put("team_idx", teamvo.getTeam_idx());
					jsonObj.put("admin_userid", teamvo.getAdmin_userid());
					jsonObj.put("team_name", teamvo.getTeam_name());
					jsonObj.put("team_delete_status", teamvo.getTeam_delete_status());
					jsonObj.put("team_visibility_status", teamvo.getTeam_visibility_status());
					jsonObj.put("server_filename", teamvo.getServer_filename());
					jsonObj.put("file_size", teamvo.getFile_size());
					jsonObj.put("org_filename", teamvo.getOrg_filename());
					
					jsonArr.put(jsonObj);
					
				}
			}
			
			
			
			
			String str_jsonArr = jsonArr.toString();
			req.setAttribute("str_jsonArr", str_jsonArr);
	
		}
		
		HttpSession session = req.getSession();
		session.setAttribute("search_input", search_input);
	
		return "teamSearch.notiles";

	}
	
	// header : 검색을 위해 projectList 를 얻음
	@RequestMapping(value="/projectSearch.action", method= {RequestMethod.GET})
	public String projectSearch(HttpServletRequest req,  HttpServletResponse res) {
	
		System.out.println("controller 실행확인");
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String search_input = req.getParameter("search_input");
		
		if(!search_input.trim().isEmpty()) {
			
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("userid", loginuser.getUserid());
			map.put("search_input", search_input);
			
			List<ProjectVO> projectList = service.getSearch_project(map);
			
			JSONArray jsonArr = new JSONArray();
			
			if(projectList != null && projectList.size() > 0) {
				for(ProjectVO projectvo :projectList) {
				
					JSONObject jsonObj = new JSONObject();
					
					jsonObj.put("project_idx", projectvo.getProject_idx());
					jsonObj.put("fk_team_idx", projectvo.getFk_team_idx());
					jsonObj.put("project_name", projectvo.getProject_name());
					jsonObj.put("project_visibility_st", projectvo.getProject_visibility_st());
					jsonObj.put("project_delete_status", projectvo.getProject_delete_status());
					jsonObj.put("fk_project_image_idx", projectvo.getFk_project_image_idx());
					
					jsonArr.put(jsonObj);
					
				}
			}
		
			String str_jsonArr = jsonArr.toString();
			req.setAttribute("str_jsonArr", str_jsonArr);
	
		}
	
		return "projectSearch.notiles";

	}
	
	
	@RequestMapping(value="/listSearch.action", method= {RequestMethod.GET})
	public String listSearch(HttpServletRequest req,  HttpServletResponse res) {
	
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String search_input = req.getParameter("search_input");
		
		if(!search_input.trim().isEmpty()) {
			
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("search_input", search_input);
			map.put("userid", loginuser.getUserid());
			
			List<ListVO> listList = service.getSearch_list(map);
		
			JSONArray jsonArr = new JSONArray();
			
			if(listList != null && listList.size() > 0) {
				
				for(ListVO listvo :listList) {
					
					JSONObject jsonObj = new JSONObject();
					
					jsonObj.put("list_idx", listvo.getList_idx());
					jsonObj.put("fk_project_idx", listvo.getFk_project_idx());
					jsonObj.put("list_name", listvo.getList_name());
					jsonObj.put("list_delete_status", listvo.getList_delete_status());
					
					jsonArr.put(jsonObj);
					
				}
				
			}
			
			String str_jsonArr = jsonArr.toString();
			req.setAttribute("str_jsonArr", str_jsonArr);
			
		}
		
		return "listSearch.notiles";

	}
	
	@RequestMapping(value="/cardSearch.action", method= {RequestMethod.GET})
	public String cardSearch(HttpServletRequest req,  HttpServletResponse res) {
	
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String search_input = req.getParameter("search_input");
		
		if(!search_input.trim().isEmpty()) {
			
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("search_input", search_input);
			map.put("userid", loginuser.getUserid());
			
			List<CardVO> cardList = service.getSearch_card(map);
		
			JSONArray jsonArr = new JSONArray();
			
			if(cardList != null && cardList.size() > 0) {
				
				for(CardVO cardvo :cardList) {
					
					JSONObject jsonObj = new JSONObject();
					
					jsonObj.put("card_idx", cardvo.getCard_idx());
					jsonObj.put("fk_list_idx", cardvo.getFk_list_idx());
					jsonObj.put("card_userid", cardvo.getCard_userid());
					jsonObj.put("card_title", cardvo.getCard_title());
					jsonObj.put("card_commentcount", cardvo.getCard_commentcount());
					jsonObj.put("card_date", cardvo.getCard_date());
					jsonObj.put("card_delete_status", cardvo.getCard_delete_status());
					
					jsonArr.put(jsonObj);
					
				}
				
			}
			
			String str_jsonArr = jsonArr.toString();
			req.setAttribute("str_jsonArr", str_jsonArr);
			
		}
		
		return "cardSearch.notiles";

	}
	
	
	@RequestMapping(value="/memberSearch.action", method= {RequestMethod.GET})
	public String memberSearch(HttpServletRequest req,  HttpServletResponse res) {
			
		String search_input = req.getParameter("search_input");
		
		if(!search_input.trim().isEmpty()) {
						
			List<HashMap<String, String>> memberList = service.getSearch_member(search_input);
		
			JSONArray jsonArr = new JSONArray();
			
			if(memberList != null && memberList.size() > 0) {
				
				for(HashMap<String, String> memberMap:memberList) {
					
					JSONObject jsonObj = new JSONObject();
					
					jsonObj.put("userid", memberMap.get("userid"));
					jsonObj.put("nickname", memberMap.get("nickname"));
					jsonObj.put("name", memberMap.get("name"));
					jsonObj.put("profilejpg", memberMap.get("profilejpg"));
					
					
					jsonArr.put(jsonObj);
					
				}
				
			}
			
			
			String str_jsonArr = jsonArr.toString();
			req.setAttribute("str_jsonArr", str_jsonArr);
			
		}
		
		return "memberSearch.notiles";

	}
	
	@RequestMapping(value="/leaveProject.action", method= {RequestMethod.GET})
	public String requireLogin_leaveProject(HttpServletRequest req,  HttpServletResponse res) throws Throwable  {
		
		/*String fk_project_idx = req.getParameter("fk_project_idx");*/
		String fk_project_idx = "31";
		System.out.println("fk_project_idx>>>>>>>>>>>>>>>>>>>>>>>>>" + fk_project_idx);
		
		
		// project 탈퇴시 project_member의 userid 와 admin_status 를 얻어옴
		List<ProjectMemeberVO> projectmemberList = service.getProjectCorrect(fk_project_idx);
		for(ProjectMemeberVO projectmembervo:projectmemberList) {
			System.out.println("project_member userid, admin_status" + projectmembervo.getProject_member_userid());
		}
		
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		HashMap<String, String> map = new HashMap<String, String>(); 
		map.put("userid", loginuser.getUserid());
		map.put("fk_project_idx", fk_project_idx);
		
		int n =0;
		
		for(ProjectMemeberVO projectvo:projectmemberList) {
			
			if(projectvo.getProject_member_userid().equalsIgnoreCase(loginuser.getUserid())) {
				
				if("0".equals(projectvo.getProject_member_admin_status())) {
					// 일반유저 경우 
					n = service.generalProjectLeave(map);
					System.out.println("일반 유저의 탈퇴     >>>>>>>>>" + n);
				}
				else if("1".equals(projectvo.getProject_member_admin_status())) {
					// 프로젝트 관리자 경우
					
					n = service.adminProjectLeave(map); // 프로젝트 관리자의 상태를 바꿈
					System.out.println("프로젝트 관리자 유저의 탈퇴     >>>>>>>>>" + n);
					
				}
				
			}
		}
		
		String msg = "";
		String loc = "";
		
		if(n == 1) {
			msg = loginuser.getUserid() + "님의 프로젝트 탈퇴가 성공적으로 되었습니다.";
			loc = "index.action";		
		}
		else {
			msg = loginuser.getUserid() + "님의 프로젝트 탈퇴를 실패하였습니다.";
			loc = "javascript:history.back();";
		}
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
							
		return "msg.notiles";
				
	}
	
	@RequestMapping(value="/deleteProject.action", method=RequestMethod.GET)
	public String requireLogin_deleteProject(HttpServletRequest req, HttpServletResponse res) throws Throwable {
		
		String fk_project_idx = req.getParameter("fk_project_idx");
		
		fk_project_idx = "31";
		
		// project의 adminList를 갖고 옴
		List<HashMap<String, String>> adminList = service.getAdminList();
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		int n = 0;
		
		String msg = "";
		String loc = "";
		
		if( adminList != null || adminList.size() > 0 ) {
			for(int i =0; i<adminList.size(); i++) {
				String adminuserid = adminList.get(i).get("project_member_userid");
				System.out.println("adminuserid>>>>>>>>>" + adminuserid);
				
				
				if(adminuserid.equals(loginuser.getUserid())){
					
					n = service.deleteProject(fk_project_idx);
					System.out.println("deleteProject.action>>>>>>>>>>>>>>>>>>>>> " + n);
				}
				
				
			}
		}
		else {
			msg = "관리자 권한을 가진 사람만 가능합니다";
			loc = "javascript:history.back();";
					
		}


		
		if(n > 0) {
			msg = "프로젝트의 삭제가 성공했습니다.";
			loc = "index.action";
		}
		else {
			msg = "프로젝트의 삭제를 실패했습니다.";
			loc = "javascript:history.back();";
		}
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
		
		
		return "msg.notiles";
		
	}
	
	
	@RequestMapping(value="/projectRecordView.action", method=RequestMethod.GET)
	public String requireLogin_projectRecordView(HttpServletRequest req, HttpServletResponse res) {
				
		String fk_project_idx = req.getParameter("fk_project_idx");
		String sel1Val = req.getParameter("sel1Val");
	
			
	//	String fk_project_idx = "3";
		
		System.out.println("sel1Val>>>>>>>>>>>" + sel1Val);
		System.out.println("fk_project_idx>>>>>>>>>>>>>" + fk_project_idx);
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("fk_project_idx", fk_project_idx);
		map.put("sel1Val", sel1Val);
		map.put("userid", loginuser.getUserid());
		
		System.out.println("controller sel1Val>>>>>>> " + sel1Val);
				
		List<HashMap<String, String>> projectRecordList = service.projectRecordView(map);
		
		for (int i = 0; i < projectRecordList.size(); i++) {
			
			System.out.println("Controller>>>>>>>>>>>>> projectRecordList >>>>>>>>>>>>>" + projectRecordList.get(i).get("card_title"));
			
		}
		
		JSONArray jsonArr = new JSONArray();
		
		if(projectRecordList != null && projectRecordList.size() > 0  ) {
			
			for(HashMap<String, String> projectRecordMap : projectRecordList) {
				
				JSONObject jsonObj = new JSONObject();
				
				jsonObj.put("server_filename", projectRecordMap.get("server_filename"));
				jsonObj.put("userid", projectRecordMap.get("userid"));
				jsonObj.put("project_record_idx", projectRecordMap.get("project_record_idx"));
				jsonObj.put("fk_project_idx", projectRecordMap.get("fk_project_idx"));
				jsonObj.put("project_record_time", projectRecordMap.get("project_record_time"));
				jsonObj.put("fk_list_idx", projectRecordMap.get("fk_list_idx"));
				jsonObj.put("list_name", projectRecordMap.get("list_name"));
				jsonObj.put("fk_card_idx", projectRecordMap.get("fk_card_idx"));
				jsonObj.put("card_title", projectRecordMap.get("card_title"));
				jsonObj.put("record_dml_status", projectRecordMap.get("record_dml_status"));
				
				
				jsonArr.put(jsonObj);
			}
		}
		
		
		
		String str_jsonArr = jsonArr.toString();
		req.setAttribute("str_jsonArr", str_jsonArr);
		System.out.println("projectRecordList>>>>>>>>" + str_jsonArr);
		
		req.setAttribute("projectRecordList", projectRecordList);
		/*req.setAttribute("sel1Val", sel1Val);*/
		
		return "projectRecordView.notiles";
		
	}
	@RequestMapping(value="/searchINproject.action", method=RequestMethod.GET)
	public String requireLogin_searchINproject(HttpServletRequest req, HttpServletResponse res) {
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String fk_project_idx = req.getParameter("fk_project_idx");
		String sel2Val = req.getParameter("sel2Val");
		String listsearchINproject = req.getParameter("listsearchINproject");
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("userid", loginuser.getUserid());
		map.put("fk_project_idx", fk_project_idx);
		map.put("listsearchINproject", listsearchINproject);
		
		JSONArray jsonArr = new JSONArray();
		
		List<HashMap<String, String>> searchINprojectList = null;
		
		if(("list").equals(sel2Val)) {
			searchINprojectList = service.getSearchlistINproject(map);
			
			if(searchINprojectList != null && searchINprojectList.size() > 0) {
				for(HashMap<String, String> searchINprojectMap :searchINprojectList) {
					JSONObject jsonObj = new JSONObject();
					
					jsonObj.put("list_idx", searchINprojectMap.get("list_idx"));
					jsonObj.put("list_name", searchINprojectMap.get("list_name"));
					jsonObj.put("list_userid", searchINprojectMap.get("list_userid"));
					
					jsonArr.put(jsonObj);
				}
			}
			
		}
		else if(("card").equals(sel2Val)) {
		
			/*List<HashMap<String, String>> searchINprojectList = service.getSearchcardINproject(map);*/
		}
		
		
		String str_jsonArr = jsonArr.toString();
		req.setAttribute("str_jsonArr", str_jsonArr);
		
		
		
		return "searchINproject.notiles";
				
		
	}
	
	@RequestMapping(value="/personalAlarm.action", method=RequestMethod.GET)
	public String personalAlarmProjectList(HttpServletRequest req, HttpServletResponse res) {
	
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String userid = loginuser.getUserid();
				
		int newmsg = service.getNewMessageCount(userid); // user가 읽지 않은 메시지의 갯수를 얻어옴
		
		System.out.println("controller msg >>>>>" + newmsg);
		// session.setAttribute("newmsg", newmsg);
		
		///////////////////////////////////////////////////////////////////////////////////////////////
								
		List<HashMap<String, String>> newMsgList = service.getNewMessageList(userid); // user가 읽지 않은 메세지의 리스트를 얻어옴
		
		JSONArray jsonArr = new JSONArray();
		
		if(newMsgList.size() > 0) {
			
			for(HashMap<String, String> newMsgMap :newMsgList) {
				
				JSONObject jsonObj = new JSONObject();
				
				jsonObj.put("project_record_idx", newMsgMap.get("project_record_idx"));
				jsonObj.put("record_userid", newMsgMap.get("record_userid"));
				jsonObj.put("project_record_time", newMsgMap.get("project_record_time"));
				jsonObj.put("record_dml_status", newMsgMap.get("record_dml_status"));
				jsonObj.put("project_name", newMsgMap.get("project_name"));
				jsonObj.put("list_name", newMsgMap.get("list_name"));
				jsonObj.put("card_title", newMsgMap.get("card_title"));
				jsonObj.put("server_filename", newMsgMap.get("server_filename"));
				jsonObj.put("newmsg", newmsg);
				jsonArr.put(jsonObj);
				
			}
			
		}
		
		String str_jsonArr = jsonArr.toString();
		req.setAttribute("str_jsonArr", str_jsonArr);
		
		return "personalAlarm.notiles";
				
	}
	
	
	@RequestMapping(value="/personalAlarmCheckbox.action", method=RequestMethod.POST)
	public String personalAlarmCheckbox(HttpServletRequest req, HttpServletResponse res) {
		
		String checkboxVal = req.getParameter("checkboxVal");
		
		System.out.println("checkboxVal >>>>>>>>>>>>>>>" + checkboxVal);
		
		int n = service.setPersonal_alarm_read_status(checkboxVal);// personal_alarm_read_status 변경
		
		JSONArray jsonArr = new JSONArray();
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		jsonArr.put(jsonObj);
		String str_jsonArr = jsonArr.toString();
		req.setAttribute("str_jsonArr", str_jsonArr);
		
		System.out.println("성공했다.>>>>>>>>>>>>>>>>>" + n);
		
		
	   return "personalAlarmCheckbox.notiles";
	}
	
	
	
}
