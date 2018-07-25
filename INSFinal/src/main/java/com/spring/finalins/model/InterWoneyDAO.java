package com.spring.finalins.model;

import java.util.HashMap;
import java.util.List;

//===== model단(DAO)의 인터페이스 생성 =====
public interface InterWoneyDAO {

	HashMap<String, String> getCardInfo(String cardIdx); // 카드 정보 받아오기
	
	HashMap<String, String> getCardDetailInfo(String cardIdx); // 카드 상세 정보 받아오기
	
	List<HashMap<String, String>> cardCommentInfo(String cardIdx); // 카드 코멘트 정보 받아오기
	
	HashMap<String, String> cardDueDateInfo(String cardIdx); // 카드 완료일 받아오기
	
	HashMap<String, String> cardCheckTitleInfo(String cardIdx); // 체크타이틀 받아오기
	
	List<HashMap<String, String>> cardCheckListInfo(String cardIdx); // 체크리스트 받아오기
	
	List<HashMap<String, String>> cardLabelListInfo(String cardIdx); // 카드 라벨리스트 받아오기
	
	int cardLabelCNT(String cardIdx); // 카드 라벨 갯수 정보

	int getProjectMember(HashMap<String, String> map); // 프로젝트 멤버 체크

	int setCardTitleUpdate(HashMap<String, String> map); // 카드 제목 수정
	
	//////////////////////////////////////////////////////////////////
	int setCardRecordInsert(HashMap<String, String> map); // 카드 수정 기록
	List<HashMap<String, String>> getCardRecordInfo(HashMap<String, String> map); // 카드 기록 받아오기
	String getCardRecordIdx(HashMap<String, String> map); // 트랜잭션 프로젝트 idx 받아오기
	int setCardAlarmInsert(String cardRecordIdx); // 카드 알람 생성
	//////////////////////////////////////////////////////////////////
	
	int cardDescriptionCNT(String cardIdx); // 카드 Description 존재 여부 체크

	int setcardDescriptionInsert(String cardIdx); // 카드 Description 입력
	
	int setcardDescriptionUpdate(HashMap<String, String> map); // 카드 Description 수정

	int add_withFile(CardDetailVO cardvo); // 파일첨부

	int setcardAttachDelete(String cardIdx); // 카드 첨부파일 삭제

	///////////////////////////////////////////////////////////////////
	int setcardaddComment(HashMap<String, String> map); // 카드 Comment 입력
	int setcardCommentCountUP(String cardIdx); // 카드 Comment 입력시 ins_card 테이블에 commentcount수 증가
	///////////////////////////////////////////////////////////////////

	int setcardCommentEdit(HashMap<String, String> map); // 카드 Comment 수정

	///////////////////////////////////////////////////////////////////
	int setcardCommentDelete(HashMap<String, String> map); // 카드 Comment 삭제
	int setcardCommentCountDown(String cardIdx); // 카드 Comment 삭제시 ins_card 테이블에 commentcount수 감소 
	///////////////////////////////////////////////////////////////////

	

	int cardRecordDescriptionCNT(String cardIdx); 	// 카드 Description null 인지 아닌지 체크

	int setCardDelete(String cardIdx); // 카드 삭제 

	int setCardDuDateAdd(HashMap<String, String> map); // 카드 DueDate 생성	
	
	int setCardDueDateEdit(HashMap<String, String> map); // 카드  DueDate 수정
	
	int setCardDueDateDelete(HashMap<String, String> map); // 카드  DueDate 삭제

	int cardDueDateCNT(String cardIdx);	// 카드 DueDate 삭제 체크를 위한 CNT

	int getCardCheck(HashMap<String, String> map); // 카드 DueDate 체크 여부 확인

	int setCheckChangeAdd(HashMap<String, String> map);	// 카드 DueDate 체크 업데이트

	int setCheckChangeRemove(HashMap<String, String> map); // 카드 DueDate 체크해제 업데이트

	int getCheckListCNT(String cardIdx); // 카드 체크리스트 존재여부 확인
	
	int setCheckListTitleAdd(HashMap<String, String> map); // 카드 체크리스트 타이틀 생성

	int setCheckLisTitletEdit(HashMap<String, String> map); // 카드  체크리스트 타이들 수정

	int setCheckListAdd(HashMap<String, String> map); // 카드  체크리스트 생성

	int setCheckListChange(HashMap<String, String> map); // 카드  체크리스트 체크 상태 변경

	int setCheckListDelete(HashMap<String, String> map); // 카드  체크리스트 삭제

	int setCheckListTitleDelete(HashMap<String, String> map); // 카드 체크리스트 타이틀 삭제

	int setLabelAdd(HashMap<String, String> map); // 카드  라벨추가

}
