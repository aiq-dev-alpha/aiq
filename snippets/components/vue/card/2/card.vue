<template>
  <div :class="['flip-card', { flipped }]">
    <div class="card-inner">
      <div class="card-front">
        <slot name="front">
          <div class="card-content">
            <h3>{{ title }}</h3>
            <p>{{ description }}</p>
          </div>
        </slot>
        <button class="flip-btn" @click="flipped = !flipped">Flip →</button>
      </div>
      <div class="card-back">
        <slot name="back">
          <div class="card-content">
            <p>{{ backContent }}</p>
          </div>
        </slot>
        <button class="flip-btn" @click="flipped = !flipped">← Back</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  title?: string;
  description?: string;
  backContent?: string;
}

withDefaults(defineProps<Props>(), {
  title: 'Card Title',
  description: 'Card description',
  backContent: 'Back content'
});

const flipped = ref(false);
</script>

<style scoped>
.flip-card {
  perspective: 1000px;
  width: 100%;
  max-width: 400px;
  height: 300px;
}

.card-inner {
  position: relative;
  width: 100%;
  height: 100%;
  transition: transform 0.6s;
  transform-style: preserve-3d;
}

.flip-card.flipped .card-inner {
  transform: rotateY(180deg);
}

.card-front,
.card-back {
  position: absolute;
  width: 100%;
  height: 100%;
  backface-visibility: hidden;
  border-radius: 16px;
  padding: 2rem;
  background: white;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.card-back {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  transform: rotateY(180deg);
}

.flip-btn {
  align-self: flex-end;
  padding: 0.5rem 1rem;
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 8px;
  color: inherit;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.2s;
}

.flip-btn:hover {
  background: rgba(255, 255, 255, 0.3);
}
</style>