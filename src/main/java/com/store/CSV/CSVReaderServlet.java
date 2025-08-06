package com.store.CSV;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@WebServlet("/csvdata")
public class CSVReaderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");

        Map<String, String> messageMap = CSVReaderUtility.loadCSVData();
        String id = request.getParameter("id");
        PrintWriter out = response.getWriter();

        if(id != null && messageMap.containsKey(id)){
            out.println("{\"id\": \"" + id + "\", \"message\": \"" + messageMap.get(id) + "\"}");
        }
        else{
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.println("{\"error\": \"Message not found\"}");
        }
    }
}
