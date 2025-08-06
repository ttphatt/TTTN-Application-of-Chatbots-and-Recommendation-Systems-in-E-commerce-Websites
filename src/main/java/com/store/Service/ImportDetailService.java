package com.store.Service;

import com.store.DAO.ImportDAO;
import com.store.DAO.ImportDetailDAO;
import com.store.DTO.ImportDTO;
import com.store.DTO.ImportDetailDTO;
import com.store.Mapper.ImportDetailMapper;
import com.store.Mapper.ImportMapper;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ImportDetailService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final ImportDetailDAO importDetailDAO;
    private final ImportDAO importDAO;

    public ImportDetailService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
        this.importDetailDAO = new ImportDetailDAO();
        this.importDAO = new ImportDAO();
    }

    public void getInfoImportDetail() throws ServletException, IOException {
        String importId = request.getParameter("id");

        List<ImportDetailDTO> importDetails = ImportDetailMapper.INSTANCE.toDTOList(importDetailDAO.findByImportId(importId));

        ImportDTO importInfo = ImportMapper.INSTANCE.toDTO(importDAO.get(importId));

        request.setAttribute("importDetailList", importDetails);
        request.setAttribute("importInfo", importInfo);

        String path = "import_detail.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }
}
