package com.spring.finalins.service;

import java.util.HashMap;
import java.util.List;

import com.spring.finalins.model.CardVO;
import com.spring.finalins.model.ListVO;
import com.spring.finalins.model.MemberVO;
import com.spring.finalins.model.TeamMemberVO;


public interface InterProjectService {

	//로그인 처리를 하는 메소드
	MemberVO getLogin(HashMap<String, String> map);
	
	//로그인 한 유저의 팀리스트를 가져오는 메소드
	List<HashMap<String, String>> getTeamList(String userid);

	//회원가입 요청을 처리하는 메소드  
	int signupEnd(MemberVO mvo);

	//아이디 중복체크를 하는 메소드
	int idcheck(String useridCheck);

	//팀의 노출값을 가져오는 메소드
	HashMap<String, String> getTeamVS(HashMap<String, String> userInfo);

	//프로젝트를 생성하는 메소드
	int insertProject(HashMap<String, String> project_info);
	//프로젝트를 생성하면서 팀 멤버를 인서트하는 경우
	int insertProject(HashMap<String, String> project_info, String[] memberIdArr);
	
	//로그인 한 유저의 프로젝트리스트를 가져오는 메소드
	List<HashMap<String, String>> getProjectList(String userid);

	//유저가 접속한 프로젝트의 정보를 가져오는 메소드
	HashMap<String, String> getProjectInfo(HashMap<String, String> map);

	//프로젝트의 즐겨찾기 상태를 변경하는 메소드
	int updateFavoriteStatus(HashMap<String, String> map);

	//project_idx로 배경이미지 테이블에서 프로젝트의 배경이미지명을 가져오는 메소드
	String getBackgroundIMG(String project_idx);

	//프로젝트의 리스트 목록을 가져오는 메소드
	List<ListVO> getListInfo(String project_idx);

	//비밀번호찾기에서 이메일과 id로 일치하는 회원이 있는지 확인하는 메소드
	int emailCheck(HashMap<String, String> map);

	//회원가입 폼에서 이메일 중복체크하는 메소드
	int signupEmailcheck(String emailCheck);

	//email로 가입된 유저의 아이디를 가져오는 메소드
	String getuserID(String emailCheck);

	//배경이미지테이블의 데이터를 가져오는 메소드
	List<HashMap<String, String>> getProjectImg();

	//새로운 리스트를 생성하는 메소드
	int addList(HashMap<String, String> map);

	//프로젝트에 포함된 리스트의 카드목록을 가져오는 메소드
	List<CardVO> getCardInfo(String list_idx);

	//새로운 카드를 생성하는 메소드
	int addCard(HashMap<String, String> map);

	//메인페이지에서 비밀번호 변경하는 메소드 
	int changePassword(HashMap<String, String> map);

	//리스트 제목을 변경하는 메소드
	String updateListTitle(HashMap<String, String> map);

	//리스트 생성 ajax처리를 위한 insert된 리스트 정보를 가져오는 메소드
	ListVO getListOne(HashMap<String, String> map);

	//프로젝트에 소속되어 있는 프로젝트 멤버의 정보를 가져오는 메소드
	List<HashMap<String, String>> getProjectMemberInfo(String project_idx);

	//팀 idx를 받아와서 팀멤버vo 정보를 불러오는 메소드 
	List<TeamMemberVO> getTeamMemberInfo(HashMap<String, String> map);
	
	//리스트 삭제
	int updateListDeleteStatus(HashMap<String, String> map);

	public List<HashMap<String, String>> getArchive(String project_idx);
}
