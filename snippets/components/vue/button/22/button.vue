<template>
  <button
    :class="['wave-btn', { active, disabled }]"
    :disabled="disabled"
    @click="handleClick"
  >
    <span class="btn-text"><slot /></span>
    <svg class="wave" viewBox="0 0 100 20">
      <path
        v-for="i in 5"
        :key="i"
        class="wave-path"
        :style="{ animationDelay: `${i * 0.1}s` }"
        :d="`M 0,10 Q 25,${5 + i}, 50,10 T 100,10`"
      />
    </svg>
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
  click: [event: MouseEvent];
}>();

const active = ref(false);

const handleClick = (event: MouseEvent) => {
  if (!disabled) {
    active.value = true;
    setTimeout(() => active.value = false, 1000);
    emit('click', event);
  }
};
</script>

<style scoped>
.wave-btn {
  position: relative;
  padding: 0.875rem 2rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
  border: none;
  border-radius: 10px;
  cursor: pointer;
  overflow: hidden;
  transition: all 0.2s ease;
}

.wave-btn:hover:not(.disabled) {
  transform: translateY(-2px);
}

.wave-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-text {
  position: relative;
  z-index: 2;
}

.wave {
  position: absolute;
  bottom: -5px;
  left: 0;
  width: 100%;
  height: 20px;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.wave-btn.active .wave {
  opacity: 1;
}

.wave-path {
  fill: none;
  stroke: rgba(255, 255, 255, 0.6);
  stroke-width: 2;
  animation: wave-move 1s ease-in-out infinite;
}

@keyframes wave-move {
  0%, 100% {
    d: path('M 0,10 Q 25,5, 50,10 T 100,10');
  }
  50% {
    d: path('M 0,10 Q 25,15, 50,10 T 100,10');
  }
}
</style>