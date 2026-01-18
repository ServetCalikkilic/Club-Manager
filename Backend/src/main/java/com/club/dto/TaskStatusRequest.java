package com.club.dto;

import com.club.entity.Task;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class TaskStatusRequest {
    @NotNull(message = "Status is required")
    private Task.TaskStatus status;
}
