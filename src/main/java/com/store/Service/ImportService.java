package com.store.Service;

import com.google.gson.Gson;
import com.store.DAO.*;
import com.store.DTO.ImportDTO;
import com.store.DTO.ImportDetailDTO;

import com.store.Entity.*;
import com.store.Mapper.ImportMapper;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;


public class ImportService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final ImportDAO importDAO;
    private final UserDAO userDAO;
    private final ProductVariantDAO productVariantDAO;
    private final ImportDetailDAO importDetailDAO;
    private final WarehouseDAO warehouseDAO;
    private final ImportPriceDAO importPriceDAO;

    public ImportService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
        this.importDAO = new ImportDAO();
        this.userDAO = new UserDAO();
        this.productVariantDAO = new ProductVariantDAO();
        this.importDetailDAO = new ImportDetailDAO();
        this.warehouseDAO = new WarehouseDAO();
        this.importPriceDAO = new ImportPriceDAO();
    }

    public void listAllImport() throws ServletException, IOException {
        List<ImportDTO> imports = ImportMapper.INSTANCE.toDTOList(importDAO.listAll());

        request.setAttribute("importList", imports);

        String path = "import_list.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void showImportForm() throws ServletException, IOException {
        String path = "import_form.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void createImport() throws IOException {
        String importId = request.getParameter("importId");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if(importDAO.get(importId) == null){
            out.print("{\"valid\": " + true + "}");
        }else{
            out.print("{\"valid\": " + false + "}");
            return;
        }

        float totalPrice = Float.parseFloat(request.getParameter("totalPriceField"));
        String dateStr = request.getParameter("createdDate");

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        Date createdDate;

        if (dateStr == null || dateStr.isEmpty()) {
            createdDate = new Date();
        } else {
            try {
                SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm:ss");
                String currentTime = timeFormatter.format(new Date());

                dateStr += " " + currentTime;

                createdDate = formatter.parse(dateStr);
            } catch (ParseException e) {
                createdDate = new Date();
            }
        }

        Integer userId = (Integer) request.getSession().getAttribute("userId");

        Import newImport = new Import();
        newImport.setId(importId);
        newImport.setUser(userDAO.getReference(userId));
        newImport.setDate(createdDate);
        newImport.setTotalPrice(BigDecimal.valueOf(totalPrice));
        importDAO.create(newImport);

        String productData = request.getParameter("productData");

        Gson gson = new Gson();
        ImportDetailDTO[] importDetailDTOs = gson.fromJson(productData, ImportDetailDTO[].class);

        for (ImportDetailDTO importDetailDTO : importDetailDTOs) {
            Integer productVariantId = productVariantDAO.getIdByUniqueKey(importDetailDTO.getProductVariant().getProductId(), importDetailDTO.getProductVariant().getColorId(), importDetailDTO.getProductVariant().getSizeId(), importDetailDTO.getProductVariant().getMaterialId());

            ImportDetail importDetail = new ImportDetail();
            importDetail.setImportRecord(importDAO.getReference(importId));
            importDetail.setProductVariant(productVariantDAO.getReference(productVariantId));
            importDetail.setPrice(importDetailDTO.getPrice());
            importDetail.setQuantity(importDetailDTO.getQuantity());

            importDetailDAO.createWithMerge(importDetail);
            warehouseDAO.updateQuantityByProductVariantId(productVariantId, importDetail.getQuantity());

            ImportPrice importPrice = new ImportPrice();
            importPrice.setProductVariantId(productVariantId);
            importPrice.setQuantity(importDetail.getQuantity());
            importPrice.setPrice(importDetail.getPrice());
            importPrice.setTime(createdDate);
            importPriceDAO.create(importPrice);
        }

        out.flush();
        out.close();
    }
}
