<template>
  <div class="team-card">
    <div class="member-image">
      <img :src="photo" :alt="name" />
    </div>
    <h3 class="member-name">{{ name }}</h3>
    <p class="member-role">{{ role }}</p>
    <p class="member-bio">{{ bio }}</p>
    <div class="social-links">
      <a v-for="link in socialLinks" :key="link.platform" :href="link.url" class="social-link">
        {{ link.icon }}
      </a>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  photo: string;
  name: string;
  role: string;
  bio: string;
  socialLinks: Array<{ platform: string; url: string; icon: string }>;
}>();
</script>

<style scoped>
.team-card {
  text-align: center;
  padding: 2rem;
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: transform 0.3s;
}

.team-card:hover {
  transform: translateY(-8px);
}

.member-image {
  width: 120px;
  height: 120px;
  margin: 0 auto 1.5rem;
  border-radius: 50%;
  overflow: hidden;
  border: 4px solid #e5e7eb;
}

.member-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.member-name {
  margin: 0 0 0.5rem 0;
  font-size: 1.5rem;
  font-weight: 700;
  color: #111827;
}

.member-role {
  margin: 0 0 1rem 0;
  color: #8b5cf6;
  font-weight: 600;
}

.member-bio {
  color: #6b7280;
  line-height: 1.6;
  margin: 0 0 1.5rem 0;
}

.social-links {
  display: flex;
  justify-content: center;
  gap: 0.75rem;
}

.social-link {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f3f4f6;
  border-radius: 50%;
  text-decoration: none;
  font-size: 1.25rem;
  transition: all 0.2s;
}

.social-link:hover {
  background: #8b5cf6;
  transform: scale(1.1);
}
</style>