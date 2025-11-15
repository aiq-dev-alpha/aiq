<template>
  <div class="gallery-card">
    <div class="main-image" @click="openLightbox(0)">
      <img :src="images[currentIndex]" alt="Gallery image" />
      <div class="image-overlay">
        <span class="enlarge-icon">🔍</span>
      </div>
    </div>
    <div class="thumbnails">
      <div
        v-for="(img, i) in images.slice(0, 4)"
        :key="i"
        :class="['thumbnail', { active: i === currentIndex }]"
        @click="currentIndex = i"
      >
        <img :src="img" :alt="`Thumbnail ${i + 1}`" />
        <div v-if="i === 3 && images.length > 4" class="more-overlay">
          +{{ images.length - 4 }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

defineProps<{
  images: string[];
}>();

const currentIndex = ref(0);

const emit = defineEmits<{
  openLightbox: [index: number];
}>();

const openLightbox = (index: number) => {
  emit('openLightbox', index);
};
</script>

<style scoped>
.gallery-card {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.main-image {
  position: relative;
  height: 300px;
  overflow: hidden;
  cursor: pointer;
}

.main-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}

.main-image:hover img {
  transform: scale(1.05);
}

.image-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s;
}

.main-image:hover .image-overlay {
  opacity: 1;
}

.enlarge-icon {
  font-size: 3rem;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.5));
}

.thumbnails {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 0.5rem;
  padding: 0.5rem;
}

.thumbnail {
  position: relative;
  aspect-ratio: 1;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  border: 2px solid transparent;
  transition: all 0.2s;
}

.thumbnail.active {
  border-color: #8b5cf6;
}

.thumbnail img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.more-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.7);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  font-weight: 700;
}
</style>