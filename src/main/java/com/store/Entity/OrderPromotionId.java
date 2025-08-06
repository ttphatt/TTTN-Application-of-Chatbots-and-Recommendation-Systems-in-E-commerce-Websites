package com.store.Entity;


import javax.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

public class OrderPromotionId implements Serializable {
    private int orderId;
    private String promotion;

    public OrderPromotionId() {}

    public OrderPromotionId(int orderId, String promotion) {
        this.orderId = orderId;
        this.promotion = promotion;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getPromotion() {
        return promotion;
    }

    public void setPromotion(String promotion) {
        this.promotion = promotion;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof OrderPromotionId that)) return false;
        return orderId == that.orderId && Objects.equals(promotion, that.promotion);
    }

    @Override
    public int hashCode() {
        return Objects.hash(orderId, promotion);
    }
}
