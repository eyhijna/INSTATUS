package com.spring.finalins.model;

import java.util.HashMap;
import java.util.List;

public interface InterStarDAO {

	int createTeam(HashMap<String, String> map); // 팀생성하기 
	
	TeamVO myTeamInfo(HashMap<String, String> map); // 팀정보 가져오기
	
	int editTeam(HashMap<String, String> map); // 팀명수정하기  
	
	TeamVO getInfoTeam(String team_idx); //변경된 팀정보 가져오기 (JSON)
	
	int insertTeamMember(HashMap<String, String> map); // 팀멤버테이블 insert 하는 메소드

	TeamMemberVO teamMemberInfo(HashMap<String, String> map); // 팀idx에 해당하는 팀멤버테이블 VO를 가져오는 메소드

	int checkMemberExist(HashMap<String, String> map); // AOP에서 팀멤버테이블에 이미 해당유저가 존재하는지 체크해주는 메소드

	int updateViewStatus(HashMap<String, String> map); // 팀공개컬럼을 update해주는 메소드

	int countMember(HashMap<String, String> map); // 나를 제외한 팀원이 있는지 count해오는 메소드

	List<MemberVO> getTeamMembers(HashMap<String, String> map); // 팀원들의 정보를 가져오는 메소드

	List<TeamVO> getTeamListJSON(String userid); // 내가 가입한 팀목록을 불러오는 메소드 
	int getcountTeam(String userid); // 내가 가입한 팀 갯수를 세어오기  

	List<HashMap<String, Integer>> getTeamMembersMap(HashMap<String, Integer> map); // 팀멤버들의 정보를 Hashmap으로 받아오는 메소드

	List<HashMap<String, String>> getSearchMember(HashMap<String, String> map); // 멤버검색 JSON 으로 받아오기 

	int checkAdmin(String team_idx);  // 부관리자가 있는지 조회해오는 메소드

	int chgTo2ndAdmin(HashMap<String, String> map); // 부관리자로 권한을 변경해주는 메소드

	int chgToAdmin(HashMap<String, String> map); //운영자로 update해주는 메소드
	int updateAdminUser(HashMap<String, String> map); // team_member테이블에 운영자 status로 변경 
	int updateOldAdmin(HashMap<String, String> map); // 구 운영자를 일반사용자로 변경
	
	int chgToNormal(HashMap<String, String> map);// 회원 권한을  일반사용자로 바꾸는 메소드 

	int inviteMember(HashMap<String, String> map); // 검색한 멤버를 초대하는 메소드 

	List<HashMap<String, Integer>> joinMemberList(HashMap<String, Integer> map); // 팀 가입을 요청한 회원들의 정보를 가져온다.

	int acceptMember(HashMap<String, String> map); // 팀 가입을 요청한 회원을 수락하는 메소드 

	int declineMember(HashMap<String, String> map); // 팀 가입을 원한 멤버의 요청을 거절하는 메소드

	int updateTeamPic(TeamVO teamvo); // 파일첨부가 완료되면 사진을 등록해주는 메소드

	int leaveTeam(HashMap<String, String> map); // 팀을 탈퇴할때 delete해주는 메소드

	List<HashMap<String, String>> searchMyTmember(HashMap<String, String> map); // 검색했을때 검색어에 해당되는 회원들의 정보를 가져옴(관리자가 아닌 회원이 자신의 팀내에서 멤버검색)

	List<TeamMemberVO> myTeamMemberList(String team_idx); //팀멤버들의 정보를 가져오는 메소드

	int count2Admin(String team_idx); // 부운영자 갯수를 가져오는 메소드 

	int totalMemberCount(String team_idx); // 나 자신을 포함한 팀원의 총 갯수를 가져오는 메소드

	List<HashMap<String, String>> getSearchExceptTeamMember(HashMap<String, String> map);  // 검색했을때 검색어에 해당되는 회원들의 정보를 가져옴(멤버가 존재하고 그외의 회원들을 관리자가 조회하는 검색창)

	int joinMemberCount(String team_idx); // 가입신청을 한 멤버의갯수를 가져온다 

	int breakTeam(String team_idx); // 팀 해체버튼을 눌렀을때 호출되는 메소드

	int projectCnt(HashMap<String, String> map1); // 내가 포함된 팀 프로젝트 총 갯수 가져오기 

	List<ProjectVO> getProjectList(HashMap<String, String> map2); // 내가 포함된 프로젝트를 불러오는 메소드
 
	

	

}
