package com.store.DTO;

import java.math.BigDecimal;

public class ProductVariantDTO {
    private Integer id;
    private String productName;
    private String image;
    private BigDecimal price;
    private String colorName;
    private String sizeName;
    private String materialName;
    private Integer productId;
    private Integer colorId;
    private Integer sizeId;
    private Integer materialId;
    private String brand;

    public ProductVariantDTO() {}

    public ProductVariantDTO(Integer id, Integer productId, BigDecimal price, Integer colorId, Integer sizeId, Integer materialId) {
        this.id = id;
        this.productId = productId;
        this.price = price;
        this.colorId = colorId;
        this.sizeId = sizeId;
        this.materialId = materialId;
    }

    public ProductVariantDTO(Integer id, String productName, String image, BigDecimal price, String colorName, String sizeName, String materialName) {
        this.id = id;
        this.productName = productName;
        this.image = image;
        this.price = price;
        this.colorName = colorName;
        this.sizeName = sizeName;
        this.materialName = materialName;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getSizeName() {
        return sizeName;
    }

    public void setSizeName(String sizeName) {
        this.sizeName = sizeName;
    }

    public String getColorName() {
        return colorName;
    }

    public void setColorName(String colorName) {
        this.colorName = colorName;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public Integer getColorId() {
        return colorId;
    }

    public void setColorId(Integer colorId) {
        this.colorId = colorId;
    }

    public Integer getSizeId() {
        return sizeId;
    }

    public void setSizeId(Integer sizeId) {
        this.sizeId = sizeId;
    }

    public Integer getMaterialId() {
        return materialId;
    }

    public void setMaterialId(Integer materialId) {
        this.materialId = materialId;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }
}
