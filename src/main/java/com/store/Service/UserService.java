package com.store.Service;

import com.store.DAO.UserDAO;
import com.store.DTO.UserDTO;
import com.store.Entity.User;
import com.store.Mapper.UserMapper;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class UserService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final UserDAO userDAO;

    public UserService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
        this.userDAO = new UserDAO();
    }

    public void listAllUser(String message) throws ServletException, IOException {
        List<UserDTO> listUsers = UserMapper.INSTANCE.toDTOList(userDAO.listAll());

        request.setAttribute("listUsers", listUsers);

        request.setAttribute("message", message);

        String path = "user_list.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void createUser() {
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullname");
        String password = request.getParameter("password");

        String passwordHash = new HashSha_256Service().hashWithSHA256(password);

        User user = new User(email, passwordHash, fullName, User.Role.staff);

        userDAO.create(user);
    }

    public void preprocessBeforeCreate() throws IOException {
        String email = request.getParameter("email");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if(checkDuplicateEmail(email) == null){
            out.print("{\"valid\": " + true + "}");
            createUser();
        }
        else{
            out.print("{\"valid\": " + false + "}");
        }
        out.flush();
        out.close();
    }

    public void editUser() throws ServletException, IOException {
        Integer userId = Integer.parseInt(request.getParameter("id"));

        UserDTO user = UserMapper.INSTANCE.toDTO(userDAO.get(userId));

        String path = "user_form.jsp";

        //Đẩy thông tin của user qua view
        request.setAttribute("user", user);

        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void updateUser() throws IOException {
        Integer userId = Integer.parseInt(request.getParameter("userId"));
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullname");
        String password = request.getParameter("password");

        String passwordHash;

        User userById = userDAO.get(userId);
        if(password != null && !password.isEmpty()){
            passwordHash = new HashSha_256Service().hashWithSHA256(password);
        }else{
            passwordHash = userById.getPasswordHash();
        }
        User userByEmail = userDAO.findByEmail(email);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        //Kiểm tra xem email có tồn tại và thuộc quyền sở hữu của user khác không
        //Cũng là kiểm tra trường hợp user edit email mà email này đã có user khác sử dụng
        if(userByEmail != null && !userByEmail.getId().equals(userById.getId())) {
            out.print("{\"valid\": " + false + "}");
        }
        else {
            //Tạo 1 object user mới để lưu dữ liệu vừa edit
            User user = new User(userId, email, passwordHash, fullName, userById.getRole());

            //Đẩy object xuống Model để thêm vào database
            userDAO.update(user);
            out.print("{\"valid\": " + true + "}");
        }
    }

    public void deleteUser() throws ServletException, IOException {
        Integer userId = Integer.parseInt(request.getParameter("id"));

        //Xóa user trong database dựa theo id
        userDAO.delete(userId);

        String message = "User has been deleted successfully";
        listAllUser(message);
    }

    public void doLogin() throws ServletException, IOException {
        //Lấy ra các thông tin: user và password từ view
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String passwordHash = new HashSha_256Service().hashWithSHA256(password);
        //Thực hiện kiểm tra xem user này có tài khoản trong database hay chưa
        //Cũng là để kiểm tra tài khoản và mật khẩu khi đăng nhập vào trang admin
        boolean loginRes = userDAO.checkLogin(email, passwordHash);

        //Đăng nhập vào trang admin thành công
        if(loginRes) {
            //Tạo 1 object user từ việc tìm user theo email
            User user = userDAO.findByEmail(email);

            request.getSession().setAttribute("userFullName", user.getFullName());

            request.getSession().setAttribute("userRole", user.getRole().name());

            request.getSession().setAttribute("userEmail", email);

            request.getSession().setAttribute("userId", user.getId());

            RequestDispatcher requestDispatcher = request.getRequestDispatcher("/admin/");
            requestDispatcher.forward(request, response);
        }

        //Đăng nhập vào trang admin không thành công
        else {
            String message = "Login failed, please check your email and password again";
            request.setAttribute("message", message);
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("login.jsp");
            requestDispatcher.forward(request, response);

        }
    }

    public User checkDuplicateEmail(String email) {
        return userDAO.findByEmail(email);
    }
}
