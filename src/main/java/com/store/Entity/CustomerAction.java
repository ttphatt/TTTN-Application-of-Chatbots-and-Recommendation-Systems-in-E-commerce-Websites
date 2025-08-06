package com.store.Entity;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "customer_actions")
public class CustomerAction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "product_variant_id")
    private Integer productVariantId;

    @Column(name = "customer_id")
    private Integer customerId;

    @Enumerated(EnumType.STRING)
    @Column(name = "action_type")
    private ActionType actionType;

    private Date time;

    public enum ActionType {
        view, add_to_cart, remove_from_cart, search
    }

    public CustomerAction() {}

    public CustomerAction(Integer id, Integer productVariantId, Integer customerId, ActionType actionType, Date time) {
        this.id = id;
        this.productVariantId = productVariantId;
        this.customerId = customerId;
        this.actionType = actionType;
        this.time = time;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getProductVariantId() {
        return productVariantId;
    }

    public void setProductVariantId(Integer productVariantId) {
        this.productVariantId = productVariantId;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomer(Integer customerId) {
        this.customerId = customerId;
    }

    public ActionType getActionType() {
        return actionType;
    }

    public void setActionType(ActionType actionType) {
        this.actionType = actionType;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }
}
