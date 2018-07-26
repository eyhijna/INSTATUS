<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
   $(document).ready(function(){
	   alert("Success!");
	   myTeamInfo();
   });
   
   function myTeamInfo(){
	   
	   var frm = document.nameFrm;
	   frm.method = "GET";
	   frm.action = "<%= request.getContextPath()%>/myTeamInfo.action";
	   frm.submit();
	   
   }
</script>
</head>
<body>
    <form name="nameFrm">
      <input type="hidden" name="team_name" value="${teamvo.team_name}"/>
      <input type="hidden" name="team_idx" value="${teamvo.team_idx}"/>
      <input type="hidden" name="admin_userid" value="${teamvo.admin_userid}"/>
      <input type="hidden" name="team_delete_status" value="${teamvo.team_delete_status}"/>
      <input type="hidden" name="team_visibility_status" value="${teamvo.team_visibility_status}"/>
      <input type="hidden" name="org_filename" value="${teamvo.org_filename}"/>
      <input type="hidden" name="server_filename" value="${teamvo.server_filename}"/>
      <input type="hidden" name="file_size" value="${teamvo.file_size}"/>
       
    </form>
</body>
</html>