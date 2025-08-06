package com.store.Entity;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "chatbot_messages")
public class ChatbotMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;


    @Column(name = "session_id")
    private Integer sessionId;

    @Column(name = "sender_id")
    private Integer senderId;

    @Enumerated(EnumType.STRING)
    private MessageType type;

    private String content;
    private String intent;
    private String entities;
    private Date time;

    public enum MessageType {
        QUESTION, ANSWER
    }

    public ChatbotMessage() {}

    public ChatbotMessage(Integer id, Integer sessionId, Integer senderId, MessageType type, String content, String entities, Date time, String intent) {
        this.id = id;
        this.sessionId = sessionId;
        this.senderId = senderId;
        this.type = type;
        this.content = content;
        this.entities = entities;
        this.time = time;
        this.intent = intent;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getSession() {
        return sessionId;
    }

    public void setSession(Integer sessionId) {
        this.sessionId = sessionId;
    }

    public Integer getSenderId() {
        return senderId;
    }

    public void setSenderId(Integer senderId) {
        this.senderId = senderId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public MessageType getType() {
        return type;
    }

    public void setType(MessageType type) {
        this.type = type;
    }

    public String getIntent() {
        return intent;
    }

    public void setIntent(String intent) {
        this.intent = intent;
    }

    public String getEntities() {
        return entities;
    }

    public void setEntities(String entities) {
        this.entities = entities;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }
}
