<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> --%>

<jsp:include page="top.jsp" /> 

<style>


 /*   table, th, td {border: solid 1px gray;}
   
   #table, #table2 {width: 1000px; border-collapse: collapse;}
   
   #table th, #table td {padding: 5px;}
   
   #table th {width: 120px; background-color: #DDDDDD; }
   #table td {width: 860px;}
   
   a{text-decoration: none;}
    */
  
</style>

    
<script type="text/javascript">

    function replyQna() {

      var frm = document.replyFrm;
      
  //    var qna_fk_idx = $("#qna_fk_idx").val();
      
   //   console.log(qna_fk_idx);
      frm.action="goWrite.action";
      frm.method = "post";
      frm.submit();
   }   

  function deleteQna(qna_idx){
    	
    if(confirm("정말 삭제하시겠습니까?") == true){

    	// 팝업창을 띄운 뒤 한 번 더 묻고 예/아니오 예라고 선택했을 때 del
    	var qna_idx = ${qnavo.qna_idx};
    	var frm = document.delFrm;
    	frm.qna_idx.value= qna_idx;;
    	frm.action = "del.action";
    	frm.method = "post";
    	frm.submit();    	
   		 
   	} else {
   		return;
   	}	

  }
    
</script>  
 
<div class="super_container"> 
   <div class="cart_container" style="padding-top: 20px;">
      <div class="container" >
         <div class="row" >
            <div class="col" >
                    
                <div class="row" >
                 <div class="col">  
					<div style="padding-left: 0;">
					    <h1 class="cart_title">글 내용 보기</h1>
					     <br/>
                    </div>
                  </div>
                   
             <%--       <div  style="margin-bottom:15px;">
	                   <div>		                   					   
					     원글에서 답변글이 없는 글에  대해서만 admin에게 답변글쓰기 버튼을 나타낸다.
					    <c:if test="${sessionScope.loginuser.userid.equals('admin') && qnavo.qna_depthno == 0}">
					          <button id="goWrite" type="button" class="btn btn-warning btn-sm" onClick="replyQna();">답변글쓰기</button>
					     </c:if> 
	                   </div>
                 </div> --%>
                
                        
					   <%-- 회원인 경우 수정/삭제 보여주기 --%>
					   <table id="table" class="table table-striped">	
		
					        <tr>
					        
					           <th style="font-weight: bold; white-space: pre;  width: 100px;">글번호</th>
					            <td><span style="color: maroon;  width: 100px;">${qnavo.qna_idx}</span></td>
					        </tr>     
					        <tr>
					            <th style="font-weight: bold; white-space: pre;  width: 100px;">성명</th>
					            <td><span style="color: maroon;  width: 100px;">${qnavo.fk_userid}</span></td>
					        </tr>          
					        <tr>
					            <th style="font-weight: bold; white-space: pre;">제목</th>
					            <td><span style="color: maroon; font-weight: bold; width: 100px;">${qnavo.qna_title}</span></td>
					        </tr>       
					        <tr>
					            <th style="font-weight: bold; white-space: pre; ">내용</th>
					            <td ><span style="color: maroon; font-weight: bold; width: 100px;">${qnavo.qna_content}</span></td>
					        </tr>             
					        <tr>
					            <th style="font-weight: bold; white-space: pre; ">날짜</th>
					            <td><span style="color: maroon;  width: 100px;">${qnavo.qna_date}</span></td>
					        </tr>
					        <%-- ==== #147.첨부파일 이름 및 파일크기를 보여주고 첨부파일 다운받게 만들기 --%>
					        <c:if test="${not empty qnavo.qna_orgfilename}">
					        <tr>
					            <th  style="font-weight: bold; white-space: pre; ">첨부파일</th>
					            <td>
					                <c:if test="${sessionScope.loginuser.userid != null}">
					                  <a href="<%= request.getContextPath() %>/download.action?qna_idx=${qnavo.qna_idx}">${qnavo.qna_orgfilename}</a>
					                </c:if>
					                <c:if test="${sessionScope.loginuser.userid == null}">
					                   ${qnavo.qna_orgfilename}
					                </c:if>
					            </td>
					        </tr>
					         <tr>
					            <th style="font-weight: bold; white-space: pre;">파일크기(bytes)</th>
					            <td>
					               ${qnavo.qna_byte}
					            </td>
					        </tr>
					        </c:if>
					        
					   </table>
	                    <br/>
					   	<%-- admin인 경우 답글에 대해서만 수정/삭제 보여주기   <!-- 이미 답글을 등록했기 때문에 삭제가 불가하다. -->--%>
				        <%--  <button type="button" class="btn btn-primary btn-sm" onClick="javascript:location.href='<%= request.getContextPath() %>/qna.action'">목록보기</button> --%>
					        <button type="button" class="btn btn-primary btn-sm" onClick="javascript:history.back();">목록보기</button>
					   <c:if test="${!sessionScope.loginuser.userid.equals('admin') && qnavo.qna_depthno == 0}">
						   <button type="button" class="btn btn-info btn-sm" onClick="javascript:location.href='<%= request.getContextPath() %>/editQna.action?qna_idx=${qnavo.qna_idx}'">수정</button>   
						   <button type="button" class="btn btn-danger btn-sm" onClick="deleteQna('${qnavo.qna_idx}')">삭제</button>
					   </c:if>
	   
				
					   <c:if test="${sessionScope.loginuser.userid.equals('admin')&& !qnavo.qna_fk_idx.equals('0')}"> <!--  qna_fk_idx가 0이면 원글이다. -->
						   <button type="button" class="btn btn-info btn-sm" onClick="javascript:location.href='<%= request.getContextPath() %>/editQna.action?qna_idx=${qnavo.qna_idx}'">수정</button>  		    				    	      
					   </c:if>
					    <c:if test="${sessionScope.loginuser.userid.equals('admin')&& !qnavo.qna_fk_idx.equals('0') && qnavo.qna_depthno == 0}"> 
					   <button type="button" class="btn btn-danger btn-sm" onClick="deleteQna('${qnavo.qna_idx}')">삭제</button>	
					   </c:if>
					   
					   <c:if test="${sessionScope.loginuser.userid.equals('admin') && qnavo.qna_depthno == 0}">
					       <button id="goWrite" type="button" class="btn btn-warning btn-sm" onClick="replyQna();">답변글쓰기</button>
					    </c:if> 
	    
		
					                                                                                                      <!--  부모글의 값을 받기 때문에 qnavo를 불러서 넣는다. 그리고 fk_seq는 참조키가 아닌 seq랑 같은 것이기 때문에 seq를 넣음. -->
					   <br/> 
					   <br/>	   
                  
             </div>
          </div>
       </div>
     </div>
   </div>       
</div>

<


<%-- 삭제 form --%>
<form name="delFrm">
  <input type="hidden" name="qna_idx" />
</form>

<%-- 답글 form --%>
<form name="replyFrm">
  <!-- 답글일 경우 부모글의 qna_idx를 받는다. -->
  <input type="hidden" name="replyChk" value="답글" />
  <input type="hidden" id="qna_fk_idx" name="qna_fk_idx" value="${qnavo.qna_idx}" />
  <input type="hidden" name="qna_groupno" value="${qnavo.qna_groupno}" />
  <input type="hidden" name="qna_depthno" value="${qnavo.qna_depthno}" />
 
</form>


<!-- 

<script src="resources/jihye/bootstrap4/popper.js"></script> 
<script src="resources/jihye/bootstrap4/bootstrap.min.js"></script>
<script src="resources/jihye/plugins/easing/easing.js"></script>
<script src="resources/jihye/plugins/parallax-js-master/parallax.min.js"></script>
<script src="resources/jihye/checkout_custom.js"></script> -->


