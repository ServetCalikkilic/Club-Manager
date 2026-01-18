package com.club.controller;

import com.club.dto.AnnouncementRequest;
import com.club.dto.AnnouncementResponse;
import com.club.service.AnnouncementService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/announcements")
@RequiredArgsConstructor
public class AnnouncementController {

    private final AnnouncementService announcementService;

    @PostMapping
    public ResponseEntity<AnnouncementResponse> createAnnouncement(
            @Valid @RequestBody AnnouncementRequest request,
            Authentication authentication) {
        return ResponseEntity.ok(announcementService.createAnnouncement(request, authentication.getName()));
    }

    @GetMapping
    public ResponseEntity<List<AnnouncementResponse>> getAllAnnouncements() {
        return ResponseEntity.ok(announcementService.getAllAnnouncements());
    }

    @GetMapping("/{id}")
    public ResponseEntity<AnnouncementResponse> getAnnouncementById(@PathVariable Long id) {
        return ResponseEntity.ok(announcementService.getAnnouncementById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<AnnouncementResponse> updateAnnouncement(
            @PathVariable Long id,
            @Valid @RequestBody AnnouncementRequest request,
            Authentication authentication) {
        return ResponseEntity.ok(announcementService.updateAnnouncement(id, request, authentication.getName()));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteAnnouncement(
            @PathVariable Long id,
            Authentication authentication) {
        announcementService.deleteAnnouncement(id, authentication.getName());
        return ResponseEntity.noContent().build();
    }
}
