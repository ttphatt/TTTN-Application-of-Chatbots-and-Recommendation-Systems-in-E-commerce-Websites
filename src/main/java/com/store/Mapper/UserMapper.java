package com.store.Mapper;

import com.store.DTO.UserDTO;
import com.store.Entity.User;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper
public interface UserMapper {
    UserMapper INSTANCE = Mappers.getMapper(UserMapper.class);

    UserDTO toDTO(User entity);

    User toEntity(UserDTO dto);

    List<UserDTO> toDTOList(List<User> list);
}
