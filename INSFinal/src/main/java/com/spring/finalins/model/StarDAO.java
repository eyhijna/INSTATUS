package com.spring.finalins.model;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class StarDAO implements InterStarDAO {
	 
	
	@Autowired
	private SqlSessionTemplate sqlsession;
	
	// 팀생성하기 
	@Override
	public int createTeam(HashMap<String, String> map) {
		int n = sqlsession.insert("star.createTeam", map);
		return n;
	}
	
	// 팀정보 가져오기
	@Override
	public TeamVO myTeamInfo(HashMap<String, String> map) {
		TeamVO teamvo = sqlsession.selectOne("star.myTeamInfo",map);
		return teamvo;
	}
	
	// 팀명수정하기  
	@Override
	public int editTeam(HashMap<String, String> map) {
		int n = sqlsession.update("star.editTeam", map);
		return n;
	}
 
	//변경된 팀정보 가져오기 (JSON)
	@Override
	public TeamVO getInfoTeam(String team_idx) {
		TeamVO teamEditvo = sqlsession.selectOne("star.getInfoTeam", team_idx);
		return teamEditvo;
	}
	
	// 팀멤버테이블 insert 하는 메소드
	@Override
	public int insertTeamMember(HashMap<String, String> map) {
		int n = sqlsession.insert("star.insertTeamMember", map);
		return n;
	}

	// 팀idx에 해당하는 팀멤버테이블 VO를 가져오는 메소드
	@Override
	public TeamMemberVO teamMemberInfo(HashMap<String, String> map) {
		TeamMemberVO tmvo = sqlsession.selectOne("star.teamMemberInfo", map);
		return tmvo;
	} 
   
	// 내가 중복으로 들어가 있는지 체크해주는 메소드 
	@Override
	public int checkMemberExist(HashMap<String, String> map) {
		int m = sqlsession.selectOne("star.checkMemberExist", map);
		return m;
	}
  
	// 팀 공개설정 업데이트 해주는 메소드
	@Override
	public int updateViewStatus(HashMap<String, String> map) {
		int n = sqlsession.update("star.updateViewStatus", map);
		return n;
	}
	
	// 나를 제외한 팀원이 있는지 count해오는 메소드
	@Override
	public int countMember(HashMap<String, String> map) {
		int n = sqlsession.selectOne("star.countMember", map);
		return n;
	}

	@Override
	public List<MemberVO> getTeamMembers(HashMap<String, String> map) {
		List<MemberVO> memberList = sqlsession.selectList("star.getTeamMembers", map);
		return memberList;
	}

	@Override
	public List<TeamVO> getTeamListJSON(String userid) {
		List<TeamVO> teamList = sqlsession.selectList("star.getTeamListJSON", userid);
		return teamList;
	}

	@Override
	public int getcountTeam(String userid) {
		int n = sqlsession.selectOne("star.getcountTeam", userid);
		return n;
	}

	@Override
	public List<HashMap<String, Integer>> getTeamMembersMap(HashMap<String, Integer> map) {
		List<HashMap<String, Integer>> mapList = sqlsession.selectList("star.getTeamMembersMap", map);
		return mapList; 
	}
	
	// 멤버검색 JSON 으로 받아오기 
	@Override
	public List<HashMap<String, String>> getSearchMember(HashMap<String, String> map) {
		List<HashMap<String, String>> memberList = sqlsession.selectList("star.searchMember", map);
	    return memberList;
	}

	@Override
	public int checkAdmin(String team_idx) {
		int n = sqlsession.selectOne("star.checkAdmin", team_idx);
		return n;
	}

	@Override
	public int chgTo2ndAdmin(HashMap<String, String> map) {
		int m = sqlsession.update("star.chgTo2ndAdmin", map);
		return m;
	}

	@Override
	public int chgToAdmin(HashMap<String, String> map) {
		int n = sqlsession.update("star.chgToAdmin", map);
		return n;
	}
	
	// 회원 권한을  일반사용자로 바꾸는 메소드 
	@Override
	public int chgToNormal(HashMap<String, String> map) {
		int n = sqlsession.update("star.chgToNormal", map);
		return n;
	}

	@Override
	public int updateAdminUser(HashMap<String, String> map) {
		int n = sqlsession.update("star.updateAdminUser", map);
		return n;
	}

	@Override
	public int updateOldAdmin(HashMap<String, String> map) {
		int n = sqlsession.update("star.updateOldAdmin", map);
		return n;
	}

	@Override
	public int inviteMember(HashMap<String, String> map) {
		int n = sqlsession.insert("star.inviteMember", map);
		return n;
	}

	@Override
	public List<HashMap<String, Integer>> joinMemberList(HashMap<String, Integer> map) {
		List<HashMap<String, Integer>> memberList = sqlsession.selectList("star.joinMemberList", map);
		return memberList;
	}

	@Override
	public int acceptMember(HashMap<String, String> map) {
		int n = sqlsession.update("star.acceptMember", map);
		return n;
	}

	@Override
	public int declineMember(HashMap<String, String> map) {
		int n = sqlsession.delete("star.declineMember", map);
		return n;
	}

	@Override
	public int updateTeamPic(TeamVO teamvo) {
		int n = sqlsession.update("star.updateTeamPic", teamvo);
		return n;
	}

	@Override
	public int leaveTeam(HashMap<String, String> map) {
		int n = sqlsession.delete("star.leaveTeam", map); 
		return n;
	}

	@Override
	public List<HashMap<String, String>> searchMyTmember(HashMap<String, String> map) {
		List<HashMap<String, String>> memberList = sqlsession.selectList("star.searchMyTmember", map);
		return memberList;
	}

	@Override
	public List<TeamMemberVO> myTeamMemberList(String team_idx) {
		List<TeamMemberVO> memberList = sqlsession.selectList("star.myTeamMemberList", team_idx);
		return memberList;
	}

	@Override
	public int count2Admin(String team_idx) {
		int n = sqlsession.selectOne("star.count2Admin", team_idx);
		return n;
	}

	@Override
	public int totalMemberCount(String team_idx) {
		int totalCount = sqlsession.selectOne("star.totalMemberCount", team_idx);
		return totalCount;
	}

	@Override
	public List<HashMap<String, String>> getSearchExceptTeamMember(HashMap<String, String> map) {
		List<HashMap<String, String>> memberList = sqlsession.selectList("star.getSearchExceptTeamMember", map);
	    return memberList;
	}
	
	// 가입신청을 한 멤버의갯수를 가져온다 
	@Override
	public int joinMemberCount(String team_idx) {
		int totalCount = sqlsession.selectOne("star.joinMemberCount", team_idx); 
		return totalCount;
	}

	// 팀 해체버튼을 눌렀을때 호출되는 메소드
	@Override
	public int breakTeam(String team_idx) {
		int m =  sqlsession.update("star.breakTeam", team_idx);
		return m;
	}

	@Override
	public int projectCnt(HashMap<String, String> map1) {
		int totalCount = sqlsession.selectOne("star.projectCnt", map1);
		return totalCount;
	}

	@Override
	public List<ProjectVO> getProjectList(HashMap<String, String> map2) {
		List<ProjectVO> projectList = sqlsession.selectList("star.getProjectList", map2);
		return projectList;
	}
 
}
