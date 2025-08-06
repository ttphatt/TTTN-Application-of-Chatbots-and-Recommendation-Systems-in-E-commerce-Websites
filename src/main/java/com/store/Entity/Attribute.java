package com.store.Entity;

import javax.persistence.*;

@Entity
@Table(name = "attributes", uniqueConstraints = @UniqueConstraint(columnNames = {"type", "value"}))
@NamedQueries({
        @NamedQuery(name = "Attribute.findAll", query = "SELECT a FROM Attribute a"),
        @NamedQuery(name = "Attribute.findByTypeAndValue", query = "SELECT a FROM Attribute a WHERE a.type = :type AND a.value = :value")
})
public class Attribute {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    public enum AttributeType {
        color, size, material
    }

    @Enumerated(EnumType.STRING)
    private AttributeType type;

    @Column(length = 100)
    private String value;

    public Attribute() {}

    public Attribute(Integer id, AttributeType type, String value) {
        this.id = id;
        this.type = type;
        this.value = value;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public AttributeType getType() {
        return type;
    }

    public void setType(AttributeType type) {
        this.type = type;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}

