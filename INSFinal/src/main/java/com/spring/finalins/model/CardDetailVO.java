package com.spring.finalins.model;

import org.springframework.web.multipart.MultipartFile;

public class CardDetailVO {
	/*private String card_idx;  // 시퀀스 seq_card
	private String fk_list_idx; //리스트번호
	private String card_userid; //카드작성유저ID
	private String card_title; //카드제목
	private String card_commentCount; //카드댓글수
	private String card_date; //카드작성일
	private String card_delete_status; //0:카드삭제 1:카드사용
	*/
	//카드 디테일
	private String card_detail_idx; //시퀀스 seq_card_detail
	private String fk_card_idx; // 카드번호
	private String card_description; // 카드상세내용
	private String card_filename; // 카드첨부파일이름
	private String card_orgfilename; // 첨부파일원본이름
	private String card_byte;// 첨부파일 사이즈
	
	private MultipartFile attach;
	
	public CardDetailVO() {}
	public CardDetailVO(String card_detail_idx, String fk_card_idx, String card_description, String card_filename,
			String card_orgfilename, String card_byte) {
		super();
		this.card_detail_idx = card_detail_idx;
		this.fk_card_idx = fk_card_idx;
		this.card_description = card_description;
		this.card_filename = card_filename;
		this.card_orgfilename = card_orgfilename;
		this.card_byte = card_byte;
	}
	
	public String getCard_detail_idx() {
		return card_detail_idx;
	}
	public void setCard_detail_idx(String card_detail_idx) {
		this.card_detail_idx = card_detail_idx;
	}
	public String getFk_card_idx() {
		return fk_card_idx;
	}
	public void setFk_card_idx(String fk_card_idx) {
		this.fk_card_idx = fk_card_idx;
	}
	public String getCard_description() {
		return card_description;
	}
	public void setCard_description(String card_description) {
		this.card_description = card_description;
	}
	public String getCard_filename() {
		return card_filename;
	}
	public void setCard_filename(String card_filename) {
		this.card_filename = card_filename;
	}
	public String getCard_orgfilename() {
		return card_orgfilename;
	}
	public void setCard_orgfilename(String card_orgfilename) {
		this.card_orgfilename = card_orgfilename;
	}
	public String getCard_byte() {
		return card_byte;
	}
	public void setCard_byte(String card_byte) {
		this.card_byte = card_byte;
	}
	public MultipartFile getAttach() {
		return attach;
	}

	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}
}
