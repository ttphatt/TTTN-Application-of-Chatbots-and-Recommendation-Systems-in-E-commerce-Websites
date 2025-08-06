package com.store.Controller.Admin.Attribute;

import com.store.Service.AttributeService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serial;

@WebServlet("/admin/list_attributes")
public class ListAttributeServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        AttributeService attributeService = new AttributeService(request, response);
        attributeService.listAllAttributes();
    }
}
