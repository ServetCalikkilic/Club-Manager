package com.club.service;

import com.club.dto.EventRequest;
import com.club.dto.EventResponse;
import com.club.entity.Event;
import com.club.repository.EventRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class EventService {

    private final EventRepository eventRepository;

    @Transactional
    public EventResponse createEvent(EventRequest request) {
        Event event = new Event();
        event.setTitle(request.getTitle());
        event.setDescription(request.getDescription());
        event.setEventDate(request.getEventDate());

        event = eventRepository.save(event);
        return new EventResponse(event);
    }

    public List<EventResponse> getAllEvents() {
        return eventRepository.findAllByOrderByEventDateDesc()
                .stream()
                .map(EventResponse::new)
                .collect(Collectors.toList());
    }

    public EventResponse getEventById(Long id) {
        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Event not found"));
        return new EventResponse(event);
    }
}
