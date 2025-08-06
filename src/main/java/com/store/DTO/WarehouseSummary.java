package com.store.DTO;

import java.util.Date;

public class WarehouseSummary {
    private Integer productId;
    private String productName;
    private Integer quantity;
    private Date updatedDate;

    public WarehouseSummary() {}

    public WarehouseSummary(Integer productId, String productName, Integer quantity, Date updatedDate) {
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.updatedDate = updatedDate;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Date getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Date updatedDate) {
        this.updatedDate = updatedDate;
    }
}
