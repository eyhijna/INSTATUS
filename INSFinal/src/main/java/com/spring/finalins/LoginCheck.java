package com.spring.finalins;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

import com.spring.finalins.common.MyUtil;


/* === 주업무(<예:글쓰기, 글수정, 댓글쓰기 등등>를 실행하기 앞서 
             이러한 주업무들은 먼저 로그인을 해야만 사용가능한 작업이므로  
             주업무에 대한 보조업무 객체로 로그인 여부를 체크하는 관심 클래스(객체)를 생성하여 
             포인트컷과 더불어 어드바이스를 생성하여 동작하도록 만들겠다.       
 */

// ===== #52. 공통관심사 클래스(Aspect 클래스)생성하기 =====
@Aspect
/* 공통관심사 클래스 객체로 등록한다.
  - 기존의 XML <aop:aspect> 역할을 한다. */
@Component
/* XML에서 빈을 만드는 대신에 클래스명 앞에 @Component 어노테이션을 적어주면 해당 클래스는 bean으로 자동 등록된다. 
     그리고 bean의 이름(첫글자는 소문자)은 해당 클래스명이 된다. */
public class LoginCheck {

	    // Pointcut을 생성한다.
		// - 아래의 메소드가 기존의 XML <aop:pointcut> 역할을 한다.
		// - void + 인자값 없음으로 선언한다. 
		// - 선언해도 어차피 어노테이션의 AspectJ 표현식이 우선이기 때문에 메소드 자체의 형식은 의미가 없다.
		// - 또한 구현부도 의미없다.
		// - 대신 메소드 이름이 나중에 각각의 Advice에서 식별자로 사용됨
		@Pointcut("execution(public * com.spring.*.*Controller.requireLogin_*(..))")
		public void requireLogin() {} //포인트컷의 메소드명은 식별자로 사용된다.
		
		
		// 보조(어드바이스)업무 추가
		// -- 메모를 작성하기 전 현재 시간을 로그에 남기는 보조업무 
		
		// Adivce 설정 선언과 동시에 보조업무 생성
		// - 아래의 어노테이션이 기존의 XML <aop:before> 역할을 한다.
		// - Pointcut은 상단에 이미 선언되어 있기 때문에 지금 생성하는 Before Advice와 연결만 시켜준다.
		// 이미 설정되어 있는 requireLogin() 메소드명으로 Pointcut("execution()")이 있기 때문에
		// @Before 어노테이션을 통해 Advice 를 추가해주는 것만으로 구현이 끝난다. 
		@Before("requireLogin()")
		public void before(JoinPoint joinPoint) { //JoinPoint는 주업무의 객체를 의미한다.
			
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
				// response.sendRedirect("/finalins/index.action"); //데이터 이동 없이 페이지(url)만 이동한다.
					
				} catch(ServletException e) {
					e.printStackTrace();
				} catch(IOException e) {
					e.printStackTrace();
				} // end of try-catch 
			} // end of if
			
			return;
			
		} // end of before()
	
}
