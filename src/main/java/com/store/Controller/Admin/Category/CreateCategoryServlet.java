package com.store.Controller.Admin.Category;

import com.store.Service.CategoryService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serial;

@WebServlet("/admin/create_category")
public class CreateCategoryServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CategoryService categoryService = new CategoryService(request, response);

        String categoryName = request.getParameter("categoryName");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if(categoryService.checkDuplicateCategory(categoryName) == null){
            out.print("{\"valid\": " + true + "}");
            categoryService.createCategory();
        }
        else{
            out.print("{\"valid\": " + false + "}");
        }

        out.flush();
        out.close();
    }
}
