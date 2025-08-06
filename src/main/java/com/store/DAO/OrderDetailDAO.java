package com.store.DAO;

import com.store.Entity.OrderDetail;

import java.util.List;

public class OrderDetailDAO extends JPADAO<OrderDetail> implements GenericDAO<OrderDetail> {

    @Override
    public OrderDetail get(Object id) {
        return super.find(OrderDetail.class, id);
    }

    @Override
    public void delete(Object id) {
        super.delete(OrderDetail.class, id);
    }

    @Override
    public List<OrderDetail> listAll() {
        return null;
    }

    @Override
    public long count() {
        return 0;
    }

    public List<OrderDetail> getOrderDetailByOrderId(Integer orderId) {
        return super.findWithNamedQuery("OrderDetail.findWithOrderId", "orderId", orderId);
    }
}
