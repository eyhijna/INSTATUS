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




@Controller
@Component
public class WoneyController {
	

	@RequestMapping(value="/index.action", method= {RequestMethod.GET})
	public String index(HttpServletRequest request) {

		return "main/index.tiles";
	}
}