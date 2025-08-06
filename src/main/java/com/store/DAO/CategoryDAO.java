package com.store.DAO;

import com.store.Entity.Category;

import java.util.List;

public class CategoryDAO extends JPADAO<Category> implements GenericDAO<Category> {
    @Override
    public Category create(Category category) {
        return super.create(category);
    }

    @Override
    public Category update(Category category) {
        return super.update(category);
    }

    @Override
    public Category get(Object id) {
        return super.find(Category.class, id);
    }

    @Override
    public void delete(Object id) {
        super.delete(Category.class, id);
    }

    @Override
    public List<Category> listAll() {
        return super.findWithNamedQuery("Category.findAll");
    }

    @Override
    public long count() {
        return super.countWithNamedQuery("Category.countAll");
    }

    public Category findByName(String name) {
        List<Category>categories = super.findWithNamedQuery("Category.findByName", "name", name);

        if(categories != null && !categories.isEmpty()) {
            return categories.getFirst();
        }
        return null;
    }

    public List<String> listUsedCategoryName() {
        return super.listWithNamedQuery("Category.findAllUsedCategoryName");
    }

    public long countChildrenByParentId(Integer parentId) {
        return super.countWithNamedQuery("Category.countChildrenByParentId", "categoryId", parentId);
    }

    public Category getReference(Integer id) {
        return super.getReference(Category.class, id);
    }

    public List<Category> findByParentId(Integer parentId) {
        return super.findWithNamedQuery("Category.findByParentId", "parentId", parentId);
    }

    public List<Category> findRootCategories() {
        return super.findWithNamedQuery("Category.findRootCategories");
    }
}
