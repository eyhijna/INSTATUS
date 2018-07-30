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
		
//////////////////////////////////////////////////민재 ///////////////////////////////////////////////////////////////////////////////		
		$("#listsearchINproject").keyup(function(){
			
			 // alert("실행성공이다222222222222");
			 
			  if(${sessionScope.loginuser == null}){
					alert("로그인이 필요합니다.");
					location.href = "<%=request.getContextPath()%>/index.action";
					return;
			  }
			
			  if($("#listsearchINproject").val().trim() != ""){
				  
				  if($("#sel3").val() == 'list'){
					
					  searchListINproject();
					  
				  }
				  else if($("#sel3").val() == 'card'){
					  
					  searchCardINproject();
					  
				  }
				   
			  }
			  
			  if($("#listsearchINproject").val().trim() == ""){
				 
				 	projectINlistRe();
				 	
			  } 
			  
		   }); // $("#search_input").keyup()-------------------------------------------------------------------
		
		
		
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
	
///////////////////////////////////////////////////////// 민재 //////////////////////////////////////////////////////////////////////////////
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
	}
	
	
	
	function leaveProject(){
		
	//	var fk_project_idx = "${projectInfo.project_idx}";
		
		var frm = document.leaveProjectFrm;
				
		frm.method = "GET";
		frm.action = "<%= request.getContextPath() %>/leaveProject.action";
		frm.submit();
		
	}
	
	
	function deleteProject(){
		
		/* var fk_project_idx = "${projectInfo.project_idx}"; */
		
		var frm = document.leaveProjectFrm;
				
		frm.method = "GET";
		frm.action = "<%= request.getContextPath() %>/deleteProject.action";
		frm.submit();
		
	}
	
	function Activity(val){
				
		var form_data1 = {fk_project_idx: "${projectInfo.project_idx}", 
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
							
							if(val == '생성'){
								html += "<tr>";
								html += "<td rowspan='3' class='imgtd' style='size: 10px;'><img class='drop_img' src='<%=request.getContextPath()%>/resources/files/"+entry.server_filename+"'></td>";
								html += "<td style='font-weight: bold;'>"+entry.record_userid+"&nbsp;&nbsp;"+entry.record_dml_status+"</td>";
								html += "</tr>";
								html += "<tr>";
								html += "<td  style='font-size: 8pt;'>&nbsp;"+entry.project_record_time+"</td>";
								html += "</tr>";
								/* html += "<tr>";
								html += "<td style='font-size: 8pt; color: #b3b3b3;'>"+entry.card_title+"</td>"; 
								html += "</tr>";
 */								html += "<tr>";
								html += "<td colspan='2' style='border: 1px solid #fed189;'></td>";
								html += "</tr>";
							}
							
							else{
								
								html += "<tr>";
								html += "<td rowspan='3' class='imgtd' style='size: 10px;'><img class='drop_img' src='<%=request.getContextPath()%>/resources/files/"+entry.server_filename+"'></td>";
								html += "<td style='font-weight: bold;'>"+entry.record_userid+"&nbsp;&nbsp;"+entry.record_dml_status+"</td>";
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
							
							
						 }
						
					});
					
					$("#projectRecordListTB").html(html);
					
					 if(json.length > 10 ){  
						
						html += "<tr style='height: 50px; text-align:center; border: 1px solid red;' >";
						html += "<td colspan='2' style='padding-top: 15px;'>";
						html += "<a style='cursor: pointer; color: #00a0df;' id='viewallactivity'>view all activity</a></td>"; 
						html += "</tr>";
						
				 	 } 
					
					$("#projectRecordListTB").html(html);
					
					$("#activitylist").html(html);
					
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
	
	
	$(document).on("click", "#viewallactivity", function(event){
		
		// alert("실행 성공");
		
		var val = $("#sel1").val();
		
		var form_data1 = {fk_project_idx: "${projectInfo.project_idx}", 
		          		  sel1Val: val}   
		
		$.ajax({
			url: "<%= request.getContextPath()%>/projectRecordView.action",
			type: "get",
			data: form_data1,
			dataType: "json",
			success: function(json){
								
				var html = "";
								
				openNav3();
				
				if(json.length > 0){
					
					$.each(json, function(entryIndex, entry){
						
						html += "<tr>";
						html += "<td rowspan='3' class='imgtd' style='size: 10px;'><img class='drop_img' src='<%=request.getContextPath()%>/resources/files/"+entry.server_filename+"'></td>";
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
					
						$("#projectRecordListMoreTB").html(html);
					
					}); // end of $.each(json)------------------------------------------------------------ 
				 						
				}
					
					$("#activitylistMore").html(html); 
				
			},
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
		    }
		});
		
			
	});
			
	/* 프로젝트 내 리스트를 검색하는 함수 */
	function searchListINproject(){
		   
		var listsearchINproject = $("#listsearchINproject").val();
		var sel = $("#sel3").val();
		
		/* 리스트 form */
		var form_data2 = {fk_project_idx: "${projectInfo.project_idx}",
				          sel3Val : $("#sel3").val(),
				          listsearchINproject: listsearchINproject}
			
		$.ajax({
			
			url: "<%= request.getContextPath() %>/listsearchINproject.action",
			type: "get",
			data: form_data2,
			dataType: "json",
			success: function(json){
				
				var html = "";
				
				if($("#sel3").val() == 'list'){
							
					 $(".list-wrapper").empty();
					 var html = "";
					
					$.each(json, function(entryIndex, entry){
				
						/* 카드 form */
						var project_idx = "${projectInfo.project_idx}"; 
												
	
					  	if(entry.list_delete_status != 0){ 
					  		
								html += "<input type='text' class='project_listname newval' value='"+entry.list_name+"' style='background-color:transparent; border:none; font-size: 14pt; color: gray; font-weight: bold;'/>";
								html += "<div id='list"+entryIndex+"' class='well list-hover' style='width:300px;display:inline-block; vertical-align: top; border-radius: 1em;'>";
								html += "<input type='text' class='project_listname newval' value='"+entry.list_name+"' style='background-color:transparent; border:none; font-size: 14pt; color: gray; font-weight: bold;'/>";
								html += "&nbsp;&nbsp;&nbsp;<i class='fa fa-align-justify' style='font-size:24px'></i>";
								html += "<input type='hidden' class='project_listname oldval' value='"+entry.list_name+"' style='background-color:transparent; border:none; font-size: 14pt; color: gray; font-weight: bold;'/>";
								html += "<input type='hidden' class='project_listname oldval' value='"+entry.list_name+"' style='background-color:transparent; border:none; font-size: 14pt; color: gray; font-weight: bold;'/>";
								html += "<div class='card-wrapper' style='max-height:500px;overflow-y:auto; margin-top: 5%;'>";
								
								var listidx = entry.list_idx
								// alert("listidx"+ listidx);
					 	        cardinfo(project_idx, sel,listsearchINproject,listidx);
					 
								
								html += "</div>";
								html += "<div class='div-addcard'>";
	/* 							html += "<textarea rows='2' cols='33' placeholder=;'Enter card title...'></textarea><br/>"; 
								html += "<button class='btn btn-default btn-addcard' style='margin-top: 10px;' >add Card</button>";  */
								html += "<input type='hidden' value='"+entry.list_idx+"'>";
								html += "</div>";
								/* html += "<span style='font-size: 12pt; color: gray;' id='addCardstyle"+entryIndex+"' class='addCardstyle'><i class='fa fa-plus'></i>&nbsp;add another card...</span>"; */
								html += "</div>";
								html += "</div>";
								
						}
					  	
							
						
						
				
				});
			
					$(".list-wrapper").html(html);
			
			    }
		
			},
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
		    }
			
		});
		
		
	}
	   
	/* 프로젝트 내에서 리스트를 검색할 시 카드 리스트를 불러오는 함수 */   
		function cardinfo(fk_project_idx,sel3Val,listsearchINproject,fk_list_idx){
		// alert("시작");
		
		var form_data = {fk_project_idx: fk_project_idx,
				          sel3Val : sel3Val,
				          listsearchINproject: listsearchINproject,
				          fk_list_idx : fk_list_idx}
		
		$.ajax({
			
			url: "<%= request.getContextPath() %>/listsearchINproject_card.action",
			type: "get",
			data: form_data,
			dataType: "json",
			success: function(json){
				
				var html = "";
				
				if(json.length > 0){
					
					$.each(json, function(entryIndex, entry){
						
						html += "<div class='panel panel-default'>";
						html += "<div class='panel-body' onClick='window.open('carddetail.action?projectIDX="+entry.fk_project_idx+"&listIDX="+entry.fk_list_idx+"&cardIDX="+entry.card_idx+"','window_name','width=800,height=710,location=no,status=no,scrollbars=yes');'>"+entry.card_title+"</div>";
						html += "</div>";
					});
					
					
						
				}
				
				$(".card-wrapper").html(html);
				
			},
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
		    }
			
		}); // $.ajax({searchCardINproject.action});
	}
		
	// 프로젝트 내에서 카드를 검색하는 함수 
	  function searchCardINproject(){
					
		    var fk_project_idx = "${projectInfo.project_idx}";
			var cardsearchINproject = $("#listsearchINproject").val();
			var sel = $("#sel3").val();
			/* 리스트 form */
			
			var form_data = {fk_project_idx: fk_project_idx,
					          sel3Val : sel,
					          cardsearchINproject: cardsearchINproject}
			
			$(".list-wrapper").empty();
			
			// alert("cardsearchINproject"+cardsearchINproject);
			
			// 프로젝트 내에서 검색한 카드의 list_idx 를 갖고 온다. 
			$.ajax({
				
				url: "<%= request.getContextPath() %>/cardsearchINproject_list.action",
				type: "get",
				data: form_data,
				dataType: "json",
				success: function(json){
					
					var html = "";
					
					if($("#sel3").val() == 'card'){
						
						if(json.length > 0){
							
							$.each(json, function(entryIndex, entry){
								
								/* var project_idx = ${projectInfo.project_idx};  */
								
								if(entry.list_delete_status != 0){  
							  		
									html += "<input type='text' class='project_listname newval' value='"+entry.list_name+"' style='background-color:transparent; border:none; font-size: 14pt; color: gray; font-weight: bold;'/>";
									html += "<div id='list"+entryIndex+"' class='well list-hover' style='width:300px;display:inline-block; vertical-align: top; border-radius: 1em;'>";
									html += "<input type='text' class='project_listname newval' value='"+entry.list_name+"' style='background-color:transparent; border:none; font-size: 14pt; color: gray; font-weight: bold;'/>";
									html += "&nbsp;&nbsp;&nbsp;<i class='fa fa-align-justify' style='font-size:24px'></i>";
									html += "<input type='hidden' class='project_listname oldval' value='"+entry.list_name+"' style='background-color:transparent; border:none; font-size: 14pt; color: gray; font-weight: bold;'/>";
									html += "<input type='hidden' class='project_listname oldval' value='"+entry.list_name+"' style='background-color:transparent; border:none; font-size: 14pt; color: gray; font-weight: bold;'/>";
									html += "<div class='card-wrapper' id='card-wrapper"+entryIndex+"' style='max-height:500px;overflow-y:auto; margin-top: 5%;'>";
									
																	 
									cardinfo2(fk_project_idx, sel, cardsearchINproject, entry.fk_list_idx, entryIndex);
						  
									html += "</div>";
									html += "<div class='div-addcard'>";
		/* 							html += "<textarea rows='2' cols='33' placeholder=;'Enter card title...'></textarea><br/>"; 
									html += "<button class='btn btn-default btn-addcard' style='margin-top: 10px;' >add Card</button>";  */
									html += "<input type='hidden' value='"+entry.list_idx+"'>";
									html += "</div>";
									/* html += "<span style='font-size: 12pt; color: gray;' id='addCardstyle"+entryIndex+"' class='addCardstyle'><i class='fa fa-plus'></i>&nbsp;add another card...</span>"; */
									html += "</div>";
									html += "</div>";
									
								}
								
							});
						}
						
						 
						
					}
					
					$(".list-wrapper").html(html);
					
					//searchCardINproject();
	
			},
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
		    }
			
		});
			
			
	}   
	
	function cardinfo2(fk_project_idx, sel, cardsearchINproject, fk_list_idx, Index){
		// alert("시작2222222");
		
		var form_data = {fk_project_idx: fk_project_idx,
				         sel3Val : sel,
				         cardsearchINproject: cardsearchINproject,
				         fk_list_idx : fk_list_idx}
		
		
		$.ajax({
			
			url: "<%= request.getContextPath() %>/cardsearchINproject_card.action",
			type: "get",
			data: form_data,
			dataType: "json",
			success: function(json){
				
				var html = "";
				
				if(json.length > 0){
					
					$.each(json, function(entryIndex, entry){
						
						html += "<div class='panel panel-default'>";
						html += "<div class='panel-body' onClick='window.open('carddetail.action?projectIDX="+entry.fk_project_idx+"&listIDX="+entry.fk_list_idx+"&cardIDX="+entry.card_idx+"','window_name','width=800,height=710,location=no,status=no,scrollbars=yes');'>"+entry.card_title+"</div>";
						html += "</div>";
					});
											
				}
				
				$("#card-wrapper"+Index).html(html);
				
			},
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
		    }
			
		}); // $.ajax({searchCardINproject.action});
	} 
	   
	
	var se1Val = "";
	
	function selVal(){
		
		if($("#sel1").val() == null){
			
			sel1Val = $("#sel1").val("수정");
			
		} 
				
		sel1Val = $("#sel1").val($("#sel").val());	
		
		sel1Val = $("#sel1").val();
		
		// console.log("버튼확인::::::"+se1Val);
		
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
	
	
	
		$(document).mouseup(function (e){
		
		if(!$(".sidenav").is(e.target) && $(".sidenav").has(e.target).length == 0 ){
			
			closeNav(); 
			
		}
				
	});
	
	
	
	function projectINlistRe(){
		
		// alert("값 : ${projectInfo.project_idx}" );
		
		var form_data = {project_idx : "${projectInfo.project_idx}"}
				
		$(".list-wrapper").empty();
		
		$.ajax({
			
			url: "<%= request.getContextPath()%>/projectRe_list.action",
			type: "get",
			dataType: "json",
			data: form_data,
			success: function(json){
				
				var html = "";
										
				if(json.length == 0){
					html += "<div id='addList' class='well list-hover' style='width: 300px; display: inline-block; vertical-align: top; border-radius: 1em;'>";
					html += "<label for='addListstyle'>";
					html += "<span style='font-size: 14pt; color: gray; font-weight: bold;' id='addListstyle'><i class='fa fa-plus'></i>&nbsp;add another list...</span>";
					html += "</label>";
					html += "<div class='div-listname'>";
					html += "<input type='text' class='list-title' id='listname' placeholder='Enter list title...' maxlength='30'>";
					html += "<button class='btn btn-default' style='margin-top: 10px;' onClick='insertList();'>add List</button>";
					html += "</div>";
					html += "</div>";
				}
				else if(json.length > 0){
					
					$.each(json, function(entryIndex, entry){
					
						if(entry.list_delete_status != 0){
							html += "<div id='list"+entryIndex+"' class='well list-hover' style='width:300px;display:inline-block; vertical-align: top; border-radius: 1em;'>";
							html += "<input type='text' class='project_listname newval' value='"+entry.list_name+"' style='background-color:transparent; border:none; font-size: 14pt; color: gray; font-weight: bold;'/>";
							html += "&nbsp;&nbsp;&nbsp;<i class='fa fa-align-justify' style='font-size:24px'></i>";
							html += "<input type='hidden' class='project_listname oldval' value='"+entry.list_name+"' style='background-color:transparent; border:none; font-size: 14pt; color: gray; font-weight: bold;'/>";
							html += "<div class='card-wrapper' id='card-wrapper"+entryIndex+"' style='max-height:500px;overflow-y:auto; margin-top: 5%;'>";
													
							var list_idx = entry.list_idx;
							var fk_project_idx = entry.fk_project_idx;
							
							cardlistRe(fk_project_idx, list_idx, entryIndex);
														
							html += "</div>";
							html += "<div style='margin-top: 5%;'>";
							html += "<div class='div-addcard'>";
						//	html += "<textarea rows='2' cols='33' placeholder='Enter card title...'></textarea><br/>";
						//	html += "<button class='btn btn-default btn-addcard' style='margin-top: 10px;' >add Card</button>";
							html += "<input type='hidden' value='"+entry.list_idx+"'>";
							html += "</div>";
							html += "<span style='font-size: 12pt; color: gray;' id='addCardstyle"+entryIndex+"' class='addCardstyle'><i class='fa fa-plus'></i>&nbsp;add another card...</span>";
							html += "</div>"; 
							html += "</div>";
							
						}
						
					});
					
					
					html += "<div id='addList' class='well list-hover' style='width: 300px; display: inline-block; vertical-align: top; border-radius: 1em;'>";
					html += "<label for='addListstyle'>";
					html += "<span style='font-size: 14pt; color: gray; font-weight: bold; padding-bottom: 10%;' id='addListstyle'><i class='fa fa-plus'></i>&nbsp;add another list...</span>";
					html += "</label>";
					html += "<div class='div-listname'>";
					html += "<input type='text' class='list-title' id='listname' placeholder='Enter list title...' maxlength='30'>";
					html += "<button class='btn btn-default' style='margin-top: 10px;' onClick='insertList();'>add List</button>";
					html += "</div>";
					html += "</div>";
					              
				}
				
				$(".list-wrapper").html(html);
				
								
			},
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
		    }
			
		});
	}
	
	function cardlistRe(fk_project_idx, list_idx, Index){
		
		//alert("list_idx : " + list_idx);
		var form_data = {projectIDX : fk_project_idx}
	
		$.ajax({
			
			url: "<%= request.getContextPath()%>/projectRe_card.action",
			type: "get",
			dataType: "json",
			data: form_data,
			//async: false,
			success: function(json){
				
				var html = "";
				
				if(json.length > 0 ){
					
					$.each(json, function(entryIndex, entry){
					
				
						//alert("카드 형성 확인용: >>>>>>>>>>>" + entryIndex);
						// console.log("entry.fk_list_idx : " + entry.fk_list_idx);
						if(list_idx == entry.fk_list_idx){
						
							html += "<div class='panel panel-default'>";
							html += "<div class='panel-body' onClick=\"window.open('carddetail.action?projectIDX="+entry.fk_project_idx+"&listIDX="+entry.card_idx+"&cardIDX="+entry.card_idx+"','window_name','width=800,height=710,location=no,status=no,scrollbars=yes');\">"+entry.card_title+"</div>";
							html += "</div>";
						
						} 
						
						
						
							
					});
						
					$("#card-wrapper"+Index).html(html);
					
				}
				
				
				
			},
			error: function(request, status, error){
				alert("code : " + request.status+"\n"+"message : "+request.responseText+"\n"+"error : "+ error); // 어디가 오류인지 알려줌
		    }
				
		});
		
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

/* ----------------------------------------------- 민재 -------------------------------------------- */
	.sidenav {
	    height: 100%;
	    width: 0;
	    position: fixed; 
	    z-index: 2; 
	    top: 0;
	    right: 0;
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
		<!-- <ul class="nav navbar-nav navbar-right showMenu">
			<li class="dropdown">
			<button class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="true">...Show Menu</button>
				<ul class="dropdown-menu">
					<li style="min-width: 250px; min-height: 100px; padding-left: 10px; padding-top: 5px;">
					<div style="width: inherit; height: inherit;"></div>
					</li>
				</ul>
			</li>
		</ul> -->
		<p align="right">
			
			<button class="btn btn-default" type="button" id="menu1"
				style="background-color: black; margin-top: 5px; margin-bottom: 5px; color: black; border-color: black;">
				<span style="font-size: 13pt; color: yellow;"  onclick='openNav();'>...Show Menu</span>
			</button>
		</p>
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
<!-- ----------------------------------------------------------  민재 ------------------------------------------------------------------------------- -->	
	<div id="mySidenav" class="sidenav">
	 	  <span style="font-size: 40pt; font-weight: bold;" onclick="Activity();">&#9776; menu</span>
	 	  <a href="javascript:void(0)"onclick="closeNav();"><span style="padding-left: 80%; ">&times;</span></a>
	 	  <span style="cursor:pointer" onclick="openNav2();">Search in PROJECT</span> 
		  <span style="cursor: pointer;" onclick="leaveProject();">Leave PROJECT</span> 
		  
		  
		  <span style="cursor: pointer;" onclick="deleteProject();" >Delete PROJECT</span>
		 
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
		  
	  	  </div>

		    
		    
		  
		  
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
			      <select class="form-control" id="sel3">    
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
	
	 <%--  <form name="project_idxFrm">
	  	<input type="hidden" name="fk_project_idx" value="${projectInfo.project_idx}"/>value="${project_membervo.fk_project_idx}"
	  	<input type="hidden" name="sel1Val" />
	  </form> --%>
	  
	  <form name="leaveProjectFrm">
	  	<input type="hidden" name="fk_project_idx" value="${projectInfo.project_idx}"/><%-- value="${project_membervo.fk_project_idx}" --%>
	  </form>

	  <div style="float: right;">
	  		<input type="hidden" id="sel1" name="sel1" value=""/>	
	  </div>