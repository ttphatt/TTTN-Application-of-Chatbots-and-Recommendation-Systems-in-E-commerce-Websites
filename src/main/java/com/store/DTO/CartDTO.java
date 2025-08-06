package com.store.DTO;

public class CartDTO {
    private ProductVariantDTO productVariant;
    private int quantity;

    public CartDTO() {}

    public CartDTO(ProductVariantDTO productVariant, Integer quantity) {
        this.quantity = quantity;
        this.productVariant = productVariant;
    }

    public ProductVariantDTO getProductVariant() {
        return productVariant;
    }

    public void setProductVariant(ProductVariantDTO productVariant) {
        this.productVariant = productVariant;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
