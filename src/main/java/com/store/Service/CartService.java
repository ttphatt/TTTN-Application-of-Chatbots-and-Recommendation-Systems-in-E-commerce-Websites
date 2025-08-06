package com.store.Service;

import com.store.DAO.*;
import com.store.DTO.CartDTO;
import com.store.DTO.ShoppingCart;
import com.store.Entity.Cart;
import com.store.Entity.Customer;
import com.store.Mapper.CartMapper;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

public class CartService {
    private final HttpServletRequest request;
    private final HttpServletResponse response;
    private final CartDAO cartDAO;
    private final ProductVariantDAO productVariantDAO;
    private final CustomerDAO customerDAO;


    public CartService(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
        this.cartDAO = new CartDAO();
        this.productVariantDAO = new ProductVariantDAO();
        this.customerDAO = new CustomerDAO();
    }

    public void saveCart(int customerId) {
        ShoppingCart shoppingCart = (ShoppingCart) request.getSession().getAttribute("cart");

        if (shoppingCart == null) {
            shoppingCart = new ShoppingCart();
        }

        List<Cart> carts = cartDAO.getCartsByCustomerId(customerId);
        Map<Integer, Cart> cartMap = new HashMap<>();
        for (Cart cart : carts) {
            cartMap.put(cart.getProductVariant().getId(), cart);
        }

        for (CartDTO cartDTO : shoppingCart.getCarts()) {
            int variantId = cartDTO.getProductVariant().getId();
            Cart existingCart = cartMap.get(variantId);

            if (existingCart != null) {
                if (existingCart.getQuantity() != cartDTO.getQuantity()) {
                    existingCart.setQuantity(cartDTO.getQuantity());
                    cartDAO.update(existingCart);
                }
            } else {
                Cart newCart = new Cart();
                newCart.setCustomer(customerDAO.getReference(customerId));
                newCart.setProductVariant(productVariantDAO.getReference(variantId));
                newCart.setQuantity(cartDTO.getQuantity());
                cartDAO.createWithMerge(newCart);
            }
        }

        List<CartDTO> cartDTOs = CartMapper.INSTANCE.toDTOList(cartDAO.getCartsByCustomerId(customerId));
        shoppingCart.setCarts(cartDTOs);

        request.getSession().setAttribute("cart", shoppingCart);
    }

    public void updateCate() throws IOException {
        Customer customer = (Customer) request.getSession().getAttribute("loggedCustomer");
        ShoppingCart shoppingCart = (ShoppingCart) request.getSession().getAttribute("cart");
        String[] variantIds = request.getParameterValues("productVariantId");
        String[] quantities = request.getParameterValues("quantity");

        Map<Integer, Integer> variantMap = new HashMap<>();

        for (int i = 0; i < variantIds.length; i++) {
            try {
                variantMap.put(Integer.parseInt(variantIds[i]), Integer.parseInt(quantities[i]));
            } catch (NumberFormatException ignored) {

            }
        }

        List<Cart> carts = cartDAO.getCartsByCustomerId(customer.getId());
        for (Cart cart : carts) {
            int variantId = cart.getProductVariant().getId();
            if (variantMap.containsKey(variantId)) {
                if (cart.getQuantity() != variantMap.get(variantId)) {
                    cart.setQuantity(variantMap.get(variantId));
                    cartDAO.update(cart);
                }
            }
        }

        for (CartDTO cartDTO : shoppingCart.getCarts()) {
            int variantId = cartDTO.getProductVariant().getId();
            if (variantMap.containsKey(variantId)) {
                cartDTO.setQuantity(variantMap.get(variantId));
            }
        }

        String cartPage = request.getContextPath().concat("/view_cart");
        response.sendRedirect(cartPage);
    }

    public void handleCart(int customerId,String action) throws ServletException, IOException {
        if ("save".equals(action)) {
            saveCart(customerId);
        }else {
            Map<String, Object> parameters = new HashMap<>();
            parameters.put("customerId", customerId);
            List<CartDTO> list =  CartMapper.INSTANCE.toDTOList(cartDAO.findWithNamedQuery("Cart.findAllByCustomerId", parameters));

            ShoppingCart shoppingCart = new ShoppingCart();
            shoppingCart.setCarts(list);
            request.getSession().setAttribute("cart", shoppingCart);
        }

        String profilePath = "frontend/customer_profile.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(profilePath);
        requestDispatcher.forward(request, response);
    }

    public void viewCart() throws ServletException, IOException {
        HttpSession session = request.getSession();
        ShoppingCart cart = (ShoppingCart) session.getAttribute("cart");

        if (cart == null) {
            cart = new ShoppingCart();
            session.setAttribute("cart", cart);

            Customer customer = (Customer) session.getAttribute("loggedCustomer");

            if(customer != null) {
                saveCart(customer.getId());
            }
        }

        request.setAttribute("cart", cart);

        String path = "frontend/cart.jsp";
        RequestDispatcher requestDispatcher = request.getRequestDispatcher(path);
        requestDispatcher.forward(request, response);
    }

    public void clearCart() throws IOException {
        ShoppingCart cart = (ShoppingCart) request.getSession().getAttribute("cart");
        Customer customer = (Customer) request.getSession().getAttribute("loggedCustomer");

        cart.clearCart();
        if (customer != null) {
            cart.deleteCart(customer.getId());
        }

        String cartPage = request.getContextPath().concat("/view_cart");
        response.sendRedirect(cartPage);
    }

    public void addProduct() throws IOException {
        Integer productId = Integer.valueOf(request.getParameter("productId"));
        Integer colorId = Integer.valueOf(request.getParameter("colorId"));
        Integer sizeId = Integer.valueOf(request.getParameter("sizeId"));
        Integer materialId = Integer.valueOf(request.getParameter("materialId"));

        ShoppingCart cart = (ShoppingCart) request.getSession().getAttribute("cart");
        if (cart == null) {
            cart = new ShoppingCart();
        }

        cart.addItem(productId, colorId, sizeId, materialId);
        request.getSession().setAttribute("cart", cart);

        Customer customer = (Customer) request.getSession().getAttribute("loggedCustomer");

        if(customer != null) {
            // Will Optimize later
            saveCart(customer.getId());
        }

        String cartPage = request.getContextPath().concat("/view_cart");
        response.sendRedirect(cartPage);
    }

    public void removeProduct() throws IOException {
        Integer productVariantId = Integer.valueOf(request.getParameter("productVariantId"));

        ShoppingCart cart = (ShoppingCart) request.getSession().getAttribute("cart");

        cart.removeItem(productVariantId);

        Customer customer = (Customer) request.getSession().getAttribute("loggedCustomer");
        if(customer != null) {
            cartDAO.deleteByUniqueKey(customer.getId(), productVariantId);
        }

        String cartPage = request.getContextPath().concat("/view_cart");
        response.sendRedirect(cartPage);
    }
}
