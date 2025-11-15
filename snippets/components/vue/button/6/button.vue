<template>
  <div class="fab-wrapper">
    <button
      :class="['fab', { open: isOpen }]"
      @click="toggleActions"
    >
      <span :class="['fab-icon', { rotate: isOpen }]">+</span>
    </button>
    <Transition name="actions">
      <div v-if="isOpen" class="speed-dial">
        <button
          v-for="(action, index) in actions"
          :key="index"
          class="speed-dial-action"
          :style="{ transitionDelay: `${index * 50}ms` }"
          @click="handleAction(action, $event)"
        >
          <span class="action-icon">{{ action.icon }}</span>
          <span class="action-label">{{ action.label }}</span>
        </button>
      </div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Action {
  icon: string;
  label: string;
  value: string;
}

interface Props {
  actions?: Action[];
}

withDefaults(defineProps<Props>(), {
  actions: () => []
});

const emit = defineEmits<{
  action: [action: Action, event: MouseEvent];
}>();

const isOpen = ref(false);

const toggleActions = () => {
  isOpen.value = !isOpen.value;
};

const handleAction = (action: Action, event: MouseEvent) => {
  emit('action', action, event);
  isOpen.value = false;
};
</script>

<style scoped>
.fab-wrapper {
  position: fixed;
  bottom: 2rem;
  right: 2rem;
  z-index: 1000;
}

.fab {
  width: 56px;
  height: 56px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
  border: none;
  border-radius: 50%;
  color: white;
  font-size: 2rem;
  cursor: pointer;
  box-shadow: 0 6px 20px rgba(245, 158, 11, 0.4);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.fab:hover {
  transform: scale(1.1);
  box-shadow: 0 8px 30px rgba(245, 158, 11, 0.5);
}

.fab.open {
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
}

.fab-icon {
  display: block;
  transition: transform 0.3s ease;
  line-height: 1;
}

.fab-icon.rotate {
  transform: rotate(45deg);
}

.speed-dial {
  position: absolute;
  bottom: 72px;
  right: 0;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.speed-dial-action {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1rem;
  background: white;
  border: none;
  border-radius: 28px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;
  opacity: 0;
  animation: slideIn 0.3s ease forwards;
}

.speed-dial-action:hover {
  transform: translateX(-8px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
}

.action-icon {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
  border-radius: 50%;
  color: white;
  font-size: 1rem;
}

.action-label {
  font-size: 0.875rem;
  font-weight: 600;
  color: #374151;
  white-space: nowrap;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.actions-enter-active .speed-dial-action,
.actions-leave-active .speed-dial-action {
  transition: all 0.2s ease;
}

.actions-leave-active .speed-dial-action {
  animation: none;
}
</style>
