package com.club.dto;

import com.club.entity.Message;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class MessageResponse {
    private Long id;
    private String content;
    private UserResponse user;
    private LocalDateTime createdAt;

    public MessageResponse(Message message) {
        this.id = message.getId();
        this.content = message.getContent();
        this.user = new UserResponse(message.getUser());
        this.createdAt = message.getCreatedAt();
    }
}
