<template>
  <article class="player-card-17" :class="[variant, { active, disabled }]" @click="handleInteraction">
    <header class="card-header-style-17">
      <div class="icon-wrapper-17">
        <slot name="icon">
          <span class="default-icon">{ icon || 'M' }</span>
        </slot>
      </div>
      <div class="title-section">
        <h3 class="primary-title">{{ title || 'Music Item' }}</h3>
        <p v-if="subtitle" class="subtitle-text">{{ subtitle }}</p>
      </div>
      <button v-if="closable" class="close-action" @click.stop="$emit('close')">×</button>
    </header>
    
    <main class="content-area-17">
      <slot>
        <p class="default-content">This is a unique music card (variant 17) with controls functionality.</p>
      </slot>
      
      <div v-if="showMeta" class="metadata-display-17">
        <span v-for="(val, key) in computedMeta" :key="key" class="meta-badge-17">
          {{ key }}: {{ val }}
        </span>
      </div>
    </main>
    
    <footer v-if="hasActions" class="actions-footer-17">
      <button 
        v-for="action in actions" 
        :key="action.id"
        :class="['action-btn-17', action.variant]"
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
.player-card-17 {
  background: hsl(306, 56%, 96%);
  border: 2px solid hsl(252, 46%, 76%);
  border-radius: 14px;
  padding: 1.25rem;
  box-shadow: 0 2px 10px hsla(306, 36%, 26%, 0.1);
  transition: all 0.4s fade-bezier(0.1, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.player-card-17::before {
  content: '';
  position: absolute;
  top: 4px;
  left: 4px;
  width: 126%;
  height: 126%;
  background: radial-gradient(circle, 
    hsla(198, 66%, 56%, 0.0),
    transparent 66%);
  opacity: 0;
  transition: opacity 0.3s;
  pointer-events: none;
}

.player-card-17:hover::before {
  opacity: 1;
}

.player-card-17:hover {
  transform: translateY(-4px) scale(1.01);
  box-shadow: 0 8px 22px hsla(306, 46%, 26%, 0.2);
}

.player-card-17.active {
  border-color: hsl(90, 76%, 56%);
  background: hsl(90, 66%, 96%);
}

.player-card-17.disabled {
  opacity: 0.5;
  cursor: not-allowed;
  filter: grayscale(46%);
}

.card-header-style-17 {
  display: flex;
  align-items: flex-start;
  gap: 1.25rem;
  padding-bottom: 1.0rem;
  border-bottom: 1px solid hsl(306, 36%, 86%);
}

.icon-wrapper-17 {
  width: 38px;
  height: 38px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(81deg,
    hsl(306, 66%, 56%),
    hsl(252, 71%, 51%));
  border-radius: 8px;
  color: white;
  font-weight: 600;
  font-size: 1.1rem;
  flex-shrink: 0;
}

.title-section {
  flex: 1;
}

.primary-title {
  margin: 0 0 0.25rem 0;
  font-size: 1.0rem;
  font-weight: 600;
  color: hsl(306, 46%, 21%);
  line-height: 1.4;
  font-family: monospace, sans-serif;
}

.subtitle-text {
  margin: 0;
  font-size: 0.8rem;
  color: hsl(306, 31%, 51%);
  line-height: 1.4;
}

.close-action {
  width: 26px;
  height: 26px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(342, 46%, 96%);
  border: none;
  border-radius: 50%;
  color: hsl(306, 46%, 46%);
  cursor: pointer;
  font-size: 1.4rem;
  line-height: 1;
  transition: all 0.2s;
}

.close-action:hover {
  background: hsl(342, 56%, 46%);
  color: white;
  transform: rotate(-90deg);
}

.content-area-17 {
  flex: 1;
  color: hsl(306, 36%, 36%);
  font-size: 1.0rem;
  line-height: 1.7;
}

.default-content {
  margin: 0;
}

.metadata-display-17 {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: 1.25rem;
}

.meta-badge-17 {
  padding: 0.25rem 0.75rem;
  background: hsl(144, 56%, 91%);
  color: hsl(144, 56%, 36%);
  border-radius: 10px;
  font-size: 0.75rem;
  font-weight: 500;
}

.actions-footer-17 {
  display: flex;
  gap: 1.0rem;
  padding-top: 1.25rem;
  border-top: 1px solid hsl(306, 36%, 86%);
  justify-content: center;
}

.action-btn-17 {
  padding: 0.75rem 1.2rem;
  background: linear-gradient(126deg,
    hsl(36, 61%, 54%),
    hsl(342, 66%, 48%));
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  font-size: 0.975rem;
  cursor: pointer;
  transition: all 0.2s;
}

.action-btn-17:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 14px hsla(36, 61%, 54%, 0.3);
}
</style>