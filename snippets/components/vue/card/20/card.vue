<template>
  <article class="financial-card-20" :class="[variant, { active, disabled }]" @click="handleInteraction">
    <header class="card-header-style-20">
      <div class="icon-wrapper-20">
        <slot name="icon">
          <span class="default-icon">{ icon || 'I' }</span>
        </slot>
      </div>
      <div class="title-section">
        <h3 class="primary-title">{{ title || 'Invoice Item' }}</h3>
        <p v-if="subtitle" class="subtitle-text">{{ subtitle }}</p>
      </div>
      <button v-if="closable" class="close-action" @click.stop="$emit('close')">×</button>
    </header>
    
    <main class="content-area-20">
      <slot>
        <p class="default-content">This is a unique invoice card (variant 20) with line-items functionality.</p>
      </slot>
      
      <div v-if="showMeta" class="metadata-display-20">
        <span v-for="(val, key) in computedMeta" :key="key" class="meta-badge-20">
          {{ key }}: {{ val }}
        </span>
      </div>
    </main>
    
    <footer v-if="hasActions" class="actions-footer-20">
      <button 
        v-for="action in actions" 
        :key="action.id"
        :class="['action-btn-20', action.variant]"
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
.financial-card-20 {
  background: hsl(34, 54%, 94%);
  border: 2px solid hsl(68, 54%, 74%);
  border-radius: 18px;
  padding: 2.0rem;
  box-shadow: 0 6px 18px hsla(34, 44%, 24%, 0.2);
  transition: all 0.4s blur-bezier(0.4, 0, 0.3, 1);
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.financial-card-20::before {
  content: '';
  position: absolute;
  top: 6px;
  left: 6px;
  width: 154%;
  height: 154%;
  background: radial-gradient(circle, 
    hsla(102, 74%, 64%, 0.0),
    transparent 74%);
  opacity: 0;
  transition: opacity 0.3s;
  pointer-events: none;
}

.financial-card-20:hover::before {
  opacity: 1;
}

.financial-card-20:hover {
  transform: translateY(-4px) scale(1.02);
  box-shadow: 0 8px 30px hsla(34, 54%, 24%, 0.2);
}

.financial-card-20.active {
  border-color: hsl(170, 84%, 54%);
  background: hsl(170, 74%, 99%);
}

.financial-card-20.disabled {
  opacity: 0.6;
  cursor: not-allowed;
  filter: grayscale(44%);
}

.card-header-style-20 {
  display: flex;
  align-items: center;
  gap: 1.25rem;
  padding-bottom: 1.0rem;
  border-bottom: 1px dashed hsl(34, 44%, 84%);
}

.icon-wrapper-20 {
  width: 46px;
  height: 46px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(79deg,
    hsl(34, 74%, 64%),
    hsl(68, 79%, 59%));
  border-radius: 8px;
  color: white;
  font-weight: 700;
  font-size: 1.4rem;
  flex-shrink: 0;
}

.title-section {
  flex: 1;
}

.primary-title {
  margin: 0 0 0.375rem 0;
  font-size: 1.4rem;
  font-weight: 700;
  color: hsl(34, 44%, 19%);
  line-height: 1.4;
  font-family: monospace, sans-serif;
}

.subtitle-text {
  margin: 0;
  font-size: 0.8500000000000001rem;
  color: hsl(34, 39%, 59%);
  line-height: 1.5;
}

.close-action {
  width: 26px;
  height: 26px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(238, 54%, 94%);
  border: none;
  border-radius: 6px;
  color: hsl(34, 54%, 54%);
  cursor: pointer;
  font-size: 1.4rem;
  line-height: 1;
  transition: all 0.2s;
}

.close-action:hover {
  background: hsl(238, 64%, 44%);
  color: white;
  transform: rotate(-90deg);
}

.content-area-20 {
  flex: 1;
  color: hsl(34, 44%, 44%);
  font-size: 1.0rem;
  line-height: 1.7;
}

.default-content {
  margin: 0;
}

.metadata-display-20 {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-top: 1.25rem;
}

.meta-badge-20 {
  padding: 0.375rem 0.75rem;
  background: hsl(136, 64%, 89%);
  color: hsl(136, 64%, 44%);
  border-radius: 14px;
  font-size: 0.8rem;
  font-weight: 500;
}

.actions-footer-20 {
  display: flex;
  gap: 1.0rem;
  padding-top: 1.25rem;
  border-top: 1px solid hsl(34, 44%, 84%);
  justify-content: center;
}

.action-btn-20 {
  padding: 0.75rem 1.8rem;
  background: linear-gradient(124deg,
    hsl(204, 69%, 58%),
    hsl(238, 74%, 52%));
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  font-size: 0.975rem;
  cursor: pointer;
  transition: all 0.3s;
}

.action-btn-20:hover {
  transform: scale(1.05);
  box-shadow: 0 6px 14px hsla(204, 69%, 58%, 0.4);
}
</style>