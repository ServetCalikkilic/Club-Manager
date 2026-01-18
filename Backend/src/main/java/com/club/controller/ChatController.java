package com.club.controller;

import com.club.dto.MessageRequest;
import com.club.dto.MessageResponse;
import com.club.service.ChatService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

    @PostMapping("/messages")
    public ResponseEntity<MessageResponse> sendMessage(
            @Valid @RequestBody MessageRequest request,
            Authentication authentication) {
        return ResponseEntity.ok(chatService.sendMessage(request, authentication.getName()));
    }

    @GetMapping("/messages")
    public ResponseEntity<List<MessageResponse>> getMessages(
            @RequestParam(defaultValue = "50") int limit) {
        return ResponseEntity.ok(chatService.getMessages(limit));
    }

    @GetMapping("/messages/latest")
    public ResponseEntity<List<MessageResponse>> getLatestMessages(
            @RequestParam String after) {
        LocalDateTime afterTime = LocalDateTime.parse(after);
        return ResponseEntity.ok(chatService.getLatestMessages(afterTime));
    }
}
