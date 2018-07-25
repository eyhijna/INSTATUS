package com.spring.finalins.model;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.util.SystemPropertyUtils;

//===== DAO 선언 =====
@Repository
public class WoneyDAO implements InterWoneyDAO {

	
	// ===== #29. 의존객체 주입하기(DI: Dependency Injection) =====
	@Autowired
	private SqlSessionTemplate sqlsession;

	// 카드 정보 받아오기
	@Override
	public HashMap<String, String> getCardInfo(String cardIdx) {
		HashMap<String, String> CardMap = sqlsession.selectOne("woney.getCardInfo", cardIdx);
		return CardMap;
	}
	
	// 카드 상세 정보 받아오기
	@Override
	public HashMap<String, String> getCardDetailInfo(String cardIdx) {
		HashMap<String, String> cardDetailMap = sqlsession.selectOne("woney.getCardDetailInfo", cardIdx);
		return cardDetailMap;
	}
	
	// 카드 코멘트 정보 받아오기
	@Override
	public List<HashMap<String, String>> cardCommentInfo(String cardIdx) {
		List<HashMap<String, String>> cardCommentList = sqlsession.selectList("woney.cardCommentInfo", cardIdx);
		return cardCommentList;
	}
	
	// 카드 완료일 받아오기
	@Override
	public HashMap<String, String> cardDueDateInfo(String cardIdx) {
		HashMap<String, String> cardDueDateMap = sqlsession.selectOne("woney.cardDueDateInfo", cardIdx);
		return cardDueDateMap;
	}
	
	// 체크타이틀 받아오기
	@Override
	public HashMap<String, String> cardCheckTitleInfo(String cardIdx) {
		HashMap<String, String> cardCheckListMap = sqlsession.selectOne("woney.cardCheckTitleInfo", cardIdx);
		return cardCheckListMap;
	}
	
	// 체크리스트 받아오기
	@Override
	public List<HashMap<String, String>> cardCheckListInfo(String cardIdx) {
		List<HashMap<String, String>> cardCheckList = sqlsession.selectList("woney.cardCheckListInfo", cardIdx);
		return cardCheckList;
	}
	
	// 카드 라벨리스트 받아오기
	@Override
	public List<HashMap<String, String>> cardLabelListInfo(String cardIdx) {
		List<HashMap<String, String>> cardLabelList = sqlsession.selectList("woney.cardLabelListInfo", cardIdx);
		return cardLabelList;
	}

	// 카드 라벨 갯수 정보
	@Override
	public int cardLabelCNT(String cardIdx) {
		int n = sqlsession.selectOne("woney.cardLabelCNT", cardIdx);
		return n;
	}
	
	// 프로젝트 멤버 체크
	@Override
	public int getProjectMember(HashMap<String, String> map) {
		int n = sqlsession.selectOne("woney.getProjectMember", map);
		return n;
	}

	// 카드 제목 수정
	@Override
	public int setCardTitleUpdate(HashMap<String, String> map) {
		int n = sqlsession.update("woney.setCardTitleUpdate", map);
		return n;
	}
	
	// 카드 Description 존재 여부 체크
	@Override
	public int cardDescriptionCNT(String cardIdx) {
		int cnt = sqlsession.selectOne("woney.cardDescriptionCNT", cardIdx);
		return cnt;
	}

	// 카드 Description 입력
	@Override
	public int setcardDescriptionInsert(String cardIdx) {
		int n = sqlsession.insert("woney.setcardDescriptionInsert", cardIdx);
		return n;
	}

	// 카드 Description 수정
	@Override
	public int setcardDescriptionUpdate(HashMap<String, String> map) {
		int n = sqlsession.update("woney.setcardDescriptionUpdate", map);
		return n;
	}

	// 파일첨부
	@Override
	public int add_withFile(CardDetailVO cardvo) {
		int n = sqlsession.update("woney.add_withFile", cardvo);		
		return n;
	}

	// 카드 첨부파일 삭제
	@Override
	public int setcardAttachDelete(String cardIdx) {
		int n = sqlsession.delete("woney.setcardAttachDelete", cardIdx);
		return n;
	}
	
///////////////////////////////////////////////////////////////////////
	// 카드 Comment 입력
	@Override
	public int setcardaddComment(HashMap<String, String> map) {
		int n = sqlsession.insert("woney.setcardaddComment", map);
		return n;
	}
	// 카드 Comment 입력시 ins_card 테이블에 commentcount수 증가
	@Override
	public int setcardCommentCountUP(String cardIdx) {
		int n = sqlsession.update("woney.setcardCommentCountUP", cardIdx);
		return n;
	}
///////////////////////////////////////////////////////////////////////
	
	// 카드 Comment 수정
	@Override
	public int setcardCommentEdit(HashMap<String, String> map) {
		int n = sqlsession.update("woney.setcardCommentEdit", map);
		return n;
	}

//////////////////////////////////////////////////////////////////////	
	// 카드 Comment 삭제
	@Override
	public int setcardCommentDelete(HashMap<String, String> map) {
		int n = sqlsession.delete("woney.setcardCommentDelete", map);
		return n;
	}
	
	// 카드 Comment 삭제시 ins_card 테이블에 commentcount수 감소 
	@Override
	public int setcardCommentCountDown(String cardIdx) {
		int n = sqlsession.update("woney.setcardCommentCountDown", cardIdx);
		return n;
	}
//////////////////////////////////////////////////////////////////////

	// 카드 수정 기록
	@Override
	public int setCardRecordInsert(HashMap<String, String> map) {
		int n = sqlsession.insert("woney.setCardRecordInsert", map);
		return n;
	}

	// 카드 기록 받아오기
	@Override
	public List<HashMap<String, String>> getCardRecordInfo(HashMap<String, String> map) {
		List<HashMap<String, String>> cardRedcordMap = sqlsession.selectList("woney.getCardRecordInfo", map);
		return cardRedcordMap;
	}
	
	// 트랜잭션 프로젝트 idx 받아오기
	@Override
	public String getCardRecordIdx(HashMap<String, String> map) {
		String getCardRecordIdx = sqlsession.selectOne("woney.getCardRecordIdx", map);
		return getCardRecordIdx;
	}
	
	// 카드 알람 생성
	@Override
	public int setCardAlarmInsert(String cardRecordIdx) {
		int n = sqlsession.insert("woney.setCardAlarmInsert", cardRecordIdx);
		return n;
	}


	// 카드 Description null 인지 아닌지 체크
	@Override
	public int cardRecordDescriptionCNT(String cardIdx) {
		int n = sqlsession.selectOne("woney.cardRecordDescriptionCNT", cardIdx);
		return n;
	}

	// 카드 삭제 
	@Override
	public int setCardDelete(String cardIdx) {
		int n = sqlsession.update("woney.setCardDelete", cardIdx);
		return n;
	}

	 // 카드 DueDate 생성
	@Override
	public int setCardDuDateAdd(HashMap<String, String> map) {
		int n = sqlsession.insert("woney.setCardDuDateAdd", map);
		return 0;
	}
	
	// 카드  DueDate 수정
	@Override
	public int setCardDueDateEdit(HashMap<String, String> map) {
		int n = sqlsession.update("woney.setCardDueDateEdit", map);
		return n;
	}
	
	// 카드  DueDate 삭제
	@Override
	public int setCardDueDateDelete(HashMap<String, String> map) {
		int n = sqlsession.delete("woney.setCardDueDateDelete", map);
		return 0;
	}
	
	// 카드 DueDate 삭제 체크를 위한 CNT
	@Override
	public int cardDueDateCNT(String cardIdx) {
		int cardDueDateCNT = sqlsession.selectOne("woney.cardDueDateCNT", cardIdx);
		return cardDueDateCNT;
	}
	
	// 카드 DueDate 체크 여부 확인
	@Override
	public int getCardCheck(HashMap<String, String> map) {
		int n = sqlsession.selectOne("woney.getCardCheck", map);
		return n;
	}

	// 카드 DueDate 체크 업데이트
	@Override
	public int setCheckChangeAdd(HashMap<String, String> map) {
		int n = sqlsession.update("woney.setCheckChangeAdd", map);
		return n;
	}

	// 카드 DueDate 체크해제 업데이트
	@Override
	public int setCheckChangeRemove(HashMap<String, String> map) {
		int n = sqlsession.update("woney.setCheckChangeRemove", map);
		return n;
	}
	
	// 카드 체크리스트 존재여부 확인
	@Override
	public int getCheckListCNT(String cardIdx) {
		int n = sqlsession.selectOne("woney.getCheckListCNT", cardIdx);
		return n;
	}

	// 카드 체크리스트 타이틀 생성
	@Override
	public int setCheckListTitleAdd(HashMap<String, String> map) {
		int n = sqlsession.insert("woney.setCheckListTitleAdd", map);
		return n;
	}

	// 카드  체크리스트 타이들 수정
	@Override
	public int setCheckLisTitletEdit(HashMap<String, String> map) {
		int n = sqlsession.update("woney.setCheckLisTitletEdit", map);
		return n;
	}

	// 카드  체크리스트 생성
	@Override
	public int setCheckListAdd(HashMap<String, String> map) {
		int n = sqlsession.insert("woney.setCheckListAdd", map);
		return 0;
	}

	// 카드  체크리스트 체크 상태 변경
	@Override
	public int setCheckListChange(HashMap<String, String> map) {
		int n = sqlsession.update("woney.setCheckListChange", map);
		return n;
	}

	// 카드  체크리스트 삭제
	@Override
	public int setCheckListDelete(HashMap<String, String> map) {
		int n = sqlsession.delete("woney.setCheckListDelete", map);
		return n;
	}

	// 카드 체크리스트 타이틀 삭제
	@Override
	public int setCheckListTitleDelete(HashMap<String, String> map) {
		int n = sqlsession.delete("woney.setCheckListTitleDelete", map);
		return n;
	}

	// 카드  라벨추가
	@Override
	public int setLabelAdd(HashMap<String, String> map) {
		int n = sqlsession.insert("woney.setLabelAdd", map);
		return n;
	}

}
