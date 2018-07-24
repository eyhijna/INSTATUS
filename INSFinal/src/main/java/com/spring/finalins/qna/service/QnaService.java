package com.spring.finalins.qna.service;

import java.util.HashMap;
import java.util.List;

import org.apache.tools.ant.util.SymbolicLinkUtils;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.finalins.model.MemberVO;
import com.spring.finalins.qna.model.InterQnaDAO;
import com.spring.finalins.qna.model.QnaVO;



// ====== #30. Service 선언
@Service
public class QnaService implements InterQnaService {

		// ======= #31. 의존객체 주입하기(DI: Dependency Injection)
		@Autowired
		private InterQnaDAO dao;
		
	   @Override
	   public int write(QnaVO qnavo) {
	      
	      // ==== #123. 글쓰기가 원글쓰기인지 아니면 답변글쓰기인지를 구분하여
	      //            tblBoard 테이블에 insert 를 해줘야 한다.
	      //            원글쓰기 라면 tblBoard 테이블의 groupno 컬럼의 값은
	      //            max값 +1 로 해야 하고,
	      //            답변글쓰기 라면 넘겨 받은 값을 그대로 insert 해줘야 한다.
	      
	      // 원글쓰기인, 답변글쓰기인지 구분하기
	      if(qnavo.getQna_fk_idx() == null ||qnavo.getQna_fk_idx().trim().isEmpty()) { // 원글을 쓸 경우!
	         // 원글쓰기인 경우
	          int groupno = dao.getGroupMaxno()+1;  //(groupno는 max+1)   
	          qnavo.setQna_groupno(String.valueOf(groupno));// db에서 읽어와서 qnavo에 set을 해줬다. 그래서 board.xml에서 글쓰기 add를 할 때 qnavo에 있는 getGroupno를 넣어주면 된다.
	      }
 
	      int n = dao.write(qnavo);
	      return n;
	   }

	   

	   
	   // ===== #139. 파일첨부가 있는 글쓰기(답변형 게시판)   =====
	   @Override
	   public int write_withFile(QnaVO qnavo) {
	      
	      // ==== #123. 글쓰기가 원글쓰기인지 아니면 답변글쓰기인지를 구분하여
	      //            tblBoard 테이블에 insert 를 해줘야 한다.
	      //            원글쓰기 라면 tblBoard 테이블의 groupno 컬럼의 값은
	      //            max값 +1 로 해야 하고,
	      //            답변글쓰기 라면 넘겨 받은 값을 그대로 insert 해줘야 한다.
	      
	      // 원글쓰기인, 답변글쓰기인지 구분하기
	      if(qnavo.getQna_fk_idx() == null || qnavo.getQna_fk_idx().trim().isEmpty()) { // 원글을 쓸 경우!
	         // 원글쓰기인 경우
	          int groupno = dao.getGroupMaxno()+1;  //(groupno는 max+1)   
	          System.out.println("groupno"+groupno);
	          
	          
	         qnavo.setQna_groupno(String.valueOf(groupno));// db에서 읽어와서 qnavo에 set을 해줬다. 그래서 board.xml에서 글쓰기 add를 할 때 qnavo에 있는 getGroupno를 넣어주면 된다.
	      }
	      
	      int n = dao.write_withFile(qnavo);
	      return n;
	   }

	   
	   // 글 1개 보기 (조회수 없음)
	   @Override
	   public QnaVO getView(String qna_idx) {
	       QnaVO qnavo = dao.getView(qna_idx); 
	      return qnavo;
	   }

	
		// 글 1개 수정하기   
		@Override
		public int editQna(QnaVO qnavo) {
			int n = dao.editQna(qnavo);
			return n;
		}

	   // 글 1개 삭제하기
		@Override
		public int del(String qna_idx) {
			int n = dao.del(qna_idx);
			return n;
		}


		// ===== #114.   검색어가 없는 총 게시물 건수   =====
		@Override
		public int getTotalCount(HashMap<String,String> map) {
			int totalCount = dao.getTotalCount(map);
			return totalCount;
		}
		
		// 검색어가 없는 총 게시물 수 & 기술문의 or 기타 선택옵션
	   @Override
		public int getTotalCount2(HashMap<String, String> map2) {
			int totalCount = dao.getTotalCount2(map2);
			return totalCount;
		}


		// ===== #107. 글목록 보여주기(검색어가 없는 것) =====
		@Override
		public List<HashMap<String,String>> qnaList(HashMap<String, String> map) {	
			List<HashMap<String,String>> qnaList =  dao.qnaList(map);
		    return qnaList;
		}
		
		
				
		
		
		
		// 글쓰기(트랜잭션 처리함)
		/*
		   >>>> 트랜잭션처리를 해야 할 메소드에 @Transactional 어노테이션을 설정하면 된다. 
		   rollbackFor= {Throwable.class} 은 롤백을 해야 할 범위를 말한다.
		   Throwable.class 은 error 및 exception 을 포함한 최상위 루트이다.
		     즉, 해당 메소드 실행시 발생하는 모든 error 및 exception 에 대해서 롤백을 하겠다.
		     
		   isolation=Isolation.READ_COMMITTED  커밋되어진다.
		 */
		@Override
		@Transactional( propagation=Propagation.REQUIRED,  isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})   // 트랜잭션 처리를 위해 @Transactional를 한다.
		// 체크제약에 위배되면 throws throwable한다. 던져버린 것을 spring container가 처리하고 이것을 여기서...
		public int updateQnaDepthno(QnaVO qnavo) throws Throwable{
	
			String qna_groupno = qnavo.getQna_groupno();
			QnaVO qnaupdate = dao.qnaupdate(qna_groupno);
			
			String qna_idx = qnaupdate.getQna_idx();
		    int m = dao.depthnoUpdate(qna_idx);	

			return m;
		}



		
	
	
	

}
