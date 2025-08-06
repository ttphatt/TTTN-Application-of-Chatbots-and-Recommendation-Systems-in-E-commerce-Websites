package com.store.DAO;

import com.store.Entity.Rate;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RateDAO extends JPADAO<Rate> implements GenericDAO<Rate> {

	@Override
	public Rate create(Rate rate) {
		rate.setTime(new Date());
		return super.create(rate);
	}
	
	@Override
	public Rate get(Object rateId) {
		return super.find(Rate.class, rateId);
	}

	@Override
	public void delete(Object rateId) { super.delete(Rate.class, rateId); }

	@Override
	public List<Rate> listAll() {
		return super.findWithNamedQuery("Rate.listAll");
	}

	@Override
	public long count() {
		return super.countWithNamedQuery("Rate.countAll");
	}
	
	public List<Rate> listMostRecentRates(){
		return super.findWithNamedQuery("Rate.listAll", 0, 3);
	}
	
	public List<String> listRatingStars(){
		return super.listWithNamedQuery("Rate.listRatingStars");
	}
	
	public List<Integer> countRatingStars(){
		return super.countListWithNamedQuery("Rate.countRatingStars");
	}

	public Rate findByCustomerAndProduct(Integer customerId, Integer productId) {
		Map<String, Object> params = new HashMap<>();
		params.put("customerId", customerId);
		params.put("productId", productId);

		List<Rate>res = super.findWithNamedQuery("Rate.findByCustomerAndProduct", params);

		if(!res.isEmpty()) {
			return res.getFirst();
		}
		return null;
	}
}
