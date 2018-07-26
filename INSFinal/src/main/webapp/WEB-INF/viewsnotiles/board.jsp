<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
.button {
    background-color: #e6e6e6;
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
</style>
<script type="text/javascript">
  $(document).ready(function(){
	   
	  displayProject("1");
	  
	  // NEW상품 더보기  버튼 클릭시 이벤트 등록 
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
	  
	  
  });//end of doucment.ready
  
  var length = 3;
  function displayProject(start){
 	 
	 var team_idx = ${team_idx};
 	 var form_data = {"start" : start 
 			          ,"len" : length
 			          ,"team_idx" : team_idx };
 	 // 시작값이 1이고 1부터 HIT상품을 3개만 보여주라는 뜻 
 	 
 	if(${sessionScope.loginuser  == "" || sessionScope.loginuser  == null }){
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
 		    		    	
 		    		    	 html += "<div align='left' style='display: inline-block; margin-left:30px;'>"
		    		  				 // + "<a href='/MyMVC/prodView.do?pnum="+entry.pnum+"'>" 
		    		  				 // + "<img width='120px;' height='130px;' src='images/"+entry.pimage1+"'>"
		    		  				 //  + "</a>"	project_idx, fk_team_idx, project_name, project_visibility_st, project_delete_status, fk_project_image_idx
	    		  			 html += "<br/><button type='button' class='button'>"+entry.project_name+"</button>";    					   
	    		  			 html += "<input type='hidden' name='project_idx' value='"+entry.project_idx+"'>";
	    		  			 html += "<br/><br/></div>"; 
	    		  				      
	    		  		     $("#totalCount").text(entry.totalCount);
 		    		    });//end of each
 		    	   }//end of if  
 		    	       html += "<div style='clear: both;'>&nbsp;</div>";
 		    	       	
 		    	       	// === *** HIT 상품 결과를 출력해주기 *** ===
 		    	        $("#displayResult").append(html);
 		    	         
 		    	        $("#btnMore").val(parseInt(start) + length );
 		    	        
 			    	     if($("#totalCount").text() <= 3 ){
 			    			 $("#btnMore").hide(); 
 			    		 }	   
 			    		 else{
 			    			 $("#btnMore").show();
 			    			 $("#btnMore").text("More");
 			    		 }
 			    	      
 		    	       	$("#count").text(parseInt($("#count").text()) + json.length ); 
 		    	       	// 변수를 읽어올때는 $()로 사용한다. 없어도 상관없지만 xml에서 읽어온 객체변수인것을 표시하기위해 사용 
 		    	       	
 		    	       	// === *** 더보기 버튼을 계속해서 눌러서 count 와 totalHITCount 가 일치하는 경우 (=더이상 볼 상품이 없는경우) 
 		    	       	//         버튼내용을 처음으로 라고 변경하고 변경된 버튼을 클릭 시 맨 처음 상품3개만 보여지도록 한다.(=countHIT를 0으로 초기화)*** ===
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
 	 
  }// end of displayNEWAppend -------------------------------

</script>
</head>
<body> 

  <div style="width: 100%; margin-top: 60px; margin-bottom: 30px;">
	 <div style="display: block; margin-left:430px; margin-bottom:35px;">
 	   <button type="button" class="button">Create a new board</button>
 	 </div> 
	 <div id="displayResult" style="margin-left: 400px; border: 0px solid gray;"> 
 	 </div>	    		   
	<div style="margin-top: 10px; margin-left:730px; margin-bottom:20px;">
	  <button type="button" id="btnMore" class="btn" style="color:black; font-weight:bold;" value="">More</button>
	  <span id="totalCount" hidden>${totalCount}</span> <!-- 총 프로젝트 갯수(totalCOUNT)보다 많아지면 더보기버튼을 안보여주기 위해 사용 -->
	  <span id="count" hidden>0</span> <!-- 현재 내가 프로젝트를 몇개만큼 받아왔는지 알아보기 위해  count변수사용 -->
	</div>
	
 </div>
</body>
</html>