<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<script type="text/javascript">
   <c:if test="${n==1}" >
     location.href="<%= request.getContextPath() %>/qna.action"   
   </c:if>   
   <c:if test="${n <1}" >
     alert("글쓰기에 실패하셨습니다.");
     location.href="javascript:history.back();";   
   </c:if>   
 </script>  