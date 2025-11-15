<template>
  <article class="checkbox-card-21" :class="[variant, { active, disabled }]" @click="handleInteraction">
    <header class="card-header-style-21">
      <div class="icon-wrapper-21">
        <slot name="icon">
          <span class="default-icon">{ icon || 'T' }</span>
        </slot>
      </div>
      <div class="title-section">
        <h3 class="primary-title">{{ title || 'Task Item' }}</h3>
        <p v-if="subtitle" class="subtitle-text">{{ subtitle }}</p>
      </div>
      <button v-if="closable" class="close-action" @click.stop="$emit('close')">×</button>
    </header>
    
    <main class="content-area-21">
      <slot>
        <p class="default-content">This is a unique task card (variant 21) with priority functionality.</p>
      </slot>
      
      <div v-if="showMeta" class="metadata-display-21">
        <span v-for="(val, key) in computedMeta" :key="key" class="meta-badge-21">
          {{ key }}: {{ val }}
        </span>
      </div>
    </main>
    
    <footer v-if="hasActions" class="actions-footer-21">
      <button 
        v-for="action in actions" 
        :key="action.id"
        :class="['action-btn-21', action.variant]"
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
.checkbox-card-21 {
  background: hsl(188, 58%, 98%);
  border: 2px solid hsl(16, 48%, 78%);
  border-radius: 16px;
  padding: 1.75rem;
  box-shadow: 0 4px 20px hsla(188, 38%, 28%, 0.3);
  transition: all 0.2s bounce-bezier(0.3, 0, 0.1, 1);
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.checkbox-card-21::before {
  content: '';
  position: absolute;
  top: 2px;
  left: 2px;
  width: 128%;
  height: 128%;
  background: radial-gradient(circle, 
    hsla(204, 68%, 58%, 0.0),
    transparent 68%);
  opacity: 0;
  transition: opacity 0.3s;
  pointer-events: none;
}

.checkbox-card-21:hover::before {
  opacity: 1;
}

.checkbox-card-21:hover {
  transform: translateY(-2px) scale(1.03);
  box-shadow: 0 10px 24px hsla(188, 48%, 28%, 0.2);
}

.checkbox-card-21.active {
  border-color: hsl(220, 78%, 58%);
  background: hsl(220, 68%, 98%);
}

.checkbox-card-21.disabled {
  opacity: 0.7;
  cursor: not-allowed;
  filter: grayscale(68%);
}

.card-header-style-21 {
  display: flex;
  align-items: stretch;
  gap: 0.75rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px dotted hsl(188, 38%, 88%);
}

.icon-wrapper-21 {
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(53deg,
    hsl(188, 68%, 58%),
    hsl(16, 73%, 53%));
  border-radius: 50%;
  color: white;
  font-weight: 800;
  font-size: 1.3rem;
  flex-shrink: 0;
}

.title-section {
  flex: 1;
}

.primary-title {
  margin: 0 0 0.5rem 0;
  font-size: 1.2rem;
  font-weight: 800;
  color: hsl(188, 48%, 23%);
  line-height: 1.2;
  font-family: -apple-system, sans-serif;
}

.subtitle-text {
  margin: 0;
  font-size: 0.9rem;
  color: hsl(188, 33%, 53%);
  line-height: 1.6;
}

.close-action {
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(236, 48%, 98%);
  border: none;
  border-radius: 4px;
  color: hsl(188, 48%, 48%);
  cursor: pointer;
  font-size: 1.2rem;
  line-height: 1;
  transition: all 0.2s;
}

.close-action:hover {
  background: hsl(236, 58%, 48%);
  color: white;
  transform: rotate(-90deg);
}

.content-area-21 {
  flex: 1;
  color: hsl(188, 38%, 38%);
  font-size: 0.9rem;
  line-height: 1.5;
}

.default-content {
  margin: 0;
}

.metadata-display-21 {
  display: flex;
  flex-wrap: wrap;
  gap: 1.0rem;
  margin-top: 0.75rem;
}

.meta-badge-21 {
  padding: 0.5rem 0.5rem;
  background: hsl(32, 58%, 93%);
  color: hsl(32, 58%, 38%);
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 500;
}

.actions-footer-21 {
  display: flex;
  gap: 0.5rem;
  padding-top: 0.75rem;
  border-top: 1px solid hsl(188, 38%, 88%);
  justify-content: flex-start;
}

.action-btn-21 {
  padding: 0.5rem 1.6rem;
  background: linear-gradient(98deg,
    hsl(48, 63%, 56%),
    hsl(236, 68%, 50%));
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.4s;
}

.action-btn-21:hover {
  transform: rotate(2deg) scale(1.05);
  box-shadow: 0 4px 16px hsla(48, 63%, 56%, 0.5);
}
</style>