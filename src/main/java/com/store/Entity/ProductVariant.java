package com.store.Entity;

import javax.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "product_variants", uniqueConstraints = @UniqueConstraint(columnNames = {"product_id", "color_id", "size_id", "material_id"}))
@NamedQueries({
        @NamedQuery(
                name = "ProductVariant.findByAttributes",
                query = "SELECT pv " +
                        "FROM ProductVariant pv " +
                        "WHERE pv.product.id = :productId AND pv.color.id = :colorId AND pv.size.id = :sizeId AND pv.material.id = :materialId"),
        @NamedQuery(name = "ProductVariant.findAll", query = "SELECT pv FROM ProductVariant pv ORDER BY pv.product.id, pv.color.id, pv.size.id, pv.material.id"),
        @NamedQuery(name = "ProductVariant.findByUniqueKey",
                query = "SELECT pv " +
                        "FROM ProductVariant pv " +
                        "WHERE pv.product.id = :productId AND pv.color.id = :colorId AND pv.size.id = :sizeId AND pv.material.id = :materialId"),
        @NamedQuery(
                name = "ProductVariant.findByFilters",
                query = "SELECT pv FROM ProductVariant pv " +
                        "WHERE pv.product.id = :productId " +
                        "AND (:colorId IS NULL OR pv.color.id = :colorId) " +
                        "AND (:sizeId IS NULL OR pv.size.id = :sizeId) " +
                        "AND (:materialId IS NULL OR pv.material.id = :materialId)"),
        @NamedQuery(
                name = "ProductVariant.findByAttributeId",
                query = "SELECT p FROM ProductVariant p " +
                        "WHERE p.size.id = :attributeId OR p.color.id = :attributeId OR p.material.id = :attributeId"),

        @NamedQuery(name = "ProductVariant.loadMapToProductId", query = "SELECT pv.id, pv.product.id FROM ProductVariant pv")
})
public class ProductVariant {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;

    @Column(length = 255)
    private String image;

    private BigDecimal price;

    @ManyToOne @JoinColumn(name = "color_id")
    private Attribute color;

    @ManyToOne @JoinColumn(name = "size_id")
    private Attribute size;

    @ManyToOne @JoinColumn(name = "material_id")
    private Attribute material;

    public ProductVariant() {}

    public ProductVariant(Integer id, Product product, String image, BigDecimal price, Attribute color, Attribute size, Attribute material) {
        this.id = id;
        this.product = product;
        this.image = image;
        this.price = price;
        this.color = color;
        this.size = size;
        this.material = material;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Attribute getColor() {
        return color;
    }

    public void setColor(Attribute color) {
        this.color = color;
    }

    public Attribute getSize() {
        return size;
    }

    public void setSize(Attribute size) {
        this.size = size;
    }

    public Attribute getMaterial() {
        return material;
    }

    public void setMaterial(Attribute material) {
        this.material = material;
    }
}
