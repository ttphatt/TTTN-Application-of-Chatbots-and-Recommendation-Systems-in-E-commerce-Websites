package com.store.Service;

import com.store.DAO.AttributeDAO;
import com.store.Entity.Attribute;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class AttributeService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final AttributeDAO attributeDAO;

    public AttributeService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
        this.attributeDAO = new AttributeDAO();
    }

    public void listAllAttributes() throws ServletException, IOException {
        Map<String, List<Attribute>> categorized = attributeDAO.categorizeAttributes();

        List<Attribute> colorList = categorized.getOrDefault("color", new ArrayList<>());
        List<Attribute> sizeList = categorized.getOrDefault("size", new ArrayList<>());
        List<Attribute> materialList = categorized.getOrDefault("material", new ArrayList<>());

        request.setAttribute("colorList", colorList);
        request.setAttribute("sizeList", sizeList);
        request.setAttribute("materialList", materialList);

        String path = "attribute_list.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void create() throws ServletException, IOException {
        Attribute attribute = readField();
        attributeDAO.create(attribute);

        listAllAttributes();
    }

    public Attribute readField() {
        Attribute attribute = new Attribute();
        String type = request.getParameter("type");
        String value = request.getParameter("value");

        attribute.setType(Attribute.AttributeType.valueOf(type.toLowerCase()));
        attribute.setValue(value);

        return attribute;
    }

    public void update() throws ServletException, IOException {
        // Need Notification can not update when type and value exist.

        Attribute attribute = readField();
        Integer id = Integer.valueOf(request.getParameter("id"));
        attribute.setId(id);

        if (!attributeDAO.isExistAttribute(attribute.getType(), attribute.getValue())) {
            attributeDAO.update(attribute);
        }

        listAllAttributes();
    }

    public void delete() throws ServletException, IOException {
        // Need Notification can not delete when attribute used.
        Integer id = Integer.parseInt(request.getParameter("id"));

        if (!attributeDAO.isAttributeUsed(id)) {
            attributeDAO.delete(id);
        }

        listAllAttributes();
    }
}
