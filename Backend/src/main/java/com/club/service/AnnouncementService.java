package com.club.service;

import com.club.dto.AnnouncementRequest;
import com.club.dto.AnnouncementResponse;
import com.club.entity.Announcement;
import com.club.entity.User;
import com.club.repository.AnnouncementRepository;
import com.club.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AnnouncementService {

    private final AnnouncementRepository announcementRepository;
    private final UserRepository userRepository;

    @Transactional
    public AnnouncementResponse createAnnouncement(AnnouncementRequest request, String username) {
        User author = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        Announcement announcement = new Announcement();
        announcement.setTitle(request.getTitle());
        announcement.setContent(request.getContent());
        announcement.setAuthor(author);

        announcement = announcementRepository.save(announcement);
        return new AnnouncementResponse(announcement);
    }

    public List<AnnouncementResponse> getAllAnnouncements() {
        return announcementRepository.findAllByOrderByCreatedAtDesc()
                .stream()
                .map(AnnouncementResponse::new)
                .collect(Collectors.toList());
    }

    public AnnouncementResponse getAnnouncementById(Long id) {
        Announcement announcement = announcementRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Announcement not found"));
        return new AnnouncementResponse(announcement);
    }

    @Transactional
    public AnnouncementResponse updateAnnouncement(Long id, AnnouncementRequest request, String username) {
        Announcement announcement = announcementRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Announcement not found"));

        // Check if user is the author or admin
        if (!announcement.getAuthor().getUsername().equals(username)) {
            User user = userRepository.findByUsername(username)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));
            if (user.getRole() != User.UserRole.ADMIN) {
                throw new RuntimeException("Unauthorized to update this announcement");
            }
        }

        announcement.setTitle(request.getTitle());
        announcement.setContent(request.getContent());

        announcement = announcementRepository.save(announcement);
        return new AnnouncementResponse(announcement);
    }

    @Transactional
    public void deleteAnnouncement(Long id, String username) {
        Announcement announcement = announcementRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Announcement not found"));

        // Check if user is the author or admin
        if (!announcement.getAuthor().getUsername().equals(username)) {
            User user = userRepository.findByUsername(username)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));
            if (user.getRole() != User.UserRole.ADMIN) {
                throw new RuntimeException("Unauthorized to delete this announcement");
            }
        }

        announcementRepository.delete(announcement);
    }
}
