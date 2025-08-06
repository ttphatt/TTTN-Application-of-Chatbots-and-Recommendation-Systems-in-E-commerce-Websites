package com.store.Entity;

import javax.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "order_detail")
@IdClass(OrderDetailId.class)
@NamedQueries({
        @NamedQuery(name = "OrderDetail.findWithOrderId", query = "SELECT od FROM OrderDetail od WHERE od.order.id = :orderId"),
        @NamedQuery(
                name = "OrderDetail.listBestSelling",
                query = "SELECT od.productVariant.product, AVG(r.stars) " +
                        "FROM OrderDetail od " +
                        "JOIN Rate r ON r.product.id = od.productVariant.product.id " +
                        "GROUP BY od.productVariant.product.id " +
                        "ORDER BY SUM(od.quantity) DESC"
        )
})
public class OrderDetail {
    @Id
    @ManyToOne
    @JoinColumn(name = "order_id")
    private Order order;

    @Id
    @ManyToOne
    @JoinColumn(name = "product_variant_id")
    private ProductVariant productVariant;

    private Integer quantity;

    @Column(name = "sub_total")
    private BigDecimal subTotal;

    public OrderDetail() {}

    public OrderDetail(Order order, ProductVariant productVariant, Integer quantity, BigDecimal subTotal) {
        this.order = order;
        this.productVariant = productVariant;
        this.quantity = quantity;
        this.subTotal = subTotal;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public ProductVariant getProductVariant() {
        return productVariant;
    }

    public void setProductVariant(ProductVariant productVariant) {
        this.productVariant = productVariant;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(BigDecimal subTotal) {
        this.subTotal = subTotal;
    }
}
