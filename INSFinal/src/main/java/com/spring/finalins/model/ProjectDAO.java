package com.spring.finalins.model;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ProjectDAO implements InterProjectDAO{
	
	@Autowired
	private SqlSessionTemplate sqlsession;

	//로그인 처리를 하는 메소드
	@Override
	public MemberVO getLogin(HashMap<String, String> map) {
		MemberVO mvo = sqlsession.selectOne("dasom.getLogin", map);
		return mvo;
	} // end of getLogin(HashMap<String, String> map) 

	
	//로그인 한 유저의 팀리스트를 가져오는 메소드
	@Override
	public List<HashMap<String, String>> getTeamList(String userid) {
		List<HashMap<String, String>> teamList = sqlsession.selectList("dasom.getTeamList", userid);
		return teamList;
	} // end of getTeamList(String userid)
		
		
	//회원가입 요청을 처리하는 메소드 (멤버테이블에 insert)
	@Override
	public int signupEnd(MemberVO mvo) {
		int n = sqlsession.insert("dasom.signupEnd", mvo);
		return n;
	} // end of signupEnd(MemberVO mvo)


	//아이디 중복체크하는 메소드(멤버테이블에 select)
	@Override
	public int idcheck(String useridCheck) {
		int n = sqlsession.selectOne("dasom.idcheck", useridCheck);
		return n;
	} // end of idcheck(String useridCheck) 


	//팀의 노출값을 가져오는 메소드
	@Override
	public HashMap<String, String> getTeamVS(HashMap<String, String> userInfo) {
		HashMap<String, String> teamInfo = sqlsession.selectOne("dasom.getTeamVS", userInfo);
		return teamInfo;
	} // end of getTeamVS(String teamIDX)


	//프로젝트 테이블에 새로운 프로젝트 insert
	@Override
	public int insertProject(HashMap<String, String> project_info) {
		int n = sqlsession.insert("dasom.insertProject", project_info);
		return n;
	}

	//새로 생성된 프로젝트idx에 프로젝트멤버 insert
	@Override
	public int insertProjectMember(HashMap<String, String> project_info) {
		int n = sqlsession.insert("dasom.insertProjectMember", project_info);
		return n;
	} // end of insertProject(HashMap<String, String> project_info)


	//생성된 프로젝트idx를 select
	@Override
	public String getProjectIDX(HashMap<String, String> project_info) {
		String projectIDX = sqlsession.selectOne("dasom.getProjectIDX", project_info);
		return projectIDX;
	} // end of getProjectIDX(HashMap<String, String> project_info)


	//로그인 한 유저의 프로젝트리스트를 가져오는 메소드
	@Override
	public List<HashMap<String, String>> getProjectList(String userid) {
		List<HashMap<String, String>> projectList = sqlsession.selectList("dasom.getProjectList", userid);
		return projectList;
	} // end of getProjectList(String userid)


	//유저가 접속한 프로젝트의 정보를 가져오는 메소드
	@Override
	public HashMap<String, String> getProjectInfo(HashMap<String, String> map) {
		HashMap<String, String> projectInfo = sqlsession.selectOne("dasom.getProjectInfo", map);
		return projectInfo;
	} // end of getProjectInfo(HashMap<String, String> map)


	//프로젝트의 즐겨찾기 상태를 변경하는 메소드
	@Override
	public int updateFavoriteStatus(HashMap<String, String> map) {
		int result = sqlsession.update("updateFavoriteStatus", map);
		return result;
	} // end of updateFavoriteStatus(HashMap<String, String> map)


	//project_idx로 배경이미지 테이블에서 프로젝트의 배경이미지명을 가져오는 메소드
	@Override
	public String getBackgroundIMG(String project_idx) {
		String project_image_name = sqlsession.selectOne("dasom.getBackgroundIMG", project_idx);
		return project_image_name;
	} // end of getBackgroundIMG(String project_idx)


	//프로젝트의 리스트 목록을 가져오는 메소드
	@Override
	public List<ListVO> getListInfo(String project_idx) {
		List<ListVO> listvo = sqlsession.selectList("dasom.getListInfo", project_idx);
		return listvo;
	}

	//비밀번호찾기에서 이메일과 id로 일치하는 회원이 있는지 확인하는 메소드
	@Override
	public int emailCheck(HashMap<String, String> map) {
		int n = sqlsession.selectOne("dasom.emailCheck", map);
		return n;
	}


	//회원가입 폼에서 이메일 중복체크하는 메소드
	@Override
	public int signupEmailcheck(String emailCheck) {
		int n = sqlsession.selectOne("dasom.signupEmailcheck", emailCheck);
		return n;
	} // end of signupEmailcheck(String emailCheck)


	//email로 가입된 유저의 아이디를 가져오는 메소드
	@Override
	public String getuserID(String emailCheck) {
		String resultid = sqlsession.selectOne("dasom.getuserID", emailCheck);
		return resultid;
	} // end of getuserID(String emailCheck)


	//배경이미지테이블의 데이터를 가져오는 메소드
	@Override
	public List<HashMap<String, String>> getProjectImg() {
		List<HashMap<String, String>> imageList = sqlsession.selectList("dasom.getProjectImg");
		return imageList;
	} // end of getProjectImg()


	//새로운 리스트를 생성하는 메소드
	@Override
	public int addList(HashMap<String, String> map) {
		int result = sqlsession.insert("dasom.addList", map);
		return result;
	} // end of addList(HashMap<String, String> map)


	//프로젝트에 포함된 리스트의 카드목록을 가져오는 메소드
	@Override
	public List<CardVO> getCardInfo(String list_idx) {
		List<CardVO> cardlist = sqlsession.selectList("dasom.getCardInfo", list_idx);
		return cardlist;
	}


	//새로운 카드를 생성하는 메소드
	@Override
	public int addCard(HashMap<String, String> map) {
		int result = sqlsession.insert("dasom.addCard", map);
		return result;
	} // end of addCard(HashMap<String, String> map) 


	//메인페이지에서 비밀번호 변경하는 메소드
	@Override
	public int changePassword(HashMap<String, String> map) {
		int result = sqlsession.update("dasom.changePassword", map);
		return result;
	} // end of changePassword(HashMap<String, String> map)


	//리스트 제목을 변경하는 메소드
	@Override
	public int updateListTitle(HashMap<String, String> map) {
		int result = sqlsession.update("dasom.updateListTitle", map);
		return result;
	} // end of updateListTitle(HashMap<String, String> map)


	//리스트 생성 ajax처리를 위한 insert된 리스트 정보를 가져오는 메소드
	@Override
	public ListVO getListOne(HashMap<String, String> map) {
		ListVO vo = sqlsession.selectOne("dasom.getListOne", map);
		return vo;
	} // end of getListOne(HashMap<String, String> map)


	//프로젝트에 소속되어 있는 프로젝트 멤버의 정보를 가져오는 메소드
	@Override
	public List<HashMap<String, String>> getProjectMemberInfo(String project_idx) {
		List<HashMap<String, String>> memberInfo = sqlsession.selectList("dasom.getProjectMemberInfo", project_idx);
		return memberInfo;
	} // end of getProjectMemberInfo(String project_idx)


	//insert된 리스트의 idx를 가져오는 메소드
	@Override
	public String getListIDX(HashMap<String, String> map) {
		String list_idx = sqlsession.selectOne("dasom.getListIDX", map);
		return list_idx;
	} // end of getListIDX(HashMap<String, String> map)


	//리스트가 생성될 때 기록테이블에 insert해주는 메소드
	@Override
	public int addListRecord(HashMap<String, String> map) {
		int result = sqlsession.insert("dasom.addListRecord", map);
		return result;
	} // end of addListRecord(HashMap<String, String> map)


	//팀 idx를 받아와서 팀멤버vo 정보를 불러오는 메소드 
	@Override
	public List<TeamMemberVO> getTeamMemberInfo(HashMap<String, String> map) {
		List<TeamMemberVO> voList = sqlsession.selectList("dasom.getTeamMemberInfo", map);
		return voList;
	} // end of getTeamMemberInfo(String team_idx)


	//팀멤버를 프로젝트 멤버에 insert
	@Override
	public int insertProjectMembers(HashMap<String, String> map) {
		int n = sqlsession.insert("dasom.insertProjectMembers", map);
		return n;
	} // end of insertProjectMembers(HashMap<String, String> map)


	@Override
	public int updateListDeleteStatus(HashMap<String, String> map) {
		int n = sqlsession.update("dasom.updateListDeleteStatus", map);
		return n;
	}


	@Override
	public int addArchive(HashMap<String, String> map) {
		int n = sqlsession.insert("dasom.addArchive", map);
		return n;
	}


	@Override
	public int deleteArchive(HashMap<String, String> map) {
		int n = sqlsession.delete("dasom.deleteArchive", map);
		return n;
	}


	@Override
	public List<HashMap<String, String>> getArchive(String project_idx) {
		List<HashMap<String, String>> voList = sqlsession.selectList("dasom.getArchive", project_idx);
		return voList;
	}
}
