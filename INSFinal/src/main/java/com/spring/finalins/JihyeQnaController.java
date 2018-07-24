 package com.spring.finalins;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.finalins.common.FileManager;
import com.spring.finalins.common.MyUtil;
import com.spring.finalins.model.MemberVO;
import com.spring.finalins.model.PhotoVO;
import com.spring.finalins.qna.model.QnaVO;
import com.spring.finalins.qna.service.InterQnaService;

//====== #32. 컨트롤러 선언 ======
@Controller
@Component // 해당클래스를 bean으로 만들어 줌
public class JihyeQnaController {
	
	// ====== . 의존객체 주입하기(DI: Dependency Injection) ========
	@Autowired
	private InterQnaService service;
	
		
    // ====== 파일업로드 및 다운로드를 해주는 FileManager 클래스 의존객체 주입하기(DI: Dependency Injection) ========
    /*
     * 이전에 파일 업로드는 cos.jar를 사용하였지만 이제부터 FileManager.java를 사용할 것이다. smart editor에서
     * 사용할 것이다.
     */
    @Autowired
    private FileManager fileManager;	


	// 회원 - qna 목록 보여주기
	@RequestMapping(value="/qna.action", method= {RequestMethod.GET})
	public String requireLogin_qna(HttpServletRequest req, HttpServletResponse res) {

		// 1. Qna 페이지를 보면 qna리스트를 보여주고 없으면 글쓰기 버튼 클릭해서 스마트 에디트를 보여준다.
		HttpSession session = req.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		String userid = loginuser.getUserid(); 
		List<HashMap<String,String>> qnaList = null;
		
		
		// ==== #106. 검색어가 포함되었으므로
		// 먼저 위의 boardList = service.boardList(); 부분을
		// 주석처리하고서 아래의 작업을 한다. ====
	   String colname = req.getParameter("colname"); 												
	   HashMap<String, String> map2 = new HashMap<String, String>();
	   map2.put("colname", colname);
	   map2.put("userid", userid);
	

		HashMap<String, String> map = new HashMap<String, String>();
		map.put("userid", userid);


				// ===== #110. 페이징 처리 하기 =====
				String str_currentShowPageNo = req.getParameter("currentShowPageNo");

				int totalCount = 0; // 총 게시물 건 수 알기
				int sizePerPage = 5; // 한 페이지당 보여줄 게시물 건수
				int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기값은 1페이지로 설정함.
				int totalPage = 0; // 총페이지수(웹브라우저상에 보여줄 총 페이지 갯수)

				int startRno = 0;// 시작행 번호
				int endRno = 0;// 끝행 번호

				int blockSize = 1;// "페이지바" 에 보여줄 페이지의 갯수

				/*
				 * ==== 총 페이지 수 구하기 ==== 검색 조건이 없을 때의 총 페이지 수와 검색 조건이 있을 때의 총 페이지 수를 구해야 한다.
				 * 
				 * 검색 조건이 없을 때의 총 페이지 수 ==> colname과 search가 null 인 것이고, 검색 조건이 있을 때의 총 페이지 수
				 *                         ==> colname과 search가 null 이 아닌 것이다.
				 */
				// 먼저 총 게시물 건수를 구한다.
				// 먼저 총 게시물 건수를 구한다.
				if ((colname != null ) && (!colname.equals("null"))
						&& (!colname.trim().isEmpty() )) // colname을 선택했고 검색어를 입력했을 경우
				{
					totalCount = service.getTotalCount2(map2); // 검색어가 있는 총 게시물 건수 // map에 colname과 search과 포함되어 있다.

				} else {
					totalCount = service.getTotalCount(map); // 검색어가 없는 총 게시물 건수
				}
		
								
				System.out.println("총 게시물 수"+totalCount);

				// 구해온 totalCount로 totalPage를 만든다.
				// 정수 / 정수 (정수 나누기 정수는 실수) ==> 형번환 해준다.
				totalPage = (int)Math.ceil((double)totalCount / sizePerPage);
				
				System.out.println("총 페이지 수"+totalPage);


				// 맨 처음에 목록보기를 눌렀을 때
				// 뷰단에서 자바로 넘어올 때 get방식이라서 장난치는 것을 다 막아줘야 한다. get방식의 주소창은 다 드러나기 때문에 유효성 검사
				if (str_currentShowPageNo == null) {
					// 게시판 초기 화면에 보여지는 것은
					// req.getParameter("currentShowPageNo"); 값이 없으므로
					// str_currentShowPageNo 은 null 이 된다.

					currentShowPageNo = 1;
				} else { // null이 아니라면 int로 바꿔주는데 존재하지 않는 음수 페이지거나 토탈페이지보다 더 많으면 currentShowPageNo = 1; 로
							// 설정하겠다.
					try { // 숫자만 Integer로 바꿀 수 있고 똘똘이와 같은 건 안되기 때문에 numberformat exception이 발생
						currentShowPageNo = Integer.parseInt(str_currentShowPageNo);

						if (currentShowPageNo < 1 || currentShowPageNo > totalPage) { // ==> 존재하지 않는 페이지가 있다면
							currentShowPageNo = 1;
						}

					} catch (NumberFormatException e) {
						currentShowPageNo = 1;
					}
				}

				// **** 가져올 게시글의 범위를 구한다.(공식임!!) ****
				/*
				 * // 1페이지당 5개씩 보여준다고 가정한다면 currentShowPageNo startRno endRno
				 * ------------------------------------------------ 1 page ==> 1 5 2 page ==> 6
				 * 10 3 page ==> 11 15 4 page ==> 16 20 5 page ==> 21 25 6 page ==> 26 30 7 page
				 * ==> 31 35
				 */

				// ****** 공식!공식!공식! *******
				startRno = (currentShowPageNo - 1) * sizePerPage + 1;
				endRno = startRno + sizePerPage - 1;

				// totalCount 는 검색어의 유무에 따라 게시물의 총 갯수가 달라진다
				// ===== #111. 페이징 처리를 위한 startRno, endRno 를 map에 추가하여
				// 파라미터로 넘겨서 select 되도록 한다.
				// --> totalCount 구하기(DB에서 데이터 갯수 알아오기)

				// 처음에 검색도 안했을때 현재 페이지는 1이고 페이지에서 시작값은 1이고 마지막 값은 5이다. 그것을 map에 넣어준다.

				map.put("startRno", String.valueOf(startRno));
				map.put("endRno", String.valueOf(endRno));
				
				map.put("userid", userid);
				
				
				map2.put("startRno", String.valueOf(startRno));
				map2.put("endRno", String.valueOf(endRno));
				
				if ((colname != null ) && (!colname.equals("null"))
						&& (!colname.trim().isEmpty() )) // colname을 선택했고 검색어를 입력했을 경우
				{
					qnaList = service.qnaList(map2);

				} else {
					qnaList = service.qnaList(map);
				}
				
				
				

				// =====  페이지바 만들기(먼저, 페이지바에 나타낼 총 페이지 갯수(totalPage) 구해야 한다.) =====
				String pagebar = "<ul>";
				
				
				if ((colname != null ) && (!colname.equals("null"))
						&& (!colname.trim().isEmpty() )) // colname을 선택했고 검색어를 입력했을 경우
				{
					pagebar += MyUtil.getSearchPageBar("qna.action", currentShowPageNo, sizePerPage, totalPage, blockSize,
							map2.get("colname"), map2.get("search"), null); // period는 없으니까 null 을 넣어준다.
					pagebar += "</ul>";

				} else {
					pagebar += MyUtil.getSearchPageBar("qna.action", currentShowPageNo, sizePerPage, totalPage, blockSize,
							map.get("colname"), map.get("search"), null); // period는 없으니까 null 을 넣어준다.
					pagebar += "</ul>";
				}
				
				
				
				
				
				
				

				req.setAttribute("pagebar", pagebar);

				req.setAttribute("qnaList", qnaList);
		
		
		return "jihye/qna.tiles";
	}
	
	
	
	 // ======= #61. 글 1개를 보여주는 페이지 요청하기 =====
    @RequestMapping(value = "/view.action", method = { RequestMethod.POST})
    public String requireLogin_view(HttpServletRequest req,  HttpServletResponse res) {

        HttpSession session = req.getSession();
 		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
 		String userid = loginuser.getUserid();

 		System.out.println("로그인한 유저"+userid);
 		
 	    String qna_idx = req.getParameter("qna_idx"); // 글번호 받아오기
 	 	    QnaVO qnavo = service.getView(qna_idx);
 	
 	    req.setAttribute("qnavo", qnavo);  
 	   

 	     return "jihye/view.tiles"; 
        
    }

	
		
	  // ============== 글쓰기 페이지 요청하기
      @RequestMapping(value="/goWrite.action", method={RequestMethod.POST})
      public String requireLogin_writeQna(HttpServletRequest req, HttpServletResponse res) {
         
         // 처음에 글쓰기(원글)은 아래 qna_fk_idx/qna_groupno/qna_depthno 값이 없다.
         // 원글일 경우 뷰단에서 값을 넘기는 것은 DB에 insert가 아니기 때문에 null이다.
         // 그러나 답변 글쓰기 경우 위의 세가지 값을 뷰단에서 받아서 컨트롤러로 넘긴다.

    	  String qnavo = req.getParameter("qnavo");
    	      	  
         // ===== #121. 답변글쓰기 추가 되었으므로 아래와 같이 한다(시작). =======
         String qna_fk_idx = req.getParameter("qna_fk_idx");
         String qna_groupno = req.getParameter("qna_groupno");
         String qna_depthno = req.getParameter("qna_depthno");
         String replyChk = req.getParameter("replyChk");
         
     //    System.out.println("qna_fk_idx"+qna_fk_idx);
    //     System.out.println("qna_groupno"+qna_groupno);
     //    System.out.println("qna_depthno"+qna_depthno);
         

         req.setAttribute("qna_fk_idx", qna_fk_idx);
         req.setAttribute("qna_groupno", qna_groupno);
         req.setAttribute("qna_depthno", qna_depthno);
         req.setAttribute("replyChk", replyChk);

         // ==== 답변글쓰기 추가 되었으므로 아래와 같이 한다(끝).
         
         return "jihye/qnaWrite.tiles";         
      }

		
      // =======  글쓰기 완료 요청 =======
      @RequestMapping(value = "/writeEnd.action", method = { RequestMethod.POST })
      public String writeEnd(QnaVO qnavo,MultipartHttpServletRequest req,  HttpSession session, HttpServletResponse res) throws Throwable{
	  //requireLogin_
    	  
    	   String qna_fk_idx = req.getParameter("qna_fk_idx");
           String qna_groupno = req.getParameter("qna_groupno");
           String qna_depthno = req.getParameter("qna_depthno");
           String replyChk = req.getParameter("replyChk");
           
           System.out.println("qna_fk_idx"+qna_fk_idx); // 원글의 qna_idx
           System.out.println("qna_groupno"+qna_groupno); // 원글의 qna_groupno
           System.out.println("글쓸 때 qna_depthno"+qna_depthno); //0
           System.out.println("답글용체크"+replyChk);
 	  
          MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
          String userid = null;
          if (loginuser != null) {
             userid = loginuser.getUserid();   
                qnavo.setFk_userid(userid);
          }
    	  
    	  if (loginuser != null) {
    			if (!qnavo.getFk_userid().equals(loginuser.getUserid())) {

    				String msg = "다른 사용자의 글은 수정이 불가합니다.";
    				String loc = "qna.action";

    				req.setAttribute("msg", msg);
    				req.setAttribute("loc", loc);

    				return "msg.notiles";
    			
    			} else { // 자신의 글을 수정함
    						// 가져온 1개의 글을 request 영역에 저장시켜서 view 단 페이지로 넘긴다.
    				 // HttpServletRequest는 파일첨부를 하지 못한다. 그래서 HttpServletRequest 를 지우고
    		         // MultipartHttpServletRequest를 한다.

    		         // =======  사용자가 쓴 글에 파일이 첨부가 된 것인지 아니면 파일첨부가 안 된 것인지 구분지어야 한다.
    		         // ************* 첨부파일이 있으면 파일업로드 하기 시작 ******************************
    		         if (!qnavo.getAttach().isEmpty()) {
    		            // attach 가 비어있지 않다면 (즉, 청부파일이 있는 경우라면 )

    		            /*
    		             * 1. 사용자가 보낸 파일을 WAS(톰캣)의 특정 경로 폴더에 저장해 줘야 한다. >>>> 파일이 업로드 되어질 특정 경로(폴더)지정해주기
    		             * 우리는 WAS(톰캣)의 webapp/resources/files 라는 폴더로 지정해주겠다. // files 명은 바꿔도 된다.
    		             */

    		            // WAS(톰캣)의 webapp 의 절대경로를 알아와야 한다.
    		            String root = session.getServletContext().getRealPath("/"); // /는 첫번째 경로를 말한다. 확장자.java //
    		                                                         // session.getServletContext().getRealPath("/");
    		                                                         // == 절대경로
    		            String path = root + "resources" + File.separator + "files";
    		            // File.separator ==> 운영체제가 Windows 라면 "\" 이고,
    		            // ==> 운영체제가 UNIX, Linux 이라면 "/" 이다.

    		            System.out.println("root >>" + root);
    		            // C:\INSFinal\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\INSFinal\
    		            System.out.println("path>>" + path);
    		            // C:\INSFinal\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\INSFinal\resources\files

    		            /*
    		             * 2. 파일첨부를 위한 변수의 설정 및 값을 초기화한 후 파일 올리기
    		             */
    		            
    		            String newFileName = "";
    		            // WAS(톰캣) 디스크에 저장할 파일명.

    		            byte[] bytes = null;
    		            // 첨부파일을 WAS(톰캣) 디스크에 저장할 때 사용되는 용도. 실제파일이다.

    		            long qna_byte =0;
    		            //long fileSize = 0;
    		            // 파일크기를 읽어오기 위한 용도.

    		            // FileManager에 있는 doFileUpload 가 throws Exception을 하였기 때문에 try-catch
    		            try {
    		               bytes = qnavo.getAttach().getBytes(); // 실제 파일의 내용물들을 읽어온 것. 리턴타입은 byte[]
    		               // getBytes() 는 첨부된 파일을 바이트 단위로 파일을 다 읽어오는 것이다.
    		               
    		               System.out.println("확인용>>>>>>>>>>>>>>>"+bytes);

    		               newFileName = fileManager.doFileUpload(bytes, qnavo.getAttach().getOriginalFilename(), path);
    		               // getOriginalFilename() 은 우리가 만든 것이 아니라 MultipartFile에서 제공해주는 것이다.
    		               // 파일을 업로드 한 후 현재시간 + 나노타임. 확장자로 되어진 파일명을
    		               // 리턴받아 newFileName 으로 저장한다.
    		               // qnavo.getAttach().getOriginalFilename() 은 첨부된 파일의 실제 파일명(문자열)을 얻어 오는 것이다.

    		               System.out.println("qna_filename: " + newFileName);

    		               qnavo.setQna_filename(newFileName);
    		               // newFileName이 WAS(톰캣)에 저장될 파일명(

    		               
    		             
    		               
    		               qnavo.setQna_orgfilename(qnavo.getAttach().getOriginalFilename());
    		               // qnavo.getAttach().getOriginalFilename() 은 진짜 파일명(강아지.png);
    		               // 사용자가 파일을 다운로드할 때 사용되어지는 파일명

    		          
    		               
    		               qna_byte = qnavo.getAttach().getSize();
    		               //filesieze
    		               // qnavo.getAttach().getSize() 은 첨부한 파일의 크기를 말한다.

    		               qnavo.setQna_byte(String.valueOf(qna_byte));

    		            } catch (Exception e) {

    		            }

    		         }
    		         // ************* 첨부파일이 있으면 파일업로드 하기 끝 ******************************

    		         // VO를 사용하면 편함
    		         String qna_content = qnavo.getQna_content().replaceAll("\r\n", "<br/>");
    		         qnavo.setQna_content(qna_content);
    		         
    		         qnavo.setQna_depthno(qna_depthno); // qna_depthno
    		         qnavo.setQna_fk_idx(qna_fk_idx);  // qnaWrite.jsp에서 원글의 qna_idx를 넣어준 값이다.
    		         qnavo.setQna_groupno(qna_groupno);
    		         
    		   //      System.out.println("qnavo 그룹넘버"+qnavo.getQna_groupno());
    		         

    		         int n = 0;

    		         if (qnavo.getAttach().isEmpty()) {
    		            // 파일첨부가 없다면
    		            n = service.write(qnavo); // insert니까 리턴타입은 int
    		
    		         }      
    		         if (!qnavo.getAttach().isEmpty()) {
    		            // 파일첨부가 있다면
    		           n = service.write_withFile(qnavo); // insert니까 리턴타입은 int
    		         }

    		        // 글을 성공적으로 쓰고 난 후 qna_groupno 갯수를 구한다.// 원글일 경우 입력 전의 qna_idx를 넣기 때문에 null이 될 것이고 
    		         // 답글일 경우 qna_idx가 생성됐기 때문에 null이 아닌가?
    		         int m = 0;
    		         if(n==1 && !replyChk.equals("")) { // groupno 갯수를 구한다.   		        	 
    		       	 
    		        	// String qna_idx = qnavo.getQna_idx();
    		       
    		        	 m = service.updateQnaDepthno(qnavo);
    		         }	 

    		         req.setAttribute("n", n);

    		         return "writeEnd.notiles";

    			}

    		} else {
    			
    			session.invalidate();
    			
    			String msg = "QnA에 문의하려면 로그인을 해주세요";
    			String loc = "index.action";

    			req.setAttribute("msg", msg);
    			req.setAttribute("loc", loc);

    			return "msg.notiles";
    		}
        
      }

      
      
  	// ====== #70. 글수정 페이지 요청 =====
  	@RequestMapping(value = "/editQna.action", method = { RequestMethod.GET})
  	public String requiredLogin_editQna(HttpServletRequest req, HttpServletResponse res) { // LoginCheck.java에서 로그인 유무 검사할
  																						// 때 파라미터가 2개라서 지금 이 메소드에도 파라미터
  																						// 2개 넣은 것임.

  		String qna_idx = req.getParameter("qna_idx");// 수정해야할 글번호 가져오기

  		// 수정해야할 글 전체 내용가져오기
  		// 조회수 1증가 없이 그냥 글을 가져오는 것
  		QnaVO qnavo = service.getView(qna_idx);

  		HttpSession session = req.getSession();
  		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");

  			if (!qnavo.getFk_userid().equals(loginuser.getUserid())) {

  				String msg = "다른 사용자의 글은 수정이 불가합니다.";
  				String loc = "javascript:history.back();";

  				req.setAttribute("msg", msg);
  				req.setAttribute("loc", loc);

  				return "msg.notiles";
  			
  			} else { // 자신의 글을 수정함
  						// 가져온 1개의 글을 request 영역에 저장시켜서 view 단 페이지로 넘긴다.
  				req.setAttribute("qnavo", qnavo);

  				return "jihye/editQna.tiles";
  				// /Board/src/main/webapp/WEB-INF/views2/board/edit.jsp 파일을 생성한다.
  			}



  	}

  	// ====== #71. 글수정 페이지 완료하기=====
  	@RequestMapping(value = "/editQnaEnd.action", method = { RequestMethod.POST })
  	public String editQnaEnd(QnaVO qnavo, HttpServletRequest req,  HttpServletResponse res) {
        	
  		
  		HttpSession session = req.getSession();
  		 MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
   
   	    if (loginuser != null) {
   			
   				String qna_content = qnavo.getQna_content().replaceAll("\r\n", "<br/>");
   		  		qnavo.setQna_content(qna_content);
   		  		
   		  		String fk_qna_category_idx = req.getParameter("fk_qna_category_idx");
   		  		qnavo.setFk_qna_category_idx(Integer.parseInt(fk_qna_category_idx));
   		  		
   		  		String qna_orgfilename = req.getParameter("qna_orgfilename");
   		  		qnavo.setQna_orgfilename(qna_orgfilename);
   		  		
   		  		/*
   		  		 * 글 수정을 하려면 원본 글의 암호화 수정시 입력해주는 암호가 일치할 때만 글수정이 가능하도록 해야 한다.
   		  		 */
   		  		int n = service.editQna(qnavo);
   		  		// n 이 1이면 update 성공
   		  		// n 이 0이면 update 실패(암호가 틀리므로)
   		  	
   		  		
   		  		  req.setAttribute("n", n);
   		  		   req.setAttribute("qna_idx", qnavo.getQna_idx());
   		  	      return "jihye/editQnaEnd.tiles";
   	    }	
		 else {
			
			session.invalidate();
			
			String msg = "글을 수정하려면 로그인을 해주세요";
			String loc = "index.action";
	
			req.setAttribute("msg", msg);
			req.setAttribute("loc", loc);
	
			return "msg.notiles";
		 }
  		
  	}
  	
  	
 // ====== #77. 글삭제 페이지 요청 =====
 	@RequestMapping(value = "/del.action", method = { RequestMethod.POST})
 	public String requireLogin_del(HttpServletRequest req, HttpServletResponse res) { // LoginCheck.java 체크할때 파라미터가
 																						// 두개였었다.

 		// 삭제해야할 글번호 가져오기
 		String qna_idx = req.getParameter("qna_idx"); // view.jps페이지에서 boardvo seq 글번호

 		// 삭제할 글은 자신이 작성한 글이어야만 가능하다.
 		// 삭제할 글 내용을 읽어오면 작성자를 알 수 있다.
 		QnaVO qnavo = service.getView(qna_idx);

 		HttpSession session = req.getSession();
 		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");

 		if (loginuser != null) {

 			if (!loginuser.getUserid().equals(qnavo.getFk_userid())) {
 				String msg = "다른 사용자의 글은 삭제가 불가합니다.";
 				String loc = "javascript:history.back()";

 				req.setAttribute("msg", msg);
 				req.setAttribute("loc", loc);

 				return "msg.notiles";
 			} else { // 삭제해야할 글번호 유저아이디와 로그인한 유저아이디가 같을 경우 삭제할 수 있다.
 				
 				// 삭제해야할 글번호를 request 영역에 저장시켜서 view단 페이지로 옮긴다.
 				req.setAttribute("qna_idx", qna_idx);

 				// 글삭제시 글장석지 입력한 암호를 다시 입력 받아 암호의 일치여부를 알아보도록
 				// view단 페이지 del.jsp 로 넘긴다.

 				int n = service.del(qna_idx);
 		 		// 넘겨받은 값이 1(원게시글 및 댓글까지 삭제 성공)이면 글삭제 성공,
 		 		// 넘겨받은 값이 2(댓글이 없는 원게시글 삭제 성공)이면 글삭제 성공,
 		 		// 넘겨받은 값이 0이면 글삭제 실패(암호가 틀리므로)

 		 		req.setAttribute("n", n);

 		 		return "jihye/delEnd.tiles";
 			}
 		} else {
 			String msg = "글을 삭제하려면 로그인을 해주세요";
 			String loc = "javascript:history.back();";

 			req.setAttribute("msg", msg);
 			req.setAttribute("loc", loc);

 			return "msg.notiles";
 		}

 	}

	
   // ==== #148. 첨부파일 다운로드 받기 =====
  	@RequestMapping(value = "/download.action", method = { RequestMethod.GET})
  	public String requireLogin_download(HttpServletRequest req, HttpServletResponse res) {
      
  		HttpSession session = req.getSession();
  		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
  		
  		String userid = loginuser.getUserid();

  		String qna_idx = req.getParameter("qna_idx");  // get방식 주소창에 seq로 받았으니까 받는 것도seq이다!!
  		// 첨부파일이 있는 글번호

  		QnaVO qnavo = service.getView(qna_idx);

  		// 유효성 검사: 글쓴 유저가 아닌 사람은 다운로드가 불가능하다.
  		if(!userid.equalsIgnoreCase(qnavo.getFk_userid()) && !userid.equalsIgnoreCase("admin")) {
  			String msg = "다운로드가 불가합니다.";
			String loc = "javascript:history.back()";

			req.setAttribute("msg", msg);
			req.setAttribute("loc", loc);

			return "msg.notiles";
  		}
  		
  		
  		String qna_filename = qnavo.getQna_filename();
  		String qna_orgfilename = qnavo.getQna_orgfilename();

  		// WAS(톰캣)의 webapp 의 절대경로를 알아와야 한다.
        String root = session.getServletContext().getRealPath("/"); // /는 첫번째 경로를 말한다. 확장자.java //
  																	// session.getServletContext().getRealPath("/"); ==
  																	// 절대경로
  		String path = root + "resources" + File.separator + "files"; // path 는 업로드 되는 곳
  		// File.separator ==> 운영체제가 Windows 라면 "\" 이고,
  		// ==> 운영체제가 UNIX, Linux 이라면 "/" 이다.

  		boolean bool = false;

  		bool = fileManager.doFileDownload(qna_filename, qna_orgfilename, path, res);
  		// 다운로드가 성공이면 true를 반납하고,
  		// 다운로드가 실패면 false를 반납한다.

  		if (!bool) { // !bool == true 라는 뜻
  			// 다운로드가 실패할 경우 메시지를 띄어준다.
  			res.setContentType("text/html; charset=UTF-8");
  			PrintWriter writer = null; // PrintWriter는 웹상에서 쓰는 볼펜같은 역할이다.

  			try {
  				writer = res.getWriter();
  				// 웹브라우저상에 메시지를 쓰기 위한 객체생성.
  			} catch (IOException e) { // IO는 입출력을 뜻한다.
  				e.printStackTrace();
  			}

  			writer.println("<script type='text/javascript'>alert('파일 다운로드 실패!!')</script>");

  		}
  		
  		return null;
  		
	}
  		
  		

  	
  	
  
      
    // ************************************************************************************************************************************
  	// //
 	// ==== #스마트에디터1. 단일사진 파일업로드 ====
 	@RequestMapping(value = "/image/photoUpload.action", method = { RequestMethod.POST })
 	public String photoUpload(PhotoVO photovo, HttpServletRequest req) {

 		
 		String callback = photovo.getCallback();
 		String callback_func = photovo.getCallback_func();
 		String file_result = "";
 		
 		
 	
 		if (!photovo.getFiledata().isEmpty()) {
 			// 파일이 존재한다라면

 			/*
 			 * 1. 사용자가 보낸 파일을 WAS(톰캣)의 특정 폴더에 저장해주어야 한다. >>>> 파일이 업로드 되어질 특정 경로(폴더)지정해주기 우리는
 			 * WAS 의 webapp/resources/photo_upload 라는 폴더로 지정해준다.
 			 */

 			// WAS 의 webapp 의 절대경로를 알아와야 한다.
 			HttpSession session = req.getSession();
 			String root = session.getServletContext().getRealPath("/");
 			String path = root + "resources" + File.separator + "photo_upload";
 			// path 가 첨부파일들을 저장할 WAS(톰캣)의 폴더가 된다.

 			 System.out.println(">>>> 확인용 path ==> " + path);
 			// >>>> 확인용 path ==>
 			// C:\INSFinal\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\INSFinal\resources\photo_upload

 			// 2. 파일첨부를 위한 변수의 설정 및 값을 초기화한 후 파일올리기
 			String newFilename = "";
 			// WAS(톰캣) 디스크에 저장할 파일명

 			byte[] bytes = null;
 			// 첨부파일을 WAS(톰캣) 디스크에 저장할때 사용되는 용도

 			try {
 				bytes = photovo.getFiledata().getBytes();
 				
 				
 				System.out.println("네이버 용량"+bytes);
 				// getBytes()는 첨부된 파일을 바이트단위로 파일을 다 읽어오는 것이다.
 				/*
 				 * 2-1. 첨부된 파일을 읽어오는 것 첨부한 파일이 강아지.png 이라면 이파일을 WAS(톰캣) 디스크에 저장시키기 위해 byte[]
 				 * 타입으로 변경해서 받아들인다.
 				 */
 				// 2-2. 이제 파일올리기를 한다.
 				String original_name = photovo.getFiledata().getOriginalFilename();
 				// photovo.getFiledata().getOriginalFilename() 은 첨부된 파일의 실제 파일명(문자열)을 얻어오는 것이다.
 				newFilename = fileManager.doFileUpload(bytes, original_name, path);

 				// System.out.println(">>>> 확인용 newFileName ==> " + newFileName);

 				int width = fileManager.getImageWidth(path + File.separator + newFilename);
 				// System.out.println("확인용 >>>>>>>> width : " + width);

 				if (width > 600)
 					width = 600;
 				// System.out.println("확인용 >>>>>>>> width : " + width);

 				String CP = req.getContextPath(); // board
 				file_result += "&bNewLine=true&sFileName=" + newFilename + "&sWidth=" + width + "&sFileURL=" + CP
 						+ "/resources/photo_upload/" + newFilename;

 			} catch (Exception e) {
 				e.printStackTrace();
 			}

 		} else {
 			// 파일이 존재하지 않는다라면
 			file_result += "&errstr=error";
 		}

 		return "redirect:" + callback + "?callback_func=" + callback_func + file_result;

 	}// end of String photoUpload(PhotoVO photovo, HttpServletRequest
 		// req)-------------------

 	// ==== #스마트에디터2. 드래그앤드롭을 사용한 다중사진 파일업로드 ====
 	@RequestMapping(value = "/image/multiplePhotoUpload.action", method = { RequestMethod.POST })
 	public void multiplePhotoUpload(HttpServletRequest req, HttpServletResponse res) {

 		/*
 		 * 1. 사용자가 보낸 파일을 WAS(톰캣)의 특정 폴더에 저장해주어야 한다. >>>> 파일이 업로드 되어질 특정 경로(폴더)지정해주기 우리는
 		 * WAS 의 webapp/resources/photo_upload 라는 폴더로 지정해준다.
 		 */

 		// WAS 의 webapp 의 절대경로를 알아와야 한다.
 		HttpSession session = req.getSession();
 		String root = session.getServletContext().getRealPath("/");
 		String path = root + "resources" + File.separator + "photo_upload";
 		// path 가 첨부파일들을 저장할 WAS(톰캣)의 폴더가 된다.

 		 //System.out.println(">>>> 확인용 path ==> " + path);
 		// >>>> 확인용 path ==>
 		// C:\springworkspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\Board\resources\photo_upload

 		File dir = new File(path);
 		if (!dir.exists())
 			dir.mkdirs();

 		String strURL = "";

 		try {
 			if (!"OPTIONS".equals(req.getMethod().toUpperCase())) {
 				String filename = req.getHeader("file-name"); // 파일명을 받는다 - 일반 원본파일명

 				// System.out.println(">>>> 확인용 filename ==> " + filename);
 				// >>>> 확인용 filename ==> berkelekle%ED%8A%B8%EB%9E%9C%EB%94%9405.jpg

 				InputStream is = req.getInputStream();
 				/*
 				 * 요청 헤더의 content-type이 application/json 이거나 multipart/form-data 형식일 때, 혹은 이름 없이
 				 * 값만 전달될 때 이 값은 요청 헤더가 아닌 바디를 통해 전달된다. 이러한 형태의 값을 'payload body'라고 하는데 요청 바디에
 				 * 직접 쓰여진다 하여 'request body post data'라고도 한다.
 				 * 
 				 * 서블릿에서 payload body는 Request.getParameter()가 아니라 Request.getInputStream() 혹은
 				 * Request.getReader()를 통해 body를 직접 읽는 방식으로 가져온다.
 				 */
 				String newFilename = fileManager.doFileUpload(is, filename, path);

 				int width = fileManager.getImageWidth(path + File.separator + newFilename);

 				if (width > 600)
 					width = 600;

 				// System.out.println(">>>> 확인용 width ==> " + width);
 				// >>>> 확인용 width ==> 600
 				// >>>> 확인용 width ==> 121

 				String CP = req.getContextPath(); // board

 				strURL += "&bNewLine=true&sFileName=";
 				strURL += newFilename;
 				strURL += "&sWidth=" + width;
 				strURL += "&sFileURL=" + CP + "/resources/photo_upload/" + newFilename;
 			}

 			/// 웹브라우저상에 사진 이미지를 쓰기 ///
 			PrintWriter out = res.getWriter();
 			out.print(strURL);
 		} catch (Exception e) {
 			e.printStackTrace();
 		}

 	}// end of void multiplePhotoUpload(HttpServletRequest req, HttpServletResponse
 		// res)----------------
 	
 	
 	
 	
 	
 	

 	
      
 }

	
	
	
	
	

