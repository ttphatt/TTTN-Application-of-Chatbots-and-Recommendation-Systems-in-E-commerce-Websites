package com.store.Entity;

import javax.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

public class OrderDetailId implements Serializable {
    private int order;
    private int productVariant;

    public OrderDetailId() {}

    public OrderDetailId(int order, int productVariant) {
        this.order = order;
        this.productVariant = productVariant;
    }

    public int getOrder() {
        return order;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public int getProductVariant() {
        return productVariant;
    }

    public void setProductVariant(int productVariant) {
        this.productVariant = productVariant;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        OrderDetailId that = (OrderDetailId) o;
        return order == that.order && productVariant == that.productVariant;
    }

    @Override
    public int hashCode() {
        return Objects.hash(order, productVariant);
    }
}
