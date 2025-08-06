package com.store.Entity;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "chat_sessions")
public class ChatSession {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "started_at")
    private Date startedAt;

    @Column(name = "ended_at")
    private Date endedAt;

    @Enumerated(EnumType.STRING)
    private SessionStatus status;

    @Column(name = "last_intent")
    private String lastIntent;

    public enum SessionStatus {
        OPEN, CLOSED
    }

    public ChatSession() {}

    public ChatSession(Integer id, Date startedAt, Date endedAt, SessionStatus status, String lastIntent) {
        this.id = id;
        this.startedAt = startedAt;
        this.endedAt = endedAt;
        this.status = status;
        this.lastIntent = lastIntent;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Date getEndedAt() {
        return endedAt;
    }

    public void setEndedAt(Date endedAt) {
        this.endedAt = endedAt;
    }

    public Date getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(Date startedAt) {
        this.startedAt = startedAt;
    }

    public SessionStatus getStatus() {
        return status;
    }

    public void setStatus(SessionStatus status) {
        this.status = status;
    }

    public String getLastIntent() {
        return lastIntent;
    }

    public void setLastIntent(String lastIntent) {
        this.lastIntent = lastIntent;
    }
}
