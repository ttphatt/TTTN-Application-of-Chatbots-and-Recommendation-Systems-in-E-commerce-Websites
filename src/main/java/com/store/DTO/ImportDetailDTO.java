package com.store.DTO;

import java.math.BigDecimal;

public class ImportDetailDTO {
    private String importId;
    private ProductVariantDTO productVariant;
    private BigDecimal price;
    private Integer quantity;

    public ImportDetailDTO(String importId, ProductVariantDTO productVariant, BigDecimal price, Integer quantity) {
        this.importId = importId;
        this.productVariant = productVariant;
        this.price = price;
        this.quantity = quantity;
    }

    public String getImportId() {
        return importId;
    }

    public void setImportId(String importId) {
        this.importId = importId;
    }

    public ProductVariantDTO getProductVariant() {
        return productVariant;
    }

    public void setProductVariant(ProductVariantDTO productVariant) {
        this.productVariant = productVariant;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}
