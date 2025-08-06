package com.store.Controller.Admin;

import com.store.DAO.*;
import com.store.DTO.OrderDTO;
import com.store.DTO.RateDTO;
import com.store.Mapper.OrderMapper;
import com.store.Mapper.RateMapper;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serial;
import java.util.List;

@WebServlet("/admin/")
public class AdminHomePageServlet extends HttpServlet {
	@Serial
	private static final long serialVersionUID = 1L;
    
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//Lấy ra danh sách các đơn đặt hàng để hiển thị lên trang index của admin
		OrderDAO orderDAO = new OrderDAO();
		List<OrderDTO> listMostRecentSales = OrderMapper.INSTANCE.toDTOList(orderDAO.listMostRecentSales());


		//Lấy ra danh sách các đánh giá để để hiển thị trên trand index của admin
		RateDAO rateDAO = new RateDAO();
		List<RateDTO> listMostRecentRates = RateMapper.INSTANCE.toDTOList(rateDAO.listMostRecentRates());

		List<String> listRatingStars = rateDAO.listRatingStars();
		List<Integer> countRatingStars = rateDAO.countRatingStars();

		//Đếm số lượng user có trong database
		UserDAO userDAO = new UserDAO();
		long totalUsers = userDAO.count();

		//Đếm số lượng áo có trong database
		ProductDAO productDAO = new ProductDAO();
		long totalShirts = productDAO.count();
		List<String>soldShirtName = productDAO.listSoldProductName();
		List<Integer>eachShirtRevenue = productDAO.listEachProductRevenue();

		List<Integer>shirtsByTypes = productDAO.countGroupedByCategory();

		//Đếm số lượng khách hàng có trong database
		CustomerDAO customerDAO = new CustomerDAO();
		long totalCustomers = customerDAO.count();

		CategoryDAO categoryDAO = new CategoryDAO();
		long totalTypes = categoryDAO.count();

		//Lấy ra danh sách chứa tên các loại
		List<String>typeNames = categoryDAO.listUsedCategoryName();

		//Đếm số lượng đánh giá
		long totalRates = rateDAO.count();

		//Đếm số lượng đơn hàng
		long totalOrders = orderDAO.count();

		//Đẩy dữ liệu qua view
		request.setAttribute("listMostRecentSales", listMostRecentSales);
		request.setAttribute("listMostRecentRates", listMostRecentRates);

		request.setAttribute("listRatingStars", listRatingStars);
		request.setAttribute("countRatingStars", countRatingStars);

		request.setAttribute("totalUsers", totalUsers);
		request.setAttribute("totalShirts", totalShirts);

		request.setAttribute("shirtsByTypes", shirtsByTypes);
		request.setAttribute("soldShirtName", soldShirtName);
		request.setAttribute("eachShirtRevenue", eachShirtRevenue);

		request.setAttribute("totalCustomers", totalCustomers);
		request.setAttribute("totalTypes", totalTypes);
		request.setAttribute("typeNames", typeNames);
		request.setAttribute("totalRates", totalRates);
		request.setAttribute("totalOrders", totalOrders);

		String homePage = "index.jsp";
		RequestDispatcher dispatcher = request.getRequestDispatcher(homePage);
		dispatcher.forward(request, response);
	}
}
