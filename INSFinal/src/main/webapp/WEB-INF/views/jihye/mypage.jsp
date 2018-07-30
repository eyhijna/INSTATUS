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
      
		       <div>
		        <div style="display: block; ">
		           <c:if test="${teamList.size() <1}">
		           
		                  <span style="font-size: 15px; ">등록하신 팀이 없습니다.</span>
		           </c:if>  
			       <c:if test="${teamList.size() > 0}">  
			          <c:forEach var="teamvo" items="${teamList}">
			             
			           <c:if test="${teamvo.server_filename == '0'}">
			           <button type="button" class="button btnTeam" id="btnTeamId" style="margin-right: 50px;margin-bottom: 30px;  background-image: url('<%= request.getContextPath() %>/resources/images/04148_wingsofangelsnorthernlightsoniceland_1920x1080.jpg');" onclick="location.href='<%= request.getContextPath()%>/showTeam.action?team_idx=${teamvo.team_idx}'">${teamvo.team_name}</br>
			          <c:if test="${teamvo.team_visibility_status == 0}">
		    	    	 <span style='color: #ff5252;' class='glyphicon glyphicon-eye-close'></span><span style='font-size: 12pt;'>&nbsp;&nbsp;private</span>
		    	      </c:if>
		    	       <c:if test="${teamvo.team_visibility_status == 1}">
		    	    	  <span style='color: blue;' class='glyphicon glyphicon-eye-open'></span><span style=' font-size: 12pt;'>&nbsp;&nbsp;public</span>
		    	      </c:if>
		    	      </button>
				 	   </c:if>
				 	   
				 	    <c:if test="${teamvo.server_filename != 0 && teamvo.team_visibility_status == 1}">
				 	   <button type="button" class="button btnTeam" id="btnTeamId" style="margin-right: 50px;margin-bottom: 30px;  background-image: url('<%= request.getContextPath() %>/resources/files/${teamvo.server_filename}');" onclick="location.href='<%= request.getContextPath()%>/showTeam.action?team_idx=${teamvo.team_idx}'">${teamvo.team_name}</br>
				 	    <c:if test="${teamvo.team_visibility_status == 0}">
		    	    	 <span style='color: #ff5252;' class='glyphicon glyphicon-eye-close'></span><span style=' font-size: 12pt;'>&nbsp;&nbsp;private</span>
		    	      </c:if>
		    	       <c:if test="${teamvo.team_visibility_status == 1}">
		    	    	  <span style='color: blue;' class='glyphicon glyphicon-eye-open'></span><span style=' font-size: 12pt;'>&nbsp;&nbsp;public</span>
		    	      </c:if>
				 	   </button>
	                   </c:if>
	                   
	                   </c:forEach>
			       </c:if>
		       </div> 
		       </div>
							
	
		    </div>
        </div>
    </div>
</div>
        
   

