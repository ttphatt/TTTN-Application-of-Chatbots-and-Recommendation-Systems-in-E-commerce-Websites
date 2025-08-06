package com.store.DAO;

import com.store.Entity.Message;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MessageDAO extends JPADAO<Message> implements GenericDAO<Message>{
    public MessageDAO() {}

    @Override
    public Message get(Object id) {
        return super.find(Message.class, id);
    }

    @Override
    public void delete(Object id) {
        super.delete(Message.class, id);
    }

    @Override
    public List<Message> listAll() {
        return null;
    }

    @Override
    public long count() {
        return 0;
    }

    public Message create(Message message) {
        message.setTime(new Timestamp(System.currentTimeMillis()));
        return super.create(message);
    }

    public List<Message> getMessageHistory(String sender, String receiver) {
        Map<String, Object> params = new HashMap<>();
        params.put("u1", sender);
        params.put("u2", receiver);

        List<Message> res = super.findWithNamedQuery("Message.GetMessageHistory", params);

        if(!res.isEmpty()) {
            return res;
        }

        return null;
    }
}
