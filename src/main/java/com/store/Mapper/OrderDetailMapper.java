package com.store.Mapper;

import com.store.DTO.OrderDetailDTO;
import com.store.Entity.OrderDetail;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(uses = {ProductVariantMapper.class})
public interface OrderDetailMapper {
    OrderDetailMapper INSTANCE = Mappers.getMapper(OrderDetailMapper.class);

    @Mapping(target = "orderId", source = "order.id")
    @Mapping(target = "productVariant", source = "productVariant")
    OrderDetailDTO toDTO(OrderDetail entity);

    List<OrderDetailDTO> toDTOList(List<OrderDetail> entityList);
}
