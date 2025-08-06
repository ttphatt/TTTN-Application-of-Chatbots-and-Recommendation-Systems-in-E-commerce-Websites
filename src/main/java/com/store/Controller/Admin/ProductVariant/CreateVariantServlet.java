package com.store.Controller.Admin.ProductVariant;

import com.store.Service.ProductVariantService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serial;

@MultipartConfig(
        fileSizeThreshold = 1024 * 10,	//10 KB
        maxFileSize = 1024 * 300,		//300 KB
        maxRequestSize = 1024 * 1024 	//1 MB
)
@WebServlet("/admin/product_variant_create")
public class CreateVariantServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductVariantService productVariantService = new ProductVariantService(request, response);
        productVariantService.process(true);
    }
}
