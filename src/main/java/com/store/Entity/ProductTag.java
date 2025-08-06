package com.store.Entity;

import javax.persistence.*;

@Entity
@Table(name = "product_tag")
@NamedQueries({
        @NamedQuery(name = "ProductTag.findAll", query = "SELECT pt FROM ProductTag pt"),
        @NamedQuery(name = "ProductTag.findByProductId", query = "SELECT pt FROM ProductTag pt WHERE pt.productId = :productId"),
        @NamedQuery(name = "ProductTag.deleteByProductId", query = "DELETE FROM ProductTag pt WHERE pt.productId = :productId")
})
@IdClass(ProductTagId.class)
public class ProductTag {
    @Id
    @Column(name = "tag_id")
    private Integer tagId;

    @Id
    @Column(name = "product_id")
    private Integer productId;

    public ProductTag() {}

    public ProductTag(Integer tagId, Integer productId) {
        this.tagId = tagId;
        this.productId = productId;
    }

    public Integer getTagId() {
        return tagId;
    }

    public void setTagId(Integer tagId) {
        this.tagId = tagId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }
}
