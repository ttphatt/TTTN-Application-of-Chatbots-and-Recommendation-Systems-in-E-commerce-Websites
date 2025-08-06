package com.store.Controller.Admin.User;


import com.store.Service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serial;

@WebServlet("/admin/checkDuplicateUserEmail")
public class CheckDuplicateUserEmail extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserService userServices = new UserService(request, response);

        String email = request.getParameter("email");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if(userServices.checkDuplicateEmail(email) == null){
            out.print("{\"valid\": " + true + "}");
        }
        else{
            out.print("{\"valid\": " + false + "}");
        }

        out.flush();
        out.close();
    }
}
