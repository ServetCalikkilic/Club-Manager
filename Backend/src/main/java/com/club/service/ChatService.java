package com.club.service;

import com.club.dto.MessageRequest;
import com.club.dto.MessageResponse;
import com.club.entity.Channel;
import com.club.entity.Message;
import com.club.entity.User;
import com.club.repository.ChannelRepository;
import com.club.repository.MessageRepository;
import com.club.repository.UserRepository;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final MessageRepository messageRepository;
    private final ChannelRepository channelRepository;
    private final UserRepository userRepository;

    @PostConstruct
    public void init() {
        // Create #general channel if it doesn't exist
        if (channelRepository.findByName("general").isEmpty()) {
            Channel channel = new Channel();
            channel.setName("general");
            channelRepository.save(channel);
        }
    }

    @Transactional
    public MessageResponse sendMessage(MessageRequest request, String username) {
        Channel channel = channelRepository.findByName("general")
                .orElseThrow(() -> new RuntimeException("Channel not found"));

        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        Message message = new Message();
        message.setChannel(channel);
        message.setUser(user);
        message.setContent(request.getContent());

        message = messageRepository.save(message);
        return new MessageResponse(message);
    }

    public List<MessageResponse> getMessages(int limit) {
        Channel channel = channelRepository.findByName("general")
                .orElseThrow(() -> new RuntimeException("Channel not found"));

        return messageRepository.findByChannelOrderByCreatedAtDesc(channel, PageRequest.of(0, limit))
                .stream()
                .map(MessageResponse::new)
                .collect(Collectors.toList());
    }

    public List<MessageResponse> getLatestMessages(LocalDateTime after) {
        Channel channel = channelRepository.findByName("general")
                .orElseThrow(() -> new RuntimeException("Channel not found"));

        return messageRepository.findByChannelAndCreatedAtAfterOrderByCreatedAtAsc(channel, after)
                .stream()
                .map(MessageResponse::new)
                .collect(Collectors.toList());
    }
}
