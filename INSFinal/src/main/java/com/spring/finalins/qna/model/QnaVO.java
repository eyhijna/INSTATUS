package com.spring.finalins.qna.model;

import org.springframework.web.multipart.MultipartFile;

public class QnaVO {  // 코멘트는 필요 없음. 원글러 + 관리자답글
	
	// 데이터베이스에서 int여도 vo에서 즉, 웹상에서 오가는 값은 숫자 표현이 안되서 (String) 으로 전부 받기 때문에
	// 하여간 여긴선 String으로 하여도 된다.
	
	
	//private String pw;        // 비밀번호 글 비밀번호가 필요한 것인가? 필요 없지 않을까?
	
	
	private String qna_idx; // 시퀀스 seq_qna
	private String fk_userid;  //-QnA작성자ID
	private int fk_qna_category_idx;//카테고리idx
	private String qna_title; //문의제목
	private String qna_content; //문의내용
	private String qna_date;  //문의작성일
	
	private String qna_fk_idx; //원글번호  --> String type으로 요청하기
	 /*
    fk_seq 컬럼은 절대로 foreign key가 아니다.
    fk_seq 컬럼은 자신의 글(답변글)에 있어서 
        원글(부모글)이 누구인지에 대한 정보값이다.
        답변글쓰기에 있어서 답변글이라면 fk_seq 컬럼의 값은 
        원글(부모글)의 seq 컬럼의 값을 가지게 되며,
        답변글이 아닌 원글일 경우 0 을 가지도록 한다.
   */
	private String qna_depthno; //답글여부
	/*
	  답변글쓰기에 있어서 답변글 이라면                                                
       원글(부모글)의 depthno + 1 을 가지게 되며,
       답변글이 아닌 원글일 경우 0 을 가지도록 한다.
	*/
	
	private String qna_groupno; //그룹번호
	/*
    답변글쓰기에 있어서 그룹번호
       원글(부모글)과 답변글은 동일한 groupno 를 가진다. 
       답변글이 아닌 원글(부모글)인 경우 groupno 의 값은 groupno 컬럼의 최대값(max)+1 로 한다.   
 */
	
	// 아래 3개의 컬럼은 파일첨부용이다.
	private String qna_filename;//첨부파일명 // WAS(톰캣)에 저장될 파일명(20161121324325454354353333432.png)
	/*
	  A와 B가 아무리 똑같은 파일을 업로드해도 was 서버에서는 위와 같이 나노초까지 다른 파일네임으로 저장된다.
    was 서버에서 등록된 파일네임은 랜덤이 아니라 시간초로 등록되기때문에 고유한 값이다.
        그러나 was에 등록된 파일네임은 숫자로 되면 알아보기 힘드니까
    filename은 was에 등록된 파일네임이고 orgFilename은 A라는 사람이 등록한 파일네임으로 구분하겠다.
	 */
	
	private String qna_orgfilename; //첨부파일원본명 진짜 파일명(강아지.png)   // 사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명
	
	private String qna_byte; //첨부파일사이즈
	
	
	private MultipartFile attach; // 진짜 파일 (위에 것은 파일이름일뿐 이것이 진짜 파일이다!!) ==> WAS(톰캣) 디스크에 저장됨.
    // MultipartFile attach 는 오라클 데이터베이스 tblBoardd 테이블의 컬럼이 아니다!!!!!!
	
	
	
	
	
	// ===== #83. commentCount 프로퍼티 추가하기
		//            먼저 tblBoard 테이블에 commentCount 컬럼을 추가한다.
	//	private String commentCount; // 댓글수 
		
		// ===== #118. 답변형 게시판을 위한 멤버변수 추가하기
		//             먼저, 오라클에서 tblBoard 테이블 tblComment 테이블을 기존에 있는 것을 삭제하고 새로 해야 한다. 
		
		/*
		   <답변글> 
		 두번째 원글에 대한 답변글(4)
		seq                   fk_seq          depthno(깊이)
		13	세번째원글(3)         0                   0
		12	두번째원글(2)         0                   0
		11	첫번째원글(1)         0                   0             groupno max(groupno) +1
			                                                      --> null값이 없으니까 첫번째는 0이기 때문에 1이 나온다.
			
		14	세번째원글(3)         0                   0
		13	두번째원글(2)         0                   0
		15	   |- RE 두번째 원글에 대한 답변글         2    13    0+1   (원글과 답변글은 동일한 groupno를 갖도록 짤 것이다.)        // 답변글은 오름차순, 원글은 내림차순      
		17        |-Re 두번째 원글에 대한 답변글의 답변글(부모글은 15번이다)  2(groupno)  15(fk_seq)   1+1(depthno)  (padding-left: 20이면 10*2 =20이고  0일 경우 10*0=0)   
		16	   |- RE 두번째 원글에 대한 또답변글       2    13    0+1
		12	첫번째원글(1)         0                   0

		 */
	
	
	
	public QnaVO() {}	
	

	public QnaVO(String qna_idx, String fk_userid, int fk_qna_category_idx, String qna_title, String qna_content, String qna_date,
			String qna_fk_idx, String qna_depthno, String qna_groupno, String qna_filename, String qna_orgfilename,
			String qna_byte, MultipartFile attach) {
		
		this.qna_idx = qna_idx;
		this.fk_userid = fk_userid;
		this.fk_qna_category_idx = fk_qna_category_idx;
		this.qna_title = qna_title;
		this.qna_content = qna_content;
		this.qna_date = qna_date;
		this.qna_fk_idx = qna_fk_idx;
		this.qna_depthno = qna_depthno;
		this.qna_groupno = qna_groupno;
		this.qna_filename = qna_filename;
		this.qna_orgfilename = qna_orgfilename;
		this.qna_byte = qna_byte;
		this.attach = attach;
	}


	public String getQna_idx() {
		return qna_idx;
	}


	public void setQna_idx(String qna_idx) {
		this.qna_idx = qna_idx;
	}


	public String getFk_userid() {
		return fk_userid;
	}


	public void setFk_userid(String fk_userid) {
		this.fk_userid = fk_userid;
	}


	public int getFk_qna_category_idx() {
		return fk_qna_category_idx;
	}


	public void setFk_qna_category_idx(int fk_qna_category_idx) {
		this.fk_qna_category_idx = fk_qna_category_idx;
	}


	public String getQna_title() {
		return qna_title;
	}


	public void setQna_title(String qna_title) {
		this.qna_title = qna_title;
	}


	public String getQna_content() {
		return qna_content;
	}


	public void setQna_content(String qna_content) {
		this.qna_content = qna_content;
	}


	public String getQna_date() {
		return qna_date;
	}


	public void setQna_date(String qna_date) {
		this.qna_date = qna_date;
	}


	public String getQna_fk_idx() {
		return qna_fk_idx;
	}


	public void setQna_fk_idx(String qna_fk_idx) {
		this.qna_fk_idx = qna_fk_idx;
	}


	public String getQna_depthno() {
		return qna_depthno;
	}


	public void setQna_depthno(String qna_depthno) {
		this.qna_depthno = qna_depthno;
	}


	public String getQna_groupno() {
		return qna_groupno;
	}


	public void setQna_groupno(String qna_groupno) {
		this.qna_groupno = qna_groupno;
	}


	public String getQna_filename() {
		return qna_filename;
	}


	public void setQna_filename(String qna_filename) {
		this.qna_filename = qna_filename;
	}


	public String getQna_orgfilename() {
		return qna_orgfilename;
	}


	public void setQna_orgfilename(String qna_orgfilename) {
		this.qna_orgfilename = qna_orgfilename;
	}


	public String getQna_byte() {
		return qna_byte;
	}


	public void setQna_byte(String qna_byte) {
		this.qna_byte = qna_byte;
	}


	public MultipartFile getAttach() {
		return attach;
	}


	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}
	
	

	
	

	

}
