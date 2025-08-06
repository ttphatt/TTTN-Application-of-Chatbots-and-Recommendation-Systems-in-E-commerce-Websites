package com.store.Entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "import_prices")
@NamedQueries({
        @NamedQuery(name = "ImportPrice.listAll", query = "SELECT i FROM ImportPrice i"),
        @NamedQuery(name = "ImportPrice.findByProductVariantIds", query = "SELECT i FROM ImportPrice i WHERE i.productVariantId IN :ids AND i.quantity != 0 ORDER BY i.time ASC")
})
public class ImportPrice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "product_variant_id")
    private Integer productVariantId;
    private Integer quantity;
    private BigDecimal price;
    private Date time;

    public ImportPrice() {}

    public ImportPrice(Integer productVariantId, Integer quantity, BigDecimal price, Date time) {
        this.productVariantId = productVariantId;
        this.quantity = quantity;
        this.price = price;
        this.time = time;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getProductVariantId() {
        return productVariantId;
    }

    public void setProductVariantId(Integer productVariantId) {
        this.productVariantId = productVariantId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }
}
