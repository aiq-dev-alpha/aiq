<template>
  <div
    :class="['expandable-card', { expanded }]"
    @click="toggle"
  >
    <div class="card-header">
      <div class="header-content">
        <slot name="header">
          <h3 class="card-title">{{ title }}</h3>
        </slot>
      </div>
      <button class="expand-button" :class="{ rotated: expanded }">
        <span class="chevron">▼</span>
      </button>
    </div>
    <Transition name="expand">
      <div v-show="expanded" class="card-body">
        <div class="body-content">
          <slot />
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  title?: string;
  defaultExpanded?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  title: 'Expandable Card',
  defaultExpanded: false
});

const expanded = ref(props.defaultExpanded);

const toggle = () => {
  expanded.value = !expanded.value;
};
</script>

<style scoped>
.expandable-card {
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
}

.expandable-card:hover {
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.5rem;
  background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
}

.header-content {
  flex: 1;
}

.card-title {
  margin: 0;
  font-size: 1.125rem;
  font-weight: 700;
  color: #111827;
}

.expand-button {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: white;
  border: none;
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.expand-button:hover {
  background: #f3f4f6;
}

.chevron {
  display: block;
  font-size: 0.875rem;
  color: #6b7280;
  transition: transform 0.3s ease;
}

.expand-button.rotated .chevron {
  transform: rotate(180deg);
}

.card-body {
  overflow: hidden;
}

.body-content {
  padding: 1.5rem;
}

.expand-enter-active,
.expand-leave-active {
  transition: all 0.3s ease;
}

.expand-enter-from,
.expand-leave-to {
  max-height: 0;
  opacity: 0;
}

.expand-enter-to,
.expand-leave-from {
  max-height: 500px;
  opacity: 1;
}
</style>
