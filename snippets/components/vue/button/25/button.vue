<template>
  <button
    :class="['longpress-btn', { pressing, confirmed, disabled }]"
    :disabled="disabled"
    @mousedown="startPress"
    @mouseup="endPress"
    @mouseleave="endPress"
    @touchstart="startPress"
    @touchend="endPress"
  >
    <span class="btn-text"><slot>Hold to Confirm</slot></span>
    <svg class="progress-ring" viewBox="0 0 60 60">
      <circle
        class="progress-bg"
        cx="30"
        cy="30"
        r="26"
      />
      <circle
        class="progress-bar"
        cx="30"
        cy="30"
        r="26"
        :style="{ strokeDashoffset: circleProgress }"
      />
    </svg>
  </button>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';

interface Props {
  duration?: number;
  disabled?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  duration: 2000,
  disabled: false
});

const emit = defineEmits<{
  confirm: [];
}>();

const pressing = ref(false);
const confirmed = ref(false);
const progress = ref(0);
let startTime = 0;
let animationFrame: number | null = null;

const circumference = 2 * Math.PI * 26;
const circleProgress = computed(() => {
  return circumference - (progress.value / 100) * circumference;
});

const startPress = () => {
  if (props.disabled || confirmed.value) return;
  
  pressing.value = true;
  startTime = Date.now();
  updateProgress();
};

const updateProgress = () => {
  const elapsed = Date.now() - startTime;
  progress.value = Math.min((elapsed / props.duration) * 100, 100);
  
  if (progress.value >= 100) {
    handleConfirm();
  } else if (pressing.value) {
    animationFrame = requestAnimationFrame(updateProgress);
  }
};

const endPress = () => {
  pressing.value = false;
  if (animationFrame) {
    cancelAnimationFrame(animationFrame);
  }
  if (progress.value < 100) {
    progress.value = 0;
  }
};

const handleConfirm = () => {
  confirmed.value = true;
  emit('confirm');
  setTimeout(() => {
    confirmed.value = false;
    progress.value = 0;
  }, 1000);
};
</script>

<style scoped>
.longpress-btn {
  position: relative;
  padding: 1rem 2rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #ec4899 0%, #db2777 100%);
  border: none;
  border-radius: 30px;
  cursor: pointer;
  user-select: none;
  transition: all 0.2s ease;
}

.longpress-btn.pressing {
  transform: scale(0.95);
}

.longpress-btn.confirmed {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
}

.longpress-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-text {
  position: relative;
  z-index: 2;
}

.progress-ring {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 60px;
  height: 60px;
  transform: translate(-50%, -50%) rotate(-90deg);
  pointer-events: none;
}

.progress-bg {
  fill: none;
  stroke: rgba(255, 255, 255, 0.2);
  stroke-width: 3;
}

.progress-bar {
  fill: none;
  stroke: white;
  stroke-width: 3;
  stroke-dasharray: 163.36;
  stroke-linecap: round;
  transition: stroke-dashoffset 0.05s linear;
}
</style>