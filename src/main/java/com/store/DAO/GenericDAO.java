package com.store.DAO;

import java.util.List;

public interface GenericDAO<E> {
    E create(E t);

    E update(E t);

    E get(Object id);

    void delete(Object id);

    List<E> listAll();

    long count();
}
