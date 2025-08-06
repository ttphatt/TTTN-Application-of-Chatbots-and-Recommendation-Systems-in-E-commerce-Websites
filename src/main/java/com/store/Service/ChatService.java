package com.store.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.store.DAO.CustomerDAO;
import com.store.DAO.MessageDAO;
import com.store.DTO.CustomerDTO;
import com.store.Entity.Customer;
import com.store.Entity.Message;
import com.store.Mapper.CustomerMapper;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ChatService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final CustomerDAO customerDAO;
    private final MessageDAO messageDAO;

    public ChatService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
        this.customerDAO = new CustomerDAO();
        this.messageDAO = new MessageDAO();
    }

    public void chooseChat() throws IOException {
        List<Customer> list = customerDAO.listAll();

        List<CustomerDTO> customers = CustomerMapper.INSTANCE.getChatCustomerDTOList(list);

        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        new ObjectMapper().writeValue(response.getWriter(), customers);
    }

    public void loadChat() throws IOException {
        String user1 = request.getParameter("user1");
        String user2 = request.getParameter("user2");

        List<Message> messages = messageDAO.getMessageHistory(user1, user2);

        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        new ObjectMapper().writeValue(response.getWriter(), messages);
    }

    public void chat() throws ServletException, IOException {
        String receiver = request.getParameter("id");
        String username = "admin";

        List<Message> messages = messageDAO.getMessageHistory(username, receiver);
        request.setAttribute("messages", messages);
        request.setAttribute("receiver", receiver);
        request.setAttribute("username", username);
        request.getRequestDispatcher("/admin/chat.jsp").forward(request, response);
    }

    public void processChat() throws ServletException, IOException {
        Customer customer = (Customer) request.getSession().getAttribute("loggedCustomer");

        String receiver = "admin";
        String username = String.valueOf(customer.getId());

        List<Message> messages = new MessageDAO().getMessageHistory(username, receiver);
        request.setAttribute("messages", messages);
        request.setAttribute("receiver", receiver);
        request.setAttribute("username", username);
        request.getRequestDispatcher("/frontend/chat.jsp").forward(request, response);
    }
}
