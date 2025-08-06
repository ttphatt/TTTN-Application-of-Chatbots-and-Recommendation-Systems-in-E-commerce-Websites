package com.store.Service;

import Constant.Iconstant;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.store.DAO.CategoryDAO;
import com.store.DAO.ProductDAO;
import com.store.DAO.ProductTagDAO;
import com.store.DAO.TagDAO;
import com.store.DTO.CategoryDTO;
import com.store.DTO.ProductDTO;
import com.store.Entity.Product;
import com.store.Entity.ProductTag;
import com.store.Entity.Tag;
import com.store.Mapper.CategoryMapper;
import com.store.Mapper.ProductMapper;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

public class ProductService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final ProductDAO productDAO;
    private final TagDAO tagDAO;
    private final ProductTagDAO productTagDAO;
    private final CategoryDAO categoryDAO;

    public ProductService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
        productDAO = new ProductDAO();
        tagDAO = new TagDAO();
        productTagDAO = new ProductTagDAO();
        categoryDAO = new CategoryDAO();
    }

    public void listAllProducts(String message) throws ServletException, IOException {
        List<Product> products = productDAO.listAll();
        List<Tag> tags = tagDAO.listAll();
        List<ProductTag> productTags = productTagDAO.listAll();

        Map<Integer, List<Tag>> productIdToTags = new HashMap<>();
        Map<Integer, Tag> tagMap = tags.stream().collect(Collectors.toMap(Tag::getId, tag -> tag));

        for (ProductTag pt : productTags) {
            Tag tag = tagMap.get(pt.getTagId());
            if (tag != null) {
                productIdToTags
                        .computeIfAbsent(pt.getProductId(), k -> new ArrayList<>())
                        .add(tag);
            }
        }

        List<ProductDTO> productDTOs = ProductMapper.INSTANCE.toDTO(products);
        for (ProductDTO dto : productDTOs) {
            List<Tag> tagList = productIdToTags.getOrDefault(dto.getId(), new ArrayList<>());
            dto.setTags(tagList);
        }

        request.setAttribute("listProducts", productDTOs);

        if(message != null) {
            request.setAttribute("message", message);
        }

        String path = "product_list.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void showProductForm() throws ServletException, IOException {
        List<CategoryDTO> categories = CategoryMapper.INSTANCE.toDTOList(categoryDAO.listAll());
        request.setAttribute("listCategories", categories);

        List<Tag> tags = tagDAO.listAll();
        request.setAttribute("listTags", tags);

        String productId = request.getParameter("id");
        if (productId != null) {
            Product product = productDAO.get(Integer.parseInt(productId));
            ProductDTO productDTO = ProductMapper.INSTANCE.toDTO(product);
            CategoryDTO categoryDTO = CategoryMapper.INSTANCE.toDTO(categoryDAO.get(product.getCategory().getId()));
            productDTO.setCategory(categoryDTO);

            request.setAttribute("product", productDTO);

            List<Integer> selectedTagIds = productTagDAO.getTagIdsByProductId(Integer.parseInt(productId));
            request.setAttribute("selectedTagIds", selectedTagIds);
        }

        String path = "product_form.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void createProduct() throws ServletException, IOException {
        Product product = readFields();

        Product createdProduct = productDAO.create(product);

        createTags(createdProduct.getId());

        listAllProducts(null);
    }

    public void updateProduct() throws ServletException, IOException {
        Product product = readFields();

        productDAO.update(product);

        productTagDAO.deleteByProductId(product.getId());
        createTags(product.getId());

        listAllProducts(null);
    }

    public void createTags(int productId){
        String[] tagIds = request.getParameterValues("tagIds");

        if (tagIds != null) {
            for (String tagIdStr : tagIds) {
                int tagId = Integer.parseInt(tagIdStr);

                ProductTag pt = new ProductTag();
                pt.setProductId(productId);
                pt.setTagId(tagId);

                productTagDAO.create(pt);
            }
        }
    }

    public void deleteProduct() throws ServletException, IOException {
        String message = "Not allowed to delete product. This is because we need data for recommendation system";

        listAllProducts(message);
    }

    public Product readFields() throws ServletException, IOException {
        String id = request.getParameter("productId");
        Integer categoryId = Integer.parseInt(request.getParameter("category"));
        String name = request.getParameter("name");
        String brand = request.getParameter("brand");
        String description = request.getParameter("description");
        BigDecimal price = BigDecimal.valueOf(Double.parseDouble(request.getParameter("price")));

        DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateStr = request.getParameter("releasedDate");
        Date releasedDate;

        if (dateStr == null || dateStr.isEmpty()) {
            releasedDate = new Date();
        } else {
            try {
                SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm:ss");
                String currentTime = timeFormatter.format(new Date());

                dateStr += " " + currentTime;

                releasedDate = df.parse(dateStr);
            }
            catch(ParseException ex) {
                throw new ServletException("Error parsing released date (format is: yyyy-MM-dd");
            }
        }

        Product product = new Product();
        product.setName(name);
        product.setBrand(brand);
        product.setDescription(description);
        product.setCategory(categoryDAO.getReference(categoryId));
        product.setReleasedDate(releasedDate);
        product.setPrice(price);

        String imageUrl = imageProcessing();
        if(!imageUrl.isEmpty()){
            product.setImage(imageUrl);
        }

        if (id != null && !id.equals("undefined")) {
            product.setId(Integer.parseInt(id));
        }

        return product;
    }

    public void getAllProduct() throws IOException {
        List<ProductDTO> result = ProductMapper.INSTANCE.getProductDTOWithIdAndNameList(productDAO.listAll());

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        ObjectMapper mapper = new ObjectMapper();
        mapper.writeValue(response.getWriter(), result);
    }

    public String imageProcessing() throws ServletException, IOException {
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + Iconstant.UPLOAD_DIRECTORY;

        File uploadDir = new File(uploadFilePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        Part part = request.getPart("image");

        if (part == null || part.getSize() == 0 || part.getSubmittedFileName() == null || part.getSubmittedFileName().isEmpty()) {
            // Lấy ảnh cũ từ form
            String oldImage = request.getParameter("oldImage");
            return oldImage != null ? oldImage : "";
        }

        String fileName = fileNameProcessing(part);
        if (fileName.isEmpty()) {
            return "";
        }

        File file = new File(uploadFilePath, fileName);
        Files.copy(part.getInputStream(), file.toPath(), StandardCopyOption.REPLACE_EXISTING);
        part.write(uploadFilePath + File.separator + fileName);

        return request.getContextPath() + "/" + Iconstant.UPLOAD_DIRECTORY + "/" + fileName;
    }

    public String fileNameProcessing(Part part) {
        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd-MM-yyyy-HH-mm-ss");
        String formattedDate = dateTimeFormatter.format(LocalDateTime.now());

        if (!getFileName(part).isEmpty()) {
            return formattedDate + "-" + getFileName(part);
        }

        return "";
    }

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");

        for(String token : tokens){
            if(token.trim().startsWith("filename")){
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    public void listProductByCategory() throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("id"));

        List<ProductDTO> products = ProductMapper.INSTANCE.toDTO(productDAO.listByCategoryId(categoryId));

        CategoryDTO category = CategoryMapper.INSTANCE.toDTO(categoryDAO.get(categoryId));

        request.setAttribute("productList", products);
        request.setAttribute("category", category);

        String path = "frontend/products_list_by_category.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void viewProductDetail() throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("id"));

        ProductDTO product = ProductMapper.INSTANCE.toDTO(productDAO.get(productId));

        request.setAttribute("product", product);

        String path = "frontend/product_detail.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }
}
