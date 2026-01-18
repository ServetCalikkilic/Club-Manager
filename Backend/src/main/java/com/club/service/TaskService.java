package com.club.service;

import com.club.dto.TaskRequest;
import com.club.dto.TaskResponse;
import com.club.dto.TaskStatusRequest;
import com.club.entity.Event;
import com.club.entity.Task;
import com.club.entity.User;
import com.club.repository.EventRepository;
import com.club.repository.TaskRepository;
import com.club.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TaskService {

    private final TaskRepository taskRepository;
    private final UserRepository userRepository;
    private final EventRepository eventRepository;

    @Transactional
    public TaskResponse createTask(TaskRequest request) {
        Task task = new Task();
        task.setTitle(request.getTitle());
        task.setDescription(request.getDescription());
        task.setStatus(request.getStatus() != null ? request.getStatus() : Task.TaskStatus.TODO);

        if (request.getAssignedToId() != null) {
            User assignedUser = userRepository.findById(request.getAssignedToId())
                    .orElseThrow(() -> new RuntimeException("User not found"));
            task.setAssignedTo(assignedUser);
        }

        if (request.getEventId() != null) {
            Event event = eventRepository.findById(request.getEventId())
                    .orElseThrow(() -> new RuntimeException("Event not found"));
            task.setEvent(event);
        }

        task = taskRepository.save(task);
        return new TaskResponse(task);
    }

    public List<TaskResponse> getAllTasks() {
        return taskRepository.findAllByOrderByCreatedAtDesc()
                .stream()
                .map(TaskResponse::new)
                .collect(Collectors.toList());
    }

    public List<TaskResponse> getTasksByStatus(Task.TaskStatus status) {
        return taskRepository.findByStatus(status)
                .stream()
                .map(TaskResponse::new)
                .collect(Collectors.toList());
    }

    @Transactional
    public TaskResponse updateTaskStatus(Long id, TaskStatusRequest request) {
        Task task = taskRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Task not found"));

        task.setStatus(request.getStatus());
        task = taskRepository.save(task);

        return new TaskResponse(task);
    }
}
