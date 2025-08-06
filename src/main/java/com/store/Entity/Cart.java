package com.store.Entity;

import javax.persistence.*;

@Entity
@Table(name = "carts")
@NamedQueries({
        @NamedQuery(name = "Cart.findAllByCustomerId", query = "SELECT c FROM Cart c WHERE c.customer.id = :customerId"),
        @NamedQuery(
                name = "Cart.deleteByCustomerId",
                query = "DELETE FROM Cart c WHERE c.customer.id = :customerId"
        ),
        @NamedQuery(
                name = "Cart.deleteByCustomerAndProductVariant",
                query = "DELETE FROM Cart c " +
                        "WHERE c.customer.id = :customerId AND c.productVariant.id = :productVariantId")
})
@IdClass(CartId.class)
public class Cart {
    @Id
    @ManyToOne
    @JoinColumn(name = "customer_id", referencedColumnName = "id")
    private Customer customer;

    @Id
    @ManyToOne
    @JoinColumn(name = "product_variant_id", referencedColumnName = "id")
    private ProductVariant productVariant;

    private int quantity;

    public Cart() {}

    public Cart(Customer customer, ProductVariant productVariant, int quantity) {
        this.customer = customer;
        this.productVariant = productVariant;
        this.quantity = quantity;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public ProductVariant getProductVariant() {
        return productVariant;
    }

    public void setProductVariant(ProductVariant productVariant) {
        this.productVariant = productVariant;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
