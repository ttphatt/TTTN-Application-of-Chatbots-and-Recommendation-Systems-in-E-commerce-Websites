package com.store.DAO;

import com.store.Entity.Promotion;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PromotionDAO extends JPADAO<Promotion> implements GenericDAO<Promotion> {

    public PromotionDAO() {}

    @Override
    public Promotion create(Promotion promotion) {
        return super.create(promotion);
    }

    @Override
    public Promotion update(Promotion promotion) {
        return super.update(promotion);
    }

    @Override
    public Promotion get(Object promotionId) {
        return super.find(Promotion.class, promotionId);
    }

    @Override
    public void delete(Object id) { super.delete(Promotion.class, id); }

    @Override
    public List<Promotion> listAll() {
        return super.findWithNamedQuery("Promotion.findAll");
    }

    @Override
    public long count() {
        return super.countWithNamedQuery("Promotion.countAll");
    }

    public List<Long> countUsedAllPromotion() {
        return super.countListWithNamedQuery3("Promotion.countUsedAllPromotionId");
    }

    public long countUsedPromotion(String promotionId) {
        return super.countWithNamedQuery("Promotion.countUsedPromotionId", "promotionId", promotionId);
    }

    public Promotion findByName(String promotionID) {
        List<Promotion> promotion = super.findWithNamedQuery("Promotion.findByPromotionId", "promotionId", promotionID);

        if(promotion != null && !promotion.isEmpty()) {
            return promotion.getFirst();
        }
        return null;
    }

    public Map<String, String> findPromotionsBeingDisplayed(String promotionType){
        List<Object[]> listPromotions = super.findWithNamedQueryObjects("Promotion.findPromotionsBeingDisplayed");

        Map<String, String> res = new HashMap<>();
        String promotionId, promotionDescription, type;

        for(Object[] promotion : listPromotions) {
            promotionId = (String) promotion[0];
            promotionDescription = (String) promotion[1];
            type = promotion[2].toString();

            if(promotionType.equals(type)){
                res.put(promotionId, promotionDescription);
            }
        }

        return res;
    }

    public Map<String, String> findPromotionDisplayed(String promotionType){
        return findPromotionsBeingDisplayed(promotionType);
    }

    public Promotion getReference(String promotionId) {
        return super.getReference(Promotion.class, promotionId);
    }
}
