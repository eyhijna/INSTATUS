<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%
   String ctxpath = request.getContextPath();
%>


<%-- 스마트 에디터 구현 시작(no frame 사용시) --%>
 
<%-- <link href="<%=ctxpath%>/resources/smarteditor/css/smart_editor2.css" rel="stylesheet" type="text/css">

<script type="text/javascript" src="<%=ctxpath%>/resources/smarteditor/js/lib/jindo2.all.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=ctxpath%>/resources/smarteditor/js/lib/jindo_component.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=ctxpath%>/resources/smarteditor/js/SE2M_Configuration.js" charset="utf-8"></script>   <!-- 설정 파일 -->
<script type="text/javascript" src="<%=ctxpath%>/resources/smarteditor/js/SE2BasicCreator.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=ctxpath%>/resources/smarteditor/js/smarteditor2.min.js" charset="utf-8"></script> 


<!-- 사진첨부샘플  --> 
<script type="text/javascript" src="<%=ctxpath%>/resources/smarteditor/sample/js/plugin/hp_SE2M_AttachQuickPhoto.js" charset="utf-8"></script> 

 스마트 에디터 구현 끝(no frame 사용시)        
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/js/jquery-2.0.0.js"></script>

스마트 에디터 구현 시작(iframe 사용시)  
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>  
스마트 에디터 구현 끝(iframe 사용시)  
 --%>

<!-- <link href="resources/jihye/plugins/font-awesome-4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css">

<link rel="stylesheet" type="text/css" href="resources/jihye/checkout.css"> 
<link rel="stylesheet" type="text/css" href="resources/jihye/checkout_responsive.css"> 

<link rel="stylesheet" type="text/css" href="resources/jihye/cart.css"> 
<link rel="stylesheet" type="text/css" href="resources/jihye/cart_responsive.css"> -->



<style >

.grid-container {
  display: grid;
  /* grid-gap: 10px; */
 /*  background-color: #2196F3; */
  padding: 10px;
  width: 50%;
/*   border: 3px solid black; */
  margin:0 auto;
}

.grid-item {
 /*  background-color: rgba(255, 255, 255, 0.8); */
 /*  text-align: center; */
  padding: 20px;
  font-size: 20px;
/*   border: 3px solid red; */
}

.item1 {
  padding-left: 30px;
  text-align: center; 
  grid-column: 1; /* grid-column: 오른쪽에서 부터 순서 / grid-row: 열의 순서  /span: 컬럼 합친 갯수*/
  grid-row: 1 / span 2;
}
.item2 {
  grid-column: 2 / span 2;
  grid-row: 1 / span 2;
  text-align: left;
}

.avatar2 {
    vertical-align: middle;
    width: 200px;
    height: 200px; 
     border-radius: 70%;  
    border: 0px solid gold;
}

.abc {
      /*  border: 3px solid gold;  */
      padding-left:42%;
     padding-right:30%;   
}

.tab-content{
  padding-left:10%;
  padding-right:10%;
}

.topNav {
/*   color: white; */
   font-weight : bold;
  font-size: 14px;
            background: #e2e4e6;
   color: black;
}


.activity {
    border-bottom: 0px solid #e2e4e6;
    margin-left: 40px;
    min-height: 32px;
    padding: 12px 0;
    position: relative;
   
}

.hilight {
  

   background: #2e3b46;

    color: #fff;

    display: block;
    }
        
/* .modal-dialog{
  display: inline-block;
  text-align: left;
  vertical-align : middle;
} */

.topBack {

    background-color: white;
}

.filebox label {
       display: inline-block; 
       padding: .5em .75em; 
       color: #999;
       font-size: inherit; 
       line-height: normal; 
       vertical-align: middle; 
       background-color: #fdfdfd; 
       cursor: pointer; 
       border: 0px solid #ebebeb; 
       border-bottom-color: #e2e2e2; 
       border-radius: .25em; } 
        
.filebox input[type="file"] { /* 파일 필드 숨기기 */ 
       position: absolute; 
       width: 1px; 
       height: 1px; 
       padding: 0;
       margin: -1px; 
       overflow: hidden;  
       clip:rect(0,0,0,0); 
       border: 0; 
       } 
.btnFileUpload {
    background-color:rgb(255, 82, 82);  
      color: white;
}

.filebox img
{
  max-width:100%; 
  max-height:100%;
  margin:auto;
  display:block;
}
</style>

<script type="text/javascript">

$(document).ready(function(){
	

});
	

function test(){
	
	// 프로필 이미지 업데이트시 현재 페이지 유지하기 위해 url을 보냄.
	 var url = window.location.href;
	 
 	 var frm = document.profileImgFrm;
 	 frm.url.value= url;
 	 
	 frm.action= "/finalins/test.action"; 
	 frm.method="post";
	 frm.submit();	 	
}
	

</script>

<div class="topBack" >
    <div class="cart_container" style="padding-top: 0px;padding-bottom: 0px;" > 
      <div class="container" >
         <div class="row" >
            <div class="col" > 

				<div class="grid-container" style="border: 0px solid black; margin_bottom: 100px;">
				       <div class="grid-item item1"> <!--grid-item  -->				     
				       <c:if test="${sessionScope.loginuser.server_filename == null}"> 				        
				           <div id="profileImg2" class="avatar2" style="border: 0px solid black;"  data-toggle="modal" data-target="#myModal"> 				              
				               <img alt="Avatar2" class="avatar2" src="<%= request.getContextPath() %>/resources/files/20180726153350620877817488252.jpg">               
				            </div> 
				      </c:if>
				       <c:if test="${sessionScope.loginuser.server_filename != null}"> 				        
				           <div id="profileImg2" class="avatar2" style="border: 0px solid black;"  data-toggle="modal" data-target="#myModal"> 
				               <img alt="Avatar2" class="avatar2" src="<%= request.getContextPath() %>/resources/files/${sessionScope.loginuser.server_filename}">               
				            </div> 
				      </c:if>  
				      </div>
				 
					  <div class="grid-item item2" >
					    <br/>					    
					    <input type="hidden" value="${sessionScope.loginuser.userid}" />   
						   <span style="color:black; font-size: 15pt;">  이  름 :</span><span style="font-weigth: bold">   ${sessionScope.loginuser.name}</br></br>
						     <span style="color:black; font-size: 15pt;"> 이메일 :</span> <span style="font-weigth: bold">  ${sessionScope.loginuser.email} </span></br></br>
						    <span style="color:black; font-size: 15pt;">  닉네임 : </span><span style="font-weigth: bold"> ${sessionScope.loginuser.nickname} </span></br></br>         
					  </div> 
				</div>  <!-- end of grid Container --> 
				
		  </div>
       </div>
    </div>
  </div>
    		 		
 
 
 

<%-- 확인용 server_filename 주소
<input type="text" value="${sessionScope.loginuser.server_filename}"> --%>
 <!-- Modal -->
 <div class="modal fade" id="myModal" role="dialog" >
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content" style="width: 80%;margin-right: 20%;">
           <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">×</button>
                <h4 class="modal-title"><span style="color:rgb(255, 82, 82); font-weight: bold; ">Change Profile Image</span></h4>
           </div>
           <div class="modal-body filebox" >      <%-- style="background-image: url('./resources/files/${sessionScope.loginuser.server_filename}');   " --%>
               <img alt="Avatar2" src="<%= request.getContextPath() %>/resources/files/${sessionScope.loginuser.server_filename}" > 
                 </br>             
                             <span style="font-weight: bold;">프로필 사진을 변경하시겠습니까?</span>  
                 </br>
                 </br>
                <form name="profileImgFrm" id="profileImg" enctype="multipart/form-data">
                   <label for="attach" style="background-color:rgb(255, 82, 82); color: white;">업로드</label>
                   <input type="file" id="attach" name="attach">                    
                    <input type="hidden" id="url" name="url" >                                         
                 </form>   
           </div>
           <div class="modal-footer">
               <button type="button" class="btn btnFileUpload" onclick="test();">Save changes</button> 
              <button type="button" class="btn btnFileUpload" data-dismiss="modal">Close</button>   
           </div>
      </div>
      
    </div>
  </div>
  
  
    
  
		 <%-- 상단에 탭메뉴이다. 탭을 클릭하면 링크타고 페이지 이동한다. --%> 
		<div class="navtab" align="center" style="background-color: white;">        
		    <ul class="nav nav-tabs abc">
		    <%--     <c:if test="${sessionScope.loginuser.userid.equals('admin') }">  
		            <li><a class="topNav"data-toggle="tab5" href="<%= request.getContextPath() %>/managementMember.action">Management</a></li> 
		       </c:if> --%>
		       <c:if test="${!sessionScope.loginuser.userid.equals('admin') }">  
			       <li><a class="topNav" data-toggle="tab1" href="<%= request.getContextPath() %>/mypage.action">Profile</a></li>
			       <li><a class="topNav"data-toggle="tab4" href="<%= request.getContextPath() %>/editMember.action">Edit</a></li> 
			        <li><a class="topNav"data-toggle="tab4" href="<%= request.getContextPath() %>/activity.action">Activity</a></li> 
		       </c:if> 
		       
			       <li><a class="topNav"  data-toggle="tab2" href="<%= request.getContextPath() %>/qna.action">Q&A</a></li>
			     <c:if test="${sessionScope.loginuser.userid.equals('admin') }">     
			       <li><a class="topNav" data-toggle="tab3" href="<%= request.getContextPath() %>/adminChart.action">Chart</a></li> 
			     </c:if> 
			      <c:if test="${!sessionScope.loginuser.userid.equals('admin') }">     
			     <li><a class="topNav" data-toggle="tab3" href="<%= request.getContextPath() %>/mySetting.action">Setting</a></li> 
			     </c:if> 
		   </ul>   
		</div>  
 

 </div>
 











