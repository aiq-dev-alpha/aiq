<template>
  <article :class="['blog-card', { horizontal }]">
    <div class="card-image">
      <img :src="image" :alt="title" />
      <span class="category-badge">{{ category }}</span>
    </div>
    <div class="card-body">
      <div class="meta">
        <time :datetime="date">{{ formattedDate }}</time>
        <span class="reading-time">{{ readingTime }} min read</span>
      </div>
      <h3 class="card-title">{{ title }}</h3>
      <p class="card-excerpt">{{ excerpt }}</p>
      <div class="card-footer">
        <div class="author">
          <img :src="authorAvatar" :alt="authorName" class="author-avatar" />
          <span class="author-name">{{ authorName }}</span>
        </div>
        <button class="read-more">Read More →</button>
      </div>
    </div>
  </article>
</template>

<script setup lang="ts">
import { computed } from 'vue';

interface Props {
  image: string;
  title: string;
  excerpt: string;
  category: string;
  date: string;
  readingTime: number;
  authorName: string;
  authorAvatar: string;
  horizontal?: boolean;
}

const props = defineProps<Props>();

const formattedDate = computed(() => {
  return new Date(props.date).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric'
  });
});
</script>

<style scoped>
.blog-card {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.blog-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.12);
}

.blog-card.horizontal {
  display: flex;
  flex-direction: row;
}

.card-image {
  position: relative;
  overflow: hidden;
}

.blog-card:not(.horizontal) .card-image {
  height: 240px;
}

.blog-card.horizontal .card-image {
  width: 40%;
  flex-shrink: 0;
}

.card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.blog-card:hover .card-image img {
  transform: scale(1.1);
}

.category-badge {
  position: absolute;
  top: 1rem;
  left: 1rem;
  padding: 0.5rem 1rem;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 20px;
  font-size: 0.75rem;
  font-weight: 700;
  color: #8b5cf6;
}

.card-body {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.meta {
  display: flex;
  gap: 1rem;
  font-size: 0.875rem;
  color: #6b7280;
}

.card-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #111827;
  line-height: 1.3;
  margin: 0;
}

.card-excerpt {
  color: #4b5563;
  line-height: 1.6;
  margin: 0;
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: auto;
}

.author {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.author-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
}

.author-name {
  font-weight: 600;
  color: #374151;
}

.read-more {
  padding: 0.5rem 1rem;
  background: transparent;
  border: none;
  color: #8b5cf6;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.read-more:hover {
  transform: translateX(4px);
}
</style>