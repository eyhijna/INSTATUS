<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>     
    
<jsp:include page="top.jsp" /> 


<style>

.btnTeam{
   background: #e2e4e6;
   color: black;
   margin-left: 50px;
}
</style>
   
<script>

$(document).ready(function(){
	invitedTeams();
	requestTeams();
});
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function invitedTeams(){
	
	$.ajax({
	   url: "mySettingJSON.action",
	   type: "GET",
	   dataType: "JSON",
	   success: function(json){
		   
		   var html = "";
		   
		   if(json.length == 0){
			   
			   html +=  "<td style='text-align: center;' colspan='5'>" +"초대받은 팀이 없습니다."+"</td>"
			   
			   $("#invitedTeamList").html(html);		   			   
		   }
		   else{
			   
			   $.each(json, function(entryIndex, entry){
   
			      html += "<tr>"			        			           
			           + "<td style='width: 90%;'><span style='color: rgb(255, 82, 82);'>"+entry.TEAM_NAME+"</span> 에서 초대하셨습니다.</td> "
			           +  "<td >"
	                   +  "<button type='button' class='btn btnTeam btn-sm'  name='approve' id='approve' value='승인' onclick='approve();'  ><span style='font-weight: bold'>승인</span></button>"  
	                   +  "<td >"
	                   +  "<button type='button' class='btn btnTeam btn-sm'  name='deny' id='deny' value='거절' onclick='deny();'><span style='font-weight: bold'>거절</span></button>"
	                   +  "</td>"
	                   + "<input type='hidden' name='fk_team_idx' id='fk_team_idx' value='"+entry.FK_TEAM_IDX+"'>"	 
	                   + "<input type='hidden' name='TEAM_MEMBER_ADMIN_STATUS' id='TEAM_MEMBER_ADMIN_STATUS' value='"+entry.TEAM_MEMBER_ADMIN_STATUS+"'>"	 
	                   +  "</td>"
	                   + "</tr>"
			         			   
			   });
			   			       
			       $("#invitedTeamList").append(html);   			   
			   
		      } // end of if~else		   
		   
		   },// end of success: function(json)---------------------------------------------------
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); 
			}
	
	});
}

// 팀초대 승인
function approve(){
		
	var fk_team_idx = $("#fk_team_idx").val();
	
	var approve = $("#approve").val();
	var deny = $("#deny").val();
	var TEAM_MEMBER_ADMIN_STATUS =$("#TEAM_MEMBER_ADMIN_STATUS").val();
	
	var form_data = {"fk_team_idx" : fk_team_idx,
			          "approve" : approve,
			          "TEAM_MEMBER_ADMIN_STATUS" : TEAM_MEMBER_ADMIN_STATUS};
	
	$.ajax({
	   url: "approveTeamJSON.action",
	   type: "GET",
	   data: form_data,
	   dataType: "JSON",
	   success: function(json){
		   
		   var html = "";
		   
		   if(json.length == 0){
			   
			   html += "<td style='text-align: center;' colspan='5'>" +"초대한 팀이 없습니다."+"</td>"
			   
			   $("#invitedTeamList").html(html);		   
			   
		   }
		   else{
			   $.each(json, function(entryIndex, entry){
				   			   
			      html += "<tr>"
			           + "<td style='width: 90%;'><span style='color: rgb(255, 82, 82);'>"+entry.TEAM_NAME+"</span> 에서 초대하셨습니다.</td> "
			           +  "<td >"
	                   +  "<button type='button' class='btn btnTeam btn-sm'  name='approve'id='approve' value='승인' onclick='approve();'><span style='font-weight: bold'>승인</span></button>"
	                   +  "<td >"
	                   +  "<button type='button' class='btn  btnTeam btn-sm'  name='deny'   id='deny' value='거절' onclick='deny();' ><span style='font-weight: bold'>거절</span></button>"
	                   + "</td>"
	                   + "<input type='hidden' name='fk_team_idx' id='fk_team_idx' value='"+entry.FK_TEAM_IDX+"'>"	
	                   + "<input type='hidden' name='TEAM_MEMBER_ADMIN_STATUS' id='TEAM_MEMBER_ADMIN_STATUS' value='"+entry.TEAM_MEMBER_ADMIN_STATUS+"'>"	
	                   +  "</td>"
	                   + "</tr>"	             			   
			   });
			  			   
		      } // end of if~else
		   $("#invitedTeamList").empty();
		   $("#invitedTeamList").append(html);   
		   
		   },// end of success: function(json)---------------------------------------------------
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); 
			}
	    });
}	

// 팀초대 거절	
function deny(){
		
		var fk_team_idx = $("#fk_team_idx").val();
		
	    var approve = $("#approve").val(); 
		var deny = $("#deny").val();
		var TEAM_MEMBER_ADMIN_STATUS =$("#TEAM_MEMBER_ADMIN_STATUS").val();
		
		console.log(TEAM_MEMBER_ADMIN_STATUS);
		console.log(fk_team_idx);
		
		var form_data = {"fk_team_idx" : fk_team_idx,				  
				          "deny" : deny,
				          "TEAM_MEMBER_ADMIN_STATUS" : TEAM_MEMBER_ADMIN_STATUS};
		

		
		$.ajax({
		   url: "approveTeamJSON.action",
		   type: "GET",
		   data: form_data,
		   dataType: "JSON",
		   success: function(json){
			   
			   var html = "";
			   
			   if(json.length == 0){
								   
				   html += "<td style='text-align: center;' colspan='5'>" +"초대한 팀이 없습니다."+"</td>"				   
				   $("#invitedTeamList").html(html);	
				 			   
			   }
			   else{

					   $.each(json, function(entryIndex, entry){
						   				   			   
					      html += "<tr>"
					           + "<td style='width: 90%;'><span style='color: rgb(255, 82, 82);'>"+entry.TEAM_NAME+"</span> 에서 초대하셨습니다.</td> "
					           +  "<td>"
			                   +  "<button type='button' class='btn btnTeam btn-sm'  name='approve'id='approve' value='승인' onclick='approve();'><span style=' font-weight: bold'>승인</span></button>"
			                   +  "<td >"
			                   +  "<button type='button' class='btn  btnTeam btn-sm'  name='deny'   id='deny' value='거절' onclick='deny();' ><span style='font-weight: bold'>거절</span></button>"
			                   +  "</td>"
			                   + "<input type='hidden' name='fk_team_idx' id='fk_team_idx' value='"+entry.FK_TEAM_IDX+"'>"	
			                   + "<input type='hidden' name='TEAM_MEMBER_ADMIN_STATUS' id='TEAM_MEMBER_ADMIN_STATUS' value='"+entry.TEAM_MEMBER_ADMIN_STATUS+"'>"	
			                   +  "</td>"
			                   + "</tr>"	
			  
				          });
				   	   
			      } // end of if~else
			    	  
			    	  
			    	  
			    
			    	  
				   $("#invitedTeamList").empty();
				   $("#invitedTeamList").append(html);  
			   
			   },// end of success: function(json)---------------------------------------------------
				error: function(request, status, error){
					alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); 
				}
		
		});
		
}


	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 가입신청 팀 목록 보여주기
function requestTeams(){

	$.ajax({
	   url: "reqTeamNameJSON.action",
	   type: "GET",
	   dataType: "JSON",
	   success: function(json){
		   
		   var html = "";
		   
		   if(json.length == 0){
			   
			   html += "<td style='text-align: center;' colspan='5'>" +"가입신청한 팀이 없습니다."+"</td>"
			   
			   $("#requestTeamList").html(html);		   
			   
		   }
		   else{
			   $.each(json, function(entryIndex, entry){
				  			   
			      html += "<tr>"			        			           
			           + "<td style='width: 95%;'><span style='color: rgb(255, 82, 82); font-weight: bold;'>"+entry.team_name+"</span> 에 가입 신청하셨습니다."
			           + "<span style='font-style: italic; color: #ca4889; font-weight: bold;font-size: 8px;'>승인대기중</span></td> "                   
	                   +  "</td>"
	                   +  "<td >"
	                   +  "<button type='button' class='btn btnTeam btn-sm'  name='deny' id='deny' value='취소' onclick='cancel();' style='background-color: none;'><span class='glyphicon glyphicon-remove'></span></button>"
	                   + "<input type='hidden' name='fk_team_idx_cancel' id='fk_team_idx_cancel' value='"+entry.FK_TEAM_IDX+"'>"	 
	                   + "<input type='hidden' name='TEAM_MEMBER_ADMIN_STATUS_cancel' id='TEAM_MEMBER_ADMIN_STATUS_cancel' value='"+entry.TEAM_MEMBER_ADMIN_STATUS+"'>"	
	                   +  "</td>" 
	                   + "</tr>"
			          			   
			   });
			   		       
			       $("#requestTeamList").append(html);   
			   			   
		      } // end of if~else		   
		   
		   },// end of success: function(json)---------------------------------------------------
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); 
			}
	
	});
}


//팀초대 거절	
function cancel(){
		
		var fk_team_idx = $("#fk_team_idx_cancel").val();
		
	    var approve = $("#approve").val(); 
		var deny = $("#deny").val();
/* 		var deny1 = $("#deny1").val(); */
		var TEAM_MEMBER_ADMIN_STATUS =$("#TEAM_MEMBER_ADMIN_STATUS_cancel").val();
		
		console.log(TEAM_MEMBER_ADMIN_STATUS);
		console.log(fk_team_idx);
		
		var form_data = {"fk_team_idx" : fk_team_idx,				  
				          "deny" : deny,
				          "TEAM_MEMBER_ADMIN_STATUS" : TEAM_MEMBER_ADMIN_STATUS};
		

		
		$.ajax({
		   url: "approveTeamJSON.action",
		   type: "GET",
		   data: form_data,
		   dataType: "JSON",
		   success: function(json){
			   
			   var html = "";
			   
			   if(json.length == 0){			  
					   html += "<td style='text-align: center;' colspan='5'>" +"가입신청한 팀이 없습니다."+"</td>"
					   
					   $("#requestTeamList").html(html);	
				   
			   }
			   else{
   
					   $.each(json, function(entryIndex, entry){
						   				   			   
						   html += "<tr>"			        			           
					           + "<td style='width: 95%;'><span style='color: rgb(255, 82, 82); font-weight: bold;'>"+entry.TEAM_NAME+"</span> 에 가입 신청하셨습니다."
					           + "<span style='font-style: italic; color: #ca4889; font-weight: bold;font-size: 8px;'>승인대기중</span></td> "                   
			                   +  "</td>"
			                   +  "<td '>"
			                   +  "<button type='button' class='btn btnTeam btn-sm' name='deny' id='deny' value='거절' onclick='cancel();' style='background: white;'><span class='glyphicon glyphicon-remove'></span></button>"
			                   + "<input type='hidden' name='fk_team_idx_cancel' id='fk_team_idx_cancel' value='"+entry.FK_TEAM_IDX+"'>"	 
			                   + "<input type='hidden' name='TEAM_MEMBER_ADMIN_STATUS_cancel' id='TEAM_MEMBER_ADMIN_STATUS_cancel' value='"+entry.TEAM_MEMBER_ADMIN_STATUS+"'>"	
			                   +  "</td>" 
			                   + "</tr>"
					  
					   });

				  
				   
			      } // end of if~else
			    	  
		
			    	  
			    	  $("#requestTeamList").empty();
					   $("#requestTeamList").append(html);  
			   
			   },// end of success: function(json)---------------------------------------------------
				error: function(request, status, error){
					alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); 
				}
		
		});
		
}









</script>
 
<div class="super_container"> 
   <div class="cart_container" style="padding-top: 20px;">
      <div class="container" >
         <div class="row" >
            <div class="col" > 

					  <div class="tab-content">
						   <!--  <div id="profile" class="tab-pane fade in active"> -->
						           <!-- 팀목록 -->
							       <div>
							        <table class="table table-hover">
							          <thead>
							            <tr>
							              <th>Invited Team Member</th>
							            </tr>
							          </thead>
							          
							          <!-- ajax처리한 데이터가 여기에 들어온다.  -->
							          <tbody id="invitedTeamList"></tbody>
							          
							         </table> 
							      <!--  </div> -->
						              
						    
					        </div>
					  </div>
					  
					   <div class="tab-content">
						 <!--    <div id="profile" class="tab-pane fade in active"> -->
						           <!-- 팀목록 -->
							       <div>
							        <table class="table table-hover">
							          <thead>
							            <tr>
							              <th>Request Team Member</th>
							            </tr>
							          </thead>
							          
							          <tbody id="requestTeamList"> </tbody>
							          
							         </table> 
							       </div>
						             						    
					       <!--  </div> -->
					  </div>

            </div>
         </div>
      </div>
   </div> 
</div>



