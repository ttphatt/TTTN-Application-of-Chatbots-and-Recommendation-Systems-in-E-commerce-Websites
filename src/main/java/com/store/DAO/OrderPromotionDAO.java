package com.store.DAO;

import com.store.Entity.OrderPromotion;

import java.util.List;

public class OrderPromotionDAO extends JPADAO<OrderPromotion> implements GenericDAO<OrderPromotion> {
    @Override
    public OrderPromotion create(OrderPromotion orderPromotion) {
        return super.create(orderPromotion);
    }

    @Override
    public OrderPromotion get(Object id) {
        return null;
    }

    @Override
    public void delete(Object id) { super.delete(OrderPromotion.class, id); }

    @Override
    public List<OrderPromotion> listAll() {
        return null;
    }

    @Override
    public long count() {
        return 0;
    }

    public List<OrderPromotion> findWithOrderId(Integer orderId) {
        return super.findWithNamedQuery("OrderPromotion.findWithOrderId", "orderId", orderId);
    }
}
