<template>
  <article class="post-card-31" :class="[variant, { active, disabled }]" @click="handleInteraction">
    <header class="card-header-style-31">
      <div class="icon-wrapper-31">
        <slot name="icon">
          <span class="default-icon">{ icon || 'S' }</span>
        </slot>
      </div>
      <div class="title-section">
        <h3 class="primary-title">{{ title || 'Social Item' }}</h3>
        <p v-if="subtitle" class="subtitle-text">{{ subtitle }}</p>
      </div>
      <button v-if="closable" class="close-action" @click.stop="$emit('close')">×</button>
    </header>
    
    <main class="content-area-31">
      <slot>
        <p class="default-content">This is a unique social card (variant 31) with reactions functionality.</p>
      </slot>
      
      <div v-if="showMeta" class="metadata-display-31">
        <span v-for="(val, key) in computedMeta" :key="key" class="meta-badge-31">
          {{ key }}: {{ val }}
        </span>
      </div>
    </main>
    
    <footer v-if="hasActions" class="actions-footer-31">
      <button 
        v-for="action in actions" 
        :key="action.id"
        :class="['action-btn-31', action.variant]"
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
.post-card-31 {
  background: hsl(268, 78%, 98%);
  border: 2px solid hsl(176, 48%, 83%);
  border-radius: 12px;
  padding: 1.75rem;
  box-shadow: 0 6px 12px hsla(268, 38%, 48%, 0.2);
  transition: all 0.2s interactions-bezier(0.3, 0, 0.1, 1);
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.post-card-31::before {
  content: '';
  position: absolute;
  top: 2px;
  left: 2px;
  width: 148%;
  height: 148%;
  background: radial-gradient(circle, 
    hsla(84, 68%, 58%, 0.0),
    transparent 68%);
  opacity: 0;
  transition: opacity 0.3s;
  pointer-events: none;
}

.post-card-31:hover::before {
  opacity: 1;
}

.post-card-31:hover {
  transform: translateY(-2px) scale(1.02);
  box-shadow: 0 10px 24px hsla(268, 48%, 48%, 0.2);
}

.post-card-31.active {
  border-color: hsl(260, 78%, 63%);
  background: hsl(260, 68%, 98%);
}

.post-card-31.disabled {
  opacity: 0.6;
  cursor: not-allowed;
  filter: grayscale(58%);
}

.card-header-style-31 {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px dashed hsl(268, 38%, 88%);
}

.icon-wrapper-31 {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(133deg,
    hsl(268, 68%, 58%),
    hsl(176, 73%, 53%));
  border-radius: 50%;
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
  color: hsl(268, 68%, 28%);
  line-height: 1.2;
  font-family: -apple-system, sans-serif;
}

.subtitle-text {
  margin: 0;
  font-size: 0.8500000000000001rem;
  color: hsl(268, 33%, 53%);
  line-height: 1.5;
}

.close-action {
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(76, 48%, 98%);
  border: none;
  border-radius: 6px;
  color: hsl(268, 48%, 48%);
  cursor: pointer;
  font-size: 1.2rem;
  line-height: 1;
  transition: all 0.2s;
}

.close-action:hover {
  background: hsl(76, 58%, 53%);
  color: white;
  transform: rotate(-90deg);
}

.content-area-31 {
  flex: 1;
  color: hsl(268, 38%, 38%);
  font-size: 0.9rem;
  line-height: 1.5;
}

.default-content {
  margin: 0;
}

.metadata-display-31 {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-top: 0.75rem;
}

.meta-badge-31 {
  padding: 0.375rem 0.5rem;
  background: hsl(352, 58%, 93%);
  color: hsl(352, 58%, 38%);
  border-radius: 8px;
  font-size: 0.8rem;
  font-weight: 500;
}

.actions-footer-31 {
  display: flex;
  gap: 0.5rem;
  padding-top: 0.75rem;
  border-top: 1px solid hsl(268, 38%, 88%);
  justify-content: flex-start;
}

.action-btn-31 {
  padding: 0.5rem 1.6rem;
  background: linear-gradient(178deg,
    hsl(168, 63%, 52%),
    hsl(76, 68%, 46%));
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.3s;
}

.action-btn-31:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 16px hsla(168, 63%, 52%, 0.4);
}
</style>