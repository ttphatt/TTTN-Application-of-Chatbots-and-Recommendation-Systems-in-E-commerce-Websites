package com.store.Entity;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "warehouse")
@NamedQueries({
        @NamedQuery(name = "Warehouse.findAll", query = "SELECT w FROM Warehouse w"),
        @NamedQuery(name = "Warehouse.countAll", query = "SELECT COUNT(*) FROM Warehouse"),
        @NamedQuery(name = "Warehouse.findByProductId",
                query = "SELECT w " +
                        "FROM Warehouse w " +
                        "WHERE w.productVariant.product.id = :productId " +
                        "ORDER BY w.productVariant.id"),
        @NamedQuery(
                name = "Warehouse.updateQuantityByProductVariantId",
                query = "UPDATE Warehouse w SET w.quantity = w.quantity + :quantity WHERE w.productVariant.id = :productVariantId"
        ),

        @NamedQuery(name = "Warehouse.findByVariantIds", query = "SELECT w FROM Warehouse w WHERE w.productVariant.id IN :ids"),
})
public class Warehouse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "product_variant_id")
    private ProductVariant productVariant;

    private Integer quantity;

    @Column(name = "created_date")
    private Date createdDate;

    @Column(name = "updated_date")
    private Date updatedDate;

    public Warehouse() {}

    public Warehouse(ProductVariant productVariant, Integer quantity, Date createdDate, Date updatedDate) {
        this.productVariant = productVariant;
        this.quantity = quantity;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
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

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Date updatedDate) {
        this.updatedDate = updatedDate;
    }
}
