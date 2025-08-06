package com.store.DTO;

import com.store.DAO.CartDAO;
import com.store.DAO.ProductVariantDAO;
import com.store.Mapper.ProductVariantMapper;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class ShoppingCart {
	private List<CartDTO> carts;
	private final ProductVariantDAO productVariantDAO;
	private final CartDAO cartDAO;

	public ShoppingCart() {
		carts = new ArrayList<>();
		productVariantDAO = new ProductVariantDAO();
		cartDAO = new CartDAO();
	}

	//Thêm giày vào giỏ hàng
	public void addItem(Integer productId, Integer colorId, Integer sizeId, Integer materialId) {
		boolean found = false;
		for(CartDTO cart : carts){
			if(checkSameProduct(cart.getProductVariant(), productId, colorId, sizeId, materialId)){
				cart.setQuantity(cart.getQuantity() + 1);
				found = true;
				break;
			}
		}

		if(!found){
			ProductVariantDTO productVariant = ProductVariantMapper.INSTANCE.toDTO(productVariantDAO.findByAttributes(productId, colorId, sizeId, materialId));
			carts.add(new CartDTO(productVariant, 1));
		}
	}

	public boolean checkSameProduct(ProductVariantDTO product, Integer productId, Integer colorId, Integer sizeId, Integer materialId) {
        return product.getProductId().equals(productId) && product.getColorId().equals(colorId) &&
                product.getSizeId().equals(sizeId) && materialId.equals(product.getMaterialId());
    }

	public List<CartDTO> getCarts() {
		return this.carts;
	}

	public void setCarts(List<CartDTO> carts) {
		this.carts = carts;
	}

	public void removeItem(Integer productVariantId) {
		for(CartDTO cart : carts){
			if(cart.getProductVariant().getId().equals(productVariantId)){
				carts.remove(cart);
				break;
			}
		}
	}

	public int getTotalQuantity() {
		int totalQuantity = 0;

		for(CartDTO cart : carts){
			totalQuantity += cart.getQuantity();
		}

		return totalQuantity;
	}

	public BigDecimal getTotalAmount() {
		BigDecimal total = BigDecimal.ZERO;

		for (CartDTO cart : carts) {
			BigDecimal price = cart.getProductVariant().getPrice();
			int quantity = cart.getQuantity();
			total = total.add(price.multiply(BigDecimal.valueOf(quantity)));
		}

		return total;
	}

	public void clearCart(){
		carts.clear();
	}

	public void deleteCart(Integer customerId){
		cartDAO.deleteCartByCustomerId(customerId);
	}

	public int getTotalItems() {
		return carts.size();
	}

	public void updateCart(int[] shirtIds, int[] quantities, String[] sizes) {
//		carts.clear();
//		for (int i = 0; i < shirtIds.length; i++) {
//			Shirt shirt = shirtDAO.get(shirtIds[i]);
//			carts.add(new CartDTO(0, shirt, quantities[i], sizes[i]));
//		}
//
//		for(int i = 0; i < carts.size() - 1; i++){
//			for(int j = i + 1; j < carts.size(); j++){
//				if(carts.get(i).getShirt().getShirtId() == carts.get(j).getShirt().getShirtId() && carts.get(i).getSize().equals(carts.get(j).getSize())){
//					carts.get(i).setQuantity(carts.get(i).getQuantity() + carts.get(j).getQuantity());
//					carts.remove(j);
//					j--;
//				}
//			}
//		}
	}
}
