package com.spring.finalins.service;

import java.util.HashMap;
import java.util.List;

import com.spring.finalins.model.MemberVO;
import com.spring.finalins.model.TeamVO;

public interface InterJihyeService {

	MemberVO getMyProfile(String userid); // 개인정보 수정을 위한 로그인한 유저의 정보를 불러오기

	int updateMyProfile(MemberVO membervo);  // 회원정보수정 업데이트 하기

	int deleteMyAccount(String userid); // 회원탈퇴(leave_status 업데이트 하기)


	List<TeamVO> getTeamList(String userid); // 내가 속한 팀목록 불러오기
	
	int getRecordTotalCount(HashMap<String, String> map); // 내가 활동한 전체 기록수
	List<HashMap<String, String>> getMyRecordList(HashMap<String,String> btnmoreMap); // 내가 활동한 기록 불러오기
//	List<HashMap<String, String>> getMyRecordList(String userid);

	int updateProfileImg(HashMap<String, String> map); // 프로필 이미지 변경하기

	// ==== 차트 그리기 ====
	List<HashMap<String, String>> getChartJSON_job(); // 직업별 인원수
	List<HashMap<String, String>> adminChartJSON_ageline(); // 연령별 인원수

	List<HashMap<String, String>> getInviteTeamName(String userid);  // 나를 초대한 팀 목록 불러오기
	int approveTeam( HashMap<String,String> map); //  팀초대 승인할 경우 
	int denyTeam( HashMap<String,String> map); /// 팀 초대 거절할 경우.

	// 이중차트
	String rankShowJSON(); 
	String jobAgelineRankShowJSON(String job); //

//	int updateIns_personal_alarm(String userid); // ins_personal_alarm값 변경하기

	

	
	




	

}


