package com.store.Entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "imports")
@NamedQueries({
        @NamedQuery(name = "Import.findAll", query = "SELECT i FROM Import i")
})
public class Import {
    @Id
    private String id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private Date date;

    @Column(name = "total_price")
    private BigDecimal totalPrice;

    public Import() {}

    public Import(User user, Date date, BigDecimal totalPrice) {
        this.user = user;
        this.date = date;
        this.totalPrice = totalPrice;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
}
