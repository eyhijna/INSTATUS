<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script type="text/javascript">
	if(${sessionScope.loginuser.userid == 'admin'} ){ 
		alert("관리자 아이디로 로그인하셨습니다.");
		location.href = "<%=request.getContextPath()%>/index.action";
	}
	else if(${sessionScope.loginuser.userid != 'admin' && sessionScope.loginuser != null}){ 
		alert("${sessionScope.loginuser.name}" + "님 접속하셨습니다.");
		location.href = "<%=request.getContextPath()%>/index.action";
	}
	else{
		alert("로그인 실패!");
		location.href = "<%=request.getContextPath()%>/index.action";
	}
	
</script>