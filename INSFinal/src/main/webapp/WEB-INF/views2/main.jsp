<!DOCTYPE html>
<html>
<head> 
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1"> 
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">


<style>
body {
    font-family: "Lato", sans-serif;
} 
.sidenav {
    height: 100%;
    width: 280px;
    position: fixed;
    z-index: 1;
    top: 0; 
    background-color: #ffffff;
    overflow-x: hidden;
    padding-top: 20px; 
}

.sidenav a {
    padding: 20px 8px 6px 16px;
    text-decoration: none;
    font-size: 20px;
    color: #ffc61a;
    display: block;
}

.sidenav a:hover {
    color: #1aa3ff;
}

.main {
    margin-left: 300px; /* Same as the width of the sidenav */
    font-size: 20px; /* Increased text to enable scrolling */
    padding: 18px 10px; 
}

.btn1 {border: solid 0px red;
       text-align: left; }

@media screen and (max-height: 450px) {
    .sidenav {padding-top: 15px;}
    .sidenav a {font-size: 18px;}
}
</style>
<script type="text/javascript">
    $(document).ready(function(){
    	 
    	$("#new_team_name").keydown(function(key) {
            if (key.keyCode == 13) {
               $("#submitBtn").click();
            }
        });
    	
    	showTeamList();
    	
    });//end of document.ready
  
    function createTeam(){
    	
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
      
    function showTeamList(){
      
        if(${sessionScope.loginuser  == "" || sessionScope.loginuser  == null }){
			  alert("you must login. go to login page..");
			  location.href="<%= request.getContextPath()%>/index.action";   
		} 
        else{
	        $.ajax({ 
	    		
			      url:"<%= request.getContextPath()%>/showTeamList.action",
		  	      type:"GET",  
		  	      dataType:"JSON",
		  	      success:function(json){
		  	    	  
		  	    	     $("#content").empty();
		  	    	     
		  	    	     var html = "";
		  	    	         html +=  "<div class='btn-group-vertical'>";
		  	    	     $.each(json, function(entryindex, entry){   
		  	    	    	  
		  	    	          html +=  "<button type='button' id='goTeamInfo' class='btn btn-primary btn1' style='background-color: white; color:black;' onClick='teamByIdx("+entry.team_idx+");'><span class='glyphicon glyphicon-leaf' style='color:lightgray;'/>&nbsp;&nbsp;"+entry.team_name+"</button>";
		  	    	          
		  	    	     });//end of each 
		  	    	     
						 html += "   </div>";
						 
						 $("#content").html(html);
		  	    	     
		  	      },
		  	      error: function(request, status, error){
		  				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		  	      } 
	    		
	    	}); //end of ajax 
        }	
    }
    
    
    function teamByIdx(team_idx){
             
       var frm = document.infoFrm;
       frm.team_idx.value = team_idx; 
       
       frm.method = "GET";
       frm.action = "<%= request.getContextPath()%>/showTeam.action";
       frm.submit();
    }
    
</script>
</head>
<body>

<div class="sidenav" align="right" style="padding-right: 15px;">
  <a href="#about">About</a>
  <a href="#services">Services</a>
  <a href="#clients">Clients</a> 
  <a>Team&nbsp;&nbsp;<span class="badge">${countTeam}</span></a>
  
  <div id="content">
  </div>
  
  <div id="teamList"></div>
 
  
  <a href="#myModal" data-toggle="modal"><span class="glyphicon glyphicon-plus">&nbsp;Create a team</span></a> 
 
  
</div> 

<div class="main" style="padding-top: 50px;">
  <h2>index</h2> 
  
	  <form name="infoFrm"> 
		<input type="hidden" name="team_idx" id="team_idx"/>
		<input type="hidden" name="nav" id="nav"/>    
	  </form> 
	
</div>
 

  <!-- =================== Modal ======================== -->
   <div class="modal fade" id="myModal" role="dialog" >
    <div class="modal-dialog">
    
      <div class="modal-content" style="display:inline-block; right: 600px; top: 100px; width: 400px; " >
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
  
 
   
     
</body>
</html> 
