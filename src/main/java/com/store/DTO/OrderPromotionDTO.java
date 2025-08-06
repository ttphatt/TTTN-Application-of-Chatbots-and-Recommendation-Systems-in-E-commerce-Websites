package com.store.DTO;

import java.math.BigDecimal;

public class OrderPromotionDTO {
    private Integer orderId;
    private String promotionId;
    private String promotionType;
    private BigDecimal discountPrice;

    public OrderPromotionDTO(Integer orderId, String promotionId, String promotionType, BigDecimal discountPrice) {
        this.orderId = orderId;
        this.promotionId = promotionId;
        this.promotionType = promotionType;
        this.discountPrice = discountPrice;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(String promotionId) {
        this.promotionId = promotionId;
    }

    public String getPromotionType() {
        return promotionType;
    }

    public void setPromotionType(String promotionType) {
        this.promotionType = promotionType;
    }

    public BigDecimal getDiscountPrice() {
        return discountPrice;
    }

    public void setDiscountPrice(BigDecimal discountPrice) {
        this.discountPrice = discountPrice;
    }
}
