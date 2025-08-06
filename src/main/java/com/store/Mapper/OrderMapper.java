package com.store.Mapper;

import com.store.DTO.OrderDTO;
import com.store.Entity.Customer;
import com.store.Entity.Order;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.Named;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper
public interface OrderMapper {
    OrderMapper INSTANCE = Mappers.getMapper(OrderMapper.class);

    @Mappings({
            @Mapping(source = "customer", target = "customerName", qualifiedByName = "combineFullName"),
            @Mapping(source = "customer.id", target = "customerId")
    })
    OrderDTO toDTO(Order order);

    Order toEntity(OrderDTO orderDTO);

    List<OrderDTO> toDTOList(List<Order> orders);

    @Named("combineFullName")
    static String combineFullName(Customer customer) {
        return RateMapper.combineFullName(customer);
    }
}
