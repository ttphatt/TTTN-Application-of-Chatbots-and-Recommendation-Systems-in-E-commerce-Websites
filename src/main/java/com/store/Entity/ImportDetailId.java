package com.store.Entity;

import java.io.Serializable;
import java.util.Objects;

public class ImportDetailId implements Serializable {
    private String importRecord;
    private Integer productVariant;

    public ImportDetailId() {}

    public ImportDetailId(String importRecord, Integer productVariant) {
        this.importRecord = importRecord;
        this.productVariant = productVariant;
    }

    public String getImportRecord() {
        return importRecord;
    }

    public void setImportRecord(String importRecord) {
        this.importRecord = importRecord;
    }

    public Integer getProductVariant() {
        return productVariant;
    }

    public void setProductVariant(Integer productVariant) {
        this.productVariant = productVariant;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ImportDetailId that)) return false;
        return Objects.equals(importRecord, that.importRecord) &&
                Objects.equals(productVariant, that.productVariant);
    }

    @Override
    public int hashCode() {
        return Objects.hash(importRecord, productVariant);
    }
}
