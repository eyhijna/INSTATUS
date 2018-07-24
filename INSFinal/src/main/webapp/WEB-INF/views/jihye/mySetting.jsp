<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%-- <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>      --%>
    
<jsp:include page="top.jsp" /> 
   
<script>

$(document).ready(function(){
	invitedTeams();
});
    

function invitedTeams(){
	
	//var form_data = {"fk_team_idx" : teamName.FK_TEAM_IDX};
	
	
	
	$.ajax({
	   url: "mySettingJSON.action",
	   type: "GET",
	 //  data: form_data,
	   dataType: "JSON",
	   success: function(json){
		   
		   var html = "";
		   
		   if(json.length == 0){
			   
			   html += "초대한 팀이 없습니다.";
			   
			   $("#invitedTeamList").html(html);		   
			   
		   }
		   else{
			   $.each(json, function(entryIndex, entry){
				  
				
				   
			      html += "<tr>"			        			           
			           + "<td style='width: 60%;'><span style='color: orange;'>"+entry.TEAM_NAME+"</span> 에서 초대하셨습니다.</td> "
			           +  "<td style='width: 10%;'>"
	                   +  "<button type='button' class='btn btn-primary btn-sm'  name='approve' id='approve' value='승인' onclick='approve();'>승인</button>"
	                   +  "</td>"
	                   +  "<td style='width: 10%;'>"
	                   +  "<button type='button' class='btn btn-warning btn-sm'  name='deny' id='deny' value='거절' onclick='deny();'>거절</button>"
	                   + "<input type='text' name='fk_team_idx' id='fk_team_idx' value='"+entry.FK_TEAM_IDX+"'>"	    			   
	                   +  "</td>"
	                   + "</tr>"
			          
			   
			   });
			   
			       
			       $("#invitedTeamList").append(html);   
			   
			   
		      } // end of if~else
		   
		   
		   },// end of success: function(json)---------------------------------------------------
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
			}

	
	});
}

function approve(){
		
	var fk_team_idx = $("#fk_team_idx").val();
	

	var approve = $("#approve").val();
	var deny = $("#deny").val();
	
	var form_data = {"fk_team_idx" : fk_team_idx,
			          "approve" : approve
			     };
	

	
	$.ajax({
	   url: "approveTeamJSON.action",
	   type: "GET",
	   data: form_data,
	   dataType: "JSON",
	   success: function(json){
		   
		   var html = "";
		   
		   if(json.length == 0){
			   
			   html += "초대한 팀이 없습니다.";
			   
			   $("#invitedTeamList").html(html);		   
			   
		   }
		   else{
			   $.each(json, function(entryIndex, entry){
				   			   
			      html += "<tr>"
			           + "<td style='width: 60%;'><span style='color: orange;'>"+entry.TEAM_NAME+"</span> 에서 초대하셨습니다.</td> "
			           +  "<td style='width: 10%;'>"
	                   +  "<button type='button' class='btn btn-primary btn-sm'  name='approve'id='approve' value='승인' onclick='approve();'>승인</button>"
	                   +  "</td>"
	                   +  "<td style='width: 10%;'>"
	                   +  "<button type='button' class='btn  btn-warning btn-sm'  name='deny'   id='deny' value='거절' onclick='deny();'>거절</button>"
	                   + "<input type='text' name='fk_team_idx' id='fk_team_idx' value='"+entry.FK_TEAM_IDX+"'>"	
	                   +  "</td>"
	                   + "</tr>"	             			   
			   });
			  
			   
		      } // end of if~else
		   $("#invitedTeamList").empty();
		   $("#invitedTeamList").append(html);   
		   
		   },// end of success: function(json)---------------------------------------------------
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
			}

	
	});
}	
	
	function deny(){
		
		var fk_team_idx = $("#fk_team_idx").val();
		

		var approve = $("#approve").val();
		var deny = $("#deny").val();
		
		var form_data = {"fk_team_idx" : fk_team_idx,
				  
				          "deny" : deny};
		

		
		$.ajax({
		   url: "approveTeamJSON.action",
		   type: "GET",
		   data: form_data,
		   dataType: "JSON",
		   success: function(json){
			   
			   var html = "";
			   
			   if(json.length == 0){
				   
				   html += "초대한 팀이 없습니다.";
				   
				   $("#invitedTeamList").html(html);		   
				   
			   }
			   else{
				   $.each(json, function(entryIndex, entry){
					   			   
				      html += "<tr>"
				           + "<td style='width: 60%;'><span style='color: orange;'>"+entry.TEAM_NAME+"</span> 에서 초대하셨습니다.</td> "
				           +  "<td style='width: 10%;'>"
		                   +  "<button type='button' class='btn btn-primary btn-sm'  name='approve'id='approve' value='승인' onclick='approve();'>승인</button>"
		                   +  "</td>"
		                   +  "<td style='width: 10%;'>"
		                   +  "<button type='button' class='btn  btn-warning btn-sm'  name='deny'   id='deny' value='거절' onclick='deny();'>거절</button>"
		                   + "<input type='text' name='fk_team_idx' id='fk_team_idx' value='"+entry.FK_TEAM_IDX+"'>"	
		                   +  "</td>"
		                   + "</tr>"	             			   
				   });
				  
				   
			      } // end of if~else
			   $("#invitedTeamList").empty();
			   $("#invitedTeamList").append(html);   
			   
			   },// end of success: function(json)---------------------------------------------------
				error: function(request, status, error){
					alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
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
						    <div id="profile" class="tab-pane fade in active">
						           <!-- 팀목록 -->
							       <div>
							        <table class="table table-hover">
							          <thead>
							            <tr>
							              <th>Invite Team Member</th>
							            </tr>
							          </thead>
							          <tbody id="invitedTeamList">
							              <%--  <c:if test="${teamName.size() > 0}">   
                                             <c:forEach var="teamName" items="${teamName}">
									            <tr>
									              <td style="width: 60%;"><span style="color: orange;">${teamName.TEAM_NAME}</span> 에서 초대하셨습니다.</td> 
									              <td style="width: 10%;">
									              <button type="button" class="btn btn-primary btn-sm "  name="approveDeny" value="승인" onclick="location.href='<%= request.getContextPath() %>/approveTeam.action?approveDeny=승인&fk_team_idx=${teamName.FK_TEAM_IDX}'" >승인</button>
									              </td>
									              <td style="width: 10%;">
									              <button type="button" class="btn btn-warning btn-sm "   name="approveDeny" value="거절" onclick="location.href='<%= request.getContextPath() %>/approveTeam.action?approveDeny=거절&fk_team_idx=${teamName.FK_TEAM_IDX}'">거절</button>
									              </td>
									                
									            </tr>							 
							                </c:forEach>
							         </c:if> --%>
							           </tbody>
							         </table> 
							       </div>
						              
						    
					        </div>
					  </div>

            </div>
         </div>
      </div>
   </div> 
</div>


<!-- <script src="resources/jihye/bootstrap4/popper.js"></script> 
<script src="resources/jihye/bootstrap4/bootstrap.min.js"></script>
<script src="resources/jihye/plugins/easing/easing.js"></script>
<script src="resources/jihye/plugins/parallax-js-master/parallax.min.js"></script>
<script src="resources/jihye/checkout_custom.js"></script> -->


