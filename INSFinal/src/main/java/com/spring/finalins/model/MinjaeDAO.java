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
	public List<HashMap<String, String>> getProjectList(HashMap<String, String> map) {
		
		List<HashMap<String, String>> projectList = sqlsession.selectList("mj.getProjectList", map);
				
		return projectList;
	}

	// ========================================================== SEARCH ========================================================================================
	// header : 검색을 위해 teamList 를 얻음
	@Override
	public List<TeamVO> getSearch_team(String search_input) {
		
		List<TeamVO> teamList = sqlsession.selectList("mj.getSearch_team", search_input);
		
		return teamList;
	}

	// header : 검색을 위해 projectList 를 얻음
	@Override
	public List<ProjectVO> getSearch_project(HashMap<String, String> map) {
	
		List<ProjectVO> projectList = sqlsession.selectList("mj.getSearch_project", map);
		
		return projectList;
	}
	
	// header : 검색을 위해 listList 를 얻음
	@Override
	public List<HashMap<String, String>> getSearch_list(HashMap<String, String> map) {
		
		List<HashMap<String, String>> listList = sqlsession.selectList("mj.getSearch_list", map);
		
		return listList;
	}
	
	// header : 검색을 위해 cardList 를 얻음
	@Override
	public List<HashMap<String, String>> getSearch_card(HashMap<String, String> map) {
		
		List<HashMap<String, String>> cardList = sqlsession.selectList("mj.getSearch_card", map);
		
		return cardList;
	}

	// header : 검색을 위해 memberList 를 얻음
	@Override
	public List<HashMap<String, String>> getSearch_member(String search_input) {
		
		List<HashMap<String, String>> memberList = sqlsession.selectList("mj.getSearch_member", search_input);
		
		return memberList;
	}

	// project : project 탈퇴시 project_member의 userid 와 admin_status 를 얻어옴
	@Override
	public List<ProjectMemeberVO> getProjectCorrect(String fk_project_idx) {
		
		List<ProjectMemeberVO> projectmemberList = sqlsession.selectList("mj.getProjectCorrect", fk_project_idx);
		
		return projectmemberList;
	}

	// project: 프로젝트의 일반 유저일 경우 프로젝트 탈퇴
	@Override
	public int generalProjectLeave(HashMap<String, String> map) {
		
		int n = sqlsession.update("mj.generalProjectLeave", map);
		
		return n;
	}

	// project: 프로젝트의 관리자일 경우 프로젝트 탈퇴
	@Override
	public int adminProjectLeave(HashMap<String, String> map) {
		
		int n = sqlsession.update("mj.adminProjectLeave", map);
		
		return n;
	}

	// project: 프로젝트의 관리자일 경우 프로젝트 탈퇴 할 때 해당하는 프로젝트의 다른사람 목록을 알아 온다.
	@Override
	public String adminProjectNextPerson1(HashMap<String, String> map) {
		
		String project_member_idxMin = sqlsession.selectOne("mj.adminProjectNextPerson1", map);
		
		return project_member_idxMin;
	}

	// project: 프로젝트의 관리자일 경우 프로젝트를 탈퇴 할 때 다음 사람에게 권한을 위임함.
	@Override
	public int adminProjectNextPerson2(String project_member_idxMin) {
		
		int m = sqlsession.update("mj.adminProjectNextPerson2", project_member_idxMin);
		
		return m;
	}

	
	 // project : 삭제하기 위해 admin인지 확인하기 위해 admin을 갖고옴
	@Override
	public String getAdmin(String fk_project_idx) {
		
		String admin = sqlsession.selectOne("mj.getAdminList", fk_project_idx);
		
		return admin;
	}

	// project: ins_project 테이블에서의 project_delete_status = 0
	@Override
	public int deleteProject(String fk_project_idx) {
		
		int n = sqlsession.update("mj.deleteProject", fk_project_idx);
		
		return n;
	}

	// project: ins_project_member 테이블에서의 project_member_status = 1 project_favorite_status = 0
	@Override
	public int deleteProjectMember(String fk_project_idx) {
		
		int n = sqlsession.update("mj.deleteProjectMember", fk_project_idx);
		
		return n;
	}

	// project: 프로젝트 기록의 리스트를 얻어옴(생성)
	@Override
	public List<HashMap<String, String>> projectRecordView_create(HashMap<String, String> map) {
		
		List<HashMap<String, String>> projectRecordList = sqlsession.selectList("mj.projectRecordView_create", map);
		
		return projectRecordList;
	}

	// project : 프로젝트 기록의 리스트를 얻어옴(수정, 삭제, 추가)
	@Override
	public List<HashMap<String, String>> projectRecordView_else(HashMap<String, String> map) {
		
		List<HashMap<String, String>> projectRecordList = sqlsession.selectList("mj.projectRecordView_else", map);
		
		return projectRecordList;
	}



	// header : user가 읽지 않은 메시지의 갯수를 얻어옴
	@Override
	public int getNewMessageCount(String userid) {
		
		int newmsg = sqlsession.selectOne("mj.getNewMessageCount", userid);
		
		System.out.println("dao 에서 newmsg22222222222222222222222"+newmsg);
		
		return newmsg;
	}

	// header : user가 읽지 않은 메세지의 리스트를 얻어옴
	@Override
	public List<HashMap<String, String>> getNewMessageList(String userid) {
		
		List<HashMap<String, String>> newMsgList = sqlsession.selectList("mj.getNewMessageList", userid);
		
		return newMsgList;
	}

	// header : personl_alarm 테이블의 personal_alarm_read_status 변경
	@Override
	public int setPersonal_alarm_read_status(String checkboxVal) {
		
		int n = sqlsession.update("mj.setPersonal_alarm_read_status", checkboxVal);
		
		return n;
	}

	// project: projectList의 favorite_status를 변경
	@Override
	public int projectList_updateFavoriteStatus(HashMap<String, String> map) {
		
		int n = sqlsession.update("mj.projectList_updateFavoriteStatus", map);
		
		return n;
	}
	
	// project: 프로젝트 내에서 list 검색
	@Override
	public List<HashMap<String, String>> getSearchlistINproject(HashMap<String, String> map) {
		
		List<HashMap<String, String>> searchINprojectList = sqlsession.selectList("mj.getSearchlistINproject", map);
	
		return searchINprojectList;
	}

	// project: 프로젝트 내에서 card 검색
	@Override
	public List<HashMap<String, String>> getSearchcardINproject(HashMap<String, String> map) {
		
		List<HashMap<String, String>> cardsearchINprojectList = sqlsession.selectList("mj.getSearchcardINproject", map);
		
		return cardsearchINprojectList;
	}

	// project: 프로젝트 내에서 card 검색 list 얻어옴
	@Override
	public List<HashMap<String, String>> getcardsearchINproject_list(HashMap<String, String> map) {
		
		List<HashMap<String, String>> cardsearchINprojectList_list  = sqlsession.selectList("mj.getcardsearchINproject_list", map);
		
		return cardsearchINprojectList_list;
	}

	// project: 프로젝트 내에서 card 검색  card 얻어옴
	@Override
	public List<HashMap<String, String>> getcardsearchINproject_card(HashMap<String, String> map) {
		
		List<HashMap<String, String>> cardsearchINprojectList_card = sqlsession.selectList("mj.getcardsearchINproject_card", map);
		
		return cardsearchINprojectList_card;
	}
	
	// project :  프로젝트의 관리자일 경우 프로젝트 탈퇴
	@Override
	public List<ListVO> getListInfo(String project_idx) {
		
		List<ListVO> listvo = sqlsession.selectList("dasom.getListInfo", project_idx);
		return listvo;
		
	}

	 // project : 삭제하기 위해 adminList를 갖고옴
	@Override
	public List<CardVO> getCardInfo(String list_idx) {
		List<CardVO> cardlist = sqlsession.selectList("dasom.getCardInfo", list_idx);
		return cardlist;
	}

	

	
	
	

}
