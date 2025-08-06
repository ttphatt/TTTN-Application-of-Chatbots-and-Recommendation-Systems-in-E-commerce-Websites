package com.store.Entity;

import org.mapstruct.Mapping;

import javax.persistence.*;
import java.math.BigDecimal;

@Entity
@IdClass(OrderPromotionId.class)
@Table(name = "order_promotion")
@NamedQueries({
        @NamedQuery(name = "OrderPromotion.findWithOrderId", query = "SELECT od FROM OrderPromotion od WHERE od.orderId = :orderId"),
})
public class OrderPromotion {
    @Id
    @Column(name = "order_id")
    private int orderId;

    @Id
    @ManyToOne
    @JoinColumn(name = "promotion_id")
    private Promotion promotion;

    @Column(name = "discount_price")
    private BigDecimal discountPrice;

    public OrderPromotion() {}

    public OrderPromotion(int orderId, BigDecimal discountPrice, Promotion promotion) {
        this.orderId = orderId;
        this.discountPrice = discountPrice;
        this.promotion = promotion;
    }

    // Getters & Setters
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public Promotion getPromotion() {
        return promotion;
    }

    public void setPromotion(Promotion promotion) {
        this.promotion = promotion;
    }

    public BigDecimal getDiscountPrice() { return discountPrice; }
    public void setDiscountPrice(BigDecimal discountPrice) { this.discountPrice = discountPrice; }
}