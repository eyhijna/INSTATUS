package com.spring.finalins.common;

import java.text.DecimalFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;


public class MyUtil {
	
	// 되돌아갈 URL 페이지의 값을 알기 위해 현재 URL 주소를 얻어오는 메소드
	public static String getCurrentURL(HttpServletRequest request) {
		
		// 회원 삭제 후 돌아갈 url페이지의 값을 알기 위해 현재 url주소를 가져온다. 
		String currentURL = request.getRequestURL().toString(); 
		//http://localhost:9090/MyWeb/member/memberList.jsp
		
		String queryString = request.getQueryString(); 
		// 초기화면에서는 queryString는 null, 페이지를 이동하면 해당 페이지가 추출된다. currentShowPageNo=7&sizePerPage=10 
		//http://localhost:9090/MyWeb/member/memberList.jsp? 에서 ? 다음에 올 주소이다.
		
		currentURL += "?" + queryString; 
		// http://localhost:9090/MyWeb/member/memberList.jsp?currentShowPageNo=7&sizePerPage=10  전체주소를 불러온다.
				
		// request.getContextPath();  => /Myweb
		// currentURL.indexOf(request.getContextPath());  => /Myweb이 시작되는 인덱스번호를 알려준다. (21)
		// currentURL.indexOf(request.getContextPath()) +  request.getContextPath().length();  => 21+6=27 => /member에서 /의 인덱스위치
		
		
		// 돌아갈 페이지를 알기 위해 member/~ 부분을 추출해온다
		int beginIndex = currentURL.indexOf(request.getContextPath()) +  request.getContextPath().length();
		currentURL = currentURL.substring(beginIndex+1); // => member 부터 마지막까지 추출한다.
		// currentURL 결과값: member/memberList.jsp?currentShowPageNo=9&sizePerPage=10
		
		
		return currentURL;
	} // end of getCurrentURL(HttpServletRequest request)
	
	
	// 페이징처리에서 pageBar 만들기
	public static String getPageBar(String url, int currentPage, int sizePerPage, int totalPage, int blocksize) {
		String pageBar = "";
		
		int pageNo = 1; 	//pageNo => 실제 화면에 보여지는 페이지번호 이다.
		int loop = 1; 		//총 페이지를 블럭단위로 구분하기 위한 변수
		pageNo = ((currentPage-1)/blocksize)*blocksize+1; //블럭단위로 페이지번호를 보여주는 공식(1-10 / 11-20 / 21-30)
		// 7.[이전] [다음] 링크 만들기
		if(pageNo == 1) { //pageNo가 1일때는 이전 링크를 넣지 않고
			pageBar += "";
		}
		else {
			pageBar += "<a href='" + url + "?currentPage=" + (pageNo-1) + "&sizePerPage=" + sizePerPage + "'>이전</a>&nbsp;&nbsp;";
		}
		
		// 1페이지부터 totalPage까지 페이지넘버를 표현하기 위해 while문 사용
		// 페이지마다 링크를 걸어준다
	   while(loop <= blocksize && pageNo <= totalPage) { 
			if(pageNo == currentPage) { //페이지 번호가 현재페이지라면 링크를 걸지 않는다
				pageBar += "&nbsp;<span style='color:red; font-weight:bold; text-decoration:underline;'>" + pageNo + "</span>";
			}
			else { //현재페이지가 아닌 다른 페이지들은 이동을 위한 링크를 걸어둔다.
				if(pageNo==1) {
					pageBar = "<a href='" + url + "?currentPage=" + pageNo + "&sizePerPage=" + sizePerPage +"'>" + pageNo + "</a>";
				}
				else {
					pageBar += "&nbsp;&nbsp;<a href='" + url + "?currentPage=" + pageNo + "&sizePerPage=" + sizePerPage +"'>" + pageNo+ "</a>";
				}
			}
			pageNo++;
			loop++;
		} // end of while
		
		if(pageNo > totalPage) { //while문을 빠져나온 조건이 pageNo > totalPage 라면
			pageBar += "";
		}
		else {
			pageBar += "&nbsp;&nbsp;<a href='" + url + "?currentPage=" + pageNo + "&sizePerPage=" + sizePerPage + "'>다음</a>";
		}
		
		// while문을 수행하고 나온 pageBar에 다음 블럭으로 넘어가는 다음 링크를 만든다.
		return pageBar;
	} // end of getPageBar(String url, int currentPage, int sizePerPage, int totalPage, int blocksize)
	
	
	// ===== *** 검색어가 포함된 페이지바 만들기 *** ======= //
		public static String getSearchPageBar(String url
				                            , int currentShowPageNo
				                            , int sizePerPage
				                            , int totalPage
				                            , int blockSize
				                            , String colname, String search, String period) {
			
			String pageBar = "";
		    
			int pageNo = 1;
			int loop = 1;
			
			pageNo = ((currentShowPageNo - 1) / blockSize) * blockSize + 1;
			// 공식임.
			
			//     currentShowPageNo      pageNo
			//    -------------------------------
			//           1                  1
			//           2                  1
			//          ..                 ..
			//          10                  1
			//          
			//          11                 11
			//          12                 11
			//          ..                 ..
			//          20                 11
			//          
			//          21                 21                 
			//          22                 21 
			//          ..                 ..
			//          30                 21 
			
			if(pageNo == 1) {
				pageBar += "";
			}
			else {
				pageBar += "&nbsp;<a class='previous round' href=\""+url+"?currentShowPageNo="+(pageNo-1)+"&sizePerPage="+sizePerPage+"&colname="+colname+"&search="+search+"&period="+period+"\"><span style=' font-weight: bold;'> << </span></a>";
			}
			
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if(pageNo == currentShowPageNo) {
					pageBar += "&nbsp;<span style=\"color: #fed189; font-size: 13pt; font-weight: bold; text-decoration: underline;\">"+pageNo+"</span>&nbsp;"+"/ 총 "+totalPage+"페이지 &nbsp;";
				}
				else {
					pageBar += "&nbsp;<a href=\""+url+"?currentShowPageNo="+pageNo+"&sizePerPage="+sizePerPage+"&colname="+colname+"&search="+search+"&period="+period+"\">"+pageNo+"</a>&nbsp;";
				}
				
				pageNo++;
				loop++;
			}// end of while-------------------------
			
			if(pageNo > totalPage) {
				pageBar += "";
			}
			else {
				pageBar += "&nbsp;<a class='next round' href=\""+url+"?currentShowPageNo="+pageNo+"&sizePerPage="+sizePerPage+"&colname="+colname+"&search="+search+"&period="+period+"\"><span style=' font-weight: bold;'> >> </span></a>";
			}

			return pageBar;
			
		}// end of getPageBar(String url, int currentShowPageNo, int sizePerPage, int totalPage, int blockSize)-------------------	
		
	
	
	
/*	
	public static String getSearchPageBar(String url, int currentPage, int sizePerPage, int totalPage, int blockSize
					, String searchtype, String searchword, String period) {

		String pageBar = "";
		
		int pageNo = 1;
		int loop = 1;
		
		pageNo = ((currentPage - 1) / blockSize) * blockSize + 1;
		// 공식임.
		
		//     currentShowPageNo      pageNo
		//    -------------------------------
		//           1                  1
		//           2                  1
		//          ..                 ..
		//          10                  1
		//          
		//          11                 11
		//          12                 11
		//          ..                 ..
		//          20                 11
		//          
		//          21                 21                 
		//          22                 21 
		//          ..                 ..
		//          30                 21 
		
		if(pageNo == 1) {
		pageBar += "";
		}
		else {
		pageBar += "&nbsp;<a class='previous' href=\""+url+"?currentShowPageNo="+(pageNo-1)+"&sizePerPage="+sizePerPage+"&colname="+searchtype+"&search="+searchword+"&period="+period+"\" >previous</a>";
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
		
		if(pageNo == currentPage) {
		pageBar += "&nbsp;<span style=\"color: red; font-size: 13pt; font-weight: bold; text-decoration: underline;\">"+pageNo+"</span>&nbsp;";
		}
		else {
		pageBar += "&nbsp;<a href=\""+url+"?currentShowPageNo="+pageNo+"&sizePerPage="+sizePerPage+"&colname="+searchtype+"&search="+searchword+"&period="+period+"\">"+pageNo+"</a>&nbsp;";
		}
		
		pageNo++;
		loop++;
		}// end of while-------------------------
		
		if(pageNo > totalPage) {
		pageBar += "";
		}
		else {
		pageBar += "&nbsp;<a class='next' href=\""+url+"?currentShowPageNo="+pageNo+"&sizePerPage="+sizePerPage+"&colname="+searchtype+"&search="+searchword+"&period="+period+"\">next</a>";
		}
		
		return pageBar;
		
	}// end of getPageBar(String url, int currentShowPageNo, int sizePerPage, int totalPage, int blockSize)-------------------	
*/	
	
	// 숫자를 입력받아 세자리마다 콤마를 찍어 리턴시켜주는 메소드
	public static String getComma(long number) {
		DecimalFormat df = new DecimalFormat("#,###"); //숫자형의 데이터에 세자리마다 콤마를 찍어주는 객체DecimalFormat을 생성
		
		String result = df.format(number);
		
		return result;
	} // getComma(long number)

	// ****  현재시각을 나타내기  **** //
	public static String getNowTime() {
		Date now = new Date();
		String today = String.format("%tF %tT", now, now);
        return today;
	}


}
