package com.club.dto;

import com.club.entity.Meeting;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class MeetingResponse {
    private Long id;
    private String title;
    private String description;
    private LocalDateTime meetingDate;
    private UserResponse createdBy;
    private LocalDateTime createdAt;

    public MeetingResponse(Meeting meeting) {
        this.id = meeting.getId();
        this.title = meeting.getTitle();
        this.description = meeting.getDescription();
        this.meetingDate = meeting.getMeetingDate();
        this.createdBy = new UserResponse(meeting.getCreatedBy());
        this.createdAt = meeting.getCreatedAt();
    }
}
