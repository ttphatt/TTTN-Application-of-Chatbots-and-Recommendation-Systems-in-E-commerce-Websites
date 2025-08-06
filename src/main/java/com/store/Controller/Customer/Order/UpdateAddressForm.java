package com.store.Controller.Customer.Order;

import com.store.Entity.Customer;
import com.store.Service.OrderService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serial;

@WebServlet("/updateAddress")
public class UpdateAddressForm extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        OrderService orderService = new OrderService(request, response);
        Customer customer = orderService.getAddressForm();
        orderService.showCheckOutForm(customer);
    }
}
