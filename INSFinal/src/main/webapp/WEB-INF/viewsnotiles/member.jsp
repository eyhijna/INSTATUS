<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
	
 
 .btn1 {width:250px;} 
 
 #displayData {
    position: relative;
    display: inline-block; 
    overflow: auto;
    max-height: 150px;
    width: 300px; 
    }
 #displayData2 {
    position: relative;
    display: inline-block; 
    overflow: auto;
    max-height: 150px;
    width: 225px; 
    z-index : 1;
    }     
 
 #searchWord {
    width: 100%;
    box-sizing: border-box;
    border: 2px solid #ccc;
    border-radius: 4px;
    font-size: 16px;
    background-color: white; 
    background-position: 10px 10px; 
    background-repeat: no-repeat;
    padding: 5px 20px 5px 40px;
  }
  #searchWord2 {
    width: 100%;
    box-sizing: border-box;
    border: 2px solid #ccc;
    border-radius: 4px;
    font-size: 16px;
    background-color: white; 
    background-position: 10px 10px; 
    background-repeat: no-repeat;
    padding: 5px 20px 5px 40px;
  }
  
  #searchMyTmember {
    width: 100%;
    box-sizing: border-box;
    border: 2px solid #ccc;
    border-radius: 4px;
    font-size: 16px;
    background-color: white; 
    background-position: 10px 10px; 
    background-repeat: no-repeat;
    padding: 5px 20px 5px 40px;
  }
  #secondUser{
    text-align: left;
  }
</style>
<script type="text/javascript">
   $(document).ready(function(){
	    
       var memberCnt_val = ${memberCnt};
	   
	   if(memberCnt_val > 0){ // 팀원들이 있는 경우    
		    showMember("1");
	   }
	   else{ // 팀원이 없는 경우(나자신제외)
		    $("#searchBtn").click(); 
		    document.getElementById("searchmember").disabled = true;
	   }
	   
	   $("#btnMore").bind("click", function(){
    	   
   		   if($(this).text() == "Back"){   
   			    
   		      $("#input").empty();
   		        showMember("1");
   		       $(this).text("More");
   		   }
   		   else{
   			   showMember($(this).val());// 버튼의 value값을 넣는다 
   		   }
   		   
   	    });//end of btnMore.bind(click)
	   
	   $("#searchBtn").click(function(){
		   document.getElementById("searchmember").disabled = true; 
	   }); // searchBtn 버튼을 누르면 search member버튼 비활성화 
	   
	    var result = document.getElementById("displayData");

		window.onclick = function(event) { //검색결과창 밖을 클릭했을때 꺼주는 메소드
		    if (event.target != result) {
		    	$("#displayData").hide();
		    }
		}
	     
		$("#displayData").hide();   
		
	    $("#searchWord").keyup(function(){ // 검색창에 검색어를 입력하고 키보드를 뗐을때  (팀원이 없는경우-전체회원검색)
		   if($("#searchWord").val().trim() != ""){   
			    searchBarAjax(); ///  팀원이 없을때 검색창 
		   }
		   else{
			   $("#displayData").hide();
			   document.getElementById("searchmember").disabled = true; 
		   }
	   });	 
	  
	     
	   $("#displayData").click(function(){ // 검색했을때 
		   var word = "";
		   var $target = $(event.target);
		   
		   if($target.is(".first")){ // 내가 선택한게 클래스 first인지 묻는것 
			   word = $target.text(); 
		   }
		   
		   $("#searchWord").val(word);
		   // 텍스트박스에 내가 선택한 문자열을 입력해준다.
		   
		   $("#searchUserid").val($target.next().val());
		   // 텍스트박스에 내가 선택한 문자열에서 userId 값만 입력해준다.
		   
		   $("#displayData").hide(); 
		 
	   });//end of  $("#displayData").click

	   $(document).on("click", "#searchmember", function(event){
		   var userId = $("#searchUserid").val();
		    
		   var frm = document.inviteFrm;
		   
		   frm.inviteUser.value = userId;
		   frm.team_idx.value = ${team_idx};
		   
		   frm.method="POST";
		   frm.action="<%= request.getContextPath()%>/inviteMember.action";
		   frm.submit();
	   });   
	   
	   
	   var result2 = document.getElementById("displayData2");

		window.onclick = function(event) { //검색결과창 밖을 클릭했을때 꺼주는 메소드
		    if (event.target != result2) {
		    	$("#displayData2").hide();
		    }
		}
	    
		$("#displayData2").hide();   
		
	    $("#searchWord2").keyup(function(){ // 검색창에 검색어를 입력하고 키보드를 뗐을때  (팀원이 없는경우-전체회원검색)
		   if($("#searchWord2").val().trim() != ""){   
			    searchBarAjax2(); ///  팀원이 있을때 Admin이 멤버를 검색하는 검색창 
		   }
		   else{
			   $("#displayData2").hide();
			   document.getElementById("searchmember2").disabled = true; 
		   }
	   });	 
	      
	   
	   $("#displayData2").click(function(){ // 검색했을때 
		   var word = "";
		   var $target = $(event.target);
		   
		   if($target.is(".first")){ // 내가 선택한게 클래스 first인지 묻는것 
			   word = $target.text(); 
		   }
		   
		   $("#searchWord2").val(word);
		   // 텍스트박스에 내가 선택한 문자열을 입력해준다.
		   
		   $("#searchUserid2").val($target.next().val());
		   // 텍스트박스에 내가 선택한 문자열에서 userId 값만 입력해준다.
		   
		   $("#displayData2").hide(); 
		 
	   });//end of  $("#displayData").click

	   $(document).on("click", "#searchmember2", function(event){
		   var userId = $("#searchUserid2").val();
		    
		   var frm = document.inviteFrm;
		   
		   frm.inviteUser.value = userId;
		   frm.team_idx.value = ${team_idx};
		   
		   frm.method="POST";
		   frm.action="<%= request.getContextPath()%>/inviteMember.action";
		   frm.submit();
	   });
	   
	   $("#searchMyTmember").keyup(function(){ // 검색창에 검색어를 입력하고 키보드를 뗐을때  (팀원이 있는경우-팀내 검색)
		    if($("#searchMyTmember").val().trim() != ""){   
				 searchMyTmemberAjax(); 
		    } 
		    else if($("#searchMyTmember").val().trim() == ""){
		    	 $("#input").empty();  
		    	 showMember("1");
		    }
	   });	 
	   
	   $(document).on("click", ".btnAdmin", function(event){ // 권한 변경 버튼을 눌렀을때 
		   
		   var dataVal = $(this).next().val();
		// console.log("dataVal : "+dataVal);
		   
		   $("#toAdmin").val(dataVal);
	       $("#to2ndAdmin").val(dataVal);
		   $("#toNormal").val(dataVal); 
	   }); 
	   
	   $("#giveAdmin").click(function(){ // 부운영자가 여러명일때 한명을 선택하고 submit버튼을 누를때 호출되는 함수 
		   
		   var frm = document.secondAdminFrm;
		   frm.action = "<%= request.getContextPath()%>/giveAdmin.action";
		   frm.method = "POST";
		   frm.submit();
		   
	   });		   
			   
	   $("#toAdmin").click(function(){ 
		    toAdmin($(this).val());
	   });
	   
	   $("#to2ndAdmin").click(function(){  
		   
		   var useridval = $("#to2ndAdmin").val().trim();
		   var adminuserid = $("#teamAdmin").val().trim(); 
		   
		   if(adminuserid == useridval){ //내 권한을 바꿨을때  
			     
			    
			   var countsecondAD = ${secondAdminCnt};  
				 
				  if(countsecondAD >= 2){ // 부운영자가 2명이상 있다면 선택할 수 있게끔 모달창을 띄운다.
					 
					  var team_idxval = ${teamvo.team_idx}
					  
					  var form_data = { "team_idx" : team_idxval }
					  
					  if(${sessionScope.loginuser.userid  == "" || sessionScope.loginuser.userid  == null }){
						  alert("you must login. go to login page..");
						  location.href="<%= request.getContextPath()%>/index.action";   
					  }
					  else{
							    $.ajax({ 
						 
							  
							    url: "SecondAdminListJSON.action",
								type:"GET",
								data: form_data,
								dataType:"JSON",
								success: function(json){
								  
								   var html = "";
								   if(json.length > 0){
									   
									  $.each(json, function(entryindex, entry){ 
										  html += "<input type='radio'  name='chguser' id='chguser' value='"+entry.team_userid+"' />&nbsp;&nbsp;<span style='color:black; font-weight:black;'>"+entry.team_userid+"</span><br/>";
										  html += "<input type='hidden' name='team_idx' value='"+entry.fk_team_idx+"'/>";
										  html += "<input type='hidden' name='status' value='1'/>"; 
									  });
				                      
									
									  $("#2ndmemberList").html(html);
								   }
									 
								},//end of success
								error: function(request, status, error){
									  
								    alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
								}
						      });//end of ajax;
					  }
			       } 
				    else if (countsecondAD == 0){
					   alert("부운영자가 있어야 권한 변경이 가능합니다.");
					   $("#Modal2Content").hide(); 
					   return;
				   }
				   else{ // 부운영자가 1명 일때
					   to2ndAdmin($(this).val());
				   }  
		   }
		   else if(useridval != adminuserid){ // 내가 아닌 회원의 권한을 부관리자로 변경했을때 
			    $("#Modal2Content").hide(); 
			    to2ndAdmin($(this).val());
		   }
	   });
	    
	   $("#toNormal").click(function(){ 
		   
		   var useridval = $("#toNormal").val().trim();
		   var adminuserid = $("#teamAdmin").val().trim(); 
		   
		   if(adminuserid == useridval){ //내 권한을 바꿨을때  
			    
			   var countsecondAD = ${secondAdminCnt}; 
				  
				  if(countsecondAD >= 2){ // 부운영자가 2명이상 있다면 선택할 수 있게끔 모달창을 띄운다.
					  var team_idxval = ${teamvo.team_idx}
					  
					  var form_data = { team_idx : team_idxval }
					
					  if(${sessionScope.loginuser.userid  == "" || sessionScope.loginuser.userid  == null }){
						  alert("you must login. go to login page..");
						  location.href="<%= request.getContextPath()%>/index.action";   
					  }
					  else{ 
						  $.ajax({ 
							  
							    url: "SecondAdminListJSON.action",
								type:"GET",
								data: form_data,
								dataType:"JSON",
								success: function(json){
								  
								   var html = "";
								   if(json.length > 0){
									   
									  $.each(json, function(entryindex, entry){ 
										  html += "<input type='radio' name='chguser' id='chguser' value='"+entry.team_userid+"' />&nbsp;&nbsp;<span style='color:black; font-weight:black;'>"+entry.team_userid+"</span><br/>";
										  html += "<input type='hidden' name='team_idx' value='"+entry.fk_team_idx+"'/>";
										  html += "<input type='hidden' name='status' value='0'/>";
									  });
				                      
									  $("#2ndmemberList").html(html);
								   }
									
								},//end of success
								error: function(request, status, error){
									  
								    alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
								}
						  });//end of ajax;
					  }
			       }
				   else if (countsecondAD == 0){
					   alert("부운영자가 있어야 권한 변경이 가능합니다.");
					   $("#Modal2Content").hide(); 
					   return;
				   }
				   else { // 부운영자가 1명일때
					     toNormal($(this).val());
				   }  
		   }
		   else if(useridval != adminuserid){
			    $("#Modal2Content").hide(); 
			    toNormal($(this).val());
		   }
		   
	   });  
   });//end of document.ready
   
     
    function toAdmin(userid){ // 운영자가 권한을 부여 (관리자로 변경, 기존 운영자는 일반사용자로 변경됨 )  
	     
                if( confirm("변경하시겠습니까?")){
				   var frm = document.manageFrm; 
				   frm.otherstatus.value = "2";
			       frm.userid.value = userid;
				   frm.team_idx.value = ${team_idx};
				   
				   frm.method="POST";
				   frm.action="<%= request.getContextPath()%>/cngToAdmin.action";
				   frm.submit();
			    }  
			    else{
				   return; 
			    }   
	 }
	   
	   
	   function to2ndAdmin(userid){ // 운영자가 권한을 부여 (부관리자로 변경)  
			    if( confirm("변경하시겠습니까?")){
				   var frm = document.manageFrm; 
				   frm.otherstatus.value = "1";
			       frm.userid.value = userid;
				   frm.team_idx.value = ${team_idx};
				   
				   frm.method="POST";
				   frm.action="<%= request.getContextPath()%>/cngTo2ndAdmin.action";
				   frm.submit();
			    }  
			    else{
				   return; 
			    }   
	   } 
	  
		function toNormal(userid){ // 운영자가 권한을 부여 (일반사용자로 변경) 
		     if( confirm("변경하시겠습니까?")){
			   var frm = document.manageFrm; 
			   frm.otherstatus.value = "0";
		       frm.userid.value = userid;
			   frm.team_idx.value = ${team_idx};
			   
			   frm.method="POST";
			   frm.action="<%= request.getContextPath()%>/cngToNormal.action";
			   frm.submit();
		     } 
		     else{
		    	 return;
		     }
	    } 
		
		
		
   function  searchBarAjax( ){ // 관리자가 팀원을 검색할때 
      
	  var form_data = { searchWord : $("#searchWord").val()
		               , "team_idx" : ${teamvo.team_idx} };  
   
			
	  if(${sessionScope.loginuser.userid  == "" || sessionScope.loginuser.userid  == null }){
		  alert("you must login. go to login page..");
		  location.href="<%= request.getContextPath()%>/index.action";   
	  } 
	  else{
			 $.ajax({
		  
					url: "wordSearchJSON.action",
					type:"GET",
					data: form_data,
					dataType:"JSON",
					success: function(json){
					  
					    $("#displayData").empty(); 
					     
					     
						if(json.length > 0){// 검색된 데이터가 있는 경우
						// 데이터가 없어도 결과값이 [] 이렇게 나오기 때문에  if(json != null)  이 아니라 >0 이런식으로 표기를 해야한다.
					    
						   var html = "";  
						
						   $.each(json, function(entryindex, entry){ 
							  
							    var word = entry.nickname.trim();  // 공백이 들어가는 경우를 대비하여 공백을 없앤다.
							             // 예) ajax 프로그래밍
							    
							    var index = word.toLowerCase().indexOf($("#searchWord").val().toLowerCase());
							             // word에서 영문자는 모두 소문자로 바꾼다는 뜻. word도 소문자로 바꾸어주었기 때문에 내가 검색한 데이터 searchWord도 소문자로 바꾸어준다 
							             // 반대는 toUpperCase()
							             // 만약 ("#searchWord").val().toLowerCase() 이 ja라면 ajax 프로그래밍을 예로 듦면 index값은 1이 나온다
							     
							    html += "<li><a style='cursor:pointer;' class='first'>"+entry.nickname+"&nbsp;("+entry.userid+")"; 
							    html += "</a><input type='hidden' id='memberId' value='"+entry.userid+"'/> </li>";  
						   });// end of each   
						 
						   $("#displayData").append(html)
						   $("#displayData").show();  
						     
						   
						   document.getElementById("searchmember").disabled = false; 
						}
						else{
						    // 검색된 데이터가 없는 경우	
						    $("#displayData").hide();
						    document.getElementById("searchmember").disabled = true;  
						} 
					},//end of success
					error: function(request, status, error){
						  
					    alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				
			 });//end of ajax 
	  }
	}
   
   
   function  searchBarAjax2( ){ // 팀내에 멤버가존재하고 그외의 멤버를 관리자가  검색할때 
	     
		  
		  var form_data = { searchWord : $("#searchWord2").val()
		                   ,team_idx : ${teamvo.team_idx} };   
			
		  if(${sessionScope.loginuser.userid  == "" || sessionScope.loginuser.userid  == null }){
			  alert("you must login. go to login page..");
			  location.href="<%= request.getContextPath()%>/index.action";   
		  } 
		  else{ 
				$.ajax({
						url: "wordSearchJSON2.action",
						type:"GET",
						data: form_data,
						dataType:"JSON",
						success: function(json){
						  
						    $("#displayData2").empty(); 
						     
						     
							if(json.length > 0){// 검색된 데이터가 있는 경우
							// 데이터가 없어도 결과값이 [] 이렇게 나오기 때문에  if(json != null)  이 아니라 >0 이런식으로 표기를 해야한다.
						    
							   var html = "";  
							
							   $.each(json, function(entryindex, entry){ 
								  
								    var word = entry.nickname.trim();  // 공백이 들어가는 경우를 대비하여 공백을 없앤다.
								             // 예) ajax 프로그래밍
								    
								    var index = word.toLowerCase().indexOf($("#searchWord2").val().toLowerCase());
								             // word에서 영문자는 모두 소문자로 바꾼다는 뜻. word도 소문자로 바꾸어주었기 때문에 내가 검색한 데이터 searchWord도 소문자로 바꾸어준다 
								             // 반대는 toUpperCase()
								             // 만약 ("#searchWord").val().toLowerCase() 이 ja라면 ajax 프로그래밍을 예로 듦면 index값은 1이 나온다
								     
								    html += "<li><a style='cursor:pointer;' class='first'>"+entry.nickname+"&nbsp;("+entry.userid+")"; 
								    html += "</a><input type='hidden' id='memberId2' value='"+entry.userid+"'/> </li>";  
							   });// end of each   
							 
							   $("#displayData2").append(html)
							   $("#displayData2").show();  
							     
							   
							   document.getElementById("searchmember2").disabled = false; 
							}
							else{
							    // 검색된 데이터가 없는 경우	
							    $("#displayData2").hide();
							    document.getElementById("searchmember2").disabled = true;  
							} 
						},//end of success
						error: function(request, status, error){
							  
						    alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
						}
					
				 });//end of ajax
		    }
		} 
   
   var length = 10;
   
   function showMember(start){ // 팀원들이 존재했을때 
	   
	   var team_idx_val = ${team_idx}; 
	   
	   var form_data = {team_idx : team_idx_val
			           ,"start" : start
			           ,"len" : length};
	   
	   if(${sessionScope.loginuser.userid  == "" || sessionScope.loginuser.userid  == null }){
			  alert("you must login. go to login page..");
			  location.href="<%= request.getContextPath()%>/index.action";   
	   } 
	   else{
		      $.ajax({ 
		     
		      url:"<%= request.getContextPath()%>/getMembers.action",
	  	      type:"GET", 
	  	      data:form_data,
	  	      dataType:"JSON",
	  	      success:function(json){
	  	    	    
	  	    	     var html = "";
	  	    	      
	  	    	         html += "<table class='table'> "; 
					  	 html += "  <tbody>"; 
					  	 
					 if(json.length > 0){		
						 
						  $.each(json, function(entryindex, entry){
	
						  		html += "  <tr>";
				  	    	    html += "    <td style='padding:15px;'>"+entry.nickname+"("+entry.name+")</td>";
				  	    	    html += "    <td style='padding:15px;'>"+entry.userid+"</td>";
				  	    	    if("${teamvo.admin_userid}" == "${sessionScope.loginuser.userid}"){
				  	    	    	html += "    <td style='width:385px; padding:15px;'>"+entry.email+"</td>";
				  	    	    }
				  	    	    else if("${teamvo.admin_userid}" != "${sessionScope.loginuser.userid}"){
				  	    	    	html += "    <td style='width:270px; padding:15px;'>"+entry.email+"</td>";
				  	    	    } 
				  	       		html += "    <td>";
				  	       	    html += "      <c:set var='entryUserid' value='"+entry.userid+"'></c:set>";
				  	       		
				  	       	    if( "${teamvo.admin_userid}" == "${sessionScope.loginuser.userid}"){
					  	       	      if(entry.team_member_admin_status == 0){
					  	       	    	html += "<button type='button' class='btn btnAdmin' data-toggle='modal' data-target='#myModal1' value='${entryUserid}' style='width:130px;'><span style='color:black; font-weight:bold;'>Normal&nbsp;&nbsp;</span><span class='glyphicon glyphicon-cog'></span></button>&nbsp;&nbsp;<input type='hidden' value='"+entry.userid+"'/>";                                  
					  	       	      }
					  	       	      else if(entry.team_member_admin_status == 1){
					  	       	    	html += "<button type='button' class='btn btnAdmin' data-toggle='modal' data-target='#myModal1' value='${entryUserid}' style='width:130px;'><span style='color:black; font-weight:bold;'>Second Admin&nbsp;&nbsp;</span><span class='glyphicon glyphicon-cog'></span></button>&nbsp;&nbsp;<input type='hidden' value='"+entry.userid+"'/>"; 
					  	       	      }
					  	       	      else if(entry.team_member_admin_status == 2){
					  	       	    	html += "<button type='button' class='btn btnAdmin' data-toggle='modal' data-target='#myModal1' value='${entryUserid}' style='width:130px;'><span style='color:black; font-weight:bold;'>Admin&nbsp;&nbsp;</span><span class='glyphicon glyphicon-cog'></span></button>&nbsp;&nbsp;<input type='hidden' value='"+entry.userid+"'/>";  
					  	       	      } 
				  	       	      
				  	       	    }
				  	       	    else if("${teamvo.admin_userid}" != "${sessionScope.loginuser.userid}"){
					  	       	      if(entry.team_member_admin_status == 0){
					  	       	    	html += "<span style='margin-right:5px; padding:15px; width:130px;'>Normal"; 
					  	       	      }
					  	       	      else if(entry.team_member_admin_status == 1){
					  	       	        html += "<span style='margin-right:5px;  padding:15px; width:130px;'>Second Admin&nbsp;</span>"; 
					  	       	      }
					  	       	      else if(entry.team_member_admin_status == 2){
					  	       	    	html += "<span style='margin-right:5px;  padding:15px; width:130px;'>Admin</span>";   
					  	       	      } 
				  	       	    } 
				  	       	   
				  	       	    
				  	       	    if( "${teamvo.admin_userid}" == "${sessionScope.loginuser.userid}"){
				  	       	      html += "        <button type='button' onclick='leave(\""+entry.userid+"\");'  class='btn btnLeave' value='${entryUserid}' style='width:130px; margin-left:15px;'><span style='color:black; font-weight:bold;'>Leave&nbsp;&nbsp;</span><span class='glyphicon glyphicon-remove'><span></button><input type='hidden' value='"+entry.userid+"'/>"; 
				  	       	    }
				  	       	    else if("${teamvo.admin_userid}" != "${sessionScope.loginuser.userid}" && entry.userid == "${sessionScope.loginuser.userid}"){
				  	       	      html += "        <button type='button' onclick='leave(\""+entry.userid+"\");'  class='btn btnLeave' value='${entryUserid}' style='width:130px; margin-left:15px;'><span style='color:black; font-weight:bold;'>Leave&nbsp;&nbsp;</span><span class='glyphicon glyphicon-remove'><span></button><input type='hidden' value='"+entry.userid+"'/>"; 
				  	       	    } 
				  	       	    
				  	       	    html += "    </td>"; 
					  	        html += "  </tr>";
						  		  
					  	        $("#totalCount").text(entry.totalCount);
						  	 }); //end of each
					     }    	    
					     html += "  </tbody>";
					     html += " </table>";
					     
	  	    	     	 
					 $("#input").append(html); 
					 
		    	     $("#btnMore").val(parseInt(start)+length); 
		    	     
		    	     if($("#totalCount").text() <= 10 ){
		    			 $("#btnMore").hide();
		    		 }	   
		    		 else{
		    			 $("#btnMore").show();
		    			 $("#btnMore").text("More");
		    		 }
		    	     
		    	     $("#count").text(parseInt($("#count").text()) + json.length);
		    	     
		    	     if($("#count").text() == $("#totalCount").text() ){
		    	       		$("#btnMore").text("Back");
		    	       		$("#count").text("0");
		    	     }   
		    	      
		    	   
	  	      },
	  	      error: function(request, status, error){
	  				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	  	      }
	    		 
	   });//end of ajax
	 } 
   }// end of function showMember()---------------------------------
  
   function searchMember(){ // 팀원들이 존재하지 않을때 
	   
	   var html =   " <c:if test='${(sessionScope.loginuser).userid == teamvo.admin_userid}'>   ";   
	       html +=  "  <form name='searchFrm'>";
	       html +=  "   <div style=' margin-left: 250px; margin-top:50px; '>";
	       html +=  "     <img src='resources/img/letter.png' alt='' style='width:110px;height:110px; margin-left:145px;'>";
	       html +=  "     <h2 style='margin-top:10px; font-size:28pt; font-weight:bold; color:black; margin-left:62px;'>Invite Your Team</h2>";
		   html +=  "        <input type='text' placeholder='Search Member' name='searchWord' id='searchWord' style='width:300px;'>";
		   html +=  "        <input type='hidden' name='searchUserid' id='searchUserid' style='width:100px;'>";
		   html +=  "       <button type='button' id='searchmember' class='btn btn-primary' style='font-weight:bold; width:140px; margin-bottom:5px;'>Invite to Team</button>";
		   
		   html +=  "      <div id='display' class='dropdown' >"; 
	       html +=  "        <ul class='dropdown-menu' id='displayData'></ul>";  
	       html +=  "	   </div>"; 
		   
		   
		   html +=  "   </div>"; 
		   html +=  "  </form>";
		   html +=  " </c:if>";
		   
		   html +=  "<c:if test='${(sessionScope.loginuser).userid != teamvo.admin_userid}'>   "; 
		   html +=  "  <table>";
		   html +=  "   <td><tr><span  style='color: #ff5252; font-weight:bold;'><span class='glyphicon glyphicon-exclamation-sign'></span>&nbsp;There is no members</span></tr></td>";
		   html +=  "  </table>";
		   html +=  "</c:if>";
	   
	   $("#input").html(html);
	   
   }
   
   function leave(userid){ // 회원이 탈퇴하거나 운영자가 탈퇴시킬때  
	   
	   if( confirm("탈퇴하시겠습니까?")){
		   
		   var secondAdminCnt = ${secondAdminCnt};
		   var admin_userid = $("#teamAdmin").val();
		   if(secondAdminCnt == 0 && admin_userid == userid  ){  // 부관리자가 없을때 
			   alert("부관리자를 지정해주세요.");
			   return; 
		   }
		   else if(secondAdminCnt > 1 && admin_userid == userid ){ // 부관리자가 2명이상일때
			   alert("부관리자 중 1명을 Admin으로 임명해주세요.");
		       return;			   
		   }
		   else{ // 부관리자가 1명일때 
			   
			   var frm = document.manageFrm; 
		       frm.userid.value = userid;
			   frm.team_idx.value = ${team_idx};
			   
			   frm.method="POST";
			   frm.action="<%= request.getContextPath()%>/leaveTeam.action";
			   frm.submit();
		   } 
	    }  
	    else{
		   return; 
	    }   
	   
   }
	
	function searchMyTmemberAjax(){
		var team_idxval = ${teamvo.team_idx}
		var form_data = { searchMyTmember : $("#searchMyTmember").val() 
				         , team_idx : team_idxval };  
		 
		if(${sessionScope.loginuser.userid  == "" || sessionScope.loginuser.userid  == null }){
			  alert("you must login. go to login page..");
			  location.href="<%= request.getContextPath()%>/index.action";   
		} 
		else{
			
			
			
			   $.ajax({
		 
					url: "myTmemberSearchJSON.action",
					type:"GET",
					data: form_data,
					dataType:"JSON",
					success: function(json){
					  
					    $("#input").empty();  
					    
						if(json.length > 0){// 검색된 데이터가 있는 경우
						// 데이터가 없어도 결과값이 [] 이렇게 나오기 때문에  if(json != null)  이 아니라 >0 이런식으로 표기를 해야한다.
					     
						   var html = "<table class='table'> "; 
						  	   html += "  <tbody>"; 
						 					 
						  	 $.each(json, function(entryindex, entry){
	
						  		html += "  <tr>";
				  	    	    html += "    <td style='padding:15px;'>"+entry.nickname+"("+entry.name+")</td>";
				  	    	    html += "    <td>"+entry.userid+"</td>";
				  	       		html += "    <td style='width:500px;'>"+entry.email+"</td>";
				  	       		html += "    <td>";
				  	       	    html += "      <c:set var='entryUserid' value='"+entry.userid+"'></c:set>";
				  	       		
				  	       	    if("${teamvo.admin_userid}" != "${sessionScope.loginuser.userid}"){
					  	       	      if(entry.team_member_admin_status == 0){
					  	       	    	html += "Normal&nbsp;&nbsp;&nbsp;&nbsp;"; 
					  	       	      }
					  	       	      else if(entry.team_member_admin_status == 1){
					  	       	        html += "Second Admin&nbsp;&nbsp;&nbsp;&nbsp;"; 
					  	       	      }
					  	       	      else if(entry.team_member_admin_status == 2){
					  	       	    	html += "Admin&nbsp;&nbsp;&nbsp;&nbsp;";   
					  	       	      } 
				  	       	    } 
				  	       	   
				  	       	    html += "    </td>";
					  	        html += "  </tr>";
						  		  
						  	 }); 
						  	    	    
						     html += "  </tbody>";
						     html += " </table>"; 
						}
						else{
						    // 검색된 데이터가 없는 경우	
						    html += " <tr>";
						    html += "   <td>";
						    html += "     <h3><span class='glyphicon glyphicon-remove' style='color:black; font-weight:bold; margin-top:140px; margin-left:200px;'> There is no matching keyword </span></h3>";
						    html += "   </td>";
						    html += " </tr>";
						} 
						
						$("#input").html(html); 
						$("#btnMore").hide();
					},
					error: function(request, status, error){
						  
					    alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
					
				
		   });//end of ajax
		}	
	}
</script>


</head>
<body> 
    <div class="btn-group-vertical" style="margin-left: 230px; border: solid 0px black; margin-top: 30px;"> 
	  <button type="button" class="btn btn1" disabled="disabled" ><span style="font-weight: bold;">Members of Team Boards</span></button>
	  
	  <c:if test="${memberCnt > 0}"> <!-- 팀원이 존재했을때  -->
	    <button type="button" class="btn btn1" id="showBtn" disabled="disabled"><span style="font-weight: bold; color:black;">Team Members ( ${memberCnt + 1} )</span></button>  
      </c:if>
	  
	  <c:if test="${memberCnt == 0 }"> <!-- 팀원이 존재하지 않을때  -->
	    <button type="button" class="btn btn1" id="searchBtn" onClick="searchMember();" disabled="disabled"><span style="font-weight: bold; color:black;">Team Members</span></button>
	  </c:if>
	</div>
	
	<c:if test="${memberCnt > 0 && teamvo.admin_userid != sessionScope.loginuser.userid}">
	  <input type="text" placeholder="Search team member" name="searchMyTmember" id="searchMyTmember" style="width:230px; margin-left:850px;">
	</c:if>
	
	<c:if test="${memberCnt > 0 && teamvo.admin_userid == sessionScope.loginuser.userid }"> 
	    <form name="searchFrm2" class="form-inline"> 
			  <input type="text" placeholder="Search Member" name="searchWord" id="searchWord2" style="width:230px; margin-left:1150px;" ><button type="button" id="searchmember2" class="btn btn-primary" style="font-weight:bold; width:130px; margin-bottom:5px; margin-left:6px;">Invite to Team</button> 
			  <input type="hidden" name="searchUserid" id="searchUserid2">  
			  <input type="hidden" name="status" id="status" value="" />
			  
			  <div id="display2" class="dropdown" style="margin-left:1150px;"> 
		        <ul class="dropdown-menu" id="displayData2"></ul>  
		      </div>   
		</form>
	</c:if>
	
	<div style="margin-left: 460px; margin-top: -50px;">
	    <h4 style=" font-weight: bold; width:100px; border: solid 0px black; display: inline; color:black;">Team Members ( ${memberCnt + 1} )</h4>
	    <br/><h5 style="width:200px; font-weight: bold; width:100px; border: solid 0px black; display: inline;">Team members can view and join all Team Visible boards and create new boards in the team.</h5>
		 
		<div id="input" style=" border: solid 0px black; width:1070px; margin-top: 10px;" >
		</div>
		
		<c:if test="${memberCnt > 10}">
		  <div style="margin-top: 20px; margin-bottom:20px; margin-left:450px;">
			  <button type="button" class="btn" id="btnMore" value="" style="color:black; font-weight:bold;">More</button>
			  <span id="totalCount" hidden >${totalCount}</span> <!-- 총 멤버수보다 많아지면 더보기버튼을 안보여주기 위해 사용 -->
			  <span id="count" hidden >0</span> <!-- 현재 내가 멤버수를 몇개만큼 받아왔는지 알아보기 위해  count변수사용 -->
		  </div>
		</c:if>
		<form name="manageFrm">
		  <input type="hidden" id="userid" name="userid"/>
		  <input type="hidden" id="team_idx" name="team_idx"/>	 
		  <input type="hidden" id="admin_userid" name="admin_userid" value="${teamvo.admin_userid}"/> 
	      <input type="hidden" id="secondAdminCnt" name="secondAdminCnt" value="${secondAdminCnt}" />
		  <input type="hidden" id="otherstatus" name="otherstatus" value="" />
		</form>
	
	    <form name="inviteFrm">
	      <input type="hidden" id="inviteUser" name="inviteUser" />
	      <input type="hidden" id="team_idx" name="team_idx"/>
	    </form>
	</div>
	  <!-- Modal -->
	  <div class="modal" id="myModal1" role="dialog" >
	    <div class="modal-dialog">
	    
	      <!-- Modal content-->
	      <div class="modal-content" style="left: 400px; top: 100px; width: 450px; ">
	        <div class="modal-header">
	          <button type="button"  class="close" data-dismiss="modal">&times;</button>
	          <h4 class="modal-title" style="color:black; font-weight: bold;">Change Permission</h4>
	        </div> 
	        <div class="modal-body">
	          <h4 style="font-weight:bold; color:black;" >Choose Permission</h4>
	           <div style="padding: 32px; display: block;" class="btn-group-vertical">
	           <button class="btn" id="toAdmin"    style="width:350px; font-weight:bold; color:black;"   value="">Change to Admin<br/><sub>Can view, create and edit team board, delete team, invite team</br> and change settings for the team </sub></button>
	           <button class="btn" id="to2ndAdmin" style="width:350px; font-weight:bold; color:black;  margin-top: 10px;" data-toggle='modal' data-target='#myModal2' value="">Change to Second Admin<br/><sub>Can view, create and edit team board, and change settings for the team </sub></button>
	           <button class="btn" id="toNormal"   style="width:350px; font-weight:bold; color:black;  margin-top: 10px;" data-toggle='modal' data-target='#myModal2' value="">Change to Normal<br/><sub>Can view, create, and edit team board, but not change settings</sub></button>
	           <input type="hidden" id="teamAdmin" value="${teamvo.admin_userid}" />
	           </div>
	        </div>
	        <div class="modal-footer">
	          <button type="button" class="btn btn-default" data-dismiss="modal" style="color:black; font-weight:bold;">Close</button>
	        </div>
	      </div>
	      
	    </div>
	  </div>
	  
	  <!-- Modal -->
  <div class="modal fade" id="myModal2" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content" id="Modal2Content" style="left: 330px; top: 130px; width: 400px;" >
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="color:black; font-weight:bold;">Choose member</h4>
        </div>
        <div class="modal-body">
          <p style="color:black; font-weight:bold;">choose one of second administrators who will get Admin permission</p>
         
          <form name="secondAdminFrm">
            <div id="2ndmemberList" >  
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal" id="giveAdmin">Submit</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
      
    </div>
  </div>  
  
</body>
</html>