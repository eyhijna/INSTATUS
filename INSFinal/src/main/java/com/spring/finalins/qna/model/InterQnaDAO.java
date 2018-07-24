package com.spring.finalins.qna.model;

import java.util.HashMap;
import java.util.List;

import com.spring.finalins.model.MemberVO;

// ====== model단 (DAO)의 인터페이스 생성 ======
public interface InterQnaDAO {
	
   int write(QnaVO qnavo);// 글쓰기(파일첨부가 없는 글쓰기)

   int write_withFile(QnaVO qnavo);// 글쓰기(파일첨부가 있는 글쓰기)
   
   int getGroupMaxno(); // ins_QnA 테이블의 groupno 의 max값 알아오기

   QnaVO getView(String qna_idx);  // 글 1개를 보여주기

	int editQna(QnaVO qnavo); // 글 1개 수정하기

	int del(String qna_idx); // 글 1개 삭제하기
	
	int getTotalCount(HashMap<String,String> map); // 검색어가 없는 총 게시물 수
	int getTotalCount2(HashMap<String, String> map2); // 검색어가 없는 총 게시물 수 & 기술문의 or 기타 선택옵션
	
	List<HashMap<String, String>> qnaList(HashMap<String, String> map); // 글목록 보여주기(검색어가 없는 것)

	
	QnaVO qnaupdate(String qna_groupno); //원글 qna_idx찾아오기
	int depthnoUpdate(String qna_idx); // 원글 qna_depthno 업데이트 하기

	

	


	

	
	

}
