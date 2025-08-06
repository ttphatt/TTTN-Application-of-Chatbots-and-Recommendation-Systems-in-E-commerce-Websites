package com.store.Entity;

import javax.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "import_detail")
@IdClass(ImportDetailId.class)
@NamedQueries({
        @NamedQuery(name = "ImportDetail.findByImportId", query = "SELECT id FROM ImportDetail id WHERE id.importRecord.id =: importId"),
})
public class ImportDetail {
    @Id
    @ManyToOne
    @JoinColumn(name = "import_id")
    private Import importRecord;

    @Id
    @ManyToOne
    @JoinColumn(name = "product_variant_id")
    private ProductVariant productVariant;

    private BigDecimal price;
    private Integer quantity;

    public ImportDetail() {}

    public ImportDetail(Import importRecord, ProductVariant productVariant, BigDecimal price, Integer quantity) {
        this.importRecord = importRecord;
        this.productVariant = productVariant;
        this.price = price;
        this.quantity = quantity;
    }

    public Import getImportRecord() {
        return importRecord;
    }

    public void setImportRecord(Import importRecord) {
        this.importRecord = importRecord;
    }

    public ProductVariant getProductVariant() {
        return productVariant;
    }

    public void setProductVariant(ProductVariant productVariant) {
        this.productVariant = productVariant;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}
