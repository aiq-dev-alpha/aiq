package com.example.template.service;

import com.example.template.dto.PostRequest;
import com.example.template.dto.PostResponse;
import com.example.template.entity.Post;
import com.example.template.entity.User;
import com.example.template.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class PostService {

    @Autowired
    private PostRepository postRepository;

    @Transactional(readOnly = true)
    public Page<PostResponse> getAllPosts(Pageable pageable) {
        return postRepository.findAllWithAuthor(pageable)
                .map(PostResponse::new);
    }

    @Transactional(readOnly = true)
    public PostResponse getPostById(Long id) {
        Post post = postRepository.findByIdWithAuthor(id)
                .orElseThrow(() -> new RuntimeException("Post not found with id: " + id));
        return new PostResponse(post);
    }

    public PostResponse createPost(PostRequest postRequest, User author) {
        Post post = new Post(postRequest.getTitle(), postRequest.getContent(), author);
        Post savedPost = postRepository.save(post);

        // Fetch with author to ensure it's loaded
        return postRepository.findByIdWithAuthor(savedPost.getId())
                .map(PostResponse::new)
                .orElseThrow(() -> new RuntimeException("Error retrieving created post"));
    }

    public PostResponse updatePost(Long id, PostRequest postRequest, User currentUser) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Post not found with id: " + id));

        if (!post.getAuthor().getId().equals(currentUser.getId())) {
            throw new RuntimeException("You can only update your own posts");
        }

        post.setTitle(postRequest.getTitle());
        post.setContent(postRequest.getContent());

        Post savedPost = postRepository.save(post);

        // Fetch with author to ensure it's loaded
        return postRepository.findByIdWithAuthor(savedPost.getId())
                .map(PostResponse::new)
                .orElseThrow(() -> new RuntimeException("Error retrieving updated post"));
    }

    public void deletePost(Long id, User currentUser) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Post not found with id: " + id));

        if (!post.getAuthor().getId().equals(currentUser.getId())) {
            throw new RuntimeException("You can only delete your own posts");
        }

        postRepository.delete(post);
    }
}