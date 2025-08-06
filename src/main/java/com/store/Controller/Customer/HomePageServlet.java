package com.store.Controller.Customer;

import com.store.DAO.ProductDAO;
import com.store.DTO.ProductDTO;
import com.store.Entity.Product;
import com.store.Mapper.ProductMapper;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serial;
import java.util.List;

@WebServlet("")
public class HomePageServlet extends HttpServlet {
	@Serial
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ProductDAO productDAO = new ProductDAO();
		
		List<ProductDTO> listNewShirts = productDAO.listNewProducts();
		List<ProductDTO> listMostFavoredProducts = productDAO.listMostFavoredProducts();
		List<ProductDTO> listBestSellingProducts = productDAO.listBestSelling();
		
		request.setAttribute("listNewShirts", listNewShirts);
		request.setAttribute("listBestSellingProducts", listBestSellingProducts);
		request.setAttribute("listMostFavoredProducts", listMostFavoredProducts);
		
		String homePage = "frontend/index.jsp";
		RequestDispatcher dispatcher = request.getRequestDispatcher(homePage);
		dispatcher.forward(request, response);
	}
}
