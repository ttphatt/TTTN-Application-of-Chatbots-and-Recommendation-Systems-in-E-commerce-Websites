package com.store.Controller.Customer.Promotion;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serial;
import java.math.BigDecimal;

@WebServlet("/update_order_sum_after_promotion")
public class UpdateOrderSumAfterPromotionServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String updateTotalPriceStr = request.getParameter("updateTotalPrice");
        BigDecimal updateTotalPrice = new BigDecimal(updateTotalPriceStr);
        request.getSession().setAttribute("totalPrice", updateTotalPrice);
    }
}
