package com.spring.finalins.service;

import java.util.HashMap;
import java.util.List;

import com.spring.finalins.model.CardVO;
import com.spring.finalins.model.ListVO;
import com.spring.finalins.model.MemberVO;
import com.spring.finalins.model.ProjectMemeberVO;
import com.spring.finalins.model.ProjectVO;
import com.spring.finalins.model.TeamVO;

public interface InterMinjaeServie {

	List<TeamVO> getTeamList(String userid); // header : 로그인한 userid의 팀의 리스트를 얻음

	List<HashMap<String, String>> getProjectList(HashMap<String, String> map); // header : 해당 user의 팀에 해당하는 프로젝트 리스트를 얻음

	List<TeamVO> getSearch_team(String search_input); // header : 검색을 위해 teamList 를 얻음

	List<ProjectVO> getSearch_project(HashMap<String, String> map); // header : 검색을 위해 projectList 를 얻음
	
	List<HashMap<String, String>> getSearch_list(HashMap<String, String> map);// header : 검색을 위해 listList 를 얻음

	List<HashMap<String, String>> getSearch_card(HashMap<String, String> map);// header : 검색을 위해 cardList 를 얻음

	List<HashMap<String, String>> getSearch_member(String search_input); // header : 검색을 위해 memberList 를 얻음

	List<ProjectMemeberVO> getProjectCorrect(String fk_project_idx); // project : project 탈퇴시 project_member의 userid 와 admin_status 를 얻어옴

	int generalProjectLeave(HashMap<String, String> map); // project : 프로젝트의 일반 유저일 경우 프로젝트 탈퇴

	int adminProjectLeave(HashMap<String, String> map) throws Throwable; // project :  프로젝트의 관리자일 경우 프로젝트 탈퇴

	String getAdmin(String fk_project_idx); // project : 삭제하기 위해 admin 갖고옴

	int deleteProject(String fk_project_idx); // project : 프로젝트의 관리자일 경우 프로젝트 삭제 

	List<HashMap<String, String>> projectRecordView(HashMap<String, String> map); // project : 프로젝트 기록을 얻어옴

	int getNewMessageCount(String userid); // user가 읽지 않은 메시지의 갯수를 얻어옴

	List<HashMap<String, String>> getNewMessageList(String userid); // user가 읽지 않은 메세지의 리스트를 얻어옴

	int setPersonal_alarm_read_status(String checkboxVal); // personl_alarm 테이블의 personal_alarm_read_status 변경

	int projectList_updateFavoriteStatus(HashMap<String, String> map); // projectList의 favorite_status를 변경

	List<HashMap<String, String>> getSearchlistINproject(HashMap<String, String> map); // project : 프로젝트 내 리스트 검색
	
	List<HashMap<String, String>> getSearchcardINproject(HashMap<String, String> map); // project : 프로젝트 내 리스트 검색 카드 리스트

	List<HashMap<String, String>> getcardsearchINproject_list(HashMap<String, String> map); // project : 프로젝트 내 카드 검색 list 알아옴

	List<HashMap<String, String>> getcardsearchINproject_card(HashMap<String, String> map); // project : 프로젝트 내 카드 검색 card 알아옴

	List<ListVO> getListInfo(String project_idx); // project : 프로젝트 내 전체 리스트 받아옴 

	List<CardVO> getCardInfo(String list_idx); // project : 프로젝트 내 전체 카드 받아옴
	

	

	

	 
}
