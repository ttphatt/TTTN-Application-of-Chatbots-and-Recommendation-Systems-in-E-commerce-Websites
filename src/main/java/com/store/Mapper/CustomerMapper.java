package com.store.Mapper;

import com.store.DTO.CustomerDTO;
import com.store.Entity.Customer;
import org.mapstruct.*;
import org.mapstruct.factory.Mappers;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Mapper
public interface CustomerMapper {
    CustomerMapper INSTANCE = Mappers.getMapper(CustomerMapper.class);

    CustomerDTO toDTO(Customer customer);

    Customer toEntity(CustomerDTO dto);

    List<CustomerDTO> toDTO(List<Customer> customers);

    @Named("getChatCustomerDTO")
    @BeanMapping(ignoreByDefault = true)
    @Mappings({
            @Mapping(source = "id", target = "id"),
            @Mapping(source = "firstname", target = "firstname"),
            @Mapping(source = "lastname", target = "lastname"),

    })
    CustomerDTO getChatCustomerDTO(Customer customer);

    default List<CustomerDTO> getChatCustomerDTOList(List<Customer> customers) {
        if (customers == null) return new ArrayList<>();
        return customers.stream()
                .map(this::getChatCustomerDTO)
                .collect(Collectors.toList());
    }
}
