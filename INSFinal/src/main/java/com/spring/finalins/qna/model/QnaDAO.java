package com.spring.finalins.qna.model;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.finalins.model.MemberVO;

// ===== #.28 DAO 선언
@Repository
public class QnaDAO implements InterQnaDAO {

		// ===== #29. 의존객체 주입하기(DI: Dependency Injection)
		// root-context.xml 의 의존객체 설정하기에서 어떤 클래스에 주입할지 알 수 있음
		@Autowired
		private SqlSessionTemplate sqlsession;

	
		 // ======  글쓰기(파일첨부가 없는 글쓰기) ====== 
	    @Override
	    public int write(QnaVO qnavo) {;
	      //mybatis
	      int n = sqlsession.insert("qna.write", qnavo);
	      return n;
	    }

	   // =====  ins_QnA 테이블의 groupno 의 max값 알아오기 ===== 
	   @Override
	   public int getGroupMaxno() {
	      int max = sqlsession.selectOne("qna.getGroupMaxno");
	      return max;
	   }
	   
	   
	   // =====  파일첨부가 있는 글쓰기(답변형 게시판) ===== 
	   @Override
	   public int write_withFile(QnaVO qnavo) {
	      int n = sqlsession.insert("qna.write_withFile", qnavo);
	      return n;
	   }


	   // =======  글 1개 보여주기 =====
	   @Override
	   public QnaVO getView(String qna_idx) {
	      QnaVO qnavo = sqlsession.selectOne("qna.getView", qna_idx);
	      return qnavo;
	   }

	   // 글 1개 수정하기
		@Override
		public int editQna(QnaVO qnavo) {
		    int n = sqlsession.update("qna.editQna", qnavo);
			return n;
		}

		// 글 1개 삭제하기
		@Override
		public int del(String qna_idx) {
			int n = sqlsession.delete("qna.del", qna_idx);
			return n;
		}
		
		
		// ===== #115. 검색어가 없는 총 게시물 건수 =====
		@Override
		public int getTotalCount(HashMap<String,String> map) {
			int totalCount = sqlsession.selectOne("qna.getTotalCount", map);
			return totalCount;
		}
		// 검색어가 없는 총 게시물 수 & 기술문의 or 기타 선택옵션
 	   @Override
		public int getTotalCount2(HashMap<String, String> map2) {
			int totalCount = sqlsession.selectOne("qna.getTotalCount2", map2);
			return totalCount;
		}
		
		
		// ===== #108. 글목록 보여주기(검색어가 있는 것) =====
	/*	@Override
		public List<QnaVO> qnaList2(HashMap<String, String> map) {
			List<QnaVO> qnaList = sqlsession.selectList("qna.qnaList2", map);
			return qnaList ;
		}
		*/
		// ===== #108. 글목록 보여주기(검색어가 없는 것) =====
		@Override
		public List<HashMap<String,String>> qnaList(HashMap<String, String> map) {
						
			System.out.println("확인용 "+map.get("userid"));
			
			List<HashMap<String,String>> qnaList = sqlsession.selectList("qna.qnaList", map);
			return qnaList ;
		}
	  

		@Override
		public QnaVO qnaupdate(String qna_groupno) {
			
	         QnaVO qnaupdate = sqlsession.selectOne("qna.qnaupdate", qna_groupno);
	         
	         qnaupdate.getQna_idx();
	         
	         System.out.println("원글 번호"+qnaupdate.getQna_idx());
			
			return qnaupdate;
		}

		@Override
		public int depthnoUpdate(String qna_idx) {
			int m = sqlsession.update("qna.depthnoUpdate", qna_idx);
			return m;
		}

	
		
		
}
