<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
   
<jsp:include page="top.jsp" /> 



<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/export-data.js"></script>

<script src="https://code.highcharts.com/modules/data.js"></script>
<script src="https://code.highcharts.com/modules/drilldown.js"></script>

<script type="text/javascript" src="<%= request.getContextPath() %>/resources/js/jquery-3.3.1.min.js"></script>

 

<style type="text/css">
   table#tblGender {width: 100%;
                    margin-top: 10%;
                    border: 1px solid gray;
                    border_collapse: collapse;}
                    
   table#tblGender th, table#tblGender td {border: 1px solid gray;
                                           text-align: center;} 
                                                               
   table#tblGender th {background-color: #ffffe6;}

</style>



<script type="text/javascript">

  $(document).ready(function(){
	  
	 loopshowNowTime();
	 showRank();
		
  });

  ////////////////////////////////////////////////////////////////////////////////////////////////
	function showNowTime() {
		
		var now = new Date();
	
		var strNow = now.getFullYear() + "-" + (now.getMonth() + 1) + "-" + now.getDate();
		
		var hour = "";
		if(now.getHours() > 12) {
			hour = " 오후 " + (now.getHours() - 12);
		} else if(now.getHours() < 12) {
			hour = " 오전 " + now.getHours();
		} else {
			hour = " 정오 " + now.getHours();
		}
		
		var minute = "";
		if(now.getMinutes() < 10) {
			minute = "0"+now.getMinutes();
		} else {
			minute = ""+now.getMinutes();
		}
		
		var second = "";
		if(now.getSeconds() < 10) {
			second = "0"+now.getSeconds();
		} else {
			second = ""+now.getSeconds();
		}
		
		strNow += hour + ":" + minute + ":" + second;
		
		$("#clock").html("<span style='color:green; font-weight:bold;'>"+strNow+"</span>");
     
	}
	
	function loopshowNowTime() {
		
		showNowTime();
		
		var timejugi = 1000;   // 시간을 1초 마다 자동 갱신하려고.
		
		setTimeout(function() {
						loopshowNowTime();	
					}, timejugi);
		
	}// end of loopshowNowTime() --------------------------
//////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	// 직업별 인원수 rank
	function getTableRank(){
		
		$.ajax({
			url: "rankShowJSON.action",
		    type: "GET",
		    dataType: "JSON",
		    success: function(json){
		    	
		    	$("#displayTable").empty();
		    	
		    	var html  = "<table class=table table-hover' align='center' width='250px' height='180px' >";  //table 태그에서 class에 적은 것은 부트스트랩을 참조한 것이다.
		    	    html += "<tr>";
		    	    html += "<th class='myaligncenter'>등수</th>";
		    	    html += "<th class='myaligncenter'>직업명</th>";
		    	    html += "<th class='myaligncenter'>인원수</th>";   // layout-tiles.jsp에 보면 css에 .myaligncenter 를 align='center'로 설정해둠.
		    	    html += "<th class='myaligncenter'>비율</th>";
		    	    html += "</tr>";
		    	    
		    	$.each(json, function(entryIndex, entry){
		    		html += "<tr>";
		    	    html += "<td class='myaligncenter myrank'>"+entry.RANK+"</td>";
		    	    html += "<td class='myaligncenter'>"+entry.JOB+"</td>";
		    	    html += "<td class='myaligncenter'>"+entry.CNT+"</td>";
		    	    html += "<td class='myaligncenter'>"+entry.PERCENT+"</td>";
		    	    html += "</tr>";
		    	});   
		    	
		    	html += "</table>";
	    	    

		    	$("#displayTable").append(html);
		    },
			error: function(request, status, error){ //ajax 요청에 의해 실행했으나 데이터를 받아오는데 실패한 경우, 디버깅을 위해 error를 실행한다.
	             alert(" code: " + request.status + "\n"+"message: " + request.responseText + "\n"+"error: " + error);
	        }
		});
		
		
	}// end of getTableRank()
	
	
	function getChartRank(){
		
		$.ajax({
			url: "rankShowJSON.action",
		    type: "GET",
		    dataType: "JSON",
		    success: function(json){
		    	
		    	var jobObjArr = [];
		    	
		    	// 배열 속에 값넣기
		    	$.each(json,function(entryIndex, entry){
		    		
		    		// 실제 데이터 값 jobObjArr에 넣기
		    		jobObjArr.push({
		  		           "name": entry.JOB,
		  		           "y": parseFloat(entry.PERCENT),
		  		           "drilldown": entry.JOB
					});

		    	});// end of $.each(json,function(entryIndex, entry)
		    				
		    			
		    	// *** 객체 속의 배열
		    	var agelineObjArr = [];	
		    	
		    	// 배열 속의 객체 속의 배열에 값넣기
		    	$.each(json,function(entryIndex, entry){
		    		
		    		var form_data = {job : entry.JOB}; // form_data로 값을 보낸다.
		    		
		    		// 새로운 쿼리문으로 값을 구해야 하기 때문에 ajax를 또 한다. 
		    		$.ajax({
		    		    url: "jobAgelineRankShowJSON.action",
		    		    data: form_data,
		    		    type: "get",
		    		    dataType: "JSON",
		    		    success: function(json2){
		                     
		    		    	var subArr = [];
		    		    	
		    		    	$.each(json2,function(entryIndex2, entry2){
		    		    		subArr.push([
		    		    		   	          entry2.AGELINE,
		    		    		   	          parseFloat(entry2.PERCENT)
		    		    		             ]);
		    		    	});// end of $.each(json2,function()
		    		    	
		    		    			
		    		    	agelineObjArr.push({
		    		    		"name": entry.JOB,
				  		        "id": entry.JOB,
				  		        "data": subArr          
		    		    	});  //{}는 객체		
		    		    			
		    		    },
		    			error: function(request, status, error){ //ajax 요청에 의해 실행했으나 데이터를 받아오는데 실패한 경우, 디버깅을 위해 error를 실행한다.
		   	             alert(" code: " + request.status + "\n"+"message: " + request.responseText + "\n"+"error: " + error);
		   	           }
		    		    
		    		
		    		});
		    	});	
		    			

		    			
		    			
                ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// Create the chart
		    	Highcharts.chart('chart-container', {
		  		  chart: {
		  		    type: 'column'
		  		  },
		  		  title: {
		  		    text: '직업별/연령별 인원수 통계'
		  		  },
		  		  subtitle: {
		  		    text: 'Click the columns to view versions. Source: <a href="http://statcounter.com" target="_blank">statcounter.com</a>'
		  		  },
		  		  xAxis: {
		  		    type: 'category'
		  		  },
		  		  yAxis: {
		  		    title: {
		  		      text: '인원수(명)'
		  		    }

		  		  },
		  		  legend: {
		  		    enabled: false
		  		  },
		  		  plotOptions: {
		  		    series: {
		  		      borderWidth: 0,
		  		      dataLabels: {
		  		        enabled: true,
		  		        format: '{point.y:.1f}%'
		  		      }
		  		    }
		  		  },

		  		  tooltip: {
		  		    headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
		  		    pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> of total<br/>'
		  		  },

		  		  "series": [ //배열
		  		    {
		  		      "name": "직업",
		  		      "colorByPoint": true,
		  		      "data": jobObjArr // *** 위에서 구한 값을 대입시킴 ***//
		  		    }
		  		  ] ,
		  		  "drilldown": {
		  			"series": agelineObjArr   // *** 위에서 구한 값을 대입시킴 ***//
		  		  }
		  		});
                
               //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		    },
			error: function(request, status, error){ //ajax 요청에 의해 실행했으나 데이터를 받아오는데 실패한 경우, 디버깅을 위해 error를 실행한다.
	             alert(" code: " + request.status + "\n"+"message: " + request.responseText + "\n"+"error: " + error);
	        }    
		});

		
		
		
		
	} // end of getCharRank()
	

	

          function callAjax(){        
            $.ajax({
             
               url: "adminChartJSON_job.action",
               type: "GET",
               dataType: "JSON",
               success: function(json){ // 배열타입 jsonArray는 [{},{},{},..,{}] 이런식으로 나올 것이다.
                //  $("#chart").empty();
                //  $("#tbl").empty();
                  
                  console.log("성공");
                  var resultArr = [];
                  
                  for(var i=0; i<json.length; i++){
                     var obj = {name : json[i].job,    // 위의 json배열 결과물의 i번째 값의 job 키값
                              y : Number(json[i].percent) }; // 배열 json i번째 값의 점유율  
                                                      // json에서는 name과 y에 들어가는 값은 전부 String이지만 실질적으로 y의 값은 숫자이기 때문에 
                                                      // 꼭 Number(json[i].percent)로 해줘야 한다.
                                                      // 객체는 키값이랑 같이 들어온다. A : A'
                       resultArr.push(obj)   // 배열 속에 값 넣기     
                                             // resultArr을 밑에 차트 data에 넣어주면 된다.
                  } 
                  
                  ////////////////////////////////
                   Highcharts.chart('chart1', {
                      chart: {
                        plotBackgroundColor: null,
                        plotBorderWidth: null,
                        plotShadow: false,
                        type: 'pie'
                      },
                      title: {
                        text: '직업별 인원수'
                      },
                      tooltip: {
                        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                      },
                      plotOptions: {
                        pie: {
                          allowPointSelect: true,
                          cursor: 'pointer',
                          dataLabels: {
                            enabled: true,
                            format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                            style: {
                              color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                            }
                          }
                        }
                      },
                      series: [{
                        name: '구성비율',
                        colorByPoint: true,
                        data: resultArr
                      }]
                    });
                  
                  
                /*   var html = "<table id='tblGender'>"
                           + "<thead>"
                           + "<tr>"
                           + "<th>직업</th>"
                           + "<th>인원수</th>"
                           + "<th>비율(%)</th>"
                           + "</tr>"
                           + "</thead>"
                          + "<tbody>";
                          
                          
                  $.each(json, function(entryIndex, entry){
                     html += "<tr>";
                     html += "<td>"+entry.job+"</td>";
                     html += "<td>"+entry.cnt+"</td>";
                     html += "<td>"+entry.percent+"</td>";
                     html += "</tr>";
                  });
                  
                    html += "</tbody>";
                    html += "</table>";
                    
                    $("#tbl").html(html); */
                  
               },
               error: function(request, status, error){ //ajax 요청에 의해 실행했으나 데이터를 받아오는데 실패한 경우, 디버깅을 위해 error를 실행한다.
                      alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
                  }
            
               
            });
          }   


      function callAjax2(){             
            $.ajax({
                
               url: "adminChartJSON_ageline.action",
               type: "GET",
               dataType: "JSON",
               success: function(json){
                  
                //  $("#chart").empty();
                //  $("#tbl").empty();
                  
                      var resultArr = [];
                  
                  for(var i=0; i<json.length; i++){
                     var subArr = [ json[i].ageline, Number(json[i].cnt)];
                     resultArr.push(subArr);
                  } 
                 
                  
                //////////////////////////////////////////////////////////////////////////////////////////  
                 
                  Highcharts.chart('chart2', {
                      chart: {
                          type: 'column'
                      },
                      title: {
                          text: '연령대별 인원수'
                      },
                      subtitle: {
                          text: 'Source: <a href="http://www.google.com">Google</a>'
                      },
                      xAxis: {
                          type: 'category',
                          labels: {
                              rotation: -45,
                              style: {
                                  fontSize: '13px',
                                  fontFamily: 'Verdana, sans-serif'
                              }
                          }
                      },
                      yAxis: {
                          min: 0,
                          title: {
                              text: '인원수 (명)'
                          }
                      },
                      legend: {
                          enabled: false
                      },
                      tooltip: {
                          pointFormat: '연령대별 인원수 : <b>{point.y:.1f} 명</b>'
                      },
                      series: [{
                          name: 'Population',
                          data: resultArr,
                          dataLabels: {
                              enabled: true,
                              rotation: -90,
                              color: '#FFFFFF',
                              align: 'right',
                              format: '{point.y:.0f}', // one decimal  // 1을 0으로 바꿔 소수부를 없앴따.
                              y: 10, // 10 pixels down from the top
                              style: {
                                  fontSize: '13px',
                                  fontFamily: 'Verdana, sans-serif'
                              }
                          }
                      }]
                  });
                  
                
               },
               error: function(request, status, error){ //ajax 요청에 의해 실행했으나 데이터를 받아오는데 실패한 경우, 디버깅을 위해 error를 실행한다.
                      alert(" code: " + request.status + "\n message: " + request.responseText + "\n error: " + error);
                 }
              
            });
         }
      
      
  	function showRank(){

		getTableRank();
		getChartRank();
		callAjax();
	    callAjax2();
     /*    var timejugi = 10000;   // 시간을 1초 마다 자동 갱신하려고.
		
		setTimeout(function() {
			           showRank();	
					}, timejugi); */
	} // end of showRank()
   
</script>


<div class="super_container"> 
   <div class="cart_container" style="padding-top: 20px;">
      <div class="container" >
         <div class="row" >
            <div class="col" >
                    
                <div class="row" >
                 <div class="col">  
					<div style="padding-left: 30px;">   
						<h2>회원 통계 자료</h2>
						    <br/><br/>
						         
						         <br/>
						         <br/>
						         <!-- 이중차트 Rank -->
						         <div class="row">
							          <div class="col">
						 		         <div id="displayTable" style="min-width: 90%; margin-top: 50px; margin-bottom: 50px; padding-left: 20px; padding-right: 20px;"></div> 		
		                                 <div id="chart-container" style="min-width: 90%; height: 400px; margin: 0 auto"></div>	
						                </div>
						         </div>   
						         <br/>
						         <br/>
						         <!-- 직업별 인원수 -->
						         <div class="row">
						            <div class="col">
						               <div class="mychart" id="chart1" style="margin-bottom: 20px;"></div>
						               <div id="tbl" style="margin:0 auto; width: 20%; border: 0px solid red;"></div>
						            </div>
						         </div>
						         <br/>
						         <br/>
						         <!-- 연령별 인원수 -->
						          <div class="row">
							          <div class="col">
							            <div class="mychart" id="chart2" style="margin-bottom: 20px;"></div>
							          </div>
						         </div>          
                      </div>
                 </div>
            </div>
            
        </div>
      </div>
    </div>
  </div>
</div> 
   


<div style="margin: 0 auto;" align="center">
	현재시각 :&nbsp; 
	<div id="clock" style="display:inline;"></div>
</div>
	

	

