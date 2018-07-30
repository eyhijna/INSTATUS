package com.spring.finalins;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.spring.finalins.common.MyUtil;
import com.spring.finalins.model.MemberVO;
import com.spring.finalins.model.TeamMemberVO;
import com.spring.finalins.model.TeamVO;
import com.spring.finalins.service.InterStarService;

// 팀생성시 팀테이블에 자동insert되는 클래스 

 
@Aspect 
@Component 
public class InsertTeamMember {
  
	     @Autowired
	     private InterStarService service;
	
		 @Before("execution(public * com.spring.*.*Controller.loginAndInsert_*(..))")
	     public void Before(JoinPoint joinPoint) {
			
			//로그인 유무를 확인하기 위해 request를 통해 session을 얻어온다.
			HttpServletRequest request = (HttpServletRequest)joinPoint.getArgs()[0]; //주업무 객체의 첫번째 파라미터인 HttpServletRequest를 가져온다.
			HttpServletResponse response = (HttpServletResponse)joinPoint.getArgs()[1]; //dispatcher.forward를 위해 response 또한 파라미터로 지정해야 한다.
			HttpSession session = request.getSession();
			
			//보조업무 구현
			//	-> 해당 요청자가 인증받지 못한 상태라면 회원 전용 페이지에 접근할 수 없기에 다른페이지(/WEB-INF/viewsnotiles/msg.jsp)로 강제이동시킨다.
			if(session.getAttribute("loginuser") == null) {
				try { //dispatcher 예외처리를 위한 try-catch
					String msg = "로그인이 필요한 메뉴입니다.";
					String loc = "/finalins/index.action"; //로그인하지 않은 상태에서 메뉴접근하는 경우 메세지를 띄운 후 로그인 페이지로 이동시킬 예정
					
					request.setAttribute("msg", msg);
					request.setAttribute("loc", loc);
					
					//로그인 성공 후 로그인 하기 이전의 페이지로 돌아가기 위해 현재페이지의 주소(url)을 알아온다.
					String url = MyUtil.getCurrentURL(request);
				//	System.out.println("현재페이지 확인용:" + url);
					session.setAttribute("goBackURL", url); //세션에 url정보를 저장시킨다.
					
					RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/viewsnotiles/msg.jsp"); 
					// request에 데이터를 담아 /WEB-INF/viewsnotiles/msg.jsp페이지로 보낸다.
					dispatcher.forward(request, response); 
					//dispatcher는 데이터를 다른 페이지로 이동시키지만 url이 바뀌지는 않는다.
					//response.sendRedirect("/board/index.action"); 데이터 이동 없이 페이지(url)만 이동한다.
					
				} catch(ServletException e) {
					e.printStackTrace();
				} catch(IOException e) {
					e.printStackTrace();
				} // end of try-catch 
			} // end of if
	    	  
	     }
	     
	     @After("execution(public * com.spring.*.*Controller.loginAndInsert_*(..))")
	     public void After(JoinPoint joinPoint) {
	    	 
	    	 HttpServletRequest request = (HttpServletRequest)joinPoint.getArgs()[0]; //주업무 객체의 첫번째 파라미터인 HttpServletRequest를 가져온다.
			 HttpServletResponse response = (HttpServletResponse)joinPoint.getArgs()[1]; //dispatcher.forward를 위해 response 또한 파라미터로 지정해야 한다.
			 TeamVO teamvo = (TeamVO)joinPoint.getArgs()[2];
			 
			 HttpSession session = request.getSession();
			 MemberVO loginuser= (MemberVO)session.getAttribute("loginuser");
			 
			 System.out.println("after확인용:"+teamvo.getTeam_idx());
			 
			 HashMap<String, String> map = new HashMap<String, String>();
			 map.put("team_idx", teamvo.getTeam_idx());
			 map.put("admin_userid", teamvo.getAdmin_userid());
			 map.put("login_userid", loginuser.getUserid());
			 
			 int n = 0, m = 0; 
			 if("yes".equals(session.getAttribute("createTeam"))) { //팀생성 페이지를 통해 들어왔다면 
			     m = service.checkMemberExist(map); // 팀안에 중복되어있는지 검사 
			    if(m == 0) {
			        n = service.insertTeamMember(map); // 중복되어있지 않다면 insert해준다.  
			        
			        String nav = "1";  
					request.setAttribute("nav", nav);
			        if(n==0) {
			    		 try { //dispatcher 예외처리를 위한 try-catch
				    		    String msg = "팀테이블 생성 실패";
								String loc = "/finalins/index.action"; //로그인하지 않은 상태에서 메뉴접근하는 경우 메세지를 띄운 후 로그인 페이지로 이동시킬 예정
								
								request.setAttribute("msg", msg);
								request.setAttribute("loc", loc);
								
								//로그인 성공 후 로그인 하기 이전의 페이지로 돌아가기 위해 현재페이지의 주소(url)을 알아온다.
								String url = MyUtil.getCurrentURL(request);
							//	System.out.println("현재페이지 확인용:" + url);
								session.setAttribute("goBackURL", url); //세션에 url정보를 저장시킨다.
								
								RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/viewsnotiles/msg.jsp"); 
								// request에 데이터를 담아 /WEB-INF/viewsnotiles/msg.jsp페이지로 보낸다.
								dispatcher.forward(request, response);  
								
							} catch(ServletException e) {
								e.printStackTrace();
							} catch(IOException e) {
								e.printStackTrace();
							} // end of try-catch 
			    	 }//end of if
			         else {
			        	
			        	List<TeamMemberVO> memberList = service.teamMemberList(teamvo.getTeam_idx()); // 팀의 회원정보들을 불러오는 메소드 
						request.setAttribute("memberList", memberList);  
					   	  
					    n = service.checkMemberExist(map); //내가 회원에 존재하는지 체크 
					    if(n>0) { 
					         TeamMemberVO myinfo = service.teamMemberInfo(map); //존재한다면 나의 status 를 가져온다. 	    	 
					    	 request.setAttribute("mystatus", myinfo.getTeam_member_admin_status());
					    }
			        }//end of else
			        session.removeAttribute("createTeam");
			    }
			 } 
			  
	    	 
	     }
	
}
