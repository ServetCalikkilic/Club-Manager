package com.club.repository;

import com.club.entity.Channel;
import com.club.entity.Message;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {
    List<Message> findByChannelOrderByCreatedAtDesc(Channel channel, Pageable pageable);

    List<Message> findByChannelAndCreatedAtAfterOrderByCreatedAtAsc(Channel channel, LocalDateTime after);
}
