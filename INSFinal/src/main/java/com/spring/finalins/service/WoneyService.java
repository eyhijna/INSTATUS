package com.spring.finalins.service;

import java.util.HashMap;
import java.util.List;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.finalins.model.CardDetailVO;
import com.spring.finalins.model.InterWoneyDAO;

@Service
public class WoneyService implements InterWoneyService{

	// ===== #31. 의존객체 주입하기(DI: oDependency Injection) =====
	@Autowired
	private InterWoneyDAO dao;

	// 카드정보 받아오기
	@Override
	public HashMap<String, String> getCardInfo(String cardIdx) {
		HashMap<String, String> CardMap = dao.getCardInfo(cardIdx);
		return CardMap;
	}

	// 카드 상세 정보 받아오기
	@Override
	public HashMap<String, String> getCardDetailInfo(String cardIdx) {
		HashMap<String, String> cardDetailMap = dao.getCardDetailInfo(cardIdx);
		return cardDetailMap;
	}

	// 카드 코멘트 정보 받아오기
	@Override
	public List<HashMap<String, String>> cardCommentInfo(String cardIdx) {
		List<HashMap<String, String>> cardCommentList = dao.cardCommentInfo(cardIdx);
		return cardCommentList;
	}
	
	// 카드 완료일 받아오기
	@Override
	public HashMap<String, String> cardDueDateInfo(String cardIdx) {
		HashMap<String, String> cardDueDateMap = dao.cardDueDateInfo(cardIdx);
		return cardDueDateMap;
	}
	
	// 체크타이틀 받아오기
	@Override
	public HashMap<String, String> cardCheckTitleInfo(String cardIdx) {
		HashMap<String, String> cardCheckListMap = dao.cardCheckTitleInfo(cardIdx);
		return cardCheckListMap;
	}
	
	// 체크리스트 받아오기
	@Override
	public List<HashMap<String, String>> cardCheckListInfo(String cardIdx) {
		List<HashMap<String, String>> cardCheckList = dao.cardCheckListInfo(cardIdx);
		return cardCheckList;
	}
	
	// 카드 라벨리스트 받아오기
	@Override
	public List<HashMap<String, String>> cardLabelListInfo(String cardIdx) {
		List<HashMap<String, String>> cardLabelList = dao.cardLabelListInfo(cardIdx);
		return cardLabelList;
	}
	
	// 카드 라벨 갯수 정보
	@Override
	public int cardLabelCNT(String cardIdx) {
		int n = dao.cardLabelCNT(cardIdx);
		return n;
	}
	
	// 프로젝트 멤버 체크
	@Override
	public String getProjectMember(HashMap<String, String> map) {
		int n = dao.getProjectMember(map);
		
		String str_jsonobj = null;
		JSONObject jsonObj =  new JSONObject();
		jsonObj.put("CNT", n);
		str_jsonobj = jsonObj.toString();
		
		return str_jsonobj;
	}
	
	// 카드 제목 수정 후 기록
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED,rollbackFor= {Throwable.class})
	public int setCardTitleUpdate(HashMap<String, String> map) throws Throwable {
	int result = 0;
		
		int n = 0;
		n = dao.setCardTitleUpdate(map);
		
		if(n==1) {
			int m = dao.setCardRecordInsert(map);
			String cardRecordIdx = dao.getCardRecordIdx(map);
			if(m==1) {
				result = dao.setCardAlarmInsert(cardRecordIdx);
			}
		}
		return result;
	}

	// 카드 정보와 기록 JSON으로 받아오기
	@Override
	public String getCardInfoJSON(HashMap<String, String> map) {
		HashMap<String, String> CardMap = dao.getCardInfo(map.get("cardIdx"));
		
		String str_jsonobj = null;
		if(CardMap !=null) {
		JSONObject jsonObj =  new JSONObject();
		jsonObj.put("CARDIDX", CardMap.get("CARDIDX"));
		jsonObj.put("CARDTITLE", CardMap.get("CARDTITLE"));
		
		str_jsonobj = jsonObj.toString();
		System.out.println("str_jsonobj :"+str_jsonobj);
		}
		return str_jsonobj;
		
	}
	
	// 카드 Description 존재 여부 체크
	@Override
	public int cardDescriptionCNT(String cardIdx) {
		int cnt = dao.cardDescriptionCNT(cardIdx);
		return cnt;
	}

	// 카드 Description 입력
	@Override
	public int setcardDescriptionInsert(String cardIdx) throws Throwable{
		int n = dao.setcardDescriptionInsert(cardIdx);

		return n;
	}

	// 카드 Description 수정
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED,rollbackFor= {Throwable.class})
	public int setcardDescriptionUpdate(HashMap<String, String> map) {
		int result = 0;
		
		int n = dao.setcardDescriptionUpdate(map);
		if(n==1) {
			int m = dao.setCardRecordInsert(map);
			String cardRecordIdx = dao.getCardRecordIdx(map);
			if(m==1) {
				result = dao.setCardAlarmInsert(cardRecordIdx);
			}
		}
		return result;
	}

	// 카드 Description 정보 JSON으로 받아오기
	@Override
	public String getCardDescriptionInfoJSON(String cardIdx) {
		HashMap<String, String> cardDetailMap = dao.getCardDetailInfo(cardIdx);
		
		String str_jsonobj = null;
		if(cardDetailMap !=null) {
		JSONObject jsonObj =  new JSONObject();
		jsonObj.put("FKCARDIDX", cardDetailMap.get("FKCARDIDX"));
		jsonObj.put("DESCRIPTION", cardDetailMap.get("DESCRIPTION"));
		
		str_jsonobj = jsonObj.toString();
		System.out.println("str_jsonobj :"+str_jsonobj);
		}
		return str_jsonobj;
	}

	// 파일첨부 추가
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED,rollbackFor= {Throwable.class})
	public int add_withFile(CardDetailVO cardvo,HashMap<String,String> map) {
		int result = 0;
		int n = dao.add_withFile(cardvo);
		if(n==1) {
			int m = dao.setCardRecordInsert(map);
			String cardRecordIdx = dao.getCardRecordIdx(map);
			if(m==1) {
				result = dao.setCardAlarmInsert(cardRecordIdx);
			}
		}
		
		return result;
	}

	// 카드 첨부파일 삭제
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED,rollbackFor= {Throwable.class})
	public int setcardAttachDelete(HashMap<String,String> map) {
		int result = 0;
		
		int n = 0;
		n = dao.setcardAttachDelete(map.get("cardIdx"));
		if(n==1) {
			int m = dao.setCardRecordInsert(map);
			String cardRecordIdx = dao.getCardRecordIdx(map);
			if(m==1) {
				result = dao.setCardAlarmInsert(cardRecordIdx);
			}
		}
		
		return result;
	}

	// 카드 Comment 입력 후 ins_card 테이블에 commentcount수 증가
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED,rollbackFor= {Throwable.class})
	public int setcardaddComment(HashMap<String, String> map)  throws Throwable{
		int result = 0;
		
		int n = 0;
		n = dao.setcardaddComment(map);
		
		if(n==1) {
			int m = dao.setcardCommentCountUP(map.get("cardIdx"));
			if(m == 1) {
				int a = dao.setCardRecordInsert(map);
				String cardRecordIdx = dao.getCardRecordIdx(map);
				if(a==1) {
					result = dao.setCardAlarmInsert(cardRecordIdx);
				}
			}
		}
		return result;
	}

	// 카드 Comment 수정
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED,rollbackFor= {Throwable.class})
	public int setcardCommentEdit(HashMap<String, String> map) {
		int result = 0;
		int n = dao.setcardCommentEdit(map);
		if(n==1) {	
			int m = dao.setCardRecordInsert(map);
			String cardRecordIdx = dao.getCardRecordIdx(map);
			if(m==1) {
				result = dao.setCardAlarmInsert(cardRecordIdx);
			}
		}
		return result;
	}

	// 카드 Comment 삭제 후  ins_card 테이블에 commentcount수 감소 
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED,rollbackFor= {Throwable.class})
	public int setcardCommentDelete(HashMap<String, String> map) throws Throwable{
		int result = 0;
		
		int n = 0;
		 n = dao.setcardCommentDelete(map);
		 if(n==1) {
				int m = dao.setcardCommentCountDown(map.get("cardIdx"));
				if(m == 1) {
					int a = dao.setCardRecordInsert(map);
					String cardRecordIdx = dao.getCardRecordIdx(map);
					if(a==1) {
						result = dao.setCardAlarmInsert(cardRecordIdx);
					}
				}
			}
		return result;
	}

	// 카드 기록 받아오기
	@Override
	public List<HashMap<String, String>> getCardRecordInfo(HashMap<String, String> cardRecordIDXMap) {
		List<HashMap<String, String>> cardRecordList = dao.getCardRecordInfo(cardRecordIDXMap);
		return cardRecordList;
	}

	// 카드 Description null 인지 아닌지 체크
	@Override
	public int cardRecordDescriptionCNT(String cardIdx) {
		int n = dao.cardRecordDescriptionCNT(cardIdx);
		return n;
	}

	// 카드 기록 입력
	@Override
	public int setCardRecordInsert(HashMap<String, String> map) {
		int n = dao.setCardRecordInsert(map);
		return n;		
	}

	// 카드 삭제 
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED,rollbackFor= {Throwable.class})
	public int setCardDelete(HashMap<String, String> map) {
		int result = 0, m=0;
	
		int n = dao.setCardDelete(map.get("cardIdx")); 
		if(n==1) {	
			m = dao.setCardRecordInsert(map);
			String cardRecordIdx = dao.getCardRecordIdx(map);
			if(m==1) {
				result = dao.setCardAlarmInsert(cardRecordIdx);
			}
		}
		return result;
	}

	// 카드 DueDate 생성
	@Override
	public int setCardDuDateAdd(HashMap<String, String> map) {
		int n = dao.setCardDuDateAdd(map);
		return n;
	}

	// 카드  DueDate 수정
	@Override
	public int setCardDueDateEdit(HashMap<String, String> map) {
		int n = dao.setCardDueDateEdit(map);
		return n;
	}
	
	// 카드  DueDate 삭제
	@Override
	public int setCardDueDateDelete(HashMap<String, String> map) {
		int n = dao.setCardDueDateDelete(map);
		return n;
	}

	// 카드 DueDate 삭제 체크를 위한 CNT
	@Override
	public int cardDueDateCNT(String cardIdx) {
		int cardDueDateCNT = dao.cardDueDateCNT(cardIdx);
		return cardDueDateCNT;
	}

	// 카드 DueDate 체크 여부 확인
	@Override
	public int cardCheck(HashMap<String, String> map) {
		int m = 0 ; 
		int result =0;
		int n = dao.getCardCheck(map);
		
		if(n ==0) {
			m = dao.setCheckChangeAdd(map);
		}else if(n==1) {
			m = dao.setCheckChangeRemove(map);
		}

		if(m > 0) {
			result = dao.getCardCheck(map);
		}
		return result;
	}

	// 카드 체크리스트 존재여부 확인
	@Override
	public int getCheckListCNT(String cardIdx) {
		int n = dao.getCheckListCNT(cardIdx);
		return n;
	}
	
	// 카드 체크리스트 타이틀 생성
	@Override
	public int setCheckListTitleAdd(HashMap<String, String> map) {
		int n = dao.setCheckListTitleAdd(map);
		return n;
	}

	// 카드  체크리스트 타이들 수정
	@Override
	public int setCheckLisTitletEdit(HashMap<String, String> map) {
		int n = dao.setCheckLisTitletEdit(map);
		return n;
	}

	// 카드  체크리스트 생성
	@Override
	public int setCheckListAdd(HashMap<String, String> map) {
		int n = dao.setCheckListAdd(map);
		return n;
	}

	// 카드  체크리스트 체크 상태 변경
	@Override
	public int setCheckListChange(HashMap<String, String> map) {
		int n = dao.setCheckListChange(map);
		return n;
	}

	// 카드  체크리스트 삭제
	@Override
	public int setCheckListDelete(HashMap<String, String> map) {
		int n = dao.setCheckListDelete(map);
		return n;
	}

	// 카드 체크리스트 타이틀 삭제
	@Override
	public int setCheckListTitleDelete(HashMap<String, String> map) {
		int n = dao.setCheckListTitleDelete(map);
		return n;
	}

	// 카드  라벨추가
	@Override
	public int setLabelAdd(HashMap<String, String> map) {
		int n = dao.setLabelAdd(map);
		return n;
	}

}
