package com.club.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class EventRequest {
    @NotBlank(message = "Title is required")
    private String title;

    private String description;
    private LocalDateTime eventDate;
}
