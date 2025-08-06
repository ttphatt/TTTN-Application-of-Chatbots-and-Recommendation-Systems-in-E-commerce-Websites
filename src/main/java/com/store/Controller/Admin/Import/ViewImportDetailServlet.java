package com.store.Controller.Admin.Import;

import com.store.Service.ImportDetailService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serial;

@WebServlet("/admin/import_detail")
public class ViewImportDetailServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ImportDetailService importDetailService = new ImportDetailService(request, response);
        importDetailService.getInfoImportDetail();
    }
}
