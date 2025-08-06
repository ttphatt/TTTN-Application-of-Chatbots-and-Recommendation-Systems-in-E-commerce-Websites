package com.store.Entity;

import javax.persistence.*;
import javax.persistence.criteria.CriteriaBuilder;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "products")
@NamedQueries({
        @NamedQuery(name = "Product.findAll", query = "SELECT p FROM Product p"),
        @NamedQuery(name = "Product.countAll", query = "SELECT COUNT(*) FROM Product"),
        @NamedQuery(name = "Product.listSoldProductName", query = "SELECT p.name FROM Product p JOIN OrderDetail od ON p.id = od.productVariant.id GROUP BY p.name ORDER BY p.name"),
        @NamedQuery(name = "Product.listEachProductRevenue", query = "SELECT ROUND(SUM(od.subTotal)) FROM Product p JOIN OrderDetail od ON p.id = od.productVariant.id GROUP BY p.name ORDER BY p.name"),
        @NamedQuery(name = "Product.countGroupedByCategory", query = "SELECT COUNT(p.id) FROM Product p GROUP BY p.category.id"),
        @NamedQuery(name = "Product.countByCategory", query = "SELECT COUNT(p) FROM Product p WHERE p.category.id = :categoryId"),
        @NamedQuery(name = "Product.loadNameAndBrand", query = "SELECT p FROM Product p"),
        @NamedQuery(
                name = "Product.listNewProducts",
                query = "SELECT p, AVG(r.stars) " +
                        "FROM Product p " +
                        "LEFT JOIN Rate r ON r.product.id = p.id " +
                        "GROUP BY p.id " +
                        "ORDER BY p.releasedDate DESC"
        ),
        @NamedQuery(name = "Product.listByCategoryId", query = "SELECT p FROM Product p WHERE p.category.id = :categoryId")
})
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    @Column(length = 50)
    private String name;

    @Column(length = 50)
    private String brand;

    @Column(length = 200)
    private String description;

    @Column(name = "released_date")
    private Date releasedDate;

    private String image;
    private BigDecimal price;

    public Product() {}

    public Product(Category category, String name, String brand, String image, String description, Date releasedDate, BigDecimal price) {
        this.category = category;
        this.name = name;
        this.brand = brand;
        this.image = image;
        this.description = description;
        this.releasedDate = releasedDate;
        this.price = price;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getReleasedDate() {
        return releasedDate;
    }

    public void setReleasedDate(Date releasedDate) {
        this.releasedDate = releasedDate;
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
}
