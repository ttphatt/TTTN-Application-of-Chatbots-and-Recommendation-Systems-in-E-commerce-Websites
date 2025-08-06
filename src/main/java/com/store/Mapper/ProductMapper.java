package com.store.Mapper;

import com.store.DTO.ProductDTO;
import com.store.Entity.Product;
import org.mapstruct.*;
import org.mapstruct.factory.Mappers;

import java.util.List;
import java.util.stream.Collectors;

@Mapper(componentModel = "default", uses = {CategoryMapper.class})
public interface ProductMapper {
    ProductMapper INSTANCE = Mappers.getMapper(ProductMapper.class);

    @Mapping(source = "category", target = "category")
    ProductDTO toDTO(Product entity);

    Product toEntity(ProductDTO dto);

    List<ProductDTO> toDTO(List<Product> list);

    @Named("getProductDTOWithIdAndName")
    @BeanMapping(ignoreByDefault = true)
    @Mappings({
            @Mapping(source = "id", target = "id"),
            @Mapping(source = "name", target = "name")

    })
    ProductDTO getProductDTOWithIdAndName(Product entity);

    default List<ProductDTO> getProductDTOWithIdAndNameList(List<Product> products) {
        if (products == null) return null;

        return products.stream()
                .map(this::getProductDTOWithIdAndName)
                .collect(Collectors.toList());
    }
}
