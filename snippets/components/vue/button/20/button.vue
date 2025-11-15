<template>
  <div class="swipe-btn-wrapper">
    <div class="swipe-track">
      <div
        class="swipe-handle"
        :style="{ transform: `translateX(${swipePos}px)` }"
        @mousedown="startSwipe"
        @touchstart="startSwipe"
      >
        <span class="arrow">→</span>
      </div>
      <span class="swipe-text" :class="{ confirmed }">
        {{ confirmed ? 'Confirmed!' : 'Swipe to confirm' }}
      </span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';

const emit = defineEmits<{
  confirm: [];
}>();

const swipePos = ref(0);
const confirmed = ref(false);
const isDragging = ref(false);
const startX = ref(0);
const maxSwipe = ref(200);

const startSwipe = (e: MouseEvent | TouchEvent) => {
  if (confirmed.value) return;
  
  isDragging.value = true;
  startX.value = 'touches' in e ? e.touches[0].clientX : e.clientX;
};

const handleMove = (e: MouseEvent | TouchEvent) => {
  if (!isDragging.value || confirmed.value) return;
  
  const currentX = 'touches' in e ? e.touches[0].clientX : e.clientX;
  const diff = currentX - startX.value;
  
  if (diff >= 0 && diff <= maxSwipe.value) {
    swipePos.value = diff;
  }
  
  if (diff >= maxSwipe.value * 0.9) {
    confirmSwipe();
  }
};

const handleEnd = () => {
  if (!confirmed.value) {
    swipePos.value = 0;
  }
  isDragging.value = false;
};

const confirmSwipe = () => {
  confirmed.value = true;
  swipePos.value = maxSwipe.value;
  emit('confirm');
};

onMounted(() => {
  document.addEventListener('mousemove', handleMove);
  document.addEventListener('mouseup', handleEnd);
  document.addEventListener('touchmove', handleMove);
  document.addEventListener('touchend', handleEnd);
});

onUnmounted(() => {
  document.removeEventListener('mousemove', handleMove);
  document.removeEventListener('mouseup', handleEnd);
  document.removeEventListener('touchmove', handleMove);
  document.removeEventListener('touchend', handleEnd);
});
</script>

<style scoped>
.swipe-btn-wrapper {
  display: inline-block;
}

.swipe-track {
  position: relative;
  width: 250px;
  height: 50px;
  background: #e5e7eb;
  border-radius: 25px;
  overflow: hidden;
}

.swipe-handle {
  position: absolute;
  left: 2px;
  top: 2px;
  width: 46px;
  height: 46px;
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 1.5rem;
  cursor: grab;
  transition: transform 0.2s ease;
  z-index: 2;
}

.swipe-handle:active {
  cursor: grabbing;
}

.swipe-text {
  position: absolute;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.875rem;
  font-weight: 600;
  color: #6b7280;
  user-select: none;
  pointer-events: none;
}

.swipe-text.confirmed {
  color: #10b981;
}
</style>