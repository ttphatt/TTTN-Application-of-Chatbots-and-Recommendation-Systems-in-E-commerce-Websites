package com.store.Controller.Api;

import com.store.Service.OrderService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serial;

@WebServlet("/api/order_shipping_check")
public class CheckStockBeforeShippingServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        OrderService orderService = new OrderService(request, response);

        Integer orderId = Integer.parseInt(request.getParameter("orderId"));

        boolean hasEnough = orderService.processBeforeShipping(orderId);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        if (hasEnough) {
            out.print("{\"success\": true}");
        } else {
            out.print("{\"success\": false, \"message\": \"Not Enough Stock.\"}");
        }
        out.flush();
    }
}
