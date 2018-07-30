<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<jsp:include page="top.jsp" /> 
<style>
  

</style>  
<script type="text/javascript">
   
    $(document).ready(function(){
    	if(${msg != null}){ 
    		alert("${msg}");
    	} 
     	
    	if(${nav != null && nav == 1}){
    		board();
        }
    	else if(${nav != null && nav == 2}){
    		member();
    	}
    	else if(${nav != null && nav == 3}){
    		setting();
    	}
    
    });
    
    function board(){ // 보드버튼을 눌렀을때 
    	
        var team_idx_val = ${team_idx};
    	
    	var form_data = {team_idx : team_idx_val };
    	
    	if(${sessionScope.loginuser.userid  == "" || sessionScope.loginuser.userid  == null }){
  		  alert("you must login. go to login page..");
  		  location.href="<%= request.getContextPath()%>/index.action";   
  	    } 
  	    else{
    		  $.ajax({
    	
    		
	          url:"<%= request.getContextPath()%>/teamBoard.action",
	  	      type:"GET", 
	  	      data:form_data,
	  	      dataType:"HTML",
	  	      success:function(html){
	  	    	     $("#content").html(html);
	  	      },
	  	      error: function(request, status, error){
	  				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	  	      }
	    		
  		
  		
  	           })//end of ajax 
  	      } 
    }
    
    
    function setting(){ // 세팅버튼을 눌렀을때 
    	
    	var team_idx_val = ${team_idx};
    	
    	var form_data = {team_idx : team_idx_val };
    	
    	if(${sessionScope.loginuser.userid  == "" || sessionScope.loginuser.userid  == null }){
	  		  alert("you must login. go to login page..");
	  		  location.href="<%= request.getContextPath()%>/index.action";   
  	    }  
  	    else{
	    	$.ajax({
	    		
		          url:"<%= request.getContextPath()%>/teamSetting.action",
		  	      type:"GET", 
		  	      data:form_data,
		  	      dataType:"HTML",
		  	      success:function(html){
		  	    	     $("#content").html(html);
		  	      },
		  	      error: function(request, status, error){
		  				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		  	      }
		    		
	    		
	    		
	    	})//end of ajax 
  	    }
    }
    
	function member(){ // 멤버버튼을 눌렀을때 
    	
    	var team_idx_val = ${team_idx};
    	
    	var form_data = {team_idx : team_idx_val };
    	
    	if(${sessionScope.loginuser.userid  == "" || sessionScope.loginuser.userid  == null }){
	  		  alert("you must login. go to login page..");
	  		  location.href="<%= request.getContextPath()%>/index.action";   
  	    }  
  	    else{
	    	$.ajax({
	    		
		          url:"<%= request.getContextPath()%>/teamMember.action",
		  	      type:"GET", 
		  	      data:form_data,
		  	      dataType:"HTML",
		  	      success:function(html){
		  	    	     $("#content").html(html);
		  	      },
		  	      error: function(request, status, error){
		  				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		  	      }
		    		
	    		
	    		
	    	})//end of ajax 
  	    }
    }
</script>


    <div class="navtab" align="center">        
        <ul class="nav nav-tabs abc"> 
		       <li><a data-toggle="tab1" onClick="board();"><span style="font-weight: bold; color: black;">Board</span></a></li>
		       <li><a data-toggle="tab1" onClick="member();"><span style="font-weight: bold; color: black;">Member</span></a></li>
		  <c:forEach items="${memberList}" var="member">
             <c:if test="${(sessionScope.loginuser).userid == member.team_userid && ( mystatus == 1 || mystatus == 2 )}">   
		       <li><a data-toggle="tab1" onClick="setting();"><span style="font-weight: bold; color: black;">Setting & Alarm</span></a></li>    
	         </c:if>
	      </c:forEach>
	    </ul> 
   </div>     
   
   <form name="teamFrm">
	 <div>
	   <input type="hidden" id="team_idx" name="team_idx" value="${team_idx}"/>
	 </div>
   </form>
 
   <div id="content">
   </div>





