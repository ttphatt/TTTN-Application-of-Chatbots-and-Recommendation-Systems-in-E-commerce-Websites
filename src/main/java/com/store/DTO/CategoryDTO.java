package com.store.DTO;

public class CategoryDTO {
    private Integer id;
    private String name;
    private Integer parentId;
    private String parentName;

    public CategoryDTO() {}

    public CategoryDTO(String name, Integer id, Integer parentId, String parentName) {
        this.name = name;
        this.id = id;
        this.parentId = parentId;
        this.parentName = parentName;
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

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }
}
