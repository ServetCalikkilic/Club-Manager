package com.club.repository;

import com.club.entity.Attendance;
import com.club.entity.Meeting;
import com.club.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, Long> {
    Optional<Attendance> findByMeetingAndUser(Meeting meeting, User user);

    List<Attendance> findByMeeting(Meeting meeting);

    List<Attendance> findByUser(User user);
}
