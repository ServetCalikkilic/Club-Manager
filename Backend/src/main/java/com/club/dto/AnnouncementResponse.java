package com.club.dto;

import com.club.entity.Announcement;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class AnnouncementResponse {
    private Long id;
    private String title;
    private String content;
    private UserResponse author;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public AnnouncementResponse(Announcement announcement) {
        this.id = announcement.getId();
        this.title = announcement.getTitle();
        this.content = announcement.getContent();
        this.author = new UserResponse(announcement.getAuthor());
        this.createdAt = announcement.getCreatedAt();
        this.updatedAt = announcement.getUpdatedAt();
    }
}
