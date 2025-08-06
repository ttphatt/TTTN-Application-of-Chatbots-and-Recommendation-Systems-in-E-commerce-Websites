package com.store.DTO;

import Constant.Iconstant;
import com.google.gson.Gson;

import com.store.Entity.Customer;
import com.store.Service.HashSha_256Service;
import org.apache.http.client.fluent.Content;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import org.json.JSONObject;

import java.io.IOException;

public class CustomerGoogleLogin {
    public String getToken(String code) throws IOException {

        Content content = Request.Post(Iconstant.GOOGLE_LINK_GET_TOKEN)
                .bodyForm(
                        Form.form()
                                .add("client_id", Iconstant.GOOGLE_CLIENT_ID)
                                .add("client_secret", Iconstant.GOOGLE_CLIENT_SECRET)
                                .add("redirect_uri", Iconstant.GOOGLE_REDIRECT_URI)
                                .add("code", code)
                                .add("grant_type", Iconstant.GOOGLE_GRANT_TYPE)
                                .build()
                )
                .execute()
                .returnContent();

        String responseString = content.asString();

        // Chuyển đổi phản hồi JSON sử dụng org.json
        JSONObject jsonObj = new JSONObject(responseString);

        if (jsonObj.has("access_token")) {
            return jsonObj.getString("access_token");
        } else {
            return null;
        }
    }
    
    public static Customer getUserInfo(final String accessToken) throws IOException {

    	String link = Iconstant.GOOGLE_LINK_GET_USER_INFO + accessToken;

        String response = Request.Get(link).execute().returnContent().asString();

        // Ánh xạ JSON từ Google vào lớp tạm thời GoogleUser
        GoogleUser googleUser = new Gson().fromJson(response, GoogleUser.class);

        // Chuyển đổi dữ liệu từ GoogleUser sang Customer

        return convertGoogleUserToCustomer(googleUser);
    }
    
    private static Customer convertGoogleUserToCustomer(GoogleUser googleUser) {
        Customer customer = new Customer();
        customer.setEmail(googleUser.getEmail());

        if (googleUser.getGiven_name() == null){
            customer.setFirstname("");
        }else{
            customer.setFirstname(googleUser.getGiven_name());
        }

        if (googleUser.getFamily_name() == null){
            customer.setLastname("");
        }else{
            customer.setLastname(googleUser.getFamily_name());
        }
        String passwordHash = new HashSha_256Service().hashWithSHA256(customer.getEmail());
        customer.setPasswordHash(passwordHash);
		/* customer.setCountry("VN"); */
        // Đặt các giá trị mặc định hoặc từ GoogleUser vào các trường khác nếu cần thiết
        customer.setSignUpDate(new java.util.Date());  // Example: setting current date as sign up date
        return customer;
    }
}
