<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" >


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
	    
	    getArchive();
	   
	    $("#addList").addClass("hidden");
		$(".div-addcard").hide();
		
		//addcard 클릭시 인풋창
		$(".addCardstyle").click(function(event){
			$(this).hide();
			$(this).prev().show();
		});
		
	    //addlist 클릭시 인풋창
	    $("#addListShow").click(function(event){
	    	$("#addList").removeClass("hidden");
	    	$("#addListShow").addClass("hidden");
	    	$("#listname").focus();
	    }); 

	    //리스트명 인풋창에서 엔터키를 누르는 경우 함수 호출
		$("#listname").keydown(function(event){
			if(event.keyCode == 13){
				insertList();
			}
		}); 	 
	    
	    //addList에서 취소버튼을 누른 경우
	    $("#btn_listCancel").click(function(event){
	    	$("#addList").addClass("hidden");
	    	$("#addListShow").removeClass("hidden");
	   
	    });
	    
     	//리스트제목 클릭시 인풋창 스타일 변경, 제목 변경
	    $(document).on("click", '.listname', function(event){
	    	$(this).hide();
	    	$(this).parent().find(".newval").show();
    	});
	    
	    $(document).on("keypress", '.newval', function(event){
    		if(event.keyCode == 13){
    			changeListName(this, true);
    		}
    	});
	    
	    $(document).on("blur", '.newval', function(event){
    		changeListName(this, false);
    	});
	    
	    // 리스트 삭제 버튼 클릭 시
	    $(document).on("click", '.removeList', function(event){
	    	if(confirm("리스트를 삭제하시겠습니까?")) {
	    		var project_idx = "${projectInfo.project_idx}";
	    		var $listDiv = $(this).closest(".listDiv");
	    		var list_idx = $listDiv.find(".update_idx").val();
	    		var form_data = {"project_idx" : project_idx, "list_idx" : list_idx, "delete_type" : "D"};
	    		
				$.ajax({
					url: "updateListDeleteStatus.action",
					type: "POST",
					data: form_data,    
					dataType: "JSON",
					success: function(data){
						if(data.result == "2") {
							$listDiv.remove();
						}
					},
					error: function(request, status, error){ 
						alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
					}
				}); // end of $.ajax  
	    	}
    	});
	    
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

		
		$(".btn_cardCancel").click(function(){ //cancel버튼 클릭시 카드생성 div 숨기는 이벤트
			$(this).prev().prev().prev().val("");
			$(this).parent().hide();
			$(this).parent().next().show();
		});
		
		$(document).on("click", ".btn-addcard", function(){ //addcard버튼 클릭시 카드 생성하는 이벤트
			var card_title = $(this).prev().prev().val().trim(); //카드 타이틀
			var card_title_length = $(this).prev().prev().val().length;
			var list_idx = $(this).next().next().val();//리스트idx
			var userid = "${sessionScope.loginuser.userid}";//유저 아이디
			var $listDiv = $(this).closest(".listDiv");
			
			if(card_title_length == 0){
				alert("카드 타이틀은 공백으로 할 수 없습니다.");
				$(this).prev().prev().val("");
				$(this).prev().prev().focus();
				return;
			}
			else if(card_title_length > 200){
				alert("카드 타이틀은 한글200자, 영문400자 이내로 입력해주세요.");
				$(this).prev().prev().val("");
				$(this).prev().prev().focus();
				return;
			}
			
		 	if(card_title != "" && userid != null && list_idx != "" && card_title_length <= 200){
				var addCard_data = {"userid" : userid, "list_idx" : list_idx, "card_title" : card_title};
				$.ajax({
					url: "addCard.action",
					type: "POST",
					data: addCard_data,
					dataType: "JSON",
					success: function(data){
						if(data.result == 1){
						//	location.reload();
							//alert("카드를 생성했습니다.");
							var html = "<div class='panel panel-default'>"
									 + "	<div class='panel-body' onclick='NewWindow(\"carddetail.action?projectIDX=${projectInfo.project_idx}&listIDX="+list_idx+"&cardIDX="+data.card_idx+"\",\"window_name\",\"800\",\"710\",\"yes\");return false' style='word-break:break-all;white-space:normal;'>"
									 + card_title
									 + "	</div>"
									 + "</div>";
							$listDiv.find(".card-wrapper").append(html);
							$listDiv.find(".btn_cardCancel").click();
						}
						else{
							alert("카드 생성에 실패했습니다.");
						}
					},
					error: function(request, status, error){ 
				         alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
				    }
				}); //end of $.ajax  */
			}
		}); // end of $(".btn-addcard").click
	}); // end of $(document).ready
	
	function changeListName(obj, blur) {
    	var contentid = $(obj).parent("id"); //클릭한 리스트 아이디
    	var list_idx = $(obj).parent().children('.update_idx').val();
    	var oldval = $(obj).parent().children('.oldval').val();
		var newval = $(obj).val().trim();
		if(newval == "") {
			$(obj).val(oldval);
			newval = oldval;
		}
    	var form_data = {"newtitle" : newval, "oldtitle" : oldval, "list_idx" : list_idx};
		 $.ajax({ 
			url: "updateListTitle.action",
			type: "POST",
			data: form_data,
			dataType: "JSON",
			success: function(data){
				if(data.resultTitle == newval){
					$(obj).val(data.resultTitle);
					if(blur) $(obj).blur();
					$(obj).parent().find('.oldval').val(data.resultTitle);
					$(obj).parent().find(".listname").text(data.resultTitle);
					$(obj).parent().find(".listname").show();
					$(obj).hide();
				}
				else{
					$(obj).val(oldval);
				}
			},
			error: function(request, status, error){ 
				//alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
				$(obj).val(oldval);
			}
		}); 
    }
	
	function getArchive() {
    	var project_idx = "${projectInfo.project_idx}";
    	var form_data = {"project_idx" : project_idx};
    	$.ajax({
			url: "getArchive.action",
			type: "POST",
			data: form_data,    
			dataType: "JSON",
			success: function(data){
				var html = "";
				$(".showMenu").find(".dropdown-menu div").empty();
				$.each(data, function(i, v) {
					html = "<span data-list-idx="+v.list_idx+" onclick='recoverList(this)'>"+v.list_name+"</span><br/>";
					$(".showMenu").find(".dropdown-menu div").append(html);
				});
			},
			error: function(request, status, error){ 
				alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
			}
		}); // end of $.ajax  
    }
	
	function recoverList(obj) { //리스트 복구하는 함수
		if(confirm("리스트를 복구하시겠습니까?")) {
			var project_idx = "${projectInfo.project_idx}";
			var list_idx = $(obj).data("listIdx");
			var form_data = {"project_idx" : project_idx, "list_idx" : list_idx, "delete_type" : "R"};
			
			$.ajax({
				url: "updateListDeleteStatus.action",
				type: "POST",
				data: form_data,    
				dataType: "JSON",
				success: function(data){ 
					if(data.result == "2") {
						getArchive();
						//리스트 복구 후 empty 후 리스트 갱신
					}
				},
				error: function(request, status, error){ 
					alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
				}
			}); // end of $.ajax 
		}
	}
	
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
					if(data.result == 2){
					var html = "<div class='well well2 listDiv' style='width:300px;display:inline-block; vertical-align: top; border-radius: 1em;'>"
							 + "<p class='listname' style='width:85%; cursor: pointer; background-color: transparent; border: none; font-size: 14pt; color: gray; font-weight: bold; word-break:break-all; white-space:normal; display:inline-block;'>"+data.list_name+"</p>"
							 + "	<input type='text' class='project_listname newval' value='" + data.list_name + "' style='cursor:pointer;  background-color:transparent; border:none; font-size: 14pt; color: gray; font-weight: bold; display:none;' maxlength='25'/>"
							 + "	&nbsp;&nbsp;&nbsp;<i class='fa fa-trash removeList' style='font-size: 24px;vertical-align:top;cursor:pointer;'></i>"
							 + "	<input type='hidden' class='project_listname oldval' value='" + data.list_name + "'/>"
		 					 + "	<input type='hidden' class='update_idx' value='" + data.list_idx + "' maxlength='4'/>"
		 					 + "	<div class='card-wrapper' style='max-height:500px;overflow-y:auto; margin-top: 5%;'>"
		 					 + "	</div>"
							 + "	<div style='margin-top: 5%;'>"
							 + "    <div class='div-addcard'>"
							 + "    	<textarea rows='2' cols='33' placeholder='Enter card title...'></textarea><br/>"
							 + "    	<button class='btn btn-default btn-addcard' style='margin-top: 10px;'>add Card</button>"
							 + "        <button class='btn btn-default btn_cardCancel' style='margin-top: 10px;'>cancel</button>"
							 + "    	<input type='hidden' value='" + data.list_idx + "'>"
							 + "    </div>"
							 + "    <span style='font-size: 12pt; color: gray; cursor: pointer;'  class='addCardstyle'><i class='fa fa-plus'></i>&nbsp;add another card...</span>"
			   				 + "</div>";
			   				 
			   				 $(".listDiv:last").after(html);
			   				 $(".div-addcard").hide();
			   				 
			   				 $("#listname").val("");
			   				 $("#addList").addClass("hidden");
			   				 $("#addListShow").removeClass("hidden");

			   				 $(".addCardstyle").click(function(){
			   						$(this).hide();
			   						$(this).prev().show();
			   					});
			   				 
			   				$(".btn_cardCancel").click(function(){ //cancel버튼 클릭시 카드생성 div 숨기는 이벤트
			   						$(this).prev().prev().prev().val("");
			   						$(this).parent().hide();
			   						$(this).parent().next().show();
			   					});
			   				 
			   				/* $(".btn-addcard").click(function(){ //addcard버튼 클릭시 카드 생성하는 이벤트
			   					var card_title = $(this).prev().prev().val().trim(); //카드 타이틀
			   					var card_title_length = $(this).prev().prev().val().length;
			   					var list_idx = $(this).next().next().val();//리스트idx
			   					var userid = "${sessionScope.loginuser.userid}";//유저 아이디
			   				
			   					console.log("카드타이틀 확인: " + card_title + "  리스트idx확인: " + list_idx + "   유저아이디 확인: " + userid);
			   					if(card_title_length == 0){
			   						alert("카드 타이틀은 공백으로 할 수 없습니다.");
			   						$(this).prev().prev().val("");
			   						$(this).prev().prev().focus();
			   						return;
			   					}
			   					else if(card_title_length > 200){
			   						alert("카드 타이틀은 한글200자, 영문400자 이내로 입력해주세요.");
			   						$(this).prev().prev().val("");
			   						$(this).prev().prev().focus();
			   						return;
			   					}
			   					
			   				 	if(card_title != "" && userid != null && list_idx != "" && card_title_length <= 200){
			   						var addCard_data = {"userid" : userid, "list_idx" : list_idx, "card_title" : card_title};
			   						 $.ajax({
			   							url: "addCard.action",
			   							type: "POST",
			   							data: addCard_data,
			   							dataType: "JSON",
			   							success: function(data){
			   								if(data.result == 1){
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
			   				}); // end of $(".btn-addcard").click */
			   				
			   				//리스트제목 클릭시 인풋창 스타일 변경, 제목 변경
			   			    $(".well2").click(function(){
			   			    	var list_idx = $(this).children('.update_idx').val();
			   			    	var oldval = $(this).children('.oldval').val();
			   			    	
			   			    	$(this).children('.newval').keyup(function(){
			   			    		var newval = $(this).val();
			   			    		if(event.keyCode == 13){
			   							
			   			    			var form_data = {"newtitle" : newval, "oldtitle" : oldval, "list_idx" : list_idx};
			   			    			 $.ajax({ 
			   			    				url: "updateListTitle.action",
			   			    				type: "POST",
			   			    				data: form_data,
			   			    				dataType: "JSON",
			   			    				success: function(data){
			   			    					if(data.resultTitle == newval){
			   			    						$(this).val(data.resultTitle);
			   			    					}
			   			    					else{
			   			    						alert("리스트 제목 변경에 실패했습니다.");
			   			    					}
			   			    				},
			   			    				error: function(request, status, error){ 
			   			    					alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
			   			    				}
			   			    			}); 
			   			    		}
			   			    	});
			   			    }); // end of $(".well").click
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
	
	
	
	var win = null;
	function NewWindow(mypage,myname,w,h,scroll){
	LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
	TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
	settings =
	'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',scrollbars='+scroll+',resizable'
	win = window.open(mypage,myname,settings)
	} 
	
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
 	   opacity: 0.9;
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
  
  .hidden {
  	display: none;
  }
  
  .project_member{
   /*  background-color: #d6dadc; */
    border-radius: 25em;
    color: #444;
    cursor: pointer;
    display: block;
    float: left;
    height: 32px;
	padding-top: 8px;
    margin-top: 1px;
    margin-bottom: 2px;
    overflow: visible;
    position: inherit;
  }

  .member_avatar{
    height: 40px;
    width: 40px;
    border-radius: 25em;
    margin-left: 60%;
    margin-top: 19%;
  }
  
  .drop_img{
  height: 65px;
    width: 65px;
    border-radius: 25em;
  }
  
  .dropdown_member{
  	background-color: black;
  	left: 60%;
  }
  
  .img_style{
  	margin-left: 10px;
  	font-size: 13pt;
  	color: white;
  	font-weight: bold;
  }
  
  /* width */
::-webkit-scrollbar {
    width: 7px;
}

/* Track */
::-webkit-scrollbar-track {
    background: white; 
}
 
/* Handle */
::-webkit-scrollbar-thumb {
    background: #f1f1f1; 
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
    background: #555; 
}
  
</style>

<nav class="navbar navbar-inverse"
	style="width: 100%; margin-top: 20px; height: 30px; position: fixed; opacity: 0.7;">
	<div class="container-fluid">
		<div class="navbar-header">
			<a class="navbar-brand" href="#" onClick="window.location.reload();return false;"><span style="color: yellow;">${projectInfo.project_name}</span></a>
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
			<!-- 팀명 -->
		<li><a href="<%=request.getContextPath()%>/showTeam.action?team_idx=${projectInfo.team_idx}">team:&nbsp;&nbsp;
			<span style="font-size: 12pt; color: yellow; font-weight: bold;">${projectInfo.team_name}</span></a></li>
		</ul>
		
	
		<!-- 프로젝트 멤버 프로필사진 -->
		<c:if test="${memberInfo.size() > 0}">
			<c:forEach items="${memberInfo}" var="member" >
				<ul class="nav navbar-nav">
					<li class="dropdown">
					<img class="member_avatar dropdown-toggle" src="<%=request.getContextPath()%>/resources/files/${member.server_filename}" data-toggle="dropdown">
						<ul class="dropdown-menu dropdown_member">
							<li style="min-width: 250px; min-height: 100px; padding-left: 10px; padding-top: 5px;">
							<div style="width: inherit; height: inherit;">
							<img class="drop_img" src="<%=request.getContextPath()%>/resources/files/${member.server_filename}">
							<span class="img_style">${member.nickname}</a></span><br/>
							<span class="img_style">${member.email}</span><br/>
							<span class="img_style">${member.userid}</span><br/>
							</div>
							</li>
						</ul>
					</li>
				</ul>
			</c:forEach>
		</c:if>
		<ul class="nav navbar-nav navbar-right showMenu">
			<li class="dropdown">
			<button class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="true">...Show Menu</button>
				<ul class="dropdown-menu">
					<li style="min-width: 250px; min-height: 100px; padding-left: 10px; padding-top: 5px;">
					<div style="width: inherit; height: inherit;"></div>
					</li>
				</ul>
			</li>
		</ul>
		<!-- <p align="right">
			
			<button class="btn btn-default" type="button" id="menu1"
				style="background-color: black; margin-top: 5px; margin-bottom: 5px; color: black; border-color: black;">
				<span style="font-size: 13pt; color: yellow;">...Show Menu</span>
			</button>
		</p> -->
	</div>
</nav>

<div class="list-wrapper" >
	<c:if test="${listvo == null || listvo.size() == 0}">
		<div id="addListShow" class="well list-hover"
			style="width: 300px; display: inline-block; vertical-align: top; border-radius: 1em;">
			<div class="addListstyle" id="addListstyle">
				<label for="addListstyle"> <span
					style="font-size: 14pt; color: gray; font-weight: bold; padding-bottom: 10%; cursor: pointer;"><i
						class="fa fa-plus"></i>&nbsp;add another list...</span>
				</label>
			</div>
		</div>
		<div id="addList" class="well list-hover"
			style="width: 300px; display: inline-block; vertical-align: top; border-radius: 1em;">
			<div class="div-listname" id="div-listname">
				<input type='text' class='list-title' id="listname"
					placeholder="Enter list title..." maxlength="25">
				<button class="btn btn-default" style="margin-top: 10px;"
					onClick="insertList();">add List</button>
				<button class="btn btn-default"
					style="margin-top: 10px; padding-left: 10px;" id="btn_listCancel">cancel</button>
			</div>
		</div>
	</c:if>

	<c:if test="${listvo.size() != 0}">
		<c:forEach items="${listvo}" var="vo" varStatus="status">
			<c:if test="${vo.list_delete_status != 0 }">
				<!--  list_delete_status != 0 인 경우에만 리스트 노출 -->
				<div id="list${status.count}" class="well well2 listDiv"
					style="width: 300px; display: inline-block; vertical-align: top; border-radius: 1em;">
					<p class="listname" style="width:85%; cursor: pointer; background-color: transparent; border: none; font-size: 14pt; color: gray; font-weight: bold; word-break:break-all; white-space:normal; display:inline-block;">${vo.list_name}</p>
					<input type="text" class="project_listname newval" value="${vo.list_name}" style="cursor: pointer; background-color: transparent; border: none; font-size: 14pt; color: gray; font-weight: bold; display:none;" maxlength="25" /> 
					&nbsp;&nbsp;&nbsp;<i class="fa fa-trash removeList" style="font-size: 24px;vertical-align:top;cursor:pointer;"></i>
					<input type="hidden" class="project_listname oldval" value="${vo.list_name}" /> 
					<input type="hidden" class="update_idx" value="${vo.list_idx}" maxlength="4" />
					<div class="card-wrapper" style="max-height: 595px; overflow-y: auto; margin-top: 5%;">
						<c:if test="${vo.cardlist != null}">
							<c:forEach items="${vo.cardlist}" var="cardvo">
								<div class="panel panel-default">
									<div class="panel-body" onClick="NewWindow('carddetail.action?projectIDX=${vo.fk_project_idx}&listIDX=${cardvo.fk_list_idx}&cardIDX=${cardvo.card_idx}','window_name','800','710','yes');return false" style="word-break:break-all;white-space:normal;"> 
										${cardvo.card_title}
									</div>
								</div>
							</c:forEach>
						</c:if>
					</div>
					<div style="margin-top: 5%;">
						<div class="div-addcard">
							<textarea class="addcard-TA" rows="2" cols="33" placeholder="Enter card title..."></textarea>
							<br />
							<button class="btn btn-default btn-addcard" style="margin-top: 10px;">add Card</button>
							<button class="btn btn-default btn_cardCancel" style="margin-top: 10px;">cancel</button>
							<input type="hidden" value="${vo.list_idx}">
						</div>
						<span style="font-size: 12pt; color: gray; cursor: pointer;" id="addCardstyle${status.count}" class="addCardstyle">
						<i class="fa fa-plus"></i>&nbsp;add another card...</span>
					</div>
				</div>
			</c:if>
		</c:forEach>
		<div id="addListShow" class="well list-hover"
			style="width: 300px; display: inline-block; vertical-align: top; border-radius: 1em;">
			<div class="addListstyle" id="addListstyle">
				<label for="addListstyle"> <span
					style="font-size: 14pt; color: gray; font-weight: bold; padding-bottom: 10%; cursor: pointer;"><i
						class="fa fa-plus"></i>&nbsp;add another list...</span>
				</label>
			</div>
		</div>
		<div id="addList" class="well list-hover"
			style="width: 300px; display: inline-block; vertical-align: top; border-radius: 1em;">
			<div class="div-listname" id="div-listname">
				<input type='text' class='list-title' id="listname"
					placeholder="Enter list title..." maxlength="25">
				<button class="btn btn-default" style="margin-top: 10px;"
					onClick="insertList();">add List</button>
				<button class="btn btn-default"
					style="margin-top: 10px; padding-left: 10px;" id="btn_listCancel">cancel</button>
			</div>
		</div>
	</c:if>
</div>

<form name="updateFavorite">
	<input type="hidden" name="userid" value="${projectInfo.member_id}">
	<input type="hidden" name="favorite_status"
		value="${projectInfo.project_favorite}" id="favorite_status">
	<input type="hidden" name="project_idx"
		value="${projectInfo.project_idx}">
</form>