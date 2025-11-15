<template>
  <div
    :class="['notification-card', severity, { dismissible }]"
    role="alert"
  >
    <div class="notification-icon">
      <span class="icon">{{ getIcon(severity) }}</span>
    </div>
    <div class="notification-content">
      <h4 v-if="title" class="notification-title">{{ title }}</h4>
      <p class="notification-message">
        <slot />
      </p>
      <div v-if="$slots.actions" class="notification-actions">
        <slot name="actions" />
      </div>
    </div>
    <button
      v-if="dismissible"
      class="dismiss-button"
      @click="$emit('dismiss')"
      aria-label="Dismiss notification"
    >
      ×
    </button>
    <div class="progress-bar" v-if="autoClose" :style="{ animationDuration: `${autoClose}ms` }"></div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue';

interface Props {
  severity?: 'info' | 'success' | 'warning' | 'error';
  title?: string;
  dismissible?: boolean;
  autoClose?: number;
}

const props = withDefaults(defineProps<Props>(), {
  severity: 'info',
  dismissible: true,
  autoClose: 0
});

const emit = defineEmits<{
  dismiss: [];
}>();

const getIcon = (severity: string): string => {
  const icons = {
    info: 'ℹ️',
    success: '✓',
    warning: '⚠️',
    error: '✕'
  };
  return icons[severity as keyof typeof icons] || icons.info;
};

onMounted(() => {
  if (props.autoClose > 0) {
    setTimeout(() => {
      emit('dismiss');
    }, props.autoClose);
  }
});
</script>

<style scoped>
.notification-card {
  position: relative;
  display: flex;
  align-items: flex-start;
  gap: 1rem;
  padding: 1.25rem;
  background: white;
  border-radius: 12px;
  border-left: 4px solid;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.notification-card.info {
  border-color: #3b82f6;
  background: linear-gradient(to right, #eff6ff, white);
}

.notification-card.success {
  border-color: #10b981;
  background: linear-gradient(to right, #ecfdf5, white);
}

.notification-card.warning {
  border-color: #f59e0b;
  background: linear-gradient(to right, #fffbeb, white);
}

.notification-card.error {
  border-color: #ef4444;
  background: linear-gradient(to right, #fef2f2, white);
}

.notification-icon {
  flex-shrink: 0;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  font-size: 1.25rem;
  font-weight: 700;
}

.notification-card.info .notification-icon {
  background: #dbeafe;
  color: #3b82f6;
}

.notification-card.success .notification-icon {
  background: #d1fae5;
  color: #10b981;
}

.notification-card.warning .notification-icon {
  background: #fef3c7;
  color: #f59e0b;
}

.notification-card.error .notification-icon {
  background: #fee2e2;
  color: #ef4444;
}

.notification-content {
  flex: 1;
  min-width: 0;
}

.notification-title {
  margin: 0 0 0.5rem 0;
  font-size: 1rem;
  font-weight: 700;
  color: #111827;
}

.notification-message {
  margin: 0;
  color: #4b5563;
  line-height: 1.5;
}

.notification-actions {
  margin-top: 1rem;
  display: flex;
  gap: 0.75rem;
}

.dismiss-button {
  flex-shrink: 0;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: transparent;
  border: none;
  border-radius: 4px;
  font-size: 1.5rem;
  line-height: 1;
  color: #9ca3af;
  cursor: pointer;
  transition: all 0.2s ease;
}

.dismiss-button:hover {
  background: #f3f4f6;
  color: #374151;
}

.progress-bar {
  position: absolute;
  bottom: 0;
  left: 0;
  height: 3px;
  width: 100%;
  background: currentColor;
  transform-origin: left;
  animation: progress linear forwards;
}

@keyframes progress {
  from {
    transform: scaleX(1);
  }
  to {
    transform: scaleX(0);
  }
}
</style>
