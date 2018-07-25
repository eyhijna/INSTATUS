<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     
<script type="text/javascript">
 $(document).ready(function(){
	 
	 
	 
	 /* $(document).on("hide","checkListAdd",function(){ });
	 $(document).on("hide","checkListTitleEdit",function(){ }); */

	 
	$("#cardDelete").bind("click",function(){
		//$('#modal').modal('hide');
		var cardidx = $("#cardidx").val();
		goCardDelete(cardidx);
	}); // end of $("#cardDelete").bind()
	
	// DueDate 저장 클릭시
	$(".doneDate").bind("click",function(){
		alert("DueDate 저장 클릭시");
		$('#modalDate').modal('hide');
		$('#modalDate2').modal('hide');
		var cardidx = $("#cardidx").val();
		var datepicker1 = $("#datepicker1").val();
		var datepicker2 = $("#datepicker2").val();
		var cardduedateIdx = $("#cardduedateIdx").val();
		alert(cardduedateIdx);
		if(datepicker1 == "" && datepicker2 ==""){ // DueDate가 값이 없으면
			alert("날짜를 입력하세요");
			return;
		 }else if(datepicker1 != "" && datepicker2 ==""){ // DueDate1의 값이 있으면
			 if(cardduedateIdx == "" || cardduedateIdx== 0){
			 goDueDateAdd(cardidx,datepicker1);
			 }else{
				 alert("확인용1");
				goDueDateEdit(cardidx,datepicker1);// DueDate2의 값이 있고 DueDate1의 값을 수정하면
			 }
		 }else if(datepicker1 =="" && datepicker2 !=""){// DueDate2의 값이 있으면
			 alert("확인용2");
			goDueDateEdit(cardidx,datepicker2 );
		 }else if(datepicker1 !="" && datepicker2 !=""){
			 alert("확인용3");
			goDueDateEdit(cardidx,datepicker1);
		 }

	}); // end of $("#doneDate").bind()
    
	// DueDate Ajax 처리 후 체크 해제 및 체크 
	$(document).on("click","#dateCheck",function(){
		 var checkBox = document.getElementById("dateCheck");
		 if (checkBox.checked == true){
			 checkChange();
		 }else{
			 checkChange();
		 }
	
	});
	
	// DueDate 삭제
	$("#cardDueDateDelete").bind("click",function(){
		$('#modalDate').modal('hide');
		$('#modalDate2').modal('hide');
		
		var cardidx = $("#cardidx").val();
		var cardduedateIdx = $("#cardduedateIdx").val();
		//alert("확인용cardDueDateDelete cardduedateIdx: "+cardduedateIdx);
		
		if(cardduedateIdx !=""){
		goDueDateDelete(cardidx,cardduedateIdx);
		}else{
			alert("삭제할 Dudate가 없습니다.");
			location.href="javascript:history.go(0);"
			return;
		}
	}); // end of $("#cardDueDateDelete").bind()
	
	// 체크리스트 타이틀 생성시
	$("#checkList").bind("click",function(){
		$("#modalChecklist").modal('hide');
		
		var cardidx = $("#cardidx").val();
		var checkListTitleName = $("#checkListTitleName").val();
		goCheckListTitleAdd(cardidx,checkListTitleName);
				
	});// end of $("#checkList").bind()

	// 체크리스트타이틀 수정
	$(document).on("click","#goCheckLisTitletEdit",function(){	
		goCheckLisTitletEdit();
	});
	
	// 체크리스트 추가  
	$(document).on("click","#goCheckListAdd",function(){
		goCheckListAdd();
	});

	// 라벨 클릭 시 추가
	$(document).on("click",".LabelChecklist",function(){
		 var checkBox = $(this).val();
		var checkBoxid= $(this).attr('id');
		if(checkBoxid =="label1" || checkBoxid =="label6" ){
			checkBoxid = "0";
		}else if(checkBoxid =="label2" || checkBoxid =="label7" ){
			checkBoxid = "1";
		}else if(checkBoxid =="label3" || checkBoxid =="label8" ){
			checkBoxid = "2";
		}else if(checkBoxid =="label4" || checkBoxid =="label9" ){
			checkBoxid = "3";
		}else if(checkBoxid =="label5" || checkBoxid =="label10" ){
			checkBoxid = "4";
		}
	
		 if (checkBox.checked == true){
			 goLabelAdd(checkBoxid);
		 }else{
			 goLabelAdd(checkBoxid);
		 }  
	});
	
	
	 var arr = new Array();
	 $(".labelstatus").each(function(index){ // arr 저장된 라벨을 배열에 담아준다.
	
		arr.push($(this).val());
		
	 });
	if (arr.indexOf("0") != -1) { // 같다면
		$("#label1").prop("checked", true);
		$("#label6").prop("checked", true);
	}else{
		$("#label1").prop("checked", false);
		$("#label6").prop("checked", false);
	}
	
	if (arr.indexOf("1") != -1) { // 같다면
		$("#label2").prop("checked", true);
		$("#label7").prop("checked", true);
	}else{
		$("#label2").prop("checked", false);
		$("#label7").prop("checked", false);
	}
	if (arr.indexOf("2") != -1) { // 같다면
		$("#label3").prop("checked", true);
		$("#label8").prop("checked", true);
	}else{
		$("#label3").prop("checked", false);
		$("#label8").prop("checked", false);
	}
	if (arr.indexOf("3") != -1) { // 같다면
		$("#label4").prop("checked", true);
		$("#label9").prop("checked", true);
	}else{
		$("#label4").prop("checked", false);
		$("#label9").prop("checked", false);
	}
	if (arr.indexOf("4") != -1) { // 같다면
		$("#label5").prop("checked", true);
		$("#label10").prop("checked", true);
	}else{
		$("#label5").prop("checked", false);
		$("#label10").prop("checked", false);
	}

 });// end of $(document).ready()

 // 달력
 $(function() {
	  $( "#datepicker1" ).datepicker({
	    dateFormat: 'yy-mm-dd'
	  });
	  
	  $( "#datepicker2" ).datepicker({
		    dateFormat: 'yy-mm-dd'
	 });
});

// card 안 로그인 체크
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

/* 카드 삭제 */
function goCardDelete(cardidx){
	var CNT = LoginCheck();
	if(CNT != 0){
		var form_data = {cardidx :  cardidx,	               
						projectIdx : $("#projectIdx").val(),
                 		listIdx : $("#listIdx").val(),
                 		userid : $("#userid").val()
                 }
		
		$.ajax({		
	 		url:"cardDelete.action",
	 		type:"POST",
	 		data : form_data,
	 		success: function() {
	 			$("#description").val(json.DESCRIPTION);
	 			cardRecordInfo();
	 		}, 
	 		error: function(request, status, error){ 
	 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
	 		}
	 	
	 	}); // end of ajax({})
				
	}

}// end of goCardDelete()

// 카드 DueDate 생성
function goDueDateAdd(cardidx,datepicker){

 var CNT = LoginCheck();
	if(CNT != 0){
		var form_data = {cardidx :  cardidx,
				datepicker : datepicker
				}

		$.ajax({		
	 		url:"goDueDateAdd.action",
	 		type:"POST",
	 		data : form_data,
	 		dataType: "JSON",
     		success: function(json) {
     			$("#option").empty();
	 	        var html = "<div class='panel panel-default' style='margin-top: 2%'>"
	 	              + "<div class='panel-heading'><i class='fa fa-plus'></i>" 
	 	              + "Option"
	 	              + "</div>"
	 	              + "<div class='panel-body'>"
	 	              +  "<div class='row'>"
	 	              +     	"<div class='col-lg-6'>"
	 	              +            "<form role='form'>"
	 	              +                "<div class='form-group'>"
	 				  +					"<div class='commentCss dueCheck' id='dueCheck' style='padding: 10px 10px 1px 10px; margin: 10px 600px 10px 0px;'>"
	 				  +					  "<p><input type='checkbox' id='dateCheck'>"
	 				  +						 "<span data-toggle='modal' href='#modalDate2'>"+json.CARDDUEDATE+"</span></p>"
	 				  +						"</div>"
	 	              +                 "</div>"    
	 	              +             "</form>"
	 	              +         "</div>"
	 	              +     "</div>"
	 	              + "</div>"
	 	              + "</div>"
	 	           
	 	          $("#option").html(html);
	 	              
	 	          $("#cardduedateIdx").val(json.CARDDUEDATEIDX);
	 	          
	 		}, 
	 		error: function(request, status, error){ 
	 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
	 		}
	 	
	 	}); // end of ajax({})
	}
}// end of goDueDateAdd()

// 카드 DueDate 수정
function goDueDateEdit(cardidx,datepicker){
	 var CNT = LoginCheck();
		if(CNT != 0){
			var form_data = {cardidx :  cardidx,
					datepicker : datepicker,
					cardduedateIdx : $("#cardduedateIdx").val()
					}
	
			$.ajax({		
		 		url:"goDueDateEdit.action",
		 		type:"POST",
		 		data : form_data,
		 		dataType: "JSON",
	     		success: function(json) {
	     			$("#option").empty();
		 	        var html = "<div class='panel panel-default' style='margin-top: 2%'>"
		 	              + "<div class='panel-heading'><i class='fa fa-plus'></i>" 
		 	              + "Option"
		 	              + "</div>"
		 	              + "<div class='panel-body'>"
		 	              +  "<div class='row'>"
		 	              +     	"<div class='col-lg-6'>"
		 	              +            "<form role='form'>"
		 	              +                "<div class='form-group'>"
		 				  +					"<div class='commentCss dueCheck' id='dueCheck' style='padding: 10px 10px 1px 10px; margin: 10px 600px 10px 0px;'>"
		 				  +					  "<p><input type='checkbox' id='dateCheck'>"
		 				  +						 "<span data-toggle='modal' href='#modalDate2'>"+json.CARDDUEDATE+"</span></p>"
		 				  +						"</div>"
		 	              +                 "</div>"    
		 	              +             "</form>"
		 	              +         "</div>"
		 	              +     "</div>"
		 	              + "</div>"
		 	              + "</div>"
		 	           
		 	          $("#option").html(html);
		 	              
	     			if(json.CARDCHECK == 0){ // 체크가 안된 상태
	     			
						$(".dueCheck").removeClass("duedateCheck");
						$("#dateCheck").prop("checked", false);
					}else if(json.CARDCHECK == 1){ // 체크가 된 상태
					
						 $(".dueCheck").addClass("duedateCheck");
						$("#dateCheck").prop("checked", true);
					}
	     			
	     			$("#cardduedateIdx").val(json.CARDDUEDATEIDX);
		 		}, 
		 		error: function(request, status, error){ 
		 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
		 		}
		 	
		 	}); // end of ajax({})
		}
 }// end of goDueDateEdit()
 
function goDueDateDelete(cardidx,cardduedateIdx){
	 var CNT = LoginCheck();
		if(CNT != 0){
			var form_data = {cardidx :  cardidx,
					cardduedateIdx : $("#cardduedateIdx").val()
					}
	
			$.ajax({		
		 		url:"goDueDateDelete.action",
		 		type:"POST",
		 		data : form_data,
		 	 	dataType: "JSON", 
	     		success: function(json) {
	     			$("#option").empty();
	     			alert("delete : "+ json.CARDDUEDATECNT);
		 	        $("#cardduedateIdx").val(json.CARDDUEDATECNT); 
		 	       
		 		}, 
		 		error: function(request, status, error){ 
		 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
		 		}
		 	
		 	}); // end of ajax({})
		}
 }// end of goDueDateDelete()
 
 // 체크리스트 타이틀 추가
 function goCheckListTitleAdd(cardidx,checkListTitleName){
	 var CNT = LoginCheck();
		if(CNT != 0){
			var form_data = {cardidx :  cardidx,
					checkListTitleName : checkListTitleName
					}
	
			$.ajax({		
		 		url:"goCheckListTitleAdd.action",
		 		type:"POST",
		 		data : form_data,
		 	 	dataType: "JSON", 
	     		success: function(json) { 
	     		
	     		if(json.TitleCheck==0){
		     			$("#checkListOption").empty();
		     			
			       var html =  "<div class='panel panel-default' style='margin-top: 5%'>"
			             	+ 	"<div class='panel-heading' id='checkListTitle'>"
			              	+  		"<i class='fa fa-check-square-o'></i>"
			               	+		"<span style='cursor: pointer;'>"+json.CARDCHECKLISTTITLE+"</span>"
			                +		"<span style='cursor: pointer;  float: right;' id='checkListTitleDelete' ><i class='fa fa-trash'></i></span>"
			            	+	"</div>"
			             	+ 	"<div class='panel-heading' id='checkListTitleEdit'>"
			             	+ 		"<div>"
			                + 			"<i class='fa fa-check-square-o'></i>"
			                +			"<input style='border: none; background-color: #ffe8e8;' id='checkListTitleEditvalue' maxlength='16' value='"+json.CARDCHECKLISTTITLE+"' />"
			                +			"<input type='hidden' id= 'checkListTitleAjaxvalue' value='"+json.CARDCHECKLISTTITLE+"' />"
			                +			"<span style='cursor: pointer;  float: right;' id='checkListTitleDelete' ><i class='fa fa-trash'></i></span>"
			                +		"</div>"
			                + 		"<br/>"
			                +		"&nbsp;&nbsp;<button type='button' class='btn btn-default' style='font-weight: bold;' id = 'goCheckLisTitletEdit'><i class='fa fa-floppy-o'></i>Save</button>"
			                +		"&nbsp;<button type='button' class='btn btn-default' style='font-weight: bold;' id='checkListTitleCancel'><i class='fa fa-times-circle'></i>Cancel</button>"
			             	+	 "</div>"
			             	+	 "<div class='panel-body'>"
			                + 		"<div class='row'>"
			                +   		"<div class='col-lg-6'>"
			                +		         "<form role='form' name='commentFrm'>"
			                +		             "<div class='form-group' id='cardCheckBoxList'>"	             
									                
			                +			         "</div>"
			                +     		 	 "</form>"      
							+        		 "<span id='checkListText' style='cursor: pointer;'><i class='fa fa-plus'></i>Add an item...</span>"
							+			"<div id='checkListAdd'>"
							+			"<form role='form'>"
			                +             	"<div class='form-group'>"
			                +           		 "<textarea class='form-control' rows='3' id='CheckListContent' placeholder='Add an item...'></textarea>"
			                +             	"</div>"
				            +               "<button type='button' class='btn btn-default' style='font-weight: bold;' id='goCheckListAdd'><i class='fa fa-plus'></i>Add</button>"
							+				"<button type='button' class='btn btn-default' style='font-weight: bold;' id='checkListCancel' ><i class='fa fa-times-circle'></i>Cancel</button>"      
			                +        	"</form>"
							+			"</div>"
			                +   	 "</div>"
			                + 	 "</div>"
			             	+ 	"</div>"    
			         		+ "</div>"
			        
		       	 	$("#checkListOption").html(html);
		         		
		          	$("#checkListAdd").hide();		
		          	$("#checkListTitleEdit").hide();	
		       		$(document).on("click","#checkListTitle",function(){
			      		$("#checkListTitleEdit").show();
			      		$("#checkListTitle").hide();
		      		});

		        	$(document).on("click","#checkListTitleCancel",function(){
		        		$("#checkListTitleEdit").hide();
		      			$("#checkListTitle").show();
		        	});
		        
		        	$(document).on("click","#checkListText",function(){
		        		$("#checkListAdd").show();
		      			$("#checkListText").hide();
		        	});
		        
		        	$(document).on("click","#checkListCancel",function(){
		        		$("#checkListAdd").hide();
		      			$("#checkListText").show();
		        	}); 
			       		 		
		        	$("#checkListTitleName").val("");

	     			}else{
	     				alert("체크리스트가 존재 합니다. 더 이상 생성 불가능합니다.");
	     				location.href="javascript:history.go(0);"
	     				return;
	     			}
	     		
	     	  		$("#cardchecklistIdx").val(json.CARDCHECKLISTIDX); 
	     			
		 		}, 
		 		error: function(request, status, error){ 
		 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
		 		}
		 	
		 	}); // end of ajax({})
		}
 }// end of goDueDateDelete()
 
 function goLabelAdd(labelid){
	 var arr = new Array();
	 $(".labelstatus").each(function(index){ // arr 저장된 라벨을 배열에 담아준다.
	
		arr.push($(this).val());
		
	 });
	 
	 /* document.write(arr); */
	 
	 var CNT = LoginCheck();
		if(CNT != 0){
			if (arr.indexOf(labelid) != -1) {  //  저장된 라벨 번호가 추가되는 라벨과 값이 같다면 
				alert("라벨이 존재합니다.");
				location.href="javascript:history.go(0);"
     			return;
				
			}else {// 저장된 라벨 번호가 추가되는 라벨과 값지 않으면
				alert("시작");
				var form_data = {cardidx :  $("#cardidx").val(),
								labelid : labelid
								}
			
				$.ajax({		
			 		url:"goLabelAdd.action",
			 		type:"POST",
			 		data : form_data,
			 	 	//dataType: "JSON", 
		     		success: function() {
		     			labelselect();
			 		}, 
			 		error: function(request, status, error){ 
			 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
			 		}
			 	
			 	}); // end of ajax({})
			}
		}// end of CNT
 }// end of goLabelAdd(labelid)
 
 // 라벨 선택
 function labelselect(){
	var form_data = {cardidx :  $("#cardidx").val()
						}
	
		$.ajax({		
	 		url:"labelselect.action",
	 		type:"POST",
	 		data : form_data,
	 	 	dataType: "JSON", 
     		success: function(json) {
     			
     			if(json.length > 0){
	     			$("#cardLabel").empty();
	     			
	     			var html ="";
	     			
	     			$.each(json, function(entryIndex, entry){
						if(entry.CARDLABEL == "0"){
							html +=	"<div class='labelCss'>";
							html +=	"	<button type='button' class='btn btn-primary' style='border: 0px; width: 50px; height: 32px; margin-top: 10px;' data-toggle='modal' href='#modalLabels2'></button> &nbsp;";
							html +=	" 	<input type='text' class='labelstatus' value='0'/>";
							html +=	"</div>";
							
						}else if(entry.CARDLABEL == "1"){
							html +=	"<div class='labelCss'>";
							html +=	"	<button type='button' class='btn btn-success' style='border: 0px; width: 50px; height: 32px; margin-top: 10px;' data-toggle='modal' href='#modalLabels2'></button> &nbsp;";
							html +=	" 	<input type='text' class='labelstatus' value='1'/>";
							html +=	"</div>";
						}else if(entry.CARDLABEL == "2"){
							html +=	"<div class='labelCss'>";
							html +=	"	<button type='button' class='btn btn-info' style='border: 0px; width: 50px; height: 32px; margin-top: 10px;' data-toggle='modal' href='#modalLabels2'></button> &nbsp;";
							html +=	" 	<input type='text' class='labelstatus' value='2'/>";
							html +=	"</div>";
						}else if(entry.CARDLABEL == "3"){
							html +=	"<div class='labelCss'>";
							html +=	"	<button type='button' class='btn btn-warning' style='border: 0px; width: 50px; height: 32px; margin-top: 10px;' data-toggle='modal' href='#modalLabels2'></button> &nbsp;";
							html +=	" 	<input type='text' class='labelstatus' value='3'/>";
							html +=	"</div>";
						}else if(entry.CARDLABEL == "4"){
							html +=	"<div class='labelCss'>";
							html +=	"	<button type='button' class='btn btn-danger' style='border: 0px; width: 50px; height: 32px; margin-top: 10px;' data-toggle='modal' href='#modalLabels2'></button> &nbsp;";
							html +=	" 	<input type='text' class='labelstatus' value='4'/>";
							html +=	"</div>";
						}
					
					}); //end of each
					
					$("#cardLabel").html(html);
					
					//cardLabelCNT();
     			}
	 		}, 
	 		error: function(request, status, error){ 
	 			alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
	 		}
	 	
	 	}); // end of ajax({})
 }
 
 function cardLabelCNT(){
		var form_data = {cardidx :  $("#cardidx").val()
		}

		$.ajax({		
		url:"labelcnt.action",
		type:"POST",
		data : form_data,
		dataType: "JSON", 
		success: function(json) {
			
			/* 	var html ="";
					
				json.<c:if test="${cardLabelCNT>0 && cardLabelCNT < 5}">
				 <div class="labelCss" >
				 <button type="button" class="btn btn-default" style="border: 1px solid gray; width: 50px; height: 32px; margin-top: 10px;" data-toggle="modal" href="#modalLabels2"><i class="fa fa-plus"></i></button> &nbsp;
				 </div>		
			 	</c:if>
				
				$("#cardLabel").html(html); */
			
			}, 
			error: function(request, status, error){ 
				alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
			}
			
			}); // end of ajax({})
 }
 </script>
 <div class="navbar-default sidebar" role="navigation">
     <div class="sidebar-nav navbar-collapse">
         <ul class="nav" id="side-menu">

			<!-- 라벨 버튼-->
             <button type="button" class="btn btn-outline btnSideBar  btn-lg btn-block" data-toggle="modal" href="#modalLabels1"><i class="fa fa-tag"></i> Labels</button>
           	
           	<!-- 체크리스트 버튼 -->
             <button type="button" class="btn btn-outline btnSideBar btn-lg btn-block" data-toggle="modal" href="#modalChecklist"><i class="fa fa-check-square-o"></i> Checklist</button>
            
            <!-- 완료일 버튼 -->
             <button type="button" class="btn btn-outline btnSideBar btn-lg btn-block" data-toggle="modal" href="#modalDate"><i class="fa fa-calendar-check-o"></i> Due Date</button>
            
            <!-- 삭제 버튼 -->
             <button type="button" class="btn btn-outline btnSideBar btn-lg btn-block" data-toggle="modal" href="#modalDelete"><i class="fa fa-trash"></i> Delete</button>
  
         </ul>
     </div>
     <!-- /.sidebar-collapse -->
 </div>
 <!-- /.navbar-static-side -->
    
	<!-- 라벨 모달 -->
   	 <div class="modal fade" id="modalLabels1" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		  <div class="modal-dialog modal-sm" id="labelmodal" role="document">
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
					            <input type="checkbox" class="LabelChecklist" name="fancy-checkbox-primary" id="label1" autocomplete="off" />
					            <div class="[ btn-group ]">
					                <label for="label1" class="[ btn btn-primary LabelCheckBtn ]" style="border: 0px;">
					                    <span class="[ glyphicon glyphicon-ok LabelCheckSpan ]" style="border-right: 0px;"></span>
					                    <span> </span>
					                </label>
					                 <label for="label1" class="[ btn btn-primary LabelCheckBtn]"  style="border: 0px; width: 150px; height: 32px;" >
					                </label>
					            </div>
					        </div>
					        <div class="[ form-group ]" >
					            <input type="checkbox" class="LabelChecklist" name="fancy-checkbox-success" id="label2" autocomplete="off" />
					            <div class="[ btn-group ]">
					                <label for="label2" class="[ btn btn-success LabelCheckBtn ]" style="border: 0px;">
					                    <span class="[ glyphicon glyphicon-ok LabelCheckSpan ]"></span>
					                    <span> </span>
					                </label>
					                <label for="label2" class="[ btn btn-success LabelCheckBtn ]"  style="border: 0px; width: 150px; height: 32px;" >
					                </label>
					            </div>
					        </div>
					        <div class="[ form-group ]" >
					            <input type="checkbox" class="LabelChecklist" name="fancy-checkbox-info" id="label3" autocomplete="off" />
					            <div class="[ btn-group ]">
					                <label for="label3" class="[ btn btn-info LabelCheckBtn ]" style="border: 0px;">
					                    <span class="[ glyphicon glyphicon-ok LabelCheckSpan ]"></span>
					                    <span> </span>
					                </label>
					                <label for="label3" class="[ btn btn-info LabelCheckBtn ]" style="border: 0px; width: 150px; height: 32px;">
					                </label>
					            </div>
					        </div>
					        <div class="[ form-group ]">
					            <input type="checkbox" class="LabelChecklist" name="fancy-checkbox-warning" id="label4" autocomplete="off" />
					            <div class="[ btn-group ]">
					                <label for="label4" class="[ btn btn-warning LabelCheckBtn ]" style="border: 0px;">
					                    <span class="[ glyphicon glyphicon-ok LabelCheckSpan ]"></span>
					                    <span> </span>
					                </label>
					                <label for="label4" class="[ btn btn-warning LabelCheckBtn ]" style="border: 0px; width: 150px; height: 32px;">
					                </label>
					            </div>
					        </div>
					        <div class="[ form-group ]">
					            <input type="checkbox" class="LabelChecklist" name="fancy-checkbox-danger" id="label5" autocomplete="off" />
					            <div class="[ btn-group ]">
					                <label for="label5" class="[ btn btn-danger LabelCheckBtn ]"  style="border: 0px;">
					                    <span class="[ glyphicon glyphicon-ok LabelCheckSpan ]"></span>
					                    <span> </span>
					                </label>
					                <label for="label5" class="[ btn btn-danger LabelCheckBtn ]" style="border: 0px; width: 150px; height: 32px;">
					                </label>
					            </div>
					        </div>
					        
					    </div>
		          </div>
		        </form>
		      </div>
		    </div>
		  </div>
	
		
	<!-- 체크리스트 모달 -->
   	 <div class="modal fade" id="modalChecklist" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		  <div class="modal-dialog modal-sm" id="checklistmodal" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h4 class="modal-title" id="exampleModalLabel" style="font-weight: bold;">Card Title</h5>
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		          <span aria-hidden="true">&times;</span>
		        </button>
		      </div>
		      <div class="modal-body">
		        <form>
		          <div class="form-group">
		            <label for="recipient-name" class="col-form-label">Title</label>
		            <input type="text" class="form-control"  maxlength="16" id="checkListTitleName">
		          </div>
		        </form>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		        <button type="button" class="btn btn-default" id="checkList">Save</button>
		      </div>
		    </div>
		  </div>
		</div> 
		
	<!-- 달력 모달 -->
   	 <div class="modal fade" id="modalDate" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		  <div class="modal-dialog modal-sm" id="datemodal" role="document">
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
        		      		<input type="text" id="datepicker1">
        		  		</div>
		          </div>
		        </form>
		      </div>
		      <div class="modal-footer">
		      	<button type="button" class="btn btn-danger" id="cardDueDateDelete">Delete</button>
		        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		        <button type="button" class="btn btn-default doneDate" id="doneDate">Save</button>
		      </div>
		    </div>
		  </div>
		</div> 
		
	<!-- 삭제 모달 -->
   	 <div class="modal fade" id="modalDelete" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
		  <div class="modal-dialog modal-sm" id="deletemodal" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h4 class="modal-title" id="exampleModalLabel" style="font-weight: bold; margin-right: 30px;">Delete Card</h5>
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		          <span aria-hidden="true">&times;</span>
		        </button>
		      </div>
		      <div class="modal-body">
		        <form>
		          <div class="form-group">
		            <label for="recipient-name" class="col-form-label">카드를 삭제 하시겠습니까?</label>
		          </div>
		        </form>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		        <button type="button" class="btn btn-danger" id="cardDelete">Delete</button>
		      </div>
		    </div>
		  </div>
		</div> 