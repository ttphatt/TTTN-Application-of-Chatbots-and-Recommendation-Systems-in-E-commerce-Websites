package com.store.DAO;

import com.store.DTO.ProductDTO;
import com.store.Entity.Product;
import com.store.Mapper.ProductMapper;

import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends JPADAO<Product> implements GenericDAO<Product> {
    public ProductDAO() {}

    @Override
    public Product create(Product product) {
        return super.create(product);
    }

    @Override
    public Product update(Product product) {
        return super.update(product);
    }

    @Override
    public Product get(Object id) {
        return super.find(Product.class, id);
    }

    @Override
    public void delete(Object id) {
        super.delete(Product.class, id);
    }

    @Override
    public List<Product> listAll() {
        return super.findWithNamedQuery("Product.findAll");
    }

    @Override
    public long count() {
        return super.countWithNamedQuery("Product.countAll");
    }

    public List<String> listSoldProductName(){
        return super.listWithNamedQuery("Product.listSoldProductName");
    }

    public List<Integer> listEachProductRevenue(){
        return super.countListWithNamedQuery("Product.listEachProductRevenue");
    }

    public List<Integer> countGroupedByCategory(){
        return super.countListWithNamedQuery("Product.countGroupedByCategory");
    }

    public long countByCategory(Integer categoryId) {
        return super.countWithNamedQuery("Product.countByCategory", "categoryId", categoryId);
    }

    public Product getReference(Integer id) {
        return super.getReference(Product.class, id);
    }

    public List<ProductDTO> listNewProducts() {
        List<ProductDTO> products = new ArrayList<>();
        List<Object[]> res = super.findWithNamedQueryObjects("Product.listNewProducts", 0, 3);

        if (!res.isEmpty()) {
            for (Object[] elements : res) {
                ProductDTO product = ProductMapper.INSTANCE.toDTO((Product) elements[0]);
                product.setAvgStars((Double) elements[1]);
                products.add(product);
            }
        }

        return products;
    }

    public List<ProductDTO> listMostFavoredProducts() {
        List<ProductDTO> mostFavoredProducts = new ArrayList<>();
        List<Object[]> results = super.findWithNamedQueryObjects("Rate.listMostFavoredProducts", 0, 3);

        if(!results.isEmpty()) {
            for(Object[] elements : results) {
                ProductDTO product = ProductMapper.INSTANCE.toDTO((Product) elements[0]);
                product.setAvgStars((Double) elements[2]);
                mostFavoredProducts.add(product);
            }
        }

        return mostFavoredProducts;
    }

    public List<ProductDTO> listBestSelling() {
        List<ProductDTO> bestSellingProducts = new ArrayList<>();
        List<Object[]> res = super.findWithNamedQueryObjects("OrderDetail.listBestSelling", 0, 3);

        if (!res.isEmpty()) {
            for(Object[] elements : res) {
                ProductDTO product = ProductMapper.INSTANCE.toDTO((Product) elements[0]);
                product.setAvgStars((Double) elements[1]);
                bestSellingProducts.add(product);
            }
        }

        return bestSellingProducts;
    }

    public List<Product> listByCategoryId(Integer categoryId) {
        return super.findWithNamedQuery("Product.listByCategoryId", "categoryId", categoryId);
    }
}
