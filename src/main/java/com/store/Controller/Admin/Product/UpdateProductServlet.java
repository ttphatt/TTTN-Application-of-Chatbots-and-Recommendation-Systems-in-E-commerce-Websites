package com.store.Controller.Admin.Product;

import com.store.Service.ProductService;

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
@WebServlet("/admin/product_update")
public class UpdateProductServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductService productService = new ProductService(request, response);
        productService.updateProduct();
    }
}
