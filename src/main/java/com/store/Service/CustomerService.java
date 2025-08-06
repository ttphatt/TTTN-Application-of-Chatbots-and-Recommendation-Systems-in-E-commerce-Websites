package com.store.Service;

import com.store.DAO.CustomerDAO;
import com.store.DTO.CustomerDTO;
import com.store.DTO.CustomerFacebookLogin;
import com.store.DTO.CustomerGoogleLogin;
import com.store.DTO.ShoppingCart;
import com.store.Entity.Customer;
import com.store.Mapper.CustomerMapper;
import org.apache.commons.lang3.RandomStringUtils;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class CustomerService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final CustomerDAO customerDAO;

    public CustomerService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
        this.customerDAO = new CustomerDAO();
    }

    public void listAllCustomers(String message) throws ServletException, IOException {
        List<CustomerDTO> listCustomer = CustomerMapper.INSTANCE.toDTO(customerDAO.listAll());

        if (message != null) {
            request.setAttribute("message", message);
        }

        request.setAttribute("listCustomer", listCustomer);

        String path = "customer_list.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void readField(Customer customer) throws UnsupportedEncodingException, ServletException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String gender = request.getParameter("gender");
        String birthdayStr = request.getParameter("birthday");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phone");
        String addressLine1 = request.getParameter("address1");
        String addressLine2 = request.getParameter("address2");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zip = request.getParameter("zip");
        String country = request.getParameter("country");

        Date birthday = null;

        if (birthdayStr != null && !birthdayStr.isEmpty()) {
            try {
                SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                birthday = df.parse(birthdayStr);
            } catch (ParseException e) {
                throw new ServletException("Invalid date format. Expected yyyy-MM-dd", e);
            }
        }

        if (email != null && !email.isEmpty()) {
            customer.setEmail(email);
        }

        customer.setFirstname(firstname);
        customer.setLastname(lastname);
        customer.setGender(gender);
        customer.setBirthday(birthday);

        if (password != null && !password.isEmpty()) {
            String passwordHash = new HashSha_256Service().hashWithSHA256(password);
            customer.setPasswordHash(passwordHash);
        }
        customer.setPhoneNumber(phoneNumber);
        customer.setAddressLine1(addressLine1);
        customer.setAddressLine2(addressLine2);
        customer.setCity(city);
        customer.setState(state);
        customer.setZipcode(zip);
        customer.setCountry(country);
    }

    public void createCustomer() throws ServletException, IOException {
        Customer customer = new Customer();
        readField(customer);
        customerDAO.create(customer);

        listAllCustomers(null);
    }

    public void preprocessBeforeCreate() throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");

        if(customerDAO.findByEmail(email) == null){
            out.print("{\"valid\": " + true + "}");
            createCustomer();
        }else{
            out.print("{\"valid\": " + false + "}");
        }

        out.flush();
        out.close();
    }

    public void preprocessBeforeUpdate() throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String email = request.getParameter("email");

        Customer customerByEmail = customerDAO.findByEmail(email);

        if (customerByEmail != null && customerByEmail.getId() != customerId) {
            out.print("{\"valid\": " + false + "}");
        } else {
            out.print("{\"valid\": " + true + "}");
            updateCustomer();
        }

        out.flush();
        out.close();
    }

    public void editCustomer() throws ServletException, IOException {
        CommonUtility.generateCountriesList(request);
        Integer customerId = Integer.parseInt(request.getParameter("id"));

        CustomerDTO customer = CustomerMapper.INSTANCE.toDTO(customerDAO.get(customerId));

        request.setAttribute("customer", customer);

        String path = "customer_form.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void updateCustomer() throws IOException, ServletException {
        Integer customerId = Integer.parseInt(request.getParameter("customerId"));
        Customer customer = customerDAO.get(customerId);
        readField(customer);
        customerDAO.update(customer);

        listAllCustomers(null);
    }

    public void deleteCustomer() throws ServletException, IOException {
        String message = "Not allow to delete customer because we need their data to create recommendation system.";
        listAllCustomers(message);
    }

    public void registerAsCustomer() throws IOException, ServletException {
        Customer customer = new Customer();
        readField(customer);
        customerDAO.create(customer);

        String message = "You have signed up successfully.";

        String path = "frontend/message.jsp";
        request.setAttribute("message", message);
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void completeRegistration() throws IOException, ServletException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        Customer customer = customerDAO.get(customerId);
        readField(customer);
        customerDAO.update(customer);

        request.getSession().setAttribute("loggedCustomer", customer);

        showCustomerProfile();
    }

    public void showLogin() throws ServletException, IOException {
        String loginPage = "frontend/login.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(loginPage);
        requestDispatcher.forward(request, response);
    }

    public void doLogin() throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String passwordHash = new HashSha_256Service().hashWithSHA256(password);

        Customer customer = customerDAO.checkLogin(email, passwordHash);

        if (customer != null) {
            request.getSession().setAttribute("loggedCustomer", customer);

            processCart(customer);
        } else {
            String message = "Login failed. Please check your email and password again";
            request.setAttribute("message", message);
            showLogin();
        }
    }

    public void newCustomer() throws ServletException, IOException {
        CommonUtility.generateCountriesList(request);

        String customerForm = "customer_form.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(customerForm);
        requestDispatcher.forward(request, response);
    }

    public void showCustomerProfile() throws ServletException, IOException {
        CommonUtility.generateCountriesList(request);
        String profilePath = "frontend/customer_profile.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(profilePath);
        requestDispatcher.forward(request, response);
    }

    public void updateCustomerProfile() throws ServletException, IOException {
        Customer customer = (Customer) request.getSession().getAttribute("loggedCustomer");
        readField(customer);
        customerDAO.update(customer);

        showCustomerProfile();
    }

    public String resetCustomerPassword(String email) {
        Customer existingCustomer = customerDAO.findByEmail(email);
        String randomPassword = RandomStringUtils.randomAlphanumeric(10);
        String passwordHash = new HashSha_256Service().hashWithSHA256(randomPassword);

        existingCustomer.setPasswordHash(passwordHash);
        customerDAO.update(existingCustomer);

        return randomPassword;
    }

    public void loginGoogle() {
        response.setContentType("text/html;charset=UTF-8");

        String code = request.getParameter("code");

        CustomerGoogleLogin gg = new CustomerGoogleLogin();
        try {
            String accessToken = gg.getToken(code);
            if (accessToken != null) {
                Customer customer = CustomerGoogleLogin.getUserInfo(accessToken);

                processOtherLogin(customer);
            }
        } catch (IOException | ServletException ignored) {

        }
    }

    public void loginFacebook() {
        String code = request.getParameter("code");
        CustomerFacebookLogin fb = new CustomerFacebookLogin();
        try {
            String accessToken = fb.getToken(code);
            if (accessToken != null) {
                Customer customer = CustomerFacebookLogin.getUserInfo(accessToken);

                processOtherLogin(customer);
            }
        } catch (IOException | ServletException ignored) {

        }
    }

    private void processOtherLogin(Customer customer) throws ServletException, IOException {
        Customer existingCustomer = customerDAO.findByEmail(customer.getEmail());
        if (existingCustomer == null) {
            // Nếu khách hàng chưa tồn tại, tạo mới
            customerDAO.create(customer);
            request.setAttribute("customer", customer);
            CommonUtility.generateCountriesList(request);
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("frontend/complete_registration.jsp");
            requestDispatcher.forward(request, response);
        } else {
            // Nếu khách hàng đã tồn tại, đăng nhập và hiển thị hồ sơ
            HttpSession session = request.getSession();
            session.setAttribute("loggedCustomer", existingCustomer);

            // Chép cart mới của khách hàng.
            processCart(existingCustomer);
        }
    }

    public void processCart(Customer customer) throws ServletException, IOException {
        ShoppingCart shoppingCart = (ShoppingCart) request.getSession().getAttribute("cart");

        if (shoppingCart == null || shoppingCart.getTotalItems() == 0) {
            CartService cartService = new CartService(request, response);

            cartService.handleCart(customer.getId(), "false");
        } else {
            request.setAttribute("customerId", customer.getId());
            request.getRequestDispatcher("frontend/confirmSaveCart.jsp").forward(request, response);
        }
    }

    public void showCustomerRegistrationForm() throws ServletException, IOException {
        CommonUtility.generateCountriesList(request);

        String path = "frontend/customer_registration.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void processLogin() throws ServletException, IOException {
        String code = request.getParameter("code");
        String state = request.getParameter("state");
        if(code != null && !code.isEmpty() && state != null && state.equals("provider=google")) {
            loginGoogle();
        }
        else if(code != null && !code.isEmpty() && state != null && state.equals("provider=facebook")) {
            loginFacebook();
        } else {
            showLogin();
        }
    }

    public void processResetPassword() throws ServletException, IOException {
        String recipient = request.getParameter("email");
        Customer existingCustomer = customerDAO.findByEmail(recipient);

        if (existingCustomer == null) {
            // Nếu khách hàng chưa tồn tại
            String path = "frontend/message.jsp";
            String message = "The account belonging to this email does not exist in this website";
            request.setAttribute("message", message);
            RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
            requestDispatcher.forward(request, response);
        } else {
            String subject = "Your Password Has Been Reset";
            String content = getContent(request, response, recipient);

            String message = "";

            try {
                MailServices.SendMail(recipient, subject, content);
                message = "Your password has been reset. Please check your e-mail.";
            } catch (Exception ex) {
                message = "There were an error: " + ex.getMessage();
            } finally {
                String path = "frontend/message.jsp";
                request.setAttribute("message", message);
                RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
                requestDispatcher.forward(request, response);
            }
        }
    }

    private static String getContent(HttpServletRequest request, HttpServletResponse response, String recipient) {
        CustomerService customerServices = new CustomerService(request, response);
        String newPassword = customerServices.resetCustomerPassword(recipient);
        return "PHK SHIRT" +
                " STORE\r\n"
                + "\r\n"
                + "Dear " + recipient + ",\r\n"
                + "\r\n"
                + "This is your new password: " + newPassword
                + "\r\n"
                + "For security reason, "
                + "you must change your password after logging in.";
    }

    public void checkDuplicateEmail() throws IOException {
        String customerEmail = request.getParameter("customerEmail");
        Customer customer = customerDAO.findByEmail(customerEmail);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if(customer != null) {
            out.print("{\"isDuplicated\": " + true + "}");
        }
        else{
            out.print("{\"isDuplicated\": " + false + "}");
        }

        out.flush();
        out.close();
    }

    public void showCustomerProfileFormEdit() throws ServletException, IOException {
        CommonUtility.generateCountriesList(request);
        String profilePath = "frontend/edit_profile.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(profilePath);
        requestDispatcher.forward(request, response);
    }

    public void processRegisterCustomer() throws IOException, ServletException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");

        if(customerDAO.findByEmail(email) == null){
            out.print("{\"valid\": " + true + "}");
            registerAsCustomer();
        }else{
            out.print("{\"valid\": " + false + "}");
        }

        out.flush();
        out.close();
    }
}
