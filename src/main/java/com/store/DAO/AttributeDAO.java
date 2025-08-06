package com.store.DAO;

import com.store.Entity.Attribute;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AttributeDAO extends JPADAO<Attribute> implements GenericDAO<Attribute>  {
    @Override
    public Attribute get(Object id) {
        return super.find(Attribute.class, id);
    }

    @Override
    public void delete(Object id) {
        super.delete(Attribute.class, id);
    }

    @Override
    public List<Attribute> listAll() {
        return super.findWithNamedQuery("Attribute.findAll");
    }

    @Override
    public long count() {
        return 0;
    }

    @Override
    public Attribute create(Attribute attribute) {
        return super.create(attribute);
    }

    @Override
    public Attribute update(Attribute entity) {
        return super.update(entity);
    }

    public Map<String, List<Attribute>> categorizeAttributes() {
        List<Attribute> attributes = super.findWithNamedQuery("Attribute.findAll");

        Map<String, List<Attribute>> categorized = new HashMap<>();

        for (Attribute attr : attributes) {
            if (attr.getType() == null) continue;
            String type = attr.getType().toString();

            categorized.computeIfAbsent(type, k -> new ArrayList<>()).add(attr);
        }

        return categorized;
    }

    public Attribute getReference(Integer id) {
        return super.getReference(Attribute.class, id);
    }

    public Boolean isAttributeUsed(Integer attributeId) {
        Map<String, Object> params = new HashMap<>();
        params.put("attributeId", attributeId);

        return !super.findWithNamedQuery("ProductVariant.findByAttributeId", params).isEmpty();
    }

    public Boolean isExistAttribute(Attribute.AttributeType type, String value) {
        Map<String, Object> params = new HashMap<>();
        params.put("type", type);
        params.put("value", value);

        return !super.findWithNamedQuery("Attribute.findByTypeAndValue", params).isEmpty();
    }
}
