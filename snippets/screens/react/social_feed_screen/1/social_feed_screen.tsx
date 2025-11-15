import React, { useState } from 'react';

interface Post {
  id: string;
  author: string;
  content: string;
  likes: number;
  comments: number;
  timestamp: string;
}

const posts: Post[] = [
  { id: '1', author: 'John Doe', content: 'Just launched my new project! 🚀', likes: 42, comments: 5, timestamp: '2h ago' },
  { id: '2', author: 'Jane Smith', content: 'Beautiful sunset today 🌅', likes: 128, comments: 12, timestamp: '4h ago' },
  { id: '3', author: 'Bob Wilson', content: 'Great coffee this morning ☕', likes: 23, comments: 3, timestamp: '6h ago' }
];

export const SocialFeedScreen: React.FC = () => {
  const [likedPosts, setLikedPosts] = useState<Set<string>>(new Set());

  const toggleLike = (postId: string) => {
    setLikedPosts(prev => {
      const updated = new Set(prev);
      if (updated.has(postId)) {
        updated.delete(postId);
      } else {
        updated.add(postId);
      }
      return updated;
    });
  };

  return (
    <div style={{ minHeight: '100vh', backgroundColor: '#f9fafb', padding: '2rem', fontFamily: 'system-ui, sans-serif' }}>
      <h1 style={{ fontSize: '2rem', fontWeight: 700, marginBottom: '2rem' }}>Feed</h1>

      <div style={{ maxWidth: '600px', margin: '0 auto' }}>
        {posts.map(post => (
          <div key={post.id} style={{
            backgroundColor: '#fff',
            borderRadius: '0.75rem',
            padding: '1.5rem',
            marginBottom: '1.5rem',
            boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
          }}>
            <div style={{ display: 'flex', alignItems: 'center', marginBottom: '1rem' }}>
              <div style={{
                width: '48px',
                height: '48px',
                borderRadius: '50%',
                backgroundColor: '#3b82f6',
                marginRight: '1rem'
              }} />
              <div>
                <div style={{ fontWeight: 600 }}>{post.author}</div>
                <div style={{ fontSize: '0.875rem', color: '#6b7280' }}>{post.timestamp}</div>
              </div>
            </div>

            <p style={{ marginBottom: '1rem', fontSize: '1rem', lineHeight: 1.6 }}>{post.content}</p>

            <div style={{ display: 'flex', gap: '2rem', paddingTop: '1rem', borderTop: '1px solid #e5e7eb' }}>
              <button
                onClick={() => toggleLike(post.id)}
                style={{
                  background: 'none',
                  border: 'none',
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '0.5rem',
                  color: likedPosts.has(post.id) ? '#ef4444' : '#6b7280'
                }}
              >
                {likedPosts.has(post.id) ? '❤️' : '🤍'} {post.likes + (likedPosts.has(post.id) ? 1 : 0)}
              </button>
              <button style={{ background: 'none', border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '0.5rem', color: '#6b7280' }}>
                💬 {post.comments}
              </button>
              <button style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#6b7280' }}>
                🔗 Share
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
