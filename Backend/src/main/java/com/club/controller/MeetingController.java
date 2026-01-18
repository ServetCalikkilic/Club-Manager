package com.club.controller;

import com.club.dto.AttendanceRequest;
import com.club.dto.AttendanceResponse;
import com.club.dto.MeetingRequest;
import com.club.dto.MeetingResponse;
import com.club.service.MeetingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/meetings")
@RequiredArgsConstructor
public class MeetingController {

    private final MeetingService meetingService;

    @PostMapping
    public ResponseEntity<MeetingResponse> createMeeting(
            @Valid @RequestBody MeetingRequest request,
            Authentication authentication) {
        return ResponseEntity.ok(meetingService.createMeeting(request, authentication.getName()));
    }

    @GetMapping
    public ResponseEntity<List<MeetingResponse>> getAllMeetings() {
        return ResponseEntity.ok(meetingService.getAllMeetings());
    }

    @GetMapping("/{id}")
    public ResponseEntity<MeetingResponse> getMeetingById(@PathVariable Long id) {
        return ResponseEntity.ok(meetingService.getMeetingById(id));
    }

    @PostMapping("/{id}/attend")
    public ResponseEntity<AttendanceResponse> updateAttendance(
            @PathVariable Long id,
            @Valid @RequestBody AttendanceRequest request,
            Authentication authentication) {
        return ResponseEntity.ok(meetingService.updateAttendance(id, request, authentication.getName()));
    }

    @GetMapping("/{id}/attendances")
    public ResponseEntity<List<AttendanceResponse>> getMeetingAttendances(@PathVariable Long id) {
        return ResponseEntity.ok(meetingService.getMeetingAttendances(id));
    }
}
