<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script type="text/javascript">
	if(${n==1} ){ 
		alert("회원이 되신걸 축하합니다! 로그인 후 Ins groupware를 이용하실 수 있습니다.");
		location.href = "<%=request.getContextPath()%>/index.action";
	}
	else{
		alert("회원가입에 실패했습니다. 다시 시도해주세요!!");
		location.href = "<%=request.getContextPath()%>/signup.action";
	}
	
</script>