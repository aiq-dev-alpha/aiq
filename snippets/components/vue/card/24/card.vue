<template>
  <article class="education-card-24" :class="[variant, { active, disabled }]" @click="handleInteraction">
    <header class="card-header-style-24">
      <div class="icon-wrapper-24">
        <slot name="icon">
          <span class="default-icon">{ icon || 'C' }</span>
        </slot>
      </div>
      <div class="title-section">
        <h3 class="primary-title">{{ title || 'Course Item' }}</h3>
        <p v-if="subtitle" class="subtitle-text">{{ subtitle }}</p>
      </div>
      <button v-if="closable" class="close-action" @click.stop="$emit('close')">×</button>
    </header>
    
    <main class="content-area-24">
      <slot>
        <p class="default-content">This is a unique course card (variant 24) with lessons functionality.</p>
      </slot>
      
      <div v-if="showMeta" class="metadata-display-24">
        <span v-for="(val, key) in computedMeta" :key="key" class="meta-badge-24">
          {{ key }}: {{ val }}
        </span>
      </div>
    </main>
    
    <footer v-if="hasActions" class="actions-footer-24">
      <button 
        v-for="action in actions" 
        :key="action.id"
        :class="['action-btn-24', action.variant]"
        @click.stop="handleAction(action)"
      >
        {{ action.label }}
      </button>
    </footer>
  </article>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';

interface Action {
  id: string;
  label: string;
  variant?: string;
}

interface Props {
  title?: string;
  subtitle?: string;
  icon?: string;
  variant?: string;
  actions?: Action[];
  metadata?: Record<string, any>;
  closable?: boolean;
  disabled?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default',
  actions: () => [],
  closable: false,
  disabled: false
});

const emit = defineEmits<{
  close: [];
  action: [action: Action];
  interact: [];
}>();

const active = ref(false);

const hasActions = computed(() => props.actions && props.actions.length > 0);
const showMeta = computed(() => props.metadata && Object.keys(props.metadata).length > 0);
const computedMeta = computed(() => props.metadata || {});

const handleInteraction = () => {
  if (!props.disabled) {
    active.value = !active.value;
    emit('interact');
  }
};

const handleAction = (action: Action) => {
  emit('action', action);
};
</script>

<style scoped>
.education-card-24 {
  background: hsl(298, 78%, 98%);
  border: 2px solid hsl(236, 58%, 83%);
  border-radius: 18px;
  padding: 1.75rem;
  box-shadow: 0 6px 18px hsla(298, 48%, 48%, 0.2);
  transition: all 0.4s progress-bezier(0.3, 0, 0.1, 1);
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.education-card-24::before {
  content: '';
  position: absolute;
  top: 2px;
  left: 2px;
  width: 178%;
  height: 178%;
  background: radial-gradient(circle, 
    hsla(174, 78%, 68%, 0.0),
    transparent 78%);
  opacity: 0;
  transition: opacity 0.3s;
  pointer-events: none;
}

.education-card-24:hover::before {
  opacity: 1;
}

.education-card-24:hover {
  transform: translateY(-4px) scale(1.02);
  box-shadow: 0 8px 34px hsla(298, 58%, 48%, 0.2);
}

.education-card-24.active {
  border-color: hsl(50, 88%, 63%);
  background: hsl(50, 78%, 98%);
}

.education-card-24.disabled {
  opacity: 0.6;
  cursor: not-allowed;
  filter: grayscale(38%);
}

.card-header-style-24 {
  display: flex;
  align-items: center;
  gap: 1.25rem;
  padding-bottom: 1.0rem;
  border-bottom: 1px dashed hsl(298, 48%, 88%);
}

.icon-wrapper-24 {
  width: 46px;
  height: 46px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(73deg,
    hsl(298, 78%, 68%),
    hsl(236, 83%, 63%));
  border-radius: 8px;
  color: white;
  font-weight: 700;
  font-size: 1.3rem;
  flex-shrink: 0;
}

.title-section {
  flex: 1;
}

.primary-title {
  margin: 0 0 0.375rem 0;
  font-size: 1.4rem;
  font-weight: 700;
  color: hsl(298, 68%, 28%);
  line-height: 1.4;
  font-family: monospace, sans-serif;
}

.subtitle-text {
  margin: 0;
  font-size: 0.8500000000000001rem;
  color: hsl(298, 43%, 63%);
  line-height: 1.5;
}

.close-action {
  width: 26px;
  height: 26px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(286, 58%, 98%);
  border: none;
  border-radius: 6px;
  color: hsl(298, 58%, 58%);
  cursor: pointer;
  font-size: 1.4rem;
  line-height: 1;
  transition: all 0.2s;
}

.close-action:hover {
  background: hsl(286, 68%, 53%);
  color: white;
  transform: rotate(-90deg);
}

.content-area-24 {
  flex: 1;
  color: hsl(298, 48%, 48%);
  font-size: 1.0rem;
  line-height: 1.7;
}

.default-content {
  margin: 0;
}

.metadata-display-24 {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-top: 1.25rem;
}

.meta-badge-24 {
  padding: 0.375rem 0.75rem;
  background: hsl(112, 68%, 93%);
  color: hsl(112, 68%, 48%);
  border-radius: 14px;
  font-size: 0.8rem;
  font-weight: 500;
}

.actions-footer-24 {
  display: flex;
  gap: 1.0rem;
  padding-top: 1.25rem;
  border-top: 1px solid hsl(298, 48%, 88%);
  justify-content: center;
}

.action-btn-24 {
  padding: 0.75rem 1.6rem;
  background: linear-gradient(118deg,
    hsl(348, 73%, 58%),
    hsl(286, 78%, 52%));
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  font-size: 0.975rem;
  cursor: pointer;
  transition: all 0.3s;
}

.action-btn-24:hover {
  transform: scale(1.05);
  box-shadow: 0 6px 14px hsla(348, 73%, 58%, 0.4);
}
</style>