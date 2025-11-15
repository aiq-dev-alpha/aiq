<template>
  <div class="testimonial-card">
    <div class="quote-icon">"</div>
    <p class="testimonial-text">{{ text }}</p>
    <div class="rating">
      <span v-for="i in rating" :key="i" class="star">★</span>
    </div>
    <div class="author">
      <img :src="avatar" :alt="name" class="avatar" />
      <div>
        <div class="name">{{ name }}</div>
        <div class="role">{{ role }}</div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  text: string;
  name: string;
  role: string;
  avatar: string;
  rating: number;
}>();
</script>

<style scoped>
.testimonial-card {
  padding: 2rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 20px;
  position: relative;
}

.quote-icon {
  font-size: 4rem;
  opacity: 0.2;
  line-height: 1;
}

.testimonial-text {
  font-size: 1.125rem;
  line-height: 1.6;
  margin: 1rem 0;
}

.rating {
  display: flex;
  gap: 0.25rem;
  margin: 1rem 0;
}

.star {
  color: #fbbf24;
  font-size: 1.25rem;
}

.author {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-top: 1.5rem;
}

.avatar {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  border: 3px solid white;
}

.name {
  font-weight: 700;
  font-size: 1.125rem;
}

.role {
  opacity: 0.9;
  font-size: 0.875rem;
}
</style>