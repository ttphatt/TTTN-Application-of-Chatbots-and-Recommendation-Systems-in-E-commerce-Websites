package com.store.Mapper;

import com.store.DTO.RateDTO;
import com.store.Entity.Customer;
import com.store.Entity.Rate;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper
public interface RateMapper {
    RateMapper INSTANCE = Mappers.getMapper(RateMapper.class);

    @Mapping(source = "customer.id", target = "customerId")
    @Mapping(source = "customer", target = "customerName", qualifiedByName = "combineFullName")
    @Mapping(source = "product.id", target = "productId")
    @Mapping(source = "product.name", target = "productName")
    RateDTO toDTO(Rate rate);

    Rate toEntity(RateDTO dto);

    List<RateDTO> toDTOList(List<Rate> rates);

    @Named("combineFullName")
    static String combineFullName(Customer customer) {
        if (customer == null) return null;
        String first = customer.getFirstname() != null ? customer.getFirstname() : "";
        String last = customer.getLastname() != null ? customer.getLastname() : "";
        return (first + " " + last).trim();
    }
}
