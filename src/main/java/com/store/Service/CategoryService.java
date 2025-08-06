package com.store.Service;

import com.google.gson.Gson;
import com.store.DAO.CategoryDAO;
import com.store.DAO.ProductDAO;
import com.store.DTO.CategoryDTO;
import com.store.Entity.Category;
import com.store.Mapper.CategoryMapper;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Objects;

public class CategoryService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final CategoryDAO categoryDAO;
    private final ProductDAO productDAO;

    public CategoryService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
        this.categoryDAO = new CategoryDAO();
        this.productDAO = new ProductDAO();
    }

    public void listAllCategory(String message) throws ServletException, IOException {
        List<CategoryDTO> categories = CategoryMapper.INSTANCE.toDTOList(categoryDAO.listAll());

        request.setAttribute("listCategory", categories);

        if (message != null) {
            request.setAttribute("message", message);
        }

        String path = "category_list.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void loadParentCategory() throws ServletException, IOException {
        List<CategoryDTO> parentList = CategoryMapper.INSTANCE.toDTOList(categoryDAO.listAll());

        request.setAttribute("parentList", parentList);

        String path = "category_form.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void createCategory() {
        String name = request.getParameter("categoryName");
        String parentIdStr = request.getParameter("parentId");

        Integer parentId = (parentIdStr != null && !parentIdStr.isEmpty()) ? Integer.parseInt(parentIdStr) : null;

        Category category = new Category(name, categoryDAO.getReference(parentId));
        categoryDAO.create(category);
    }

    public void editCategory() throws ServletException, IOException {
        Integer categoryId = Integer.parseInt(request.getParameter("id"));

        CategoryDTO category = CategoryMapper.INSTANCE.toDTO(categoryDAO.get(categoryId));

        List<CategoryDTO> parentList = CategoryMapper.INSTANCE.toDTOList(categoryDAO.listAll());

        request.setAttribute("category", category);
        request.setAttribute("parentList", parentList);

        String path = "category_form.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void updateCategory() throws IOException {
        Integer categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String parentIdStr = request.getParameter("parentId");
        String categoryName = request.getParameter("categoryName");

        Integer parentId = (parentIdStr != null && !parentIdStr.isEmpty()) ? Integer.parseInt(parentIdStr) : null;

        Category categoryById = categoryDAO.get(categoryId);

        Category categoryByName = categoryDAO.findByName(categoryName);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if(categoryByName != null && !Objects.equals(categoryById.getId(), categoryByName.getId())) {
            out.print("{\"valid\": " + false + "}");
        }
        else {
            categoryById.setName(categoryName);
            categoryById.setParent(categoryDAO.getReference(parentId));

            categoryDAO.update(categoryById);
            out.print("{\"valid\": " + true + "}");
        }
    }

    public void deleteCategory() throws ServletException, IOException {
        Integer categoryId = Integer.parseInt(request.getParameter("id"));

        long numberOfProducts = productDAO.countByCategory(categoryId);
        long numberOfChildren = categoryDAO.countChildrenByParentId(categoryId);
        String message;

        if (numberOfProducts > 0 || numberOfChildren > 0) {
            message = "Could not delete category with id: " + categoryId + " there are some products or categories belong to this category";
        } else {
            categoryDAO.delete(categoryId);
            message = "The category with id: " + categoryId + " has been deleted successfully";
        }

        listAllCategory(message);
    }

    public Category checkDuplicateCategory(String name) {
        return categoryDAO.findByName(name);
    }

    public void getSubCategory() throws IOException {
        String parentIdStr = request.getParameter("parentId");
        int parentId = parentIdStr == null ? 0 : Integer.parseInt(parentIdStr);

        List<CategoryDTO> subCategories = CategoryMapper.INSTANCE.toDTOList(categoryDAO.findByParentId(parentId));

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Convert list to JSON
        Gson gson = new Gson();
        String json = gson.toJson(subCategories);
        response.getWriter().write(json);
    }
}
