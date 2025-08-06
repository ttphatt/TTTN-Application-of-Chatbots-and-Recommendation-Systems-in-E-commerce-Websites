package com.store.Controller.Admin.ProductVariant;

import com.store.Service.ProductVariantService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serial;

@WebServlet("/admin/show_product_variant_form")
public class ShowProductVariantFormServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductVariantService productVariantService = new ProductVariantService(request, response);
        productVariantService.showProductVariantForm();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductVariantService productVariantService = new ProductVariantService(request, response);
        productVariantService.showProductVariantForm();
    }
}
