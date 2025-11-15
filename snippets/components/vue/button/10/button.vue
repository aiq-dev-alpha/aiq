<template>
  <button
    :class="['morphing-btn', { morphed, disabled }]"
    :disabled="disabled"
    @click="handleClick"
  >
    <span :class="['icon-wrapper', { rotate: morphed }]">
      <span class="icon">{{ morphed ? '✓' : '+' }}</span>
    </span>
    <Transition name="text" mode="out-in">
      <span :key="morphed ? 'added' : 'add'" class="btn-text">
        {{ morphed ? 'Added' : 'Add to Cart' }}
      </span>
    </Transition>
  </button>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  disabled?: boolean;
  resetDelay?: number;
}

const props = withDefaults(defineProps<Props>(), {
  disabled: false,
  resetDelay: 2000
});

const emit = defineEmits<{
  click: [event: MouseEvent];
}>();

const morphed = ref(false);

const handleClick = (event: MouseEvent) => {
  if (props.disabled) return;

  morphed.value = true;
  emit('click', event);

  setTimeout(() => {
    morphed.value = false;
  }, props.resetDelay);
};
</script>

<style scoped>
.morphing-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.625rem;
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  min-width: 150px;
  justify-content: center;
}

.morphing-btn:hover:not(.disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
}

.morphing-btn.morphed {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
}

.morphing-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.icon-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  transition: transform 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

.icon-wrapper.rotate {
  transform: rotate(360deg);
}

.icon {
  font-size: 1.125rem;
  line-height: 1;
}

.btn-text {
  display: block;
}

.text-enter-active,
.text-leave-active {
  transition: all 0.2s ease;
}

.text-enter-from {
  opacity: 0;
  transform: translateY(-10px);
}

.text-leave-to {
  opacity: 0;
  transform: translateY(10px);
}
</style>
