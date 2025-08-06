package com.store.DAO;

import com.store.Entity.Warehouse;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class WarehouseDAO extends JPADAO<Warehouse> implements GenericDAO<Warehouse>{
    @Override
    public Warehouse create(Warehouse warehouse){
        warehouse.setCreatedDate(new Date());
        warehouse.setUpdatedDate(new Date());
        return super.create(warehouse);
    }

    @Override
    public Warehouse update(Warehouse warehouse){
        warehouse.setUpdatedDate(new Date());
        return super.update(warehouse);
    }

    @Override
    public Warehouse get(Object id) {
        return super.find(Warehouse.class, id);
    }

    @Override
    public void delete(Object id) {
        super.delete(Warehouse.class, id);
    }

    @Override
    public List<Warehouse> listAll() {
        return super.findWithNamedQuery("Warehouse.findAll");
    }

    @Override
    public long count() {
        return super.countWithNamedQuery("Warehouse.count");
    }

    public List<Warehouse> findByProductId(Integer productId) {
        Map<String, Object> params = new HashMap<>();
        params.put("productId", productId);
        return super.findWithNamedQuery("Warehouse.findByProductId", params);
    }

    public void updateQuantityByProductVariantId(Integer productVariantId, Integer quantity) {
        Map<String, Object> params = new HashMap<>();
        params.put("productVariantId", productVariantId);
        params.put("quantity", quantity);

        super.executeNamedUpdate("Warehouse.updateQuantityByProductVariantId", params);
    }

    public List<Warehouse> findByVariantIds(List<Integer> variantIds) {
        Map<String, Object> params = new HashMap<>();
        params.put("ids", variantIds);
        return super.findWithNamedQuery("Warehouse.findByVariantIds", params);
    }
}
