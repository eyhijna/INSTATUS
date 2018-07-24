package com.spring.finalins.model;

public class ProjectVO {

	private String project_idx; 
	private String fk_team_idx;
	private String project_name;
	private String project_visibility_st;
	private String project_delete_status;
	private String fk_project_image_idx;
	
	public ProjectVO() {}
	
	
	public ProjectVO(String project_idx, String fk_team_idx, String project_name, String project_visibility_st,
			String project_delete_status, String project_profilejpg,
			String fk_project_image_idx) {
		
		this.project_idx = project_idx;
		this.fk_team_idx = fk_team_idx;
		this.project_name = project_name;
		this.project_visibility_st = project_visibility_st;
		this.project_delete_status = project_delete_status;
		this.fk_project_image_idx = fk_project_image_idx;
	}


	public String getProject_idx() {
		return project_idx;
	}


	public void setProject_idx(String project_idx) {
		this.project_idx = project_idx;
	}


	public String getFk_team_idx() {
		return fk_team_idx;
	}


	public void setFk_team_idx(String fk_team_idx) {
		this.fk_team_idx = fk_team_idx;
	}


	public String getProject_name() {
		return project_name;
	}


	public void setProject_name(String project_name) {
		this.project_name = project_name;
	}


	public String getProject_visibility_st() {
		return project_visibility_st;
	}


	public void setProject_visibility_st(String project_visibility_st) {
		this.project_visibility_st = project_visibility_st;
	}


	public String getProject_delete_status() {
		return project_delete_status;
	}


	public void setProject_delete_status(String project_delete_status) {
		this.project_delete_status = project_delete_status;
	}


	public String getFk_project_image_idx() {
		return fk_project_image_idx;
	}


	public void setFk_project_image_idx(String fk_project_image_idx) {
		this.fk_project_image_idx = fk_project_image_idx;
	}
	
}
