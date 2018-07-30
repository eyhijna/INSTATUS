<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
 <!--  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"> -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<script type="text/javascript">
  
   $(document).ready(function(){
	    
	   joinMemberList("1"); // 가입신청한 멤버들을 불러들임  
	   
   });
    
    
   $("#btnMore").bind("click", function(){
	         
		   if($(this).text() == "Back"){   
			    
		      $("#joinList").empty();
		         joinMemberList("1");
		         $(this).text("More");
		   }
		   else{
			     joinMemberList($(this).val());// 버튼의 value값을 넣는다 
		   }
		   
	});//end of btnMore.bind(click)
	
	
   $(document).on("click", "#acceptBtn", function(event){ 
	    var useridval = $(this).val();
	    $("#userid").val(useridval); 
	    
        var frm = document.viewFrm;
        frm.method="POST";
        frm.action="<%= request.getContextPath()%>/acceptMember.action";
        frm.submit(); 
   });
   
   $(document).on("click", "#declineBtn", function(event){
	     
	    var useridval = $(this).val();
	    $("#userid").val(useridval); 
	    
	    var frm = document.viewFrm;
        frm.method="POST";
        frm.action="<%= request.getContextPath()%>/declineMember.action";
        frm.submit(); 
  });
   
   var length = 10; 
   
   function joinMemberList(start){ 
	            
	   var team_idx = ${tvo.team_idx};
	       
	   var form_data = {"team_idx" : team_idx
			            ,"start" : start
			            ,"len" : length};
	   
	   if(${sessionScope.loginuser.userid  == "" || sessionScope.loginuser.userid  == null }){
			  alert("you must login. go to login page..");
			  location.href="<%= request.getContextPath()%>/index.action";   
	    } 
	   else{
		   $.ajax({
			      url:"<%= request.getContextPath()%>/joinMemberListJSON.action",
		  	      type:"GET",  
		  	      dataType:"JSON",
		  	      data: form_data,
		  	      success:function(json){
		  	    	  
		  	    	 var html = "  <tbody>"; 
						 
		  	    	 
		  	    	 if(json.length > 0){
		  	    		 
		  	    		 $.each(json, function(entryindex, entry){
		  	    			  
		  	    		     html += "<tr>";
			  	    	     html += "  <td style='padding-left:20px; padding-top:16px;'>";
			  	    	     html += "    <span style='font-weight:bold; color:black; '>"+entry.nickname+"</span>("+entry.userid+")님이 가입요청을 하셨습니다.";
			  	    	     html += "  </td>";
			  	    	     
			  	    	     html += "  <td style='padding-left:10px; padding-top:10px;'>";
			  	    	     html += "    <button type='button' class='reqmember btn' id='acceptBtn' value='"+entry.userid+"'  style='margin-left:230px; color:black; font-weight:bold; display:center;'>Accept</button>";
			  	    	     html += "    <button type='button' class='reqmember btn' id='declineBtn' value='"+entry.userid+"' style='margin-left:7px; color:black; font-weight:bold;'>Decline</button>";
			  	    	     html += "  </td>";
			  	    	     html += "</tr>"; 
			  	    	     
			  	    	     $("#totalCount").text(entry.totalCount);
		  	    		 });//end of each  
		  	    		 
		  	    	 }
		  	    	 else{
			  	    	   
		  	    		 html += "<tr>";
		  	    	     html += "  <td style='size:20pt;  '>";
		  	    	     html += "   &nbsp;-&nbsp;&nbsp;<span style='font-weight:bold;'>There is no request.</span>";
		  	    	     html += "  </td>";
		  	    	     html += "</tr>"; 
		  	    	  }
		  	    	 
		  	    	 html += "    </tbody>";
		  	    	 
		  	    	 $("#joinList").append(html);
		  	    	 
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
	   
   }
 
   function changeView(){ // 버튼을 누르면 team_visibility_status 를 바뀌게 한다.
    	 
    	var visibility_status =  ${tvo.team_visibility_status};
    	if(visibility_status == 1){
    		visibility_status = 0;
    	}
    	else if(visibility_status == 0){
    		visibility_status = 1;
    	}
    	
    	var frm = document.viewFrm;
    	frm.team_visibility_status.value = visibility_status;
    	// alert($("#team_visibility_status").val()); 
    	 
        frm.action="<%= request.getContextPath()%>/changeView.action";
        frm.method="POST";
        frm.submit();
    }
   
   function breakTeam(){
	   if( confirm("팀 해체를 하시겠습니까?")){
		   
		   var frm = document.viewFrm; 
		   
	       frm.action="<%= request.getContextPath()%>/breakTeam.action";
	       frm.method="POST";
	       frm.submit(); 
	   }
	   else{
		   return;
	   }
   }

</script>
<body>   
	<div style="width:780px; margin-top: 30px;" class="container"> 
	
	 <form name="viewFrm">
	  <table class="table">
	    <thead>
	      <tr>
	        <th style="color:black; font-size: 15pt;">Team Visibility</th> 
	      </tr>
	    </thead>
	    <tbody>
	      <tr>
	        <c:if test="${tvo.team_visibility_status == 0 }">
	           <td style="padding-top:12px; padding-bottom:11px;">
	             <span style="color: #ff5252" class="glyphicon glyphicon-eye-close"></span>&nbsp;&nbsp;<span style="font-weight: bold; color:black;">Private - </span>This team is private. It's not indexed or visible to those outside the team.
	             <button type="button" class="btn" onClick="changeView();" style="margin-left:45px;"><span style="font-weight: bold; color:black;">Change to public</span></button>
	           </td> 
	        </c:if>
	        <c:if test="${tvo.team_visibility_status == 1 }">
	           <td style="padding-top:22px; padding-bottom:13px;">
	             <span style='color: blue;' class='glyphicon glyphicon-eye-open'></span>&nbsp;&nbsp;<span style="font-weight: bold; color:black;">Public - </span>This team is public. It's visible to anyone with the link and will show up in search engines like Google. Only those invited to the team can add and edit team boards.
	             <c:if test="${tvo.admin_userid == (sessionScope.loginuser).userid }">
	             <button type="button" class="btn" onClick="changeView();" style="margin-left:220px; margin-top:10px;"><span style="font-weight: bold; color:black;">Change to private</span></button>
	             </c:if>
	           </td> 
	        </c:if> 
	      </tr> 
	      
	      <c:if test="${tvo.admin_userid == sessionScope.loginuser.userid }">
	          <tr>
		         <th style="color:black; font-size: 15pt; padding-top: 50px;">Break up the team</th> 
		      </tr>
		      
		      <tr>
		         <td style="padding-top:12px; padding-bottom:11px;">
		           <span class="glyphicon glyphicon-remove-sign" style="color:#ff5252;"></span>&nbsp;&nbsp;<span style="font-weight: bold; color:black;">Do you want to break up the team?</span>
		           <button type="button" class="btn" onClick="breakTeam();" style="margin-left:365px;"><span style="font-weight: bold; color:black;">Yes</span></button>
		         </td>
		      </tr>
	      </c:if>
	      
	      <c:if test="${tvo.admin_userid == (sessionScope.loginuser).userid}">
		      <tr>
		         <th style="color:black; font-size: 15pt; padding-top: 50px;">Alarm</th> 
		      </tr>
		      
		      <tr>
		         <td style="padding-top:19px; padding-bottom:0px;">
		           <span class="glyphicon glyphicon-check" style="color:#ff5252"></span>&nbsp;&nbsp;<span style="font-weight: bold; color:black;">Who wants to join the team</span>
		         </td>
		      </tr>
		  </c:if>
		 </tbody>
		</table>
		
		  <input type="hidden" name="team_visibility_status" id="team_visibility_status"/>  
	      <input type="hidden" name="team_idx" id="team_idx" value="${tvo.team_idx}"/> 
	      <input type="hidden" name="userid" id="userid" value=""/>   
	   </form>  
	      
		  <c:if test="${tvo.admin_userid == sessionScope.loginuser.userid}">     
			<table id="joinList" class="table"> 
			</table> 
	 
		    <c:if test="${joinMemberCnt > 0 }">  
		     <div style="margin-left:300px; margin-bottom:20px;">
		      <button type="button" class="btn" id="btnMore" value="" style="color:black; font-weight:bold;">More</button>
		      <span id="totalCount" hidden>${totalCount}</span> <!-- 총 멤버수보다 많아지면 더보기버튼을 안보여주기 위해 사용 -->
		      <span id="count" hidden>0</span> <!-- 현재 내가 멤버수를 몇개만큼 받아왔는지 알아보기 위해  count변수사용 -->
	         </div>
	        </c:if> 
	        
	     </c:if>		  
	   <div>
	   </div>
	</div> 
	
	    
</body>
</html>