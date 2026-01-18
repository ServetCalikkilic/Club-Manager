package com.club.dto;

import com.club.entity.Attendance;
import lombok.Data;

@Data
public class AttendanceResponse {
    private Long id;
    private Long meetingId;
    private UserResponse user;
    private Attendance.AttendanceStatus status;

    public AttendanceResponse(Attendance attendance) {
        this.id = attendance.getId();
        this.meetingId = attendance.getMeeting().getId();
        this.user = new UserResponse(attendance.getUser());
        this.status = attendance.getStatus();
    }
}
