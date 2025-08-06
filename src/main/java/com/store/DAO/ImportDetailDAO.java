package com.store.DAO;

import com.store.Entity.ImportDetail;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ImportDetailDAO extends JPADAO<ImportDetail> implements GenericDAO<ImportDetail>{
    @Override
    public ImportDetail get(Object id) {
        return super.find(ImportDetail.class, id);
    }

    @Override
    public void delete(Object id) { super.delete(ImportDetail.class, id); }

    @Override
    public List<ImportDetail> listAll() {
        return super.findWithNamedQuery("ImportDetail.findAll");
    }

    @Override
    public long count() {
        return 0;
    }

    @Override
    public ImportDetail create(ImportDetail entity) {
        return super.create(entity);
    }

    @Override
    public ImportDetail createWithMerge(ImportDetail entity) {
        return super.createWithMerge(entity);
    }

    public List<ImportDetail> findByImportId(String importId) {
        Map<String, Object> parameters = new HashMap<>();
        parameters.put("importId", importId);

        return super.findWithNamedQuery("ImportDetail.findByImportId", parameters);
    }
}
