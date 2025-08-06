package com.store.DTO;

import Constant.IconstantFacebook;
import com.google.gson.Gson;

import com.store.Entity.Customer;
import com.store.Service.HashSha_256Service;
import org.apache.http.client.fluent.Content;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import org.json.JSONObject;

import java.io.IOException;

public class CustomerFacebookLogin {
    public String getToken(String code) throws IOException {

        Content content = Request.Post(IconstantFacebook.FACEBOOK_LINK_GET_TOKEN)
                .bodyForm(
                        Form.form()
                                .add("client_id", IconstantFacebook.FACEBOOK_CLIENT_ID)
                                .add("client_secret", IconstantFacebook.FACEBOOK_CLIENT_SECRET)
                                .add("redirect_uri", IconstantFacebook.FACEBOOK_REDIRECT_URI)
                                .add("code", code)
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

        String link = IconstantFacebook.FACEBOOK_LINK_GET_USER_INFO + accessToken;

        String response = Request.Get(link).execute().returnContent().asString();

        // Ánh xạ JSON từ Google vào lớp tạm thời GoogleUser
        FacebookUser facebookUser = new Gson().fromJson(response, FacebookUser.class);

        // Chuyển đổi dữ liệu từ GoogleUser sang Customer

        return convertFacebookUserToCustomer(facebookUser);
    }

    private static Customer convertFacebookUserToCustomer(FacebookUser facebookUser) {
        Customer customer = new Customer();

        customer.setEmail(facebookUser.getEmail());

        if (facebookUser.getName() == null){
            customer.setFirstname("");
            customer.setLastname("");
        }else{
            customer.setFirstname("");
            customer.setLastname(facebookUser.getName());
        }
        String passwordHash = new HashSha_256Service().hashWithSHA256(customer.getEmail());
        customer.setPasswordHash(passwordHash);
//        /* customer.setCountry("VN"); */
//        // Đặt các giá trị mặc định hoặc từ GoogleUser vào các trường khác nếu cần thiết
        customer.setSignUpDate(new java.util.Date());  // Example: setting current date as sign up date
        return customer;
    }
}
