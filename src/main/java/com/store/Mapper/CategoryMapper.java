package com.store.Mapper;

import com.store.DTO.CategoryDTO;
import com.store.Entity.Category;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper
public interface CategoryMapper {
    CategoryMapper INSTANCE = Mappers.getMapper(CategoryMapper.class);

    @Mapping(source = "parent.id", target = "parentId")
    @Mapping(source = "parent.name", target = "parentName")
    CategoryDTO toDTO(Category category);

    Category toEntity(CategoryDTO dto);

    List<CategoryDTO> toDTOList(List<Category> categoryList);
}
