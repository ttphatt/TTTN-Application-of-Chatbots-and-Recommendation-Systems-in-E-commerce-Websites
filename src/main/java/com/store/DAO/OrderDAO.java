package com.store.DAO;

import com.store.Entity.Order;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO extends JPADAO<Order> implements GenericDAO<Order> {
    @Override
    public Order create(Order order) {
        order.setDate(new Date());
        order.setStatus(Order.Status.Processing);

        return super.create(order);
    }

    @Override
    public Order update(Order order) {
        return super.update(order);
    }

    @Override
    public Order get(Object orderId) {
        return super.find(Order.class, orderId);
    }

    @Override
    public void delete(Object orderId) {
        super.delete(Order.class, orderId);
    }

    @Override
    public List<Order> listAll() {
        return super.findWithNamedQuery("Order.listAll");
    }

    @Override
    public long count() {
        return super.countWithNamedQuery("Order.countAll");
    }

    public List<Order> listMostRecentSales(){
        return super.findWithNamedQuery("Order.listAll", 0, 3);
    }

    public List<Order> findByCustomer(Integer customerId) {
        Map<String, Object> parameter = new HashMap<>();
        parameter.put("customerId", customerId);

        return super.findWithNamedQuery("Order.findByCustomer", parameter);
    }

    public Order getReference(Integer orderId) {
        return super.getReference(Order.class, orderId);
    }
}