package com.club.dto;

import com.club.entity.Task;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class TaskResponse {
    private Long id;
    private String title;
    private String description;
    private Task.TaskStatus status;
    private UserResponse assignedTo;
    private Long eventId;
    private LocalDateTime createdAt;

    public TaskResponse(Task task) {
        this.id = task.getId();
        this.title = task.getTitle();
        this.description = task.getDescription();
        this.status = task.getStatus();
        this.assignedTo = task.getAssignedTo() != null ? new UserResponse(task.getAssignedTo()) : null;
        this.eventId = task.getEvent() != null ? task.getEvent().getId() : null;
        this.createdAt = task.getCreatedAt();
    }
}
