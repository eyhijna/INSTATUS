<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">


<title>project</title>

<style type="text/css">
 body {
	    font-family: "Lato", sans-serif;
	}
	
	.sidenav {
	    height: 100%;
	    width: 0;
	    position: fixed;
	    z-index: 2; 
	    top: 0;
	    left: 0;
	    background-color: #111;
	    overflow-x: hidden;
	    transition: 0.5s;
	    padding-top: 100px;
	}
	
	.sidenav span {
	    padding: 8px 8px 8px 32px;
	    text-decoration: none;
	    font-size: 25px;
	    color: #818181;
	    display: block;
	    transition: 0.3s;
	    /* cursor: pointer; */
	}
	
	.sidenav span:hover {
	    color: #f1f1f1;
	}
	
	.sidenav .closebtn {
	    position: absolute;
	    top: 0;
	    right: 25px;
	    font-size: 36px;
	    margin-left: 50px;
	}
	
	
	@media screen and (max-height: 450px) {
	  .sidenav {padding-top: 15px;}
	  .sidenav a {font-size: 15px;} 
	}
	

	table, td {
		/* border: 1px solid gray; */
		/* width: 50px; */
	}
	
	/* td {
		border: 1px solid red; 
	} */
	
	.imgtd {
		width: 100px;
		/* border: 1px solid green; */
		
	}
	
	#sel1 {
		width: 150px;	}
	
	.btnActivity{
		width:24%;
		height:30px;
		background-color: #00a0df; 
		color: white;
		font-size: 5pt;
		margin-bottom: 20px;
	}
	
	


</style>

</head>



<script type="text/javascript">
	
	$(document).ready(function(){
		
		/* Activity(); */
		
		
		
	});
		
	
	function openNav() {
	
	    document.getElementById("mySidenav").style.width = "400px";
	    
	   	// Activity();  
	    selVal(); 
	   
	}

	function openNav2() {
	    document.getElementById("mySidesearch").style.width = "400px";
	   /*  document.getElementById("mySidenav").style.width = "0"; */
	}
	
	
	function openNav3(){
		document.getElementById("mySideactivity").style.width = "400px";
		
		selVal();
		// sel2Val();
		// Activity(); 
		/* $("#cardEditbtn").click(){
			Activity();
		}
		$("#cardDeletebtn").click(){
			Activity();
		}
		
		$("#cardAddbtn").click(){
			Activity();
		}
		$("#listCreatebtn").click(){
			Activity();
		} */
		
	}
	
	function closeNav() {
	    document.getElementById("mySidenav").style.width = "0";
	    document.getElementById("mySidesearch").style.width = "0";
	}

	function closeNav2() {
	    document.getElementById("mySidesearch").style.width = "0";
	    document.getElementById("mySidenav").style.width = "400px";
	}
	
	function closeNav3() {
	    document.getElementById("mySideactivity").style.width = "0";
	    /* document.getElementById("mySidenav").style.width = "400px"; */
	}
	

	
	function leaveProject(){
		
		var fk_project_idx = "31";
		
		var frm = document.project_idxFrm;
		frm.fk_project_idx.value = fk_project_idx;// input 의 value 값에 fk_projcet_idx를 받아 입력해야 한다.
				
		frm.method = "GET";
		frm.action = "<%= request.getContextPath() %>/leaveProject.action";
		frm.submit();
		
	}

	
	function deleteProject(){
		
		var fk_project_idx = "31";
		
		var frm = document.project_idxFrm;
		frm.fk_project_idx.value = fk_project_idx;// input 의 value 값에 fk_projcet_idx를 받아 입력해야 한다.
				
		frm.method = "GET";
		frm.action = "<%= request.getContextPath() %>/deleteProject.action";
		frm.submit();
		
	}
	
	function Activity(val){
					
		// alert("실행 확인용"); 
		alert("확인용 >>>>> " + val);
		
		var form_data1 = {fk_project_idx: "3", /* $("#fk_project_idx").val() */
				          sel1Val: val}
		
		
		
		$.ajax({
			
			url: "<%= request.getContextPath()%>/projectRecordView.action",
			type: "get",
			data: form_data1,
			dataType: "json",
			success: function(json){
				
				$("#activitylist").empty();
				
				$("#projectRecordListMoreTB").empty();
						
				var html = "";
				
				if(json.length > 0){
					
					$.each(json, function(entryIndex, entry){
						
						if(entryIndex < 10){ 
							 
							html += "<tr>";
							html += "<td rowspan='3' class='imgtd' style='size: 10px;'><img src='<%=request.getContextPath()%>/resources/img/avatar1.jpg'";
							html += " alt='Avatar' class='avatar' /></td>";
							html += "<td style='font-weight: bold;'>"+entry.userid+"&nbsp;&nbsp;"+entry.record_dml_status+"</td>";
							html += "</tr>";
							html += "<tr>";
							html += "<td  style='font-size: 8pt;'>&nbsp;"+entry.project_record_time+"</td>";
							html += "</tr>";
							html += "<tr>";
							html += "<td style='font-size: 8pt; color: #b3b3b3;'>"+entry.card_title+" in "+entry.list_name+"</td>"; 
							html += "</tr>";
							html += "<tr>";
							html += "<td colspan='2' style='border: 1px solid #fed189;'></td>";
							html += "</tr>";
							
						 }
						
						
					});
					
					$("#projectRecordListTB").html(html);
					
					 if(json.length > 10 ){  
						
						html += "<tr style='height: 50px; text-align:center; border: 1px solid red;' >";
						html += "<td colspan='2' style='padding-top: 15px;'>";
						/* html += "<a style='cursor: pointer; color: #00a0df;' href='javascript:void(0);'>view all activity</a></td>"; */
						html += "<a href='javascript:void(0);' id='clickFUN'>클릭확인</a></td>"
						html += "</tr>";
						
				 	 } 
					
					$("#projectRecordListTB").html(html);
					
					$("#activitylist").html(html);
					
					
					$("#clickFUN").click(function(){
						
						alert("클릭확인");
					});
					<%-- 
					$("#viewallactivity").click(function(){
						
						var html2 = "";
						
						alert("viewallactivity 성공");
						
						openNav3();
						
						$.each(json, function(entryIndex, entry){
														
							html2 += "<tr>";
							html2 += "<td rowspan='3' class='imgtd' style='size: 10px;'><img src='<%=request.getContextPath()%>/resources/img/avatar1.jpg'";
							html2 += " alt='Avatar' class='avatar' /></td>";
							html2 += "<td style='font-weight: bold;'>"+entry.userid+"&nbsp;&nbsp;"+entry.record_dml_status+"</td>";
							html2 += "</tr>";
							html2 += "<tr>";
							html2 += "<td  style='font-size: 8pt;'>&nbsp;"+entry.project_record_time+"</td>";
							html2 += "</tr>";
							html2 += "<tr>";
							html2 += "<td style='font-size: 8pt; color: #b3b3b3;'>"+entry.card_title+" in "+entry.list_name+"</td>"; 
							html2 += "</tr>";
							html2 += "<tr>";
							html2 += "<td colspan='2' style='border: 1px solid #fed189;'></td>";
							html2 += "</tr>";
						
							
							$("#projectRecordListMoreTB").html(html2);
						
						}); // end of $.each(json)------------------------------------------------------------ 
					 							
							$("#activitylistMore").html(html2);
												
					});// end of $("#viewallactivity1").click()------------------------------------------------
					 --%>
					
					
				}
				else{
										
					html = "<h2>프로젝트 내 활동이 없습니다.</h2>";
					
				}
				
					
				$("#activitylist").html(html);
				
			},
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
		    }
			
		});
		
	}
	
	
	function searchINproject(){
		
		var form_data2 = {fk_project_idx: "3",
				          sel2Val : $("#sel3").val(),
				          listsearchINproject: $("#listsearchINproject").val()}
		
		$.ajax({
			
			url: "<%= request.getContextPath() %>/searchINproject.action",
			type: "get",
			data: form_data2,
			dataType: "json",
			success: function(json){
				
				// 우선은 리스트나 카드의 정보를 json 으로 받아서 css 처리를 한다. 
				
				var html = "";
				
				if($("#sel3").val() == 'list'){
					
					
					
				}
				else if($("#sel3").val() == 'card'){
					
					
				}
				
				
			},
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
		    }
			
		});
		
		
	}
	

	var se1Val = "";
	
	function selVal(){
		
		if($("#sel1").val() == null){
			
			sel1Val = $("#sel1").val("수정");
			
		} 
				
		sel1Val = $("#sel1").val($("#sel").val());	
		
		sel1Val = $("#sel1").val();
		
		console.log("버튼확인::::::"+se1Val);
		
		Activity(sel1Val); 
				
	}
	
 /* 	function sel2Val(){
 		
 		console.log("버튼확인22222::::::"+se1Val);
		
		if($("#sel1").val() == null){
			
			sel1Val = $("#sel1").val("수정");
			
		} 
		
		sel1Val = $("#sel1").val($("#sel2").val());	
		
		
		sel1Val = $("#sel1").val();
		
		console.log("버튼확인::::::"+se1Val);
		
		Activity(sel1Val);
		 
	}  */
	
	
	/* */
	
	
</script>





<body>
	 <div id="mySidenav" class="sidenav">
	 	  <span style="font-size: 40pt; font-weight: bold;" onclick="Activity();">&#9776; menu</span>
	 	  <a href="javascript:void(0)"onclick="closeNav();"><span style="padding-left: 80%; ">&times;</span></a>
	 	  <span style="cursor:pointer" onclick="openNav2();">Search in PROJECT</span> 
		  <span style=" cursor: pointer;" onclick="location.href='<%= request.getContextPath()%>/leaveProject.action'" onclick="leaveProject();">Leave PROJECT</span> 
		  
		  
		  <span style="cursor: pointer;" onclick="location.href='<%= request.getContextPath() %>/deleteProject.action'" onclick="deleteProject();" >Delete PROJECT</span>
		 
		  <hr style="border: solid 1px gray; background-color: gray;"> 
		  <!-- <span>Activity</span> -->
		    <div class="form-group" style="padding-left:18pt; padding-top: 10pt; width: 150px; border: 0px solid yellow;">
		      <span style="padding-left: 10px;">Activity</span>
		      <select class="form-control" id="sel" name="sel" onchange="selVal();">     <!-- onclick="Activity();" -->
		        <option selected value="수정">CARD EDIT</option>
		        <option value="삭제">CARD DELETE</option>
		        <option value="추가">CARD ADD</option>
		        <option value="생성">LIST CREATE</option>
		      </select>
		    </div>           
		  
		  	<div class="container" style="background-color: #f2f2f2; border: 0px solid red; width:400px;" id="activitylist">
			  <!-- <h2>Activity</h2>  -->          
			  <table class="table" id="projectRecordListTB"> 			    	
			  </table>
		  	</div>
		  
		  
		 
		    
	  </div>
	  
	   <div id="mySideactivity" class="sidenav" style="border: 0px solid yellow;">
   		       
	  	  <span style="font-size: 40pt; font-weight: bold; cursor: pointer; float: left;" onclick="closeNav2();">Activity</span>
	  	  <ul class="w3-ul">
		    <span style="font-size: 30pt; margin-top: 20px; float: left;"><i class="fa fa-arrow-left" onclick="closeNav3();"></i></span>
	  	  </ul>
	  	  
	  	    
	  	  <div style="border: 0px solid yellow; margin-top: 100px;">
		  	  <!-- <button type="button" class="btn btnActivity" id="cardEditbtn" value="수정" onclick="selVal();">CARD<br/>EDIT</button>
		  	  <button type="button" class="btn btnActivity" id="cardDeletebtn" value="삭제" onclick="selVal();">CARD<br/>DELETE</button>
		  	  <button type="button" class="btn btnActivity" id="cardAddbtn" value="추가" onclick="selVal();">CARD<br/>ADD</button>
		  	  <button type="button" class="btn btnActivity" id="listCreatebtn" value="생성" onclick="selVal();">LIST<br/>CREATE</button> -->
		  	  <!-- <input type="button" class="btn btnActivity" id="cardEditbtn" onclick="btnVal();" value="수정" />
		  	  <input type="button" class="btn btnActivity" id="cardDeletebtn" onclick="btnVal();" value="삭제" />
		  	  <input type="button" class="btn btnActivity" id="cardAddbtn" onclick="btnVal();" value="추가" />
		  	  <input type="button" class="btn btnActivity" id="listCreatebtn" onclick="btnVal();" value="생성" /> -->
		  	  <!-- <select class="form-control" class="sel" id="sel2" name="sel2" onchange="selVal();">     onclick="Activity();"
		        <option selected value="수정">CARD EDIT</option>
		        <option value="삭제">CARD DELETE</option>
		        <option value="추가">CARD ADD</option>
		        <option value="생성">LIST CREATE</option>
		      </select> -->
	  	  </div>
		  <!-- <a href="javascript:void(0)" onclick="closeNav();"><span style="padding-left: 80%; font-size: 20pt;">&times;</span></a>
		  <span>&nbsp;&nbsp;&nbsp;Search in PROJECT</span> -->             
		   <!-- <div class="form-group" style="padding-left:18pt; padding-top: 10pt; width: 120px; border: 0px solid yellow;">
		      <h2><span>Activity</span></h2>
		      <select class="form-control" id="sel2" name="sel2" onclick="Activity();">     onclick="Activity();"
		        <option selected value="수정">CARD EDIT</option>
		        <option value="삭제">CARD DELETE</option>
		        <option value="추가">CARD ADD</option>
		        <option value="생성">LIST CREATE</option>
		      </select>
		    </div> -->
		    
		    
		  
		  
		  <div class="container" style="background-color: #f2f2f2; border: 0px solid red; width:400px;" id="activitylistMore">
			  <!-- <h2>Activity</h2>  -->          
			  <table class="table" id="projectRecordListMoreTB">
			    			    	
			  </table>
		  </div>
	  </div>
	  
	  
	  <div id="mySidesearch" class="sidenav" style="border: 0px solid yellow;">     
	  	  <span style="font-size: 40pt; font-weight: bold; cursor: pointer; " onclick="closeNav2();">&#9776; menu</span>
		  <a href="javascript:void(0)" onclick="closeNav();"><span style="padding-left: 80%; font-size: 20pt;">&times;</span></a>
		  <span>&nbsp;&nbsp;&nbsp;Search in PROJECT</span>             
		  <div class="container" style="border: 0px solid yellow;" >
			  <form>
			    <div class="form-group" style="padding-left:18pt; padding-top: 10pt; width: 120px; border: 0px solid yellow;">
			      <select class="form-control" id="sel3" onclick="searchINproject();">    
			        <option selected value="list">LIST</option>
			        <option value="card">CARD</option>
			      </select>
			    </div>             
			  </form>
			  
			  <!--  search form start -->
		      <div class="nav search-row" id="top_menu" style="float: left; width: 300px; border: 0px solid orange;">
		      <form class="navbar-form" style="border: 0px solid yellow;">
		         <input class="form-control" placeholder="Search" type="text" id="listsearchINproject" style="float:left; hight: 500px; width: 300px; border: 0px solid yellow;"> 
		      </form>                        
		        <!--  search form start -->
		        <!-- <ul class="nav top-menu"> 
		          <li>
		            
		          </li>
		        </ul>  -->
		        <!--  search form end -->
		      </div>
		  </div>
	  </div>
	  
	 
	  
                           
	  <div style="float: left;">                     
		<br/>
		<span style="font-size:30px; cursor:pointer;" onclick="openNav();">&#9776; menu</span>
	  </div>
	
			
	
	  <form name="project_idxFrm">
	  	<input type="text" name="fk_project_idx" value="31" /><%-- value="${project_membervo.fk_project_idx}" --%>
	  	<input type="text" name="sel1Val" />
	  </form>
	  
	  <input type="checkbox" id="mj_checkbox" class="" />
	  <label for="mj_checkbox">체크박스</label>
	  
	  <%-- <c:forEach items="${adminList}" var="map">
		  	<c:if test="project_member_userid.equals('${sessionScope.loginuser.userid}')">
		  		<span style="cursor: pointer;" onclick="location.href='<%= request.getContextPath() %>/deleteProject.action'" onclick="deleteProject();" >Delete PROJECT</span>
		  		<input type="text" value="집에가고 싶다"/>
		  	</c:if>
		</c:forEach> --%>
	  <div style="float: right;">
	  		<input type="text" id="sel1" name="sel1" value=""/>	
	  </div>
	  
</body>
</html>