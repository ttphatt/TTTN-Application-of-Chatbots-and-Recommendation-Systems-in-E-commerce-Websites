package com.store.DAO;

import com.store.Entity.Profit;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProfitDAO extends JPADAO<Profit> implements GenericDAO<Profit>{
    @Override
    public Profit get(Object id) {
        return super.find(Profit.class, id);
    }

    @Override
    public void delete(Object id) {
        super.delete(Profit.class, id);
    }

    @Override
    public List<Profit> listAll() {
        return super.findWithNamedQuery("Profit.listAll");
    }

    @Override
    public long count() {
        return 0;
    }

    @Override
    public Profit create(Profit profit) {
        return super.create(profit);
    }

    @Override
    public Profit update(Profit profit) {
        return super.update(profit);
    }

    public void saveAll(List<Profit> profits) {
        for (Profit profit : profits) {
            super.create(profit);
        }
    }
}
