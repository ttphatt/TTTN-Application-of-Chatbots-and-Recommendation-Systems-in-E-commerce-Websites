package com.store.Mapper;

import com.store.DTO.ProductVariantDTO;
import com.store.Entity.ProductVariant;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper
public interface ProductVariantMapper {
    ProductVariantMapper INSTANCE = Mappers.getMapper(ProductVariantMapper.class);

    @Mappings({
            @Mapping(source = "product.id", target = "productId"),
            @Mapping(source = "product.name", target = "productName"),
            @Mapping(source = "product.brand", target = "brand"),

            @Mapping(source = "color.id", target = "colorId"),
            @Mapping(source = "color.value", target = "colorName"),

            @Mapping(source = "size.id", target = "sizeId"),
            @Mapping(source = "size.value", target = "sizeName"),

            @Mapping(source = "material.id", target = "materialId"),
            @Mapping(source = "material.value", target = "materialName")
    })
    ProductVariantDTO toDTO(ProductVariant productVariant);

    ProductVariant toEntity(ProductVariantDTO dto);

    List<ProductVariantDTO> toDTOList(List<ProductVariant> productVariants);
}
