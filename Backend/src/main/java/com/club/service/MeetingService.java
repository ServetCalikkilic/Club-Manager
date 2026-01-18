package com.club.service;

import com.club.dto.AttendanceRequest;
import com.club.dto.AttendanceResponse;
import com.club.dto.MeetingRequest;
import com.club.dto.MeetingResponse;
import com.club.entity.Attendance;
import com.club.entity.Meeting;
import com.club.entity.User;
import com.club.repository.AttendanceRepository;
import com.club.repository.MeetingRepository;
import com.club.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MeetingService {

    private final MeetingRepository meetingRepository;
    private final AttendanceRepository attendanceRepository;
    private final UserRepository userRepository;

    @Transactional
    public MeetingResponse createMeeting(MeetingRequest request, String username) {
        User creator = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        Meeting meeting = new Meeting();
        meeting.setTitle(request.getTitle());
        meeting.setDescription(request.getDescription());
        meeting.setMeetingDate(request.getMeetingDate());
        meeting.setCreatedBy(creator);

        meeting = meetingRepository.save(meeting);
        return new MeetingResponse(meeting);
    }

    public List<MeetingResponse> getAllMeetings() {
        return meetingRepository.findAllByOrderByMeetingDateDesc()
                .stream()
                .map(MeetingResponse::new)
                .collect(Collectors.toList());
    }

    public MeetingResponse getMeetingById(Long id) {
        Meeting meeting = meetingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Meeting not found"));
        return new MeetingResponse(meeting);
    }

    @Transactional
    public AttendanceResponse updateAttendance(Long meetingId, AttendanceRequest request, String username) {
        Meeting meeting = meetingRepository.findById(meetingId)
                .orElseThrow(() -> new RuntimeException("Meeting not found"));

        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        Attendance attendance = attendanceRepository.findByMeetingAndUser(meeting, user)
                .orElse(new Attendance());

        attendance.setMeeting(meeting);
        attendance.setUser(user);
        attendance.setStatus(request.getStatus());

        attendance = attendanceRepository.save(attendance);
        return new AttendanceResponse(attendance);
    }

    public List<AttendanceResponse> getMeetingAttendances(Long meetingId) {
        Meeting meeting = meetingRepository.findById(meetingId)
                .orElseThrow(() -> new RuntimeException("Meeting not found"));

        return attendanceRepository.findByMeeting(meeting)
                .stream()
                .map(AttendanceResponse::new)
                .collect(Collectors.toList());
    }
}
