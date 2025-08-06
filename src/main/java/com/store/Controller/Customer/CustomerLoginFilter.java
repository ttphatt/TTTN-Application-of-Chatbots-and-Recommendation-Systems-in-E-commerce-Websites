package com.store.Controller.Customer;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;


@WebFilter("/*")
public class CustomerLoginFilter extends HttpFilter implements Filter {
    private static final String[] loginRequiredURLs = {
    		"/view_profile", "/edit_profile", "/update_profile"	, "/write_rate",
    		"/checkout", "/place_order", "/view_orders", "/show_order_detail"
    };
	
    public CustomerLoginFilter() {
        super();
	}

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpSession session = httpRequest.getSession(false);
		
		String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
		
		if(path.startsWith("/admin/")) {
			chain.doFilter(request, response);
			return;
		}
		
		String requestURL = httpRequest.getRequestURL().toString();
		boolean loggedIn = session != null && session.getAttribute("loggedCustomer") != null;
		
		if(!loggedIn && isLoginRequired(requestURL)) {
			String queryString = httpRequest.getQueryString();
			String redirectURL = requestURL;
			
			if(queryString != null) {
				redirectURL = redirectURL.concat("?").concat(queryString);
			}

            assert session != null;
            session.setAttribute("redirectURL", redirectURL);
			request.setAttribute("isAdminLogin", false);

			String loginPath = "common/login.jsp";
			RequestDispatcher requestDispatcher = request.getRequestDispatcher(loginPath);
			requestDispatcher.forward(request, response);
		}
		else {
			chain.doFilter(request, response);
		}
	}

	private boolean isLoginRequired(String requestURL) {
		for(String loginRequiredURL : loginRequiredURLs) {
			if(requestURL.contains(loginRequiredURL)) {
				return true;
			}
		}
		return false;
	}
	
	public void init(FilterConfig fConfig) throws ServletException {}
}
