package com.spring.finalins.service;

import java.util.HashMap;
import java.util.List;

import com.spring.finalins.model.MemberVO;
import com.spring.finalins.model.TeamMemberVO;
import com.spring.finalins.model.TeamVO;

public interface InterStarService {

	int createTeam(HashMap<String, String> map); // 팀생성하기 
	
	TeamVO myTeamInfo(HashMap<String, String> map); // 팀정보(teamVO)가져오기 
	
	int editTeam(HashMap<String, String> map); // 팀명바꾸기
	
	String getInfoTeam(String team_idx); // 바뀐 팀 정보 가져오기 JSON
	
	TeamVO teamInfoVO(String team_idx); // 새로고침 했을때 가져오는 TeamVO 
	
	int insertTeamMember(HashMap<String, String> map); // 팀멤버 테이블을 생성하는 메소드 (AOP-After)

	TeamMemberVO teamMemberInfo(HashMap<String, String> map); // 팀idx에 해당하는 팀멤버VO 를 가져오는 메소드

	int checkMemberExist(HashMap<String, String> map); // 팀idx에 isnert하기 전에 해당 userid가 존재하는지 확인하는 메소드
 
	int updateViewStatus(HashMap<String, String> map); // 팀공개컬럼 update하기

	int countMember(HashMap<String, String> map); // 나를 제외한 팀원이 있는지 count해오는 메소드

	List<MemberVO> getTeamMembers(HashMap<String, String> map); // 팀원들의 정보를 가져오는 메소드

	String getMembersJSON(HashMap<String, Integer> map); // 팀에 포함된 멤버들 정보 가져오기 JSON

	String getTeamListJSON(String userid); // 내가 가입한 팀목록 가져오기 JSON 
	int getcountTeam(String userid); // 내가 가입한 팀 갯수 세오기

	String getSearchMember(HashMap<String, String> map); // 멤버검색 JSON 으로 받아오기 

	int checkAdmin(String team_idx); // 부관리자가 있는지 조회해오는 메소드

	int chgTo2ndAdmin(HashMap<String, String> map); // 부관리자로 권한을 변경해주는 메소드

	int chgToAdmin(HashMap<String, String> map); // 운영자로 update해주는 메소드
	int updateAdminUser(HashMap<String, String> map); // team_member테이블에 운영자 status로 변경 
	int updateOldAdmin(HashMap<String, String> map); //기존의 관리자는 일반사용자로 변경
	
	
	int chgToNormal(HashMap<String, String> map); // 일반사용자로 update 해주는 메소드 

	int inviteMember(HashMap<String, String> map); // 검색한 멤버를 초대하는 메소드 

	String joinMemberList(HashMap<String, Integer> map); // 팀 가입을 요청한 회원들의 정보를 가져온다.

	int acceptMember(HashMap<String, String> map); // 팀 가입을 요청한 회원을 수락하는 메소드 

	int declineMember(HashMap<String, String> map); // 팀 가입을 원한 멤버의 요청을 거절하는 메소드

	int updateTeamPic(TeamVO teamvo); // 파일첨부가 완료되면 사진을 등록해주는 메소드

	int leaveTeam(HashMap<String, String> map); // 팀을 탈퇴할때 delete해주는 메소드

	String getSearchMyTMember(HashMap<String, String> map); // 검색했을때 검색어에 해당되는 회원들의 정보를 가져옴(관리자가 아닌 회원이 자신의 팀내에서 멤버검색)
 
	String myTeamMemberList(String team_idx); //팀멤버들의 정보를 가져오는 메소드

	int count2Admin(String team_idx); // 부운영자 갯수를 가져오는 메소드 

	int totalMemberCount(String team_idx); // 나 자신을 포함한 팀원의 총 갯수를 가져오는 메소드

	String getSearchExceptTeamMember(HashMap<String, String> map);  // 검색했을때 검색어에 해당되는 회원들의 정보를 가져옴(멤버가 존재하고 그외의 회원들을 관리자가 조회하는 검색창)

	int joinMemberCount(String str_team_idx); // 가입신청을 한 멤버의갯수를 가져온다 

	int breakTeam(String team_idx); // 팀 해체버튼을 눌렀을때 호출되는 메소드

	String getProjectList(HashMap<String, String> map2); // 내가 포함된 프로젝트를 불러오는 메소드

	int projectCnt(HashMap<String, String> map1); // 내가 포함된 팀 프로젝트 총 갯수 가져오기 

	List<TeamMemberVO> teamMemberList(String team_idx); // 팀의 회원정보들을 불러오는 메소드

	int wantJoinTeam(HashMap<String, String> map); // 회원이 팀가입을 요청할때

	int publicProjectCnt(String team_idx); // public인 프로젝트 갯수알아오기 

	String getPublicProjectList(HashMap<String, String> map2); // public인 프로젝트를 가져온다.
 

	

	


}
