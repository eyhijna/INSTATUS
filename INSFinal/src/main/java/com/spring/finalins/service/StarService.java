package com.spring.finalins.service;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
 
import com.spring.finalins.common.MyUtil;
import com.spring.finalins.model.InterStarDAO;
import com.spring.finalins.model.MemberVO;
import com.spring.finalins.model.ProjectVO;
import com.spring.finalins.model.TeamMemberVO;
import com.spring.finalins.model.TeamVO;

@Service
public class StarService implements InterStarService {

	@Autowired
	private InterStarDAO dao;
  
	// 팀생성하기 
	@Override
	public int createTeam(HashMap<String, String> map) {
		
		int n = dao.createTeam(map);
		return n; 
	}
   
	// 팀정보가져오기
	@Override
	public TeamVO myTeamInfo(HashMap<String, String> map) {
		
		 TeamVO  teamvo = dao.myTeamInfo(map);
		 return teamvo;
	}
   
	// 팀명 수정하기 
	@Override
	public int editTeam(HashMap<String, String> map) {
		
		int n = dao.editTeam(map); //팀명수정하기  
		return n;
	}
 
	// 팀정보 가져오기 JSON
	@Override
	public String getInfoTeam(String team_idx) {
		 
		TeamVO tvo = dao.getInfoTeam(team_idx);
	    JSONObject jsonObj = new JSONObject();
		    
			if(tvo != null) {
				 
			    jsonObj.put("team_name", tvo.getTeam_name());
			    jsonObj.put("team_idx", tvo.getTeam_idx());
			    jsonObj.put("admin_userid", tvo.getAdmin_userid());
			    jsonObj.put("team_delete_status", tvo.getTeam_delete_status());
			    jsonObj.put("org_filename", tvo.getOrg_filename());
			    jsonObj.put("file_size", tvo.getFile_size());
			    jsonObj.put("server_filename", tvo.getServer_filename());
			    jsonObj.put("team_visibility_status", tvo.getTeam_visibility_status()); 		    
			} 
			
	    String str_jsonObj = jsonObj.toString();
	    return str_jsonObj;
	}

	// 팀정보 가져오기 TeamVO
	@Override
	public TeamVO teamInfoVO(String team_idx) {
		TeamVO tvo = dao.getInfoTeam(team_idx);
		return tvo;
	}
 
	// 팀멤버테이블 생성하기
	@Override
	public int insertTeamMember(HashMap<String, String> map) {
		int n = dao.insertTeamMember(map);
		return n;
	}

	// 팀idx에 해당하는 팀멤버테이블 VO를 가져오는 메소드
	@Override
	public TeamMemberVO teamMemberInfo(HashMap<String, String> map) { 
		TeamMemberVO tmvo = dao.teamMemberInfo(map);  
		return tmvo;
	}
 
	// 내가 중복으로 들어와있는지 체크해주는 메소드
	@Override
	public int checkMemberExist(HashMap<String, String> map) {
		int m = dao.checkMemberExist(map);
		return m;
	}

    // 팀공개설정 업데이트해주는 메소드 
	@Override
	public int updateViewStatus(HashMap<String, String> map) {
		int n = dao.updateViewStatus(map);
		return n;
	}
	
	// 나를 제외한 팀원이 있는지 count해오는 메소드
	@Override
	public int countMember(HashMap<String, String> map) {
		int n = dao.countMember(map);
		return n;
	}

	// 팀멤버의 정보를 받아오는 메소드
	@Override
	public List<MemberVO> getTeamMembers(HashMap<String, String> map) {
		List<MemberVO> memberList = dao.getTeamMembers(map);
		return memberList;
	}
	 
	// 팀멤버들의 정보를 JSON 으로 받아오는 메소드
	@Override
	public String getMembersJSON(HashMap<String, Integer> map) {
		 
		List<HashMap<String, Integer>> memberList = dao.getTeamMembersMap(map);
		JSONArray jsonArray = new JSONArray();
		String str_jsonArray = "";
		
		if(memberList != null && memberList.size() > 0) {
			for(HashMap<String, Integer> hmap : memberList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("userid",  hmap.get("userid") );
				jsonObj.put("pwd", hmap.get("pwd") );
				jsonObj.put("name",  hmap.get("name"));
				jsonObj.put("nickname", hmap.get("nickname") );
				jsonObj.put("email",  hmap.get("email"));
				jsonObj.put("tel1", hmap.get("tel1"));
				jsonObj.put("tel2", hmap.get("tel2") ); 
				jsonObj.put("tel3", hmap.get("tel3"));
				jsonObj.put("leave_status", hmap.get("leave_status") );
				jsonObj.put("job", hmap.get("job"));
				jsonObj.put("birthday", hmap.get("birthday") );
				jsonObj.put("org_filename", hmap.get("org_filename"));
				//jsonObj.put("server_filename", hmap.get("server_filename"));
				//jsonObj.put("file_size", hmap.get("file_size"));
				jsonObj.put("ins_personal_alarm", hmap.get("ins_personal_alarm"));
				jsonObj.put("team_member_admin_status", hmap.get("team_member_admin_status"));
				jsonObj.put("totalCount", map.get("totalCount"));
				
				jsonArray.put(jsonObj);
			}// end of for
			
		}//end of if
		
		str_jsonArray = jsonArray.toString();
		return str_jsonArray; 
	}
   
    // 내가 가입된 팀 목록 가져오기 JSON
	@Override
	public String getTeamListJSON(String userid) {
		List<TeamVO> teamList = null;
		
	    teamList = dao.getTeamListJSON(userid);
	    
	    String str_jsonArray = "";
	    JSONArray jsonArray = new JSONArray();
		if(teamList != null && teamList.size() > 0) {
			for(TeamVO tvo : teamList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("team_idx", tvo.getTeam_idx());
				jsonObj.put("admin_userid",tvo.getAdmin_userid() );
				jsonObj.put("team_name", tvo.getTeam_name() );
				jsonObj.put("team_delete_status", tvo.getTeam_delete_status());
				jsonObj.put("team_visibility_status", tvo.getTeam_visibility_status() ); 
				jsonObj.put("file_size", tvo.getFile_size());
				jsonObj.put("org_filename", tvo.getOrg_filename());
				jsonObj.put("server_filename", tvo.getServer_filename());
				
				jsonArray.put(jsonObj);
			} 
		}
		
		str_jsonArray = jsonArray.toString();
		return str_jsonArray; 
	}
 
	// 내가 가입한 팀 갯수 세기
	@Override
	public int getcountTeam(String userid) {
		int n = dao.getcountTeam(userid);
		return n;
	}
	
	// 멤버검색 JSON 으로 받아오기 
	@Override
	public String getSearchMember(HashMap<String, String> map) { 
			 
	    List<HashMap<String, String>> memberList = dao.getSearchMember(map); 
		// VO나 HashMap 은 컬럼이 여러개일때 사용하고 컬럼이 1개이고 데이터가 여러개 있을때는 List를 사용한다
	    
	    JSONArray jsonArray = new JSONArray(); 
	    
		if(memberList != null && memberList.size() > 0) {
			 for(HashMap<String, String> map1 : memberList) {  
				 
				 JSONObject jsonObj = new JSONObject();
				 jsonObj.put("nickname", map1.get("nickname"));
				 jsonObj.put("email", map1.get("email")); 
				 jsonObj.put("org_filename", map1.get("org_filename"));
				 jsonObj.put("userid", map1.get("userid")); 
				 
				 jsonArray.put(jsonObj);
			 }// end of for
	    }//end of if 
		 
	    String str_jsonArray = jsonArray.toString();
		// 데이터가 없다면 jsonArray 배열 사이즈는 0 
	    return str_jsonArray;
	}
	
    // 부관리자가 있는지 조회해오는 메소드
	@Override
	public int checkAdmin(String team_idx) {
		int n = dao.checkAdmin(team_idx);
		return n; 
	}
	
	// 부관리자로 권한을 변경해주는 메소드
	@Override
	public int chgTo2ndAdmin(HashMap<String, String> map) {
		int m = dao.chgTo2ndAdmin(map);
		return m;
	}
	
	//운영자로 update해주는 메소드
	@Override
	public int chgToAdmin(HashMap<String, String> map) {
		int n = dao.chgToAdmin(map);
		return n;
	}

	// 회원 권한을  일반사용자로 바꾸는 메소드 
	@Override
	public int chgToNormal(HashMap<String, String> map) {
		int n = dao.chgToNormal(map);
		return n;
	}
	
	// team_member테이블에 운영자 status로 변경 
	@Override
	public int updateAdminUser(HashMap<String, String> map) {
		int n = dao.updateAdminUser(map);
		return n;
		
	}
   
	// 구 운영자를 일반사용자로 변경 
	@Override
	public int updateOldAdmin(HashMap<String, String> map) {
		int n = dao.updateOldAdmin(map);
		return n;
	}
	
	// 검색한 멤버를 초대하는 메소드 
	@Override
	public int inviteMember(HashMap<String, String> map) {
		int n = dao.inviteMember(map);
		return n;
	}
	
	// 팀 가입을 요청한 회원들의 정보를 가져온다.
	@Override
	public String joinMemberList(HashMap<String, Integer> map) {
		List<HashMap<String, Integer>> memberList = dao.joinMemberList(map);
		
		JSONArray jsonArray = new JSONArray();
		
		if(memberList.size() > 0 || memberList != null) {
			for(HashMap<String, Integer> map1 : memberList) {
	
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("userid", map1.get("userid"));
				jsonObj.put("name", map1.get("name"));
				jsonObj.put("nickname", map1.get("nickname"));
				jsonObj.put("email", map1.get("email"));
				jsonObj.put("org_filename", map1.get("org_filename"));
				jsonObj.put("totalCount", map.get("totalCount"));
				
				jsonArray.put(jsonObj);
			}
		}
		
		String str_jsonArray = jsonArray.toString();
		return str_jsonArray;
	}
	
	// 팀 가입을 요청한 회원을 수락하는 메소드 
	@Override
	public int acceptMember(HashMap<String, String> map) {
		int n = dao.acceptMember(map);
		return n;
	}

	@Override
	public int declineMember(HashMap<String, String> map) {
		int n = dao.declineMember(map);
		return n;
	}
	
	// 파일첨부가 완료되면 사진을 등록해주는 메소드
	@Override
	public int updateTeamPic(TeamVO teamvo) {
		int n = dao.updateTeamPic(teamvo);
		return n;
	}
	
	// 팀을 탈퇴할때 delete해주는 메소드
	@Override
	public int leaveTeam(HashMap<String, String> map) {
		int n = dao.leaveTeam(map);
		return n;
	}
	
	// 검색했을때 검색어에 해당되는 회원들의 정보를 가져옴(관리자가 아닌 회원이 자신의 팀내에서 멤버검색)
	@Override
	public String getSearchMyTMember(HashMap<String, String> map) {
		
		List<HashMap<String, String>> memberList = dao.searchMyTmember(map);
	    JSONArray jsonArray = new JSONArray(); 
		    
		  if(memberList != null && memberList.size() > 0) {
			  for(HashMap<String, String> hmap : memberList) {  
					 
				  JSONObject jsonObj = new JSONObject();
				  jsonObj.put("userid",  hmap.get("userid") );
				  jsonObj.put("pwd", hmap.get("pwd") );
				  jsonObj.put("name",  hmap.get("name"));
				  jsonObj.put("nickname", hmap.get("nickname") );
			      jsonObj.put("email",  hmap.get("email"));
				  jsonObj.put("tel1", hmap.get("tel1"));
				  jsonObj.put("tel2", hmap.get("tel2") ); 
				  jsonObj.put("tel3", hmap.get("tel3"));
				  jsonObj.put("leave_status", hmap.get("leave_status") );
				  jsonObj.put("job", hmap.get("job"));
				  jsonObj.put("birthday", hmap.get("birthday") );
				  jsonObj.put("org_filename", hmap.get("org_filename"));
				  //jsonObj.put("server_filename", hmap.get("server_filename"));
				  //jsonObj.put("file_size", hmap.get("file_size"));
				  jsonObj.put("ins_personal_alarm", hmap.get("ins_personal_alarm"));
				  jsonObj.put("team_member_admin_status", hmap.get("team_member_admin_status"));
					 
				  jsonArray.put(jsonObj);
			  }// end of for
		  }//end of if 
			 
		String str_jsonArray = jsonArray.toString();
	    // 데이터가 없다면 jsonArray 배열 사이즈는 0 
	    return str_jsonArray;
	} 
	//팀멤버들의 정보를 가져오는 메소드
	@Override
	public String myTeamMemberList(String team_idx) {
		List<TeamMemberVO> memberList = dao.myTeamMemberList(team_idx);
		JSONArray jsonArray = new JSONArray();
		if(memberList.size() > 0 || memberList != null) {
			for(TeamMemberVO tvo : memberList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("fk_team_idx", tvo.getFk_team_idx());
				jsonObj.put("team_userid", tvo.getTeam_userid());
				jsonObj.put("team_member_admin_status", tvo.getTeam_member_admin_status());
				
				jsonArray.put(jsonObj);
			} 
		}
		
		String str_jsonArray = jsonArray.toString();
		
		return str_jsonArray;
	}
	
	// 부운영자 갯수를 가져오는 메소드 
	@Override
	public int count2Admin(String team_idx) {
		int n = dao.count2Admin(team_idx); 
		return n;
	}
	
	// 나 자신을 포함한 팀원의 총 갯수를 가져오는 메소드
	@Override
	public int totalMemberCount(String team_idx) {
		int totalCount = dao.totalMemberCount(team_idx);
		return totalCount;
	}
	
	// 검색했을때 검색어에 해당되는 회원들의 정보를 가져옴(멤버가 존재하고 그외의 회원들을 관리자가 조회하는 검색창)
	@Override
	public String getSearchExceptTeamMember(HashMap<String, String> map) {
		
		    List<HashMap<String, String>> memberList = dao.getSearchExceptTeamMember(map); 
			// VO나 HashMap 은 컬럼이 여러개일때 사용하고 컬럼이 1개이고 데이터가 여러개 있을때는 List를 사용한다
		    
		    JSONArray jsonArray = new JSONArray(); 
		    
			if(memberList != null && memberList.size() > 0) {
				 for(HashMap<String, String> map1 : memberList) {  
					 
					 JSONObject jsonObj = new JSONObject();
					 jsonObj.put("nickname", map1.get("nickname"));
					 jsonObj.put("email", map1.get("email")); 
					 jsonObj.put("org_filename", map1.get("org_filename"));
					 jsonObj.put("userid", map1.get("userid")); 
					 
					 jsonArray.put(jsonObj);
				 }// end of for
		    }//end of if 
			 
		    String str_jsonArray = jsonArray.toString();
			// 데이터가 없다면 jsonArray 배열 사이즈는 0 
		    return str_jsonArray;
	}
	
	// 가입신청을 한 멤버의갯수를 가져온다 
	@Override
	public int joinMemberCount(String str_team_idx) {
		int totalCount = dao.joinMemberCount(str_team_idx);
		return totalCount;
	}

	// 팀 해체버튼을 눌렀을때 호출되는 메소드
	@Override
	public int breakTeam(String team_idx) {
		int m = dao.breakTeam(team_idx);
		return m;
	}

	// 내가 포함된 프로젝트를 불러오는 메소드
	@Override
	public String getProjectList(HashMap<String, String> map2) {
		
		List<HashMap<String, String>> projectList = dao.getProjectList(map2);
		  
		JSONArray jsonArray = new JSONArray();
		
		if(jsonArray != null && projectList.size() > 0) {
			 
			for(HashMap<String, String> map : projectList) {
				   
			     JSONObject jsonObj = new JSONObject();     
			     
				 jsonObj.put("fk_team_idx", map.get("fk_team_idx"));
				 jsonObj.put("project_idx", map.get("project_idx"));
				 jsonObj.put("project_name", map.get("project_name"));
				 jsonObj.put("project_visibility_st", map.get("project_visibility_st"));
				 jsonObj.put("project_delete_status", map.get("project_delete_status"));
				 jsonObj.put("fk_project_image_idx", map.get("fk_project_image_idx"));
				 jsonObj.put("project_member_admin_status", map.get("project_member_admin_status"));
				 jsonObj.put("project_image_name", map.get("project_image_name"));
				 jsonObj.put("totalCount", map2.get("totalCount"));
				 
				 
				 jsonArray.put(jsonObj);
			} 
		}//end of if 
		
		String str_jsonArray = jsonArray.toString();
		return str_jsonArray;
	}
	
	// 내가 포함된 팀 프로젝트 총 갯수 가져오기 
	@Override
	public int projectCnt(HashMap<String, String> map1) {
		int totalCount = dao.projectCnt(map1);
		return totalCount;
	}

	// 팀의 회원정보들을 불러오는 메소드
	@Override
	public List<TeamMemberVO> teamMemberList(String team_idx) {
		List<TeamMemberVO> memberList = dao.teamMemberList(team_idx);
		return memberList;
	}
	
	// 회원이 팀가입을 요청할때
	@Override
	public int wantJoinTeam(HashMap<String, String> map) {
		int n = dao.wantJoinTeam(map);
		return n;
	}
	
	// public인 프로젝트 갯수알아오기 
	@Override
	public int publicProjectCnt(String team_idx) {
		int totalCount = dao.publicProjectCnt(team_idx);
		return totalCount; 
	}

	// public인 프로젝트를 가져온다.
	@Override
	public String getPublicProjectList(HashMap<String, String> map2) {
		
		List<ProjectVO> projectList = dao.getPublicProjectList(map2);
		// 제품별로 ProductVO를 가져온다 
		 
		JSONArray jsonArray = new JSONArray();
		
		if(jsonArray != null && projectList.size() > 0) {
			
			for(ProjectVO pvo : projectList) {
				
			     JSONObject jsonObj = new JSONObject();     
			     
				 jsonObj.put("fk_team_idx", pvo.getFk_team_idx());
				 jsonObj.put("project_idx", pvo.getProject_idx());
				 jsonObj.put("project_name", pvo.getProject_name());
				 jsonObj.put("project_visibility_st", pvo.getProject_visibility_st());
				 jsonObj.put("project_delete_status", pvo.getProject_delete_status());
				 jsonObj.put("fk_project_image_idx", pvo.getFk_project_image_idx());
				 jsonObj.put("totalCount", map2.get("totalCount"));
				 
				 jsonArray.put(jsonObj);
			} 
		}//end of if 
		
		String str_jsonArray = jsonArray.toString();
		return str_jsonArray; 
	}
   
  
	 
}//end of class
