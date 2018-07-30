<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
.button { 
    border: 0px solid gray; 
    color: black;
    height : 60px;
    width : 250px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px; 
    cursor: pointer;
    width:200px;
    border-radius: 5px; 
    outline: none; 
    font-weight:bold;
} 

.button:hover {background-color: #ffffff}

.button:active {
  background-color: #ffffff;
  box-shadow: 3px 3px #666;
  transform: translateY(4px);
}


/* 30일 다솜 추가*/
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
</style>
<script type="text/javascript">
  $(document).ready(function(){
	   
	  if(${mystatus != 0 && mystatus != 1 && mystatus != 2}){
		   
		  displayPublicProject("1");
		  $("#display1").hide();
		  $("#display2").show();
	  }  
	  else{ 
		  
		  displayProject("1");
		  $("#display2").hide();
		  $("#display1").show();
	  }
	  
	  $("#btnMore").bind("click", function(){
		  
		   if($(this).text() == "Back"){   
			   
		      $("#displayResult").empty();
		      displayProject("1");
		      $(this).text("More");
		   }
		   else{
			   displayProject($(this).val());// 버튼의 value값을 넣는다 
		   }
	  });
	  
	  $("#btnMore1").bind("click", function(){
		  
		   if($(this).text() == "Back"){   
			   
		      $("#displayResult").empty();
		      displayPublicProject("1");
		      $(this).text("More");
		   }
		   else{
			   displayPublicProject($(this).val());// 버튼의 value값을 넣는다 
		   }
	  });
	  
	  
	  // 30일 다솜 Add
	  //프로젝트 생성 버튼을 눌렀을 때
		$(".btn-newProject").click(function(){
			var html = "";
			if("${teamvo.team_visibility_status == 0}"){ //팀노출도가 private인 경우
				html  = "<option value='0'>Team Visible</option>"
				      + "<option value='1'>Private</option>";
			}
			else if("${teamvo.team_visibility_status == 1}"){ //팀노출도가 public인 경우
				html  = "<option value='0'>Team Visible</option>"
			      	  + "<option value='1'>Private</option>"
			      	  + "<option value='2'>Public</option>";
			}
			$("#pjst").append(html);
			
			//////////////////////////////////////////////////////////////////////////////////
			$("#pjst").bind("change", function(){ //프로젝트 생성에서 노출도 값이 변할 때 
    				$(".div_pjst_private").remove();
    				$("#pjst").css("border-color", "#2eb82e");
    		    	 if( $("#pjst").val() == "1"){ //프로젝트 노출도가 private인 경우 멤버 select창 추가
    		    		 // team_admin_status == 3 인 멤버들 모두 나오고 있음 (3이 어떤 멤버???)
    		    		var html = "<div class='form-group div_style div_pjst_private'>"
    		    				 + "	<label for='inner_div' style='margin-top: 10px;'>Select Team mate</label><br/>"
    							 + "<div class='inner_div' id='inner_div'>";	
    		    		var form_data2 = {"teamIDX" : "${team_idx}", "userid" : "${sessionScope.loginuser.userid}" };
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
    		    	 else{ //프로젝트 노출도가 public 또는 team visible인 경우
    		     	 	$(".div_pjst_private").remove();
	    		    	var html = "<div class='form-group div_style div_pjst_private'>"
    		    				 + "	<label for='pjst' style='margin-top: 10px;'>Select Team mate</label><br/>";
    		    		
    		    		var form_data2 = {"teamIDX" : "${team_idx}", "userid" : "${sessionScope.loginuser.userid}" };
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
			}); // end of $("#pjst").bind
			//////////////////////////////////////////////////////////////////////////////////
		}); // end of $(".btn-newProject").click
	   
	   
		//다솜추가
	    $("#btn-create").click(function(){ //프로젝트 생성버튼을 눌렀을 때
	    	if($("#pjst").val() != "" && $("#pjst").val() != 3 && $("#project_name").val() != ""){
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
	   
	   
	  $(".background-grid-trigger").click(function(event){
	    	var image_name = $(this).val();
	    	$("#testcontent").css("background-image","url(./resources/images/" + image_name + ")");	
			$("#image_idx").val($(this).next().val());
	    }); // end of $(".background-grid-trigger").click
	  
  });//end of doucment.ready
  
  
  var length = 4;
  function displayProject(start){
 	 
	 var team_idx = ${team_idx};
 	 var form_data = {"start" : start 
 			          ,"len" : length
 			          ,"team_idx" : team_idx };
 	 // 시작값이 1이고 1부터 HIT상품을 3개만 보여주라는 뜻 
 	 
 	if(${sessionScope.loginuser.userid  == "" || sessionScope.loginuser.userid  == null }){
		  alert("you must login. go to login page..");
		  location.href="<%= request.getContextPath()%>/index.action";   
    } 
	else{ 
 	 // dispaly 및 HIT 제품정보 추가 요청하기 (Ajax로 처리함)
 	   $.ajax({
 		       url: "projectDisplayJSON.action",
 		       type: "GET",
 		       data: form_data,
 		       dataType: "JSON",
 		       success : function(json){
 		    	   
 		    	   var html = "";
 		    	    
 		    	   if(json.length > 0){ // 데이터가 있는 경우 
 		    		   
 		    		    $.each(json, function(entryindex, entry){
 		    		    	
 		    		    	/*  html += "<div align='left' style='display: inline-block; margin-left:30px;'>"; 
	    		  			 html += "<br/><button type='button' class='button'>"+entry.project_name+"</button>";    					   
	    		  			 html += "<input type='hidden' name='project_idx' value='"+entry.project_idx+"'>";
	    		  			 html += "<br/><br/></div>";   */
	    		  			
	    		  			 //다솜추가
	    		  			 var url = "<%=request.getContextPath()%>/project.action?project_name="
   		  					 + entry.project_name
   		  					 + "&projectIDX="
   		  					 + entry.project_idx
   		  					 + "&team_IDX="
   		  					 + team_idx;
	    		  			
	    		  			 html += "<div align='left' style='display: inline-block; margin-left:30px;'>"; 
	    		  			 html += "<br/><button type='button' class='button' onClick='location.href= \" " + url + " \"' style='background-image: url(\"http://localhost:9090/finalins/resources/images/"+entry.project_image_name+"\"); color:white;'>";
	    		  			 if(entry.project_member_admin_status == 1){ 
		    		    		 html += "<span class='glyphicon glyphicon-user' style='color: gray;'>&nbsp;</span>";
		    		    	 }
	    		  			 html += ""+entry.project_name+"</button>";     					   
	    		  			 html += "<input type='hidden' name='project_idx' value='"+entry.project_idx+"'>";
	    		  			 html += "<br/><br/></div>";  
	    		  			 
	    		  		     $("#totalCount").text(entry.totalCount);
 		    		    });//end of each
 		    	   }//end of if  
 		    	       html += "<div style='clear: both;'>&nbsp;</div>";
 		    	       	 
 		    	        $("#displayResult").append(html);
 		    	         
 		    	        $("#btnMore").val(parseInt(start) + length );
 		    	        
 			    	     if($("#totalCount").text() <= 4 ){
 			    			 $("#btnMore").hide(); 
 			    		 }	   
 			    		 else{
 			    			 $("#btnMore").show();
 			    			 $("#btnMore").text("More");
 			    		 }
 			    	      
 		    	       	$("#count").text(parseInt($("#count").text()) + json.length ); 
 		    	      	if($("#count").text() == $("#totalCount").text() ){
 		    	       		$("#btnMore").text("Back");
 		    	       		$("#count").text("0");
 		    	       	} 
 		    	   
 		       },
 		       error: function(request, status, error){
	  	     	      alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	  	           }
 		       
 		   
 	   });
	}  
  }// displayProject(start) -------------------------------
  
  function displayPublicProject(start){
	 	 
		 var team_idx = ${team_idx};
	 	 var form_data = {"start" : start 
	 			          ,"len" : length
	 			          ,"team_idx" : team_idx }; 
	 	 
	 	if(${sessionScope.loginuser.userid  == "" || sessionScope.loginuser.userid  == null }){
			  alert("you must login. go to login page..");
			  location.href="<%= request.getContextPath()%>/index.action";   
	    } 
		else{  
	 	   $.ajax({
	 		       url: "projectPublicJSON.action",
	 		       type: "GET",
	 		       data: form_data,
	 		       dataType: "JSON",
	 		       success : function(json){
	 		    	   
	 		    	   var html = "";
	 		    	    
	 		    	   if(json.length > 0){ // 데이터가 있는 경우 
	 		    		   
	 		    		    $.each(json, function(entryindex, entry){
	 		    		    	
	 		    		    	 html += "<div align='left' style='display: inline-block; margin-left:30px;'>" 
		    		  			 html += "<br/><button type='button' class='button'>"+entry.project_name+"</button>";    					   
		    		  			 html += "<input type='hidden' name='project_idx' value='"+entry.project_idx+"'>";
		    		  			 html += "<br/><br/></div>"; 
		    		  				      
		    		  		     $("#totalCount1").text(entry.totalCount);
	 		    		    });//end of each
	 		    	   }//end of if 
	 		    	   else{
	 		    		   html += "<h3 style='color: #ff5252; font-weight:bold;'><span class='glyphicon glyphicon-exclamation-sign'></span>&nbsp;There is no project.<h3>";
	 		    	   }
	 		    	       html += "<div style='clear: both;'>&nbsp;</div>";
	 		    	       	 
	 		    	        $("#displayResult").append(html);
	 		    	         
	 		    	        $("#btnMore1").val(parseInt(start) + length );
	 		    	        
	 			    	     if($("#totalCount1").text() <= 4 ){
	 			    			 $("#btnMore1").hide(); 
	 			    		 }	   
	 			    		 else{
	 			    			 $("#btnMore1").show();
	 			    			 $("#btnMore1").text("More");
	 			    		 }
	 			    	      
	 		    	       	$("#count1").text(parseInt($("#count1").text()) + json.length ); 
	 		    	      	if($("#count1").text() == $("#totalCount1").text() ){
	 		    	       		$("#btnMore1").text("Back");
	 		    	       		$("#count1").text("0");
	 		    	       	} 
	 		    	   
	 		       },
	 		       error: function(request, status, error){
		  	     	      alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		  	       }
	 		       
	 		   
	 	   });
		}  
	 	 
}// end of  displayProject

</script>
</head>
<body> 

  <div style="width: 100%; margin-top: 60px; margin-bottom: 30px; margin-left:100px;">
	 <div style="display: block; margin-left:430px; margin-bottom:35px;">
	   <c:forEach items="${memberList}" var="member">
          <c:if test="${(sessionScope.loginuser).userid == member.team_userid && ( mystatus == 1 || mystatus == 2 )}">   
 	  	     <button type="button" class="button btn-newProject" data-toggle="modal" href="#CreateProjectModal">Create a new board</button>
 	  	     <!-- <a data-toggle="modal" href="#CreateProjectModal" style="font-size: 14pt; color: white; font-weight: bold;">Create Project</a> -->
 	  	  </c:if>
 	   </c:forEach> 
 	 </div> 
	 <div id="displayResult" style="margin-left: 400px; border: 0px solid gray;"> 
 	 </div>	    		   
	<div id="display1" style="margin-top: 10px; margin-left:850px; margin-bottom:20px;">
	  <button type="button" id="btnMore" class="btn" style="color:black; font-weight:bold;" value="">More</button>
	  <span id="totalCount" hidden>${totalCount}</span> <!-- 총 프로젝트 갯수(totalCOUNT)보다 많아지면 더보기버튼을 안보여주기 위해 사용 -->
	  <span id="count" hidden >0</span> <!-- 현재 내가 프로젝트를 몇개만큼 받아왔는지 알아보기 위해  count변수사용 -->
	</div>
	
	<div id="display2" style="margin-top: 10px; margin-left:850px; margin-bottom:20px;">
	  <button type="button" id="btnMore1" class="btn" style="color:black; font-weight:bold;" value="">More</button>
	  <span id="totalCount1" hidden >${totalCount}</span> <!-- 총 프로젝트 갯수(totalCOUNT)보다 많아지면 더보기버튼을 안보여주기 위해 사용 -->
	  <span id="count1" hidden >0</span> <!-- 현재 내가 프로젝트를 몇개만큼 받아왔는지 알아보기 위해  count변수사용 -->
	</div>
 </div>
 
 <!--  30일 다솜 Add -->
 <!-- 프로젝트 생성 Modal --> 
  <div class="modal fade" id="CreateProjectModal" role="dialog" >
    <div class="modal-dialog" style="width:380px;">
      <div class="modal-content" id="testcontent">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-weight: bold; color: red;">Create New Project!!</h4>
        </div>
        
        <!-- 소속된 팀이 있는 경우 -->
        <div class="modal-body" id="project-modal">
          <form name = PJcreateFrm>
          <div class="form-group">
            <label for="usr">Project title:</label>
            <input type="text" class="form-control" id="project_name" name="project_name" style="outline: none;">
            <span id="error_project_name" class="text-danger"></span>
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
				<c:forEach items="${imageList}" var="map" varStatus="status">
				<li class="background-grid-item">
					<button class="background-grid-trigger" type="button" style="background-image: url('./resources/images/${map.project_image_name}');" value="${map.project_image_name}"></button>
					<input type="hidden" name="input-image_idx" id="input-image_idx${status.count}" value="${map.project_image_idx}">
				</li>
				</c:forEach>
			</ul>
		  </div> 
		  
		  <input type="hidden" name="image_idx" id="image_idx">
		  <input type="hidden" name="PJuserid" id="PJuserid" value="${sessionScope.loginuser.userid}">
		  <input type="hidden" name="team" id="team" value="${team_idx}">
          </form>
        </div>
          
    	  <div class="modal-footer" style="margin-top: 0;">
          	<button type="button" class="btn btn-default" id="btn-create">create</button>
          	<button type="button" class="btn btn-default" data-dismiss="modal">cancel</button>
          </div> 
      </div>
    </div>
  </div>
</body>
</html>