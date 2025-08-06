package com.store.Service;

import com.store.CSV.CSVReaderUtility;
import com.store.DAO.*;
import com.store.DTO.RateDTO;
import com.store.Entity.*;
import com.store.Mapper.RateMapper;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;

public class RateService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final RateDAO rateDAO;
    private final ProductDAO productDAO;
    private final CustomerDAO customerDAO;

    public RateService(HttpServletRequest request, HttpServletResponse response) {
        this.response = response;
        this.request = request;
        this.rateDAO = new RateDAO();
        this.productDAO = new ProductDAO();
        this.customerDAO = new CustomerDAO();
    }

    public void listAllRate(String message) throws ServletException, IOException {
        List<RateDTO> listRate = RateMapper.INSTANCE.toDTOList(rateDAO.listAll());

        request.setAttribute("rateList", listRate);

        if(message != null) {
            request.setAttribute("message", message);
        }

        String path = "rate_list.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void editRate() throws ServletException, IOException {
        Integer rateId = Integer.parseInt(request.getParameter("id"));

        RateDTO rate = RateMapper.INSTANCE.toDTO(rateDAO.get(rateId));
        Customer customer = customerDAO.get(rate.getCustomerId());
        Product product = productDAO.get(rate.getProductId());

        rate.setCustomerName(customer.getFirstname() + " " + customer.getLastname());
        rate.setProductName(product.getName());
        request.setAttribute("rate", rate);

        String path = "rate_form.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void updateRate() throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        int rateId = Integer.parseInt(request.getParameter("rateId"));
        String headline = request.getParameter("headline");
        String ratingDetail = request.getParameter("detail");

        Rate rate = rateDAO.get(rateId);
        rate.setHeadline(headline);
        rate.setDetail(ratingDetail);

        rateDAO.update(rate);

        String message = "The rate has been updated successfully";
        listAllRate(message);
    }

    public void updateRateCustomer() throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        Integer rateId = Integer.parseInt(request.getParameter("rateId"));
        String headline = request.getParameter("headline");
        String ratingDetail = request.getParameter("ratingDetail");

        Rate rate = rateDAO.get(rateId);
        rate.setHeadline(headline);
        rate.setDetail(ratingDetail);
        rate.setTime(new Date());
        rateDAO.update(rate);

        String message = "The rate has been updated successfully";
        String path = "frontend/rate_done.jsp";

        request.setAttribute("message", message);

        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void deleteRate() throws ServletException, IOException {
        Integer rateId = Integer.parseInt(request.getParameter("id"));

        rateDAO.delete(rateId);

        String message = "The rate has been deleted successfully";

        listAllRate(message);
    }

    public void deleteRateCustomer() throws ServletException, IOException {
        Integer rateId = Integer.parseInt(request.getParameter(("id")));
        rateDAO.delete(rateId);

        String message = "Your rate has been deleted successfully";
        String path = "frontend/rate_done.jsp";

        request.setAttribute("message", message);
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void showRateForm() throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer productId = Integer.parseInt(request.getParameter("productId"));
        Customer customer = (Customer) session.getAttribute("loggedCustomer");

        long completedOrder = customerDAO.checkCompletedOrder(customer.getId(), productId);
        String path;

        if(completedOrder == 0){
            String message = CSVReaderUtility.loadCSVData().get("NO_ORDER_COMPLETED");
            path = "frontend/message.jsp";
            request.setAttribute("message", message);
        }
        else {
            Product product = productDAO.get(productId);

            session.setAttribute("product", product);

            Rate existRate = rateDAO.findByCustomerAndProduct(customer.getId(), productId);
            path = "frontend/rate_form.jsp";

            if(existRate != null) {
                request.setAttribute("rate", existRate);
                path = "frontend/rate_info.jsp";
            }
        }
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void submitRate() throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        Integer productId = Integer.parseInt(request.getParameter("productId"));
        Float rating = Float.valueOf(request.getParameter("rating"));
        String headline = request.getParameter("headline");
        String ratingDetail = request.getParameter("ratingDetail");

        Rate rate = new Rate();
        rate.setHeadline(headline);
        rate.setDetail(ratingDetail);
        rate.setStars(rating);

        rate.setProduct(productDAO.getReference(productId));

        Customer customer = (Customer) request.getSession().getAttribute("loggedCustomer");
        rate.setCustomer(customerDAO.getReference(customer.getId()));

        rateDAO.create(rate);

        String message = CSVReaderUtility.loadCSVData().get("THANK_YOU_RATE");
        String path = "frontend/rate_done.jsp";

        request.setAttribute("message", message);
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }
}
