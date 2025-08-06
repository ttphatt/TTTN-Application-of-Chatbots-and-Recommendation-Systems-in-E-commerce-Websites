package com.store.Service;

import com.store.DAO.ProductDAO;
import com.store.DAO.WarehouseDAO;
import com.store.DTO.ProductDTO;
import com.store.DTO.WarehouseDTO;
import com.store.DTO.WarehouseSummary;
import com.store.Mapper.ProductMapper;
import com.store.Mapper.WarehouseMapper;
import com.store.Mapper.WarehouseMapperUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class WarehouseService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final WarehouseDAO warehouseDAO;
    private final ProductDAO productDAO;

    public WarehouseService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
        warehouseDAO = new WarehouseDAO();
        productDAO = new ProductDAO();
    }

    public void listAllWarehouses() throws ServletException, IOException {
        List<WarehouseSummary> summaryList = WarehouseMapperUtil.toSummaryList(warehouseDAO.listAll());

        request.setAttribute("warehouseList", summaryList);

        String path = "warehouse_list.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void viewDetailWarehouse() throws ServletException, IOException {
        Integer productId = Integer.valueOf(request.getParameter("id"));
        List<WarehouseDTO> warehouses = WarehouseMapper.INSTANCE.toDTOList(warehouseDAO.findByProductId(productId));
        ProductDTO product = ProductMapper.INSTANCE.getProductDTOWithIdAndName(productDAO.get(productId));

        request.setAttribute("product", product);
        request.setAttribute("warehouseList", warehouses);

        String path = "warehouse_detail.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }
}
