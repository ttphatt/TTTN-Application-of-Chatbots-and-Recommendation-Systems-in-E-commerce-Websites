package com.store.Entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "orders")
@NamedQueries({
        @NamedQuery(name = "Order.listAll", query = "SELECT o FROM Order o ORDER BY o.id DESC"),
        @NamedQuery(name = "Order.countAll", query = "SELECT COUNT(*) FROM Order"),
        @NamedQuery(name = "Order.findByCustomer", query = "SELECT o FROM Order o WHERE o.customer.id = :customerId ORDER BY o.date DESC"),
})

public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne @JoinColumn(name = "customer_id")
    private Customer customer;
    private Date date;

    @Column(name = "address_line1")
    private String addressLine1;

    @Column(name = "address_line2")
    private String addressLine2;

    private String firstname;
    private String lastname;

    private String phone;
    private String country;
    private String city;
    private String state;
    private String zipcode;

    @Enumerated(EnumType.STRING)
    private Payment payment;

    @Column(name = "shipping_fee")
    private BigDecimal shippingFee;

    private BigDecimal tax;
    private BigDecimal subtotal;

    @Column(name = "order_sum")
    private BigDecimal orderSum;

    @Enumerated(EnumType.STRING)
    private Status status;

    public enum Payment {
        COD, PAYPAL
    }

    public enum Status {
        Processing, Shipping, Delivered, Completed, Cancelled, Returned
    }

    public Order() {}

    public Order(Customer customer, Date date, String addressLine1, String addressLine2, String firstname, String lastname, String phone, String country, String city, String state, String zipcode, Payment payment, BigDecimal shippingFee, BigDecimal tax, BigDecimal subtotal, BigDecimal orderSum, Status status) {
        this.customer = customer;
        this.date = date;
        this.addressLine1 = addressLine1;
        this.addressLine2 = addressLine2;
        this.firstname = firstname;
        this.lastname = lastname;
        this.phone = phone;
        this.country = country;
        this.city = city;
        this.state = state;
        this.zipcode = zipcode;
        this.payment = payment;
        this.shippingFee = shippingFee;
        this.tax = tax;
        this.subtotal = subtotal;
        this.orderSum = orderSum;
        this.status = status;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getAddressLine1() {
        return addressLine1;
    }

    public void setAddressLine1(String addressLine1) {
        this.addressLine1 = addressLine1;
    }

    public String getAddressLine2() {
        return addressLine2;
    }

    public void setAddressLine2(String addressLine2) {
        this.addressLine2 = addressLine2;
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getZipcode() {
        return zipcode;
    }

    public void setZipcode(String zipcode) {
        this.zipcode = zipcode;
    }

    public Payment getPayment() {
        return payment;
    }

    public void setPayment(Payment payment) {
        this.payment = payment;
    }

    public BigDecimal getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
    }

    public BigDecimal getTax() {
        return tax;
    }

    public void setTax(BigDecimal tax) {
        this.tax = tax;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public BigDecimal getOrderSum() {
        return orderSum;
    }

    public void setOrderSum(BigDecimal orderSum) {
        this.orderSum = orderSum;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
}
