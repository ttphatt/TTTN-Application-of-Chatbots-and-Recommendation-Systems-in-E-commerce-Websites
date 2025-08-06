package com.store.DAO;

import javax.persistence.*;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class JPADAO<E> {
    private static final EntityManagerFactory entityManagerFactory;

    static {
        entityManagerFactory = Persistence.createEntityManagerFactory("StoreWebsite");
    }

    public JPADAO() {
    }

    public E create(E entity) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        entityManager.getTransaction().begin();

        entityManager.persist(entity);
        entityManager.flush();
        entityManager.refresh(entity);

        entityManager.getTransaction().commit();
        entityManager.close();

        return entity;
    }

    public E createWithMerge(E entity) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        entityManager.getTransaction().begin();

        E managedEntity = entityManager.merge(entity);
        entityManager.flush();
        entityManager.refresh(managedEntity);

        entityManager.getTransaction().commit();
        entityManager.close();

        return managedEntity;
    }

    public E update(E entity) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        entityManager.getTransaction().begin();

        entity = entityManager.merge(entity);

        entityManager.getTransaction().commit();
        entityManager.close();
        return entity;
    }

    public E find(Class<E> type, Object id) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        E entity = entityManager.find(type, id);
        if (entity != null) {
            entityManager.refresh(entity);
        }

        entityManager.close();
        return entity;
    }

    public void delete(Class<E> type, Object id) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        entityManager.getTransaction().begin();

        Object reference = entityManager.getReference(type, id);
        entityManager.remove(reference);

        entityManager.getTransaction().commit();
        entityManager.close();
    }

    //Trả về tập dữ liệu trong database bằng query
    public List<E> findWithNamedQuery(String queryName) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        Query query = entityManager.createNamedQuery(queryName);
        List<E> res = query.getResultList();

        entityManager.close();
        return res;
    }

    public List<E> findWithNamedQuery(String queryName, int firstResult, int maxResult) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        Query query = entityManager.createNamedQuery(queryName);
        query.setFirstResult(firstResult);
        query.setMaxResults(maxResult);

        List<E> res = query.getResultList();

        entityManager.close();
        return res;
    }

    public List<Object[]> findWithNamedQueryObjects(String queryName, int firstResult, int maxResult) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        Query query = entityManager.createNamedQuery(queryName);
        query.setFirstResult(firstResult);
        query.setMaxResults(maxResult);

        List<Object[]> res = query.getResultList();

        entityManager.close();
        return res;
    }

    public List<Object[]> findWithNamedQueryObjects(String queryName) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        Query query = entityManager.createNamedQuery(queryName);

        List<Object[]> res = query.getResultList();
        entityManager.close();

        return res;
    }

    public List<E> findWithNamedQuery(String queryName, String paramName, Object paramValue) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        Query query = entityManager.createNamedQuery(queryName);

        query.setParameter(paramName, paramValue);
        List<E> res = query.getResultList();

        entityManager.close();
        return res;
    }

    public List<E> findWithNamedQuery(String queryName, Map<String, Object> parameters) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        Query query = entityManager.createNamedQuery(queryName);
        Set<Map.Entry<String, Object>> setParameters = parameters.entrySet();

        for (Map.Entry<String, Object> temp : setParameters) {
            query.setParameter(temp.getKey(), temp.getValue());
        }

        List<E> res = query.getResultList();

        entityManager.close();
        return res;
    }

    //Các function thêm vào
    public List<String> listWithNamedQuery(String queryName) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        Query query = entityManager.createNamedQuery(queryName);
        List<String> res = query.getResultList();

        entityManager.close();
        return res;
    }

    public List<Integer> countListWithNamedQuery(String queryName) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        Query query = entityManager.createNamedQuery(queryName);
        List<Integer> res = query.getResultList();

        entityManager.close();
        return res;
    }

    public List<Long> countListWithNamedQuery3(String queryName) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        Query query = entityManager.createNamedQuery(queryName);
        List<Long> res = query.getResultList();

        entityManager.close();
        return res;
    }

    public List<Double> countListWithNamedQuery2(String queryName) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        Query query = entityManager.createNamedQuery(queryName);
        List<Double> res = query.getResultList();

        entityManager.close();
        return res;
    }

    //Trả về sồ lượng dữ liệu có trong database bằng query
    public long countWithNamedQuery(String queryName) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        Query query = entityManager.createNamedQuery(queryName);

        long res = (long) query.getSingleResult();
        entityManager.close();
        return res;
    }

    public long countWithNamedQuery(String queryName, Map<String, Object> parameters) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        Query query = entityManager.createNamedQuery(queryName);
        Set<Map.Entry<String, Object>> setParameters = parameters.entrySet();

        for (Map.Entry<String, Object> temp : setParameters) {
            query.setParameter(temp.getKey(), temp.getValue());
        }

        long res = (long) query.getSingleResult();
        entityManager.close();
        return res;
    }

    public long countWithNamedQuery(String queryName, String parameterName, Object parameterValue) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        Query query = entityManager.createNamedQuery(queryName);
        query.setParameter(parameterName, parameterValue);

        long res = (long) query.getSingleResult();
        entityManager.close();
        return res;
    }

    public void close() {
        if (entityManagerFactory != null) {
            entityManagerFactory.close();
        }
    }

    public void executeNamedUpdate(String namedQuery, Map<String, Object> parameters) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        EntityTransaction tx = entityManager.getTransaction();

        try {
            tx.begin();
            Query query = entityManager.createNamedQuery(namedQuery);
            for (Map.Entry<String, Object> entry : parameters.entrySet()) {
                query.setParameter(entry.getKey(), entry.getValue());
            }
            query.executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            entityManager.close();
        }
    }

    public <T> T getReference(Class<T> clazz, Object id) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        T reference = entityManager.getReference(clazz, id);
        entityManager.close();
        return reference;
    }
}
