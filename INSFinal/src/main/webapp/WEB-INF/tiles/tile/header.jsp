<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.net.InetAddress"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">

<!-- <link href="https://fonts.googleapis.com/css?family=Sunflower:300" rel="stylesheet"> -->

<style type="text/css">

	#project_dropdown-default:hover{
		background-color: #e6f2ff;
	}
	
	#project_dropdown {
		overflow-x: hidden;
	    overflow-y: auto;
	    max-height: 700px;
	    background-color: white;
	    padding-left: 3%;
	}             
	
	.teamname {
		font-size: 15pt;
		font-weight: bold;
	}
	
	#drop1 {
		margin-left: 9%;
		width: 500px;
		background-color: white;
	}
	
	
	#drop2{
		margin-left: 9%;
		width: 500px;
		background-color: white;
	}
	
	input[id="search_input"] {
		width: 130px;
		box-sizing: border-box;
		border: 2px solid #ccc;
		border-radius: 4px;
		font-size: 16px;
		background-color: white;
		background-image: url('searchicon.png');
		background-position: 10px 10px;
		background-repeat: no-repeat;
		padding: 12px 20px 12px 40px;
		-webkit-transition: width 0.4s ease-in-out;
		transition: width 0.4s ease-in-out;
	}
	
	input[id="search_input"]:focus {
		width: 100%;
		border-color: rgba(255, 82, 82, 0.8);
	}
	
	
	#team_name{
		color: rgb(255, 82, 82);
	} 

	#newMsgList{
	
	   overflow-x: hidden;
	   overflow-y: auto;
	   width: 300px;
	   max-height: 500px;
	   background-color: white;
		
	}
		
	.header {
		background: #fff;   
		background-color: rgba(255, 255, 255, 1); 
		hegith: 64px;        
		box-shadow: 0 4px 5px 0 rgba(0, 0, 0, 0.08);
		font-weight: lighter;
		margin-bottom: 0%;
		/* font-family: 'Sunflower', sans-serif; */
	}             

	#project_button {
		 background-color:  white;
		 margin-top:8px; 
		 color: black;  
		 border: 2px solid #CACACA;
		 border-radius: 20px;
	}
	
	.title {
		font-weight: bold; 
		color: rgba(0, 0, 0, 0.54);       
		font-size: 20pt;   
		font-weight: bold;                    
	}  
	
	a:hover {
		text-decoration: none;
		background-color: rgba(0, 0, 0, 0.54);    
	}

	.menu_header{       
		align: center;
		border: 0px solid red;   
	}
	
	.dropSearch{
		width: 80%;
	}
	
	#newMsg_img{
		width: 50px;
		height: auto;   
		border: none;  
	}
	
	.project_record_tb{
		color: black;
	}
	
	.dropdown-menu.extended li p.blue {
   		background-color: rgba(255, 82, 82, 0.8);
    } 
         
    .projectList_div1{
    	position: relative;
    	width: 90%; 
    	height: 45px; 
    	border: 0px solid green;     
    	padding-left: 5%;                      
    }        
    
    .projectList_img {
    	position: absolute;
    	width: 100%;       
    	height: 40px;   
    	border-radius: 5px;
    }
    
    .projectList_div2{         
    	position: absolute;
    	margin-left: 20%;     
    	width: 80%; 
    	height: 40px;                             
    	border: 0px solid red; 
    	border-radius: 0 5px 5px 0;
    	float: right;     
    	background-color: rgba(255, 255, 255, 0.9);
    	
    }
    
    .projectList_ul{
    	position: relative;
    	border: 0px solid yellow;         
    }	
    
    .projectList_div3{
    	position: absolute;
    	width: 100%;
    	height: 40px;
    	border: 0px solid red;
    }
                   
    .projectList_div4{                              
    	position: relative;
    	width: 19%;                                   
    	height: 40px;
    	border: 0px solid green;             
    	float: right;  
    	padding-top: 6%;            
    }
    
   	.clickStar {
    	color: yellow;
    }
    
    
    .drop_img{
	  	height: 65px;
	    width: 65px;
	    border-radius: 25em;
  }
  
  .eborder-top {
  	background-color: white;
  }
</style>





<%
	//==== #177. (웹채팅관련9) ====//
	// === 서버 IP 주소 알아오기 === //
	/* InetAddress inet = InetAddress.getLocalHost();
	String serverIP = inet.getHostAddress();
	int portnumber = request.getServerPort();

	String serverName = "http://" + serverIP + ":" + portnumber; */
%>

<script type="text/javascript">

	$(document).ready(function(){
		
		 /* 프로젝트 버튼 클릭시 함수 */
		 $("#project_button").click(function(){
			
			 teamlistButton();
			
		}); 
		 
		 /* header 의 검색어 입력시 발생 함수 */
		  $("#search_input").keyup(function(){
		
			  if($("#search_input").val().trim() != ""){
				  searchTotal(); 
			  }
			  else if($("#search_input").val().trim() == ""){
				  $("#drop1").hide();
			  }
			 
		   }); // $("#search_input").keyup()-------------------------------------------------------------------
		 
		   
		  /* header 의 검색의 결과를 보여주는 함수 */ 
		  function searchTotal(){
			 
			  dropShow1(); 
			   
			  var form_data = {search_input:$("#search_input").val()}
				 
				 $.ajax({
						
					 url: "<%=request.getContextPath()%>/teamSearch.action",
					 type: "get",
					 data: form_data,
					 dataType: "JSON",
					 success: function(json){
											  
						 var html = "";
						
						 if(json.length > 0){
							 
							 $("#team_drop1").show();  
									
							 html += "<span style='color: rgba(0, 0, 0, 0.54); font-weight: bold; font-size: 15pt;'>Teams</span>";
							 
							 $.each(json, function(entryIndex, entry){
								 												
								 var word = entry.team_name.trim();
								 // "ajax 프로그래밍"
									
								 var index = word.toLowerCase().indexOf( $("#search_input").val().toLowerCase() ); // 해당 문자열을 전부 다 소문자로 바꾸는 자바스크립트 함수 (toUpperCase())
								 
								 
								 var len = $("#search_input").val().length;
															
								 var str ="";
								
									 str += "<span class='first' style='color: gray;'>" + word.substr(0,index) + "</span>" + "<span class='second' style='color: rgb(255, 82, 82); font-weight: bold;'>" +word.substr(index, len)+"</span>"+"<span class='third' style='color: gray;'>" + word.substr(index+len) + "</span>"; 
									
								if(json.length < 2){
									
									 html += "<br/><a href='/finalins/showTeam.action?team_idx="+entry.team_idx+"'><span class='result'>"+str+"</span></a>";
									 
									 $("#team_drop1").html(html);
									
								}	  
								else{
									
									if(entryIndex < 2){
										html += "<br/><a href='/finalins/showTeam.action?team_idx="+entry.team_idx+"'><span class='result'>"+str+"</span></a>";
										
									}
									
									$("#team_drop1").html(html);
								
								}
												 
							 }); // end of $.each()----------------------------------------------------------------------
							 
							 if(json.length > 2){ 
								 html += "<li><a class='btn btn-default btn-sm' id='btnMore1'>More</a></li>";
							 } 
							 
							 html += "<li class='divider'></li>";
							 
							 
							 $("#team_drop1").html(html);
								 
						 } // json.length > 0 if()-------------------------------------------------------------------------
						 else{
							 
							 $("#team_drop1").hide();
							 
				  		}// json.length > 0 else()--------------------------------------------------------------------------
				 	
				  		
				  		/* $("#drop1").html(html); */
				  		
					  	$("#btnMore1").click(function(){
							 
					  		/* $("#drop2").empty(); */
					  		
					  		$("#project_drop2").empty();
					  		$("#list_drop2").empty();
					  		$("#card_drop2").empty();
					  		$("#member_drop2").empty(); 
						  		
					  		
					  		 dropShow2();
					  		 
							 var html2 = "";
							 
							 html2 += "<span style='color: rgba(0, 0, 0, 0.54); font-weight: bold; font-size: 15pt;'>Teams</span>";
							 html2 += "<span id='backicon'><img src='<%=request.getContextPath() %>/resources/img/left-arrow.png' /></span>";
							 
							 $.each(json, function(entryIndex, entry){
								 				
								 var word = entry.team_name.trim();
								 // "ajax 프로그래밍"
									
								 var index = word.toLowerCase().indexOf( $("#search_input").val().toLowerCase() ); // 해당 문자열을 전부 다 소문자로 바꾸는 자바스크립트 함수 (toUpperCase())
								 
								 
								 var len = $("#search_input").val().length;
															
								 var str ="";
								
									 str += "<span class='first' style='color: gray;'>" + word.substr(0,index) + "</span>" + "<span class='second' style='color: rgb(255, 82, 82); font-weight: bold;'>" +word.substr(index, len)+"</span>"+"<span class='third' style='color: gray;'>" + word.substr(index+len) + "</span>"; 
									
									 html2 += "<br/><a href='/finalins/showTeam.action?team_idx="+entry.team_idx+"'><span class='result'>"+str+"</span></a>";
									 
								 $("#team_drop2").html(html2);
									 		 
							 }); // end of $.each()----------------------------------------------------------------------
							  
							 $("#team_drop2").html(html2);
							 
							
							 $("#backicon").click(function(){
									
									/* alert("확인용:::::::"); */ 
									dropShow1();
										 
							 });
							 
							 
						 }); // end of $("#btnMore").click()---------------------------------------------------------------------------
				 		

						 
						 
					 },
					 error: function(request, status, error){
							alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
					 }
					 						 
				 });  
				 
				 
				 
				 $.ajax({
						
					 url: "<%=request.getContextPath()%>/projectSearch.action",
					 type: "get",
					 data: form_data,
					 dataType: "JSON",
					 success: function(json){
						
						 var html = "";
						
						 if(json.length > 0){
							 
							 $("#project_drop1").show();  
									
							 html += "<span style='color: rgba(0, 0, 0, 0.54);font-weight: bold; font-size: 15pt;'>Projects</span>";
							 
							 $.each(json, function(entryIndex, entry){
								 												
								 var word = entry.project_name.trim();
								 // "ajax 프로그래밍"
									
								 var index = word.toLowerCase().indexOf( $("#search_input").val().toLowerCase() ); // 해당 문자열을 전부 다 소문자로 바꾸는 자바스크립트 함수 (toUpperCase())
								 
								 
								 var len = $("#search_input").val().length;
															
								 var str ="";
								
									 str += "<span class='first' style='color: gray;'>" + word.substr(0,index) + "</span>" + "<span class='second' style='color: rgb(255, 82, 82); font-weight: bold;'>" +word.substr(index, len)+"</span>"+"<span class='third' style='color: gray;'>" + word.substr(index+len) + "</span>"; 
									
								if(json.length < 2){
									
									 html += "<br/><a href='<%= request.getContextPath() %>/project.action?project_name="+entry.project_name+"&projectIDX="+entry.project_idx+"&team_IDX="+entry.fk_team_idx+"'><span class='result'>"+str+"</span></a>";
									 
									 $("#project_drop1").html(html);
									
								}	  
								else{
									
									if(entryIndex < 2){
										html += "<br/><a href='<%= request.getContextPath() %>/project.action?project_name="+entry.project_name+"&projectIDX="+entry.project_idx+"&team_IDX="+entry.fk_team_idx+"'><span class='result'>"+str+"</span></a>";
										
									}
									$("#project_drop1").html(html);
								
								}
												 
							 }); // end of $.each()----------------------------------------------------------------------
							 
							 if(json.length > 2){ 
								 html += "<li><a class='btn btn-default btn-sm' id='btnMore2'>More</a></li>";
							 } 
							 
							 html += "<li class='divider'></li>";
							 
							 
							 $("#project_drop1").html(html);
								 
						 } // json.length > 0 if()-------------------------------------------------------------------------
						 else{
							 
							 $("#project_drop1").hide();
							 
				  		}// json.length > 0 else()--------------------------------------------------------------------------
				 	
				  		
				  		/* $("#drop1").html(html); */
				  		
					  	$("#btnMore2").click(function(){
							 
					  		/*  $("#drop2").empty(); */
					  		$("#team_drop2").empty();
					  		$("#list_drop2").empty();
					  		$("#card_drop2").empty();
					  		$("#member_drop2").empty(); 
						  		
					  		
					  		 dropShow2();
					  		 
					  		
					  		
							 var html3 = "";
							 
							 html3 += "<span style='color: rgba(0, 0, 0, 0.54); font-weight: bold; font-size: 15pt;'>Projects</span>";
							 html3 += "<span id='backicon'><img src='<%=request.getContextPath() %>/resources/img/left-arrow.png' /></span>";
							 
							 $.each(json, function(entryIndex, entry){
								 				
								 var word = entry.project_name.trim();
								 // "ajax 프로그래밍"
									
								 var index = word.toLowerCase().indexOf( $("#search_input").val().toLowerCase() ); // 해당 문자열을 전부 다 소문자로 바꾸는 자바스크립트 함수 (toUpperCase())
								 
								 
								 var len = $("#search_input").val().length;
															
								 var str ="";
								
									 str += "<span class='first' style='color: gray;'>" + word.substr(0,index) + "</span>" + "<span class='second' style='color: rgb(255, 82, 82); font-weight: bold;'>" +word.substr(index, len)+"</span>"+"<span class='third' style='color: gray;'>" + word.substr(index+len) + "</span>"; 
									
									 html3 += "<br/><a href='<%= request.getContextPath() %>/project.action?project_name="+entry.project_name+"&projectIDX="+entry.project_idx+"&team_IDX="+entry.fk_team_idx+"'><span class='result'>"+str+"</span></a>";
									 
								 $("#project_drop2").html(html3);
									 		 
							 }); // end of $.each()----------------------------------------------------------------------
							  
							 $("#project_drop2").html(html3);
							 
							
							 $("#backicon").click(function(){
									
									/* alert("확인용:::::::"); */ 
									dropShow1();
										 
							 });
							 
							 
						 }); // end of $("#btnMore").click()---------------------------------------------------------------------------
				 		

						 
						 
					 },
					 error: function(request, status, error){
							alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
					 }
					 						 
				 });  
				 
			 	 $.ajax({
					
				 url: "<%=request.getContextPath()%>/listSearch.action",
				 type: "get",
				 data: form_data,
				 dataType: "JSON",
				 success: function(json){
					
					 var html = "";
					
					 if(json.length > 0){
						 
						 $("#list_drop1").show();  
								
						 html += "<span style='color: rgba(0, 0, 0, 0.54); font-weight: bold; font-size: 15pt;'>Lists</span>";
						 
						 $.each(json, function(entryIndex, entry){
							 												
							 var word = entry.list_name.trim();
							 // "ajax 프로그래밍"
								
							 var index = word.toLowerCase().indexOf( $("#search_input").val().toLowerCase() ); // 해당 문자열을 전부 다 소문자로 바꾸는 자바스크립트 함수 (toUpperCase())
							 
							 
							 var len = $("#search_input").val().length;
														
							 var str ="";
							
								 str += "<span class='first' style='color: gray;'>" + word.substr(0,index) + "</span>" + "<span class='second' style='color: rgb(255, 82, 82); font-weight: bold;'>" +word.substr(index, len)+"</span>"+"<span class='third' style='color: gray;'>" + word.substr(index+len) + "</span>"; 
								
							if(json.length < 2){
								
								 html += "<br/><a href='<%= request.getContextPath() %>/project.action?project_name="+entry.project_name+"&projectIDX="+entry.fk_project_idx+"&team_IDX="+entry.fk_team_idx+"'><span class='result'>"+str+"</span></a>";
								 
								 $("#list_drop1").html(html);
								
							}	  
							else{
								
								if(entryIndex < 2){
									html += "<br/><a href='<%= request.getContextPath() %>/project.action?project_name="+entry.project_name+"&projectIDX="+entry.fk_project_idx+"&team_IDX="+entry.fk_team_idx+"'><span class='result'>"+str+"</span></a>";
									
								}
								$("#list_drop1").html(html);
							
							}
											 
						 }); // end of $.each()----------------------------------------------------------------------
						 
						 if(json.length > 2){ 
							 html += "<li><a class='btn btn-default btn-sm' id='btnMore3'>More</a></li>";
						 } 
						 
						 html += "<li class='divider'></li>";
						 
						 
						 $("#list_drop1").html(html);
							 
					 } // json.length > 0 if()-------------------------------------------------------------------------
					 else{
						 
						 $("#list_drop1").hide();
						 
			  		}// json.length > 0 else()--------------------------------------------------------------------------
			 	
			  		
			  		
			  		
				  	$("#btnMore3").click(function(){
						
				  	 	
				  		$("#team_drop2").empty();
				  		$("#project_drop2").empty();
				  		$("#card_drop2").empty();
				  		$("#member_drop2").empty();
				  		
				  		 dropShow2();
				  		
				  		
				  		 
						 var html4 = "";
						 
						 html4 += "<span style='color: rgba(0, 0, 0, 0.54); font-weight: bold; font-size: 15pt;'>Lists</span>";
						 html4 += "<span id='backicon'><img src='<%=request.getContextPath() %>/resources/img/left-arrow.png' /></span>";
						 
						 $.each(json, function(entryIndex, entry){
							 				
							 var word = entry.list_name.trim();
							 // "ajax 프로그래밍"
								
							 var index = word.toLowerCase().indexOf( $("#search_input").val().toLowerCase() ); // 해당 문자열을 전부 다 소문자로 바꾸는 자바스크립트 함수 (toUpperCase())
							 
							 
							 var len = $("#search_input").val().length;
														
							 var str ="";
							
								 str += "<span class='first' style='color: gray;'>" + word.substr(0,index) + "</span>" + "<span class='second' style='color: rgb(255, 82, 82); font-weight: bold;'>" +word.substr(index, len)+"</span>"+"<span class='third' style='color: gray;'>" + word.substr(index+len) + "</span>"; 
								
								 html4 += "<br/><a href='<%= request.getContextPath() %>/project.action?project_name="+entry.project_name+"&projectIDX="+entry.fk_project_idx+"&team_IDX="+entry.fk_team_idx+"'><span class='result'>"+str+"</span></a>";
								 
							 $("#list_drop2").html(html4);
								 		 
						 }); // end of $.each()----------------------------------------------------------------------
						  
						 $("#list_drop2").html(html4);
						 
						
						 $("#backicon").click(function(){
								 
								dropShow1();
									 
						 });
						 
						 
					 }); // end of $("#btnMore").click()---------------------------------------------------------------------------
			 		

					 
					 
				 },
				 error: function(request, status, error){
						alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
				 }
				 						 
			 }); 
				 
			
			 $.ajax({
					
				 url: "<%=request.getContextPath()%>/cardSearch.action",
				 type: "get",
				 data: form_data,
				 dataType: "JSON",
				 success: function(json){
					
					 var html = "";
					
					 if(json.length > 0){
						 
						 $("#card_drop1").show();  
								
						 html += "<span style='color: rgba(0, 0, 0, 0.54); font-weight: bold; font-size: 15pt;'>Cards</span>";
						 
						 $.each(json, function(entryIndex, entry){
							 												
							 var word = entry.card_title.trim();
							 								
							 var index = word.toLowerCase().indexOf( $("#search_input").val().toLowerCase() ); // 해당 문자열을 전부 다 소문자로 바꾸는 자바스크립트 함수 (toUpperCase())
							 							 
							 var len = $("#search_input").val().length;
														
							 var str ="";
							
								 str += "<span class='first' style='color: gray;'>" + word.substr(0,index) + "</span>" + "<span class='second' style='color: rgb(255, 82, 82); font-weight: bold;'>" +word.substr(index, len)+"</span>"+"<span class='third' style='color: gray;'>" + word.substr(index+len) + "</span>"; 
								
							if(json.length < 2){
								
								 html += "<br/><a href='<%= request.getContextPath() %>/project.action?project_name="+entry.project_name+"&projectIDX="+entry.project_idx+"&team_IDX="+entry.fk_team_idx+"'><span class='result'>"+str+"</span></a>";
								 
								 $("#card_drop1").html(html);
								
							}	  
							else{
								
								if(entryIndex < 2){
									html += "<br/><a href='<%= request.getContextPath() %>/project.action?project_name="+entry.project_name+"&projectIDX="+entry.project_idx+"&team_IDX="+entry.fk_team_idx+"'><span class='result'>"+str+"</span></a>";
									
								}
								$("#card_drop1").html(html);
							
							}
											 
						 }); // end of $.each()----------------------------------------------------------------------
						 
						 if(json.length > 2){ 
							 html += "<li><a class='btn btn-default btn-sm' id='btnMore4'>More</a></li>";
						 } 
						 
						 html += "<li class='divider'></li>";
						 
						 
						 $("#card_drop1").html(html);
							 
					 } // json.length > 0 if()-------------------------------------------------------------------------
					 else{
						 
						 $("#card_drop1").hide();
						 
			  		}// json.length > 0 else()--------------------------------------------------------------------------
			 	
			  					  		
				  	$("#btnMore4").click(function(){
						
				  		$("#team_drop2").empty();
				  		$("#project_drop2").empty();
				  		$("#list_drop2").empty();
				  		$("#member_drop2").empty();
				  	 	
				  	 	
				  		 dropShow2();
				  		 
				  		 
				  		
						 var html5 = "";
						 
						 html2 += "<span style='color: rgba(0, 0, 0, 0.54); font-weight: bold; font-size: 15pt;'>Cards</span>";
						 html2 += "<span id='backicon'><img src='<%=request.getContextPath() %>/resources/img/left-arrow.png' /></span>";
						 
						 $.each(json, function(entryIndex, entry){
							 				
							 var word = entry.card_title.trim();
							 								
							 var index = word.toLowerCase().indexOf( $("#search_input").val().toLowerCase() ); // 해당 문자열을 전부 다 소문자로 바꾸는 자바스크립트 함수 (toUpperCase())
							 							 
							 var len = $("#search_input").val().length;
														
							 var str ="";
							
								 str += "<span class='first' style='color: gray;'>" + word.substr(0,index) + "</span>" + "<span class='second' style='color: rgb(255, 82, 82); font-weight: bold;'>" +word.substr(index, len)+"</span>"+"<span class='third' style='color: gray;'>" + word.substr(index+len) + "</span>"; 
								
								 html5 += "<br/><a href='<%= request.getContextPath() %>/project.action?project_name="+entry.project_name+"&projectIDX="+entry.project_idx+"&team_IDX="+entry.fk_team_idx+"'><span class='result'>"+str+"</span></a>";
								 
							 $("#card_drop2").html(html5);
								 		 
						 }); // end of $.each()----------------------------------------------------------------------
						  
						 $("#card_drop2").html(html5);
						 
						
						 $("#backicon").click(function(){
								
								/* alert("확인용:::::::"); */ 
								dropShow1();
									 
						 });
						 
						 
					 }); // end of $("#btnMore").click()---------------------------------------------------------------------------
			 		
	 
				 },
				 error: function(request, status, error){
						alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
				 }
				 						 
			 }); 
			 
			 
			 $.ajax({
					
				 url: "<%=request.getContextPath()%>/memberSearch.action",
				 type: "get",
				 data: form_data,
				 dataType: "JSON",
				 success: function(json){
					
					 var html = "";
					
					 if(json.length > 0){
						 
						 $("#member_drop1").show();  
								
						 html += "<span style='color: rgba(0, 0, 0, 0.54); font-weight: bold; font-size: 15pt;'>Members</span>";
						 
						 $.each(json, function(entryIndex, entry){
							 
							 var word = "";
							 
							 if( (entry.userid.trim()).indexOf($("#search_input").val()) != -1 ){
								 word = entry.userid.trim();
							 }
							 else if( (entry.nickname.trim()).indexOf($("#search_input").val()) != -1 ){
								 word = entry.nickname.trim();
							 }
							 else if( (entry.name.trim()).indexOf($("#search_input").val()) != -1 ){
								 word = entry.name.trim();
							 }
								
							 var index = word.toLowerCase().indexOf( $("#search_input").val().toLowerCase() ); // 해당 문자열을 전부 다 소문자로 바꾸는 자바스크립트 함수 (toUpperCase())
							 
							 var len = $("#search_input").val().length;
														
							 var str ="";
							
								 str += "<span class='first' style='color: gray;'>" + word.substr(0,index) + "</span>" + "<span class='second' style='color: rgb(255, 82, 82); font-weight: bold;'>" +word.substr(index, len)+"</span>"+"<span class='third' style='color: gray;'>" + word.substr(index+len) + "</span>"; 
								
							if(json.length < 2){
								
								html += "<br/><img class='drop_img' src='<%=request.getContextPath()%>/resources/files/"+entry.server_filename+"'>";
								
								if( (entry.userid.trim()).indexOf($("#search_input").val()) != -1 ){
									html += "<a href='#'><span class='result'>"+str+"("+entry.nickname+")"+"--"+entry.name+"</span></a>";
								 }
								 else if( (entry.nickname.trim()).indexOf($("#search_input").val()) != -1 ){
									 html += "<a href='#'><span class='result'>"+entry.userid+"("+str+")"+"--"+entry.name+"</span></a>";
								 }
								 else if( (entry.name.trim()).indexOf($("#search_input").val()) != -1 ){
									 html += "<a href='#'><span class='result'>"+entry.userid+"("+entry.nickname+")"+"--"+str+"</span></a>";
								 }
														 
								 $("#member_drop1").html(html); 
								
							}	  
							else{
								
								if(entryIndex < 2){
									
									html += "<br/><img class='drop_img' src='<%=request.getContextPath()%>/resources/files/"+entry.server_filename+"'>";
									
									if( (entry.userid.trim()).indexOf($("#search_input").val()) != -1 ){
										html += "<a href='#'><span class='result'>"+str+"("+entry.nickname+")"+"--"+entry.name+"</span></a>";
									 }
									 else if( (entry.nickname.trim()).indexOf($("#search_input").val()) != -1 ){
										 html += "<a href='#'><span class='result'>"+entry.userid+"("+str+")"+"--"+entry.name+"</span></a>";
									 }
									 else if( (entry.name.trim()).indexOf($("#search_input").val()) != -1 ){
										 html += "<a href='#'><span class='result'>"+entry.userid+"("+entry.nickname+")"+"--"+str+"</span></a>";
									 }
								}
								
								 $("#member_drop1").html(html);
															
							
							}
							
						 }); // end of $.each()----------------------------------------------------------------------
						 
						 if(json.length > 2){ 
							 html += "<li><a class='btn btn-default btn-sm' id='btnMore5'>More</a></li>";
						 } 
						 
						 html += "<li class='divider'></li>";
						 
						 
						 $("#member_drop1").html(html);
							 
					 } // json.length > 0 if()-------------------------------------------------------------------------
					 else{
						 
						 $("#member_drop1").hide();
						 
			  		}// json.length > 0 else()--------------------------------------------------------------------------
			 	
			  					  		
				  	$("#btnMore5").click(function(){
					
				  		
				  		$("#team_drop2").empty();
				  		$("#project_drop2").empty();
				  		$("#list_drop2").empty();
				  		$("#card_drop2").empty();
				  		
				  		 dropShow2();
				  		
				  		
				  		 
						 var html2 = "";
						 
						 html2 += "<span style='color: rgba(0, 0, 0, 0.54); font-weight: bold; font-size: 15pt;'>Members</span>";
						 html2 += "<span id='backicon'><img src='<%=request.getContextPath() %>/resources/img/left-arrow.png' /></span>";
						 
						 $.each(json, function(entryIndex, entry){
							 
							 var word = "";
							 
							 if( (entry.userid.trim()).indexOf($("#search_input").val()) != -1 ){
								 word = entry.userid.trim();
							 }
							 else if( (entry.nickname.trim()).indexOf($("#search_input").val()) != -1 ){
								 word = entry.nickname.trim();
							 }
							 else if( (entry.name.trim()).indexOf($("#search_input").val()) != -1 ){
								 word = entry.name.trim();
							 }
								
							 var index = word.toLowerCase().indexOf( $("#search_input").val().toLowerCase() ); // 해당 문자열을 전부 다 소문자로 바꾸는 자바스크립트 함수 (toUpperCase())
							 
							 
							 var len = $("#search_input").val().length;
														
							 var str ="";
							
								 str += "<span class='first' style='color: gray;'>" + word.substr(0,index) + "</span>" + "<span class='second' style='color: rgb(255, 82, 82); font-weight: bold;'>" +word.substr(index, len)+"</span>"+"<span class='third' style='color: gray;'>" + word.substr(index+len) + "</span>"; 
								
								 html += "<br/><img class='drop_img' src='<%=request.getContextPath()%>/resources/files/"+entry.server_filename+"'>";
								 
								 if( (entry.userid.trim()).indexOf($("#search_input").val()) != -1 ){
										html2 += "<a href='#'><span class='result'><span class='userid'>"+str+"</span>("+entry.nickname+")"+"--"+entry.name+"</span></a>";
								 }
								 else if( (entry.nickname.trim()).indexOf($("#search_input").val()) != -1 ){
									 html2 += "<a href='#'><span class='result'><span class='userid'>"+entry.userid+"</span>("+str+")"+"--"+entry.name+"</span></a>";
								 }
								 else if( (entry.name.trim()).indexOf($("#search_input").val()) != -1 ){
									 html2 += "<a href='#'><span class='result'><span class='userid'>"+entry.userid+"</span>("+entry.nickname+")"+"--"+str+"</span></a>";
								 }
								 
							 $("#member_drop2").html(html2);
								 		 
						 }); // end of $.each()----------------------------------------------------------------------
						  
						 $("#member_drop2").html(html2);
						 
						
						 $("#backicon").click(function(){
							 
								dropShow1();
									 
						 });
						 
						 
					 }); // end of $("#btnMore").click()---------------------------------------------------------------------------
			 		
	 
				 },
				 error: function(request, status, error){
						alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
				 }
				 						 
			 }); // end of $.ajax memberSearch.action-------------------------------------------------------------------
		 	 
		  
			$("#drop1").click(function(event){
				var word = "";
				
				var $target = $(event.target); 				
				
				if($target.is(".first")){
					word = $target.text() + $target.next().text() + $target.next().next().text();
				}
				else if($target.is(".second")){
					word = $target.prev().text() + $target.text() + $target.next().text();
				}
				else if($target.is(".third")){
					word = $target.prev().prev().text() + $target.prev().text() + $target.text();
				}
				else if($target.is(".userid")){
					word = $target.text();
				}
				
				$("#search_input").val(word);
				
				
				$("#drop1").hide();
								
			});
			 
			 
			 
			 
			$("#drop2").click(function(event){
				var word = "";
				
				var $target = $(event.target); 				
				
				if($target.is(".first")){
					word = $target.text() + $target.next().text() + $target.next().next().text();
				}
				else if($target.is(".second")){
					word = $target.prev().text() + $target.text() + $target.next().text();
				}
				else if($target.is(".third")){
					word = $target.prev().prev().text() + $target.prev().text() + $target.text();
				}
				
				$("#search_input").val(word);
							
				$("#drop2").hide();
												
				
			}); 
	   
		 
		}	 
	 
	}); // $(document).ready()--------------------------------------------------------------------------------
		
	
	function dropShow1(){
		
	 $("#drop1").show();
	 $("#drop2").hide();
		
	}
	
	function dropShow2(){
		
		 $("#drop2").show();
		 $("#drop1").hide();
			
	}	
	

	// 팀 리스트와 프로젝트 리스트를 보여주는 함수
	function teamlistButton(){
		
		$("#project_dropdown").empty();
		
		$.ajax({
			url: "<%=request.getContextPath()%>/teamlist.action",
			type: "get",
			dataType: "json",
			success: function(json){
				
				var html = "";
				
				if(json.length > 0){
					
					$.each(json, function(entryIndex, entry){
												
						html += "<li><span id='team_name' style='padding-left: 10px;'><a href='#' style='color: rgb(255, 82, 82, 0.8); font-size: 13pt; font-weight: bold;'>"+entry.team_name+"<span style='float: right; padding-right: 12px; color: rgb(255, 82, 82, 0.8);'>  admin-"+entry.admin_userid+"</span></a></li>";
															
						html += "<li id='teamlist"+entryIndex+"'></li>";
					
						var form_data = {"fk_team_idx": entry.team_idx}
						
						$.ajax({
							
							url: "<%=request.getContextPath()%>/projectlist.action",
							type: "get",
							data: form_data,
							dataType: "json",
							success: function(json){
								                        
								var html2 = "";
								
								if(json.length > 0){
														      
									$.each(json, function(entryIndex2, entry){
																				        
										html2 += "<div class='projectList_div1' id='projectList_div"+entryIndex+"'>";
										html2 += "<a href='<%= request.getContextPath() %>/project.action?project_name="+entry.project_name+"&projectIDX="+entry.project_idx+"&team_IDX="+entry.fk_team_idx+"'>";
										html2 += "<img class='projectList_img' src='<%= request.getContextPath() %>/resources/images/"+entry.project_image_name+"' >";
										html2 += "</a>";
										html2 += "<div class='projectList_div2'>";
										
										html2 += "<a href='<%= request.getContextPath() %>/project.action?project_name="+entry.project_name+"&projectIDX="+entry.project_idx+"&team_IDX="+entry.fk_team_idx+"'>";
										html2 += "<div class='projectList_div3'>";
										html2 += "<ul class='projectList_ul'><li style='padding-top: 7%;'><span style='color: rgba(0, 0, 0, 0.7); font-weight: bold; float: left;'>"+entry.project_name+"</span></li></ul>";
										html2 += "</div>";
										html2 += "</a>";
										html2 += "<div class='projectList_div4' id='projectList_div4"+entry.project_idx+"'>"
										
										if(entry.project_favorite_status == 1){
											
											/* html2 += "<a class='clickA' id='clickA"+entry.project_idx+"' value onclick='updateFavoriteStatus("+entry.project_idx+");return false;' href='javascript:void(0);'>"; */
											
											html2 += "<a class='clickS' id='clickA"+entry.project_idx+"' >";
											
											html2 += "<i class='fa fa-star clickStar'></i>";
											
											html2 += "</a>";

											html2 += "<input type='hidden' id='idx"+entryIndex2+"' value='"+entry.project_idx+"' />";
											
										}
										
										html2 += "</div>";                       
										html2 += "</div>";
										html2 += "</div>";				   
										
										$("#teamlist"+entryIndex).html(html2);
									});
										
								}
								else{
									html2 += "<li><span style='color: black;'>등록된 프로젝트가 없습니다.</span></li>";
									
									$("#teamlist"+entryIndex).html(html2);
								}
								
							},
							error: function(request, status, error){
								alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
							}
							
							
							
						}); // end of ajax({}) ----------------------------------------
						
						html += "<li class='divider' style='border-color: rgb(255, 82, 82, 0.8);'></li>";
												
					});
									
				}
				else{
					
					html += "<li><span style='color: #ff9900; padding-left: 20%;'>가입한 팀이 없습니다.</span></li>";
					$("#project_dropdown").html(html);
				}
								
				$("#project_dropdown").html(html);		
				$(".dropdown").show(html);
				
				
			},
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
			}
			
		});
					
		
	}
	

	$(document).on("click", ".clickS", function(event){
		
		event.preventDefault();
		
		var project_idx = $(this).next().val();
					 
		var form_data = {"project_idx" : project_idx}
				
		$.ajax({
					
			url: "<%= request.getContextPath()%>/clickA.action",
			type: "POST",
			dataType: "JSON",
			data: form_data,
			success: function(json){   
			
				//alert("성공했다용");
				
				var n = json.n;
								
				if(n == 1){
					$("#projectList_div4"+project_idx).hide();
										
					teamlistButton();
				}
				
			},
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
			}
			
		});
		
	});
	
	$(document).mouseup(function (e){
		
		if(!$(".list-group.drop.dropdown-menu").is(e.target) && $(".list-group.drop.dropdown-menu").has(e.target).length == 0 ){
			
 			$(".list-group.drop.dropdown-menu").fadeOut();
			
		}
				
	});
	
	function personalAlarm(){
		  
		$.ajax({
			
			url: "<%= request.getContextPath() %>/personalAlarm.action",
			type: "get",
			dataType: "JSON",
			success: function(json){          
				
				var html = "";
								
				html += "<div class='notify-arrow notify-arrow-blue'></div>";
				
				if(json.length > 0){
						
					
					html += "<li style='width: 300px;'>";
					html += "<p class='blue'>You have "+json[0].newmsg+" new messages </p>";
					html += "</li>"; 
					
					html += "<div class='wrap' style='border: 0px solid yellow; width: 300px;'>";
					
					
					 $.each(json, function(entryIndex, entry){
						 
						 	
							
							/* html += "<span style='color: gray; font-weight: bold; font-size: 15pt;'><p>"*/
							/* html += entry.record_userid + "</p></span>" ; */ 
							html += "<li id='checkbox"+entry.project_record_idx+"' >";
							/* html += "<input type='checkbox' id='select"+entryIndex+ "' name='current_proudct' class='custom_checkbox' value='"+entry.project_record_idx+"' onclick='goHide();'/>";
							html += "<label for='select'"+entryIndex+">"; */
							html += "<input type='checkbox' name='current_proudct' class='custom_checkbox' value='"+entry.project_record_idx+"' onclick='goHide();'/>";
							html += "<label for='select'"+entryIndex+">";
							html += "</label><br/>";
							
							/* html += "<input type='checkbox' id='select'"+entryIndex+ "class='custom_checkbox'>";
							html += "<label for='select'"+entryIndex+">"; */
							html += "<span class='profile-ava'><img class='drop_img' src='<%=request.getContextPath()%>/resources/files/"+entry.server_filename+"'></span>&nbsp;&nbsp;"
							html += "<span style='color: gray; font-weight: bold; font-size: 12pt; color: rgba(255, 82, 82, 0.7);'>"+ entry.record_userid + "</span><br/>" ;
							html += "<span style='color: gray; font-weight: lighter;'>" + entry.record_dml_status + "</span><br/>";
							html += "<span style='color: gray; font-weight: lighter; font-size: 7pt;'>on CARD "+entry.card_title+" on LIST "+entry.list_name;
							html += "on PROJECT "+entry.project_name+"&nbsp;&nbsp;</span><br/>";
			
							html += "<span style='color: gray; font-weight: lighter; font-size: 7pt; float: right; padding-top: 5%; padding-right: 5%;'><br/>"+entry.project_record_time+"</span>";
							
							html += "<li class='divider'></li>";
							html += "</li>";
							
							
						});
						
						
						
						
					
				}
				else{
					
										
					html += "<li style='width: 300px;'>";
					html += "<p class='blue'>You have 0 new messages </p>";
					html += "</li>"; 
					
					html += "<div class='wrap2' style='border: 0px solid yellow; width: 300px;'>";
															
					html += "<br/><br/><li style='text-align: center;'><span style='color: gray; font-weight: bold;'>최근 활동한 기록이 없습니다.</span></li><br/><br/>";

								
								            
				}         
			
				html += "</div>";
				
				
				$("#newMsgList").html(html); 
				
				
			},
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
			}
			
		});
		  
		  
	}
	  
	  function goHide(){
		  
		  var test = "";
		  
		  
		  $("input[name=current_proudct]:checked").each(function() {
			 
			  test = $(this).val();
			 //  alert("test : " + test);  		
		      var form_data = {checkboxVal: test}
		  		   			  
			  $.ajax({
				  url: "<%= request.getContextPath() %>/personalAlarmCheckbox.action",
				  type: "post",
				  data: form_data,
				  dataType: "JSON",
				  success: function(json){
					
					var n = json[0].n;
					 
					if(n == 1){
						
				//	 console.log("read_status 변경 성공!!!"+${n});
				//	 alert("체크박스 value 값>>>" + test);
					 
					  $("#checkbox"+test).hide();
					 
					  personalAlarm();
					}
					
					 					  
				  },
				  error: function(request, status, error){
						alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
				  }
					
				  
			  });
		  
		  
		  });
		  
	  }
	 
		
 
</script>


<body>
	<!-- container section start -->
	<section id="container" class="">

		<c:if test="${sessionScope.loginuser == null }">
			<header class="header dark-bg">


				<div style="padding-left: 47%; border: 0px solid red;">
					<!-- logo start --> 
					 <a href="index.action" class="title">FINAL <span style="color: rgb(255, 82, 82);">INS</span></span></a>
					<!-- logo end -->
				</div>

			</header>
		</c:if>


		<c:if test="${sessionScope.loginuser != null }">

			<header class="header dark-bg">
			
			<div class="menu_header" style="position: relative; padding-top: -15%;">
				<div class="container"
					style="border: 0px solid yellow; width: 150px; float: left; padding-top: 2px;">
					<div class="dropdown" style="border: 0px solid yellow;">

						 <button class="btn btn-default dropdown-toggle" type="button" id="project_button"
						  data-toggle="dropdown"> 
         				 <span class="icon_cloud-upload_alt logo" style="margin-right: 10px; font-size: 20pt; color: rgb(255, 82, 82);"></span>
         				 <span style="font-size: 16pt; color: gray; font-weight: bold;">Project</span> 
       					<!-- <span class="caret"></span> --></button>
							
						<ul class="dropdown-menu" id="project_dropdown"
							style="width: 300px;">
						</ul>

					</div>
				</div>
				
				<!--  search form start -->
				<div class="nav search-row" id="top_menu"
					style="float: left; padding-left: 1px; margin-bottom: 7px; width: 500px; border: 0px solid yellow;">
					<!--  search form start -->
					<ul class="nav top-menu">
						<li>
							<div style="border: 0px solid red; width: 300px;">
								<form class="navbar-form">
									<input class="form-control" id="search_input"
										name="search_input" data-toggle="dropdown"
										placeholder="Search" type="text" style="height: 35px; margin-bottom: 5px;">
								</form>
							</div>
						</li>

						<!-- <div class="container">
		  <div class="list-group drop dropdown-menu" id="drop" style="border: 1px solid yellow;">
		    <span class='searchGroup' id='teamSearch'>Team<br/></span>
		  </div>
		</div> -->

		<div class="container dropSearch">
			<ul class="list-group drop dropdown-menu" id="drop1">
				<li id="team_drop1"></li>
				<li id="project_drop1"></li>
				<li id="list_drop1"></li>
				<li id="card_drop1"></li>
				<li id="member_drop1"></li>
			</ul>
		</div>
		<div class="container dropSearch">
			<ul class="list-group drop dropdown-menu" id="drop2">
				<li id="team_drop2"></li>
				<li id="project_drop2"></li>
				<li id="list_drop2"></li>
				<li id="card_drop2"></li>
				<li id="member_drop2"></li>
			</ul>
		</div>

					</ul>
					<!--  search form end -->    
				</div>

				 
				
				<div class="top-nav notification-row" style="float: right;">  
					    <div class="scrollbar" id="style-2">
					      <div class="force-overflow"></div>
					    </div>
					<!-- notificatoin dropdown start-->
					<ul class="nav pull-right top-menu">

						<!-- inbox notificatoin start-->
						<li id="mail_notificatoin_bar" class="dropdown"><a
							data-toggle="dropdown" class="dropdown-toggle" onclick="personalAlarm();"> <i
								class="icon-envelope-l"></i> <!-- <span class="badge bg-important">5</span> -->
						</a>
							<ul class="dropdown-menu extended inbox" id="newMsgList">
								
							</ul></li> 
						<!-- inbox notificatoin end -->



						<!-- alert notification start-->
						<li id="alert_notificatoin_bar" class="dropdown">
							

						</li>
						<!-- alert notification end-->

						<!-- user login dropdown start-->
						<li class="dropdown"><a data-toggle="dropdown"
							class="dropdown-toggle" href="#"> <span class="profile-ava">
									<!-- <img alt="" src="img/avatar1_small.jpg"> -->
							</span> <span class="username">${sessionScope.loginuser.userid}</span> <b
								class="caret"></b>
						</a>
							<ul class="dropdown-menu extended logout">
								<div class="log-arrow-up"></div>
								<li class="eborder-top"><a href="mypage.action"><i
										class="icon_profile"></i> My Profile</a></li>
								<li><a href="<%= request.getContextPath() %>/logout.action"><i class="icon_key_alt"></i>
										Log Out</a></li>
							</ul></li>

						<li><img class="drop_img" src="<%=request.getContextPath()%>/resources/files/${sessionScope.loginuser.server_filename}"></li>
						<!-- user login dropdown end -->
						<!-- task notificatoin start -->
						<!--           <li id="task_notificatoin_bar" class="dropdown">
            <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                            <i class="icon-task-l"></i>
                            <span class="badge bg-important">6</span>
            </a>
            <ul class="dropdown-menu extended tasks-bar">
              <div class="notify-arrow notify-arrow-blue"></div>
              <li>
                <p class="blue">You have 6 pending letter</p>
              </li>
              <li>
                <a href="#">
                  <div class="task-info">
                    <div class="desc">Design PSD </div>
                    <div class="percent">90%</div>
                  </div>
                  <div class="progress progress-striped">
                    <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="90" aria-valuemin="0" aria-valuemax="100" style="width: 90%">
                      <span class="sr-only">90% Complete (success)</span>
                    </div>
                  </div>
                </a>
              </li>
              <li>
                <a href="#">
                  <div class="task-info">
                    <div class="desc">
                      Project 1
                    </div>
                    <div class="percent">30%</div>
                  </div>
                  <div class="progress progress-striped">
                    <div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100" style="width: 30%">
                      <span class="sr-only">30% Complete (warning)</span>
                    </div>
                  </div>
                </a>
              </li>
              <li>
                <a href="#">
                  <div class="task-info">
                    <div class="desc">Digital Marketing</div>
                    <div class="percent">80%</div>
                  </div>
                  <div class="progress progress-striped">
                    <div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100" style="width: 80%">
                      <span class="sr-only">80% Complete</span>
                    </div>
                  </div>
                </a>
              </li>
              <li>
                <a href="#">
                  <div class="task-info">
                    <div class="desc">Logo Designing</div>
                    <div class="percent">78%</div>
                  </div>
                  <div class="progress progress-striped">
                    <div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="78" aria-valuemin="0" aria-valuemax="100" style="width: 78%">
                      <span class="sr-only">78% Complete (danger)</span>
                    </div>
                  </div>
                </a>
              </li>
              <li>
                <a href="#">
                  <div class="task-info">
                    <div class="desc">Mobile App</div>
                    <div class="percent">50%</div>
                  </div>
                  <div class="progress progress-striped active">
                    <div class="progress-bar" role="progressbar" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100" style="width: 50%">
                      <span class="sr-only">50% Complete</span>
                    </div>
                  </div>

                </a>
              </li>
              <li class="external">
                <a href="#">See All Tasks</a>
              </li>
            </ul>
          </li> -->
						<!-- task notificatoin end -->
			<!-- <span style="font-weight: "></span> -->
					</ul>
					<!-- notificatoin dropdown end-->
				</div>
				
				
				 <div style="padding-left: 47%; padding-top: 1%; border: 0px solid red;">      
					<!-- logo start -->
					   <a href="index.action" class="title">FINAL <span style="color: rgb(255, 82, 82);">INS</span></span></a>
					<!-- logo end -->
				 </div> 
				
			</div>
				

			<!-- <ul>
				<li rowspan="2"><input></li>
				<li rowspan="2"><img /></li>
				<li></li>
			</ul>
			<ul>
				<li></li>			
			</ul> -->


			
				
			</header>
		</c:if>
		<!--header end-->
		

		