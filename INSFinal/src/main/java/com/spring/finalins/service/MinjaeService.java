package com.spring.finalins.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.finalins.model.CardVO;
import com.spring.finalins.model.InterMinjaeDAO;
import com.spring.finalins.model.ListVO;
import com.spring.finalins.model.MemberVO;
import com.spring.finalins.model.ProjectMemeberVO;
import com.spring.finalins.model.ProjectVO;
import com.spring.finalins.model.TeamVO;

@Service
public class MinjaeService implements InterMinjaeServie {

	@Autowired
	private InterMinjaeDAO dao;

	// ========================================================== PROJECTBUTTON ========================================================================================
	// header : 로그인한 userid의 팀의 리스트를 얻음
	@Override
	public List<TeamVO> getTeamList(String userid) {
		
		List<TeamVO> teamList = dao.getTeamList(userid);
				
		return teamList;
	}
	
	// header : 해당 user의 팀에 해당하는 프로젝트 리스트를 얻음
	@Override
	public List<HashMap<String, String>> getProjectList(HashMap<String, String> map) {
		
		List<HashMap<String, String>> projectList = dao.getProjectList(map);
		
		return projectList;
	}

	// ========================================================== SEARCH ========================================================================================
	// header : 검색을 위해 teamList 를 얻음
	@Override
	public List<TeamVO> getSearch_team(String search_input) {
		
		List<TeamVO> teamList = dao.getSearch_team(search_input);
		
		return teamList;
	}

	@Override
	public List<ProjectVO> getSearch_project(HashMap<String, String> map) {
		
		List<ProjectVO> projectList = dao.getSearch_project(map);
		
		return projectList;
	}
	
	@Override
	public List<ListVO> getSearch_list(HashMap<String, String> map) {
		
		List<ListVO> listList = dao.getSearch_list(map);
		
		return listList;
	}

	@Override
	public List<CardVO> getSearch_card(HashMap<String, String> map) {
		
		List<CardVO> cardList = dao.getSearch_card(map);
		
		return cardList;
	}

	@Override
	public List<HashMap<String, String>> getSearch_member(String search_input) {

		List<HashMap<String, String>> memberList = dao.getSearch_member(search_input);
		
		return memberList;
	}

	// project 탈퇴시 project_member의 userid 와 admin_status 를 얻어옴
	@Override
	public List<ProjectMemeberVO> getProjectCorrect(String fk_project_idx) {
		
		List<ProjectMemeberVO> projectmemberList = dao.getProjectCorrect(fk_project_idx);
		
		return projectmemberList;
	}

	// 프로젝트의 일반 유저일 경우 프로젝트 탈퇴
	@Override
	public int generalProjectLeave(HashMap<String, String> map) {
		
		int n = dao.generalProjectLeave(map);
		
		return n;
	}

	
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int adminProjectLeave(HashMap<String, String> map) throws Throwable {
		
		int n = dao.adminProjectLeave(map); // 프로젝트의 관리자일 경우 프로젝트 탈퇴
		
		int m = 0;
		
		if(n==1) {
			String project_member_idxMin = dao.adminProjectNextPerson1(map); // 프로젝트의 관리자일 경우 프로젝트 탈퇴 할 때 해당하는 프로젝트의 다른사람 목록을 알아 온다.
			
			m = dao.adminProjectNextPerson2(project_member_idxMin); // 프로젝트의 관리자일 경우 프로젝트를 탈퇴 할 때 다음 사람에게 권한을 위임함.
			
		}
		
		return m;
	}

	// 삭제하기 위해 adminList를 갖고옴
	@Override
	public List<HashMap<String, String>> getAdminList() {
		
		List<HashMap<String, String>> adminList = dao.getAdminList();
		
		return adminList;
	}

	@Override
	public int deleteProject(String fk_project_idx) {
		
		int n = dao.deleteProject(fk_project_idx); // ins_project 테이블에서의 project_delete_status = 0 
						
		int m =0;
		
		if(n == 1) {
			m = dao.deleteProjectMember(fk_project_idx); // ins_project_member 테이블에서의 project_member_status = 1 project_favorite_status = 0
			
			return n+m;
		}
		else {
			return -1;
		}
		
	}

	@Override
	public List<HashMap<String, String>> projectRecordView(HashMap<String, String> map) {
		
		List<HashMap<String, String>> projectRecordList = dao.projectRecordView(map);
		
		return projectRecordList;
	}

	@Override
	public List<HashMap<String, String>> getSearchlistINproject(HashMap<String, String> map) {
		
		List<HashMap<String, String>> searchINprojectList = dao.getSearchlistINproject(map);
		
		return searchINprojectList;
	}

    // user가 읽지 않은 메시지의 갯수를 얻어옴
	@Override
	public int getNewMessageCount(String userid) {
		
		int newmsg = dao.getNewMessageCount(userid);
		
		// System.out.println("service 에서 newmsg1111111111111111111111"+newmsg);
		
		return newmsg;
	}

	// user가 읽지 않은 메세지의 리스트를 얻어옴
	@Override
	public List<HashMap<String, String>> getNewMessageList(String userid) {
		
		List<HashMap<String, String>> nesMsgList = dao.getNewMessageList(userid);
		
		return nesMsgList;
	}

	// personl_alarm 테이블의 personal_alarm_read_status 변경
	@Override
	public int setPersonal_alarm_read_status(String checkboxVal) {
		
		int n = dao.setPersonal_alarm_read_status(checkboxVal);
		
		return n;
	}

	
	
	
	
}
