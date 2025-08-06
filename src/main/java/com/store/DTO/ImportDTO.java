package com.store.DTO;

import java.math.BigDecimal;
import java.util.Date;

public class ImportDTO {
    private String id;
    private Integer userId;
    private String userName;
    private BigDecimal totalPrice;
    private Date date;

    public ImportDTO() {}

    public ImportDTO(Integer userId, String userName, BigDecimal totalPrice, Date date) {
        this.userId = userId;
        this.userName = userName;
        this.totalPrice = totalPrice;
        this.date = date;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
}
