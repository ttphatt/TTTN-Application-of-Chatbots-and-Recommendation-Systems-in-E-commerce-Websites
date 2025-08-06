package com.store.DAO;

import com.store.Entity.User;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserDAO extends JPADAO<User> implements GenericDAO<User> {
	
	public UserDAO() {}
	
	//Thêm 1 user mới
	public User create(User user) {
		return super.create(user);
	}
	
	//Cập nhật user
	@Override
	public User update(User user) {
		return super.update(user);
	}

	//Lấy user ra
	@Override
	public User get(Object userId) {
		return super.find(User.class, userId);
	}

	//Xóa user
	@Override
	public void delete(Object userId) {
		super.delete(User.class, userId);
	}

	//Lấy ra tập các user
	@Override
	public List<User> listAll() {
		return super.findWithNamedQuery("User.findAll");
	}

	//Đếm số lượng user
	@Override
	public long count() {
		return super.countWithNamedQuery("User.countAll");
	}
	
	//Tìm user theo email
	public User findByEmail(String email) {
		List<User> listUsers = super.findWithNamedQuery("User.findByEmail", "email", email);
		
		if(listUsers != null && !listUsers.isEmpty()) {
			return listUsers.getFirst();
		}
		return null;
	}

	//Kiểm tra user này đã có tài khoản trong database hay chưa
	public boolean checkLogin(String email, String password) {
		Map<String, Object>param = new HashMap<>();
		param.put("email", email);
		param.put("password", password);
		
		List<User> listUsers = super.findWithNamedQuery("User.checkLogin", param);

        return listUsers.size() == 1;
    }

	public User getReference(Integer userId) {
		return super.getReference(User.class, userId);
	}
}
