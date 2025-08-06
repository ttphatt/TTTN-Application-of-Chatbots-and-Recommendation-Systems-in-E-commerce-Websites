package com.store.DAO;

import com.store.Entity.Customer;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerDAO extends JPADAO<Customer> implements GenericDAO<Customer> {
    @Override
    public Customer create(Customer customer) {
        customer.setSignUpDate(new Date());
        return super.create(customer);
    }

    @Override
    public Customer update(Customer entity) { return super.update(entity); }

    @Override
    public Customer get(Object customerId) {
        return super.find(Customer.class, customerId);
    }

    @Override
    public void delete(Object customerId) {
        super.delete(Customer.class, customerId);
    }

    @Override
    public List<Customer> listAll() {
        return super.findWithNamedQuery("Customer.findAll");
    }

    @Override
    public long count() {
        return super.countWithNamedQuery("Customer.countAll");
    }

    public Customer findByEmail(String email) {
        List<Customer> res = super.findWithNamedQuery("Customer.findByEmail", "email", email);

        if(!res.isEmpty()) {
            return res.getFirst();
        }
        return null;
    }

    public Customer checkLogin(String email, String password) {
        Map<String, Object> params = new HashMap<>();
        params.put("email", email);
        params.put("password", password);

        List<Customer> res = super.findWithNamedQuery("Customer.checkLogin", params);

        if(!res.isEmpty()) {
            return res.getFirst();
        }

        return null;
    }

    public long checkCompletedOrder(int customerId, int productId){
        Map<String, Object>params = new HashMap<>();
        params.put("customerId", customerId);
        params.put("productId", productId);
        return super.countWithNamedQuery("Customer.checkCompletedOrder", params);
    }

    public Customer getReference(Integer customerId){
        return super.getReference(Customer.class, customerId);
    }
}
