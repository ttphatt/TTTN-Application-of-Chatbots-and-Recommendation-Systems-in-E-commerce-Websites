package com.store.DAO;

import com.store.Entity.ProductVariant;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductVariantDAO extends JPADAO<ProductVariant> implements GenericDAO<ProductVariant> {

    public ProductVariantDAO() {}

    @Override
    public ProductVariant create(ProductVariant product) {
        return super.create(product);
    }

    @Override
    public ProductVariant update(ProductVariant product) {
        return super.update(product);
    }

    @Override
    public ProductVariant get(Object productId) {
        return super.find(ProductVariant.class, productId);
    }

    @Override
    public void delete(Object productId) {
        super.delete(ProductVariant.class, productId);
    }

    @Override
    public List<ProductVariant> listAll() {
        return super.findWithNamedQuery("ProductVariant.findAll");
    }

    @Override
    public long count() {
        return super.countWithNamedQuery("ProductVariant.countAll");
    }

    public ProductVariant findByAttributes(Integer productId, Integer colorId, Integer sizeId, Integer materialId) {
        Map<String, Object> parameters = new HashMap<>();
        parameters.put("productId", productId);
        parameters.put("colorId", colorId);
        parameters.put("sizeId", sizeId);
        parameters.put("materialId", materialId);

        List<ProductVariant> result = super.findWithNamedQuery("ProductVariant.findByAttributes", parameters);

        return result.isEmpty() ? null : result.getFirst();
    }

    public ProductVariant findByUniqueKey(Integer productId, Integer colorId, Integer sizeId, Integer materialId) {
        Map<String, Object> parameters = new HashMap<>();
        parameters.put("productId", productId);
        parameters.put("colorId", colorId);
        parameters.put("sizeId", sizeId);
        parameters.put("materialId", materialId);

        List<ProductVariant> result = super.findWithNamedQuery("ProductVariant.findByUniqueKey", parameters);

        return result.isEmpty() ? null : result.getFirst();
    }

    public Integer getIdByUniqueKey(Integer productId, Integer colorId, Integer sizeId, Integer materialId) {
        Map<String, Object> parameters = new HashMap<>();
        parameters.put("productId", productId);
        parameters.put("colorId", colorId);
        parameters.put("sizeId", sizeId);
        parameters.put("materialId", materialId);
        List<ProductVariant> result = super.findWithNamedQuery("ProductVariant.findByUniqueKey", parameters);

        return result.isEmpty() ? null : result.getFirst().getId();
    }

    public List<ProductVariant> findByFilters(Integer productId, Integer sizeId, Integer colorId, Integer materialId) {
        Map<String, Object> parameters = new HashMap<>();
        parameters.put("productId", productId);
        parameters.put("colorId", colorId);
        parameters.put("sizeId", sizeId);
        parameters.put("materialId", materialId);

        return super.findWithNamedQuery("ProductVariant.findByFilters", parameters);
    }

    public ProductVariant getReference(Integer id) {
        return super.getReference(ProductVariant.class, id);
    }

    public Map<Integer, Integer> getMapToProductId() {
        List<Object[]> res = super.findWithNamedQueryObjects("ProductVariant.loadMapToProductId");

        Map<Integer, Integer> mapToProductId = new HashMap<>();
        if (!res.isEmpty()) {
            for (Object[] row : res) {
                mapToProductId.put((Integer) row[0], (Integer) row[1]);
            }
        }

        return mapToProductId;
    }
}
