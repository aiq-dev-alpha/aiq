<template>
  <button
    :class="['badge-btn', { disabled }]"
    :disabled="disabled"
    @click="$emit('click', $event)"
  >
    <slot />
    <span v-if="badge" class="badge" :class="badgeVariant">{{ badge }}</span>
  </button>
</template>

<script setup lang="ts">
interface Props {
  badge?: string | number;
  badgeVariant?: 'default' | 'danger' | 'success';
  disabled?: boolean;
}

withDefaults(defineProps<Props>(), {
  badgeVariant: 'default',
  disabled: false
});

defineEmits<{
  click: [event: MouseEvent];
}>();
</script>

<style scoped>
.badge-btn {
  position: relative;
  padding: 0.875rem 2rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.badge-btn:hover:not(.disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(59, 130, 246, 0.3);
}

.badge-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.badge {
  position: absolute;
  top: -8px;
  right: -8px;
  min-width: 20px;
  height: 20px;
  padding: 0 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  font-weight: 700;
  border-radius: 10px;
  border: 2px solid white;
  animation: badge-pop 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

.badge.default {
  background: #ef4444;
  color: white;
}

.badge.danger {
  background: #dc2626;
  color: white;
}

.badge.success {
  background: #10b981;
  color: white;
}

@keyframes badge-pop {
  0% {
    transform: scale(0);
  }
  100% {
    transform: scale(1);
  }
}
</style>