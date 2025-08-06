package com.store.DAO;

import com.store.Entity.ProductTag;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductTagDAO extends JPADAO<ProductTag> implements GenericDAO<ProductTag> {
    @Override
    public ProductTag get(Object id) {
        return super.find(ProductTag.class, id);
    }

    @Override
    public void delete(Object id) {
        super.delete(ProductTag.class, id);
    }

    @Override
    public List<ProductTag> listAll() {
        return super.findWithNamedQuery("ProductTag.findAll");
    }

    @Override
    public long count() {
        return 0;
    }

    @Override
    public ProductTag create(ProductTag entity) {
        return super.create(entity);
    }

    @Override
    public ProductTag update(ProductTag entity) {
        return super.update(entity);
    }

    public List<Integer> getTagIdsByProductId(int productId) {
        Map<String, Object> parameters = new HashMap<>();
        parameters.put("productId", productId);

        List<ProductTag> productTags = findWithNamedQuery("ProductTag.findByProductId", parameters);
        List<Integer> tagIds = new ArrayList<>();

        for (ProductTag productTag : productTags) {
            tagIds.add(productTag.getTagId());
        }

        return tagIds;
    }

    public void deleteByProductId(int productId) {
        Map<String, Object> parameter = new HashMap<>();
        parameter.put("productId", productId);

        super.executeNamedUpdate("ProductTag.deleteByProductId", parameter);
    }
}
