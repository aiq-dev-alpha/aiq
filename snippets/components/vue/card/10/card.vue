<template>
  <div :class="['stats-card', variant]">
    <div class="icon-container">
      <span class="icon">{{ icon }}</span>
    </div>
    <div class="stats-content">
      <p class="label">{{ label }}</p>
      <h3 class="value">{{ value }}</h3>
      <div v-if="change !== undefined" :class="['change', changeType]">
        <span class="change-icon">{{ changeType === 'positive' ? '↑' : '↓' }}</span>
        <span class="change-value">{{ Math.abs(change) }}%</span>
        <span class="change-period">vs last {{ period }}</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';

interface Props {
  icon: string;
  label: string;
  value: string | number;
  change?: number;
  period?: string;
  variant?: 'primary' | 'success' | 'warning' | 'danger';
}

const props = withDefaults(defineProps<Props>(), {
  period: 'month',
  variant: 'primary'
});

const changeType = computed(() => {
  if (props.change === undefined) return null;
  return props.change >= 0 ? 'positive' : 'negative';
});
</script>

<style scoped>
.stats-card {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  padding: 1.5rem;
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  border-left: 4px solid;
}

.stats-card.primary {
  border-color: #3b82f6;
}

.stats-card.success {
  border-color: #10b981;
}

.stats-card.warning {
  border-color: #f59e0b;
}

.stats-card.danger {
  border-color: #ef4444;
}

.icon-container {
  width: 64px;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 12px;
  font-size: 2rem;
}

.stats-card.primary .icon-container {
  background: #dbeafe;
}

.stats-card.success .icon-container {
  background: #d1fae5;
}

.stats-card.warning .icon-container {
  background: #fef3c7;
}

.stats-card.danger .icon-container {
  background: #fee2e2;
}

.stats-content {
  flex: 1;
}

.label {
  margin: 0 0 0.5rem 0;
  color: #6b7280;
  font-size: 0.875rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.value {
  margin: 0 0 0.5rem 0;
  font-size: 2rem;
  font-weight: 700;
  color: #111827;
}

.change {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
}

.change.positive {
  color: #10b981;
}

.change.negative {
  color: #ef4444;
}

.change-period {
  color: #6b7280;
}
</style>