<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<style>

.grid-container {
  display: grid;
  /* grid-gap: 10px; */
 /*  background-color: #2196F3; */
  padding: 10px;
  width: 60%;
/*   border: 3px solid black; */
  margin:0 auto;
}
.grid-item {
 /*  background-color: rgba(255, 255, 255, 0.8); */
 /*  text-align: center; */
  padding: 20px;
  font-size: 20px;
/*   border: 3px solid red; */
}
/* 
.item1 {
  text-align: center; 
  grid-column: 1;  
  grid-row: 1 / span 2;
}
.item2 {
  grid-column: 2 / span 2;
  grid-row: 1 / span 2;
}
 */
/* .item3{
  grid-column: 2 / span 2;
  grid-row: 2 ;
} */
/* .item5 {
 text-align: center;
  grid-column: 1 / span 3;
  grid-row: 3;
} */

/* 
.avatar {
    vertical-align: middle;
    width: 200px;
    height: 200px;
    border-radius: 70%;
    
    border: 3px solid gold;
} */

 .abc {
      /*  border: 3px solid gold;  */
      padding-left:45%;
     padding-right:35%;   
}

/* 
.tablink {
     background-color: #555; 
    color: white;
    float: left;
     border: none; 
    outline: none;
    cursor: pointer;
     padding: 10px 16px; 
    font-size: 15px;
     width: 100%; 
}  */

.tab-content{
  padding-left:10%;
  padding-right:10%;
}

.activity {
    border-bottom: 1px solid #e2e4e6;
    margin-left: 40px;
    min-height: 32px;
    padding: 12px 0;
    position: relative;
   
}

/* .attach1{
     background: rgba(0,0,0,.5);
    bottom: 0;
    color: #fff;
    display: none;
    height: 40px;
    line-height: 30px;
    right: 0;
    width: 100%;
    z-index: 3;
}  */



</style>
<script type="text/javascript">
 
  $(document).ready(function(){
	  
	  /*
	     ==================== ★★★  !!! 중요 !!! ★★★  ====================
	      Ajax 로 구현되어진 내용물에서 선택자를 잡을때는 아래와 같이 해야한다   
	       
	      $(document).on("click", "선택자", function(){}); 으로 해야한다.
	    
      */ 		
      showTeamName();
	  showTeamImage();
	  $(document).on("keydown", "#team_name", function(event){
		  if(event.keyCode == 13) {
			  EditprofileEnd();
		  }
	  });
	  
	    
	  $(document).on("click", "#cancel", function(event){ 
			  showTeamName(); 
	  }); 	
	  
	  
	  $("#submitBtn").click(function(){
		   
		  var frm = document.fileFrm;
		  frm.action = "<%= request.getContextPath()%>/addFile.action";
		  frm.method = "POST";
		  frm.submit();
		  
	  });//end of submitBtn.click.function
	    
  });//end of document ready
  function showTeamImage(){
	  
	  var team_idxval = ${teamvo.team_idx}; 
	  var data_form = {team_idx : team_idxval}
	  
	  if(${sessionScope.loginuser  == "" || sessionScope.loginuser  == null }){
		  alert("you must login. go to login page..");
		  location.href="<%= request.getContextPath()%>/index.action";   
	  } 
	  else{
		  $.ajax({
		      url:"<%= request.getContextPath()%>/getTeamImage.action",
		      type:"GET",
		      data:data_form,
		      dataType:"JSON",
		      success:function(json){ 
		    	   
		    	  var html = ""; 
		    	  
		    	  $("#TeamImage").empty();
		    	  
		    	  html += "<table>";
		    	  html += "<tr> ";
		    	  
		    	  if(json.file_size == 0){  
		    	      html += " <a data-toggle='modal' href='#myModal' ><img src='<%= request.getContextPath() %>/resources/img/"+json.org_filename+"' class='img-circle' alt='' style='width:80px;height:80px; margin-left:220px; margin-right:0px; margin-top:25px;' /></a>";
		    	  }
		   		  
		    	  if(json.file_size != 0){
		    		  html += "<a data-toggle='modal' href='#myModal' ><img src='<%= request.getContextPath() %>/resources/files/"+json.server_filename+"' class='img-circle' alt='' style='width:80px;height:80px; margin-left:220px; margin-right:0px; margin-top:25px;' /></a>";
		    	      
		    	  }
		    	    
		    	  html += "</tr>";
		    	  html += "</table>";
		    	  
		    	  $("#TeamImage").html(html);
		    	  
		      },
		      error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		      }
			  		
	    }) //end of ajax  
	  }   
  }
  
  
  function showTeamName(){

	  var team_idx_val = ${teamvo.team_idx};
	  
	  var data_form = {team_idx : team_idx_val};
	  
	  if(${sessionScope.loginuser  == "" || sessionScope.loginuser  == null }){
		  alert("you must login. go to login page..");
		  location.href="<%= request.getContextPath()%>/index.action";   
	  } 
	  else{
	  
		  $.ajax({
		      url:"<%= request.getContextPath()%>/TeamInfoTop.action",
		      type:"GET",
		      data:data_form,
		      dataType:"JSON",
		      success:function(json){
		    	  
		    	  $("#infoTeam").empty();
		      
		    	  var html = "<span style='font-size: 25pt; font-weight: bold; color: black;'>"+json.team_name+"</span>&nbsp;&nbsp;";
		    	     if(json.team_visibility_status == 0){
		    	    	 html += "   <span style='color: red;' class='glyphicon glyphicon-eye-close'></span><span style='color:gray; font-size: 12pt;'>&nbsp;&nbsp;private</span>";
		    	     } 
		    	     else if(json.team_visibility_status == 1){
		    	         html += "   <span style='color: blue;' class='glyphicon glyphicon-eye-open'></span><span style='color:gray; font-size: 12pt;'>&nbsp;&nbsp;public</span>";
		     		 }
		    	      
		    	      html += "<div style='padding-top:20px;'>"; 
		    	      html += "	 <button type='button' class='btn' onClick='Editprofile();'><span class='glyphicon glyphicon-pencil'></span>&nbsp;&nbsp;&nbsp;<span style='font-size: 10pt; font-weight: bold; color:black;'>Edit Team Profile</span></button>";
		    	      html += "</div>";
		    	      
		         $("#infoTeam").html(html);    
		      },
		      error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		      }
			  		
	    }) //end of ajax
	  }
  }
  
  function Editprofile(){
	 
	  
	  $("#infoTeam").empty();
	  var html = " <form name='editFrm'>";
		  html += "  <div class='form-group' style='margin-top:10px; margin-left:0;'>"; 
		  html += "       <label for='team_name'><span style='color:black; font-weight:bold; font-size:13pt;'>Team Name:</span></label>";
		  html += "       <input type='text' class='form-control' id='team_name' placeholder='Enter Team Name' name='team_name'>";
		  html += "       <input type='hidden' id='team_idx' name='team_idx' value='${teamvo.team_idx}' />"
		  html += "  </div>";
		  html += " <button type='button' class='btn' id='editEnd' onClick='EditprofileEnd();'><span style='font-size: 10pt; font-weight: bold; color:black;'>Submit</span></button>";
		  html += " <button type='button' class='btn' id='cancel' ><span style='font-size: 10pt; font-weight: bold; color:black;'>Cancel</span></button>";
		  html += "</form>";
		  
	      
      $("#infoTeam").html(html);
  }  
  
  function EditprofileEnd(){
	 
    var frm = document.editFrm;
    var team_name = $("#team_name").val();
       
    var regexp_team_name = new RegExp(/^[A-Za-z0-9]{1,20}$/g); 
	    
	var bool = regexp_team_name.test(team_name);
      
  	if(bool== false || team_name.trim() == ""){
  		alert("Team name must includes A-Z or 0-9 and be 1 to 20");   
  		$("#team_name").val("");
  		$("#team_name").focus();
  		return; 
  	}  
  	
  	if(bool== true || team_name.trim() != ""){
  		 
  		frm.method="POST";
  		frm.action="<%= request.getContextPath()%>/EditEnd.action";
  		frm.submit(); 
  	} 
  	
  	
  }//end of ready
</script>

<div> 
  <div class="col-sm-3" id ="TeamImage" style="margin-top: 30pt; margin-left:280px;"> <!--grid-item  -->  
  </div>
  <div class="col-sm-4" id="infoTeam" style="margin-top: 45pt; margin-bottom:30pt;">
  </div> 
</div>

  
  <!-- Modal -->
  <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      
	      <div class="modal-content" style="display:inline-block; right: 600px; top: 100px; width: 400px; ">
	        <div class="modal-header">
	          <button type="button" class="close" data-dismiss="modal">&times;</button>
	          <h4 class="modal-title" style="color:black; font-weight: bold;">Set Team Image</h4>
	        </div>
	        <div class="modal-body">
	          <form name="fileFrm" enctype="multipart/form-data"> 
	           <input type="file" name="attach">
	           <input type="hidden" name="team_idx"       value="${teamvo.team_idx}">
	           <input type="hidden" name="admin_userid"   value="${teamvo.admin_userid}">
	           <input type="hidden" name="team_name"      value="${teamvo.team_name}">
	           <input type="hidden" name="team_delete_status"   value="${teamvo.team_delete_status}">
	           <input type="hidden" name="team_visibility_status"  value="${teamvo.team_visibility_status}">
	           <input type="hidden" name="org_filename" value="${teamvo.org_filename}">
	           <input type="hidden" name="server_filename" value="${teamvo.server_filename}">
	           <input type="hidden" name="file_size"  value="${teamvo.file_size}">
	          </form>
	        </div>
	        <div class="modal-footer">
	          <button type="button" class="btn btn-default" data-dismiss="modal" style="color:black; font-weight:bold;" id="submitBtn">Submit</button>
	          <button type="button" class="btn btn-default" data-dismiss="modal" style="color:black; font-weight:bold;">Close</button>
	        </div>
	      </div>
	    </div>
      </div>  
   
	  
   
 

 


    