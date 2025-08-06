package com.store.Entity;

import javax.persistence.*;

@Entity
@Table(name = "categories")
@NamedQueries({
        @NamedQuery(name = "Category.findAll", query = "SELECT c FROM Category c ORDER BY c.id"),
        @NamedQuery(name = "Category.countAll", query = "SELECT COUNT(*) FROM Category"),
        @NamedQuery(name = "Category.findByName", query = "SELECT c FROM Category c WHERE c.name = :name"),
        @NamedQuery(name = "Category.listTypeName", query = "SELECT name FROM Category"),
        @NamedQuery(name = "Category.findAllUsedCategoryName", query = "SELECT c.name FROM Category c JOIN Product p ON c.id = p.category.id GROUP BY c.name ORDER BY c.name"),
        @NamedQuery(name = "Category.countChildrenByParentId", query = "SELECT COUNT(c) FROM Category c WHERE c.parent.id = :categoryId"),
        @NamedQuery(name = "Category.findByParentId", query = "SELECT c FROM Category c WHERE c.parent.id = :parentId"),
        @NamedQuery(name = "Category.findRootCategories", query = "SELECT c FROM Category c WHERE c.parent IS NULL")
})
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(length = 100)
    private String name;

    @ManyToOne
    @JoinColumn(name = "parent_id")
    private Category parent;

    public Category() {}

    public Category(String name, Category parent) {
        this.name = name;
        this.parent = parent;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Category getParent() {
        return parent;
    }

    public void setParent(Category parent) {
        this.parent = parent;
    }
}
