<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 

<script type="text/javascript">
$(document).ready(function(){

	$(".content").hide(); // comment 수정 시 효과
	$("#checkListAdd").hide(); // 체크리스트 추가시 효과
	$("#checkListTitleEdit").hide(); // 체크리스트 타이틀 수정 시 효과
	
	
/* 	if($("#inputcss").val().trim = ""){
		titleSelect();
	} */
	
	$("#inputcss").keyup(function(event) {

		if (event.keyCode == 13) {
			titleUpdate();
		} 
	}); // end of $("#inputcss").keydown()

 	$('body').click(function(e) {
		if(!$('#titleInput').has(e.target).length) { 
			titleUpdate();
		}  
	});// end of $('body').click()------------------ 
	
	// 코멘트 리스트로 불렀을때 지정된 코멘트를 선택하기 위해 숫자생성
	var count = 1;
	var cnt = $("#cardCommentListLength").val();
	//$("#commentEdit").hide();
	for(;count<cnt+1;count++){
		$("#commentEdit"+count).hide();
	}
	
	// DueDate
	var datecheckCNT = $("#datecheckCNT").val();
	if(datecheckCNT == 0){ // 체크해제
		$(".dueCheck").removeClass("duedateCheck");
		$("#dateCheck").prop("checked", false);
	}else if(datecheckCNT == 1){// 체크
		$(".dueCheck").addClass("duedateCheck");
		$("#dateCheck").prop("checked", true);
	}
	
	// DueDate 클릭시 색을 바꿔주는 함수
	$("#dateCheck").bind("click", function(){
		 var checkBox = document.getElementById("dateCheck");
		 if (checkBox.checked == true){
			 checkChange();
		 }else{
			 checkChange();
		 }
	});// end of $("#dateCheck").bind()
	
	// 체크리스트 클릭시 효과 시작
	$("#checkListText").bind("click", function(){
		
		$("#checkListAdd").show();
		$("#checkListText").hide();
	}); //	$("#checkListText").bind()
	
	$("#checkListCancel").bind("click", function(){
		$("#checkListAdd").hide();
		$("#checkListText").show();
	});
	
	$("#checkListTitle").bind("click", function(){
		$("#checkListTitleEdit").show();
		$("#checkListTitle").hide();
	}); //	$("#checkListText").bind()
	
	$("#checkListTitleCancel").bind("click", function(){
		$("#checkListTitleEdit").hide();
		$("#checkListTitle").show();
	});
	// 체크리스트 클릭시 효과 끝
	
	// Ajax안에서 체크리스트 클릭 시 체크, 체크해제
	$(document).on("click",".checklist",function(){
		 var checkBox = $(this).val();
		 var $target = $(event.target); 
		 var checklistdetailidx =$target.next().next().val();
		 var checklisttodostatus =$target.next().next().next().val();
		 
	/* 	 alert("체크박스 : "+checkBox);
		 alert("체크리스트 idx : " + cardchecklistdetailidx);
		 alert("체크리스트 스테이터스:"+cardchecklisttodostatus); */
		 if (checkBox.checked == true){
			//alert("체크해제");
			goCheckListChange(checklistdetailidx,checklisttodostatus); // 체크 해제
		 }else{
			//alert("체크");
			goCheckListChange(checklistdetailidx,checklisttodostatus);// 체크
		 }
	}); // end of $(document).on()
	
	// 체크리스트 DB에서 불러올때 status가 0 이면 체크 해제 1이면 체크
	$(".checklist").each(function(index,  item){

		var cardchecklisttodostatus = $("#checklist"+index).val();

		// alert("checklist 체크확인 : "+cardchecklisttodostatus);
		 if(cardchecklisttodostatus==0){ // 체크해제
			 $(this).prop("checked", false);
		 }else if(cardchecklisttodostatus==1){
			 $(this).prop("checked", true);
		 }
	});
	
	// Ajax안에서 체크리스트 삭제 클릭 시 체크리스트 삭제
	$(document).on("click",".checkListDelete",function(){
		alert("checkListDelete ");
		var cnt =/* $("#indexval").val(); */$(this).next().val();
		var checklistdetailIdx = $("#checklistIdx"+cnt).val();
		alert(cnt);
		alert(checklistdetailIdx);
		goCheckListDelete(checklistdetailIdx);
	}); // end of $(document).on()
	
	//  Ajax안에서 체크리스트타이틀 삭제 클릭 시 
	$(document).on("click","#checkListTitleDelete",function(){
		goCheckListTitleDelete();
	}); // end of $(document).on()
	
	
	
	/* // 체크리스트 삭제
	$(".checkboxList").each(function(index,  item){
		 var checkBox = $(this).val();
		 var $target = $(event.target); 
		 var cardchecklistdetailidx =$target.next().next().val();
		 var cardchecklisttodostatus =$target.next().next().next().val();
		 
		 alert("체크박스 : "+checkBox);
		 alert("체크리스트 idx : " + cardchecklistdetailidx);
		 alert("체크리스트 스테이터스:"+cardchecklisttodostatus);
		 if (checkBox.checked == true){
			alert("체크해제");
			goCheckListChange(cardchecklistdetailidx,cardchecklisttodostatus); // 체크 해제
		 }else{
			alert("체크");
			goCheckListChange(cardchecklistdetailidx,cardchecklisttodostatus);// 체크
		 }
	}); // end of $(".checklist").click() */
    
/* 
    $("#goCheckLisTitletEdit").bind("click", function(){  	  
    	alert("호호호");
    	goCheckLisTitletEdit();
   	
    });
    
    $("#goCheckListAdd").bind("click", function(){
    	goCheckListAdd();

    }); */
	
/* 	#  ed ==	///////////////////////////////////////////////////
	comment 입력 수정 삭제 시 불러오는 값 테스트
	$(".btnDelete").bind("click", function(){
		var $target = $(event.target); 
		
		var cardidx = $target.next().val();
		var cardcommentidx = $target.next().next().val();
		
		// alert(cardidx + ", " + cardcommentidx);
		
		goCommentDelete(cardidx, cardcommentidx);
	});
	
	
	// **** !!!!중요!!!! **** //
	
	//	ajax로 구현되어진 내용물에서 선택자를 잡을 때는 아래와 같이 해야한다.
	//	$(document).on("click","선택자",function(){ });
	//	으로 해야한다.
	
	$(document).on("click",".btnDeleteAjax",function(){
		// test();
    
		var $target = $(event.target); 
		
		var cardidx = $target.next().val();
		var cardcommentidx = $target.next().next().val();
		
		// alert(cardidx + ", " + cardcommentidx);
		
		goCommentDelete(cardidx, cardcommentidx);
	});
	/////////////////////////////////////////////////// */
	
});// end of $(document).ready()

//card 로그인 체크
function cardLoginCheck(){
	if(  ${sessionScope.loginuser.userid == null || sessionScope.loginuser.userid == "" || empty sessionScope.loginuser.userid }  ) {
    	alert("로그인이 필요한 메뉴입니다.");
    	opener.window.location ="/finalins/index.action";
    	close();
    } else {
    	var userid = "${sessionScope.loginuser.userid}";
    	var form_data = {cardidx :  $("#cardidx").val(),
    					userid : userid};
    	$.ajax({
    		url:"projectMemberCheck.action",
    		type:"GET",
    		data : form_data,
    		dataType: "JSON",
    		success: function(json) {
    			if(json.CNT == 0){
    				alert("프로젝트 멤버만 사용가능합니다.");
    		    	location.href="javascript:history.back();";
    		    	return 0;
    			}
    		}, 
    		error: function(request, status, error){ 
    			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
    		}
    	});// end of $.ajax({})
    	
    	
    } // end of if~else------------------------------- 
} // end of LoginCheck()

//card 안 로그인 체크
function LoginCheck(){
	if(  ${sessionScope.loginuser.userid == null || sessionScope.loginuser.userid == "" || empty sessionScope.loginuser.userid }  ) {
    	opener.window.location ="/finalins/index.action";
    	close();
   } else {
   	var userid = "${sessionScope.loginuser.userid}";
   	var form_data = {cardidx :  $("#cardidx").val(),
   					userid : userid};
   	$.ajax({ 
   		url:"projectMemberCheck.action",
   		type:"GET",
   		data : form_data,
   		dataType: "JSON",
   		success: function(json) {
   			if(json.CNT == 0){
   				location.href="javascript:history.back();";
   		    	return 0;
   			}
   		}, 
   		error: function(request, status, error){ 
   			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
   		}
   	});// end of $.ajax({})
   	
   	
   } // end of if~else------------------------------- 
} // end of LoginCheck()

// byte 수 계산
function getByteB(str) {
	var byte = 0;
	for (var i=0; i<str.length; ++i) {
	// 기본 한글 2바이트 처리
	(str.charCodeAt(i) > 127) ? byte += 3 : byte++ ;
	}
	return byte;
}

// 카드 기록 정보 불러오는 Ajax
function cardRecordInfo(){
	var form_data = {cardidx :  $("#cardidx").val(),// cardidx값 받아오면 넣어준다.
            projectIdx : $("#projectIdx").val(),
            listIdx : $("#listIdx").val(),
            } 

	$.ajax({
		url:"cardRecordInfo.action",
		type:"GET",
		data : form_data,
		dataType: "JSON",
		success: function(json) {
			$("#recordSelect").empty();
			var html = "<button class='collapsible' style='border :1px solid #ddd; border-top-left-radius: 3px; border-top-right-radius: 3px;'><i class='fa fa-list-alt'></i>Activity</button>";
				html += "<div class='content' style='border:1px solid #ddd; border-top-left-radius: 3px; border-top-right-radius: 3px;'>";
					$.each(json, function(entryIndex, entry){
					  html += "<p><div class='form-group'>";
				      html += entry.NICKNAME+"<br/>";	                                        
				      html +=	"<div class='commentCss'>";
					  html += 		"<p>"+ entry.RECORDDMLSTATUS+"</p>";
					  html += 	"</div>";
					  html += 	"<div align='right'>";
					  html += 		"<span style='color:grey; font-size: 10px; text-align: right; font-weight: bold;'>"+entry.PROJECTRECORDTIME+"</span>";
					  html += 	"</div>";
					  html += "</div>";
					  html += "</p>"; 
					}); //end of each
				html +=	"</div>";
			$("#recordSelect").html(html);
		}, 
		error: function(request, status, error){ 
			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
		}
	
	}); // end of ajax({})
}
 
 
// 제목 수정
function titleUpdate(){
	var CNT = cardLoginCheck();
	if(CNT != 0){
		var newcardtitle =  $("#inputcss").val().trim();
		var oldcardtitle = $("#inputtitle").val().trim();
		var getbyte = getByteB(oldcardtitle);

		if(getbyte < 400 ){
			if(newcardtitle != oldcardtitle){
		    	var form_data = {cardidx :  $("#cardidx").val(),// cardidx값 받아오면 넣어준다.
				                 cardtitle : newcardtitle,
				                 projectIdx : $("#projectIdx").val(),
				                 listIdx : $("#listIdx").val(),
				                 userid : $("#userid").val()
				                 } 
		
		    	$.ajax({
		    		url:"cardTitleUpdate.action",
		    		type:"POST",
		    		data : form_data,
		    		dataType: "JSON",
		    		success: function(json) {
		    		 		//$("#inputcss").val(json.CARDTITLE);
		    		 		$("#titleInput").empty();
		    		 		
		    		 		html ="<i class='fa fa-columns'></i><input type='text'  id='inputcss' value='"+json.CARDTITLE+"' />"; 
		                  	html += "<input input type='hidden'  id='inputtitle' value='"+json.CARDTITLE+"'  />";
		    		 		//alert(json.CARDTITLE);
		    		 		$("#titleInput").html(html);
		    		 		cardRecordInfo();
		    		}, 
		    		error: function(request, status, error){ 
		    			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
		    		}
		    	
		    	}); // end of ajax({})
			}
		}else{
			alert("1~130자로 입력해주세요");
			location.href="javascript:history.go(0);"
			return;
		}
	}
 }// end of titleUpdate() 

 // 설명 수정
 function goDescription(cardidx){

	var CNT = LoginCheck();
	if(CNT != 0){
	 var form_data = {cardidx :  cardidx,
					carddescription : $("#description").val(),
	                 projectIdx : $("#projectIdx").val(),
	                 listIdx : $("#listIdx").val(),
	                 userid : $("#userid").val()
	                 }
	 
		$.ajax({		
	 		url:"cardDescriptionCange.action",
	 		type:"POST",
	 		data : form_data,
	 		dataType: "JSON",
	 		success: function(json) {
	 			$("#description").val(json.DESCRIPTION);
	 			cardRecordInfo();
	 		}, 
	 		error: function(request, status, error){ 
	 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
	 		}
	 	
	 	}); // end of ajax({})
	}
 }// end of goDescription()
 
 // 첨부파일 추가
 function goAttach(){
	 var Attach = $("#attach").val();
	 var CNT = LoginCheck();
		if(CNT != 0){
			if(Attach !=""){
				// form 전송하기
				var frm = document.fileFrm;
				frm.action="<%=request.getContextPath()%>/cardAttachInsert.action";
				frm.method ="post";
				frm.submit();
			}else{
				alert("파일이 없습니다.");
				location.href="javascript:history.go(0);"
				return;
			}
		}
 }// end of goAttach()
 
 // 첨부파일 삭제
 function goAttachDelete(cardidx){
	var CNT = LoginCheck();
	if(CNT != 0){
		
		var bool = confirm("파일첨부를 삭제하시겠습니까?");
		if(bool){
			 var form_data = {cardidx : cardidx, 
					  projectIdx : $("#projectIdx").val(),
		                 listIdx : $("#listIdx").val(),
		                 userid : $("#userid").val()}
		 
			$.ajax({		
		 		url:"cardAttachDelete.action",
		 		type:"POST",
		 		data : form_data,
		 		success: function() {
		 			$("#attachdiv").empty();
		       		var html = "<form role='form' name='fileFrm' enctype='multipart/form-data'>";
			 			html += 	"<input type='text' name='projectIdx' value='${cardRecordIDXMap.projectIdx}'/>";
			 			html += 	"<input type='text' name='listIdx' value='${cardRecordIDXMap.listIdx}'/>";
			 			html +=		"<input type='text' name='userid' value='${sessionScope.loginuser.userid}'/>"
			 			html +=		"<input type='text' name='fkcardidx' value='${cardMap.CARDIDX}'/>";  
			 			html += 	"<div class='form-group' >";
			 			html += 		"<input name='attach' id='attach' type='file' />";   
			 			html += 		"<input type='hidden' name='fk_card_idx' value='${cardMap.CARDIDX}'/>";                                
			 			html += 	"</div>"; 
			 			html += 	"<button type='button' class='btn btn-default' style='font-weight: bold;' onClick=\"goAttach('${cardMap.CARDIDX}')\"><i class='fa fa-floppy-o'></i>Save</button>";	
			 			html += "</form>"; 
		 			$("#attachdiv").append(html);
		 			cardRecordInfo();	
		 		}, 
		 		error: function(request, status, error){ 
		 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
		 		}
		 	
			}); // end of ajax({})
		}else{
			alert("삭제가 취소됐습니다.");
			location.href="javascript:history.go(0);"
			return;
		}
	}
 }// end of goAttachDelete() 
 
 
 // 코멘트 입력
 function goAddComment(){
	 var CNT = LoginCheck();
		if(CNT != 0){
			var contentval = $("#content").val().trim();
			if(contentval == "") {
				alert("댓글 내용을 입력하세요!!");
				return;
			}
			
			var data_form = {userid : $("#userid").val(),
					 nickname : $("#nickname").val(),
			         content: contentval,
			         cardidx: $("#cardidx").val(),
					 projectIdx : $("#projectIdx").val(),
		             listIdx : $("#listIdx").val()
		             }
	
			$.ajax({
				url:"cardAddComment.action",
				data: data_form,
				type: "POST",
				//dataType: "JSON",
				success: function() {
					javascript:history.go(0);
					cardRecordInfo();
				/*  	$("#commentList").empty();
				 	$("#content").val("");
				 	var html ="";
					$.each(json, function(entryIndex, entry){
						
						if(entryIndex != 0){
						html += "<hr style='border: solid 1px grey;'/>";
						}
						html += "<form role='form' name='commentFrm'>";
						html += "<div class='form-group'>";
						html += entry.CARDNICKNAME+"<br/>";
                    	html += "<div class='commentCss'>";
						html += "<p>"+entry.CARDCOMMENTCONTENT+"</p>";
							html += "<div align='right'>";
							html += "<span style='color:grey; font-size: 10px; text-align: right; font-weight: bold;'>"+entry.CARDCOMMENTDATE+"</span>";
							html += "</div>";
						html += "</div>";
						html += "<input type='hidden' name='commentidx' id = 'commentidx' value='"+entry.CARDCOMMENTIDX+"' />";
						html += "</div>";
						if(entry.SESSIONUSERID == entry.CARDCOMMENTUSERID){
						html += "<button type='button' class='btn btn-default' style='font-weight: bold;' onClick=\"goCommentEdit('"+entry.CARDCOMMENTIDX+"','"+entry.CARDCOMMENTCONTENT+"');\"><i class='fa fa-pencil-square-o'></i></i>Edit</button>";
						html += "<button type='button' class='btn btn-default' style='font-weight: bold;' onClick=\"goCommentDelete('"+entry.FKCARDIDX+"','"+entry.CARDCOMMENTIDX+"')\"><i class='fa fa-trash'></i>Delete</button>";
						html += "<input type='text' value='"+entry.FKCARDIDX+"' /><input type='text' value='"+entry.CARDCOMMENTIDX+"' />";
						}
						html += "</form>";
						html += "<br/>";
					
					});
					$("#commentList").html(html); */
					 
				},
				error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});	// end of ajax({})
		}
	 
 } // end of goAddComment()
 
 //////////////////////////////////////////////////////////////
 /* 코멘트 수정 이벤트 */
 function goCommentEdit(cnt,commentcontent){
	$("#comment"+cnt).hide();
	$("#Editcontent"+cnt).val(commentcontent);
	$("#commentEdit"+cnt).show();
 }
 
 function goCommentCancel(cnt){
	$("#comment"+cnt).show();
	$("#commentEdit"+cnt).hide();
 }
//////////////////////////////////////////////////////////////

 // 카드 내용 수정
 function goEditComment(cardidx,cardcommentidx,cnt){
	 var EditOldcontent = $("#EditOldcontent"+cnt).val();
	 var Editcontent = $("#Editcontent"+cnt).val().trim();
	 
	 alert("EditOldcontent" + EditOldcontent);
	 alert("Editcontent" + Editcontent);
	 var CNT = LoginCheck();
		if(CNT != 0){
			if(EditOldcontent != Editcontent){
				 var form_data = {cardidx : cardidx,
						 cardcommentidx : cardcommentidx,
						 Editcontent : Editcontent,
					 	 projectIdx : $("#projectIdx").val(),
		                 listIdx : $("#listIdx").val(),
		                 userid : $("#userid").val()
		                 }
			 
				$.ajax({		
			 		url:"cardCommentEdit.action",
			 		type:"POST",
			 		data : form_data,
			 		//dataType: "JSON",
					success: function() {
						javascript:history.go(0);
						cardRecordInfo();
					 /* 	$("#commentList").empty();
					 	var html ="";
						$.each(json, function(entryIndex, entry){
							if(entryIndex != 0){
							html += "<hr style='border: solid 1px grey;'/>";
							}
							html += "<form role='form' name='commentFrm'>";
							html += "<div class='form-group'>";
							html += entry.CARDNICKNAME+"<br/>";
	                    	html += "<div class='commentCss'>";
							html += "<p>"+entry.CARDCOMMENTCONTENT+"</p>";
								html += "<div align='right'>";
								html += "<span style='color:grey; font-size: 10px; text-align: right; font-weight: bold;'>"+entry.CARDCOMMENTDATE+"</span>";
								html += "</div>";
							html += "</div>";
							html += "<input type='hidden' name='commentidx' id = 'commentidx' value='"+entry.CARDCOMMENTIDX+"' />";
							html += "</div>";
							if(entry.SESSIONUSERID == entry.CARDCOMMENTUSERID){
							html += "<button type='button' class='btn btn-default' style='font-weight: bold;' onClick=\"goCommentEdit('"+entry.CARDCOMMENTIDX+"','"+entry.CARDCOMMENTCONTENT+"');\"><i class='fa fa-pencil-square-o'></i></i>Edit</button>";
							html += "<button type='button' class='btn btn-default' style='font-weight: bold;' onClick=\"goCommentDelete('"+entry.FKCARDIDX+"','"+entry.CARDCOMMENTIDX+"')\"><i class='fa fa-trash'></i>Delete</button>";
							}
							html += "</form>";
							html += "<br/>";
						
						});
						$("#commentList").html(html); */
			 		}, 
			 		error: function(request, status, error){ 
			 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
			 		}
			 	
				}); // end of ajax({})
			}else{
				alert("똑같아요");
			}
		
		}// end of if(CNT != 0)
 } // end of goEditComment(cardidx,cardcommentidx)
  
 // 코멘트 삭제
 function goCommentDelete(cardidx,cardcommentidx){
	// alert("삭제시작");
	 var CNT = LoginCheck();
		if(CNT != 0){
			
			var bool = confirm("댓글을 삭제하시겠습니까?");
			if(bool){
				var form_data = {cardidx : cardidx,
						         cardcommentidx : cardcommentidx,
						         projectIdx : $("#projectIdx").val(),
				                 listIdx : $("#listIdx").val(),
				                 userid : $("#userid").val() 
								};
			 
				$.ajax({		
			 		url:"goCommentDelete.action",
			 		type:"GET",
			 		data : form_data,
			 		//dataType: "JSON",
					success: function() {
						javascript:history.go(0);
/* 					    $("#commentList").empty();
					 // $("#deleteAftercommentList").empty();
					 	
					 	var html ="";
						$.each(json, function(entryIndex, entry){
				   
                      	
						if(entryIndex != 0){
								html += "<hr style='border: solid 1px grey;'/>";
							}
							
							html += "<form role='form' name='commentFrm'>";
							html += "<div class='form-group'>";
							html += entry.CARDNICKNAME+"<br/>";
	                    	html += "<div class='commentCss'>";
							html += "<p>"+entry.CARDCOMMENTCONTENT+"</p>";
							html += "<div align='right'>";
							html += "<span style='color:grey; font-size: 10px; text-align: right; font-weight: bold;'>"+entry.CARDCOMMENTDATE+"</span>";
							html += "</div>";
							html += "</div>";
							html += "<input type='hidden' name='commentidx' id = 'commentidx' value='"+entry.CARDCOMMENTIDX+"' />";
							html += "</div>";
							
							if(entry.SESSIONUSERID == entry.CARDCOMMENTUSERID){
								html += "<button type='button' class='btn btn-default' style='font-weight: bold;' onClick='goCommentEdit('"+entry.CARDCOMMENTIDX+"','"+entry.CARDCOMMENTCONTENT+"');'><i class='fa fa-pencil-square-o'></i></i>Edit</button>";
								
							html += "<button type='button' class='btn btn-default' style='font-weight: bold;' onClick='goCommentDelete('"+entry.FKCARDIDX+"','"+entry.CARDCOMMENTIDX+"');'><i class='fa fa-trash'></i>Delete</button>"; 
								
							 	html += "<button type='button' class='btn btn-default btnDeleteAjax' style='font-weight: bold;'><i class='fa fa-trash'></i>Delete</button> <input type='text' value='"+entry.FKCARDIDX+"'/><input type='text' value='"+entry.CARDCOMMENTIDX+"' />";           
							}
							
							
							html += "<br/>"; 
						
						});
						$("#commentList").html(html); */
			 		}, 
			 		error: function(request, status, error){ 
			 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
			 		}
			 	
				}); // end of ajax({})
			}else{
				alert("삭제가 취소됐습니다.");
				location.href="javascript:history.go(0);"
				return;
			}
		}
 } // end of  goCommentDelete(cardidx,cardcommentidx)
 
 // DueDate 체크 상태 변경
 function checkChange(){
	 var CNT = LoginCheck();
		if(CNT != 0){
			var form_data = {cardidx : $("#cardidx").val(),
							cardduedateIdx : $("#cardduedateIdx").val()
							};
		 
			$.ajax({		
		 		url:"checkChange.action",
		 		type:"POST",
		 		data : form_data,
		 		dataType: "JSON",
		 		success: function(json) {
					if(json.datecheckCNT == 0){ // 체크가 안된 상태
						$(".dueCheck").removeClass("duedateCheck");
					}else if(json.datecheckCNT == 1){ // 체크가 된 상태
						 $(".dueCheck").addClass("duedateCheck");
					}
				}, 
				error: function(request, status, error){ 
		 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
		 		}
		 	
			}); // end of ajax({})
		} // end of if(CNT != 0)
 }// end of checkChange()
 
// 체크리스트 타이틀 변경
function goCheckLisTitletEdit(){
    var cardidx= $("#cardidx").val();
    var checkListTitleEditvalue = $("#checkListTitleEditvalue").val().trim(); // 체크리스트 타이틀 내용
    var cardchecklistTitle = $("#cardchecklistTitle").val(); // 체크리스트 DB에 있는 내용
    var checkListTitleAjaxvalue = $("#checkListTitleAjaxvalue").val(); // ajax로 값이 처음 들어 오면  
    var cardchecklistIdx = $("#cardchecklistIdx").val(); 

/* 
    alert("checkListTitleAjaxvalue :"+checkListTitleAjaxvalue);
    alert("checkListTitleEditvalue 수정 :"+checkListTitleEditvalue);
    alert("cardchecklistTitle DB :"+cardchecklistTitle);
    alert("cardchecklistIdx :"+cardchecklistIdx);  */
	var CNT = LoginCheck();
		if(CNT != 0){
			if(checkListTitleEditvalue !=""){
				if( (cardchecklistTitle != "" && checkListTitleEditvalue != cardchecklistTitle) // DB에 값이 있으면 수정되는 값과 DB가 같은 지 비교
						|| (cardchecklistTitle == "" && checkListTitleEditvalue != checkListTitleAjaxvalue)){ // DB에 값이 없으면 수정되는 값과 input테그에있는 Ajax 값을 비교 
					var form_data = {cardidx : cardidx,
							cardchecklistIdx : cardchecklistIdx,
							checkListTitleEditvalue : checkListTitleEditvalue
							};
				 
					$.ajax({		
				 		url:"goCheckLisTitletEdit.action",
				 		type:"POST",
				 		data : form_data,
				 		dataType: "JSON",
				 		success: function(json) {
							/* alert("수정 시작"); */
							
			        		$("#checkListTitleEdit").hide();
			        		$("#cardchecklistTitle").val(json.CARDCHECKLISTTITLE);
			        		$("#checkListTitle").show();
			        	
				 			$("#checkListTitle").empty();
				 			$("#checkListTitleEdit").empty();
			     			
					         var html =  "<i class='fa fa-check-square-o'></i>";
					        	 html +=	"<span style='cursor: pointer;'>"+json.CARDCHECKLISTTITLE+"</span>";
					        	 html +=	"<span style='cursor: pointer;  float: right;' id='checkListTitleDelete' ><i class='fa fa-trash'></i></span>";
					            	
					         var date = "<div>";
					        	 date += 	"<i class='fa fa-check-square-o'></i>";
					        	 date +=	"<input style='border: none; background-color: #ffe8e8;' id='checkListTitleEditvalue' maxlength='16' value='"+json.CARDCHECKLISTTITLE+"' />";
					        	 date +=	"<input type='hidden' id= 'checkListTitleAjaxvalue' value='"+json.CARDCHECKLISTTITLE+"' />";
					        	 date +=	"<input type='hidden' id= 'checkListTitleAjaxIdx' value='"+json.CARDCHECKLISTIDX+"' />";
					        	 date +=	"<span style='cursor: pointer;  float: right;' id='checkListTitleDelete' ><i class='fa fa-trash'></i></span>";
					        	 date +="</div>";
					        	 date +=	"<br/>";
					        	 date +=		"&nbsp;&nbsp;<button type='button' class='btn btn-default' style='font-weight: bold;' id = 'goCheckLisTitletEdit'><i class='fa fa-floppy-o'></i>Save</button>";
					        	 date +=		"&nbsp;<button type='button' class='btn btn-default' style='font-weight: bold;' id='checkListTitleCancel'><i class='fa fa-times-circle'></i>Cancel</button>";
					             	
					             	
				       	 	$("#checkListTitle").html(html);
					        $("#checkListTitleEdit").html(date);

					    	$(document).on("click","#checkListTitle",function(){
					      		$("#checkListTitleEdit").show();
					      		$("#checkListTitle").hide();
				      		});

				        	$(document).on("click","#checkListTitleCancel",function(){
				        		$("#checkListTitleEdit").hide();
				      			$("#checkListTitle").show();
				        	});  
				        	
						}, 
						error: function(request, status, error){ 
				 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
				 		}
				 	
					}); // end of ajax({})
				}else {
					alert("체크리스트 제목이 같습니다.");
					location.href="javascript:history.go(0);";
					return;
				}//end of if~else()
					
			} else if(checkListTitleEditvalue == ""){
				alert("제목을 입력해주세요.");
				location.href="javascript:history.go(0);";
				return;
		}//end of if~else()
	}// //end of if()	 
}// end of goCheckListAdd()
 
// 체크리스트 추가
function goCheckListAdd(){
	var checkListContent =  $("#CheckListContent").val().trim(); // 체크리스트 리스트
	var cardchecklistIdx = $("#cardchecklistIdx").val(); 
	    
	/* alert("cardchecklistIdx :"+cardchecklistIdx) */
	var CNT = LoginCheck();
	if(CNT != 0){
		if(checkListContent !=""){	
				var form_data = {cardchecklistIdx : cardchecklistIdx,
						checkListContent : checkListContent
								};
			 
				$.ajax({		
			 		url:"goCheckListAdd.action",
			 		type:"POST",
			 		data : form_data,
			 		dataType: "JSON",
			 		success: function(json) {
			 			$("#cardCheckBoxList").empty();
			 			var	html = "";
			 			$.each(json, function(entryIndex,entry){
							
				 				html += 	"<div class='checkboxList'>";
								html += 	"<label style='float: left;'>";
								html += 		"<input type='checkbox'  class='checklist'>";
								html += 		"<span class='cr'><i class='cr-icon glyphicon glyphicon-ok'></i></span>";		
								html +=			"<input type='hidden' id='checklistIdx"+entryIndex+"' value='"+entry.CARDCHECKLISTDETAILIDX+"' />";
								html +=	   		"<input type='hidden' id='checklist"+entryIndex+"' value='"+entry.CARDCHECKLISTTODOSTATUS+"' />";
								html += 	"</label>";
								html += 		"<span id ='checkboxlist'  style='font-weight: bold'>"+entry.CARDCHECKLISTTODO+"</span>";
								html += 		"<div align='left' style='float: right;'>";
								html += 		"<span style='cursor: pointer;' class='checkListDelete'><i class='fa fa-trash'></i></span>";
								html +=			"<input type='hidden' id='indexval' value='"+entryIndex+"'/>";
								html += 		"</div>";
								html += "</div>";
								html += "<br/>";
								
			 			}); 
			 			$("#cardCheckBoxList").html(html);
			 			
			 			$(".checklist").each(function(index,  item){

			 				var cardchecklisttodostatus = $("#checklist"+index).val();

			 				// alert("checklist 체크확인 : "+cardchecklisttodostatus);
			 				 if(cardchecklisttodostatus==0){ // 체크해제
			 					 $(this).prop("checked", false);
			 				 }else if(cardchecklisttodostatus==1){
			 					 $(this).prop("checked", true);
			 				 }
			 			});
			 			
			 			$("#CheckListContent").val("");
			 			$("#checkListAdd").hide();
			 			$("#checkListText").show();
					}, 
					error: function(request, status, error){ 
			 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
			 		}
			 	
				}); // end of ajax({})
		
				
		} else {
			alert("체크리스트 내용을 입력해주세요.");
			return;
		}//end of if~else()
	}//end of if()	 
}// end of goCheckListAdd()

// 체크리스트 체크 해제 , 체크
function goCheckListChange(checkDetailIdx, checkListStatus){
	var cardchecklistIdx = $("#cardchecklistIdx").val();
	var CNT = LoginCheck();
	if(CNT != 0){
		var form_data = {checkDetailIdx : checkDetailIdx,
				checkListStatus : checkListStatus,
				cardchecklistIdx : cardchecklistIdx
						};
	 
		$.ajax({		
	 		url:"goCheckListChange.action",
	 		type:"POST",
	 		data : form_data,
	 		success: function(){
	 		
			}, 
			error: function(request, status, error){ 
	 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
	 		}
	 	
		}); // end of ajax({})
	}//end of if()	 
}// end of goCheckListChange

//체크리스트 삭제 
function goCheckListDelete(checkDetailIdx){
	var cardchecklistIdx = $("#cardchecklistIdx").val();
	var CNT = LoginCheck();
	if(CNT != 0){
		var form_data = {checkDetailIdx : checkDetailIdx,
				cardchecklistIdx : cardchecklistIdx
						};
	 
		$.ajax({		
	 		url:"goCheckListDelete.action",
	 		type:"POST",
	 		data : form_data,
	 		dataType: "JSON",
	 		success: function(json){
	 	 		
	 			if(json.length > 0){
		 			$("#cardCheckBoxList").empty();
		 			var	html = "";
		 			$.each(json, function(entryIndex,entry){
						
			 				html += 	"<div class='checkboxList'>";
							html += 	"<label style='float: left;'>";
							html += 		"<input type='checkbox'  class='checklist'>";
							html += 		"<span class='cr'><i class='cr-icon glyphicon glyphicon-ok'></i></span>";		
							html +=			"<input type='hidden' id='checklistIdx"+entryIndex+"' value='"+entry.CARDCHECKLISTDETAILIDX+"' />";
							html +=	   		"<input type='hidden' id='checklist"+entryIndex+"' value='"+entry.CARDCHECKLISTTODOSTATUS+"' />";
							html += 	"</label>";
							html += 		"<span id ='checkboxlist'  style='font-weight: bold'>"+entry.CARDCHECKLISTTODO+"</span>";
							html += 		"<div align='left' style='float: right;'>";
							html += 		"<span style='cursor: pointer;' class='checkListDelete' ><i class='fa fa-trash'></i></span>";
							html +=			" <input type='hidden' id='indexval' value='"+entryIndex+"'/>";
							html += 		"</div>";
							html += "</div>";
							html += "<br/>";
							
		 			}); 
		 			$("#cardCheckBoxList").html(html);
		 			
		 			$(".checklist").each(function(index,  item){
	
		 				var cardchecklisttodostatus = $("#checklist"+index).val();
	
		 				// alert("checklist 체크확인 : "+cardchecklisttodostatus);
		 				 if(cardchecklisttodostatus==0){ // 체크해제
		 					 $(this).prop("checked", false);
		 				 }else if(cardchecklisttodostatus==1){
		 					 $(this).prop("checked", true);
		 				 }
		 			});
	 			}
	 		
			}, 
			error: function(request, status, error){ 
	 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
	 		}
	 	
		}); // end of ajax({})
	}//end of if()	 
}// end of goCheckListDelete

//체크리스트 타이틀 삭제 
function goCheckListTitleDelete(){
	var cardchecklistIdx = $("#cardchecklistIdx").val();
	var cardidx = $("#cardidx").val();
	var CNT = LoginCheck();
	if(CNT != 0){
		var bool = confirm("체크리스트를 삭제하시겠습니까?");
		if(bool){
			var form_data = {cardchecklistIdx : cardchecklistIdx,
							cardidx: cardidx
							};
		 
			$.ajax({		
		 		url:"goCheckListTitleDelete.action",
		 		type:"POST",
		 		data : form_data,
		 		success: function(){
		 			$("#checkListOption").empty();
		 		
				}, 
				error: function(request, status, error){ 
		 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
		 		}
		 	
			}); // end of ajax({})
		}else{
			alert("삭제가 취소됐습니다.");
			location.href="javascript:history.go(0);"
			return;
		}
	}//end of if()	 
}// end of goCheckListDelete
 
</script>
<body>
	<input type="hidden" id="cardchecklistTitle" value="${cardCheckTitleMap.CARDCHECKLISTTITLE}"/>
	<input type="hidden" id="cardchecklistIdx" value="${cardCheckTitleMap.CARDCHECKLISTIDX}"/>
	<input type="hidden" id="datecheckCNT" value="${cardDueDateMap.CARDCHECK}"/>
 	<input type="hidden" id="cardduedateIdx" value="${cardDueDateMap.CARDDUEDATEIDX}"/>
 	<input type="hidden" id="projectIdx" value="${cardRecordIDXMap.projectIdx}"/>
	<input type="hidden" id="listIdx" value="${cardRecordIDXMap.listIdx}"/>
	<input type="hidden" id="cardidx" value="${cardMap.CARDIDX}"/>
    <div id="wrapper">
        <!-- Navigation -->
        <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
             
              <span class="navbar-brand title" id="titleInput">
              	<i class="fa fa-columns"></i><input type="text"  id="inputcss" value="${cardMap.CARDTITLE}" /> 
              	<input type="hidden"  id="inputtitle" value="${cardMap.CARDTITLE}"  />
              </span>
              
            </div>
            <!-- /.navbar-header -->

          <!--    <ul class="nav navbar-top-links navbar-right">
                <li class="dropdown">
                    <a class="dropdown-toggle"  data-toggle="modal" href="#exampleModal">
                        <i class="fa fa-pencil-square-o fa-2x"></i>
                    </a>
                </li>
            </ul> -->
            <!-- /.navbar-top-links-->


        </nav>
			
		
	
<div id="page-wrapper">
    <div class="row">
        <div class="col-lg-12">
     
     	<!-- 옵션 -->
        <div id="option">
        <c:if test="${cardDueDateMap != null || cardLabelList != null}">
      
         <div class="panel panel-default" style="margin-top: 2%">
               <div class="panel-heading">
                  <i class="fa fa-plus"></i>
                  Option
               </div>
               <div class="panel-body">
                   <div class="row">
                   <!--     <div class="col-lg-6"> -->
                           <form role="form">
                               <div class="form-group">
                               		<div class="commentCss dueCheck labelCss" id="dueCheck" style="margin: 10px 10px 10px 10px;"> <!-- style="padding: 10px 10px 1px 10px; margin: 10px 600px 10px 0px;" -->
                               		    <c:if test="${cardDueDateMap != null}">
									        <!-- 	<label style="float: left;" > -->
										              <input type="checkbox" id="dateCheck">  
										            <!-- <span class="cr"><i class="cr-icon glyphicon glyphicon-ok"></i></span> -->
										              
										        <!-- </label> -->
											 <span data-toggle="modal" href="#modalDate2">${cardDueDateMap.CARDDUEDATE}</span></p>
										 </c:if>
								    </div>
									 
		                           <%--  <div class="commentCss dueCheck" id="dueCheck" style="padding: 10px 10px 1px 10px; margin: 10px 600px 10px 0px;"> 
									<!-- <button type="button" class="commentCss dueCheck" id="dueCheck"  data-toggle="modal" href="#modal2" style="padding: 10px 10px 1px 10px; margin: 10px 600px 10px 0px;"> -->      
									  <p>
									  <input type="checkbox" id="dateCheck">  
									 <span data-toggle="modal" href="#modalDate2">${cardDueDateMap.CARDDUEDATE}</span></p>
									</div> <!-- </button> --> --%>
										<!-- 라벨 -->
									<div id = "cardLabel">
										<c:if test="${not empty cardLabelList}">
											<c:forEach var="list" items="${cardLabelList}">
												<c:if test="${list.CARDLABEL== '0'}">
												<div class="labelCss">
												 <button type="button" class="btn btn-primary " style="border: 0px; width: 50px; height: 32px; margin-top: 10px;" data-toggle="modal" href="#modalLabels2"></button> &nbsp;
												 <input type="text" class="labelstatus" value="0"/>
												 </div>
												 </c:if>
												 
												 <c:if test="${list.CARDLABEL== '1'}">
												 <div class="labelCss">
												 <button type="button" class="btn btn-success " style="border: 0px; width: 50px; height: 32px; margin-top: 10px;" data-toggle="modal" href="#modalLabels2"></button> &nbsp;
												 <input type="text" class="labelstatus" value="1"/>
												 </div>
												 </c:if>
												  
												  <c:if test="${list.CARDLABEL== '2'}">
												 <div class="labelCss" >
												 <button type="button" class="btn btn-info " style="border: 0px; width: 50px; height: 32px; margin-top: 10px;" data-toggle="modal" href="#modalLabels2"></button> &nbsp;
												 <input type="text" class="labelstatus" value="2"/>
												 </div>
												 </c:if>
												 
												  <c:if test="${list.CARDLABEL== '3'}">
												 <div class="labelCss" >
												 <button type="button" class="btn btn-warning" style="border: 0px; width: 50px; height: 32px; margin-top: 10px;" data-toggle="modal" href="#modalLabels2"></button> &nbsp;
												 <input type="text" class="labelstatus" value="3"/>
												 </div>
												 </c:if>
											
												 <c:if test="${list.CARDLABEL== '4'}">
												 <div class="labelCss" >
												 <button type="button" class="btn btn-danger" style="border: 0px; width: 50px; height: 32px; margin-top: 10px;" data-toggle="modal" href="#modalLabels2"></button> &nbsp;
												 <input type="text" class="labelstatus" value="4"/>
												 </div>	
												 </c:if>
												 
											</c:forEach>
												<input type="text" value="${cardLabelCNT}" />
												<c:if test="${cardLabelCNT>0 && cardLabelCNT < 5}">
												 <div class="labelCss" >
												 <button type="button" class="btn btn-default" style="border: 1px solid gray; width: 50px; height: 32px; margin-top: 10px;" data-toggle="modal" href="#modalLabels2"><i class="fa fa-plus"></i></button> &nbsp;
												 </div>		
											 	</c:if>
										</c:if> 
										</div>
                               </div>    
                           </form>
                     <!--   </div> -->
                   </div>
                   <!-- /.row (nested) -->
               </div>
               <!-- /option panel-body -->
           </div>
           <!-- /option panel -->
           </c:if>
        </div>
        
        <!-- 달력 모달 -->
	   	 <div class="modal fade" id="modalDate2" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
			  <div class="modal-dialog modal-sm" id="datemodal" role="document" style="margin: 195px 200px 200px 300px;">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h4 class="modal-title" id="exampleModalLabel" style="font-weight: bold;">Change Due Date</h5>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			      </div>
			      <div class="modal-body">
			        <form>
			          <div class="form-group">
			            <label for="recipient-name" class="col-form-label">Date</label>
			             	<div class="controls">
	        		      		<input type="text" id="datepicker2">
	        		  		</div>
			          </div>
			        </form>
			      </div>
			      <div class="modal-footer">
			        <button type="button" class="btn btn-danger" id="cardDueDateDelete">Delete</button>
			        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
			        <button type="button" class="btn btn-primary doneDate" id="doneDate">Save</button>
			      </div>
			    </div>
			  </div>
			</div> 
	        
        
		<!-- 라벨 모달 -->
	   	 <div class="modal fade" id="modalLabels2" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
			  <div class="modal-dialog modal-sm" id="labelmodal" role="document" style="margin: 195px 200px 200px 400px;">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h4 class="modal-title" id="exampleModalLabel" style="font-weight: bold;">Card Label</h5>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="float: right;">
			          <span aria-hidden="true" style="float: right;">&times;</span>
			        </button>
			      </div>
			      <div class="modal-body" >
			        <form>
			          <div class="form-group LabelCheck">
		               			<div class="[ form-group ]" >
						            <input type="checkbox" class="LabelChecklist" name="fancy-checkbox-primary" id="label6" autocomplete="off" />
						            <div class="[ btn-group ]">
						                <label for="label6" class="[ btn btn-primary LabelCheckBtn ]" style="border: 0px;">
						                    <span class="[ glyphicon glyphicon-ok LabelCheckSpan ]" style="border-right: 0px;"></span>
						                    <span> </span>
						                </label>
						                 <label for="label6" class="[ btn btn-primary LabelCheckBtn]"  style="border: 0px; width: 150px; height: 32px;" >
						                </label>
						            </div>
						        </div>
						        <div class="[ form-group ]" >
						            <input type="checkbox" class="LabelChecklist" name="fancy-checkbox-success" id="label7" autocomplete="off" />
						            <div class="[ btn-group ]">
						                <label for="label7" class="[ btn btn-success LabelCheckBtn ]" style="border: 0px;">
						                    <span class="[ glyphicon glyphicon-ok LabelCheckSpan ]"></span>
						                    <span> </span>
						                </label>
						                <label for="label7" class="[ btn btn-success LabelCheckBtn ]"  style="border: 0px; width: 150px; height: 32px;" >
						                </label>
						            </div>
						        </div>
						        <div class="[ form-group ]" >
						            <input type="checkbox" class="LabelChecklist" name="fancy-checkbox-info" id="label8" autocomplete="off" />
						            <div class="[ btn-group ]">
						                <label for="label8" class="[ btn btn-info LabelCheckBtn ]" style="border: 0px;">
						                    <span class="[ glyphicon glyphicon-ok LabelCheckSpan ]"></span>
						                    <span> </span>
						                </label>
						                <label for="label8" class="[ btn btn-info LabelCheckBtn ]" style="border: 0px; width: 150px; height: 32px;">
						                </label>
						            </div>
						        </div>
						        <div class="[ form-group ]">
						            <input type="checkbox" class="LabelChecklist" name="fancy-checkbox-warning" id="label9" autocomplete="off" />
						            <div class="[ btn-group ]">
						                <label for="label9" class="[ btn btn-warning LabelCheckBtn ]" style="border: 0px;">
						                    <span class="[ glyphicon glyphicon-ok LabelCheckSpan ]"></span>
						                    <span> </span>
						                </label>
						                <label for="label9" class="[ btn btn-warning LabelCheckBtn ]" style="border: 0px; width: 150px; height: 32px;">
						                </label>
						            </div>
						        </div>
						        <div class="[ form-group ]">
						            <input type="checkbox" class="LabelChecklist" name="fancy-checkbox-danger" id="label10" autocomplete="off" />
						            <div class="[ btn-group ]">
						                <label for="label10" class="[ btn btn-danger LabelCheckBtn ]"  style="border: 0px;">
						                    <span class="[ glyphicon glyphicon-ok LabelCheckSpan ]"></span>
						                    <span> </span>
						                </label>
						                <label for="label10" class="[ btn btn-danger LabelCheckBtn ]" style="border: 0px; width: 150px; height: 32px;">
						                </label>
						            </div>
						        </div>
						        
						    </div>
			          </div>
			        </form>
			      </div>
			    </div>
			  </div>

        
        
                	
       	<!-- 설명 -->
         <div class="panel panel-default" style="margin-top: 2%">
               <div class="panel-heading">
                  <i class="fa fa-list-ul"></i> 
                  Description
               </div>
               <div class="panel-body">
                   <div class="row">
                       <div class="col-lg-6">
                           <form role="form">
                               <div class="form-group">
                                   <textarea class="form-control" id="description" rows="3" >${cardDetailMap.DESCRIPTION}</textarea>
                               </div>
                                <button type="button" class="btn btn-default" style="font-weight: bold;" onClick="goDescription('${cardMap.CARDIDX}')"><i class="fa fa-floppy-o"></i>Save</button>        
                           </form>
                       </div>
                   </div>
                   <!-- /.row (nested) -->
               </div>
               <!-- /Description panel-body -->
           </div>
           <!-- /Description panel -->
                    
          <!-- 첨부파일 -->
         <div class="panel panel-default" style="margin-top: 5%">
             <div class="panel-heading">
                <i class="fa fa-paperclip"></i>
                Attachment
             </div>
             <div class="panel-body">
                 <div class="row">
                     <div class="col-lg-6" id="attachdiv">
                         <form role="form" name="fileFrm" enctype="multipart/form-data">
                         		<input type="hidden" name="projectIdx" value="${cardRecordIDXMap.projectIdx}"/>
								<input type="hidden" name="listIdx" value="${cardRecordIDXMap.listIdx}"/>
								<input type="hidden" name="userid" value="${sessionScope.loginuser.userid}"/>
								<input type="hidden" name="fkcardidx" value="${cardMap.CARDIDX}"/> 
                             <div class="form-group" >
                               
                             	<!-- 첨부파일 없으면 -->
                             	<c:if test="${cardDetailMap.FILENAME == null && cardDetailMap.ORGFILENAME == null && cardDetailMap.BYTE == null}">
                                 	<!--  <label>File Uplode</label> -->
                                  <input name="attach" id="attach" type="file" />   
                                  <input type="hidden" name="fk_card_idx" value="${cardMap.CARDIDX}"/>                                
                             	</div>  
                               <button type="button" class="btn btn-default" style="font-weight: bold;" onClick="goAttach()"><i class="fa fa-floppy-o"></i>Save</button>	                                       
                              </c:if>
                              
                              <!-- 첨부파일이 있으면 -->
                              <c:if test="${not empty cardDetailMap.FILENAME}">	      
                              	<c:if test="${sessionScope.loginuser != null}">                                 	
                              	<a href="<%=request.getContextPath()%>/cardFileDownload.action?cardidx=${cardMap.CARDIDX}"><i class="fa fa-download"></i> 첨부파일 : ${cardDetailMap.ORGFILENAME}</a><br/>
                              	</c:if>
                              	
                              	<c:if test="${sessionScope.loginuser == null}">
                              	첨부파일 : ${cardDetailMap.ORGFILENAME}<br/>
                              	</c:if>
                              	파일크기(Byte) : ${cardDetailMap.BYTE}
							</div> 
                          	    <button type="button" class="btn btn-default" style="font-weight: bold;" onClick="goAttachDelete('${cardMap.CARDIDX}')"><i class="fa fa-trash"></i>Delete</button>
                              </c:if>
                         </form>
                     </div>
                 </div>
                 <!-- /.row (nested) -->
             </div>
             <!-- /Attachment panel-body -->        
         </div>
         <!-- /Attachment panel -->
           
       
		
		 <!-- 체크리스트 -->
		 <div id = "checkListOption">
		   <c:if test="${cardCheckTitleMap != null}">
	         <div class="panel panel-default" style="margin-top: 5%">
	           	<!-- 체크리스트 타이틀 -->
	         
		             <div class="panel-heading"  id="checkListTitle">
		                <i class="fa fa-check-square-o"></i>
		                <span style="cursor: pointer;">${cardCheckTitleMap.CARDCHECKLISTTITLE}</span>
		             	<span style="cursor: pointer;  float: right;" id="checkListTitleDelete" ><i class="fa fa-trash"></i></span>
		             </div>
		         
		             
		             <!-- 체크리스트 타이틀 숨겨진 태그 -->
		             <div class="panel-heading" id="checkListTitleEdit">
		             	<div>
		                <i class="fa fa-check-square-o"></i>
		                <input type="text" id="checkListTitleEditvalue" style="border: none; background-color: #ffe8e8;" maxlength="16"  value="${cardCheckTitleMap.CARDCHECKLISTTITLE}" />
		                <span style="cursor: pointer;  float: right;" id="checkListTitleDelete" ><i class="fa fa-trash"></i></span>
		                </div>
		                <br/>
		                &nbsp;&nbsp;<button type="button" class="btn btn-default" style="font-weight: bold;" id="goCheckLisTitletEdit"><i class="fa fa-floppy-o"></i>Save</button>
		                &nbsp;<button type="button" class="btn btn-default" style="font-weight: bold;" id="checkListTitleCancel" ><i class="fa fa-times-circle"></i>Cancel</button>
		             </div>
	        
	             
	             <div class="panel-body">
	                 <div class="row">
	                     <div class="col-lg-6">
	                         <form role="form" name="commentFrm">
	                             <div class="form-group" id="cardCheckBoxList">
									 	
									 	<!-- 체크리스트가 있으면 -->
									 	<c:if test="${not empty cardCheckList}">
									 		<c:forEach var="list" items="${cardCheckList}" varStatus="status">
										        <div class="checkboxList">
										        	<label style="float: left;" >
											            <input type="checkbox" class="checklist"/>
											            <span class="cr"><i class="cr-icon glyphicon glyphicon-ok"></i></span>
											            <input type="hidden" id="checklistIdx${status.index}" value="${list.CARDCHECKLISTDETAILIDX}" />
											            <input type="hidden" id="checklist${status.index}" value="${list.CARDCHECKLISTTODOSTATUS}" />
											            
											        </label>
											          <span id ="checkboxlist"  style="font-weight: bold">${list.CARDCHECKLISTTODO}</span>
											          <div align="left" style="float: right;">
											          <span style="cursor: pointer;" class="checkListDelete" ><i class="fa fa-trash"></i></span>
											          <input type="hidden" id="indexval" value="${status.index}"/>
											          
											          </div>
										        </div>
										        <br/>
									        </c:forEach>
								        </c:if>
								        
	                             </div>
	                         </form>
	                         
	                      	<!-- 체크리스트 추가 -->
					        	<span id="checkListText" style="cursor: pointer;"><i class="fa fa-plus"></i>Add an item...</span> 
					        <!-- 숨겨진 태그 -->
								<div id="checkListAdd">
								 <form role="form" >
	                             <div class="form-group">
	                           		 <textarea class="form-control" rows="3" id="CheckListContent" placeholder="Add an item..."></textarea>
	                             </div>
		                            <button type="button" class="btn btn-default" style="font-weight: bold;" id="goCheckListAdd"><i class="fa fa-plus"></i>Add</button>
									<button type="button" class="btn btn-default" style="font-weight: bold;" id="checkListCancel" ><i class="fa fa-times-circle"></i>Cancel</button>      
	                        	 </form>
								</div>
	                     </div>
	                    
	                 </div>
	                 <!-- /.row (nested) -->
	             </div>
	             <!-- /Comment panel-body -->        
	         </div>
	         <!-- /Comment panel -->
			 </c:if> 
		 </div>
		  <!-- 체크리스트 끝 -->
		 
         <!-- 카드 댓글쓰기 -->
         <div class="panel panel-default" style="margin-top: 5%">
             <div class="panel-heading">
                <i class="fa fa-comment-o"></i>
                Add Comment
             </div>
             <div class="panel-body">
                 <div class="row">
                     <div class="col-lg-6">
                         <form role="form" name="commentFrm">
                             <div class="form-group">
                             	<input type="hidden" id="userid" value="${sessionScope.loginuser.userid}" />
                             	<input type="hidden" id = "nickname" value="${sessionScope.loginuser.nickname}" />
                                 <textarea class="form-control" rows="3" id="content"></textarea> 
                             </div>
                            	 <input type="hidden" id="cardidx" value="${cardMap.CARDIDX}"/>
                              <button type="button" class="btn btn-default" style="font-weight: bold;" onClick="goAddComment();"><i class="fa fa-floppy-o"></i>Save</button>        
                         </form>
                     </div>
                    
                 </div>
                 <!-- /.row (nested) -->
             </div>
             <!-- /Comment panel-body -->        
         </div>
         <!-- /Comment panel -->
                    
         <c:if test="${not empty cardCommentList}">
         
         <!-- 카드 댓글 -->
         <div class="panel panel-default" style="margin-top: 5%">
             <div class="panel-heading">
                <i class="fa fa-commenting"></i>
                Comment
             </div>
             <div class="panel-body">
                 <div class="row">
                     <div class="col-lg-6" id="commentList" >
                      <input type="hidden" id="cardCommentListLength" value = "${fn:length(cardCommentList)}"> <!-- 수정버튼 눌렀을때 리스트 보여주는 태그를 hide하기 위해서 사용 --> 
                            <c:forEach var="map" items="${cardCommentList}" varStatus="status">
                     		  <!-- 댓글 리스트 보여주기 -->
                       	    <div id = "comment${status.count}" >
                         	  <c:if test="${status.count !=1 }">
                         	    <hr style="border: solid 1px grey;"/>
                         	  </c:if>
                              <form role="form">
                                <div class="form-group">
                                	${map.CARDNICKNAME}<br/>	                                        
                                	<div class="commentCss">
								 <!--  <img src="/w3images/bandmember.jpg" alt="Avatar" style="width:100%;"> -->
								  <p>${map.CARDCOMMENTCONTENT}</p>
								</div>
								<div align="right">
								<span style="color:grey; font-size: 10px; text-align: right; font-weight: bold;">${map.CARDCOMMENTDATE}</span>
								</div>
                                </div>
                               	 <c:if test="${sessionScope.loginuser.userid == map.CARDCOMMENTUSERID}">
                                 <button type="button" class="btn btn-default" style="font-weight: bold;" onClick="goCommentEdit('${status.count}','${map.CARDCOMMENTCONTENT}');"><i class="fa fa-pencil-square-o"></i>Edit</button>
                            	 <button type="button" class="btn btn-default" style="font-weight: bold;" onClick="goCommentDelete('${cardMap.CARDIDX}','${map.CARDCOMMENTIDX}')"><i class="fa fa-trash"></i>Delete</button>
                                <%--  <button type="button" class="btn btn-default btnDelete" style="font-weight: bold;"><i class="fa fa-trash"></i>Delete</button><input type="text" value="${cardMap.CARDIDX}"/><input type="text" value="${map.CARDCOMMENTIDX}" /> --%>   
                                 </c:if>
                            </form>
                          	 </div>
	                                    
                             <!-- 댓글 수정하기-->
                             <div id="commentEdit${status.count}" >
                             	<c:if test="${status.count !=1 }">
	                        	   	<hr style="border: solid 1px grey;"/>
	                           	</c:if>
	                           	<form role="form">
	                               <div class="form-group" >
                                     <textarea class="form-control" rows="3"  name="content" id="Editcontent${status.count}"></textarea> 
                                     <input type="hidden" id="EditOldcontent${status.count}" value="${map.CARDCOMMENTCONTENT}"/>
                                 </div>
                                  <button type="button" class="btn btn-default" style="font-weight: bold;" onClick="goEditComment('${cardMap.CARDIDX}','${map.CARDCOMMENTIDX}','${status.count}');"><i class="fa fa-floppy-o"></i>Save</button>
                                  <button type="button" class="btn btn-default" style="font-weight: bold;" onClick="goCommentCancel('${status.count}');"><i class="fa fa-times-circle"></i>Cancel</button>  
                                </form>       
                         	</div>
                             <br/>
                          </c:forEach>   
                   	    </div>        
                    <!-- /.row (nested) -->
                </div>
                <!-- /Comment panel-body -->        
            </div>
            <!-- /Comment panel -->
            </div>
            </c:if>
                    
           <div id="recordSelect">
			<!-- 카드 기록 -->
					<button class="collapsible" style="border :1px solid #ddd; border-top-left-radius: 3px; border-top-right-radius: 3px;"> <i class="fa fa-list-alt"></i>
                       Activity</button>
	
				<div class="content" style="border:1px solid #ddd; border-top-left-radius: 3px; border-top-right-radius: 3px;">
				<c:forEach var="cardRecordMap" items="${cardRecordList}">
				  <p>
					  <div class="form-group" id="cardrecord">
		                    ${cardRecordMap.NICKNAME}<br/>	                                        
		                <div class="commentCss">
							 <!--  <img src="/w3images/bandmember.jpg" alt="Avatar" style="width:100%;"> -->
							  <p>${cardRecordMap.RECORDDMLSTATUS}</p>
						</div>
						<div align="right">
							<span style="color:grey; font-size: 10px; text-align: right; font-weight: bold;">${cardRecordMap.PROJECTRECORDTIME}</span>
						</div>
       		          </div>
					  </p>
				  </c:forEach>
				</div>
			</div>
									
					<script>
					var coll = document.getElementsByClassName("collapsible");
					var i;
					
					for (i = 0; i < coll.length; i++) {
					    coll[i].addEventListener("click", function() {
					        this.classList.toggle("active");
					        var content = this.nextElementSibling;
					        if (content.style.display === "block") {
					           content.style.display = "none";
					           // content.style.display = "block";
					        } else {
					            content.style.display = "block";
					        }
					    });
					}
					</script>
					<!-- /Activity button -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

</body>

</html>