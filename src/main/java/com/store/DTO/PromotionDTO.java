package com.store.DTO;

import java.math.BigDecimal;
import java.util.Date;

public class PromotionDTO {
    private String id;
    private String description;
    private String type;
    private Boolean isDisplay;
    private String status;
    private Integer quantityInStock;
    private Date startDate;
    private Date endDate;
    private BigDecimal priceLimit;
    private BigDecimal percent;
    private BigDecimal maxDiscount;
    private Long usedPromotion;

    public PromotionDTO() {}

    public PromotionDTO(String id, String description, String type, String status, Boolean isDisplay, Integer quantityInStock, Date startDate, Date endDate, BigDecimal priceLimit, BigDecimal percent, BigDecimal maxDiscount, Long usedPromotion) {
        this.id = id;
        this.description = description;
        this.type = type;
        this.status = status;
        this.isDisplay = isDisplay;
        this.quantityInStock = quantityInStock;
        this.startDate = startDate;
        this.endDate = endDate;
        this.priceLimit = priceLimit;
        this.percent = percent;
        this.maxDiscount = maxDiscount;
        this.usedPromotion = usedPromotion;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Boolean getIsDisplay() {
        return isDisplay;
    }

    public void setIsDisplay(Boolean display) {
        isDisplay = display;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getQuantityInStock() {
        return quantityInStock;
    }

    public void setQuantityInStock(Integer quantityInStock) {
        this.quantityInStock = quantityInStock;
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

    public Long getUsedPromotion() {
        return usedPromotion;
    }

    public void setUsedPromotion(Long usedPromotion) {
        this.usedPromotion = usedPromotion;
    }
}
