package com.club.dto;

import com.club.entity.Task;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class TaskRequest {
    @NotBlank(message = "Title is required")
    private String title;

    private String description;
    private Task.TaskStatus status = Task.TaskStatus.TODO;
    private Long assignedToId;
    private Long eventId;
}
