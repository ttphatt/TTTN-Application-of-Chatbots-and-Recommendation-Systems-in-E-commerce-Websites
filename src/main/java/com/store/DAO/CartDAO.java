package com.store.DAO;

import com.store.Entity.Cart;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CartDAO extends JPADAO<Cart> implements GenericDAO<Cart> {
    @Override
    public Cart get(Object id) {
        return super.find(Cart.class, id);
    }

    @Override
    public void delete(Object id) {
        super.delete(Cart.class, id);
    }

    @Override
    public List<Cart> listAll() {
        return null;
    }

    @Override
    public long count() {
        return 0;
    }

    @Override
    public Cart create(Cart entity) {
        return super.create(entity);
    }

    @Override
    public Cart createWithMerge(Cart entity) {
        return super.createWithMerge(entity);
    }

    @Override
    public Cart update(Cart entity) {
        return super.update(entity);
    }

    public void deleteCartByCustomerId(Integer customerId) {
        Map<String, Object> parameter = new HashMap<>();
        parameter.put("customerId", customerId);

        super.executeNamedUpdate("Cart.deleteByCustomerId", parameter);
    }

    public List<Cart> getCartsByCustomerId(Integer customerId) {
        Map<String, Object> parameter = new HashMap<>();
        parameter.put("customerId", customerId);

        return super.findWithNamedQuery("Cart.findAllByCustomerId", parameter);
    }

    public void deleteByUniqueKey(Integer customerId, Integer productVariantId) {
        Map<String, Object> parameter = new HashMap<>();
        parameter.put("customerId", customerId);
        parameter.put("productVariantId", productVariantId);

        super.executeNamedUpdate("Cart.deleteByCustomerAndProductVariant", parameter);
    }
}
