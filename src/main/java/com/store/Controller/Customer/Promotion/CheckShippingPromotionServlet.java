package com.store.Controller.Customer.Promotion;

import com.store.Service.PromotionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serial;
import java.text.ParseException;

@WebServlet("/check_shipping_promotion")
public class CheckShippingPromotionServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PromotionService promotionServices = new PromotionService(request, response);
        try {
            promotionServices.checkPromotion("shipping_discount");
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PromotionService promotionServices = new PromotionService(request, response);
        try {
            promotionServices.checkPromotion2("shipping_discount");
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }
}
