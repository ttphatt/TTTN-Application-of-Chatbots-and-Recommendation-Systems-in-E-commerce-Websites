package com.store.Service;

import com.store.DAO.*;
import com.store.DTO.*;
import com.store.Entity.*;
import com.store.Mapper.OrderDetailMapper;
import com.store.Mapper.OrderMapper;
import com.store.Mapper.OrderPromotionMapper;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.CompletableFuture;

public class OrderService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final OrderDAO orderDAO;
    private final OrderPromotionDAO orderPromotionDAO;
    private final OrderDetailDAO orderDetailDAO;
    private final PromotionDAO promotionDAO;
    private final ProductVariantDAO productVariantDAO;
    private final WarehouseDAO warehouseDAO;

    public OrderService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
        this.orderDAO = new OrderDAO();
        this.orderPromotionDAO = new OrderPromotionDAO();
        this.orderDetailDAO = new OrderDetailDAO();
        this.promotionDAO = new PromotionDAO();
        this.productVariantDAO = new ProductVariantDAO();
        this.warehouseDAO = new WarehouseDAO();
    }

    // ------------------------------------------------ Admin ------------------------------------------------

    public void listAllOrders(String message) throws ServletException, IOException {
        List<OrderDTO> orderList = OrderMapper.INSTANCE.toDTOList(orderDAO.listAll());
        List<OrderPromotion> orderPromotions = orderPromotionDAO.listAll();

        Map<Integer, BigDecimal> totalDiscountMap = new HashMap<>();
        if (orderPromotions != null && !orderPromotions.isEmpty()) {
            for (OrderPromotion op : orderPromotions) {
                totalDiscountMap.merge(
                        op.getOrderId(),
                        op.getDiscountPrice(),
                        BigDecimal::add
                );
            }
        }

        for (OrderDTO dto : orderList) {
            BigDecimal totalDiscount = totalDiscountMap.getOrDefault(dto.getId(), BigDecimal.ZERO);
            dto.setTotalDiscount(totalDiscount);
        }

        if(message != null) {
            request.setAttribute("message", message);
        }

        request.setAttribute("orderList", orderList);

        String path = "order_list.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void showEditOrderForm() throws ServletException, IOException {
        Integer orderId = Integer.parseInt(request.getParameter("orderId"));

        OrderDTO order = OrderMapper.INSTANCE.toDTO(orderDAO.get(orderId));
        List<OrderDetailDTO> oderDetailList = OrderDetailMapper.INSTANCE.toDTOList(orderDetailDAO.getOrderDetailByOrderId(orderId));
        List<OrderPromotionDTO> orderPromotions = OrderPromotionMapper.INSTANCE.toDTOList(orderPromotionDAO.findWithOrderId(orderId));

        request.setAttribute("order", order);
        request.setAttribute("orderDetailList", oderDetailList);
        request.setAttribute("orderPromotions", orderPromotions);

        String path = "order_form.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void changeOrderStatus(String status, String path, String message) throws ServletException, IOException {
        Integer orderId = Integer.parseInt(request.getParameter("orderId"));
        Order order = orderDAO.get(orderId);

        order.setStatus(Order.Status.valueOf(status));
        orderDAO.update(order);

        request.setAttribute("message", message);
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void changeOrderStatusAdmin(String status, String message) throws ServletException, IOException {
        String path = "message.jsp";
        changeOrderStatus(status, path, message);
    }

    public Boolean processBeforeShipping(Integer orderId) {
        List<OrderDetail> orderDetails = orderDetailDAO.getOrderDetailByOrderId(orderId);

        List<Integer> variantIds = new ArrayList<>();
        for (OrderDetail orderDetail : orderDetails) {
            variantIds.add(orderDetail.getProductVariant().getId());
        }

        List<Warehouse> warehouses = warehouseDAO.findByVariantIds(variantIds);
        for (Warehouse warehouse : warehouses) {
            if (warehouse.getQuantity() < 0) return false;
        }

        return true;
    }

    public void shippingOrder() throws ServletException, IOException {
        String message = "The order with id: " + Integer.parseInt(request.getParameter("orderId")) + " has been set to shipping status successfully";
        changeOrderStatusAdmin("Shipping", message);
    }

    public void deliveredOrder() throws ServletException, IOException {
        String message = "The order with id: " + Integer.parseInt(request.getParameter("orderId")) + " has been set to delivered status successfully";
        changeOrderStatusAdmin("Delivered", message);
    }

    public void completedOrder() throws ServletException, IOException {
        Integer orderId = Integer.parseInt(request.getParameter("orderId"));
        String message = "The order with id: " + orderId + " has been set to completed status successfully";
        new ProfitService().processProfit(orderId);
        updateQuantityForWarehouse();
        changeOrderStatusAdmin("Completed", message);
    }

    public void returnedOrder() throws ServletException, IOException {
        String message = "The order with id: " + Integer.parseInt(request.getParameter("orderId")) + " has been set to completed status successfully";
        updateQuantityForWarehouse();
        changeOrderStatusAdmin("Returned", message);
    }

    public void updateQuantityForWarehouse() {
        Integer orderId = Integer.parseInt(request.getParameter("orderId"));

        List<OrderDetail> orderDetails = orderDetailDAO.getOrderDetailByOrderId(orderId);

        for (OrderDetail orderDetail : orderDetails) {
            warehouseDAO.updateQuantityByProductVariantId(orderDetail.getProductVariant().getId(), orderDetail.getQuantity());
        }
    }

    // ------------------------------------------------ Customer ------------------------------------------------

    public void listOrderByCustomer() throws ServletException, IOException {
        Customer customer = (Customer) request.getSession().getAttribute("loggedCustomer");

        List<OrderDTO> orders = OrderMapper.INSTANCE.toDTOList(orderDAO.findByCustomer(customer.getId()));
        request.setAttribute("orderList", orders);

        String path = "frontend/order_list.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void showOrderDetailForCustomer() throws ServletException, IOException {
        Integer orderId = Integer.parseInt(request.getParameter("orderId"));

        OrderDTO order = OrderMapper.INSTANCE.toDTO(orderDAO.get(orderId));
        List<OrderDetailDTO> orderDetails = OrderDetailMapper.INSTANCE.toDTOList(orderDetailDAO.getOrderDetailByOrderId(orderId));
        List<OrderPromotionDTO> orderPromotions = OrderPromotionMapper.INSTANCE.toDTOList(orderPromotionDAO.findWithOrderId(orderId));

        request.setAttribute("order", order);
        request.setAttribute("orderDetailList", orderDetails);
        request.setAttribute("orderPromotions", orderPromotions);
        CommonUtility.generateCountriesList(request);

        String path = "frontend/order_detail.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void showCheckOutForm(Customer customer) throws ServletException, IOException {
        String startAddress = "11, Duong Nguyen Dinh Chieu, Thanh Pho Ho Chi Minh, Viet Nam";
        String endAddress = customer.getAddressLine1() + ", " + customer.getState() + ", " + customer.getCountry();

        CompletableFuture<BigDecimal> shippingFuture = CompletableFuture.supplyAsync(() -> new DistanceService().calculateShippingFee(startAddress, endAddress));

        HttpSession session = request.getSession();
        ShoppingCart shoppingCart = (ShoppingCart) session.getAttribute("cart");

        Map<String, String> orderPromotions = promotionDAO.findPromotionDisplayed("order_discount");
        Map<String, String> shippingPromotions = promotionDAO.findPromotionDisplayed("shipping_discount");
        request.setAttribute("orderPromotions", orderPromotions);
        request.setAttribute("shippingPromotions", shippingPromotions);

        // Tax = Subtotal * 10%
        BigDecimal tax = shoppingCart.getTotalAmount().divide(new BigDecimal(10));

        BigDecimal shippingFee;
        try {
            shippingFee = shippingFuture.get();
        } catch (Exception e) {
            shippingFee = new BigDecimal("30.00");
        }

        BigDecimal totalPrice = shoppingCart.getTotalAmount().add(tax).add(shippingFee);

        request.setAttribute("customer", customer);

        session.setAttribute("orderDiscount", null);
        session.setAttribute("orderPromotionId", null);
        session.setAttribute("shippingDiscount", null);
        session.setAttribute("shippingPromotionId", null);

        session.setAttribute("tax", tax);
        session.setAttribute("shippingFee", shippingFee);
        session.setAttribute("totalPrice", totalPrice);

        CommonUtility.generateCountriesList(request);
        request.getRequestDispatcher("frontend/checkout.jsp").forward(request, response);
    }

    public void updateOrderCustomer() throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Integer orderId = Integer.parseInt(request.getParameter("orderId"));
        Order order = orderDAO.get(orderId);

        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String phone = request.getParameter("phone");

        order.setFirstname(firstname);
        order.setLastname(lastname);
        order.setPhone(phone);

        orderDAO.update(order);

        String message = "Your order has been updated successfully";
        String path = "frontend/message.jsp";

        request.setAttribute("message", message);
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void placeOrder() throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        Order order = readFields();

        if (order.getPayment().equals(Order.Payment.PAYPAL)) {
// Không có tài khoản để test, và cũng không chắc là có ổn định để chạy hay không.
//            PaymentService paymentService = new PaymentService(request, response);
//            request.getSession().setAttribute("order4Paypal", order);
//            paymentService.authorizePayment(order);
        } else {
            placeOrderCOD(order);
        }
    }

    public Order readFields() {
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String phoneNumber = request.getParameter("phoneNumber");
        String addressLine1 = request.getParameter("addressLine1");
        String addressLine2 = request.getParameter("addressLine2");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zip = request.getParameter("zip");
        String country = request.getParameter("country");
        String payment = request.getParameter("payment");

        HttpSession session = request.getSession();
        BigDecimal tax = (BigDecimal) session.getAttribute("tax");
        BigDecimal shippingFee = (BigDecimal) session.getAttribute("shippingFee");

        BigDecimal total = (BigDecimal) session.getAttribute("totalPrice");

        ShoppingCart shoppingCart = (ShoppingCart) session.getAttribute("cart");
        Customer customer = (Customer) request.getSession().getAttribute("loggedCustomer");

        Order order = new Order();
        order.setCustomer(customer);
        order.setFirstname(firstname);
        order.setLastname(lastname);
        order.setPhone(phoneNumber);
        order.setAddressLine1(addressLine1);
        order.setAddressLine2(addressLine2);
        order.setCity(city);
        order.setState(state);
        order.setCountry(country);
        order.setZipcode(zip);
        order.setPayment(Order.Payment.valueOf(payment));
        order.setTax(tax);
        order.setShippingFee(shippingFee);
        order.setOrderSum(total);
        order.setSubtotal(shoppingCart.getTotalAmount());

        return order;
    }

    private void placeOrderCOD(Order order) throws ServletException, IOException {
        int orderID = saveOrder(order);
        sendEmailToCustomer(orderID);
        String message = "Thank you for choosing our products. Your order has been received. Your shirts will arrive within a few days.";
        request.setAttribute("message", message);

        String path = "frontend/message.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    private Integer saveOrder(Order order) {
        Order savedOrder = orderDAO.create(order);
        ShoppingCart shoppingCart = (ShoppingCart) request.getSession().getAttribute("cart");

        createOrderDetail(savedOrder, shoppingCart);
        createOrderPromotion(savedOrder);

        shoppingCart.deleteCart(order.getCustomer().getId());
        shoppingCart.clearCart();

        return savedOrder.getId();
    }

    private void createOrderDetail(Order order, ShoppingCart shoppingCart) {
        for (CartDTO cart : shoppingCart.getCarts()) {
            OrderDetail newOrderDetail = new OrderDetail();
            newOrderDetail.setOrder(orderDAO.getReference(order.getId()));
            newOrderDetail.setQuantity(cart.getQuantity());
            newOrderDetail.setSubTotal(cart.getProductVariant().getPrice().multiply(new BigDecimal(cart.getQuantity())));
            newOrderDetail.setProductVariant(productVariantDAO.getReference(cart.getProductVariant().getId()));

            orderDetailDAO.createWithMerge(newOrderDetail);
            warehouseDAO.updateQuantityByProductVariantId(cart.getProductVariant().getId(), -cart.getQuantity());
        }
    }

    private void createOrderPromotion(Order order) {
        String orderPromotionId = (String) request.getSession().getAttribute("orderPromotionId");
        String shippingPromotionId = (String) request.getSession().getAttribute("shippingPromotionId");

        BigDecimal discountPrice;

        if(orderPromotionId != null) {
            OrderPromotion orderPromotion = new OrderPromotion();

            orderPromotion.setOrderId(order.getId());
            orderPromotion.setPromotion(promotionDAO.getReference(orderPromotionId));
            discountPrice = (BigDecimal) request.getSession().getAttribute("orderDiscount");
            orderPromotion.setDiscountPrice(discountPrice);

            orderPromotionDAO.createWithMerge(orderPromotion);
        }

        if(shippingPromotionId != null){
            OrderPromotion orderPromotion = new OrderPromotion();

            orderPromotion.setOrderId(order.getId());
            orderPromotion.setPromotion(promotionDAO.getReference(shippingPromotionId));
            discountPrice = (BigDecimal) request.getSession().getAttribute("shippingDiscount");
            orderPromotion.setDiscountPrice(discountPrice);

            orderPromotionDAO.createWithMerge(orderPromotion);
        }

    }

    private void sendEmailToCustomer(int orderId){
        //lấy email hiện tại ra
        HttpSession session = request.getSession();
        Customer loggedCustomer = (Customer) session.getAttribute("loggedCustomer");
        String email = loggedCustomer.getEmail();
        String name = loggedCustomer.getFirstname();
        String title = "Order Confirmation from PHK SHIRT STORE";
        String body = formEmail(name, orderId);
        //gửi mail
        MailServices.SendMail(email,title,body);
    }

    public String formEmail(String name, int orderId) {
        return "PHK SHIRT" +
                " STORE\r\n"
                + "\r\n"
                + "Order Confirmation and Thank You\r\n"
                + "\r\n"
                + "Dear " + name + ",\r\n"
                + "\r\n"
                + "Thank you for placing an order with PHK SHIRT STORE. We are excited to process your order and ensure you receive your items as soon as possible.\r\n"
                + "\r\n"
                + "Order Details:\r\n"
                + "\r\n"
                + "Order Number: " + orderId + "\r\n"
                + "Order Date: " + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss")) + "\r\n"
                + "We appreciate your trust in us and strive to deliver the highest quality products and services. Your satisfaction is our top priority.\r\n"
                + "\r\n"
                + "Next Steps:\r\n"
                + "\r\n"
                + "You will receive a notification once your order is shipped, including tracking information.\r\n"
                + "If you have any special instructions or need to make changes to your order, please contact us promptly.\r\n"
                + "Customer Support:\r\n"
                + "If you have any questions or require further assistance, our customer service team is here to help. You can reach us at phkshirtstore@gmail.com or call us at 0123456789.\r\n"
                + "\r\n"
                + "Thank you once again for your purchase. We look forward to serving you and hope you enjoy your new items!\r\n"
                + "\r\n"
                + "Best regards,\r\n"
                + "\r\n"
                + "PHK SHIRT STORE\r\n"
                + "\r\n";
    }

    public Customer getAddressForm() {
        Customer customer = new Customer();
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String phoneNumber = request.getParameter("phoneNumber");
        String addressLine1 = request.getParameter("addressLine1");
        String addressLine2 = request.getParameter("addressLine2");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zip = request.getParameter("zip");
        String country = request.getParameter("country");

        customer.setFirstname(firstname);
        customer.setLastname(lastname);
        customer.setPhoneNumber(phoneNumber);
        customer.setAddressLine1(addressLine1);
        customer.setAddressLine2(addressLine2);
        customer.setCity(city);
        customer.setState(state);
        customer.setZipcode(zip);
        customer.setCountry(country);

        return customer;
    }

    public void cancelOrder() throws ServletException, IOException {
        String message = "Your order has been cancelled successfully";
        changeOrderStatusCustomer("Cancelled", message);
    }

    public void returnOrder() throws ServletException, IOException {
        String message = "Your order has been returned successfully";
        changeOrderStatusCustomer("Returned", message);
    }

    public void completeOrder() throws ServletException, IOException {
        Integer orderId = Integer.parseInt(request.getParameter("orderId"));
        String message = "Your order has been set to completed status successfully";
        new ProfitService().processProfit(orderId);
        changeOrderStatusCustomer("Completed", message);
    }

    public void changeOrderStatusCustomer(String status, String message) throws ServletException, IOException {
        String path = "frontend/message.jsp";
        changeOrderStatus(status, path, message);
    }
}
