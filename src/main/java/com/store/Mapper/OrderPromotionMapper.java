package com.store.Mapper;

import com.store.DTO.OrderPromotionDTO;
import com.store.Entity.OrderPromotion;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper
public interface OrderPromotionMapper {
    OrderPromotionMapper INSTANCE = Mappers.getMapper(OrderPromotionMapper.class);

    @Mappings({
            @Mapping(source = "promotion.id", target = "promotionId"),
            @Mapping(source = "promotion.type", target = "promotionType"),
    })
    OrderPromotionDTO toDTO(OrderPromotion entity);

    List<OrderPromotionDTO> toDTOList(List<OrderPromotion> entityList);
}
