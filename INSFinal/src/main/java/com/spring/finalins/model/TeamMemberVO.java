package com.spring.finalins.model;

public class TeamMemberVO {
	 
	private String fk_team_idx;   // 팀번호
	private String team_userid;  // 팀멤버ID
	private String team_member_admin_status; // 0:일반유저 1:부관리자 2:관리자  
	
	public TeamMemberVO() {}
	public TeamMemberVO(String fk_team_idx, String team_userid,
			String team_member_admin_status) {
		super(); 
		this.fk_team_idx = fk_team_idx;
		this.team_userid = team_userid;
		this.team_member_admin_status = team_member_admin_status;
	}
	 
	public String getFk_team_idx() {
		return fk_team_idx;
	}
	public void setFk_team_idx(String fk_team_idx) {
		this.fk_team_idx = fk_team_idx;
	}
	public String getTeam_userid() {
		return team_userid;
	}
	public void setTeam_userid(String team_userid) {
		this.team_userid = team_userid;
	}
	public String getTeam_member_admin_status() {
		return team_member_admin_status;
	}
	public void setTeam_member_admin_status(String team_member_admin_status) {
		this.team_member_admin_status = team_member_admin_status;
	}
	
	
	

}
