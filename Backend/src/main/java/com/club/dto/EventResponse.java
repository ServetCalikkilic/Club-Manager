package com.club.dto;

import com.club.entity.Event;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class EventResponse {
    private Long id;
    private String title;
    private String description;
    private LocalDateTime eventDate;
    private LocalDateTime createdAt;

    public EventResponse(Event event) {
        this.id = event.getId();
        this.title = event.getTitle();
        this.description = event.getDescription();
        this.eventDate = event.getEventDate();
        this.createdAt = event.getCreatedAt();
    }
}
