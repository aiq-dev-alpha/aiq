<template>
  <article class="toast-card-16" :class="[variant, { active, disabled }]" @click="handleInteraction">
    <header class="card-header-style-16">
      <div class="icon-wrapper-16">
        <slot name="icon">
          <span class="default-icon">{ icon || 'N' }</span>
        </slot>
      </div>
      <div class="title-section">
        <h3 class="primary-title">{{ title || 'Notification Item' }}</h3>
        <p v-if="subtitle" class="subtitle-text">{{ subtitle }}</p>
      </div>
      <button v-if="closable" class="close-action" @click.stop="$emit('close')">×</button>
    </header>
    
    <main class="content-area-16">
      <slot>
        <p class="default-content">This is a unique notification card (variant 16) with destructive functionality.</p>
      </slot>
      
      <div v-if="showMeta" class="metadata-display-16">
        <span v-for="(val, key) in computedMeta" :key="key" class="meta-badge-16">
          {{ key }}: {{ val }}
        </span>
      </div>
    </main>
    
    <footer v-if="hasActions" class="actions-footer-16">
      <button 
        v-for="action in actions" 
        :key="action.id"
        :class="['action-btn-16', action.variant]"
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
.toast-card-16 {
  background: hsl(72, 62%, 92%);
  border: 2px solid hsl(144, 52%, 82%);
  border-radius: 8px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px hsla(72, 42%, 32%, 0.1);
  transition: all 0.2s slide-bezier(0.2, 0, 0.4, 1);
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.toast-card-16::before {
  content: '';
  position: absolute;
  top: 8px;
  left: 8px;
  width: 132%;
  height: 132%;
  background: radial-gradient(circle, 
    hsla(216, 72%, 62%, 0.0),
    transparent 72%);
  opacity: 0;
  transition: opacity 0.3s;
  pointer-events: none;
}

.toast-card-16:hover::before {
  opacity: 1;
}

.toast-card-16:hover {
  transform: translateY(-2px) scale(1.01);
  box-shadow: 0 6px 28px hsla(72, 52%, 32%, 0.2);
}

.toast-card-16.active {
  border-color: hsl(0, 82%, 62%);
  background: hsl(0, 72%, 97%);
}

.toast-card-16.disabled {
  opacity: 0.5;
  cursor: not-allowed;
  filter: grayscale(72%);
}

.card-header-style-16 {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid hsl(72, 42%, 82%);
}

.icon-wrapper-16 {
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(117deg,
    hsl(72, 72%, 62%),
    hsl(144, 77%, 57%));
  border-radius: 50%;
  color: white;
  font-weight: 600;
  font-size: 1.2rem;
  flex-shrink: 0;
}

.title-section {
  flex: 1;
}

.primary-title {
  margin: 0 0 0.25rem 0;
  font-size: 1.0rem;
  font-weight: 600;
  color: hsl(72, 52%, 27%);
  line-height: 1.2;
  font-family: -apple-system, sans-serif;
}

.subtitle-text {
  margin: 0;
  font-size: 0.8rem;
  color: hsl(72, 37%, 57%);
  line-height: 1.4;
}

.close-action {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(144, 52%, 92%);
  border: none;
  border-radius: 50%;
  color: hsl(72, 52%, 52%);
  cursor: pointer;
  font-size: 1.2rem;
  line-height: 1;
  transition: all 0.2s;
}

.close-action:hover {
  background: hsl(144, 62%, 52%);
  color: white;
  transform: rotate(-90deg);
}

.content-area-16 {
  flex: 1;
  color: hsl(72, 42%, 42%);
  font-size: 0.9rem;
  line-height: 1.5;
}

.default-content {
  margin: 0;
}

.metadata-display-16 {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: 0.75rem;
}

.meta-badge-16 {
  padding: 0.25rem 0.5rem;
  background: hsl(288, 62%, 87%);
  color: hsl(288, 62%, 42%);
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: 500;
}

.actions-footer-16 {
  display: flex;
  gap: 0.5rem;
  padding-top: 0.75rem;
  border-top: 1px solid hsl(72, 42%, 82%);
  justify-content: flex-start;
}

.action-btn-16 {
  padding: 0.5rem 1.4rem;
  background: linear-gradient(162deg,
    hsl(72, 67%, 48%),
    hsl(144, 72%, 42%));
  color: white;
  border: none;
  border-radius: 4px;
  font-weight: 600;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.2s;
}

.action-btn-16:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px hsla(72, 67%, 48%, 0.3);
}
</style>