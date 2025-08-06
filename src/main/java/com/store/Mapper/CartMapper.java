package com.store.Mapper;

import com.store.DTO.CartDTO;
import com.store.Entity.Cart;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(uses = {ProductVariantMapper.class})
public interface CartMapper {
    CartMapper INSTANCE = Mappers.getMapper(CartMapper.class);

    @Mappings({
            @Mapping(source = "productVariant", target = "productVariant")
    })
    CartDTO toDTO(Cart entity);

    Cart toEntity(CartDTO dto);

    List<CartDTO> toDTOList(List<Cart> list);
}
