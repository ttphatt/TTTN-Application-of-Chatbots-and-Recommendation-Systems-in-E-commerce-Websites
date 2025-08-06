package com.store.Controller.Admin;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;


@WebFilter("/admin/*")
public class AdminLoginFilter implements Filter {

    public AdminLoginFilter() {}

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpSession session = httpRequest.getSession(false);

		boolean loggedIn = session != null && session.getAttribute("userEmail") != null;
		String loginURI = httpRequest.getContextPath() + "/admin/login";

		boolean loginRequest = httpRequest.getRequestURI().equals(loginURI);
		boolean loginPage = httpRequest.getRequestURI().endsWith("login.jsp");

		//Kiểm tra xem user có đăng nhập hay chưa
		if(loggedIn && (loginRequest || loginPage)) {
			RequestDispatcher requestDispatcher = request.getRequestDispatcher("/admin/");
			requestDispatcher.forward(request, response);
		}
		else if(loggedIn || loginRequest) {
			chain.doFilter(request, response);

		}
		//User chưa đang nhập thì điều hướng sang trang login
		else {
			String loginPath = "/common/login.jsp";
			request.setAttribute("isAdminLogin", true);

			RequestDispatcher requestDispatcher = request.getRequestDispatcher(loginPath);
			requestDispatcher.forward(request, response);

		}
	}
}
