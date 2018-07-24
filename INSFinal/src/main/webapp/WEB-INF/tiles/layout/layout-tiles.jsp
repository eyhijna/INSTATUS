<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- ===== #35. tiles 를 사용하는 레이아웃 페이지 만들기  ===== --%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"  %>    
    
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Creative - Bootstrap 3 Responsive Admin Template">
  <meta name="author" content="GeeksLabs">
  <meta name="keyword" content="Creative, Dashboard, Admin, Template, Theme, Bootstrap, Responsive, Retina, Minimal">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="shortcut icon" href="img/favicon.png"> 
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script> 
  
  
  <title>Final INS</title>


  <!-- Bootstrap CSS -->
  <link href="<%=request.getContextPath() %>/resources/css/bootstrap.min.css" rel="stylesheet"> 
  <!-- bootstrap theme -->
  <link href="<%=request.getContextPath() %>/resources/css/bootstrap-theme.css" rel="stylesheet">
  <!--external css-->
  <!-- font icon -->
  <link href="<%=request.getContextPath() %>/resources/css/elegant-icons-style.css" rel="stylesheet" />
  <link href="<%=request.getContextPath() %>/resources/css/font-awesome.min.css" rel="stylesheet" />
  <!-- full calendar css-->
  <link href="<%=request.getContextPath() %>/resources/assets/fullcalendar/fullcalendar/bootstrap-fullcalendar.css" rel="stylesheet" />
  <link href="<%=request.getContextPath() %>/resources/assets/fullcalendar/fullcalendar/fullcalendar.css" rel="stylesheet" />
  <!-- easy pie chart-->
  <link href="<%=request.getContextPath() %>/resources/assets/jquery-easy-pie-chart/jquery.easy-pie-chart.css" rel="stylesheet" type="text/css" media="screen" />
  <!-- owl carousel -->
  <link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/owl.carousel.css" type="text/css">
  <link href="<%=request.getContextPath() %>/resources/css/jquery-jvectormap-1.2.2.css" rel="stylesheet">
  <!-- Custom styles -->
  <link rel="stylesheet" href="<%=request.getContextPath() %>/resources/css/fullcalendar.css">
  <link href="<%=request.getContextPath() %>/resources/css/widgets.css" rel="stylesheet">
  <link href="<%=request.getContextPath() %>/resources/css/style.css" rel="stylesheet">
  <link href="<%=request.getContextPath() %>/resources/css/style-responsive.css" rel="stylesheet" />
  <link href="<%=request.getContextPath() %>/resources/css/xcharts.min.css" rel=" stylesheet">
  <link href="<%=request.getContextPath() %>/resources/css/jquery-ui-1.10.4.min.css" rel="stylesheet">
  
 


  <!-- =======================================================
    Theme Name: NiceAdmin
    Theme URL: https://bootstrapmade.com/nice-admin-bootstrap-admin-html-template/
    Author: BootstrapMade
    Author URL: https://bootstrapmade.com
  ======================================================= -->
  <style type="text/css">
/*   
     추후에 모여서 수정하는 걸로 한다.
     #myheader {border: 3px solid blue;} 
     
      #mycontainer {border: 3px solid yellow;}
      */
     
     

 
	#mycontent		{ min-height: 800px;  padding-top: 40px; border: 0px red solid;} /*margin-right:10%;  */
/* 
	#myfooter		{ background-color:#555555; clear:both; height:100px; } */
	
		.avatar {
	    vertical-align: middle;
	    width: 50px;
	    height: 50px;
	    border-radius: 50%;
	}
	
	@import url('https://fonts.googleapis.com/css?family=Do+Hyeon');
	
	

/* 	 body {
	    font-family: "Lato", sans-serif;
	}
	
	.sidenav {
	    height: 100%;
	    width: 0;
	    position: fixed;
	    z-index: 1;
	    top: 0;
	    left: 0;
	    background-color: #111;
	    overflow-x: hidden;
	    transition: 0.5s;
	    padding-top: 150px;
	}
	
	.sidenav a {
	    padding: 8px 8px 8px 32px;
	    text-decoration: none;
	    font-size: 25px;
	    color: #818181;
	    display: block;
	    transition: 0.3s;
	}
	
	.sidenav a:hover {
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
	  .sidenav a {font-size: 18px;}
	} */

	</style>
</head>

<body>
	<div id="mycontainer">
		<div id="myheader">
			<tiles:insertAttribute name="header" />
		</div>
	
		<div id="mycontent">
			<tiles:insertAttribute name="content" />
		</div>

	
		<%-- <div id="myfooter">
			<tiles:insertAttribute name="footer" />
		</div> --%>
	</div>
</body>
</html>