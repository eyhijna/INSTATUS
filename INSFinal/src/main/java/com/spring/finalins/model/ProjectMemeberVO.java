package com.spring.finalins.model;

public class ProjectMemeberVO {

	private String project_member_idx;
	private String fk_project_idx;
	private String project_member_userid;
	private String project_member_status;
	private String project_member_admin_status;
	private String project_favorite_status;
	
	
	public ProjectMemeberVO() {}
	
	public ProjectMemeberVO(String project_member_idx, String fk_project_idx, String project_member_userid,
			String project_member_status, String project_member_admin_status, String project_favorite_status) {
		
		this.project_member_idx = project_member_idx;
		this.fk_project_idx = fk_project_idx;
		this.project_member_userid = project_member_userid;
		this.project_member_status = project_member_status;
		this.project_member_admin_status = project_member_admin_status;
		this.project_favorite_status = project_favorite_status;
	}
	
	
	
	
	
	public String getProject_member_idx() {
		return project_member_idx;
	}
	public void setProject_member_idx(String project_member_idx) {
		this.project_member_idx = project_member_idx;
	}
	public String getFk_project_idx() {
		return fk_project_idx;
	}
	public void setFk_project_idx(String fk_project_idx) {
		this.fk_project_idx = fk_project_idx;
	}
	public String getProject_member_userid() {
		return project_member_userid;
	}
	public void setProject_member_userid(String project_member_userid) {
		this.project_member_userid = project_member_userid;
	}
	public String getProject_member_status() {
		return project_member_status;
	}
	public void setProject_member_status(String project_member_status) {
		this.project_member_status = project_member_status;
	}
	public String getProject_member_admin_status() {
		return project_member_admin_status;
	}
	public void setProject_member_admin_status(String project_member_admin_status) {
		this.project_member_admin_status = project_member_admin_status;
	}
	public String getProject_favorite_status() {
		return project_favorite_status;
	}
	public void setProject_favorite_status(String project_favorite_status) {
		this.project_favorite_status = project_favorite_status;
	}
	
	
	
}
