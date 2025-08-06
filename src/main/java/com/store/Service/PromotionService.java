package com.store.Service;

import com.store.CSV.CSVReaderUtility;
import com.store.DAO.PromotionDAO;
import com.store.DTO.PromotionDTO;
import com.store.Entity.Promotion;
import com.store.Mapper.PromotionMapper;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class PromotionService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final PromotionDAO promotionDAO;

    private static final String orderPromotionId = "orderPromotionId";
    private static final String shippingPromotionId = "shippingPromotionId";
    private static final String orderPromotionTypeName = "order_discount";
    private static final String shippingPromotionTypeName = "shipping_discount";

    public PromotionService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
        promotionDAO = new PromotionDAO();
    }

    public void listAllPromotion(String message) throws ServletException, IOException {
        List<PromotionDTO> listPromotion = PromotionMapper.INSTANCE.toDTOList(promotionDAO.listAll());
        List<Long> listUsedPromotion = promotionDAO.countUsedAllPromotion();

        for (int i = 0; i < listUsedPromotion.size(); i++) {
            listPromotion.get(i).setUsedPromotion(listUsedPromotion.get(i));
        }

        request.setAttribute("promotionList", listPromotion);

        if(message != null) {
            request.setAttribute("message", message);
        }

        String path = "/admin/promotion_list.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    private Promotion readFields() throws ServletException {
        Promotion promotion = new Promotion();

        String promotionId = request.getParameter("promotionId");
        String description = request.getParameter("description");
        String promotionType = request.getParameter("type");
        String status = request.getParameter("status");

        BigDecimal maxDiscount;
        BigDecimal priceLimit;
        BigDecimal percent;
        int quantityInStock;

        try {
            maxDiscount = new BigDecimal(request.getParameter("maxDiscount"));
            priceLimit = new BigDecimal(request.getParameter("priceLimit"));
            percent = new BigDecimal(request.getParameter("percent"));
            quantityInStock = Integer.parseInt(request.getParameter("quantityInStock"));
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid number format in one of the numeric fields", e);
        }


        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate;
        Date endDate;
        String startDateString = request.getParameter("startDate");
        String endDateString = request.getParameter("endDate");

        try {
            startDate = df.parse(startDateString);
        } catch(ParseException ex) {
            throw new ServletException("Error parsing released date (format is: yyyy-MM-dd");
        }

        try {
            endDate = df.parse(endDateString);
        } catch(ParseException ex) {
            throw new ServletException("Error parsing released date (format is: yyyy-MM-dd");
        }
        //set fields
        promotion.setId(promotionId);
        promotion.setDescription(description);
        promotion.setStartDate(startDate);
        promotion.setEndDate(endDate);
        promotion.setPercent(percent);
        promotion.setMaxDiscount(maxDiscount);
        promotion.setPriceLimit(priceLimit);
        promotion.setQuantityInStock(quantityInStock);
        promotion.setType(Promotion.PromotionType.valueOf(promotionType));
        promotion.setStatus(Promotion.PromotionStatus.valueOf(status));

        return promotion;
    }

    public void showPromotionForm() throws ServletException, IOException {
        String promotionId = request.getParameter("promotionId");

        if (promotionId != null) {
            request.getSession().setAttribute("isUpdate",true);

            PromotionDTO promotion = PromotionMapper.INSTANCE.toDTO(promotionDAO.get(promotionId));

            request.setAttribute("promotion", promotion);
        }

        String path = "promotion_form.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void createPromotion() throws ServletException, IOException {
        Promotion newPromotion = readFields();
        promotionDAO.create(newPromotion);

        listAllPromotion(null);
    }

    public void updatePromotion() throws ServletException, IOException {
        String promotionId = request.getParameter("promotionId");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        int quantity_in_stock = Integer.parseInt(request.getParameter("quantityInStock"));

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate;
        Date endDate;
        String startDateString = request.getParameter("startDate");
        String endDateString = request.getParameter("endDate");

        try {
            startDate = df.parse(startDateString);
        } catch(ParseException ex) {
            throw new ServletException("Error parsing released date (format is: yyyy-MM-dd");
        }

        try {
            endDate = df.parse(endDateString);
        } catch(ParseException ex) {
            throw new ServletException("Error parsing released date (format is: yyyy-MM-dd");
        }

        Promotion existedPromotion = promotionDAO.get(promotionId);
        long usedPromotion = promotionDAO.countUsedPromotion(promotionId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if(quantity_in_stock < usedPromotion ) {
            out.print("{\"valid\": " + false + "}");
        }else{
            existedPromotion.setDescription(description);
            existedPromotion.setStartDate(startDate);
            existedPromotion.setEndDate(endDate);
            existedPromotion.setStatus(Promotion.PromotionStatus.valueOf(status));
            existedPromotion.setQuantityInStock(quantity_in_stock);
            out.print("{\"valid\": " + true + "}");
            promotionDAO.update(existedPromotion);
        }
    }

    public boolean checkExistPromotion(Promotion promotion, String promotionType){
        return promotion != null && promotion.getType().equals(Promotion.PromotionType.valueOf(promotionType));
    }

    public boolean checkValidDate(Promotion promotion){
        Date current_date = new Date();

        return !current_date.before(promotion.getStartDate()) && !current_date.after(promotion.getEndDate());
    }

    public boolean checkPriceLimit(Promotion promotion) {
        BigDecimal subTotal = new BigDecimal(request.getParameter("subTotal"));
        BigDecimal priceLimit = promotion.getPriceLimit();

        // Trả về true nếu subTotal >= priceLimit
        return subTotal.compareTo(priceLimit) >= 0;
    }

    public boolean checkQuantityInStock(Promotion promotion) {
        long usedPromotion = promotionDAO.countUsedPromotion(promotion.getId());
        return usedPromotion < promotion.getQuantityInStock();
    }

    public boolean checkStatus(Promotion promotion) {
        return promotion.getStatus().equals(Promotion.PromotionStatus.valueOf("active"));
    }

    public int checkValid(Promotion promotion, String promotionType){
        if(!checkExistPromotion(promotion, promotionType)) return 1;
        if(!checkValidDate(promotion))   return 2;
        if(!checkPriceLimit(promotion))   return 3;
        if(!checkQuantityInStock(promotion))   return 4;
        if(!checkStatus(promotion))   return 5;

        return 0;
    }

    public String checkValidation(int validation){
        return switch (validation) {
            case 1 -> CSVReaderUtility.loadCSVData().get("INVALID_PROMOTION_ID");
            case 2 -> CSVReaderUtility.loadCSVData().get("INVALID_PROMOTION_DATE");
            case 3 -> CSVReaderUtility.loadCSVData().get("INVALID_PROMOTION_PRICE_LIMIT");
            case 4 -> CSVReaderUtility.loadCSVData().get("INVALID_PROMOTION_QUANTITY");
            case 5 -> CSVReaderUtility.loadCSVData().get("INVALID_PROMOTION_STATUS");
            case 0 -> null;
            default -> "";
        };
    }

    public BigDecimal getPriceDiscount(Promotion promotion) {
        BigDecimal percent = promotion.getPercent().divide(BigDecimal.valueOf(100));
        BigDecimal priceDiscount;
        BigDecimal maxDiscount = promotion.getMaxDiscount();

        if (promotion.getType().equals(Promotion.PromotionType.order_discount)) {
            BigDecimal subTotal = new BigDecimal(request.getParameter("subTotal"));
            priceDiscount = subTotal.multiply(percent);
        } else {
            BigDecimal shippingFee = (BigDecimal) request.getSession().getAttribute("shippingFee");
            priceDiscount = shippingFee.multiply(percent);
        }

        if (priceDiscount.compareTo(maxDiscount) > 0) {
            priceDiscount = maxDiscount;
        }

        return priceDiscount;
    }

    public BigDecimal getPriceDiscount2(Promotion promotion) {
        BigDecimal percent = promotion.getPercent().divide(BigDecimal.valueOf(100));
        BigDecimal priceDiscount;
        BigDecimal maxDiscount = promotion.getMaxDiscount();

        if (promotion.getType().equals(Promotion.PromotionType.valueOf(orderPromotionTypeName))) {
            BigDecimal subTotal = new BigDecimal(request.getParameter("subTotal"));
            priceDiscount = subTotal.multiply(percent);
        } else {
            BigDecimal shippingFee = (BigDecimal) request.getSession().getAttribute("shippingFee");
            priceDiscount = shippingFee.multiply(percent);
        }

        if (priceDiscount.compareTo(maxDiscount) > 0) {
            priceDiscount = maxDiscount;
        }

        return priceDiscount;
    }

    public void promotionProcessing(Promotion promotion, String promotionIdName) {
        BigDecimal priceDiscount = getPriceDiscount(promotion);

        BigDecimal totalPrice = new BigDecimal(request.getParameter("totalPrice"));
        BigDecimal newTotalPrice = totalPrice.subtract(priceDiscount);

        if (promotion.getType().equals(Promotion.PromotionType.order_discount)) {
            request.getSession().setAttribute("priceDiscount", priceDiscount);
        } else {
            request.getSession().setAttribute("shippingDiscount", priceDiscount);
        }

        request.getSession().setAttribute("totalPrice", newTotalPrice);
        request.getSession().setAttribute(promotionIdName, promotion.getId());
    }

    public List<Object> promotionProcessing2(Promotion promotion, String promotionIdName) {
        BigDecimal priceDiscount = getPriceDiscount2(promotion);

        // Ép kiểu đúng: từ Object sang BigDecimal
        Object totalObj = request.getSession().getAttribute("totalPrice");
        BigDecimal totalPrice = (totalObj instanceof BigDecimal)
                ? (BigDecimal) totalObj
                : new BigDecimal(String.valueOf(totalObj));

        BigDecimal newTotalPrice = totalPrice.subtract(priceDiscount);

        List<Object> res = new ArrayList<>();

        if (promotion.getType().equals(Promotion.PromotionType.valueOf(orderPromotionTypeName))) {
            res.add(orderPromotionTypeName);
            request.getSession().setAttribute("orderDiscount", priceDiscount);
        } else {
            res.add(shippingPromotionTypeName);
            request.getSession().setAttribute("shippingDiscount", priceDiscount);
        }

        request.getSession().setAttribute(promotionIdName, promotion.getId());

        request.getSession().setAttribute("totalPrice", newTotalPrice);

        res.add(priceDiscount);
        res.add(promotion.getId());
        res.add(newTotalPrice);

        return res;
    }

    public void redirectToCheckoutPage(String messageName, String message) throws ServletException, IOException {
        CommonUtility.generateCountriesList(request);
        String path = "frontend/checkout.jsp";

        if(message != null) request.setAttribute(messageName, message);

        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void responseToCheckOutPage(boolean isPromotionValid, String message, List<Object> promoInfo) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        if(isPromotionValid) {
            out.print("{\"valid\": " + true + ", \"newTotalPrice\": " + promoInfo.get(3) + ", \"discountPrice\": " + promoInfo.get(1) + "}");
        }
        else{
            out.print("{\"valid\": " + false + ", \"message\": \"" + message + "\"}");
        }

        out.flush();
        out.close();
    }

    public Promotion getPromotionFromView(String promotionIdName) {
        String promotionId = request.getParameter(promotionIdName);

        return promotionDAO.get(promotionId);
    }

    public void checkOrderPromotion(String promotionType) throws IOException, ServletException {
        String promotionIdName = "promotionId";
        Promotion promotion = getPromotionFromView(promotionIdName);
        int validation = checkValid(promotion, promotionType);
        String message = checkValidation(validation);

        if(message == null) promotionProcessing(promotion, promotionIdName);
        redirectToCheckoutPage("message_order_promotion", message);
    }

    public void checkOrderPromotion2() throws IOException {
        Promotion promotion = getPromotionFromView(orderPromotionId);
        int validation = checkValid(promotion, orderPromotionTypeName);
        String message = checkValidation(validation);

        if(message == null){
            List<Object> promoInfo = promotionProcessing2(promotion, orderPromotionId);
            responseToCheckOutPage(true, null, promoInfo);
        }
        else{
            responseToCheckOutPage(false, message, null);
        }
    }

    public void checkShippingPromotion(String promotionType) throws IOException, ServletException {
        String promotionIdName = "shippingPromotionId";
        Promotion promotion = getPromotionFromView(promotionIdName);
        int validation = checkValid(promotion, promotionType);
        String message = checkValidation(validation);

        if(message == null) promotionProcessing(promotion, promotionIdName);
        redirectToCheckoutPage("message_shipping_promotion", message);
    }

    public void checkShippingPromotion2() throws IOException {
        Promotion promotion = getPromotionFromView(shippingPromotionId);
        int validation = checkValid(promotion, shippingPromotionTypeName);
        String message = checkValidation(validation);

        if(message == null){
            List<Object> promoInfo = promotionProcessing2(promotion, shippingPromotionId);
            responseToCheckOutPage(true, null, promoInfo);
        }
        else{
            responseToCheckOutPage(false, message, null);
        }
    }

    public void checkPromotion(String promotionType) throws ParseException, IOException, ServletException {
        if(Promotion.PromotionType.order_discount.equals(Promotion.PromotionType.valueOf(promotionType)))  checkOrderPromotion(promotionType);
        else checkShippingPromotion(promotionType);
    }

    public void checkPromotion2(String promotionType) throws ParseException, IOException {
        if(promotionType.equals(orderPromotionTypeName)) checkOrderPromotion2();
        else checkShippingPromotion2();
    }

    public void updatePromotionDisplay() {
        String promotionId = request.getParameter("promotionId");
        boolean doDisplay = Boolean.parseBoolean(request.getParameter("doDisplay"));
        Promotion promotion = promotionDAO.get(promotionId);

        promotion.setIsDisplay(doDisplay);
        promotionDAO.update(promotion);
    }

    public Promotion checkPromotionCode(String promotionCode) {
        return promotionDAO.findByName(promotionCode);
    }

    public Promotion checkDuplicatePromotion(String promotionId) {
        return promotionDAO.findByName(promotionId);
    }
}
