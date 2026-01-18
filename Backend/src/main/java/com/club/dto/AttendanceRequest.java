package com.club.dto;

import com.club.entity.Attendance;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class AttendanceRequest {
    @NotNull(message = "Status is required")
    private Attendance.AttendanceStatus status;
}
