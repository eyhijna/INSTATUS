package com.spring.finalins.model;

import java.util.HashMap;
import java.util.List;

import com.spring.finalins.qna.model.QnaVO;
import com.spring.finalins.model.TeamVO;

public interface InterJihyeDAO {

	MemberVO getMyProfile(String userid); // 개인정보 수정을 위한 로그인한 유저의 정보를 불러오기

	int updateMyProfile(MemberVO membervo); // 회원정보수정 업데이트 하기

	int deleteMyAccount(String userid); // 회원탈퇴(leave_status 업데이트 하기)

	List<TeamVO> getTeamList(String userid); // 내가 속한 팀목록 불러오기

	int updateProfileImg(HashMap<String, String> map); // 프로필 이미지 변경하기
	

	// 차트 그리기
	List<HashMap<String, String>> getChartJSON_job(); // 직업별 인원수(통계)
	List<HashMap<String, String>> adminChartJSON_ageline(); // 연령별 인원수(통계)

	int getRecordTotalCount(HashMap<String, String> map); // 내가 활동한 전체 기록수
	List<HashMap<String, String>> getMyRecordList(HashMap<String,String> btnmoreMap); // 내가 활동한 기록 불러오기
//	List<HashMap<String, String>> getMyRecordList(String userid);

	List<HashMap<String, String>> getInviteTeamName(String userid);// 나를 초대한 팀목록 불러오기
	int approveTeam( HashMap<String,String> map); //팀초대 승인하기
	int denyTeam( HashMap<String,String> map); //팀초대 거절하기

	// 이중차트
	List<HashMap<String,String>> rankShowJSON(); 
	List<HashMap<String, String>> jobAgelineRankShowJSON(String job);

//	int updateIns_personal_alarm(String userid);// ins_personal_alarm값 변경하기

	






 
}
