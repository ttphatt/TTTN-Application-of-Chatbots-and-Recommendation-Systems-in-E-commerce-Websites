package com.store.Mapper;

import com.store.DTO.ImportDetailDTO;
import com.store.Entity.ImportDetail;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(uses = ProductVariantMapper.class)
public interface ImportDetailMapper {

    ImportDetailMapper INSTANCE = Mappers.getMapper(ImportDetailMapper.class);

    @Mapping(target = "importId", source = "importRecord.id")
    ImportDetailDTO toDTO(ImportDetail entity);

    List<ImportDetailDTO> toDTOList(List<ImportDetail> entityList);
}
