package com.store.Service;

import com.paypal.api.payments.*;
import com.paypal.base.rest.APIContext;
import com.paypal.base.rest.PayPalRESTException;
import com.store.DAO.*;
import com.store.Entity.*;
import com.store.Entity.Order;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

public class PaymentService {
    private static final String CLIENT_ID = "AZv2cYwNaqzx0au1TooXwNd_A9GpR1_0fzYovkVCIbMxdyMP7yA0z2iTsKgu5zeh3oVfClGnU4eJteDt";
    private static final String CLIENT_SECRET = "EJSZH7IUlO1TJdwLToG1MLl2OC8zn3jTqViYZQegL9HVSANsfFt_Z0DeZ8KhIUcLSszXaNk6iMFUT46o";
    private final String mode = "sandbox";

    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final CustomerDAO customerDAO;
    private final OrderPromotionDAO orderPromotionDAO;
    private final OrderDetailDAO orderDetailDAO;
    private final ProductVariantDAO productVariantDAO;
    private final ProductDAO productDAO;

    public PaymentService(HttpServletRequest request, HttpServletResponse response) {
        super();
        this.request = request;
        this.response = response;
        customerDAO = new CustomerDAO();
        orderPromotionDAO = new OrderPromotionDAO();
        orderDetailDAO = new OrderDetailDAO();
        productVariantDAO = new ProductVariantDAO();
        productDAO = new ProductDAO();
    }

    public void authorizePayment(Order order) throws ServletException, IOException {
        //Get Payer's information
        //Lấy các thông tin của người trả và set lên paypal:
        //Họ, tên và email
        Payer payer = getPayerInformation(order);

        //Redirect URLs
        //Set các đường link khi ở trang paypal:
        //Cancel -> Thì chuyển hướng về trang view_cart
        //Return -> Thì chuyển hướng về trang review_payment
        RedirectUrls redirectUrls = getRedirectUrls();

        List<Transaction> transactions = getTransactionInformation(order);

        //Request payment
        Payment requestPayment = new Payment();
        requestPayment.setPayer(payer)
                .setRedirectUrls(redirectUrls)
                .setIntent("authorize")
                .setTransactions(transactions);

        //Set chuỗi kết nối đến server paypal
        APIContext apiContext = new APIContext(CLIENT_ID, CLIENT_SECRET, mode);
        try {
            Payment authorizedPayment = requestPayment.create(apiContext);

            //Lấy ra đường link để chuyển hướng sang trang paypal để tiếp tục thanh toán
            String approvalURL = getApprovalURL(authorizedPayment);

            response.sendRedirect(approvalURL);

        } catch (PayPalRESTException e) {
            throw new ServletException("Error in authorizing payment.");
        }
    }

    private String getApprovalURL(Payment authorizedPayment) {
        String approvalURL = null;

        List<Links> links = authorizedPayment.getLinks();

        for(Links link : links) {
            if(link.getRel().equalsIgnoreCase("approval_url")) {
                approvalURL = link.getHref();
                break;
            }
        }
        return approvalURL;
    }

    private Payer getPayerInformation(Order order) {
        Payer payer = new Payer();
        payer.setPaymentMethod("Paypal");

        PayerInfo payerInfo = new PayerInfo();
        Customer customer = customerDAO.get(order.getCustomer().getId());
        payerInfo.setFirstName(customer.getFirstname());
        payerInfo.setLastName(customer.getLastname());
        payerInfo.setEmail(customer.getEmail());
        payer.setPayerInfo(payerInfo);

        return payer;
    }

    private RedirectUrls getRedirectUrls() {
        String requestURL = request.getRequestURL().toString();
        String requestURI = request.getRequestURI();
        String baseURL = requestURL.replace(requestURI, "").concat(request.getContextPath());

        RedirectUrls redirectUrls = new RedirectUrls();
        String cancelUrl = baseURL.concat("/view_cart");
        String returnUrl = baseURL.concat("/review_payment");

        redirectUrls.setCancelUrl(cancelUrl);
        redirectUrls.setReturnUrl(returnUrl);

        return redirectUrls;
    }

    private Amount getAmountDetails(Order order) {
        Details details = new Details();
        details.setShipping(String.format(Locale.US, "%.2f", order.getShippingFee()));
        details.setTax(String.format(Locale.US, "%.2f", order.getTax()));
        details.setSubtotal(String.format(Locale.US, "%.2f", order.getSubtotal()));

        List<OrderPromotion> orderPromotions = orderPromotionDAO.findWithOrderId(order.getId());
        if(!orderPromotions.isEmpty()) {
            BigDecimal totalDiscount = BigDecimal.ZERO;

            for (OrderPromotion orderPromotion : orderPromotions) {
                if (orderPromotion.getDiscountPrice() != null) {
                    totalDiscount = totalDiscount.add(orderPromotion.getDiscountPrice());
                }
            }
            details.setShippingDiscount(String.format(Locale.US, "%.2f", totalDiscount));
        }

        Amount amount = new Amount();
        amount.setCurrency("USD");
        amount.setDetails(details);
        amount.setTotal(String.format(Locale.US, "%.2f", order.getOrderSum()));

        return amount;
    }

    private	ShippingAddress getRecipientInformation(Order order) {
        ShippingAddress shippingAddress = new ShippingAddress();

        String recipientName = order.getFirstname() + " " + order.getLastname();
        shippingAddress.setRecipientName(recipientName)
                .setPhone(order.getPhone())
                .setLine1(order.getAddressLine1())
                .setLine2(order.getAddressLine2())
                .setCity(order.getCity())
                .setState(order.getState())
                .setCountryCode(order.getCountry())
                .setPostalCode(order.getZipcode());

        return shippingAddress;
    }

    private List<Transaction> getTransactionInformation(Order order) {
        Transaction transaction = new Transaction();
        transaction.setDescription("Product order");	//Thông tin mô tả của giao dịch trên pay pal

        //Set các thông tin liên quan đến: Tiền ship, thuế, tổng số tiền trước thuế và phí ship, đơn vị tiền tệ và tổng số tiền sau thuế và phí ship
        Amount amount = getAmountDetails(order);
        transaction.setAmount(amount);

        ItemList itemList = new ItemList();

        //Set các thông tin liên quan đến: Tên người nhận, số điện thoại người nhận, địa chỉ 1, địa chỉ 2, thành phố, bang, đất nước, mã ZIP
        ShippingAddress shippingAddress = getRecipientInformation(order);
        itemList.setShippingAddress(shippingAddress);


        List<Item> paypalItems = new ArrayList<>();
        Iterator<OrderDetail> iterator = orderDetailDAO.getOrderDetailByOrderId(order.getId()).iterator();

        List<Product> products = productDAO.listAll();
        Map<Integer, String> productIdToName = new HashMap<>();
        for (Product product : products) {
            productIdToName.put(product.getId(), product.getName());
        }

        List<ProductVariant> productVariants = productVariantDAO.listAll();
        Map<Integer, ProductVariant> variantMap = productVariants.stream()
                .collect(Collectors.toMap(
                        ProductVariant::getId,
                        pv -> pv
                ));


        //Duyệt để xử lý thông tin của từng sản pham trong đơn hàng
        while(iterator.hasNext()) {
            OrderDetail orderDetail = iterator.next();
            Integer quantity = orderDetail.getQuantity();
            ProductVariant tempProduct = variantMap.get(orderDetail.getProductVariant().getId());

            //Set các thông tin liên quan đến áo: Đơn vị tiền tệ, tên áo, số lượng và giá
            Item paypalItem = new Item();
            paypalItem.setCurrency("USD")
                    .setName(productIdToName.get(tempProduct.getProduct().getId()))
                    .setQuantity(String.valueOf(quantity))
                    .setPrice(String.format(Locale.US, "%.2f", tempProduct.getPrice()));

            paypalItems.add(paypalItem);
        }

        itemList.setItems(paypalItems);
        transaction.setItemList(itemList);

        List<Transaction> listTransaction = new ArrayList<>();
        listTransaction.add(transaction);

        return listTransaction;
    }

    //Trả về trang review_payment
    public void reviewPayment() throws ServletException {
        String paymentId = request.getParameter("paymentId");
        String payerId = request.getParameter("PayerID");

        if(paymentId == null || payerId == null) {
            throw new ServletException("Error in displaying payment");
        }

        //Connect to Paypal server
        APIContext apiContext = new APIContext(CLIENT_ID, CLIENT_SECRET, mode);

        try {
            //Lấy thông tin giao dịch thông payment id
            Payment payment = Payment.get(apiContext, paymentId);

            //Lấy các thông tin để hiển thị ra view
            PayerInfo payerInfo = payment.getPayer().getPayerInfo();
            Transaction transaction = payment.getTransactions().getFirst();
            ShippingAddress shippingAddress = transaction.getItemList().getShippingAddress();

            request.setAttribute("payer", payerInfo);
            request.setAttribute("transaction", transaction);
            request.setAttribute("recipient", shippingAddress);

            String reviewPage = "frontend/review_payment.jsp?paymentId=" + paymentId + "&PayerID=" + payerId;
            request.getRequestDispatcher(reviewPage).forward(request, response);

        } catch (PayPalRESTException | IOException e) {
            throw new ServletException("Error in getting payment details from Paypal");
        }
    }

    //Thực hiện giao dịch paypal
    public Payment executePayment() throws PayPalRESTException {
        String paymentId = request.getParameter("paymentId");
        String payerId = request.getParameter("PayerID");

        PaymentExecution paymentExecution = new PaymentExecution();
        paymentExecution.setPayerId(payerId);

        Payment payment = new Payment().setId(paymentId);

        APIContext apiContext = new APIContext(CLIENT_ID, CLIENT_SECRET, mode);

        return payment.execute(apiContext, paymentExecution);
    }
}
