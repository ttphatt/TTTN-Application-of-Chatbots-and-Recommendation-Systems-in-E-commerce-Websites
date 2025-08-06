package com.store.Entity;

import java.io.Serializable;
import java.util.Objects;

public class CartId implements Serializable {
    private Integer customer;
    private Integer productVariant;

    public CartId() {}

    public CartId(Integer customer, Integer productVariant) {
        this.customer = customer;
        this.productVariant = productVariant;
    }

    public Integer getCustomer() {
        return customer;
    }

    public void setCustomer(Integer customer) {
        this.customer = customer;
    }

    public Integer getProductVariant() {
        return productVariant;
    }

    public void setProductVariant(Integer productVariant) {
        this.productVariant = productVariant;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CartId cartId = (CartId) o;
        return Objects.equals(customer, cartId.customer) && Objects.equals(productVariant, cartId.productVariant);
    }

    @Override
    public int hashCode() {
        return Objects.hash(customer, productVariant);
    }
}
