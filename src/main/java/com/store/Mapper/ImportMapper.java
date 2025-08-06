package com.store.Mapper;

import com.store.DTO.ImportDTO;
import com.store.Entity.Import;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper
public interface ImportMapper {

    ImportMapper INSTANCE = Mappers.getMapper(ImportMapper.class);

    @Mappings({
            @Mapping(source = "user.id", target = "userId"),
            @Mapping(source = "user.fullName", target = "userName")
    })
    ImportDTO toDTO(Import entity);

    @Mappings({
            @Mapping(source = "userId", target = "user.id")
    })
    Import toEntity(ImportDTO dto);

    List<ImportDTO> toDTOList(List<Import> list);
}