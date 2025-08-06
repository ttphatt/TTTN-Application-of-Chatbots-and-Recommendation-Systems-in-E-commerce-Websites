package com.store.DTO;

import java.util.Date;

public class WarehouseDTO {
    private Integer productVariantId;
    private String color;
    private String size;
    private String material;
    private Integer quantity;
    private Date updatedDate;

    public WarehouseDTO(Integer productVariantId, String color, String material, String size, Integer quantity, Date updatedDate) {
        this.productVariantId = productVariantId;
        this.color = color;
        this.material = material;
        this.size = size;
        this.quantity = quantity;
        this.updatedDate = updatedDate;
    }

    public Integer getProductVariantId() {
        return productVariantId;
    }

    public void setProductVariantId(Integer productVariantId) {
        this.productVariantId = productVariantId;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
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
