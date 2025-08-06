package com.store.Service;

import com.store.DAO.*;
import com.store.Entity.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.*;

public class ProfitService {
    private final ProfitDAO profitDAO;
    private final ProductVariantDAO productVariantDAO;
    private final ImportPriceDAO importPriceDAO;
    private final ProductDAO productDAO;
    private final OrderDetailDAO orderDetailDAO;
    private final OrderPromotionDAO orderPromotionDAO;
    private final OrderDAO orderDAO;

    public ProfitService() {
        this.profitDAO = new ProfitDAO();
        this.productVariantDAO = new ProductVariantDAO();
        this.importPriceDAO = new ImportPriceDAO();
        this.productDAO = new ProductDAO();
        this.orderDetailDAO = new OrderDetailDAO();
        this.orderPromotionDAO = new OrderPromotionDAO();
        this.orderDAO = new OrderDAO();
    }

    public void processProfit(Integer orderId) {
        List<OrderDetail> orderDetails = orderDetailDAO.getOrderDetailByOrderId(orderId);
        List<OrderPromotion> orderPromotions = orderPromotionDAO.findWithOrderId(orderId);
        Order order = orderDAO.get(orderId);

        BigDecimal totalDiscount = BigDecimal.ZERO;
        for (OrderPromotion orderPromotion : orderPromotions) {
            totalDiscount = totalDiscount.add(orderPromotion.getDiscountPrice());
        }

        BigDecimal percentDiscount = totalDiscount.divide(order.getSubtotal());

        createProfit(percentDiscount, orderDetails);

    }

    public void createProfit(BigDecimal percentDiscount, List<OrderDetail> orderDetails) {
        Map<Integer, Integer> mapToProductId = productVariantDAO.getMapToProductId();

        Set<Integer> variantIds = new HashSet<>();
        Set<Integer> productIds = new HashSet<>();

        for (OrderDetail orderDetail : orderDetails) {
            Integer variantId = orderDetail.getProductVariant().getId();
            variantIds.add(variantId);
            productIds.add(mapToProductId.get(variantId));
        }

        Map<Integer, Profit> productProfitMap = new HashMap<>();
        for (Integer productId : productIds) {
            Profit profit = new Profit();
            profit.setProduct(productDAO.getReference(productId));
            profit.setProfit(BigDecimal.ZERO);
            profit.setRevenue(BigDecimal.ZERO);
            profit.setDate(new Date());
            productProfitMap.put(productId, profit);
        }

        List<ImportPrice> importPrices = importPriceDAO.findByProductVariantIds(new ArrayList<>(variantIds));

        Map<Integer, List<ImportPrice>> importMap = new HashMap<>();
        for (ImportPrice ip : importPrices) {
            importMap.computeIfAbsent(ip.getProductVariantId(), k -> new ArrayList<>()).add(ip);
        }

        for (OrderDetail orderDetail : orderDetails) {
            Integer variantId = orderDetail.getProductVariant().getId();
            Integer quantity = orderDetail.getQuantity();
            BigDecimal revenue = orderDetail.getSubTotal().multiply(BigDecimal.ONE.subtract(percentDiscount));
            BigDecimal costPrice = BigDecimal.ZERO;

            List<ImportPrice> variantImports = importMap.get(variantId);

            for (ImportPrice importPrice : variantImports) {
                if (quantity == 0) break;

                int availableQty = importPrice.getQuantity();
                if (availableQty <= 0) continue;

                int usedQty = Math.min(quantity, availableQty);
                costPrice = costPrice.add(importPrice.getPrice().multiply(BigDecimal.valueOf(usedQty)));

                importPrice.setQuantity(availableQty - usedQty);
                quantity -= usedQty;
            }

            BigDecimal profitValue = revenue.subtract(costPrice);
            Integer productId = mapToProductId.get(variantId);

            Profit profit = productProfitMap.get(productId);
            profit.setRevenue(profit.getRevenue().add(revenue));
            profit.setProfit(profit.getProfit().add(profitValue));
        }

        List<Profit> profits = new ArrayList<>(productProfitMap.values());
        profitDAO.saveAll(profits);
        importPriceDAO.updateAll(importPrices);
    }

}
