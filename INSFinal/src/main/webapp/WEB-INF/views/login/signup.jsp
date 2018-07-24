<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String ctxname = request.getContextPath();
	
%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<style>
html { 
  background: url() no-repeat center center fixed; 
  -webkit-background-size: cover;
  -moz-background-size: cover;
  -o-background-size: cover;
  background-size: cover;
}
text, select{
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
}

body{overflow: auto;}
</style>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Ins Cosmetics Company </title>
    
    <!-- <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script> -->
    
    <script type="text/javascript" src="<%=ctxname%>/resources/js/jquery-3.3.1.min.js"></script>
    
<script type="text/javascript">

	$(document).ready(function(){
		
		if(${sessionScope.loginuser != null}){
			alert("회원가입은 로그인 상태에서 이용하실 수 없습니다!!");
			location.href = "<%=request.getContextPath()%>/index.action";
		}
	
		$("#userid").keyup(function(){
			goCheckID();
		});
		$("#pwd").keyup(function(){
			pwdCheck();
			pwdchkCheck();
		});
		$("#pwdchk").keyup(function(){
			pwdchkCheck();
		});
		$("#email").keyup(function(){
			 emailCheck();
		});
		$("#tel2").keyup(function(){
			var hp2 = $("#tel2").val();
		//	var regexp_hp2 = new RegExp(/\d{3,4}/g); //숫자 세자리 혹은 네자리만 들어오도록 허락하는 정규표현식 //new RegExp(/^\d{3,4}$/);
			var regexp_hp2 = new RegExp(/^\d{3,4}$/);
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
		//	var regexp_hp2 = new RegExp(/\d{3,4}/g); //숫자 세자리 혹은 네자리만 들어오도록 허락하는 정규표현식 //\d{3,4}
			var regexp_hp2 = new RegExp(/^\d{4}$/);
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
		$("#name").keyup(function(){
			nameCheck();
		});
		$("#nickname").keyup(function(){
			nicknameCheck();
		});
		$("#birthday").keyup(function(){
			if($("#birthday" ).val()==''){
	   			$("#birthday").css("border-color", "#FF0000");
	   			$('#btn-submit').attr('disabled',true);
	   			$("#error_birthday").text("* You have to enter your Date of Birth!");
	   		}
			else{
				$("#birthday").css("border-color", "#2eb82e");
		   		$("#error_birthday").text("");
		   		$('#btn-submit').attr('disabled',false);
			}
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
			//	alert("check확인: " + check);
				alert("공백을 모두 채워주세요.");
			}
			else if(idcheckVal != 0){
				alert("사용하실 아이디를 다시 입력해주세요.");
			}
			else if(emailcheckVal != 0){
				alert("사용하실 이메일을 다시 입력해주세요.");
			}
			else if(pwdcheckVal != 0){
				alert("비밀번호 형식에 맞게 입력해주세요.");
			}
			

			if(check == 0 && idcheckVal == 0 && emailcheckVal == 0 && pwdcheckVal == 0 && $("#pwdchk").val() == $("#pwd").val()){
				var frm = document.registerFrm;
				frm.action = "signupEnd.action";
				frm.method = "POST";
				frm.submit();
			}
		}); //$( "#btn-submit" ).click
	
	}); // end of $(document).ready

	var idcheckVal = 0;
	function goCheckID(){ //아이디 형식체크 함수
		var form_data = {"useridCheck" : $("#userid").val()};
		$.ajax({
			url: "idcheck.action",
			type: "get",
			data: form_data,
			dataType: "JSON",
			success: function(data){
				var data_text = data.msg;
				var regexp_idcheck = new RegExp(/^[a-z]+[a-z0-9]{5,19}$/g); // 아이디형식을 검사해주는 정규표현식 객체 생성
				var bool = regexp_idcheck.test(data.useridCheck); 
				
			 	if(bool){ //아이디형식에 맞는 아이디인 경우
			 		if(data.n == 0){ //아이디형식에 맞고 중복된 아이디도 없는 경우(사용가능한 아이디인 경우)
						$("#error_userid").empty();
						$("#error_userid").css("color", "#2eb82e");
						$("#userid").css("border-color", "#2eb82e");
						$("#error_userid").text(data_text); 
						idcheckVal = 0;
					}
					else if(data.n != 0){ //아이디형식에 맞지만 중복된 아이디가 있는 경우(사용불가능한 아이디인 경우)
						$("#error_userid").empty();
						$("#error_userid").css("color", "#FF0000");
						$("#userid").css("border-color", "#FF0000");
						$("#error_userid").text(data_text); 
						idcheckVal = 1;
					}
				}
				else{ //아이디형식에 맞지 않는 경우
					$("#error_userid").empty();
					$("#error_userid").css("color", "#FF0000");
					$("#userid").css("border-color", "#FF0000");
					$("#error_userid").text("*아이디는 영문자로 시작하는 6~20자 영문자 또는 숫자이어야 합니다."); 
					idcheckVal = 1;
				}
			},
		    error: function(request, status, error){ 
		         alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
		    }
		}); // end of $.ajax
	} // end of function goCheckID
	
	
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
	
	
	var emailcheckVal = 0;
	function emailCheck(){ //이메일형식, 중복을 체크하는 함수
		
    	var Classification = "Signup";
    	var form_data = {"emailCheck" : $("#email").val(), "Classification" : Classification};
    	
    	$.ajax({
    		url: "emailcheck.action",
    		type: "get",
    		data: form_data,
    		dataType: "JSON",
    		success: function(data){
    			var regexp_email = new RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i); // e메일을 검사해주는 정규표현식 객체 생성
    	    	var bool = regexp_email.test(data.emailCheck);
    			
    			if(bool){ //이메일 형식에 맞는 경우
    				if(data.n == 0){ //이메일 형식에 맞고 중복된 이메일도 없는 경우(사용가능한 이메일인 경우)
    					$("#error_email").empty();
						$("#error_email").css("color", "#2eb82e");
						$("#email").css("border-color", "#2eb82e");
						$("#error_email").text("* 사용가능한 이메일입니다.");
						emailcheckVal = 0;
    				}
    				else if(data.n != 0){ //이메일 형식에 맞지만 중복된 이메일인 경우(사용불가능한 이메일인 경우)
    					$("#error_email").empty();
						$("#error_email").css("color", "#FF0000");
						$("#email").css("border-color", "#FF0000");
						$("#error_email").text("* 이미 사용중인 email입니다."); 
						emailcheckVal = 1;
    				}
    			}
    			else{ //이메일 형식에 맞지 않는 경우
    				$("#email").css("border-color", "#FF0000");
    				$("#error_email").css("color", "#FF0000");
    				$("#error_email").text("* E-Mail을 올바르게 입력하세요.");	 
    				emailcheckVal = 1;
    			}
    		},
    		error: function(request, status, error){ 
		         alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
		    }
    	}); // end of $.ajax
	} // end of emailCheck()
	
	
	function nameCheck(){ //이름형식을 체크하는 함수
		var name = $("#name").val();
		var regexp_name = new RegExp(/^[가-힣]{2,10}|[a-zA-Z]{2,20}|[a-zA-Z]{2,10}\s[a-zA-Z]{2,10}$/);
		var bool = regexp_name.test(name);
		if(!bool){
			$("#name").css("border-color", "#FF0000");
			$("#error_name").text("* 한글은 2~10글자(공백 없음) , 영문은 2~20글자 또는 Firstname(2~10글자)(space)Lastname(2~10글자)로 입력해 주세요.");	    			 
		}
    	else{
    		$("#name").css("border-color", "#2eb82e");
    		$("#error_name").text("");
    	}
	} // end of nameCheck()
	
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
		if($("#userid").val()==''){
    		$("#userid").css("border-color", "#FF0000");
    	//	$('#btn-submit').attr('disabled',true);
    		$("#error_userid").text("* You have to enter your userid!");
    		check += 1;
    	}
		if($("#pwd").val()==''){
    		$("#pwd").css("border-color", "#FF0000");
    	//	$('#btn-submit').attr('disabled',true);
    		$("#error_pwd").text("* You have to enter your password!");
    		check += 1;
    	}
		if($("#pwdchk").val()==''){
    		$("#pwdchk").css("border-color", "#FF0000");
    	//	$('#btn-submit').attr('disabled',true);
    		$("#error_pwdchk").text("* You have to enter your password check!");
    		check += 1;
    	}
		if($("#name" ).val()==''){
   			$("#name").css("border-color", "#FF0000");
   		//	$('#btn-submit').attr('disabled',true);
   			$("#error_name").text("* You have to enter your name!");
   			check += 1;
   		}
		if($("#nickname" ).val()==''){
   			$("#nickname").css("border-color", "#FF0000");
   		//	$('#btn-submit').attr('disabled',true);
   			$("#error_nickname").text("* You have to enter your nickname!");
   			check += 1;
   		}
		if($("#birthday" ).val()==''){
   			$("#birthday").css("border-color", "#FF0000");
   		//	$('#btn-submit').attr('disabled',true);
   			$("#error_birthday").text("* You have to enter your Date of Birth!");
   			check += 1;
   		}
    	if($("#tel2" ).val()==''){
    		$("#tel2").css("border-color", "#FF0000");
		//	$('#btn-submit').attr('disabled',true);
		 	$("#error_phone").text("* You have to enter your Phone Number!");
		 	check += 1;
		} 
     	if($("#tel3" ).val()==''){
     		$("#tel3").css("border-color", "#FF0000");
		//	$('#btn-submit').attr('disabled',true);
			$("#error_phone").text("* You have to enter your Phone Number!");
			check += 1;
		} 
 		if($("#email" ).val()==''){
			$("#email").css("border-color", "#FF0000");
		//	$('#btn-submit').attr('disabled',true);
			$("#error_email").text("* You have to enter your email");
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

</script>
</head>
<!-- login-img3-body 배경이미지 클래스네임 -->
  <body class="login login-img3-body">

        <div id="register" class="animate form registration_form" style="width: 80%; padding-left: 35%; padding-right: 15%;">
          <section class="login_content">
            <form name="registerFrm" style="text-align:left; width: 65%;">
              <h1 style="text-align:center;">Create Account</h1>
              
              <div class="separator" style="text-align:right;">
                <p class="change_link">Already a member ?
                  <a href="#signin" class="to_register"> Log in </a>
                <br/>
              </div>
              
              <div class="form-group" >
			  	<label for="userid">ID *</label>
				<input id="userid" name="userid" class="form-control" type="text" data-validation="required" maxlength="20">
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
			    <input type="text" id="name" name="name" class="form-control" maxlength="20">
			    <span id="error_name" class="text-danger"></span>
			  </div>
					
			  <div class="form-group">
				<label for="nickname">Nickname *</label>
				<input type="text" id="nickname" name="nickname" class="form-control" maxlength="20">
				<span id="error_nickname" class="text-danger"></span>
			  </div>
					
			  <div class="form-group">
				<label for="email">Email *</label>
				<input type="text" id="email" name="email" class="form-control" placeholder="123@abc.com" maxlength="40">
				<span id="error_email" class="text-danger"></span>
			  </div>

			  <div class="form-group">
			    <label for="birthday">Birthday *</label>
				<input type="date" name="birthday" id="birthday" class="form-control">
				<span id="error_birthday" class="text-danger"></span>
			  </div>
					
			  <div class="form-inline" style="width: 100%;">
			    <label for="tel1">Phone *</label>
				<br/>					
				<!-- <input type="text" id="tel1" name="tel1" class="form-control col-xs-2" maxlength="4" style="width:30%; height:35px; margin-right: 18px;">
				<input type="text" id="tel2" name="tel2" class="form-control col-xs-2" maxlength="4" style="width:30%; height:35px; margin-right: 18px;">
				<input type="text" id="tel3" name="tel3" class="form-control col-xs-2" maxlength="4" style="width:30%; height:35px;"> -->
				<select name="tel1" id="tel1" class="form-control" style="width:30%; margin-right: 12px;">
                     <option value="010" selected>010</option>
                     <option value="011">011</option>
                     <option value="016">016</option>
                     <option value="017">017</option>
                     <option value="018">018</option>
                     <option value="019">019</option>
                  </select>&nbsp;
                   <input type="text" name="tel2" id="tel2" size="4" maxlength="4" style="width:30%; height:35px; margin-right: 13px;" class="form-control" />&nbsp;
                   <input type="text" name="tel3" id="tel3" size="4" maxlength="4" style="width:30%; height:35px;" class="form-control"/>
				
				<span id="error_phone" class="text-danger"></span>
			  </div>

			  <div class="form-group" >
			    <label for="job" style="margin-top: 10px;">Job *</label>
				<select name="job" id="job" class="form-control">
					<option value="nn" selected>select</option>
					<option value="제조업" >제조업</option>
					<option value="외식업">외식업</option>
					<option value="서비스업">서비스업</option>
					<option value="학생">학생</option>
					<option value="IT">IT</option>
					<option value="기타">기타</option>				
				</select>
				<span id="error_job" class="text-danger"></span>
			  </div>
			
			  <button id="btn-submit" type="button" class="btn btn-primary btn-block" >SUBMIT</button><!-- onClick="goSignup();" -->
	          <br/>

              <div style="text-align:center;">
                <h1><!-- <i class="fa fa-paw"></i>  --><span onclick="javascript:window.location.href='index.do'">Ins groupware! </SPAN> </h1>
                <p>©2018 All Rights Reserved. Ins groupware is a Bootstrap 4 template. Privacy and Terms</p>
              </div>
              
            </form>
          </section>
        </div>
  </body>
</html>
