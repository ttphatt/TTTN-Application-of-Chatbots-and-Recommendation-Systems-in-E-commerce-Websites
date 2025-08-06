package com.store.DAO;

import com.store.Entity.ImportPrice;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ImportPriceDAO extends JPADAO<ImportPrice> implements GenericDAO<ImportPrice>{
    @Override
    public ImportPrice get(Object id) {
        return super.find(ImportPrice.class, id);
    }

    @Override
    public void delete(Object id) {
        super.delete(ImportPrice.class, id);
    }

    @Override
    public List<ImportPrice> listAll() {
        return super.findWithNamedQuery("ImportPrice.listAll");
    }

    @Override
    public long count() {
        return 0;
    }

    @Override
    public ImportPrice create(ImportPrice entity) {
        return super.create(entity);
    }

    @Override
    public ImportPrice update(ImportPrice entity) {
        return super.update(entity);
    }

    public List<ImportPrice> findByProductVariantIds(List<Integer> ids) {
        Map<String, Object> params = new HashMap<>();
        params.put("ids", ids);
        return super.findWithNamedQuery("ImportPrice.findByProductVariantIds", params);
    }

    public void updateAll(List<ImportPrice> importPrices) {
        for (ImportPrice importPrice : importPrices) {
            update(importPrice);
        }
    }
}
