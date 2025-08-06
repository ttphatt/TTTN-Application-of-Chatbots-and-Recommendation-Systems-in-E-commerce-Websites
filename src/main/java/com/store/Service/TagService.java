package com.store.Service;

import com.store.DAO.TagDAO;
import com.store.Entity.Tag;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class TagService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final TagDAO tagDAO;

    public TagService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
        this.tagDAO = new TagDAO();
    }

    public void listAllTags() throws ServletException, IOException {
        List<Tag> tagList = tagDAO.listAll();

        request.setAttribute("tagList", tagList);

        String path = "tag_list.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void create() throws ServletException, IOException {
        String name = request.getParameter("name");

        Tag tag = new Tag();
        tag.setName(name);

        tagDAO.create(tag);

        listAllTags();
    }

    public void update() throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");

        Tag tag = new Tag();
        tag.setId(id);
        tag.setName(name);

        tagDAO.update(tag);

        listAllTags();
    }

    public void delete() throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        tagDAO.delete(id);

        listAllTags();
    }
}
