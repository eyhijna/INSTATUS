package com.spring.finalins.model;

import java.util.HashMap;
import java.util.List;

public interface InterMinjaeDAO {

	List<TeamVO> getTeamList(String userid); // header : 로그인한 userid의 팀의 리스트를 얻음

	List<HashMap<String, String>> getProjectList(HashMap<String, String> map); // header : 해당 user의 팀에 해당하는 프로젝트 리스트를 얻음

	List<TeamVO> getSearch_team(String search_input); // header : 검색을 위해 teamList 를 얻음

	List<ProjectVO> getSearch_project(HashMap<String, String> map); // header : 검색을 위해 projectList 를 얻음
	
	List<HashMap<String, String>> getSearch_list(HashMap<String, String> map); // header : 검색을 위해 listList 를 얻음
	
	List<HashMap<String, String>> getSearch_card(HashMap<String, String> map); // header : 검색을 위해 cardList 를 얻음

	List<HashMap<String, String>> getSearch_member(String search_input); // header : 검색을 위해 memberList 를 얻음

	List<ProjectMemeberVO> getProjectCorrect(String fk_project_idx); // project 탈퇴시 project_member의 userid 와 admin_status 를 얻어옴

	int generalProjectLeave(HashMap<String, String> map); // project: 프로젝트의 일반 유저일 경우 프로젝트 탈퇴

	int adminProjectLeave(HashMap<String, String> map); // project: 프로젝트의 관리자일 경우 프로젝트 탈퇴

	String adminProjectNextPerson1(HashMap<String, String> map); // project: 프로젝트의 관리자일 경우 프로젝트 탈퇴 할 때 해당하는 프로젝트의 다른사람 목록을 알아 온다.
	
	int adminProjectNextPerson2(String project_member_idxMin);  // project: 프로젝트의 관리자일 경우 프로젝트를 탈퇴 할 때 다음 사람에게 권한을 위임함.

	String getAdmin(String fk_project_idx); // project: 삭제하기 위해 admin인지 확인하기 위해 admin 갖고 옴

	int deleteProject(String fk_project_idx); // project: ins_project 테이블에서의 project_delete_status = 0 

	int deleteProjectMember(String fk_project_idx); // project: ins_project_member 테이블에서의 project_member_status = 1 project_favorite_status = 0

	List<HashMap<String, String>> projectRecordView_create(HashMap<String, String> map); // project: 프로젝트 기록의 리스트를 얻어옴(생성)
	
	List<HashMap<String, String>> projectRecordView_else(HashMap<String, String> map); // project: 프로젝트 기록의 리스트를 얻어옴(수정, 삭제, 추가)

	int getNewMessageCount(String userid);  // header : user가 읽지 않은 메시지의 갯수를 얻어옴

	List<HashMap<String, String>> getNewMessageList(String userid); // header : user가 읽지 않은 메세지의 리스트를 얻어옴

	int setPersonal_alarm_read_status(String checkboxVal); // header : personl_alarm 테이블의 personal_alarm_read_status 변경

	int projectList_updateFavoriteStatus(HashMap<String, String> map); // project: projectList의 favorite_status를 변경

	List<HashMap<String, String>> getSearchlistINproject(HashMap<String, String> map); // project: 프로젝트 내에서 list 검색
	
	List<HashMap<String, String>> getSearchcardINproject(HashMap<String, String> map); // project: 프로젝트 내에서 list 검색 card 리스트 

	List<HashMap<String, String>> getcardsearchINproject_list(HashMap<String, String> map); // project: 프로젝트 내에서 card 검색 list 얻어옴

	List<HashMap<String, String>> getcardsearchINproject_card(HashMap<String, String> map); // project: 프로젝트 내에서 card 검색 card 얻어옴

	List<ListVO> getListInfo(String project_idx); // project :  프로젝트의 관리자일 경우 프로젝트 탈퇴

	List<CardVO> getCardInfo(String list_idx);  // project : 삭제하기 위해 adminList를 갖고옴

	

	


	

	

	

	

}
