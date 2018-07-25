package com.spring.finalins.service;

import java.util.HashMap;
import java.util.List;

import com.spring.finalins.model.CardDetailVO;

//=== Service단 인터페이스 선언 ===
public interface InterWoneyService {

	HashMap<String, String> getCardInfo(String cardIdx); // 카드정보 받아오기
	
	HashMap<String, String> getCardDetailInfo(String cardIdx); // 카드 상세 정보 받아오기
	
	List<HashMap<String, String>> cardCommentInfo(String cardIdx); // 카드 코멘트 정보 받아오기
	
	HashMap<String, String> cardDueDateInfo(String cardIdx); // 카드 완료일 받아오기
	
	HashMap<String, String> cardCheckTitleInfo(String cardIdx); // 체크타이틀 받아오기
	
	List<HashMap<String, String>> cardCheckListInfo(String cardIdx); // 체크리스트 받아오기
	
	List<HashMap<String, String>> cardLabelListInfo(String cardIdx); // 카드 라벨리스트 받아오기
	
	int cardLabelCNT(String cardIdx); // 카드 라벨 갯수 정보
	
	String getProjectMember(HashMap<String, String> map); // 프로젝트 멤버 체크
	
	int setCardTitleUpdate(HashMap<String, String> map) throws Throwable;	// 카드 제목 수정 후 기록

	String getCardInfoJSON(HashMap<String, String> map);	// 카드 정보와 기록 JSON으로 받아오기

	int cardDescriptionCNT(String cardIdx); // 카드 Description 존재 여부 체크
	
	int setcardDescriptionInsert(String cardIdx) throws Throwable; // 카드 Description 입력

	int setcardDescriptionUpdate(HashMap<String, String> map) throws Throwable; // 카드 Description 수정
 
	String getCardDescriptionInfoJSON(String cardIdx); // 카드 Description 정보 JSON으로 받아오기

	int add_withFile(CardDetailVO cardvo,HashMap<String,String> map) throws Throwable; // 파일첨부 추가

	int setcardAttachDelete(HashMap<String,String> map) throws Throwable; // 카드 첨부파일 삭제

	int setcardaddComment(HashMap<String, String> map)  throws Throwable; // 카드 Comment 입력

	int setcardCommentEdit(HashMap<String, String> map) throws Throwable; // 카드 Comment 수정

	int setcardCommentDelete(HashMap<String, String> map) throws Throwable; // 카드 Comment 삭제

	List<HashMap<String, String>> getCardRecordInfo(HashMap<String, String> cardRecordIDXMap); // 카드 기록 받아오기

	int cardRecordDescriptionCNT(String cardIdx); // 카드 Description null 인지 아닌지 체크

	int setCardRecordInsert(HashMap<String, String> map); // 카드 기록 입력

	int setCardDelete(HashMap<String, String> map); // 카드 삭제 

	int setCardDuDateAdd(HashMap<String, String> map); // 카드 DueDate 생성

	int setCardDueDateEdit(HashMap<String, String> map); // 카드  DueDate 수정
	
	int setCardDueDateDelete(HashMap<String, String> map); // 카드  DueDate 삭제
	
	int cardDueDateCNT(String cardIdx); // 카드 DueDate 삭제 체크를 위한 CNT
	
	int cardCheck(HashMap<String, String> map); // 카드 DueDate 체크 여부 확인

	int getCheckListCNT(String cardIdx); // 카드 체크리스트 존재여부 확인
	
	int setCheckListTitleAdd(HashMap<String, String> map);  // 카드 체크리스트 타이틀 생성

	int setCheckLisTitletEdit(HashMap<String, String> map); 	// 카드  체크리스트 타이들 수정

	int setCheckListAdd(HashMap<String, String> map); // 카드  체크리스트 생성

	int setCheckListChange(HashMap<String, String> map); // 카드  체크리스트 체크 상태 변경

	int setCheckListDelete(HashMap<String, String> map); // 카드  체크리스트 삭제

	int setCheckListTitleDelete(HashMap<String, String> map); // 카드 체크리스트 타이틀 삭제

	int setLabelAdd(HashMap<String, String> map); // 카드  라벨추가

}
