<template>
  <button
    :class="['progress-btn', { loading, disabled }]"
    :disabled="disabled || loading"
    @click="$emit('click', $event)"
  >
    <span class="btn-text">
      <slot />
    </span>
    <div class="progress-bar" :style="{ width: `${progress}%` }"></div>
  </button>
</template>

<script setup lang="ts">
interface Props {
  progress?: number;
  loading?: boolean;
  disabled?: boolean;
}

withDefaults(defineProps<Props>(), {
  progress: 0,
  loading: false,
  disabled: false
});

defineEmits<{
  click: [event: MouseEvent];
}>();
</script>

<style scoped>
.progress-btn {
  position: relative;
  padding: 0.875rem 2rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: #3b82f6;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  overflow: hidden;
  transition: background 0.2s ease;
}

.progress-btn:hover:not(.disabled):not(.loading) {
  background: #2563eb;
}

.progress-btn.disabled,
.progress-btn.loading {
  opacity: 0.7;
  cursor: not-allowed;
}

.btn-text {
  position: relative;
  z-index: 2;
}

.progress-bar {
  position: absolute;
  left: 0;
  bottom: 0;
  height: 4px;
  background: rgba(255, 255, 255, 0.9);
  transition: width 0.3s ease;
  border-radius: 0 4px 0 0;
}
</style>