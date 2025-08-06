package com.store.Mapper;

import com.store.DTO.WarehouseSummary;
import com.store.Entity.Warehouse;

import java.util.*;
import java.util.stream.Collectors;

public class WarehouseMapperUtil {

    public static List<WarehouseSummary> toSummaryList(List<Warehouse> warehouses) {
        // Gom nhóm theo productId
        Map<Integer, List<Warehouse>> grouped = warehouses.stream()
                .filter(w -> w.getProductVariant() != null && w.getProductVariant().getProduct() != null)
                .collect(Collectors.groupingBy(w -> w.getProductVariant().getProduct().getId()));

        // Map từng nhóm thành WarehouseSummaryDTO
        List<WarehouseSummary> result = new ArrayList<>();

        for (Map.Entry<Integer, List<Warehouse>> entry : grouped.entrySet()) {
            Integer productId = entry.getKey();
            List<Warehouse> group = entry.getValue();

            // Lấy tên sản phẩm từ product đầu tiên
            String productName = group.get(0).getProductVariant().getProduct().getName();

            // Tổng quantity
            int totalQuantity = group.stream().mapToInt(Warehouse::getQuantity).sum();

            // Ngày cập nhật mới nhất
            Date latestUpdated = group.stream()
                    .map(Warehouse::getUpdatedDate)
                    .filter(Objects::nonNull)
                    .max(Date::compareTo)
                    .orElse(null);

            WarehouseSummary dto = new WarehouseSummary();
            dto.setProductId(productId);
            dto.setProductName(productName);
            dto.setQuantity(totalQuantity);
            dto.setUpdatedDate(latestUpdated);

            result.add(dto);
        }

        return result;
    }
}
