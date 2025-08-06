package com.store.DTO;

import com.store.Entity.Tag;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class ProductDTO {
    private Integer id;
    private CategoryDTO category;
    private String name;
    private String brand;
    private String description;
    private Date releasedDate;
    private String image;
    private BigDecimal price;
    private List<Tag> tags;
    private Double avgStars;

    public ProductDTO() {}

    public ProductDTO(Integer id, CategoryDTO category, String name, String brand, String description, Date releasedDate, String image, BigDecimal price, List<Tag> tags) {
        this.id = id;
        this.category = category;
        this.name = name;
        this.brand = brand;
        this.description = description;
        this.releasedDate = releasedDate;
        this.image = image;
        this.price = price;
        this.tags = tags;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public CategoryDTO getCategory() {
        return category;
    }

    public void setCategory(CategoryDTO category) {
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

    public List<Tag> getTags() {
        return tags;
    }

    public void setTags(List<Tag> tags) {
        this.tags = tags;
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

    public Double getAvgStars() {
        return avgStars;
    }

    public void setAvgStars(Double avgStars) {
        this.avgStars = avgStars;
    }
}