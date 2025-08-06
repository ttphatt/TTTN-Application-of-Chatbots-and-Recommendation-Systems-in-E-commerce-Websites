package com.store.DAO;

import com.store.Entity.Import;

import java.util.List;

public class ImportDAO extends JPADAO<Import> implements GenericDAO<Import>{
    @Override
    public Import create(Import newImport){
        return super.create(newImport);
    }

    @Override
    public Import get(Object id) {
        return super.find(Import.class, id);
    }

    @Override
    public void delete(Object id) { super.delete(Import.class, id); }

    @Override
    public List<Import> listAll() {
        return super.findWithNamedQuery("Import.findAll");
    }

    @Override
    public long count() {
        return super.countWithNamedQuery("Import.count");
    }

    public Import getReference(String importId) {
        return super.find(Import.class, importId);
    }
}
