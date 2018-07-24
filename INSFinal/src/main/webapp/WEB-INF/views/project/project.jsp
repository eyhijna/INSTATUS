<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    


<script type="text/javascript">
	$(document).ready(function(){
		if(${sessionScope.loginuser == null}){
			alert("로그인이 필요합니다.");
			location.href = "<%=request.getContextPath()%>/index.action";
			return;
		}
		
		var star = "<i class='fa fa-star'></i>";
		var star_empty = "<i class='fa fa-star-o'></i>";
	
		
	    if(${projectInfo.project_favorite} == 0) { //초기화면에서 즐겨찾기 노출
	    	$(".clickA").html(star_empty);
	    }
	    else {
	    	$(".clickA").html(star);
	    } 
	   
	    $(".div-listname").hide();
		$(".div-addcard").hide();
		
		//addcard 클릭시 인풋창
		$(".addCardstyle").click(function(event){
		//	alert("아이디 확인용:" + $(this).attr("id"));
			$(this).hide();
			$(this).prev().show();
		});
		
	    //addlist 클릭시 인풋창
	    $("#addList").click(function(event){
	    	$("#addListstyle").hide();
	    	$(".div-listname").show();
	    	$("#listname").focus();
	 		$("#addList").removeClass("list-hover");
	 		$("#addList").css("opacity", "1.0");
	    }); 

	    //리스트명 인풋창에서 엔터키를 누르는 경우 함수 호출
		$("#listname").keydown(function(event){
			if(event.keyCode == 13){
				insertList();
			}
		}); 	 

	    
	/*     //리스트제목 클릭시 인풋창 스타일 변경, 제목 변경
	    $(".well").click(function(){
	  //  	var contentid = $(this).attr("id"); //클릭한 리스트 아이디
	  //  	var oldval = $(this).children('input').val();
	  //  	var newval = $(this).children('.newval').val();
	    	var oldval = $(this).children('.oldval').val();
	    	
	    	 $(this).keydown(function(event){
	    		if(event.keyCode == 13){
	    			;
	    			alert("new: " + newval + "   /  old: " + oldval);
	    			//	alert("리스트명 수정할까");
				//	var editList = 
				}
	    	}); 
	    }); */
	    
	    
		$("#mycontent").addClass("example1"); //프로젝트 배경이미지 노출
		
		$(".clickA").click(function(event){ //즐겨찾기 클릭시 즐겨찾기status값 update 
			event.preventDefault(); // href로 연결해 주지 않고 단순히 click에 대한 처리를 하도록 해준다.
			var form_data = $("form[name=updateFavorite]").serialize();
	
			$.ajax({
				url: "updateFavoriteStatus.action",
				type: "POST",
				data: form_data,    
				dataType: "JSON",
				success: function(data){
					if(data.project_favorite == "1") {
						$(".clickA").html(star);
						$("#favorite_status").val(data.project_favorite);
					}
					else {
						$(".clickA").html(star_empty);
						$("#favorite_status").val(data.project_favorite);
					} 
				},
				error: function(request, status, error){ 
					alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
				}
			}); // end of $.ajax  
		}); // end of $(".clickA").click

		
		
		$(".btn-addcard").click(function(){ //addcard버튼 클릭시 카드 생성하는 이벤트
			var card_title = $(this).prev().prev().val().trim(); //카드 타이틀
			var card_title_length = $(this).prev().prev().val().length;
			var list_idx = $(this).next().val();//리스트idx
			var userid = "${sessionScope.loginuser.userid}";//유저 아이디
		
			if(card_title_length == 0){
				alert("카드 타이틀은 공백으로 할 수 없습니다.");
				$(this).prev().prev().val("");
				$(this).prev().prev().focus();
				return;
			}
			else if(card_title_length > 400){
				alert("카드 타이틀은 한글200자, 영문400자 이내로 입력해주세요.");
				$(this).prev().prev().val("");
				$(this).prev().prev().focus();
				return;
			}
			
		 	if(card_title != "" && userid != null && list_idx != "" && card_title_length <= 400){
				var addCard_data = {"userid" : userid, "list_idx" : list_idx, "card_title" : card_title};
				$.ajax({
					url: "addCard.action",
					type: "POST",
					data: addCard_data,
					dataType: "JSON",
					success: function(data){
						if(data.result == 1){
						//	alert("카드가 생성되었습니다.");
							location.reload();
						}
						else{
							alert("카드 생성에 실패했습니다.");
						}
					},
					error: function(request, status, error){ 
				         alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
				    }
				}); //end of $.ajax 
			}
		}); // end of $(".btn-addcard").click
	}); // end of $(document).ready
	
	
	function insertList(){ //리스트를 추가하는 함수
		var list_name = $("#listname").val().trim();
		var project_idx = "${projectInfo.project_idx}";
		var userid = "${sessionScope.loginuser.userid}";
		
		if(list_name == ""){
			alert("리스트 이름은 공백으로 할 수 없습니다.");
			$("#listname").val("");
			$("#listname").focus();
			return;
		}
		else{
			var form_data = {"list_name" : list_name, "project_idx" : project_idx, "userid" : userid};
			
			$.ajax({
				url: "addList.action",
				type: "POST",
				data: form_data,
				dataType: "JSON",
				success: function(data){
					if(data.result == 1){
						alert("리스트가 생성되었습니다.");
						location.reload();
					}
					else{
						alert("리스트 생성에 실패했습니다.");
					}
				},
				error: function(request, status, error){ 
			         alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
			    }
			}); // end of $.ajax
		}
	} // end of insertList
	
	
	////////////////////////////////////////////////////////
	
</script>

<style type="text/css">

 #mycontainer	{height:inherit;}
 
 .fa-star{font-size:20px; color:yellow;}
 .fa-star-o{font-size:20px; color: yellow;}
 .panel-body{overflow-y: auto;}
 
 .example1{ 
  background-image: url("./resources/images/${project_image_name}"); 
  background-color: white;
  background-size: cover;
  background-attachment: fixed;
  background-repeat: repeat-x;
  height: inherit; 
 }
 
 
 .list-hover{opacity: 0.1;}
 .list-hover:hover{opacity: 1.0;}
 
 .colStyle{cursor: pointer;}
 
 .list-wrapper{
 	white-space:nowrap;
 	overflow-x: auto;
 	overflow-y: hidden;
 	height:inherit;
 	padding-top: 40px;
 	padding-left: 20px;
 	padding-right: 10px;
 }
 
 .list-wrapper .well {
 	margin-right:10px;
 }
 
 .well{margin-top: 50px;
 	   opacity: 0.8;
 	   max-height: inherit;}
 
 .list-wrap{
 width: 272px;
 margin: 0 4px;
 height: 100%;
 /* box-sizing: border-box; */
 vertical-align: top;
 white-space: nowrap;
 }
 
  
 .list-title{
 display: block;
  width: 270px;
  height: 34px;
  padding: auto;
  font-size: 14px;
  line-height: 1.428571429;
  color: #8e8e93;
  vertical-align: middle;
/*   background-color: #ffffff; */
 /*  border: 1px solid #c7c7cc; */
  border: none;
  border-radius: 4px;  
  -webkit-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
  transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
 }
 
 .assign-to-team-list-item-content, .assign-to-team-create-content {
  cursor: pointer;
  &:hover {
    background: @light-gray-300;
  }
  border-radius: 4px;

  &.disabled {
    color: @quietcolor;
    cursor: default;
  }
}


</style>

	   <nav class="navbar navbar-inverse" style="width: 100%; margin-top: 20px; height: 30px; position: fixed; opacity: 0.7;">
		  <div class="container-fluid">
		    <div class="navbar-header" >
		      <a class="navbar-brand" href="#" ><span style="color: yellow;">${projectInfo.project_name}</span></a>
		    </div>
		    <ul class="nav navbar-nav">
	      	    <li id="favorite"><a class="clickA" href="#"></a></li>

		      	<c:if test="${projectInfo.project_visibility == '0'}">
		      		<li><a href="#">team visibility</a></li>
		      	</c:if>
		      	<c:if test="${projectInfo.project_visibility == '1'}">
		      		<li><a href="#">private</a></li>
		      	</c:if>
		      	<c:if test="${projectInfo.project_visibility == '2'}">
		      		<li><a href="#">public</a></li>
		      	</c:if>
		    </ul>
		    <p align="right">
		    <button class="btn btn-default" type="button" id="menu1" style=" background-color: black; margin-top: 5px; margin-bottom: 5px; color: black; border-color: black; "> 
	    		<span style="font-size: 13pt; color: yellow;">...Show Menu</span>
	   		</button></p>
		  </div>
	</nav> 

	<div class="list-wrapper">
	<c:if test="${listvo == null || listvo.size() == 0}">
		<div id="addList" class="well list-hover" style="width: 300px; display: inline-block; vertical-align: top; border-radius: 1em;">
			<label for="addListstyle">
				<span style="font-size: 14pt; color: gray; font-weight: bold;" id="addListstyle"><i class="fa fa-plus"></i>&nbsp;add another list...</span>
			</label>
			<div class="div-listname">
				<input type='text' class='list-title' id="listname" placeholder="Enter list title..." maxlength="30">
				<button class="btn btn-default" style="margin-top: 10px;" onClick="insertList();">add List</button>
			</div>
		</div>
	</c:if>
	
	<c:if test="${listvo.size() != 0}">
		<c:forEach items="${listvo}" var="vo" varStatus="status">
			<c:if test="${vo.list_delete_status != 0 }"><!--  list_delete_status != 0 인 경우에만 리스트 노출 -->
				<div id="list${status.count}" class="well list-hover" style="width:300px;display:inline-block; vertical-align: top; border-radius: 1em;">
					<input type="text" class="project_listname newval" value="${vo.list_name}" style="background-color:transparent; border:none; font-size: 14pt; color: gray; font-weight: bold;"/>
					&nbsp;&nbsp;&nbsp;<!-- <i class="fa fa-trash-o" style="font-size: 25px;"></i> --><i class="fa fa-align-justify" style="font-size:24px"></i>
		 			<input type="hidden" class="project_listname oldval" value="${vo.list_name}" style="background-color:transparent; border:none; font-size: 14pt; color: gray; font-weight: bold;"/>
					<div class="card-wrapper" style="max-height:500px;overflow-y:auto; margin-top: 5%;">
					<c:if test="${vo.cardlist != null}">
						<c:forEach items="${vo.cardlist}" var="cardvo">
							<div class="panel panel-default">
							<%-- <div class="panel-body" onClick="location.href='<%=request.getContextPath()%>/carddetail.action?projectIDX=${vo.fk_project_idx}&listIDX=${cardvo.fk_list_idx}&cardIDX=${cardvo.card_idx}'">${cardvo.card_title}</div> --%>
							<div class="panel-body" onClick="window.open('carddetail.action?projectIDX=${vo.fk_project_idx}&listIDX=${cardvo.fk_list_idx}&cardIDX=${cardvo.card_idx}','window_name','width=800,height=710,location=no,status=no,scrollbars=yes');">${cardvo.card_title}</div>
							</div>
						</c:forEach>
					</c:if>
						<!-- <div class="panel panel-default">
							<div class="panel-body">카드 내용</div>
						</div> -->
					</div> 
					<div style="margin-top: 5%;">
						<div class="div-addcard">
							<textarea rows="2" cols="33" placeholder="Enter card title..."></textarea><br/>
							<button class="btn btn-default btn-addcard" style="margin-top: 10px;" >add Card</button>
						<!-- 	<button type="button" class="close">&times;</button> -->
							<input type="hidden" value="${vo.list_idx}">
						</div>
						<span style="font-size: 12pt; color: gray;" id="addCardstyle${status.count}" class="addCardstyle"><i class="fa fa-plus"></i>&nbsp;add another card...</span>
					</div>
					
			    </div>
	    	</c:if>
		</c:forEach>
		
		
		<div id="addList" class="well list-hover" style="width: 300px; display: inline-block; vertical-align: top; border-radius: 1em;">
			<label for="addListstyle">
				<span style="font-size: 14pt; color: gray; font-weight: bold; padding-bottom: 10%;" id="addListstyle"><i class="fa fa-plus"></i>&nbsp;add another list...</span>
			</label>
			<div class="div-listname">
				<input type='text' class='list-title' id="listname" placeholder="Enter list title..." maxlength="30">
				<button class="btn btn-default" style="margin-top: 10px;" onClick="insertList();">add List</button>
			</div>
		</div>
	</c:if>
	</div>
	
<form name="updateFavorite">
	<input type="hidden" name="userid" value="${projectInfo.member_id}">
	<input type="hidden" name="favorite_status" value="${projectInfo.project_favorite}" id="favorite_status">
	<input type="hidden" name="project_idx" value="${projectInfo.project_idx}">
</form>