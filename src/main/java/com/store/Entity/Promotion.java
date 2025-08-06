package com.store.Entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "promotions")
@NamedQueries({
        @NamedQuery(name = "Promotion.findAll", query = "SELECT p FROM Promotion p ORDER BY p.id"),
        @NamedQuery(name = "Promotion.countAll", query = "SELECT COUNT(*) FROM Promotion"),
        @NamedQuery(name = "Promotion.findByPromotionId", query = "SELECT p FROM Promotion p WHERE p.id = :promotionId"),
        @NamedQuery(name = "Promotion.countUsedAllPromotionId", query ="SELECT COUNT(op.promotion.id) AS usage_count FROM Promotion p LEFT JOIN OrderPromotion op ON p.id = op.promotion.id GROUP BY p.id"),
        @NamedQuery(name = "Promotion.countUsedPromotionId", query = "SELECT COUNT(op.promotion.id) AS usage_count FROM Promotion p, OrderPromotion op WHERE p.id = op.promotion.id AND p.id = :promotionId"),
        @NamedQuery(name = "Promotion.findPromotionsBeingDisplayed", query = "SELECT p.id, p.description, p.type FROM Promotion p WHERE p.isDisplay = true"),
})
public class Promotion {
    @Id
    private String id;

    @Column(name = "quantity_in_stock")
    private Integer quantityInStock;

    @Column(name = "price_limit")
    private BigDecimal priceLimit;
    private BigDecimal percent;

    @Column(name = "max_discount")
    private BigDecimal maxDiscount;
    private String description;

    @Column(name = "start_date")
    private Date startDate;

    @Column(name = "end_date")
    private Date endDate;

    @Enumerated(EnumType.STRING)
    private PromotionType type;

    @Enumerated(EnumType.STRING)
    private PromotionStatus status;

    @Column(name = "is_display")
    private Boolean isDisplay;

    public enum PromotionType {
        shipping_discount, order_discount
    }

    public enum PromotionStatus {
        active, expired, pending
    }

    public Promotion() {}

    public Promotion(String id, Integer quantityInStock, BigDecimal priceLimit, BigDecimal percent, BigDecimal maxDiscount, String description, Date startDate, Date endDate, PromotionType type, PromotionStatus status, Boolean isDisplay) {
        this.id = id;
        this.quantityInStock = quantityInStock;
        this.priceLimit = priceLimit;
        this.percent = percent;
        this.maxDiscount = maxDiscount;
        this.description = description;
        this.startDate = startDate;
        this.endDate = endDate;
        this.type = type;
        this.status = status;
        this.isDisplay = isDisplay;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Integer getQuantityInStock() {
        return quantityInStock;
    }

    public void setQuantityInStock(Integer quantityInStock) {
        this.quantityInStock = quantityInStock;
    }

    public BigDecimal getPriceLimit() {
        return priceLimit;
    }

    public void setPriceLimit(BigDecimal priceLimit) {
        this.priceLimit = priceLimit;
    }

    public BigDecimal getPercent() {
        return percent;
    }

    public void setPercent(BigDecimal percent) {
        this.percent = percent;
    }

    public BigDecimal getMaxDiscount() {
        return maxDiscount;
    }

    public void setMaxDiscount(BigDecimal maxDiscount) {
        this.maxDiscount = maxDiscount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public PromotionType getType() {
        return type;
    }

    public void setType(PromotionType type) {
        this.type = type;
    }

    public PromotionStatus getStatus() {
        return status;
    }

    public void setStatus(PromotionStatus status) {
        this.status = status;
    }

    public Boolean getIsDisplay() {
        return isDisplay;
    }

    public void setIsDisplay(Boolean display) {
        isDisplay = display;
    }
}
