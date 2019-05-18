package com.spring.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomLoginSucessHandler implements AuthenticationSuccessHandler {
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
			log.warn("Login success");
			
			List<String> roleNames=new ArrayList<String>();
			//로그인이 성공하면 기본적인 값들이 Authentication 객체에 담기게 됨
			authentication.getAuthorities().forEach(author -> {
				roleNames.add(author.getAuthority());
			});
			
			if(roleNames.contains("ROLE_ADMIN")) {
				response.sendRedirect("/sample/admin");
				return;
			}
			
			if(roleNames.contains("ROLE_MEMBER")) {
				response.sendRedirect("/sample/member");
				return;
			}
			response.sendRedirect("/");
	}
}





