package com.spring.finalins;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.finalins.common.FileManager;
import com.spring.finalins.common.MyUtil;
import com.spring.finalins.model.CardDetailVO;
import com.spring.finalins.model.MemberVO;
import com.spring.finalins.service.InterWoneyService;



@Controller
@Component
public class WoneyController {
	
	// ===== #33. 의존객체 주입하기(DI: Dependency Injection) =====
	@Autowired// 의존객체주입(DI : Dependency Injection)
	private InterWoneyService service;
	
	// ===== #132. 파일업로드 및 다운로드 해주는 FileManger클래스 의존객체 주입하기(DI: Dependency Injection) =====
	@Autowired
	private FileManager fileManager;
	
	@RequestMapping(value="/index.action", method= {RequestMethod.GET})
	public String index(HttpServletRequest request) {

		return "main/index.tiles";
	}
	
	// ===== 카드 상세 보여주기 requireLogin_ ===== 
	@RequestMapping(value="/carddetail.action", method= {RequestMethod.GET})
	public String crearddetail(HttpServletRequest request,HttpServletResponse response,HttpSession session) 
			throws Throwable {
		String cardIDX =  request.getParameter("cardIDX");
		String listIDX =  request.getParameter("listIDX");
		String projectIDX =  request.getParameter("projectIDX");
		
		HashMap<String, String> cardMap = service.getCardInfo(cardIDX); // 카드정보 받아오기
		HashMap<String, String> cardDetailMap = service.getCardDetailInfo(cardIDX); // 카드 상세 받아오기
		List<HashMap<String, String>> cardCommentList = service.cardCommentInfo(cardIDX);// 카드 코멘트 받아오기
		HashMap<String, String> cardDueDateMap = service.cardDueDateInfo(cardIDX); // 카드 완료일 받아오기
		
		/////////////////////////////////////////////////////////////////////////////////////////
		HashMap<String, String> cardCheckTitleMap = new HashMap<String, String>();
		cardCheckTitleMap =	service.cardCheckTitleInfo(cardIDX); // 체크타이틀 받아오기
		
		List<HashMap<String, String>> cardCheckList = new ArrayList<HashMap<String, String>>() ;
		
		if(cardCheckTitleMap !=null) {
		cardCheckList =	service.cardCheckListInfo(cardCheckTitleMap.get("CARDCHECKLISTIDX")); // 체크리스트 받아오기
		}
		////////////////////////////////////////////////////////////////////////////////////////
		
		////////////////////////////////////////////////////////////////////////////////////////
		List<HashMap<String, String>> cardLabelList = new ArrayList<HashMap<String, String>>(); // 카드 라벨리스트 받아오기
		cardLabelList = service.cardLabelListInfo(cardIDX);
		
		int cardLabelCNT = service.cardLabelCNT(cardIDX); // 카드 라벨 갯수 정보
		///////////////////////////////////////////////////////////////////////////////////////
		System.out.println(cardLabelCNT);
		
		HashMap<String, String> cardRecordIDXMap = new HashMap<String, String>(); // 카드 기록 받아오기
		cardRecordIDXMap.put("projectIdx", projectIDX);
		cardRecordIDXMap.put("listIdx", listIDX);
		cardRecordIDXMap.put("cardIdx", cardIDX);
		
		List<HashMap<String, String>> cardRecordList = service.getCardRecordInfo(cardRecordIDXMap);// 카드 기록 받아오기
			
		request.setAttribute("cardMap", cardMap);
		request.setAttribute("cardDetailMap", cardDetailMap);
		request.setAttribute("cardCommentList", cardCommentList);
		request.setAttribute("cardRecordIDXMap", cardRecordIDXMap);
		request.setAttribute("cardRecordList",cardRecordList);
		request.setAttribute("cardDueDateMap", cardDueDateMap);
		request.setAttribute("cardCheckTitleMap", cardCheckTitleMap);
		request.setAttribute("cardCheckList", cardCheckList);
		request.setAttribute("cardLabelList", cardLabelList);
		request.setAttribute("cardLabelCNT", cardLabelCNT);

		if(cardMap != null) {
			int cnt = service.cardDescriptionCNT(cardIDX); // 카드 Description 존재 여부 체크
			if(cnt == 0) {
				int n = service.setcardDescriptionInsert(cardIDX); // 카드 Description 입력
			}

			return "carddetail.tiles3";
		}else {
			
			return "main/index.tiles";
		}
	}
	
	// ===== 프로젝트 멤버 체크(AJAX 처리용) ===== 
	@RequestMapping(value="/projectMemberCheck.action", method= {RequestMethod.GET})
	public String projectMemberCheck(HttpServletRequest request) {
		String cardIdx = request.getParameter("cardidx");
		String userid = request.getParameter("userid");
		HashMap<String,String> map = new HashMap<String, String>();
		map.put("cardIdx", cardIdx);
		map.put("userid", userid);
		
		String str_jsonobj = service.getProjectMember(map);
		request.setAttribute("str_jsonobj", str_jsonobj);
	
		return "cardProjectMemberCheck.notiles";
	}// end of projectMemberCheck()--------------------------
	
	// ===== 카드 제목 수정(AJAX 처리용) ===== 
	@RequestMapping(value="/cardTitleUpdate.action", method= {RequestMethod.POST})
	public String cardTitleUpdate(HttpServletRequest request) throws Throwable {
		String cardIdx = request.getParameter("cardidx");
		String projectIdx = request.getParameter("projectIdx");
		String listIdx = request.getParameter("listIdx");
		String userid = request.getParameter("userid");
		String cardUpdateTitle = request.getParameter("cardtitle");
		String recordstatus = "Title을 수정했습니다.";
		HashMap<String,String> map = new HashMap<String, String>();
		map.put("cardIdx",cardIdx);
		map.put("projectIdx",projectIdx);
		map.put("listIdx",listIdx);
		map.put("cardUpdateTitle",cardUpdateTitle);
		map.put("userid",userid);
		map.put("recordstatus",recordstatus);
		
		int n = service.setCardTitleUpdate(map);
		if(n>0) {
			String str_jsonobj = service.getCardInfoJSON(map); // card 정보 json으로 담아준다.
			request.setAttribute("str_jsonobj", str_jsonobj);
		}
		return "cardTitleUpdateJSON.notiles";
		
	}// end of cardTitleUpdate()----------------------------
	
	// ===== 카드 Description 수정(AJAX 처리용) ===== 
	@RequestMapping(value="/cardDescriptionCange.action", method= {RequestMethod.POST})
	public String cardDescriptionCange(HttpServletRequest request) throws Throwable {
		String cardIdx = request.getParameter("cardidx");
		String cardDescription = request.getParameter("carddescription");
		String projectIdx = request.getParameter("projectIdx");
		String listIdx = request.getParameter("listIdx");
		String userid = request.getParameter("userid");
		int cnt = service.cardRecordDescriptionCNT(cardIdx); 
		
		String recordstatus = "";
		if(cnt != 0) {
			recordstatus = "Description을 추가했습니다.";
		}else {
			recordstatus = "Description을 수정했습니다.";
		}
		HashMap<String,String> map = new HashMap<String, String>();
		map.put("cardIdx",cardIdx);
		map.put("cardDescription", cardDescription);
		map.put("projectIdx",projectIdx);
		map.put("listIdx",listIdx);
		map.put("userid",userid);
		map.put("recordstatus",recordstatus);
		
		int n = service.setcardDescriptionUpdate(map);

		if(n>0) {
			String str_jsonobj = service.getCardDescriptionInfoJSON(cardIdx); // cardDescription 정보 json으로 담아준다.
			request.setAttribute("str_jsonobj", str_jsonobj);
		}
		return "cardDescriptionCangeJSON.notiles";
	}// end of cardDescriptionCange()----------------------------
	
	// ===== 카드 첨부파일 추가(AJAX 처리용) ===== 
	@RequestMapping(value="/cardAttachInsert.action", method= {RequestMethod.POST})
	public String cardAttachInsert(CardDetailVO cardvo,MultipartHttpServletRequest request,HttpSession session)
			throws Throwable{
		String listIdx= request.getParameter("listIdx");
		String userid=request.getParameter("userid");
		String projectIdx=request.getParameter("projectIdx");
		String cardIdx = request.getParameter("fkcardidx");
		String recordstatus = "Attached을 추가했습니다.";
	
		HashMap<String,String> map = new HashMap<String, String>();
		map.put("cardIdx",cardIdx);
		map.put("projectIdx",projectIdx);
		map.put("listIdx",listIdx);
		map.put("userid",userid);
		map.put("recordstatus",recordstatus);
		
		// 사용자가 보낸 파일을 WAS의 특정 경로 폴더에 저장한다. => 파일이 업로드 될 특정경로(폴더) 지정하기
	    // 지금은 webapp/resources/files 폴더로 지정한다.
	    String root = session.getServletContext().getRealPath("/"); //1. WAS의 webapp의 절대경로를 얻어온다.
	    String path = root + "resources" + File.separator + "files"; //File.separator => 운영체제가 Windows라면 "\" 이고 UNIX, Linux라면 "/" 이다.
	    
	    System.out.println("확인용 path: " + path);
	    // 확인용 path: C:\finalINS\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\INSFinal\resources\files
	    
	    //2. 파일첨부를 위한 변수의 설정 및 값을 초기화한 후 파일올리기
        String newFileName = ""; //WAS 디스크에 저장될 파일명
        byte[] bytes = null; //첨부파일을 WAS 디스크에 저장할 때 사용되는 용도. 실제파일이 저장된다.
        long fileSize = 0; //파일크기를 읽어오기 위한 용도
        
        try {
            bytes = cardvo.getAttach().getBytes(); //getBytes()는 첨부된 파일을 바이트단위로 읽어오는 것이다.
            newFileName = fileManager.doFileUpload(bytes, cardvo.getAttach().getOriginalFilename(), path);
            // 파일을 업로드 한 후 현재시간+ 나노타임. 확장자로 되어진 파일명을
            //	리턴받아 nameFileName으로 저장한다.
            //	boardvo.getAttach().getOriginalFilename()은 첨부된 파일의 실제 파일명(문자열)을 얻어오는것이다.
            	
            	cardvo.setCard_filename(newFileName);
            	//newFileName 이 WAS(톰캣)에 저장될 파일명(201806283213123213213213.png)
            	cardvo.setCard_orgfilename(cardvo.getAttach().getOriginalFilename());
            	// boardvo.getAttach().getOriginalFilename() 은 진짜 파일명 (강아지.png)
            	// 사용자가 파일을 다운로드 할때 사용되어지는 파일명
            	fileSize = cardvo.getAttach().getSize();
            	// 첨부한 파일의 크기를 알아온다.
            	// 타입은 long이다.
            	
            	cardvo.setCard_byte(String.valueOf(fileSize));
        } catch (Exception e) {
        }
        ////////////=== 첨부파일이 있으면 파일업로드 하기 끝 === ////////////	
        
       int n = service.add_withFile(cardvo,map);
     
       return "cardAttachInsert.tiles3";
       
	}// end of cardAttachInsert()----------------------------
	
	// ==== 첨부파일 다운로드 받기 ====
	@RequestMapping(value="/cardFileDownload.action", method= {RequestMethod.GET})
	public void requireLogin_cardFileDownload(HttpServletRequest request,HttpServletResponse response) {
		String cardIdx = request.getParameter("cardidx");
		// 첨부파일이 있는 글번호
		System.out.println("cardIdx"+cardIdx);
		HashMap<String, String> cardDetailMap = service.getCardDetailInfo(cardIdx);
		String fileName = cardDetailMap.get("FILENAME");
		String orgFileName = cardDetailMap.get("ORGFILENAME");
		
		HttpSession session = request.getSession();
		String root = session.getServletContext().getRealPath("/"); //1. WAS의 webapp의 절대경로를 얻어온다.
        String path = root + "resources" + File.separator + "files"; //File.separator => 운영체제가 Windows라면 "\" 이고 UNIX, Linux라면 "/" 이다.
		
        boolean bool = false;
		bool = fileManager.doFileDownload(fileName, orgFileName, path, response);
		// 다운로드가 성공이면 true를 반납해주고 ,
		// 다운로드가 성공이면 false를 반납해준다.
		
		if(!bool) {
			// 다운로드가 실패할 경우 메시지를 띄어준다.
			response.setContentType("text/html; charset = UTF-8");
			PrintWriter writer = null;
			
			try {
				writer = response.getWriter();
				// 웹브라우저상에 메시지를 쓰기 위한 객체 생성.
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			writer.println("<script type='text/javascript'>alert('파일 다운로드 실패!!')</script>");
		}
	}// end of requireLogin_cardFileDownload()------------------
	
	// ===== 카드 Attach 삭제(AJAX 처리용) ===== 
	@RequestMapping(value="/cardAttachDelete.action", method= {RequestMethod.POST})
	public String cardAttachDelete(HttpServletRequest request) 
			throws Throwable {
		String listIdx= request.getParameter("listIdx");
		String userid=request.getParameter("userid");
		String projectIdx=request.getParameter("projectIdx");
		String cardIdx = request.getParameter("cardidx");
		String recordstatus = "Attached을 삭제했습니다.";

		HashMap<String,String> map = new HashMap<String, String>();
		map.put("cardIdx",cardIdx);
		map.put("projectIdx",projectIdx);
		map.put("listIdx",listIdx);
		map.put("userid",userid);
		map.put("recordstatus",recordstatus);
		
		int n = service.setcardAttachDelete(map);

		return "cardAttachDeleteJSON.notiles";
	}// end of cardAttachDelete()----------------------------
	
	// ===== 카드 Comment 입력(AJAX 처리용) ===== 
	@RequestMapping(value="/cardAddComment.action", method= {RequestMethod.POST})
	public String cardAddComment(HttpServletRequest request, HttpSession session)
			 throws Throwable{
		
		String nickname = request.getParameter("nickname");
		String content = request.getParameter("content");
		String cardIdx = request.getParameter("cardidx");
		String userid = request.getParameter("userid");
		String listIdx= request.getParameter("listIdx");
		String projectIdx=request.getParameter("projectIdx");
		String recordstatus = "Comment을 추가했습니다.";
		content = content.replaceAll("\r\n", "<br/>");

		HashMap<String, String> map = new HashMap<String, String>();
		map.put("nickname", nickname);
		map.put("content", content);
		map.put("cardIdx", cardIdx);
		map.put("projectIdx",projectIdx);
		map.put("listIdx",listIdx);
		map.put("userid",userid);
		map.put("recordstatus",recordstatus);
		
		int n = service.setcardaddComment(map);
		/*JSONArray jsonarry = new JSONArray();
		String str_jsonarray = null;
		List<HashMap<String, String>> cardCommentList = service.cardCommentInfo(cardIdx);
		MemberVO mvo = (MemberVO)session.getAttribute("loginuser");
		if(n>0) {
			for(HashMap<String, String> commentmap :cardCommentList) {
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("CARDNICKNAME", commentmap.get("CARDNICKNAME"));
			jsonObj.put("CARDCOMMENTCONTENT",  commentmap.get("CARDCOMMENTCONTENT"));
			jsonObj.put("CARDCOMMENTDATE", commentmap.get("CARDCOMMENTDATE"));
			jsonObj.put("CARDCOMMENTUSERID", commentmap.get("CARDCOMMENTUSERID"));
			jsonObj.put("FKCARDIDX", commentmap.get("FKCARDIDX"));
			jsonObj.put("CARDCOMMENTIDX", commentmap.get("CARDCOMMENTIDX"));
			jsonObj.put("SESSIONUSERID", mvo.getUserid());
			
			jsonarry.put(jsonObj);
			}
		}
		str_jsonarray = jsonarry.toString();
		System.out.println("str_jsonarray Comment!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"+ str_jsonarray);
		request.setAttribute("str_jsonarray", str_jsonarray);
		*/
		return "goComment.notiles";
	}// end of cardAddComment()----------------------------
	
	// ===== 카드 Comment 수정(AJAX 처리용) ===== 
	@RequestMapping(value="/cardCommentEdit.action", method= {RequestMethod.POST})
	public String cardCommentEdit(HttpServletRequest request, HttpSession session) 
			throws Throwable {
		String cardIdx = request.getParameter("cardidx");
		String cardcommentidx = request.getParameter("cardcommentidx");
		String Editcontent = request.getParameter("Editcontent");
		String userid = request.getParameter("userid");
		String listIdx= request.getParameter("listIdx");
		String projectIdx=request.getParameter("projectIdx");
		String recordstatus = "Comment을 수정했습니다.";

		HashMap<String, String> map = new HashMap<String, String>();
		map.put("cardIdx", cardIdx);
		map.put("cardcommentidx", cardcommentidx);
		map.put("Editcontent", Editcontent);
		map.put("projectIdx",projectIdx);
		map.put("listIdx",listIdx);
		map.put("userid",userid);
		map.put("recordstatus",recordstatus);
				
		int n = service.setcardCommentEdit(map);
		/*JSONArray jsonarry = new JSONArray();
		String str_jsonarray = null;
		List<HashMap<String, String>> cardCommentList = service.cardCommentInfo(cardIdx);
		MemberVO mvo = (MemberVO)session.getAttribute("loginuser");
		if(n>0) {
			for(HashMap<String, String> commentmap :cardCommentList) {
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("CARDNICKNAME", commentmap.get("CARDNICKNAME"));
			jsonObj.put("CARDCOMMENTCONTENT",  commentmap.get("CARDCOMMENTCONTENT"));
			jsonObj.put("CARDCOMMENTDATE", commentmap.get("CARDCOMMENTDATE"));
			jsonObj.put("CARDCOMMENTUSERID", commentmap.get("CARDCOMMENTUSERID"));
			jsonObj.put("FKCARDIDX", commentmap.get("FKCARDIDX"));
			jsonObj.put("CARDCOMMENTIDX", commentmap.get("CARDCOMMENTIDX"));
			jsonObj.put("SESSIONUSERID", mvo.getUserid());
			
			jsonarry.put(jsonObj);
			}
		}
		str_jsonarray = jsonarry.toString();
		request.setAttribute("str_jsonarray", str_jsonarray);*/
		
		return "goComment.notiles";
	}// end of cardCommentEdit()----------------------------
	
	
	// ===== 카드 Comment 삭제(AJAX 처리용) ===== 
	@RequestMapping(value="/goCommentDelete.action", method= {RequestMethod.GET})
	public String goCommentDelete(HttpServletRequest request, HttpSession session) throws Throwable {
		
		String cardIdx = request.getParameter("cardidx");
		String cardcommentidx = request.getParameter("cardcommentidx");
		String userid = request.getParameter("userid");
		String listIdx= request.getParameter("listIdx");
		String projectIdx=request.getParameter("projectIdx");
		String recordstatus = "Comment을 삭제했습니다.";
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("cardIdx", cardIdx);
		map.put("cardcommentidx", cardcommentidx);
		map.put("projectIdx",projectIdx);
		map.put("listIdx",listIdx);
		map.put("userid",userid);
		map.put("recordstatus",recordstatus);
		
		int n = service.setcardCommentDelete(map);
		/*	
		JSONArray jsonarry = new JSONArray();
		String str_jsonarray = "";
		List<HashMap<String, String>> cardCommentList = service.cardCommentInfo(cardIdx);
		
		MemberVO mvo = (MemberVO)session.getAttribute("loginuser");
		if(n>0) {
			for(HashMap<String, String> commentmap :cardCommentList) {
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("CARDNICKNAME", commentmap.get("CARDNICKNAME"));
			jsonObj.put("CARDCOMMENTCONTENT",  commentmap.get("CARDCOMMENTCONTENT"));
			jsonObj.put("CARDCOMMENTDATE", commentmap.get("CARDCOMMENTDATE"));
			jsonObj.put("CARDCOMMENTUSERID", commentmap.get("CARDCOMMENTUSERID"));
			jsonObj.put("FKCARDIDX", commentmap.get("FKCARDIDX"));
			jsonObj.put("CARDCOMMENTIDX", commentmap.get("CARDCOMMENTIDX"));
			jsonObj.put("SESSIONUSERID", mvo.getUserid());
			
			jsonarry.put(jsonObj);
			}
		}
		str_jsonarray = jsonarry.toString();
		request.setAttribute("str_jsonarray", str_jsonarray);*/
		
		return "goComment.notiles";
	}// end of goCommentDelete()----------------------------
	
	// ==== 카드 기록 정보 받아오기 ====
	@RequestMapping(value="/cardRecordInfo.action", method= {RequestMethod.GET})
	public String cardRecordInfo(HttpServletRequest request,HttpServletResponse response) {
		String cardIdx = request.getParameter("cardidx");
		String projectIdx = request.getParameter("projectIdx");
		String listIdx = request.getParameter("listIdx");
		
		HashMap<String, String> cardRecordIDXMap = new HashMap<String, String>(); 
		cardRecordIDXMap.put("cardIdx", cardIdx);
		cardRecordIDXMap.put("projectIdx", projectIdx);
		cardRecordIDXMap.put("listIdx", listIdx);
		
		JSONArray jsonarry = new JSONArray();
		String str_jsonarray = null;
		List<HashMap<String, String>> cardRecordList = service.getCardRecordInfo(cardRecordIDXMap);// 카드 기록 받아오기
		
		for(HashMap<String, String> cardRecordmap :cardRecordList) {
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("NICKNAME", cardRecordmap.get("NICKNAME"));
		jsonObj.put("RECORDDMLSTATUS",  cardRecordmap.get("RECORDDMLSTATUS"));
		jsonObj.put("PROJECTRECORDTIME", cardRecordmap.get("PROJECTRECORDTIME"));

		jsonarry.put(jsonObj);
		}
		str_jsonarray = jsonarry.toString();
		request.setAttribute("str_jsonarray", str_jsonarray);
		
		return "gocardRecordInfoJSON.notiles";
	}// end of cardRecordInfo()------------------
	
	// ==== 카드 삭제하기 ====
	@RequestMapping(value="/cardDelete.action", method= {RequestMethod.POST})
	public String cardDelete(HttpServletRequest request) {
		String cardIdx = request.getParameter("cardidx");
		String userid = request.getParameter("userid");
		String listIdx= request.getParameter("listIdx");
		String projectIdx=request.getParameter("projectIdx");
		String recordstatus = "Card을 삭제했습니다.";
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("cardIdx", cardIdx);
		map.put("userid", userid);
		map.put("listIdx", listIdx);
		map.put("projectIdx", projectIdx);
		map.put("recordstatus", recordstatus);
			
		int n = service.setCardDelete(map);
		return "gocardRecordInfoJSON.notiles";
	}// end of cardDelete()------------------
	
	// ==== 카드 Due date 생성 ====
	@RequestMapping(value="/goDueDateAdd.action", method= {RequestMethod.POST})
	public String goDueDateAdd(HttpServletRequest request) {
		String cardIdx = request.getParameter("cardidx");
		String datepicker = request.getParameter("datepicker");
		
		HashMap<String, String> map = new HashMap<String, String>(); 
		map.put("cardIdx", cardIdx);
		map.put("datepicker", datepicker);

		int n = service.setCardDuDateAdd(map);
	
		HashMap<String, String> cardDueDateMap = service.cardDueDateInfo(cardIdx);
		
		String str_jsonobj ="";
		JSONObject jsonobj = new JSONObject();
		jsonobj.put("CARDCHECK", cardDueDateMap.get("CARDCHECK"));
		jsonobj.put("CARDDUEDATE", cardDueDateMap.get("CARDDUEDATE"));
		jsonobj.put("CARDDUEDATEIDX", cardDueDateMap.get("CARDDUEDATEIDX"));
		
		str_jsonobj = jsonobj.toString();
		request.setAttribute("str_jsonobj", str_jsonobj);
		
		return "gocheckChangeJSON.notiles";
	}// end of goDueDateAdd()------------------
	
	// ==== 카드 Due date 수정 ====
	@RequestMapping(value="/goDueDateEdit.action", method= {RequestMethod.POST})
	public String goDueDateEdit(HttpServletRequest request) {
		String cardIdx = request.getParameter("cardidx");
		String datepicker = request.getParameter("datepicker");
		String cardduedateIdx = request.getParameter("cardduedateIdx");
		
		HashMap<String, String> map = new HashMap<String, String>(); 
		map.put("cardIdx", cardIdx);
		map.put("datepicker", datepicker);
		map.put("cardduedateIdx", cardduedateIdx);

		int n = service.setCardDueDateEdit(map);
	
		HashMap<String, String> cardDueDateMap = service.cardDueDateInfo(cardIdx);
		
		String str_jsonobj ="";
		JSONObject jsonobj = new JSONObject();
		jsonobj.put("CARDCHECK", cardDueDateMap.get("CARDCHECK"));
		jsonobj.put("CARDDUEDATE", cardDueDateMap.get("CARDDUEDATE"));
		jsonobj.put("CARDDUEDATEIDX", cardDueDateMap.get("CARDDUEDATEIDX"));
		
		str_jsonobj = jsonobj.toString();
		request.setAttribute("str_jsonobj", str_jsonobj);
		
		return "gocheckChangeJSON.notiles";
	}// end of goDueDateEdit()------------------
	
	// ==== 카드 Due date 삭제 ====
	@RequestMapping(value="/goDueDateDelete.action", method= {RequestMethod.POST})
	public String goDueDateDelete(HttpServletRequest request) {
		String cardIdx = request.getParameter("cardidx");
		String cardduedateIdx = request.getParameter("cardduedateIdx");
		
		HashMap<String, String> map = new HashMap<String, String>(); 
		map.put("cardIdx", cardIdx);
		map.put("cardduedateIdx", cardduedateIdx);

		int n = service.setCardDueDateDelete(map);

		int cardDueDateCNT = service.cardDueDateCNT(cardIdx);
		
		String str_jsonobj ="";
		JSONObject jsonobj = new JSONObject();
		jsonobj.put("CARDDUEDATECNT", cardDueDateCNT);
		
		str_jsonobj = jsonobj.toString();
		request.setAttribute("str_jsonobj", str_jsonobj);
		
		return "gocheckChangeJSON.notiles";
	}// end of goDueDateDelete()------------------
	
	// ==== 카드 Due Date 체크 ====
	@RequestMapping(value="/checkChange.action", method= {RequestMethod.POST})
	public String checkChange(HttpServletRequest request) {
		String cardIdx = request.getParameter("cardidx");
		String cardduedateIdx = request.getParameter("cardduedateIdx");
		
		HashMap<String, String> map = new HashMap<String, String>(); 
		map.put("cardIdx", cardIdx);
		map.put("cardduedateIdx", cardduedateIdx);

		int n = service.cardCheck(map);

		String str_jsonobj ="";
		JSONObject jsonobj = new JSONObject();
		jsonobj.put("datecheckCNT", n);
		
		str_jsonobj = jsonobj.toString();
		request.setAttribute("str_jsonobj", str_jsonobj);

		return "gocheckChangeJSON.notiles";
	}// end of checkChange()------------------
	
	// ==== 카드  체크리스트 타이들 생성 ====
	@RequestMapping(value="/goCheckListTitleAdd.action", method= {RequestMethod.POST})
	public String goCheckListTitleAdd(HttpServletRequest request) {
		String cardIdx = request.getParameter("cardidx");
		String checkListTitleName = request.getParameter("checkListTitleName");
	
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("cardIdx", cardIdx);
		map.put("checkListTitleName", checkListTitleName);

		int cnt = service.getCheckListCNT(cardIdx);

		String str_jsonobj ="";
		JSONObject jsonobj = new JSONObject();
		if(cnt == 0) {
			int n = service.setCheckListTitleAdd(map);

			HashMap<String, String> cardCheckTitleMap = service.cardCheckTitleInfo(cardIdx); // 체크타이틀 받아오기
				
				
			jsonobj.put("CARDCHECKLISTIDX", cardCheckTitleMap.get("CARDCHECKLISTIDX"));
			jsonobj.put("CARDCHECKLISTTITLE",cardCheckTitleMap.get("CARDCHECKLISTTITLE") );
			jsonobj.put("TitleCheck", "0");
		}else {
			jsonobj.put("TitleCheck", "1");
		}
		
			str_jsonobj = jsonobj.toString();
			request.setAttribute("str_jsonobj", str_jsonobj);
		
		return "goCheckListJSON.notiles";
	}// end of goCheckListTitleAdd()------------------
	
	// ==== 카드  체크리스트 타이들 수정 ====
	@RequestMapping(value="/goCheckLisTitletEdit.action", method= {RequestMethod.POST})
	public String goCheckLisTitletEdit(HttpServletRequest request) {
		String cardIdx = request.getParameter("cardidx");
		String cardchecklistIdx = request.getParameter("cardchecklistIdx");
		String checkListTitleEditvalue = request.getParameter("checkListTitleEditvalue");
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("cardIdx", cardIdx);
		map.put("cardchecklistIdx", cardchecklistIdx);
		map.put("checkListTitleEditvalue", checkListTitleEditvalue);

		int n = service.setCheckLisTitletEdit(map);
		
		String str_jsonobj ="";
		JSONObject jsonobj = new JSONObject();	
		if(n==1) {
			HashMap<String, String> cardCheckTitleMap = service.cardCheckTitleInfo(cardIdx); // 체크타이틀 받아오기
			
			jsonobj.put("CARDCHECKLISTIDX", cardCheckTitleMap.get("CARDCHECKLISTIDX"));
			jsonobj.put("CARDCHECKLISTTITLE",cardCheckTitleMap.get("CARDCHECKLISTTITLE") );
		
		}
		str_jsonobj = jsonobj.toString();
		request.setAttribute("str_jsonobj", str_jsonobj);
		
		System.out.println("CARDCHECKLISTTITLE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!:"+str_jsonobj);
		return "goCheckListJSON.notiles";
	}// end of goCheckLisTitletEdit()------------------	
	
	// ==== 카드  체크리스트 생성 ====
	@RequestMapping(value="/goCheckListAdd.action", method= {RequestMethod.POST})
	public String goCheckListAdd(HttpServletRequest request) {
		String cardchecklistIdx = request.getParameter("cardchecklistIdx");
		String checkListContent = request.getParameter("checkListContent");
		
		HashMap<String, String> map = new HashMap<String, String>(); 
		map.put("cardchecklistIdx", cardchecklistIdx);
		map.put("checkListContent", checkListContent);

		int n = service.setCheckListAdd(map);
		String str_jsonarray ="";
		JSONArray jsonarr = new JSONArray();

		List<HashMap<String, String>> cardCheckList = service.cardCheckListInfo(cardchecklistIdx); // 체크리스트 받아오기
		
		for(HashMap<String, String> cardChecListMap :cardCheckList) {
			JSONObject jsonobj = new JSONObject();	
			jsonobj.put("CARDCHECKLISTDETAILIDX", cardChecListMap.get("CARDCHECKLISTDETAILIDX"));
			jsonobj.put("FKCARDCHECKLISTIDX", cardChecListMap.get("FKCARDCHECKLISTIDX"));
			jsonobj.put("CARDCHECKLISTTODO",cardChecListMap.get("CARDCHECKLISTTODO") );
			jsonobj.put("CARDCHECKLISTTODOSTATUS",cardChecListMap.get("CARDCHECKLISTTODOSTATUS") );
			
			jsonarr.put(jsonobj);
		}
		str_jsonarray = jsonarr.toString();
		request.setAttribute("str_jsonarray", str_jsonarray);
		
		//System.out.println("CARDCHECKLISTTITLE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!:"+str_jsonarray);System.out.println("CARDCHECKLISTTITLE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!:"+str_jsonarray);
		return "goCheckListJSONArr.notiles";
	}// end of goCheckListAdd()------------------	
			
	// ==== 카드  체크리스트 체크 상태 변경 ====
	@RequestMapping(value="/goCheckListChange.action", method= {RequestMethod.POST})
	public String goCheckListChange(HttpServletRequest request) {
		String checkDetailIdx = request.getParameter("checkDetailIdx"); // 디테일 idx
		String cardchecklistIdx = request.getParameter("cardchecklistIdx"); // 리스트 idx
		String checkListStatus = request.getParameter("checkListStatus"); 
		if("0".equals(checkListStatus)) {
			checkListStatus = "1"; // 스테이터스가 0이면 1으로 바꾸고 
		}else if("1".equals(checkListStatus)){
			checkListStatus = "0"; // 스테이터스가 1이면 0으로 바꾸고 
		}
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("checkDetailIdx", checkDetailIdx);
		map.put("cardchecklistIdx", cardchecklistIdx);
		map.put("checkListStatus", checkListStatus);

		int n = service.setCheckListChange(map);
	
		return "goCheckListNodata.notiles";
	}// end of goCheckListChange()------------------	
	
	// ==== 카드  체크리스트 삭제 ====
	@RequestMapping(value="/goCheckListDelete.action", method= {RequestMethod.POST})
	public String goCheckListDelete(HttpServletRequest request) {
		String cardchecklistIdx = request.getParameter("cardchecklistIdx");
		String checkDetailIdx = request.getParameter("checkDetailIdx");
		
		HashMap<String, String> map = new HashMap<String, String>(); 
		map.put("cardchecklistIdx", cardchecklistIdx);
		map.put("checkDetailIdx", checkDetailIdx);

		int n = service.setCheckListDelete(map);
		String str_jsonarray ="";
		JSONArray jsonarr = new JSONArray();

		List<HashMap<String, String>> cardCheckList = service.cardCheckListInfo(cardchecklistIdx); // 체크리스트 받아오기
		
		for(HashMap<String, String> cardChecListMap :cardCheckList) {
			JSONObject jsonobj = new JSONObject();	
			jsonobj.put("CARDCHECKLISTDETAILIDX", cardChecListMap.get("CARDCHECKLISTDETAILIDX"));
			jsonobj.put("FKCARDCHECKLISTIDX", cardChecListMap.get("FKCARDCHECKLISTIDX"));
			jsonobj.put("CARDCHECKLISTTODO",cardChecListMap.get("CARDCHECKLISTTODO") );
			jsonobj.put("CARDCHECKLISTTODOSTATUS",cardChecListMap.get("CARDCHECKLISTTODOSTATUS") );
			
			jsonarr.put(jsonobj);
		}
		str_jsonarray = jsonarr.toString();
		request.setAttribute("str_jsonarray", str_jsonarray);
		
		return "goCheckListJSONArr.notiles";
	}// end of goCheckListDelete()------------------
	
	// ==== 카드  체크리스트 타이틀 삭제 ====
	@RequestMapping(value="/goCheckListTitleDelete.action", method= {RequestMethod.POST})
	public String goCheckListTitleDelete(HttpServletRequest request) {
		String cardchecklistIdx = request.getParameter("cardchecklistIdx");
		String cardIdx = request.getParameter("cardidx");
		
		HashMap<String, String> map = new HashMap<String, String>(); 
		map.put("cardchecklistIdx", cardchecklistIdx);
		map.put("cardIdx", cardIdx);

		int n = service.setCheckListTitleDelete(map);
	
		return "goCheckListNodata.notiles";
	}// end of goCheckListTitleAdd()------------------	
	
	// ==== 카드  라벨추가 ====
	@RequestMapping(value="/goLabelAdd.action", method= {RequestMethod.POST})
	public String goLabelAdd(HttpServletRequest request) {
		String labelid = request.getParameter("labelid");
		String cardIdx = request.getParameter("cardidx");
		
		HashMap<String, String> map = new HashMap<String, String>(); 
		map.put("labelid", labelid);
		map.put("cardIdx", cardIdx);

		int n = service.setLabelAdd(map);
		
		return "goLabelDML.notiles";
	}// end of goLabelAdd()------------------	
	
	// 라벨 리스트 불러오기
	@RequestMapping(value="/labelselect.action", method= {RequestMethod.POST})
	public String labelselect(HttpServletRequest request) {
		String cardIdx = request.getParameter("cardidx");
		
		String str_jsonarray ="";
		JSONArray jsonarr = new JSONArray();
	
		List<HashMap<String, String>> cardLabelList = service.cardLabelListInfo(cardIdx); // 카드 라벨리스트 받아오기
		
		for(HashMap<String, String> cardLabelListMap : cardLabelList) {
			JSONObject jsonobj = new JSONObject();	
			jsonobj.put("CARDLABELIDX", cardLabelListMap.get("CARDLABELIDX"));
			jsonobj.put("CARDLABEL", cardLabelListMap.get("CARDLABEL"));

			jsonarr.put(jsonobj);
		}	
		str_jsonarray = jsonarr.toString();
		request.setAttribute("str_jsonarray", str_jsonarray);
		//System.out.println("CARDCHECKLISTTITLE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!:"+str_jsonarray);

		return "goLabel.notiles";
	}// end of labelselect()------------------	
	
	
	// 라벨 갯수 불러오기
	@RequestMapping(value="/labelcnt.action", method= {RequestMethod.POST})
	public String labelcnt(HttpServletRequest request) {
		String cardIdx = request.getParameter("cardidx");
		
		String str_jsonobj ="";
		JSONObject jsonobj = new JSONObject();
	
		int cardLabelCNT = service.cardLabelCNT(cardIdx); // 카드 라벨 갯수 정보
		
		jsonobj.put("cardLabelCNT", cardLabelCNT);
		
		str_jsonobj = jsonobj.toString();
		request.setAttribute("str_jsonobj", str_jsonobj);
		//System.out.println("CARDCHECKLISTTITLE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!:"+str_jsonobj);

		return "goLabel.notiles";
	}// end of labelcnt()------------------	
}
