<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script type="text/javascript">
  
  if(${requestScope.n == 1}) {
	 
	  alert("글수정 성공!!");
	  
	  location.href="<%= request.getContextPath() %>/qna.action";
       
  }
  else {
	  alert("글수정 실패!!");
	  location.href="<%= request.getContextPath() %>/qna.action";
  }
</script>

 <form name="goViewFrm">
     <input type="hidden" name="qna_idx" value="${qna_idx}"/>
  </form>