package com.store.DTO;

import java.math.BigDecimal;

public class OrderDetailDTO {
    private Integer orderId;
    private ProductVariantDTO productVariant;
    private Integer quantity;
    private BigDecimal subTotal;

    public OrderDetailDTO(Integer orderId, ProductVariantDTO productVariant, Integer quantity, BigDecimal subTotal) {
        this.orderId = orderId;
        this.productVariant = productVariant;
        this.quantity = quantity;
        this.subTotal = subTotal;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public ProductVariantDTO getProductVariant() {
        return productVariant;
    }

    public void setProductVariant(ProductVariantDTO productVariant) {
        this.productVariant = productVariant;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(BigDecimal subTotal) {
        this.subTotal = subTotal;
    }
}
