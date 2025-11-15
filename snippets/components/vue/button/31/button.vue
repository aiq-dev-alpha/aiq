<template>
  <button
    :class="['voice-btn', { listening, disabled }]"
    :disabled="disabled"
    @click="toggleListening"
  >
    <span class="microphone-icon">🎤</span>
    <span v-if="!listening"><slot>Voice Command</slot></span>
    <span v-else>Listening...</span>
    <div v-if="listening" class="waveform">
      <span v-for="i in 5" :key="i" class="wave-bar" :style="{ animationDelay: `${i * 0.1}s` }"></span>
    </div>
  </button>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  disabled?: boolean;
}

withDefaults(defineProps<Props>(), {
  disabled: false
});

const emit = defineEmits<{
  result: [text: string];
}>();

const listening = ref(false);

const toggleListening = () => {
  listening.value = !listening.value;
  
  if (listening.value) {
    // Simulate voice recognition
    setTimeout(() => {
      listening.value = false;
      emit('result', 'Voice command received');
    }, 3000);
  }
};
</script>

<style scoped>
.voice-btn {
  position: relative;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.875rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
  border: none;
  border-radius: 25px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.voice-btn:hover:not(.disabled) {
  transform: scale(1.05);
}

.voice-btn.listening {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  animation: pulse 1.5s ease-in-out infinite;
}

.voice-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.waveform {
  display: flex;
  align-items: center;
  gap: 3px;
  margin-left: 0.5rem;
}

.wave-bar {
  width: 3px;
  height: 12px;
  background: white;
  border-radius: 2px;
  animation: wave 1s ease-in-out infinite;
}

@keyframes wave {
  0%, 100% {
    height: 6px;
  }
  50% {
    height: 18px;
  }
}

@keyframes pulse {
  0%, 100% {
    box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.7);
  }
  50% {
    box-shadow: 0 0 0 10px rgba(239, 68, 68, 0);
  }
}
</style>