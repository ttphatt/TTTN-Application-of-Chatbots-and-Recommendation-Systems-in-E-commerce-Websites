package com.store.Controller.Customer;

import com.store.DAO.CategoryDAO;
import com.store.DTO.CategoryDTO;
import com.store.Mapper.CategoryMapper;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;


@WebFilter("/*")
public class CommonFilter extends HttpFilter implements Filter {
   
	private final CategoryDAO categoryDAO;
	
	public CommonFilter() {
		categoryDAO = new CategoryDAO();
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest)request;
		String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
		
		if(!path.startsWith("/admin/")) {
			List<CategoryDTO> categoryList = CategoryMapper.INSTANCE.toDTOList(categoryDAO.findRootCategories());
			request.setAttribute("parentList", categoryList);
		}
		chain.doFilter(request, response);
	}

	public void init(FilterConfig fConfig) throws ServletException {}
}
