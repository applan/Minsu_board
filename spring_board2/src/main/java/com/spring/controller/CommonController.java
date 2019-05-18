package com.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class CommonController {

	@GetMapping("/signin")
	public void goSignIn() {
          log.info("SignIn 호출");		
	}
	
	@GetMapping("/")
	public String index() {
		log.info("index 호출");
		return "index";
	}
	
	@GetMapping("/logout")
	public void logout() {
		log.info("logOut 호출");
		
	}
	
	@PostMapping("/logout")
	public void logoutPost() {
		log.info("logout 요청");
	}
}
