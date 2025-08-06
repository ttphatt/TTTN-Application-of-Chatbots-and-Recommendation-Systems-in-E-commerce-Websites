package com.store.Mapper;

import com.store.DTO.PromotionDTO;
import com.store.Entity.Promotion;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper
public interface PromotionMapper {
    PromotionMapper INSTANCE = Mappers.getMapper(PromotionMapper.class);

    PromotionDTO toDTO(Promotion entity);

    Promotion toEntity(PromotionDTO dto);

    List<PromotionDTO> toDTOList(List<Promotion> list);
}
