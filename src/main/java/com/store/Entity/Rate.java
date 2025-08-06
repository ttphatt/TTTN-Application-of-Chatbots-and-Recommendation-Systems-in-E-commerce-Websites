package com.store.Entity;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "rates")
@NamedQueries({
        @NamedQuery(name = "Rate.listAll", query = "SELECT r FROM Rate r ORDER BY r.time DESC"),
        @NamedQuery(name = "Rate.listRatingStars", query = "SELECT r.stars FROM Rate r GROUP BY r.stars"),
        @NamedQuery(name = "Rate.countAll", query = "SELECT COUNT(*) FROM Rate r"),
        @NamedQuery(name = "Rate.countRatingStars", query = "SELECT COUNT(r.stars) FROM Rate r GROUP BY r.stars"),
        @NamedQuery(name = "Rate.listMostFavoredProducts", query = "SELECT r.product, COUNT(r.product.id) AS RateCount, AVG(r.stars) AS AvgRating FROM Rate r "
                + "GROUP BY r.product.id HAVING AVG(r.stars) >= 4.0 "
                + "ORDER BY RateCount DESC, AvgRating DESC"),
        @NamedQuery(name = "Rate.findByCustomerAndProduct", query = "SELECT r FROM Rate r WHERE r.customer.id = :customerId AND r.product.id = :productId"),
})
public class Rate {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne @JoinColumn(name = "customer_id")
    private Customer customer;

    @ManyToOne @JoinColumn(name = "product_id")
    private Product product;

    private Float stars;
    private String headline;
    private String detail;
    private Date time;

    public Rate() {}

    public Rate(Customer customer, Product product, Float stars, String headline, Date time, String detail) {
        this.customer = customer;
        this.product = product;
        this.stars = stars;
        this.headline = headline;
        this.time = time;
        this.detail = detail;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public Float getStars() {
        return stars;
    }

    public void setStars(Float stars) {
        this.stars = stars;
    }

    public String getHeadline() {
        return headline;
    }

    public void setHeadline(String headline) {
        this.headline = headline;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }
}
