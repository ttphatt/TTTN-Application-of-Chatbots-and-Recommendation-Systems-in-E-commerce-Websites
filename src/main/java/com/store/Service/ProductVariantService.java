package com.store.Service;

import Constant.Iconstant;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.store.DAO.AttributeDAO;
import com.store.DAO.ProductDAO;
import com.store.DAO.ProductVariantDAO;
import com.store.DAO.WarehouseDAO;
import com.store.DTO.AttributeDTO;
import com.store.DTO.ProductDTO;
import com.store.DTO.ProductVariantDTO;
import com.store.Entity.Attribute;
import com.store.Entity.Product;
import com.store.Entity.ProductVariant;
import com.store.Entity.Warehouse;
import com.store.Mapper.ProductMapper;
import com.store.Mapper.ProductVariantMapper;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class ProductVariantService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final ProductDAO productDAO;
    private final AttributeDAO attributeDAO;
    private final ProductVariantDAO productVariantDAO;
    private final WarehouseDAO warehouseDAO;

    public ProductVariantService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
        this.productDAO = new ProductDAO();
        this.attributeDAO = new AttributeDAO();
        this.productVariantDAO = new ProductVariantDAO();
        this.warehouseDAO = new WarehouseDAO();
    }

    public void listAllVariants() throws ServletException, IOException {
        List<ProductVariantDTO> productVariants = ProductVariantMapper.INSTANCE.toDTOList(productVariantDAO.listAll());

        request.setAttribute("productVariantList", productVariants);

        String path = "product_variant_list.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void showProductVariantForm() throws ServletException, IOException {
        List<Product> products = productDAO.listAll();
        List<ProductDTO> productList = ProductMapper.INSTANCE.getProductDTOWithIdAndNameList(products);
        request.setAttribute("productList", productList);

        Map<String, List<Attribute>> categorized = attributeDAO.categorizeAttributes();
        List<Attribute> colorList = categorized.getOrDefault("color", new ArrayList<>());
        List<Attribute> sizeList = categorized.getOrDefault("size", new ArrayList<>());
        List<Attribute> materialList = categorized.getOrDefault("material", new ArrayList<>());
        request.setAttribute("colorList", colorList);
        request.setAttribute("sizeList", sizeList);
        request.setAttribute("materialList", materialList);

        String productVariantId = request.getParameter("id");
        if (productVariantId != null) {
            ProductVariantDTO dto = ProductVariantMapper.INSTANCE.toDTO(productVariantDAO.get(Integer.parseInt(productVariantId)));

            dto.setColorName(
                    colorList.stream()
                            .filter(attr -> Objects.equals(attr.getId(), dto.getColorId()))
                            .map(Attribute::getValue)
                            .findFirst().orElse(null)
            );

            dto.setSizeName(
                    sizeList.stream()
                            .filter(attr -> Objects.equals(attr.getId(), dto.getSizeId()))
                            .map(Attribute::getValue)
                            .findFirst().orElse(null)
            );

            dto.setMaterialName(
                    materialList.stream()
                            .filter(attr -> Objects.equals(attr.getId(), dto.getMaterialId()))
                            .map(Attribute::getValue)
                            .findFirst().orElse(null)
            );

            request.setAttribute("variant", dto);
        }

        String path = "product_variant_form.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public ProductVariant readFields() throws ServletException, IOException {
        ProductVariant productVariant = new ProductVariant();

        String productVariantId = request.getParameter("productVariantId");
        Integer productId = Integer.valueOf(request.getParameter("productId"));
        Integer colorId = Integer.valueOf(request.getParameter("colorId"));
        Integer sizeId = Integer.valueOf(request.getParameter("sizeId"));
        Integer materialId = Integer.valueOf(request.getParameter("materialId"));
        BigDecimal price = BigDecimal.valueOf(Double.parseDouble(request.getParameter("price")));

        productVariant.setProduct(productDAO.getReference(productId));
        productVariant.setColor(attributeDAO.getReference(colorId));
        productVariant.setSize(attributeDAO.getReference(sizeId));
        productVariant.setMaterial(attributeDAO.getReference(materialId));
        productVariant.setPrice(price);

        String imageUrl = imageProcessing();
        if(!imageUrl.isEmpty()){
            productVariant.setImage(imageUrl);
        }

        if (productVariantId != null && !productVariantId.equals("undefined")) {
            productVariant.setId(Integer.parseInt(productVariantId));
        }

        return productVariant;
    }

    public void process(boolean isCreate) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        ProductVariant productVariant = readFields();

        ProductVariant variantInDB = productVariantDAO.findByUniqueKey(productVariant.getProduct().getId(), productVariant.getColor().getId(), productVariant.getSize().getId(), productVariant.getMaterial().getId());

        if (variantInDB == null) {
            if (isCreate) {
                out.print("{\"valid\": " + true + "}");
                createVariant(productVariant);
            } else {
                out.print("{\"valid\": " + true + "}");
                updateVariant(productVariant);
            }
        } else {
            if (isCreate) {
                out.print("{\"valid\": " + false + "}");
            } else {
                if (variantInDB.getId().equals(productVariant.getId())) {
                    out.print("{\"valid\": " + true + "}");
                    updateVariant(productVariant);
                } else {
                    out.print("{\"valid\": " + false + "}");
                }
            }
        }

        out.flush();
        out.close();
    }

    public void createVariant(ProductVariant productVariant){
        productVariantDAO.create(productVariant);

        Warehouse warehouse = new Warehouse();
        warehouse.setQuantity(0);
        warehouse.setProductVariant(productVariantDAO.get(productVariant.getId()));
        warehouseDAO.create(warehouse);
    }

    public void updateVariant(ProductVariant productVariant) {
        productVariantDAO.update(productVariant);
    }

    public void deleteVariant() throws ServletException, IOException {
        String message = "Not allowed to delete variant from database because we need it for recommendation system";

        listAllVariants();
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

    private Integer tryParseInt(String value) {
        try {
            return (value != null && !value.isEmpty()) ? Integer.parseInt(value) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public void getImportOptions() throws IOException {
        Integer productId = tryParseInt(request.getParameter("productId"));
        Integer sizeId = tryParseInt(request.getParameter("sizeId"));
        Integer colorId = tryParseInt(request.getParameter("colorId"));
        Integer materialId = tryParseInt(request.getParameter("materialId"));

        List<ProductVariant> variants = productVariantDAO.findByFilters(productId, sizeId, colorId, materialId);

        Set<AttributeDTO> sizes = new HashSet<>();
        Set<AttributeDTO> colors = new HashSet<>();
        Set<AttributeDTO> materials = new HashSet<>();

        for (ProductVariant pv : variants) {
            if (pv.getSize() != null) {
                sizes.add(new AttributeDTO(pv.getSize().getId(), pv.getSize().getValue()));
            }
            if (pv.getColor() != null) {
                colors.add(new AttributeDTO(pv.getColor().getId(), pv.getColor().getValue()));
            }
            if (pv.getMaterial() != null) {
                materials.add(new AttributeDTO(pv.getMaterial().getId(), pv.getMaterial().getValue()));
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("sizes", sizes);
        result.put("colors", colors);
        result.put("materials", materials);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        ObjectMapper mapper = new ObjectMapper();
        mapper.writeValue(response.getWriter(), result);
    }
}
