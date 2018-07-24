package com.spring.finalins.model;

public class CardVO {
	
	private String card_idx;
	private String fk_list_idx;
	private String card_userid;
	private String card_title;
	private String card_commentcount;
	private String card_date;
	private String card_delete_status;
	
	
	public CardVO() {}
	
	public CardVO(String card_idx, String fk_list_idx, String card_userid, String card_title, String card_commentcount,
			String card_date, String card_delete_status) {
		this.card_idx = card_idx;
		this.fk_list_idx = fk_list_idx;
		this.card_userid = card_userid;
		this.card_title = card_title;
		this.card_commentcount = card_commentcount;
		this.card_date = card_date;
		this.card_delete_status = card_delete_status;
	}

	public String getCard_idx() {
		return card_idx;
	}

	public void setCard_idx(String card_idx) {
		this.card_idx = card_idx;
	}

	public String getFk_list_idx() {
		return fk_list_idx;
	}

	public void setFk_list_idx(String fk_list_idx) {
		this.fk_list_idx = fk_list_idx;
	}

	public String getCard_userid() {
		return card_userid;
	}

	public void setCard_userid(String card_userid) {
		this.card_userid = card_userid;
	}

	public String getCard_title() {
		return card_title;
	}

	public void setCard_title(String card_title) {
		this.card_title = card_title;
	}

	public String getCard_commentcount() {
		return card_commentcount;
	}

	public void setCard_commentcount(String card_commentcount) {
		this.card_commentcount = card_commentcount;
	}

	public String getCard_date() {
		return card_date;
	}

	public void setCard_date(String card_date) {
		this.card_date = card_date;
	}

	public String getCard_delete_status() {
		return card_delete_status;
	}

	public void setCard_delete_status(String card_delete_status) {
		this.card_delete_status = card_delete_status;
	}
	
	
	

}
