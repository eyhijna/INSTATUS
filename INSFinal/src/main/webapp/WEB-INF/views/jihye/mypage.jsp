<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>      
    
<jsp:include page="top.jsp" /> 

<style>
 .mypageA {
    text-decoration: none;
    display: inline-block;
    padding: 8px 16px;
}
 
.mypageA:hover {
    background-color: #ddd;
    color: black;
}


.button {
 
    background-color: #e6e6e6;
    border: 0px solid gray; 
    color:white;
    height : 80px;
    width : 250px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px; 
    cursor: pointer;

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

#btnTeamId{
   
     position: relative; 
    
    background-size: 250px 80px;
    /*  opacity: 0.7; */
     background-repeat: no reqpeat;
}

</style>


<!-- <script type="text/javascript">

$(document).ready(function(){
	
  var switchVal = null
  $(".JJ").click(function() {
      
      if (this.checked == false){
        alert("체크해제");
        switchVal = 1;
        
        console.log(switchVal);
        
        var frm = document.switchFrm;
        
        frm.switchVal.value = switchVal;
        frm.method="post";
        frm.action="switchMyRecord.action"
        frm.submit();
        
      }else{
        alert("체크");
        switchVal = 0;
        console.log(switchVal);
        
        var frm = document.switchFrm;
        
        frm.switchVal.value = switchVal;
        frm.method="post";
        frm.action="switchMyRecord.action"
        frm.submit();
        
        
     //   swichMyRecord(switchVal);
        
      }
   });// end of $(".checklist").click()
  
 }); 

function swichMyRecord(switchVal){
	         	        
	  
	    	
	    	form_data = {"switchVal" : switchVal};
	    	
	    	$.ajax({
	    		url: "swichMyRecordJSON.action",
	    		type: "post",
	    		data : form_data,
	    		dataType: "JSON",
	    		success: function(json){	    			
	    			alert("성공");	    			
	    	  },// end of success: function(json)---------------------------------------------------
				error: function(request, status, error){
					alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
				}	    	
	    	     
	    	});



}   

 
</script> -->
 
<!--  <div class="super_container"> 
   <div class="cart_container" style="padding-top: 20px;">   -->
       <div class="container" > 
         <div class="row" >
            <div class="col" > 

				 	  <div class="tab-content"> 
				 	   </br>
				 	  <span style="font-weight:bold; font-size:25px; color: black;">List of Team</span>
				
				 	  </br>
				 	  </br>
				 	  </br>
						   <%--   <div id="profile" class="tab-pane fade in active">  
						           <!-- 팀목록 -->
							       <div>
							         <table class="table table-hover"> 
							          <thead>
							            <tr>
							              <th style="color:black; font-size: 15pt;">Teams</th>
							            </tr>
							          </thead>
							          <tbody>
							          <c:if test="${teamList.size() <1 }">						         					        
							              <td style="text-align: center;" colspan="5">${sessionScope.loginuser.name}님이 소속된 팀이 없습니다.</td>
							            </c:if> 
							              <c:if test="${teamList.size() > 0}">  
                                             <c:forEach var="teamvo" items="${teamList}">
									            <tr>
									              <td style="padding: 0px;"><a href="<%= request.getContextPath()%>/showTeam.action?team_idx=${teamvo.team_idx}" class="mypageA">${teamvo.team_name}</a></td>      
									            </tr>
							 
							                </c:forEach>
							             </c:if> 
							           </tbody>
							         </table> 
							       </div> --%>
							       
							       <!-- ///////////////////////////////////////////////////////// -->
							       <div>
							        <div style="display: block; ">
							         <c:if test="${teamList.size() > 0}">  
							           <c:forEach var="teamvo" items="${teamList}">
							       
								 	   <button type="button" class="button btnTeam" id="btnTeamId" style="margin-right: 50px;margin-bottom: 30px;  background-image: url('<%= request.getContextPath() %>/resources/files/${teamvo.server_filename}');" onclick="location.href='<%= request.getContextPath()%>/showTeam.action?team_idx=${teamvo.team_idx}'">${teamvo.team_name}</button>
                                    </c:forEach>
							       </c:if>
							       </div> 
							       </div>
							
	<%-- 					          <!-- activity 기록 목록 -->	
						   					        					          
							      <div>
							        <table class="table table-hover">
							          <thead>						         
							            <tr>
							              <th colspan= 1; style="color:black; font-size: 15pt;">Activity
									     </th>
									    
									    <c:if test="${ins_personal_alarm == 0}">
									      <th colspan= 4; id="switchJihye">
									      <label class="switch" >									    
											  <input type="checkbox" data-toggle="toggle" data-size="small" class="JJ" id="JJ" checked>																	 
											  <span class="slider round"></span>
									      </label>
									      </th>
									    </c:if> 
									      <c:if test="${ins_personal_alarm == 1}">
									      <th colspan= 4; id="switchJihye">
									      <label class="switch" >									    
											  <input type="checkbox" data-toggle="toggle" data-size="small" class="JJ" id="JJ" >																	 
											  <span class="slider round"></span>
									      </label>
									      </th>
									    </c:if>  		
														      		
							            </tr>
							            
							          </thead>
							          <c:if test="${myRecordList.size() <1 }">						         					        
							              <td style="text-align: center;" colspan="5">${sessionScope.loginuser.name}님의 개인 활동 기록이 없습니다.</td>
							            </c:if>  
							        <c:if test="${myRecordList.size() > 0}"> 
							           
							          <thead>
							              <tr >
							                 <th style="text-align: center;">프로젝트</th>
							                 <th style="text-align: center;">리스트</th>
							                 <th style="text-align: center;">카드</th>
							                 <th style="text-align: center;">내용</th>
							                 <th style="text-align: center;" >기록시간</th>
							              </tr>
							            </thead>         
							            <tbody id="recordList">
							              <c:forEach var="map" items="${myRecordList}">
							            <tr>
							            	   <td style="text-align: center; padding: 0px;"><a href="#team1" class="mypageA">${map.PROJECT_NAME}</a></td> 
								              <td style="text-align: center; padding: 0px;"><a href="#team1" class="mypageA">${map.LIST_NAME}</a></td>
								              <td style="text-align: center; padding: 0px;"><a href="#team1" class="mypageA">${map.CARD_TITLE}</a></td>
								              <td style="text-align: center; padding: 0px;" ><a href="#team1" class="mypageA">${map.RECORD_DML_STATUS}</a></td> 
								              <td style="text-align: center;padding: 0px; "><a href="#team2" class="mypageA">${map.PROJECT_RECORD_TIME}</a></td>						              					           								             						           
							            </tr>
							             </c:forEach> 
							                </c:if>  
							         </tbody>					
							         </table>  --%>
							  <%--        
							           #117. 페이지바 보여주기
								   <div align="center" style="width: 70%; margin-top: 20px;  margin-left: 100px;  margin-right: auto;">
								       ${pagebar}
								   </div>
						 --%>
							               
					        </div>
					  </div>
                </div>
             </div>
         </div>
   
<%-- 
<form name = "switchFrm">
<input type="hidden" id="switchVal"  name="switchVal">
<input type="hidden" value="${ins_personal_alarm}" >
</form> --%>
