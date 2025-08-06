package com.store.Controller.Admin.Warehouse;

import com.store.Service.WarehouseService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serial;

@WebServlet("/admin/list_warehouses")
public class ListWarehouseServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        WarehouseService warehouseService = new WarehouseService(request, response);
        warehouseService.listAllWarehouses();
    }
}
