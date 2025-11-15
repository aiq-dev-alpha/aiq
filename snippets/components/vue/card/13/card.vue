<template>
  <div class="video-card" @click="handlePlay">
    <div class="video-thumbnail" :style="{ backgroundImage: `url(${thumbnail})` }">
      <div v-if="!playing" class="play-overlay">
        <button class="play-button">
          <svg viewBox="0 0 24 24" width="48" height="48">
            <path fill="white" d="M8 5v14l11-7z"/>
          </svg>
        </button>
      </div>
      <div v-else class="video-player">
        <video ref="videoEl" :src="videoUrl" controls autoplay class="video-element"></video>
      </div>
      <span class="duration-badge">{{ duration }}</span>
    </div>
    <div class="video-info">
      <h3 class="video-title">{{ title }}</h3>
      <div class="video-meta">
        <span class="views">👁 {{ views }} views</span>
        <span class="date">{{ publishedDate }}</span>
      </div>
      <div class="channel-info">
        <img :src="channelAvatar" class="channel-avatar" />
        <span class="channel-name">{{ channelName }}</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  thumbnail: string;
  videoUrl: string;
  title: string;
  duration: string;
  views: string;
  publishedDate: string;
  channelName: string;
  channelAvatar: string;
}

defineProps<Props>();
const playing = ref(false);
const videoEl = ref<HTMLVideoElement>();

const handlePlay = () => {
  playing.value = true;
};
</script>

<style scoped>
.video-card {
  background: #000;
  border-radius: 12px;
  overflow: hidden;
  cursor: pointer;
}

.video-thumbnail {
  position: relative;
  padding-top: 56.25%;
  background-size: cover;
  background-position: center;
}

.play-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.3s;
}

.video-card:hover .play-overlay {
  background: rgba(0, 0, 0, 0.5);
}

.play-button {
  width: 80px;
  height: 80px;
  background: rgba(255, 0, 0, 0.9);
  border: none;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: transform 0.2s;
}

.play-button:hover {
  transform: scale(1.1);
}

.video-player {
  position: absolute;
  inset: 0;
}

.video-element {
  width: 100%;
  height: 100%;
}

.duration-badge {
  position: absolute;
  bottom: 8px;
  right: 8px;
  padding: 2px 6px;
  background: rgba(0, 0, 0, 0.8);
  color: white;
  font-size: 0.75rem;
  font-weight: 700;
  border-radius: 4px;
}

.video-info {
  padding: 1rem;
  background: white;
}

.video-title {
  margin: 0 0 0.5rem 0;
  font-size: 1rem;
  font-weight: 600;
  color: #111;
  line-height: 1.3;
}

.video-meta {
  display: flex;
  gap: 1rem;
  margin-bottom: 0.75rem;
  font-size: 0.875rem;
  color: #666;
}

.channel-info {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.channel-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
}

.channel-name {
  font-size: 0.875rem;
  font-weight: 600;
  color: #111;
}
</style>