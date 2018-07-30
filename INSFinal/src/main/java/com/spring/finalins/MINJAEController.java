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
		
	//	System.out.println("list.action 확인>>>>>>>>>>>>>>>>");
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
		
	//	System.out.println("projectlist.action 확인>>>>>>>>>>>>>>>>");
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
	//	System.out.println("controller loginuser : " + loginuser.getUserid());
		
		String fk_team_idx = req.getParameter("fk_team_idx");
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("fk_team_idx", fk_team_idx);
		map.put("userid", loginuser.getUserid());
		
		// 해당하는 팀의 프로젝트 목록을 갖고 옴
		List<HashMap<String, String>> projectList = service.getProjectList(map);
		
		JSONArray jsonArr = new JSONArray();
		
		if(projectList.size() > 0) {
			for(HashMap<String, String> projectmap:projectList) {
				JSONObject jsonObj = new JSONObject();
				
				jsonObj.put("project_idx", projectmap.get("project_idx"));
				jsonObj.put("fk_team_idx", projectmap.get("fk_team_idx"));   
				jsonObj.put("project_name", projectmap.get("project_name"));
				jsonObj.put("project_image_name", projectmap.get("project_image_name"));
				jsonObj.put("project_favorite_status", projectmap.get("project_favorite_status"));
				
				jsonArr.put(jsonObj);
				
			}
			
			
		}
		/*else {
			
			String msg = "해당하는 프로젝트가 없습니다.";
			String loc = "javascript:history.back();";
			
			req.setAttribute("msg", msg);
			req.setAttribute("loc", loc);
			
			return "msg.notiles";
					
			
		}*/
		
		String str_jsonArr = jsonArr.toString();
		// System.out.println("project jsonArr ::::::::::::::::: " + str_jsonArr);
		
		req.setAttribute("str_jsonArr", str_jsonArr);
		
		
		return "projectlist.notiles";
		
	}
	
	// project_favorite_status 
	@RequestMapping(value="/clickA.action", method= {RequestMethod.POST})
	public String clickASearch(HttpServletRequest req, HttpServletResponse res) {
	
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String project_idx = req.getParameter("project_idx");
	
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("userid", loginuser.getUserid());
		map.put("project_idx", project_idx);
		
		int n = service.projectList_updateFavoriteStatus(map);
	
	//	System.out.println("click 확인용>>>>>>>>>>>>>>>>>>>>>>>>>");
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		String str_jsonObj = jsonObj.toString();
		req.setAttribute("str_jsonObj", str_jsonObj);
		
		return "projectList_updateFavoriteStatus2.notiles";
				
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
	
	//	System.out.println("controller 실행확인");
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
			
			List<HashMap<String, String>> listList = service.getSearch_list(map);
		
			JSONArray jsonArr = new JSONArray();
			
			if(listList != null && listList.size() > 0) {
				
				for(HashMap<String, String> listmap :listList) {
					
					JSONObject jsonObj = new JSONObject();
					
					jsonObj.put("list_idx", listmap.get("list_idx"));
					jsonObj.put("fk_project_idx", listmap.get("fk_project_idx"));
					jsonObj.put("list_name", listmap.get("list_name"));
					jsonObj.put("list_delete_status", listmap.get("list_delete_status"));
					jsonObj.put("fk_team_idx", listmap.get("fk_team_idx"));
					jsonObj.put("project_name", listmap.get("project_name"));
					
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
			
			List<HashMap<String, String>> cardList = service.getSearch_card(map);
		
			JSONArray jsonArr = new JSONArray();
			
			if(cardList != null && cardList.size() > 0) {
				
				for(HashMap<String, String> cardmap :cardList) {
					
					JSONObject jsonObj = new JSONObject();
					
					jsonObj.put("card_idx", cardmap.get("card_idx"));
					jsonObj.put("fk_list_idx", cardmap.get("fk_list_idx"));
					jsonObj.put("card_userid", cardmap.get("card_userid"));
					jsonObj.put("card_title", cardmap.get("card_title"));
					jsonObj.put("card_commentcount", cardmap.get("card_commentcount"));
					jsonObj.put("card_date", cardmap.get("card_date"));
					jsonObj.put("card_delete_status", cardmap.get("card_delete_status"));
					jsonObj.put("project_idx", cardmap.get("project_idx"));
					jsonObj.put("fk_team_idx", cardmap.get("fk_team_idx"));
					jsonObj.put("project_name", cardmap.get("project_name"));
					
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
					jsonObj.put("server_filename", memberMap.get("server_filename"));
					
					
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
		
		String fk_project_idx = req.getParameter("fk_project_idx");
		System.out.println("leave Project:::::::::::::::: fk_project_idx>>>>>>>>>>>>>>>>>>>>>>>>>" + fk_project_idx);
		
		
		// project 탈퇴시 project_member의 userid 와 admin_status 를 얻어옴
		List<ProjectMemeberVO> projectmemberList = service.getProjectCorrect(fk_project_idx);
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		HashMap<String, String> map = new HashMap<String, String>(); 
		map.put("userid", loginuser.getUserid());
		map.put("fk_project_idx", fk_project_idx);
		
		int n =0;
		
		String msg = "";
		String loc = "";
		
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
				
				if(n > 0) {
					msg = loginuser.getUserid() + "님의 프로젝트 탈퇴가 성공적으로 되었습니다.";
					loc = "index.action";		
				}
				else {
					msg = loginuser.getUserid() + "님의 프로젝트 탈퇴를 실패하였습니다.";
					loc = "javascript:history.back();";
				}
				
			}
		}
		
		
		
		req.setAttribute("msg", msg);
		req.setAttribute("loc", loc);
							
		return "msg.notiles";
				
	}
	
	@RequestMapping(value="/deleteProject.action", method=RequestMethod.GET)
	public String requireLogin_deleteProject(HttpServletRequest req, HttpServletResponse res) throws Throwable {
		
		String fk_project_idx = req.getParameter("fk_project_idx");
		//System.out.println("프로젝트 삭제 확인:::::::::::::::::::::" +fk_project_idx);
		
		// project의 adminList를 갖고 옴
		String admin = service.getAdmin(fk_project_idx);
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		int n = 0;
		
		String msg = "";
		String loc = "";
		
		if( admin != null ) {
			
			/*for(int i =0; i<adminList.size(); i++) {*/
				//String adminuserid = adminList.get(i).get("project_member_userid");
				//System.out.println("adminuserid>>>>>>>>>" + adminuserid);
				
				
				if((loginuser.getUserid()).equalsIgnoreCase(admin)){
					
					n = service.deleteProject(fk_project_idx);
					//System.out.println("deleteProject.action>>>>>>>>>>>>>>>>>>>>> " + n);
					
					
					if(n > 0) {
						msg = "프로젝트의 삭제가 성공했습니다.";
						loc = "index.action";
					}
					else {
						msg = "프로젝트의 삭제를 실패했습니다.";
						loc = "javascript:history.back();";
					}
				
				}
				else {
					msg = "관리자 권한을 가진 사람만 가능합니다";
					loc = "javascript:history.back();";		
				}
				
				
				
			
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
		
	//	System.out.println("sel1Val>>>>>>>>>>>" + sel1Val);
	//	System.out.println("fk_project_idx>>>>>>>>>>>>>" + fk_project_idx);
		
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("fk_project_idx", fk_project_idx);
		map.put("sel1Val", sel1Val);
		map.put("userid", loginuser.getUserid());
		
		//System.out.println("controller sel1Val>>>>>>> " + sel1Val);
				
		List<HashMap<String, String>> projectRecordList = service.projectRecordView(map);
		
		/*for (int i = 0; i < projectRecordList.size(); i++) {
			
			System.out.println("Controller>>>>>>>>>>>>> projectRecordList >>>>>>>>>>>>>" + projectRecordList.get(i).get("card_title"));
			
		}*/
		
		JSONArray jsonArr = new JSONArray();
		
		if(projectRecordList != null && projectRecordList.size() > 0  ) {
			
			for(HashMap<String, String> projectRecordMap : projectRecordList) {
				
				JSONObject jsonObj = new JSONObject();
				
				if(sel1Val.equals("생성")) {
									
					jsonObj.put("fk_project_idx", projectRecordMap.get("fk_project_idx"));
					jsonObj.put("project_name", projectRecordMap.get("project_name"));
					jsonObj.put("record_userid", projectRecordMap.get("record_userid"));
					jsonObj.put("project_record_time", projectRecordMap.get("project_record_time"));
					jsonObj.put("fk_list_idx", projectRecordMap.get("fk_list_idx"));
					jsonObj.put("list_name", projectRecordMap.get("list_name"));
					jsonObj.put("record_dml_status", projectRecordMap.get("record_dml_status"));
					jsonObj.put("server_filename", projectRecordMap.get("server_filename"));
				}
				else {
										
					jsonObj.put("fk_project_idx", projectRecordMap.get("fk_project_idx"));
					jsonObj.put("project_name", projectRecordMap.get("project_name"));
					jsonObj.put("record_userid", projectRecordMap.get("record_userid"));
					jsonObj.put("project_record_time", projectRecordMap.get("project_record_time"));
					jsonObj.put("fk_list_idx", projectRecordMap.get("fk_list_idx"));
					jsonObj.put("list_name", projectRecordMap.get("list_name"));
					jsonObj.put("record_dml_status", projectRecordMap.get("record_dml_status"));
					jsonObj.put("fk_card_idx", projectRecordMap.get("fk_card_idx"));
					jsonObj.put("card_title", projectRecordMap.get("card_title"));
					jsonObj.put("server_filename", projectRecordMap.get("server_filename"));
					
				}
				
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
	
	// 프로젝트 내에서 리스트를 검색하는 메소드
	@RequestMapping(value="/listsearchINproject.action", method=RequestMethod.GET)
	public String searchListINproject(HttpServletRequest req) {
				
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String fk_project_idx = req.getParameter("fk_project_idx");
		String sel3Val = req.getParameter("sel3Val");
		String listsearchINproject = req.getParameter("listsearchINproject");
		
		/*System.out.println("fk_project_idx"+fk_project_idx);
		System.out.println("sel3Val"+sel3Val);
		System.out.println("listsearchINproject"+listsearchINproject);*/
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("userid", loginuser.getUserid());
		map.put("fk_project_idx", fk_project_idx);
		map.put("listsearchINproject", listsearchINproject);
		
		JSONArray jsonArr = new JSONArray();
		
		List<HashMap<String, String>> listsearchINprojectList = null;
		
		if(("list").equals(sel3Val)) {
			listsearchINprojectList = service.getSearchlistINproject(map);
			
			if(listsearchINprojectList != null && listsearchINprojectList.size() > 0) {
				for(HashMap<String, String> searchINprojectMap :listsearchINprojectList) {
					JSONObject jsonObj = new JSONObject();
					
					jsonObj.put("list_idx", searchINprojectMap.get("list_idx"));
					jsonObj.put("list_name", searchINprojectMap.get("list_name"));
					jsonObj.put("list_userid", searchINprojectMap.get("list_userid"));
					jsonObj.put("list_delete_status", searchINprojectMap.get("list_delete_status"));
					
					jsonArr.put(jsonObj);
				}
			}
			
		}
				
		String str_jsonArr = jsonArr.toString();
		req.setAttribute("str_jsonArr", str_jsonArr);
		
		System.out.println(str_jsonArr);
		
		return "listsearchINproject.notiles";
				
		
	}
	

	// 프로젝트 내에서 리스트를 검색 시 카드 리스트를 불러오는 메소드
	@RequestMapping(value="/listsearchINproject_card.action", method=RequestMethod.GET)
	public String searchCardINproject(HttpServletRequest req, HttpServletResponse res) {
		//System.out.println("확인중!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String fk_project_idx = req.getParameter("fk_project_idx");
		String sel3Val = req.getParameter("sel3Val");
		String fk_list_idx = req.getParameter("fk_list_idx");
		
		/*System.out.println("fk_project_idx"+fk_project_idx);
		System.out.println("sel3Val"+sel3Val);
		System.out.println("fk_list_idx"+fk_list_idx);*/
		
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("userid", loginuser.getUserid());
		map.put("fk_project_idx", fk_project_idx);
		map.put("fk_list_idx", fk_list_idx);
				
		JSONArray jsonArr = new JSONArray();
		
		List<HashMap<String, String>> cardsearchINprojectList = null;
		
		if(("list").equals(sel3Val)) {
			cardsearchINprojectList = service.getSearchcardINproject(map);
			
			if(cardsearchINprojectList != null && cardsearchINprojectList.size() > 0) {
				for(HashMap<String, String> searchINprojectMap : cardsearchINprojectList) {
					JSONObject jsonObj = new JSONObject();
					
					jsonObj.put("fk_project_idx", searchINprojectMap.get("fk_project_idx"));
					jsonObj.put("fk_list_idx", searchINprojectMap.get("fk_list_idx"));
					jsonObj.put("card_idx", searchINprojectMap.get("card_idx"));
					jsonObj.put("card_title", searchINprojectMap.get("card_title"));
					
					jsonArr.put(jsonObj);
				}
			}
			
		}
	
		String str_jsonArr = jsonArr.toString();
		req.setAttribute("str_jsonArr", str_jsonArr);
	//	System.out.println("확인중!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"+str_jsonArr);
		
		
		return "listsearchINproject_card.notiles";
				
		
	}
	
	// project : 프로젝트 내 카드 검색 list 알아옴 
	@RequestMapping(value="/cardsearchINproject_list.action", method=RequestMethod.GET)
	public String cardsearchINproject_list(HttpServletRequest req) {
		
		HttpSession session = req.getSession();
	// 	MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String fk_project_idx = req.getParameter("fk_project_idx");
		String sel3Val = req.getParameter("sel3Val");
		String cardsearchINproject = req.getParameter("cardsearchINproject");
		
						
		System.out.println("fk_project_idx"+fk_project_idx);
		System.out.println("sel3Val"+sel3Val);
		System.out.println("cardsearchINproject"+cardsearchINproject);
				
		HashMap<String, String> map = new HashMap<String, String>();
	//	map.put("userid", loginuser.getUserid());
		map.put("fk_project_idx", fk_project_idx);
		map.put("cardsearchINproject", cardsearchINproject);
						
		JSONArray jsonArr = new JSONArray();
		
		List<HashMap<String, String>> cardsearchINprojectList_list = null;
		
		if(("card").equals(sel3Val)) {
			cardsearchINprojectList_list = service.getcardsearchINproject_list(map);
			
			if(cardsearchINprojectList_list != null && cardsearchINprojectList_list.size() > 0) {
				for(HashMap<String, String> cardsearchINprojectMap : cardsearchINprojectList_list) {
					JSONObject jsonObj = new JSONObject();
										
					jsonObj.put("fk_list_idx", cardsearchINprojectMap.get("fk_list_idx"));
					jsonObj.put("list_name", cardsearchINprojectMap.get("list_name"));
					jsonObj.put("list_userid", cardsearchINprojectMap.get("list_userid"));
					jsonObj.put("list_delete_status", cardsearchINprojectMap.get("list_delete_status"));
										
					jsonArr.put(jsonObj);
				}
			}
			
		}
	
		String str_jsonArr = jsonArr.toString();
		req.setAttribute("str_jsonArr", str_jsonArr);
			
		return "cardsearchINproject_list.notiles";
				
		
	}
	
	
	// 프로젝트 내에서 리스트를 검색 시 카드 리스트를 불러오는 메소드
	@RequestMapping(value="/cardsearchINproject_card.action", method=RequestMethod.GET)
	public String cardsearchINproject_card(HttpServletRequest req) {
	
		
	//	System.out.println("카드검색 리스트 실행확인");
	//	HttpSession session = req.getSession();
	//	MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String fk_project_idx = req.getParameter("fk_project_idx");
		String sel3Val = req.getParameter("sel3Val");
		String fk_list_idx = req.getParameter("fk_list_idx");
		String cardsearchINproject = req.getParameter("cardsearchINproject");
		
		/*System.out.println("fk_project_idx"+fk_project_idx);
		System.out.println("sel3Val"+sel3Val);
		System.out.println("fk_list_idx"+fk_list_idx);
		System.out.println("cardsearchINproject"+cardsearchINproject);*/
		
		HashMap<String, String> map = new HashMap<String, String>();
	//	map.put("userid", loginuser.getUserid());
		map.put("fk_project_idx", fk_project_idx);
		map.put("fk_list_idx", fk_list_idx);
		map.put("cardsearchINproject", cardsearchINproject);
		
		JSONArray jsonArr = new JSONArray();
		
		List<HashMap<String, String>> cardsearchINprojectList_card = null;
		
		if(("card").equals(sel3Val)) {
			cardsearchINprojectList_card = service.getcardsearchINproject_card(map);
			
			if(cardsearchINprojectList_card != null && cardsearchINprojectList_card.size() > 0) {
				for(HashMap<String, String> searchINprojectMap : cardsearchINprojectList_card) {
					JSONObject jsonObj = new JSONObject();
					
					jsonObj.put("fk_project_idx", searchINprojectMap.get("fk_project_idx"));
					jsonObj.put("fk_list_idx", searchINprojectMap.get("fk_list_idx"));
					jsonObj.put("card_idx", searchINprojectMap.get("card_idx"));
					jsonObj.put("card_title", searchINprojectMap.get("card_title"));
					
					jsonArr.put(jsonObj);
				}
			}
			
		}
	
		String str_jsonArr = jsonArr.toString();
		req.setAttribute("str_jsonArr", str_jsonArr);
		// System.out.println("확인중!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"+str_jsonArr);
		
		
		return "cardsearchINproject_card.notiles";
				
		
	}
	
	@RequestMapping(value="/personalAlarm.action", method=RequestMethod.GET)
	public String personalAlarmProjectList(HttpServletRequest req, HttpServletResponse res) {
	
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		String userid = loginuser.getUserid();
				
		int newmsg = service.getNewMessageCount(userid); // user가 읽지 않은 메시지의 갯수를 얻어옴
		
		// System.out.println("controller msg >>>>>" + newmsg);
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
		
		//System.out.println("checkboxVal >>>>>>>>>>>>>>>" + checkboxVal);
		
		int n = service.setPersonal_alarm_read_status(checkboxVal);// personal_alarm_read_status 변경
		
		JSONArray jsonArr = new JSONArray();
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		jsonArr.put(jsonObj);
		String str_jsonArr = jsonArr.toString();
		req.setAttribute("str_jsonArr", str_jsonArr);
		
		//System.out.println("성공했다.>>>>>>>>>>>>>>>>>" + n);
		
		
	   return "personalAlarmCheckbox.notiles";
	}
	

	//생성된 프로젝트 페이지로 이동하는 메소드
	@RequestMapping(value="/projectRe_list.action", method= {RequestMethod.GET})
	public String showProjectPage_list(HttpServletRequest req) {
		
		String project_idx= req.getParameter("project_idx");
		
				
		HttpSession session = req.getSession();	
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
				
		if(loginuser != null) {
						
			// 프로젝트의 리스트 목록을 가져오는 메소드
			List<ListVO> listvo = null;
			listvo = service.getListInfo(project_idx);
									
			JSONArray jsonArr = new JSONArray();
			
			if(listvo.size() > 0) {
				
				for( ListVO list_vo :listvo) {
					
					JSONObject jsonObj = new JSONObject();
										
					jsonObj.put("list_idx", list_vo.getList_idx());
					jsonObj.put("fk_project_idx", list_vo.getFk_project_idx());
					jsonObj.put("list_name", list_vo.getList_name());
					jsonObj.put("list_delete_status", list_vo.getList_delete_status());
								
					jsonArr.put(jsonObj);
					
				}
			}
			
			String str_jsonArr = jsonArr.toString();
			req.setAttribute("str_jsonArr", str_jsonArr);
			
		}
		return "projectRe_list.notiles";
	} // end of showProjectPage(HttpServletRequest request)

	
	@RequestMapping(value="/projectRe_card.action", method= {RequestMethod.GET})
	public String showProjectPage_cardlist(HttpServletRequest req) {
		
	//	String project_name = req.getParameter("project_name");
		String project_idx= req.getParameter("projectIDX");
		
		List<ListVO> listvo = null;
		listvo = service.getListInfo(project_idx);
		
		List<CardVO> cardlist = null;
		JSONArray jsonArr = new JSONArray();
		
		for(int i=0; i<listvo.size(); i++) {
			//프로젝트에 포함된 리스트의 카드목록을 가져오는 메소드
				
			cardlist = service.getCardInfo(listvo.get(i).getList_idx());
			
			for( CardVO cardvo :cardlist) {
				
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
		
		return "projectRe_card.notiles";
		
	}
	
}
