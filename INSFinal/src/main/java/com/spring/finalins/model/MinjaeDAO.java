package com.spring.finalins.model;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MinjaeDAO implements InterMinjaeDAO {

	@Autowired
	private SqlSessionTemplate sqlsession;

	// ========================================================== PROJECTBUTTON ========================================================================================
	// header : 로그인한 userid의 팀의 리스트를 얻음
	@Override
	public List<TeamVO> getTeamList(String userid) {
		
		List<TeamVO> teamList = sqlsession.selectList("mj.getTeamList", userid);
		
		System.out.println("DAO teamList" + teamList);
		
		return teamList;
	}

	// header : 해당 user의 팀에 해당하는 프로젝트 리스트를 얻음
	@Override
	public List<ProjectVO> getProjectList(HashMap<String, String> map) {
		
		List<ProjectVO> projectList = sqlsession.selectList("mj.getProjectList", map);
				
		return projectList;
	}

	// ========================================================== SEARCH ========================================================================================
	// header : 검색을 위해 teamList 를 얻음
	@Override
	public List<TeamVO> getSearch_team(String search_input) {
		
		List<TeamVO> teamList = sqlsession.selectList("mj.getSearch_team", search_input);
		
		return teamList;
	}

	@Override
	public List<ProjectVO> getSearch_project(HashMap<String, String> map) {
	
		List<ProjectVO> projectList = sqlsession.selectList("mj.getSearch_project", map);
		
		return projectList;
	}
	
	@Override
	public List<ListVO> getSearch_list(HashMap<String, String> map) {
		
		List<ListVO> listList = sqlsession.selectList("mj.getSearch_list", map);
		
		return listList;
	}
	
	@Override
	public List<CardVO> getSearch_card(HashMap<String, String> map) {
		
		List<CardVO> cardList = sqlsession.selectList("mj.getSearch_card", map);
		
		return cardList;
	}

	@Override
	public List<HashMap<String, String>> getSearch_member(String search_input) {
		
		List<HashMap<String, String>> memberList = sqlsession.selectList("mj.getSearch_member", search_input);
		
		return memberList;
	}

	// project 탈퇴시 project_member의 userid 와 admin_status 를 얻어옴
	@Override
	public List<ProjectMemeberVO> getProjectCorrect(String fk_project_idx) {
		
		List<ProjectMemeberVO> projectmemberList = sqlsession.selectList("mj.getProjectCorrect", fk_project_idx);
		
		return projectmemberList;
	}

	@Override
	public int generalProjectLeave(HashMap<String, String> map) {
		
		int n = sqlsession.update("mj.generalProjectLeave", map);
		
		return n;
	}

	@Override
	public int adminProjectLeave(HashMap<String, String> map) {
		
		int n = sqlsession.update("mj.adminProjectLeave", map);
		
		return n;
	}

	@Override
	public String adminProjectNextPerson1(HashMap<String, String> map) {
		
		String project_member_idxMin = sqlsession.selectOne("mj.adminProjectNextPerson1", map);
		
		return project_member_idxMin;
	}

	@Override
	public int adminProjectNextPerson2(String project_member_idxMin) {
		
		int m = sqlsession.update("mj.adminProjectNextPerson2", project_member_idxMin);
		
		return m;
	}

	
	 // 삭제하기 위해 adminList를 갖고옴
	@Override
	public List<HashMap<String, String>> getAdminList() {
		
		List<HashMap<String, String>> adminList = sqlsession.selectList("mj.getAdminList");
		
		return adminList;
	}

	@Override
	public int deleteProject(String fk_project_idx) {
		
		int n = sqlsession.update("mj.deleteProject", fk_project_idx);
		
		return n;
	}

	@Override
	public int deleteProjectMember(String fk_project_idx) {
		
		int n = sqlsession.update("mj.deleteProjectMember", fk_project_idx);
		
		return n;
	}

	@Override
	public List<HashMap<String, String>> projectRecordView(HashMap<String, String> map) {
	
		List<HashMap<String, String>> projectRecordList = sqlsession.selectList("mj.projectRecordView", map);
	
		return projectRecordList;
	}

	@Override
	public List<HashMap<String, String>> getSearchlistINproject(HashMap<String, String> map) {
		
		List<HashMap<String, String>> searchINprojectList = sqlsession.selectList("mj.getSearchlistINproject", map);
	
		return searchINprojectList;
	}

	// user가 읽지 않은 메시지의 갯수를 얻어옴
	@Override
	public int getNewMessageCount(String userid) {
		
		int newmsg = sqlsession.selectOne("mj.getNewMessageCount", userid);
		
		System.out.println("dao 에서 newmsg22222222222222222222222"+newmsg);
		
		return newmsg;
	}

	@Override
	public List<HashMap<String, String>> getNewMessageList(String userid) {
		
		List<HashMap<String, String>> newMsgList = sqlsession.selectList("mj.getNewMessageList", userid);
		
		return newMsgList;
	}

	@Override
	public int setPersonal_alarm_read_status(String checkboxVal) {
		
		int n = sqlsession.update("mj.setPersonal_alarm_read_status", checkboxVal);
		
		return n;
	}


	
	
	

}
