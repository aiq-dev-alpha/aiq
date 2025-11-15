<template>
  <button
    :class="['copy-btn', { copied, disabled }]"
    :disabled="disabled"
    @click="handleCopy"
  >
    <span v-if="!copied"><slot>Copy</slot></span>
    <span v-else class="copied-text">✓ Copied!</span>
  </button>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  text: string;
  disabled?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  disabled: false
});

const emit = defineEmits<{
  copy: [text: string];
}>();

const copied = ref(false);

const handleCopy = async () => {
  if (props.disabled) return;
  
  try {
    await navigator.clipboard.writeText(props.text);
    copied.value = true;
    emit('copy', props.text);
    
    setTimeout(() => {
      copied.value = false;
    }, 2000);
  } catch (err) {
    console.error('Failed to copy:', err);
  }
};
</script>

<style scoped>
.copy-btn {
  padding: 0.875rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: #374151;
  background: white;
  border: 2px solid #e5e7eb;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.copy-btn:hover:not(.disabled):not(.copied) {
  border-color: #3b82f6;
  color: #3b82f6;
  transform: translateY(-2px);
}

.copy-btn.copied {
  border-color: #10b981;
  color: #10b981;
  background: #ecfdf5;
}

.copy-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.copied-text {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
}
</style>