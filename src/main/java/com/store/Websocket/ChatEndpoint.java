package com.store.Websocket;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.store.DAO.MessageDAO;
import com.store.Entity.Message;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/chat/{username}")
public class ChatEndpoint {
    private static final Map<String, Session> sessions = new ConcurrentHashMap<>();
    private static final com.store.DAO.MessageDAO messageDAO = new MessageDAO();

    @OnOpen
    public void onOpen(Session session, @PathParam("username") String username) {
        sessions.put(username, session);
//        System.out.println(">> " + username + " connected.");
    }

    @OnClose
    public void onClose(Session session, @PathParam("username") String username) {
        sessions.remove(username);
//        System.out.println(">> " + username + " disconnected.");
    }

    @OnMessage
    public void onMessage(String jsonMessage, Session session, @PathParam("username") String username) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            Message message = mapper.readValue(jsonMessage, Message.class);

            // Gửi tin nhắn cho người nhận (nếu online)
            Session receiverSession = sessions.get(message.getReceiver());

            String msgJson = mapper.writeValueAsString(message);  // Convert lại thành JSON string

            if (receiverSession != null && receiverSession.isOpen()) {
                receiverSession.getAsyncRemote().sendText(msgJson);
            }

            // Gửi lại cho người gửi (echo)
            if (session != null && session.isOpen()) {
                session.getAsyncRemote().sendText(msgJson);
            }

            // Lưu vào DB
            new Thread(() -> {
                messageDAO.create(message);
            }).start();

        } catch (IOException e) {

            try {
                session.getAsyncRemote().sendText("❌ Lỗi định dạng tin nhắn.");
            } catch (Exception ignored) {

            }
        }
    }
}
