<template>
  <button
    :class="['skeleton-btn', { loading, disabled }]"
    :disabled="disabled"
    @click="$emit('click', $event)"
  >
    <div v-if="loading" class="skeleton">
      <div class="skeleton-shimmer"></div>
    </div>
    <span v-else class="btn-content">
      <slot />
    </span>
  </button>
</template>

<script setup lang="ts">
interface Props {
  loading?: boolean;
  disabled?: boolean;
}

withDefaults(defineProps<Props>(), {
  loading: false,
  disabled: false
});

defineEmits<{
  click: [event: MouseEvent];
}>();
</script>

<style scoped>
.skeleton-btn {
  position: relative;
  padding: 0.875rem 2rem;
  min-width: 120px;
  min-height: 44px;
  font-size: 1rem;
  font-weight: 600;
  background: #3b82f6;
  color: white;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.skeleton-btn:not(.loading):not(.disabled):hover {
  background: #2563eb;
  transform: translateY(-2px);
}

.skeleton-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.skeleton-btn.loading {
  background: #e5e7eb;
  cursor: wait;
}

.skeleton {
  position: relative;
  width: 100%;
  height: 20px;
  background: #d1d5db;
  border-radius: 4px;
  overflow: hidden;
}

.skeleton-shimmer {
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.5),
    transparent
  );
  animation: shimmer 1.5s infinite;
}

@keyframes shimmer {
  to {
    left: 100%;
  }
}
</style>