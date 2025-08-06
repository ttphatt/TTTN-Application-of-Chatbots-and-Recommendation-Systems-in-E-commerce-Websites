package com.store.Mapper;

import com.store.DTO.WarehouseDTO;
import com.store.Entity.Warehouse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper
public interface WarehouseMapper {
    WarehouseMapper INSTANCE = Mappers.getMapper(WarehouseMapper.class);

    @Mapping(source = "productVariant.id", target = "productVariantId")
    @Mapping(source = "productVariant.color.value", target = "color")
    @Mapping(source = "productVariant.size.value", target = "size")
    @Mapping(source = "productVariant.material.value", target = "material")
    WarehouseDTO toDTO(Warehouse entity);

    Warehouse toEntity(WarehouseDTO dto);

    List<WarehouseDTO> toDTOList(List<Warehouse> list);
}
