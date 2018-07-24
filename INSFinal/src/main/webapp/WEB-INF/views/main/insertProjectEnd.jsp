<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script type="text/javascript">
	if(${result != 2}){
		alert("프로젝트가 생성에 실패했습니다.");
		location.href = "<%=request.getContextPath()%>/index.action";
	}
	else if(${result ==2}){
		alert("프로젝트가 생성되었습니다.");
		<%-- location.href = "<%=request.getContextPath()%>/project/project.action?project_name=${project_info.project_name}&projectIDX=${project_info.projectIDX}"; --%>
		location.href = "<%=request.getContextPath()%>/project.action?project_name=${project_info.project_name}&projectIDX=${project_info.projectIDX}&team_IDX=${project_info.team_idx}";
	}
	
</script>