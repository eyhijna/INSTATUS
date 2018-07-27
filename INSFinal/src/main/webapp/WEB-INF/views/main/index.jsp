<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

    
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/js/jquery-2.0.0.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
    //   console.log("홈페이지 로딩되었습니다.");
    	   
    	$("#new_team_name").keydown(function(key) {
            if (key.keyCode == 13) {
               $("#submitBtn").click();
            }
        });
    
		$("#btnLogin").click(function(){
	           goLogin(event); 
	    }); // end of $("#btnLogin").click
	       
	    $("#pwd").keydown(function(event){
	         if(event.keyCode == 13){ //keyCode == 13이 엔터
	            goLogin(event);   
	         }    
	    }); // end of $("#pwd").keydown 
	      
	    $(".background-grid-trigger").click(function(event){
	   // 	console.log($(this).val());
	    	var image_name = $(this).val();
	   // 	$("#project-modal").css("background-image","url(./resources/images/" + image_name + ")");
	    	$("#testcontent").css("background-image","url(./resources/images/" + image_name + ")");	
	  //  	alert("확인: " + $(this).next().val());/* project_image_name */
			$("#image_idx").val($(this).next().val());
	    }); // end of $(".background-grid-trigger").click
	    
	    
	     $("#team").bind("change", function(){ // select team값이 바뀔 때 실행
	    	 
	    	if($("#team").val() == ""){ //팀을 선택하세요로 변경한 경우 
	    		$("#pjst").empty();
	    		var html = "<option value=''>::: 선택하세요 :::</option>";
	    		$("#pjst").html(html);
	    		$(".div_pjst_private").remove();
	    		return;
	    	} 
	     
	    	$("#team").css("border-color", "#2eb82e");
	    	$("#pjst").css("border-color", "#2eb82e");
	    	$("#error_teamlist").text("");
	    	
	    	$(".div_pjst_private").remove();
	    	
	    	var form_data = {teamIDX : $("#team").val()};
	    	$.ajax({
	    		url: "getTeamVS.action",
	    		type: "get",
	    		data: form_data,
	    		dataType: "JSON",
	    		success: function(data){ //str_jsonObj
	    			
	    			$("#pjst").empty();
	    			var html = "";
	    			
	    			if(data.visibility_status == 0){ //private
	    				if(data.admin_status == 1 || data.admin_status == 2){
	    					html  = "<option value='0'>Team Visible</option>"
		    				      + "<option value='1'>Private</option>";
	    				}
	    				else{ //팀내 권한이 일반인 경우
	    					html  = "<option value='3'>프로젝트 생성권한이 없습니다.</option>";
	    				}
	    			}
	    			else if(data.visibility_status == 1){ //public
	    				if(data.admin_status == 1 || data.admin_status == 2){
	    					html  = "<option value='0'>Team Visible</option>"
	    				      	  + "<option value='1'>Private</option>"
	    				      	  + "<option value='2'>Public</option>";
	    				}	    	
	    				else{
	    					html  = "<option value='3'>프로젝트 생성권한이 없습니다.</option>";
	    				}
	    			}
	    			$("#pjst").append(html);
	    			
	    			
	    			$("#pjst").bind("change", function(){ //프로젝트 생성에서 노출도 값이 변할 때 
	    				$(".div_pjst_private").remove();
	    			
	    		    	 if( $("#pjst").val() == "1"){ //프로젝트 노출도가 private인 경우 멤버 select창 추가
	    		    		var html = "<div class='form-group div_style div_pjst_private'>"
	    		    				 + "	<label for='inner_div' style='margin-top: 10px;'>Select Team mate</label><br/>"
	    							 + "<div class='inner_div' id='inner_div'>";	
	    		    		var form_data2 = {"teamIDX" : $("#team").val(), "userid" : "${sessionScope.loginuser.userid}" };
	    					$.ajax({
	    						url: "getTeamMemberInfo.action",
	    						type: "POST",
	    						data: form_data2,
	    						dataType: "JSON",
	    						success: function(data){
	    							$(".div_pjst_private").remove();
	    							if(data.length > 0){
	    								$.each(data, function(entryIndex, entry){
	    									/* var checkMember = "<input class='input_style' type='checkbox' name='memberID' value='" +  entry.team_userid + "'>&nbsp;" + entry.team_userid
	    													+ "<br/>"; */
											var checkMember = "<span class='checkbox_style'>"
															+ "<input class='input_style' type='checkbox' name='memberID' value='" +  entry.team_userid + "'>&nbsp;" + entry.team_userid
															+ "</span>"
															+ "<br/>";	    													
	    									html += checkMember;
	    								}); // end of $.each
	    								html += "</div>"
	    								html += "<input type='hidden' name='checkedID' />";
	    								html += "</div>";
	    		    					$("#div_pjst").after(html);
	    							}
	    						},
	    						error: function(request, status, error){ 
	    							alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
	    						}
	    					}); //end of 내부 $.ajax
	    		 	    }
	    		    	 else{ //프로젝트 노출도가 public 또는 
	    		     	 	$(".div_pjst_private").remove();
		    		    	var html = "<div class='form-group div_style div_pjst_private'>"
	    		    				 + "	<label for='pjst' style='margin-top: 10px;'>Select Team mate</label><br/>";
	    		    		
	    		    		var form_data2 = {"teamIDX" : $("#team").val(), "userid" : "${sessionScope.loginuser.userid}" };
	    					$.ajax({
	    						url: "getTeamMemberInfo.action",
	    						type: "POST",
	    						data: form_data2,
	    						dataType: "JSON",
	    						success: function(data){
	    							$(".div_pjst_private").remove();
	    							if(data.length > 0){
	    								$.each(data, function(entryIndex, entry){
	    									var checkMember = "<input type='checkbox' name='memberID' value='" +  entry.team_userid + "'>&nbsp;" + entry.team_userid
	    													+ "<br/>";
	    									html += checkMember;
	    								}); // end of $.each
	    								html += "<input type='hidden' name='checkedID' />"
	    								html += "</div>";
	    		    					$("#div_pjst").after(html);
	    		    					$(".div_pjst_private").hide();
	    							}
	    						},
	    						error: function(request, status, error){ 
	    							alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
	    						}
	    					}); //end of 내부 $.ajax
	    		    	 }
	    		    }); 
	    		},
	    		error: function(request, status, error){ 
					alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
				}
	    	}); // end of $.ajax
	    }); // end of  $("#team").bind
	    
	    
  	    
	    $("#btn-create").click(function(){ //프로젝트 생성버튼을 눌렀을 때
	    	
	    	if($("#pjst").val() != "" && $("#pjst").val() != 3 && $("#team").val() != "" && $("#project_name").val() != ""){
	    		
	    		var frm = document.PJcreateFrm;
	    		
	    		if($("#pjst").val() == "1"){
		    		var str_checkedID = "";
		    		
		    		$("input[name=memberID]:checked").each(function() { //input태그중 name이 membeID인 체크박스중 체크된 것들의 값을 가져옴
			    		var checked = $(this).val();
			    		str_checkedID += checked + ",";
			    	});
		    		frm.checkedID.value = str_checkedID;
	    		}
	    		else if($("#pjst").val() == "0"){
					var str_checkedID = "";
		    		
		    		$("input[name=memberID]").each(function() { //input태그중 name이 membeID인 체크박스중 체크된 것들의 값을 가져옴
			    		var checked = $(this).val();
			    		str_checkedID += checked + ",";
			    	});
		    		frm.checkedID.value = str_checkedID;
	    		}
	    		
	    		if($("#image_idx").val() == ""){
	    			frm.image_idx.value = "1";
	    		}
	    	//	alert(frm.image_idx.value);
	    		frm.action = "insertProject.action";
		    	frm.method = "POST";
		    	frm.submit();
	    	} 
	    	else if($("#project_name").val() == ""){
	    		$("#error_project_name").text("프로젝트명을 입력해주세요.");
	    		$("#project_name").focus();
	    		$("#project_name").css("border-color", "#FF0000");
	    	}
	    	else if($("#team").val() == ""){
	    		$("#error_teamlist").text("팀을 선택해주세요.");
	    		$("#team").css("border-color", "#FF0000");
	    	}
	    	else if($("#pjst").val() == ""){
	    		alert("프로젝트 노출도를 선택해주세요!");
	    		$("#pjst").css("border-color", "#FF0000");
	    	}
	    	else if($("#pjst").val() == "3"){
	    		$("#pjst").css("border-color", "#FF0000");
	    	}
	    	
	    }); // end of $("#btn-create").click
	    
	    $("#project_name").keyup(function(){
	    	if($("#project_name").val() != ""){
	    		$("#error_project_name").text("");
	    		$("#project_name").css("border-color", "#2eb82e");
	    	}
	    }); // end of $("#project_name").keyup
	    

	//    $("#btn-changePwd1").hide();
	    //아이디찾기의 경우
	    $("#findUserID").keyup(function(){
	    	var Classification = "findID";
	    	var form_data = {"emailCheck" : $("#findUserID").val(), "Classification" : Classification};
	    	
	    	$.ajax({
	    		url: "emailcheck.action",
	    		type: "get",
	    		data: form_data,
	    		dataType: "JSON",
	    		success: function(data){
	    			if(data.n == 0){ // 중복된 이메일이 없는 경우
	    				$("#span-resultID").empty();
    					$("#span-resultID").css("color", "#FF0000");
    					$("#span-resultID").text("가입되지 않은 email입니다.");
    					$("#findUserID").css("border-color", "#FF0000");
    				//	$("#btn-changePwd1").hide();
    				}
    				else if(data.n != 0){ //중복된 이메일이 있는 경우
    					$("#span-resultID").empty();
    					$("#span-resultID").css("color", "#000000");
    					
    					var html = "<span style='font-size: 11pt; color: #000000'>" + data.resultid + "</span>";
    					$("#span-resultID").html("회원님의 아이디는 < " + html + " > 입니다.");
    					$("#span-resultID").css("color", "#2eb82e");
    					$("#findUserID").css("border-color", "#2eb82e");
    				//	$("#btn-changePwd1").show();
    				}
	    		},
	    		error: function(request, status, error){ 
			         alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
			    }
	    	}); // end of $.ajax
	    }); // end of $("#findUserID").keyup
	    
	    
	    //비밀번호찾기 모달에 새 비밀번호 입력하는 div 추가
	    $("#btn-changePwd2").click(function(){
	    //	alert("버튼을 클릭했습니다.");
	    //	$("#id-modal1").hide();
	    	var idtest = $("#checkUserid").val();
	    	$("#btn-changePwd2").hide();
	    	var hiddenUserid = "<div class='form-group'>"
							 + "<input type='hidden' class='form-control' id='hiddenuserid'>"
							 + "</div>";
	    	
	    	var changePwd_div = "<div class='form-group'>"
	    					  + "<label for='newpw_findpw'>new password :</label>"
	    					  + "<input type='password' class='form-control' id='newpw_findpw'>"
	    					  + "<span id='error_newpw_findpw' class='text-danger'></span>"
	    					  + "</div>";
	    					  
    		var changePwd_div2 = "<div class='form-group'>"
	    					   + "<label for='checkpw_findpw'>check password :</label>"
	    					   + "<input type='password' class='form-control' id='checkpw_findpw'>"
	    					   + "<span id='error_checkpw_findpw' class='text-danger'></span>"
	    					   + "</div>";				  
	    					  
	    	$("#findPW_modal").empty();
	    //	alert(idtest);
	    	$("#findPW_modal").append(hiddenUserid);     
	    	$("#hiddenuserid").val(idtest);
			$("#findPW_modal").append(changePwd_div);
			$("#findPW_modal").append(changePwd_div2);
			
		
    	  	var addbtn_updatePW = "<button type='button' class='btn btn-default' id='btn_updatePW'>password Change!</button>";
    	  	$("#findpw_footer").prepend(addbtn_updatePW);
    	  	
    	  	$("#newpw_findpw").keyup(function(){
    	  		pwdCheck();
    	  		pwdchkCheck();
    	  	});
    	  	
    	  	$("#checkpw_findpw").keyup(function(){
    	  		pwdchkCheck();
    	  	});
    	  	
    	  	 $("#btn_updatePW").click(function(){ //변경된 비밀번호 입력 후 버튼을 누른 경우
    	  		if(pwdcheckVal != 0 && $("#checkpw_findpw").val().trim() != "" && $("#newpw_findpw").val().trim() != "" && ($("#checkpw_findpw").val()== $("#newpw_findpw").val())){ 
    	  			
    	  			var form_data = {"userid" : $("#hiddenuserid").val() , "password" : $("#newpw_findpw").val()};
    	  			$.ajax({
    	  				url: "changePassword.action",
    	  				type: "POST",
    					data: form_data,
    					dataType: "JSON",
    					success: function(data){
   							var msg = "<div class='form-group'>"
   		    					    + "<span style='color: black; font-size: 13pt; font-weight: bold;'>" + data.msg + "</span>"
   		    					    + "</div>";
   		    					    
   							$("#findPW_modal").empty();
   							$("#findPW_modal").append(msg);
   							
   							var modal_footer = "<button type='button' class='btn btn-default' data-dismiss='modal'>close</button>";
   							$("#findpw_footer").empty();
   							$("#findpw_footer").html(modal_footer);
    					},
    					error: function(request, status, error){ 
    				         alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
    				    }
    	  			});
    	  		}
    	  		else{
    	  			alert("비밀번호와 비밀번호확인이 일치하지 않습니다.");
    	  			$("#newpw_findpw").focus();
    	  		}
    	  		
    	  	}); 
	    });
//////////////////////////////////////////////////////////////////////////////////////
	    var pwdcheckVal = 0;
		function pwdCheck(){ //패스워드 형식체크 함수
			var passwd = $("#newpw_findpw").val().trim(); // 패스워드 값을 넣는다.
			var regexp_passwd = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g);// 패스워드를 검사해주는 정규표현식 객체 생성
			var bool = regexp_passwd.test(passwd); 
			
			if(!bool){ //패스워드가 정규표현식에 맞지 않는 경우
				$("#newpw_findpw").css("border-color", "#FF0000");
				$("#error_newpw_findpw").text("* 비밀번호는 영문 대,소문자와 특수문자를 포함한 8~15자 입니다.");
				pwdcheckVal = 0;
				$("#checkpw_findpw").attr('readonly', true);
			}
	    	else{ //공백이 아니고 정규표현식에도 맞는 경우
		   		$("#newpw_findpw").css("border-color", "#2eb82e");
		   		$("#error_newpw_findpw").text("");
		   		pwdcheckVal = 1;
		   		$("#checkpw_findpw").attr('readonly', false);
	    	}
		} // end of pwdCheck()
		
		
		function pwdchkCheck(){ //패스워드체크 확인 함수
			if($("#checkpw_findpw").val()!= $("#newpw_findpw").val()){
	    		$("#checkpw_findpw").css("border-color", "#FF0000");
	    		$("#error_checkpw_findpw").text("* 비밀번호와 다르게 입력하셨습니다.");
	    	}
	    	else{
	    		$("#checkpw_findpw").css("border-color", "#2eb82e");
	    		$("#error_checkpw_findpw").text("");
	    	}
		} // end of pwdchkCheck()
//////////////////////////////////////////////////////////////////////////////////////		
	    
	    //비밀번호찾기의 경우
	    $("#div-checkCode").hide();
	    $("#btn-changePwd2").hide();
	    var check = 0;
	    
	 	$("#checkUserid").keyup(function(){
	 		var form_data = {"useridCheck" : $("#checkUserid").val()};
			$.ajax({
				url: "idcheck.action",
				type: "get",
				data: form_data,
				dataType: "JSON",
				success: function(data){
					
					if(data.n == 1){
						$("#checkUserid").css("border-color", "#2eb82e");
						$("#error_checkUserid").css("color", "#2eb82e");
						$("#error_checkUserid").text("존재하는 회원입니다. 인증코드를 받을 이메일을 입력하세요.");
						check = 0;
					}
					else if(data.n == 0){
						$("#checkUserid").css("border-color", "#FF0000");
						$("#error_checkUserid").css("color", "#FF0000");
						$("#error_checkUserid").text("존재하지 않는 아이디입니다.");
						check = 1;
					}
				},
			    error: function(request, status, error){ 
			         alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
			    }
			}); // end of $.ajax
		}); // end of $("#checkUserid").keyup
		
		
		var checkemail = 0;
		//인증코드 이메일주소 형식검사
		$("#checkUserEmail").keyup(function(){
			var email = $("#checkUserEmail").val().trim();
			var userid = $("#checkUserid").val();
			var form_data = {"email" : email, "userid" : userid};
			
			$.ajax({
				url: "emailCheck.action",
				type: "POST",
				data: form_data,
				dataType: "JSON",
				success: function(data){
					if(data.n == 1){
						$("#checkUserEmail").css("border-color", "#2eb82e");
			    		$("#error_checkUserEmail").css("color", "#2eb82e");
			    		$("#error_checkUserEmail").text(data.msg);
			    		checkemail = 0;
			    		
					}
					else{
						$("#checkUserEmail").css("border-color", "#FF0000");
						$("#error_checkUserEmail").css("color", "#FF0000");
						$("#error_checkUserEmail").text(data.msg);	 
						checkemail = 1;
					}
				},
				error: function(request, status, error){ 
			         alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
			    }
			}); // end of $.ajax
	    	
		}); // end of $("#checkUserEmail").keyup
		
		//인증코드발송 버튼을 누르는 경우
		$("#sendCode").click(function(){
			var email = $("#checkUserEmail").val().trim();
			
			if(email == "" || checkemail == 1){
				$("#checkUserEmail").css("border-color", "#FF0000");
				$("#error_checkUserEmail").css("color", "#FF0000");
				$("#error_checkUserEmail").text("올바른 eamil을 입력해주세요.");	
			}
			if($("#checkUserid").val().trim() == ""){
				$("#checkUserid").css("border-color", "#FF0000");
				$("#error_checkUserid").css("color", "#FF0000");
				$("#error_checkUserid").text("아이디를 확인해주세요.");
			}
			if(check == 1){
				$("#checkUserid").css("border-color", "#FF0000");
				$("#error_checkUserid").css("color", "#FF0000");
				$("#error_checkUserid").text("아이디를 확인해주세요.");
			}
			
			if(email != "" && $("#checkUserid").val().trim() != "" && check == 0 && checkemail == 0){ //인증코드 메일이 발송된 경우
				$("#sendCode").prop("disabled", true); //인증코드발송 버튼 비활성화
				$("#sendCode").attr("disabled", "disabled");
				
				$("#checkUserEmail").attr('readonly', true); //이메일, 아이디 input창 비활성화
				$("#checkUserid").attr('readonly', true);
				
				$("#div-checkCode").show(); //코드 input창 show
				$("#checkCode").focus();
				
				$.ajax({ //인증코드가 일치하는지 확인하는 ajax 작동
					url: "findPassword.action",
					type: "POST",
					data: {"email":email},
					dataType: "JSON",
					success: function(data){
						alert("인증코드를 발송했습니다.");
					
						$("#checkCode").keyup(function(){
							if($("#checkCode").val() == data.certificationCode){
								$("#checkCode").css("border-color", "#2eb82e");
								$("#error_checkCode").css("color", "#2eb82e");
								$("#error_checkCode").text("인증코드가 일치합니다.");
								$("#btn-changePwd2").show(); //인증코드가 일치할 때 비밀번호 변경 버튼 노출
							}
							else{
								$("#checkCode").css("border-color", "#FF0000");
								$("#error_checkCode").css("color", "#FF0000");
								$("#error_checkCode").text("인증코드를 잘못입력했습니다.");
								$("#btn-changePwd2").hide();
							}
						});
					},
					error: function(request, status, error){ 
				         alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
				    }
				}); // end of $.ajax 
			}
		}); // end of $("#sendCode").click
		
		$("#btn-changePwd2").click(function(){
		/* 	$("#findPwd-modal").hide();
			$("#findID-modal").hide(); */
		});
		
   }); // end of $(document).ready()---------------------------    

   function createTeam(){ // 팀생성 유효성검사
	   	
	   	var frm = document.teamFrm;
	       var team_name = $("#new_team_name").val(); 
	       
	 	    var regexp_team_name = new RegExp(/^[A-Za-z0-9]{1,20}$/g); 
	 	    
	 	    var bool = regexp_team_name.test(team_name);
	       
	   	if(bool== false || team_name.trim() == ""){
	   		alert("Team name must includes A-Z or 0-9 and be 1 to 20 letters");
	   		$("#team_name").val(""); 
	   		return;
	   	} 
	   	frm.method="POST";
	   	frm.action="<%= request.getContextPath()%>/createTeam.action";
	   	frm.submit();
	   }
   
    function goLogin(event){  
      if(${sessionScope.loginuser != null}){ //이미 로그인 된 상태라면
          alert("이미 로그인 된 상태입니다.");
          $("#userid").val("");
          $("#pwd").val("");
          $("#userid").focus();
          event.preventDefault(); //event 발생을 막는다.
          return;
       }
      
       var userid = $("#userid").val();
       var pwd = $("#pwd").val(); 
       
       if(userid.trim() == ""){
         alert("아이디를 올바르게 입력해주세요!");
          $("#userid").val("");
          $("#userid").focus();
          event.preventDefault(); 
          return;
       }
       
       if(pwd.trim() == ""){
          alert("암호를 올바르게 입력해주세요!");
          $("#pwd").val("");
          $("#pwd").focus();
          event.preventDefault(); 
          return;
       }
       
       //로그인하지 않은 상태이고, 아이디와 암호를 올바르게 입력한 경우
       var frm = document.loginFrm;
       frm.action = "loginEnd.action"; 
       frm.method = "POST";
       frm.submit();
   } // end of goLogin
   

     function openNav() {
          document.getElementById("mySidenav").style.width = "300px";
      }
    
      function closeNav() {
          document.getElementById("mySidenav").style.width = "0";
      }
      
</script>

<style type="text/css">

.div_style{
	max-height: 328px;
	/* border: 1px solid blue; */
}
.inner_div {
    border: 1px solid lightgray;
    /* padding-left: 10%; */
    /* margin-left: 11px; */
    border-radius: 0.3em;
    background-color: white;
}

.checkbox_style{
	margin-left: 11px;
}

.background-grid-trigger {
    align-items: left;
    border-radius: 3px;
    box-shadow: none;
    color: rgba(0,0,0,.4);
    display: flex;
    height: 100%;
    justify-content: left;
    margin-right: 50px;
    min-height: 0;
    padding: 0;
    position: relative;
    line-height: 0;
    width: 100%;
    cursor: pointer;
}

.background-grid-item {
    height: 28px;
    width: 28px;
   /*  margin-bottom: 6px; */
}

.background-grid {
    display: flex;
    flex-wrap: wrap;
   /*  justify-content: space-between; */
    list-style: none;
    list-style-type: none;
    list-style-position: initial;
    list-style-image: initial;
 /*    margin: 0; */
    margin-top: 0px;
    margin-right: 50px;
    margin-bottom: 0px;
    margin-left: 8px;
}

body{overflow: hidden;}



</style>

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Creative - Bootstrap 3 Responsive Admin Template">
  <meta name="author" content="GeeksLabs">
  <meta name="keyword" content="Creative, Dashboard, Admin, Template, Theme, Bootstrap, Responsive, Retina, Minimal">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="shortcut icon" href="img/favicon.png">
 <!--  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script> -->
</head>  

       
<body class="login-img3-body">

<!--   <div class="container"> -->
   
      
    <form class="login-form" name="loginFrm">
      <c:if test="${sessionScope.loginuser == null}">
      <div style="padding: auto; margin: auto;" class="login-wrap">
        <p class="login-img"><i class="icon_lock_alt"></i></p>
        <div class="input-group">
          <span class="input-group-addon"><i class="icon_profile"></i></span>
          <input type="text" name="userid" id="userid" class="form-control" placeholder="Username" autofocus>
        </div>
        <div class="input-group">
          <span class="input-group-addon"><i class="icon_key_alt"></i></span>
          <input type="password" name="pwd" id="pwd" class="form-control" placeholder="Password">
        </div>
        <label class="checkbox">
                <input type="checkbox" value="remember-me"> Remember me
                <span class="pull-right"><a data-toggle="modal" href="#findID-modal">Forgot ID?</a></span><br/>
                <span class="pull-right"><a data-toggle="modal" href="#findPwd-modal">Forgot Password?</a></span>
            </label>
        <button class="btn btn-primary btn-lg btn-block" type="button" id="btnLogin">Login</button> 
        <button type="button" class="btn btn-info btn-lg btn-block" onClick="location.href='<%=request.getContextPath()%>/signup.action'">Sign up</button>
      </div>
      </c:if>
      
      <c:if test="${sessionScope.loginuser != null}">
         <div style="padding-top: 15px; padding-bottom: 10px;">
            <p>${sessionScope.loginuser.name} 님 로그인을 환영합니다!</p>
            <br/>
	
			<!-- 팀리스트, 프로젝트 리스트가 존재하지 않는 경우 -->
            <c:if test="${sessionScope.teamList == null || sessionScope.teamList.size() == 0}">
			<div class="form-group" >
			<label for="team" style="margin-top: 10px; text-align: center;">My Team List</label>
				<div class="dropdown">
					<button class="btn  dropdown-toggle" type="button" data-toggle="dropdown" style="width: 100%;">Select
				    	<span class="caret"></span>
				    </button>
				    <ul class="dropdown-menu" style="width: 100%;">
						<li><a href="#">소속된 팀이 없습니다.</a></li>
				    </ul>
				</div>
			</div>
            </c:if>
            
            <!-- 팀리스트, 프로젝트 리스트가 존재하는 경우 -->
            <c:if test="${sessionScope.teamList != null && sessionScope.teamList.size() != 0}">
            	 <div class="form-group" >
				  	<label for="team" style="margin-top: 10px; text-align: center;">My Team List</label>
			
					<!-- 팀 리스트 불러오기 -->
					<div class="dropdown">
						<button class="btn  dropdown-toggle" type="button" data-toggle="dropdown" style="width: 100%;">Select
					    <span class="caret"></span></button>
					    <ul class="dropdown-menu" style="width: 100%;">
							<c:forEach items="${sessionScope.teamList}" var="map">
								<li><a href="<%=request.getContextPath()%>/showTeam.action?team_idx=${map.team_idx}">${map.team_name}</a></li>
						    </c:forEach>
					    </ul>
					</div>
					<!-- 프로젝트 리스트 불러오기 -->
					<label for="team" style="margin-top: 10px; text-align: center;">My Project List</label>
					<div class="dropdown">
						<button class="btn  dropdown-toggle" type="button" data-toggle="dropdown" style="width: 100%;">Select
					    <span class="caret"></span></button>
					    <ul class="dropdown-menu" style="width: 100%;">
							<c:forEach items="${sessionScope.projectList}" var="map">
								<li><a href="<%=request.getContextPath()%>/project.action?project_name=${map.project_name}&projectIDX=${map.project_idx}&team_IDX=${map.team_idx}">${map.project_name}</a></li>
						    </c:forEach>
					    </ul>
					</div>
					   
				  </div>
            </c:if>
         </div>
         <button class="btn btn-info btn-lg btn-block" type="button" onClick="location.href='<%=request.getContextPath()%>/logout.action'">Logout</button>
      </c:if>
    </form>
    
    <div class="text-right">
      <div style="text-align: center; color: gray; margin-top: 10px;">
       <c:if test="${sessionScope.loginuser != null}">
         <a data-toggle="modal" href="#myModal" style="font-size: 14pt; color: white; font-weight: bold;">Create Project</a>
         <br/>
         <a data-toggle="modal" href="#myModal2" style="font-size: 14pt; color: white; font-weight: bold;">Create Team</a>
         </c:if>
      </div>
      <div class="credits">
          Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a>
      </div>
      <!--  class="closebtn"  -->
    <div id="mySidenav" class="sidenav">
        <a href="javascript:void(0)"onclick="closeNav();"><span style="color: white;">&times;</span></a>
        <a href="#">About</a>
        <a href="#">Services</a>
        <a href="#">Clients</a>
        <a href="#">Contact</a>
     </div>
     <span style="font-size:30px;cursor:pointer" onclick="openNav();">&#9776; open</span> 
    </div>


<!-- 프로젝트 생성 Modal --> 
  <div class="modal fade" id="myModal" role="dialog" >
    <div class="modal-dialog" style="width:380px;">
      <div class="modal-content" id="testcontent">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-weight: bold;">Create New Project!!</h4>
        </div>
        
        <!-- 소속된 팀이 있는 경우 -->
        <c:if test="${sessionScope.teamList != null && sessionScope.teamList.size() != 0}">
        <div class="modal-body" id="project-modal">
          <form name = PJcreateFrm>
          <div class="form-group">
            <label for="usr">Project title:</label>
            <input type="text" class="form-control" id="project_name" name="project_name" style="outline: none;">
            <span id="error_project_name" class="text-danger"></span>
          </div>
          <!-- 팀 선택 -->
          <div class="form-group" >
		  	<label for="team" style="margin-top: 10px;">select Team</label>
			<select name="team" id="team" class="form-control">
				<option value="">::: 선택하세요 :::</option>
				<c:forEach items="${sessionScope.teamList}" var="map">
					<option value="${map.team_idx}">${map.team_name}</option>
				</c:forEach>
			</select>
			<span id="error_teamlist" class="text-danger"></span>
		  </div>
		  <!-- 팀 노출도가 private인 경우 팀멤버 리스트 보여주기 -->
          <!-- 팀노출도 선택 -->
          <div class="form-group" id="div_pjst">
		  	<label for="pjst" style="margin-top: 10px;">Project Visible</label>
			<select name="pjst" id="pjst" class="form-control">
				<option value="">::: 선택하세요 :::</option>
			</select>				
		  </div> 
		  
		  <!-- 프로젝트 배경이미지 선택 -->
		  <div class="form-group" >
		  	<label for="background-grid" style="margin-top: 10px;">select Background</label>
			<ul class="background-grid" id="background-grid">
				<c:forEach items="${sessionScope.imageList}" var="map" varStatus="status">
				<li class="background-grid-item">
					<button class="background-grid-trigger" type="button" style="background-image: url('./resources/images/${map.project_image_name}');" value="${map.project_image_name}"></button>
					<input type="hidden" name="input-image_idx" id="input-image_idx${status.count}" value="${map.project_image_idx}">
				</li>
				</c:forEach>
			</ul>
		  </div> 
		  
		  <input type="hidden" name="image_idx" id="image_idx">
		  <input type="hidden" name="PJuserid" id="PJuserid" value="${sessionScope.loginuser.userid}">
          </form>
        </div>
          
    	  <div class="modal-footer" style="margin-top: 0;">
          	<button type="button" class="btn btn-default" id="btn-create">create</button>
          	<button type="button" class="btn btn-default" data-dismiss="modal">cancel</button>
          </div> 
        </c:if>
        
        <!-- 소속된 팀이 없는 경우 -->
        <c:if test="${sessionScope.teamList != null && sessionScope.teamList.size() == 0 }">
        <div class="modal-body">
        	<h4>소속된 팀이 없습니다.</h4>
        	<br/>
        	<a href="#">새로운 팀을 만들어보세요!</a> 
        </div>
          
    	  <div class="modal-footer">
          	<button type="button" class="btn btn-default" data-dismiss="modal">cancel</button>
          </div> 
        </c:if>
        
      </div>
    </div>
  </div>
  
   <!-- 팀 생성 모달 -->
   <div class="modal fade" id="myModal2" role="dialog" >
    <div class="modal-dialog">
    
      <div class="modal-content" style="display:inline-block; left:90px; top: 100px; width: 400px; " >
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="color:black; font-weight: bold;">Create a team</h4>
        </div>
        
        <div class="modal-body">
         <form name="teamFrm">
		    <div class="form-group">
		      <label for="team_name">Team name:</label>
		      <input type="text" class="form-control" id="new_team_name" placeholder="Enter team name" name="new_team_name">
		    </div>
         </form>
        </div>
       
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal" onClick="createTeam();" id="submitBtn"  style="color:black; font-weight:bold;">Submit</button>
          <button type="button" class="btn btn-default" data-dismiss="modal"  style="color:black; font-weight:bold;">Close</button>
        </div>
        
      </div> 
    </div>
  </div>
  
  <!-- 아이디찾기 modal -->
  <div class="modal fade" id="findID-modal" role="dialog" >
    <div class="modal-dialog" style="width:400px;">
      <div class="modal-content">
        
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title"><span style="font-size: 13pt; font-weight: bold;">Find Your ID!!</span></h4>
        </div>
        
        <div class="modal-body" >
          <div class="form-group id-modal1">
          	 <label for="findUserID">Email :</label>
             <input type="text" class="form-control" id="findUserID" placeholder="123@abc.com" maxlength="40">
          </div>

	      <div class="form-group id-modal1" id="div-resultID">
             <span id="span-resultID"></span>
          </div> 
       	</div>  
       	
    	  <div class="modal-footer">						  
          	<button type="button" class="btn btn-default" data-dismiss="modal">go Login</button>
          </div> 
      </div>
    </div>
  </div>
  
  
  <!-- 비밀번호찾기 modal -->
  <div class="modal fade" id="findPwd-modal" role="dialog">
    <div class="modal-dialog" style="width:400px;">
      <div class="modal-content" style="border: 0px solid yellow;">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title"><span style="font-size: 13pt; font-weight: bold;">Change your password!!</span></h4>
        </div>
        
        
        <div class="modal-body" id="findPW_modal">
          <div class="form-group">
            <label for="checkUserid">userid :</label>
            <input type="text" class="form-control" id="checkUserid" name="checkUserid" maxlength="20">
            <span id="error_checkUserid" class="text-danger"></span>
          </div>

          <div class="form-group">
          	 <label for="checkUserEmail">Email :</label>
             <input type="text" class="form-control" id="checkUserEmail" placeholder="123@abc.com" maxlength="30">
             <span id="error_checkUserEmail" class="text-danger"></span>
          </div>
          
          <div class="form-group" >
          	<button type="button" class="btn btn-default" id="sendCode">인증코드 발송</button>	
          </div>  
          
          <div class="form-group" id="div-checkCode">
          	<label for="checkCode">인증번호 입력 :</label>
            <input type="text" class="form-control" id="checkCode" maxlength="20">
			<span id="error_checkCode" class="text-danger"></span>
          </div>  
                 
        </div>
          
    	  <div class="modal-footer" id="findpw_footer">
    	  	<button type="button" class="btn btn-default" id="btn-changePwd2">password Change!</button>
          	<button type="button" class="btn btn-default" data-dismiss="modal" id="btn-reset">cancel</button>
          </div> 
          
      </div>
    </div>
  </div>
</body>

</html>