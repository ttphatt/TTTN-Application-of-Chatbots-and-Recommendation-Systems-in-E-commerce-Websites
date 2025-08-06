package com.store.DAO;

import com.store.Entity.Tag;

import java.util.List;

public class TagDAO extends JPADAO<Tag> implements GenericDAO<Tag>  {
    @Override
    public Tag get(Object id) {
        return super.find(Tag.class, id);
    }

    @Override
    public void delete(Object id) {
        super.delete(Tag.class, id);
    }

    @Override
    public List<Tag> listAll() {
        return super.findWithNamedQuery("Tag.findAll");
    }

    @Override
    public long count() {
        return 0;
    }

    @Override
    public Tag create(Tag entity) {
        return super.create(entity);
    }

    @Override
    public Tag update(Tag entity) {
        return super.update(entity);
    }
}
