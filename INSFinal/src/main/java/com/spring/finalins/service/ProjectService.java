package com.spring.finalins.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.finalins.model.CardVO;
import com.spring.finalins.model.InterProjectDAO;
import com.spring.finalins.model.ListVO;
import com.spring.finalins.model.MemberVO;

@Service
public class ProjectService implements InterProjectService{

	@Autowired
	private InterProjectDAO dao;

	//로그인처리를 하는 메소드
	@Override
	public MemberVO getLogin(HashMap<String, String> map) {
		MemberVO mvo = dao.getLogin(map);
		return mvo;
	} // end of getLogin(HashMap<String, String> map)

	
	//로그인 한 유저의 팀리스트를 가져오는 메소드
	@Override
	public List<HashMap<String, String>> getTeamList(String userid) {
		List<HashMap<String, String>> teamList = dao.getTeamList(userid);
		return teamList;
	} // end of getTeamList(String userid)
	
	
	//회원가입 요청을 처리하는 메소드  
	@Override
	public int signupEnd(MemberVO mvo) {
		int n = dao.signupEnd(mvo);
		return n;
	} // end of signupEnd(MemberVO mvo)


	//아이디 중복체크를 하는 메소드
	@Override
	public int idcheck(String useridCheck) {
		int n = dao.idcheck(useridCheck);
		return n;
	} // end of idcheck(String useridCheck)


	//팀의 노출값을 가져오는 메소드
	@Override
	public HashMap<String, String> getTeamVS(HashMap<String, String> userInfo) {
		HashMap<String, String> teamInfo = dao.getTeamVS(userInfo);
		return teamInfo;
	} // end of getTeamVS(String teamIDX)

 
	//프로젝트를 생성하는 메소드
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED,rollbackFor= {Throwable.class})
	public int insertProject(HashMap<String, String> project_info) {
		int result = 0;
		int n = 0;
		int m = 0;
		
		n = dao.insertProject(project_info);
		
		if(n==1) {
			String projectIDX = dao.getProjectIDX(project_info);
			project_info.put("projectIDX", projectIDX);
			
/*			System.out.println("projectIDX값 확인용: " + project_info.get("projectIDX"));
			System.out.println("userid값 확인용: " + project_info.get("userid"));
			System.out.println("project_name값 확인용: " + project_info.get("project_name"));
			System.out.println("pjst값 확인용: " + project_info.get("pjst"));
			System.out.println("team_idx값 확인용: " + project_info.get("team_idx"));
			*/
			m = dao.insertProjectMember(project_info);
		//	System.out.println("================== m값 확인용:" + m);
		}
		result = n + m;
		return result;
	} // end of insertProject(HashMap<String, String> project_info)


	//로그인 한 유저의 프로젝트리스트를 가져오는 메소드
	@Override
	public List<HashMap<String, String>> getProjectList(String userid) {
		List<HashMap<String, String>> projectList = dao.getProjectList(userid);
		return projectList;
	} // end of getProjectList(String userid)


	//유저가 접속한 프로젝트의 정보를 가져오는 메소드
	@Override
	public HashMap<String, String> getProjectInfo(HashMap<String, String> map) {
		HashMap<String, String> projectInfo = dao.getProjectInfo(map);
		return projectInfo;
	} // end of getProjectInfo(HashMap<String, String> map)


	//프로젝트의 즐겨찾기 상태를 변경하는 메소드
	@Override
	public int updateFavoriteStatus(HashMap<String, String> map) {
		int result = dao.updateFavoriteStatus(map);

		return result;
	} // end of updateFavoriteStatus(HashMap<String, String> map)


	//project_idx로 배경이미지 테이블에서 프로젝트의 배경이미지명을 가져오는 메소드
	@Override
	public String getBackgroundIMG(String project_idx) {
		String project_image_name = dao.getBackgroundIMG(project_idx);
		return project_image_name;
	} // end of getBackgroundIMG(String project_idx)


	//프로젝트의 리스트 목록을 가져오는 메소드
	@Override
	public List<ListVO> getListInfo(String project_idx) {
		List<ListVO> listvo = dao.getListInfo(project_idx);
		return listvo;
	} // end of getListInfo(String project_idx)

	
	//비밀번호찾기에서 이메일과 id로 일치하는 회원이 있는지 확인하는 메소드
	@Override
	public int emailCheck(HashMap<String, String> map) {
		int n = dao.emailCheck(map);
		return n;
	} // end of emailCheck(HashMap<String, String> map)


	//회원가입 폼에서 이메일 중복체크하는 메소드
	@Override
	public int signupEmailcheck(String emailCheck) {
		int n = dao.signupEmailcheck(emailCheck);
		return n;
	} // end of signupEmailcheck(String emailCheck)


	//email로 가입된 유저의 아이디를 가져오는 메소드
	@Override
	public String getuserID(String emailCheck) {
		String resultid = dao.getuserID(emailCheck);
		return resultid;
	} // end of getuserID(String emailCheck)


	//배경이미지테이블의 데이터를 가져오는 메소드
	@Override
	public List<HashMap<String, String>> getProjectImg() {
		List<HashMap<String, String>> imageList = dao.getProjectImg();
		return imageList;
	} // end of getProjectImg()


	//새로운 리스트를 생성하는 메소드
	@Override
	public int addList(HashMap<String, String> map) {
		int result = dao.addList(map);
		return result;
	} // end of addList(HashMap<String, String> map)


	//프로젝트에 포함된 리스트의 카드목록을 가져오는 메소드
	@Override
	public List<CardVO> getCardInfo(String list_idx) {
		List<CardVO> cardlist = dao.getCardInfo(list_idx);
		return cardlist;
	} // end of getCardInfo(String list_idx)


	//새로운 카드를 생성하는 메소드
	@Override
	public int addCard(HashMap<String, String> map) {
		int result = dao.addCard(map);
		return result;
	} // end of addCard(HashMap<String, String> map)


	

}
