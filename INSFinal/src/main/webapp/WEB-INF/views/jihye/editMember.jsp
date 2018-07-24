<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- <% String ctxname = request.getContextPath();  %> -->

<%-- <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> --%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="top.jsp" /> 


<style>
.form-control{
              color: black;
             }
          
</style>

<script type="text/javascript">

   $(document).ready(function(){
      
   // 구글링: select 태그에서 기존 db에 저장된 job컬럼값을 기본값으로 주고 싶을 때 다음과 같이 하면 된다.
       job_val = $('#job').attr('data-type');
       $('#job option[value=' + job_val + ']').attr('selected', 'selected');
    
      $("#pwd").keyup(function(){
         pwdCheck();
         pwdchkCheck();
      });
      $("#pwdchk").keyup(function(){
         pwdchkCheck();
      });
   
      $("#tel2").keyup(function(){
         var hp2 = $("#tel2").val();
         var regexp_hp2 = new RegExp(/^\d{3,4}$/);  //숫자 세자리 혹은 네자리만 들어오도록 허락하는 정규표현식
         var bool = regexp_hp2.test(hp2);
         if(!bool){ //전화번호가 정규표현식에 맞지 않는 경우
            $("#tel2").css("border-color", "#FF0000");
            $("#error_phone").text("* 전화번호는 세자리 또는 네자리의 숫자만 가능합니다.");
            $('#btn-submit').attr('disabled',true);
         }
          else{ //정규표현식에 맞는 경우
               $("#tel2").css("border-color", "#2eb82e");
               $("#error_phone").text("");
               $('#btn-submit').attr('disabled',false);
          }
      });
      $("#tel3").keyup(function(){
         var hp3 = $("#tel3").val();
         var regexp_hp2 = new RegExp(/^\d{4}$/); //숫자 세자리 혹은 네자리만 들어오도록 허락하는 정규표현식
         var bool = regexp_hp2.test(hp3);
         if(!bool){ //전화번호가 정규표현식에 맞지 않는 경우
            $("#tel3").css("border-color", "#FF0000");
            $("#error_phone").text("* 전화번호는 세자리 또는 네자리의 숫자만 가능합니다.");
            $('#btn-submit').attr('disabled',true);
         }
          else{ //정규표현식에 맞는 경우
               $("#tel3").css("border-color", "#2eb82e");
               $("#error_phone").text("");
               $('#btn-submit').attr('disabled',false);
          }
      });
   
      $("#nickname").keyup(function(){
         nicknameCheck();
      });
  
      $("#job").click(function(){
         if($("#job") != ''){
            $("#job").css("border-color", "#2eb82e");
               $("#error_job").text("");
         }
      });
       
       ///////////////// Submit ///////////////////////
      $( "#btn-submit" ).click(function() {
         blankCheck();
         if(check != 0){
         //   alert("check확인: " + check);
            alert("공백을 모두 채워주세요.");
         }
      
         else if(pwdcheckVal != 0){
            alert("비밀번호 형식에 맞게 입력해주세요.");
         }
         

         if(check == 0 && pwdcheckVal == 0 && $("#pwdchk").val() == $("#pwd").val()){

          var frm = document.registerFrm;
          frm.method = "post";
          frm.action = "memberEditEnd.action";
          frm.submit();    
         }
      }); //$( "#btn-submit" ).click
   
   }); // end of $(document).ready

  
   
   var pwdcheckVal = 0;
   function pwdCheck(){ //패스워드 형식체크 함수
      var passwd = $("#pwd").val().trim(); // 패스워드 값을 넣는다.
      var regexp_passwd = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g);// 패스워드를 검사해주는 정규표현식 객체 생성
      var bool = regexp_passwd.test(passwd); 
      
      if(!bool){ //패스워드가 정규표현식에 맞지 않는 경우
         $("#pwd").css("border-color", "#FF0000");
         $("#error_pwd").text("* 비밀번호는 영문 대,소문자와 특수문자를 포함한 8~15자 입니다.");
         pwdcheckVal = 1;
         $("#pwdchk").attr('readonly', true);
      }
       else{ //공백이 아니고 정규표현식에도 맞는 경우
            $("#pwd").css("border-color", "#2eb82e");
            $("#error_pwd").text("");
            pwdcheckVal = 0;
            $("#pwdchk").attr('readonly', false);
       }
   } // end of pwdCheck()
   
   
   function pwdchkCheck(){ //패스워드체크 확인 함수
      if($("#pwdchk").val()!= $("#pwd").val()){
          $("#pwdchk").css("border-color", "#FF0000");
          $("#error_pwdchk").text("* 비밀번호와 다르게 입력하셨습니다.");
       }
       else{
          $("#pwdchk").css("border-color", "#2eb82e");
          $("#error_pwdchk").text("");
       }
   } // end of pwdchkCheck()
   
   
  
   function nicknameCheck(){ //닉네임형식을 체크하는 함수
      //한글은 2 ~ 4글자(공백 없음) , 영문은 Firstname(2 ~ 10글자) (space) Lastname(2 ~10글자)로 입력해 주세요.
      //var pattern = /^[가-힣]{2,4}|[a-zA-Z]{2,10}\s[a-zA-Z]{2,10}$/;
      var nickname = $("#nickname").val();
      var regexp_nickname = new RegExp(/^[가-힣]{2,10}|[a-zA-Z]{2,10}$/);
      var bool = regexp_nickname.test(nickname);
      if(!bool){
         $("#nickname").css("border-color", "#FF0000");
         $("#error_nickname").text("* 한글은 2~10글자, 영문은 2~10글자로 입력해 주세요.");                 
      }
       else{
          $("#nickname").css("border-color", "#2eb82e");
          $("#error_nickname").text("");
       }
   } // end of nicknameCheck()
   
   
   var check = 0;
   function blankCheck(){ //submit버튼을 눌렀을 때 공백을 검사하는 함수
      /* var baday = $("#birthday").val();
      console.log("확인: " + baday); */
      check = 0;
     
      if($("#pwd").val()==''){
          $("#pwd").css("border-color", "#FF0000");
       //   $('#btn-submit').attr('disabled',true);
          $("#error_pwd").text("* You have to enter your password!");
          check += 1;
       }
      if($("#pwdchk").val()==''){
          $("#pwdchk").css("border-color", "#FF0000");
       //   $('#btn-submit').attr('disabled',true);
          $("#error_pwdchk").text("* You have to enter your password check!");
          check += 1;
       }
    
      if($("#nickname" ).val()==''){
            $("#nickname").css("border-color", "#FF0000");
         //   $('#btn-submit').attr('disabled',true);
            $("#error_nickname").text("* You have to enter your nickname!");
            check += 1;
         }
    
       if($("#tel2" ).val()==''){
          $("#tel2").css("border-color", "#FF0000");
      //   $('#btn-submit').attr('disabled',true);
          $("#error_phone").text("* You have to enter your Phone Number!");
          check += 1;
      } 
        if($("#tel3" ).val()==''){
           $("#tel3").css("border-color", "#FF0000");
      //   $('#btn-submit').attr('disabled',true);
         $("#error_phone").text("* You have to enter your Phone Number!");
         check += 1;
      } 
    
       if($("#job").val()=='nn'){
          $("#job").css("border-color", "#FF0000");
          $("#error_job").text("* You have to select your job");
          check += 1;
       }
       if($("#job").val() != 'nn'){
          $("#job").css("border-color", "#2eb82e");
          $("#error_job").text("");
       }
   } // end of blankCheck()
   
   
// 탈퇴
   function goDel()
   {   
      if(confirm("정말 탈퇴하시겠습니까?") == true){
          var frm =document.useridFrm;
           frm.method="post";
           frm.action= "memberDeleteAccount.action";
           frm.submit();   
      } else {
         return;
      }   
      
   } 

</script>
<!-- 
 회원정보 수정 form  -->
<div align="center" style="border: 0px solid gold; width: 30%; margin-left: 35%;">

<!--      탈퇴관련 form -->
    <form name="useridFrm">
            <input type="hidden" name="userid" value="${membervo.userid}" />
            <input type="hidden" name="goBackURL" value="${goBackURL}" />            
   </form> 
   
<!--    애초에 로그인 체크여부로 아래의 c:if절이 발생하지 않지만 해놓았다. -->
    <c:if test="${empty membervo}" >   
      <span style="color: red; font-weight: bold;">회원정보가 존재하지 않습니다.</span> 
      <br/><br/>
      <button type="button" style="margin-top: 30px; background-color: navy; color: white; width: 100px; border: none;" onClick="goMemberList('${goBackURL}');">회원목록</button>  
   </c:if>   
   
    <c:if test="${not empty membervo }">  

        <div id="register" class="animate form registration_form" >
    <!--       <section class="login_content"> -->
            <form name="registerFrm" style="text-align:left; width: 65%;">
            <input type="hidden" name="userid" id="userid2" value="${membervo.userid}">
          <input type="hidden" name="goBackURL" value="${goBackURL}">
          
          
          <div>
            ::: ${membervo.userid}&nbsp;회원정보수정 (<span style="font-size: 10pt; font-style: italic;"><span class="star">*</span>표시는 필수입력사항</span>) ::: 
        </div>
              
              <div class="form-group" >
              <label for="userid">ID *</label>
            <input id="userid" name="userid" value="${membervo.userid}" class="form-control" type="text" data-validation="required" maxlength="20" readonly>
            <span id="error_userid" class="text-danger"></span>
           </div>         
           
           <div class="form-group">
            <label for="pwd">Password *</label>
            <input id="pwd" name="pwd" class="form-control" type="password" data-validation="required" maxlength="15">
            <span id="error_pwd" class="text-danger"></span>
           </div>   
           
           <div class="form-group">
            <label for="pwdchk">Password Check *</label>
            <input id="pwdchk" name="pwdchk" class="form-control" type="password" data-validation="required" maxlength="15">
            <span id="error_pwdchk" class="text-danger"></span>
           </div>   
                     
           <div class="form-group">
             <label for="name">Name *</label>
             <input type="text" id="name" name="name"  value="${membervo.name}" class="form-control" maxlength="20" readonly>
             <span id="error_name" class="text-danger"></span>
           </div>
               
           <div class="form-group">
            <label for="nickname">Nickname *</label>
            <input type="text" id="nickname" name="nickname"  value="${membervo.nickname}"class="form-control" maxlength="20">
            <span id="error_nickname" class="text-danger"></span>
           </div>
               
           <div class="form-group">
            <label for="email">Email *</label>
            <input type="text" id="email" name="email"  value="${membervo.email}" class="form-control" placeholder="123@abc.com" maxlength="40" readonly>
            <span id="error_email" class="text-danger"></span>
           </div>

           <div class="form-group">
             <label for="birthday">Birthday *</label>
            <input type="date" name="birthday" id="birthday"  value="${birthday}" class="form-control" readonly>
            <span id="error_birthday" class="text-danger"></span>
           </div>
               
           <div class="form-inline" style="width: 100%;">
             <label for="tel1">Phone *</label>
            <br/>               
            <!-- <input type="text" id="tel1" name="tel1" class="form-control col-xs-2" maxlength="4" style="width:30%; height:35px; margin-right: 18px;">
            <input type="text" id="tel2" name="tel2" class="form-control col-xs-2" maxlength="4" style="width:30%; height:35px; margin-right: 18px;">
            <input type="text" id="tel3" name="tel3" class="form-control col-xs-2" maxlength="4" style="width:30%; height:35px;"> -->
            <select name="tel1" id="tel1" class="form-control" style="width:30%; margin-right: 5px;">
                     <option value="010" selected>010</option>
                     <option value="011">011</option>
                     <option value="016">016</option>
                     <option value="017">017</option>
                     <option value="018">018</option>
                     <option value="019">019</option>
                  </select>&nbsp;
                   <input type="text" name="tel2" id="tel2"  value="${membervo.tel2}" size="4" maxlength="4" style="width:30%; height:35px; margin-right: 10px;" class="form-control" />&nbsp;
                   <input type="text" name="tel3" id="tel3"   value="${membervo.tel3}" size="4" maxlength="4" style="width:30%; height:35px;" class="form-control"/>
            
            <span id="error_phone" class="text-danger"></span>
           </div>

           <div class="form-group" >
             <label for="job" style="margin-top: 10px;">Job *</label>
            <select name="job" id="job" data-type="${membervo.job}" class="form-control"  style="width:30%; height:35px;"  required>
              <!--  <option value="nn" selected>select</option> -->
               <option value="제조업" >제조업</option>
               <option value="외식업">외식업</option>
               <option value="서비스업">서비스업</option>
               <option value="학생">학생</option>
               <option value="IT">IT</option>
               <option value="기타">기타</option>            
            </select>
            <span id="error_job" class="text-danger"></span>
           </div>
         
             <br/>

             
            </form>
         </div>
         <button id="btn-submit" type="submit" class="btn btn-primary" value="submit" style="width:90px;">정보수정</button> 
          <!-- 버튼 태그마다 type속성을 넣어줘야 한다.브라우저 마다 각기 다른 기본값을 사용하기 때문이다.  -->
         <button id="editCancel" type="button"  class="btn btn-primary" onclick="location.href='${goBackURL}'" style="width: 90px;">취소</button> 
         <button id="editCancel" type="button"  class="btn btn-danger" onclick="goDel();" style="width: 90px;">탈퇴</button>   
      
             
     </c:if>  
</div>






























<%-- <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="top.jsp" /> 

<!-- 
<link rel="stylesheet" type="text/css" href="styles/bootstrap4/bootstrap.min.css"> -->
<!-- <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script> -->

<!--  Join Form check JS -->
<!-- <script src="resources/js/custom/edit_check.js"></script>  -->
<style>
.form-control{
              color: black;
             }
</style>

<script type="text/javascript">


$(document).ready(function(){
	
	
	
	// 구글링: select 태그에서 기존 db에 저장된 job컬럼값을 기본값으로 주고 싶을 때 다음과 같이 하면 된다.
    job_val = $('#job').attr('data-type');

    $('#job option[value=' + job_val + ']').attr('selected', 'selected');

	
    
    // 회원 정보 수정 입력&버튼 눌렀을 때 유효성 검사 (패스원드,패스워드 체크, 이메일, 닉네임, 전화)
	$("#pwd").keyup(function(){  // focusout -> keyup
		var passwd = $(this).val().trim(); // 패스워드 값을 넣는다.
		
		var regexp_passwd = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g);
		// 패스워드를 검사해주는 정규표현식 객체 생성
		var bool = regexp_passwd.test(passwd); 
		
		 
		if($("#pwd").val()==''){
	          $("#pwd").css("border-color", "#ccc");
	          $("#error_pwd").text("* 비밀번호를 입력하세요.");
	       }
		/* if($(this).val()==''){
			$(this).css("border-color", "#FF0000");
    		$('#submit').attr('disabled',true); 			
    	    $("#error_pwd").text("* 비밀번호를 입력하세요.");
    	} */
		else if(!bool)
			{
			$(this).css("border-color", "#FF0000");
			$('#submit').attr('disabled',true);
			 $("#error_pwd").text("* 비밀번호는 영문 대,소문자와 특수문자를 포함한 8~15자 입니다.");
			}
    	else
    	{
    		$(this).css("border-color", "#2eb82e");
    		$('#submit').attr('disabled',false);
    		$("#error_pwd").text("");

    	}
   });
	
	$("#pwdchk").keyup(function(){
		
		$pwd =$("#pwd").val();
		if($(this).val()==''){
    		$(this).css("border-color", "#FF0000");
    			$('#submit').attr('disabled',true);
    			 $("#error_pwdchk").text("* 비밀번호를 한번 더 입력하세요.");
    	}
		
		else if($(this).val()!=$("#pwd").val()){
    		$(this).css("border-color", "#FF0000");
    			$('#submit').attr('disabled',true);
    			 $("#error_pwdchk").text("* 비밀번호와 다르게 입력하셨습니다.");
    	}
    	else
    	{
    		$(this).css("border-color", "#2eb82e");
    		$('#submit').attr('disabled',false);
    		$("#error_pwdchk").text("");

    	}
   });
    
    $("#nickname").keyup(function(){
    	
    	var nickname = $("#nickname").val().trim();
    	var regexp_nickname = new RegExp(/^[가-힣]{2,10}|[a-zA-Z]{2,10}$/);                              //new RegExp(/^[가-힣]{2,10}|[a-zA-Z]{2,10}$/);
    	var bool = regexp_nickname.test(nickname);
    	
		if($(this).val()==''){
			$(this).css("border-color", "#FF0000");
			$('#submit').attr('disabled',true);
			$("#error_nickname").text("* 닉네임을 입력하세요.");
    		
    	}
    	else  if(!bool){
			$(this).css("border-color", "#FF0000");
			$('#submit').attr('disabled',true);
			$("#error_nickname").text("* 한글은 2~10글자, 영문은 2~10글자로 입력해 주세요.");
    		
    	}
    	else{
    		$(this).css("border-color", "#2eb82e");
    		$('#submit').attr('disabled',false);
    		$("#error_nickname").text("");
    	}
   });

    
    $("#tel2").keyup(function(){
    	var tel2 = $(this).val().trim();
    //	var regexp_tel2 = /^\d{3,4}$/;                            //  /\d{3,4}/g; 
       var regexp_tel2 = new RegExp(/^\d{3,4}$/); 
		// 3~4자리 숫자 입력 정규표현식
		var bool = regexp_tel2.test(tel2);
		
   //     $pho =$("#tel").val();
		if($(this).val()==''){
    		$(this).css("border-color", "#FF0000");
    			$('#submit').attr('disabled',true);
    			$("#error_tel").text("* 모바일 번호를 입력하세요.");
    	}
    	else if (!bool)
    	{   
                $(this).css("border-color", "#FF0000");
    			$('#submit').attr('disabled',true);
    			$("#error_tel").text("* 모바일 번호를 입력하세요.");
    	}
    	
    	else{
    		$(this).css({"border-color":"#2eb82e"});
    		$('#submit').attr('disabled',false);
    		$("#error_tel").text("");
    	}

	});
    
    $("#tel3").keyup(function(){
    	var tel3 = $(this).val().trim();
    //	var regexp_tel3 = /^\d{4}$/;                                            // /\d{3,4}/g; 
		var regexp_tel3 = new RegExp(/^\d{4}$/);
        // 3~4자리 숫자 입력 정규표현식
		var bool = regexp_tel3.test(tel3);
		
  //      $pho =$("#tel").val();
		if($(this).val()==''){
    		$(this).css("border-color", "#FF0000");
    			$('#submit').attr('disabled',true);
    			$("#error_tel").text("* 모바일 번호를 입력하세요.");
    	}
    	else if (!bool)
    	{   
                $(this).css("border-color", "#FF0000");
    			$('#submit').attr('disabled',true);
    			$("#error_tel").text("* 모바일 번호를 입력하세요.");
    	}
    	
    	else{
    		$(this).css({"border-color":"#2eb82e"});
    		$('#submit').attr('disabled',false);
    		$("#error_tel").text("");
    	}

	});


    
    ///////////////// Submit ///////////////////////
		$( "#submit" ).click(function() 
		{
			
			var bool = true;
			

			if($("#pwd").val().trim()=='')
			{
				$("#pwd").css("border-color", "#FF0000");	
			$("#error_pwd").text("* 비밀번호를 입력하세요.");
			
			 bool = false;
    	}

			
			
			if($("#pwdchk").val().trim()=='')
			{
				$("#pwdchk").css("border-color", "#FF0000");			
			$("#error_pwdchk").text("* 비밀번호를 한번 더 입력하세요.");
			
			bool = false;
    	}
			if($("#pwdchk").val() != $("#pwd").val())
			{
    		$("#pwdchk").css("border-color", "#FF0000");
    		$("#error_pwdchk").text("* 비밀번호와 다르게 입력하셨습니다.");
    		
    		bool = false;
    	}
			
			
		
			if($("#email").val()=='')
			{
				$("#email").css("border-color", "#FF0000");
				$("#error_email").text("* E-Mail을 입력하세요.");
			
			bool = false;
    	}

			if($("#nickname").val()=='')
			{
				$("#nickname").css("border-color", "#FF0000");
			$("#error_nickname").text("* 닉네임을 입력하세요.");
			
			bool = false;
    	}
			

			if($("#tel2").val()=='')
			{
				$("#tel2").css("border-color", "#FF0000");
				$("#error_tel").text("* 모바일 번호를 입력하세요.");
			
			bool = false;
    	}
				   			
				
			if($("#tel3").val()=='')
			{
				$("#tel3").css("border-color", "#FF0000");
				$("#error_tel").text("* 모바일 번호를 입력하세요.");
			
			bool = false;
    	}
			
		if(bool)
		{	
			var frm = document.registerFrm;
			frm.method = "post";
			frm.action = "memberEditEnd.action";
			frm.submit();	   		
		}
			
		});//submit end;
		
		
});




// 탈퇴
function goDel()
{	
	if(confirm("정말 탈퇴하시겠습니까?") == true){
		 var frm =document.useridFrm;
		  frm.method="post";
		  frm.action= "memberDeleteAccount.action";
		  frm.submit();	
	} else {
		return;
	}	
	
} 

</script>
   


 회원정보 수정 form 
<div align="center" style="border: 0px solid gold; width: 30%; margin-left: 35%;">

     탈퇴관련 form
 	<form name="useridFrm">
				<input type="hidden" name="userid" value="${membervo.userid}" />
				<input type="hidden" name="goBackURL" value="${goBackURL}" />				
	</form> 
	
	애초에 로그인 체크여부로 아래의 c:if절이 발생하지 않지만 해놓았다.
    <c:if test="${empty membervo}" >	
		<span style="color: red; font-weight: bold;">회원정보가 존재하지 않습니다.</span> 
		<br/><br/>
		<button type="button" style="margin-top: 30px; background-color: navy; color: white; width: 100px; border: none;" onClick="goMemberList('${goBackURL}');">회원목록</button>  
	</c:if>   
	
	 <c:if test="${not empty membervo }">  
		<form name="registerFrm">
			<input type="hidden" name="userid" id="userid" value="${membervo.userid}">
		    <input type="hidden" name="goBackURL" value="${goBackURL}">
		     
		
			 <table class="table table-striped">	
				<tr>
					<th colspan="2" id="th" style="text-align:center;">::: ${membervo.userid}&nbsp;회원정보수정 (<span style="font-size: 10pt; font-style: italic;"><span class="star">*</span>표시는 필수입력사항</span>) ::: </th>
				</tr>
				<tr>
					<th colspan="2" id="th" style="text-align:right;"><button type="button" class="btn btn-danger btn-sm"   onClick="goDel('${membervo.userid}','index.do');">탈퇴</button> </th>
				</tr>
				
				<tr>
					<td style="width: 25%; font-weight: bold;">성명&nbsp;<span class="star">*</span></td>
					<td style="width: 75%; text-align: left;">
					    <input type="text" name="name" id="name" value="${membervo.name}" class="form-control" required readonly />
						<span id="error_name" style="color:red; font-size:13px;"></span>
						<input type="hidden" name="userid" id="userid" value="${(sessionScope.loginuser).userid}" /> userid 값을 넣는 방법 1. memberEdit.jsp에 hidden type으로 값을 넣어 준다. (문제점은 소스보기 했을경우 userid값이 보인다.)
						
					</td>
				</tr>
				
				
				 <tr>
					<td style="width: 25%; font-weight: bold;">닉네임&nbsp;<span class="star">*</span></td>
					<td style="width: 75%; text-align: left;">
					    <input type="text" name="nickname" id="nickname" value="${membervo.nickname}" class="form-control" required/>
						<span id="error_nickname" style="color:red; font-size:13px;"></span>
					</td>
				</tr> 
				
				<tr>
					<td style="width: 25%; font-weight: bold;">비밀번호&nbsp;<span class="star">*</span></td>
					<td style="width: 75%; text-align: left;">
					    <input type="password" name="pwd" id="pwd" class="form-control" required />
						<span id="error_pwd" style="color:red; font-size:13px;"></span>
					</td>
				</tr>
				<tr>
					<td style="width: 25%; font-weight: bold;">비밀번호확인&nbsp;<span class="star">*</span></td>
					<td style="width: 75%; text-align: left;">
					    <input type="password" name="pwdchk" id="pwdchk" class="form-control" required />
						<span id="error_pwdchk" style="color:red; font-size:13px;"></span>
					</td>
				</tr>
				<tr>
					<td style="width: 25%; font-weight: bold;">이메일&nbsp;<span class="star">*</span></td>
					<td style="width: 75%; text-align: left;">
					    <input type="text" name="email" id="email" value="${membervo.email}" class="form-control" placeholder="123@abc.com" readonly/>
					    <span id="error_email" style="color:red; font-size:13px;"></span>
					</td>
				</tr>
				<tr>
					<td style="width: 20%; font-weight: bold;">생년월일&nbsp;<span class="star">*</span></td>
					<td style="width: 80%; text-align: left;"><input type="date" name="birthday" id="birthday" value="${birthday}" class="form-control" readonly/> 
					    <span id="error_birthday" style="color:red; font-size:13px;"></span>
					</td>
				</tr>
				<tr>
					<td style="width: 20%; font-weight: bold;">연락처<span class="star">*</span></td>
					<td style="width: 80%; text-align: left;">
					<div class="form-inline">
					   <select name="tel1" id="tel1" class="form-control" style="width:30%;">
							<option value="010" selected>010</option>
							<option value="011">011</option>
							<option value="016">016</option>
							<option value="017">017</option>
							<option value="018">018</option>
							<option value="019">019</option>
						</select>&nbsp;
					    <input type="text" name="tel2" id="tel2" value="${membervo.tel2}" size="4" maxlength="4" style="width:30%; height:35px;" class="form-control" />&nbsp;
					    <input type="text" name="tel3" id="tel3" value="${membervo.tel3}" size="4" maxlength="4" style="width:30%; height:35px;" class="form-control"/>
					    </div>
					    <span id="error_tel" style="color:red; font-size:13px;"></span>
					    
					</td>
				</tr>
			    <tr>
                  <td style="width: 25%; font-weight: bold;">직업군 <span class="star">*</span></td>
                      <td>
			            <select name="job" id="job" data-type="${membervo.job}" class="form-control"  style="width:30%; height:35px;"  required>
			               <option value="제조업">제조업</option>
			               <option value="외식업">외식업</option>
			               <option value="서비스업">서비스업</option>
			               <option value="학생">학생</option>
			               <option value="IT">IT</option>
			               <option value="기타">기타</option>            
			            </select>
			        </td>  
                 </tr>
				
				<tr>
					<td style="width: 20%; font-weight: bold;">성별&nbsp;<span class="star">*</span></td>
					<td style="width: 80%; text-align: left;">
						 <select name="gender" id="gender" value ="${membervo.gender}"class="form-control">
	
							<option value="여">여</option>
							<option value="남">남</option>
						</select>
					    <span id="gender_error" style="color:red; font-size:13px;"></span>
					</td>
				</tr>
				
			</table>
		</form>
		<div>
			<button id="submit" type="submit" class="btn btn-primary" value="submit" style="width:90px;">정보수정</button> 
		    <!-- 버튼 태그마다 type속성을 넣어줘야 한다.브라우저 마다 각기 다른 기본값을 사용하기 때문이다.  -->
			<button id="editCancel" type="button"  class="btn btn-primary" onclick="location.href='${goBackURL}'" style="width: 90px;">취소</button> 
			<button id="editCancel" type="button"  class="btn btn-danger" onclick="goDel();" style="width: 90px;">탈퇴</button>	
		</div>
		    	
	  </c:if>  
</div>

  
    --%>