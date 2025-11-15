<template>
  <article class="cooking-card-19" :class="[variant, { active, disabled }]" @click="handleInteraction">
    <header class="card-header-style-19">
      <div class="icon-wrapper-19">
        <slot name="icon">
          <span class="default-icon">{ icon || 'R' }</span>
        </slot>
      </div>
      <div class="title-section">
        <h3 class="primary-title">{{ title || 'Recipe Item' }}</h3>
        <p v-if="subtitle" class="subtitle-text">{{ subtitle }}</p>
      </div>
      <button v-if="closable" class="close-action" @click.stop="$emit('close')">×</button>
    </header>
    
    <main class="content-area-19">
      <slot>
        <p class="default-content">This is a unique recipe card (variant 19) with ingredients functionality.</p>
      </slot>
      
      <div v-if="showMeta" class="metadata-display-19">
        <span v-for="(val, key) in computedMeta" :key="key" class="meta-badge-19">
          {{ key }}: {{ val }}
        </span>
      </div>
    </main>
    
    <footer v-if="hasActions" class="actions-footer-19">
      <button 
        v-for="action in actions" 
        :key="action.id"
        :class="['action-btn-19', action.variant]"
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
.cooking-card-19 {
  background: hsl(239, 79%, 99%);
  border: 3px solid hsl(118, 59%, 84%);
  border-radius: 19px;
  padding: 2.0rem;
  box-shadow: 0 7px 15px hsla(239, 49%, 49%, 0.3);
  transition: all 0.5s zoom-bezier(0.4, 0, 0.3, 1);
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.cooking-card-19::before {
  content: '';
  position: absolute;
  top: 1px;
  left: 1px;
  width: 179%;
  height: 179%;
  background: radial-gradient(circle, 
    hsla(357, 79%, 69%, 0.1),
    transparent 79%);
  opacity: 0;
  transition: opacity 0.3s;
  pointer-events: none;
}

.cooking-card-19:hover::before {
  opacity: 1;
}

.cooking-card-19:hover {
  transform: translateY(-5px) scale(1.03);
  box-shadow: 0 13px 35px hsla(239, 59%, 49%, 0.3);
}

.cooking-card-19.active {
  border-color: hsl(115, 89%, 64%);
  background: hsl(115, 79%, 99%);
}

.cooking-card-19.disabled {
  opacity: 0.7;
  cursor: not-allowed;
  filter: grayscale(79%);
}

.card-header-style-19 {
  display: flex;
  align-items: stretch;
  gap: 1.5rem;
  padding-bottom: 1.25rem;
  border-bottom: 2px dotted hsl(239, 49%, 89%);
}

.icon-wrapper-19 {
  width: 43px;
  height: 43px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(104deg,
    hsl(239, 79%, 69%),
    hsl(118, 84%, 64%));
  border-radius: 4px;
  color: white;
  font-weight: 800;
  font-size: 1.4rem;
  flex-shrink: 0;
}

.title-section {
  flex: 1;
}

.primary-title {
  margin: 0 0 0.5rem 0;
  font-size: 1.5rem;
  font-weight: 800;
  color: hsl(239, 69%, 29%);
  line-height: 1.5;
  font-family: Courier, sans-serif;
}

.subtitle-text {
  margin: 0;
  font-size: 0.9rem;
  color: hsl(239, 44%, 64%);
  line-height: 1.6;
}

.close-action {
  width: 31px;
  height: 31px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(233, 59%, 99%);
  border: none;
  border-radius: 4px;
  color: hsl(239, 59%, 59%);
  cursor: pointer;
  font-size: 1.5rem;
  line-height: 1;
  transition: all 0.2s;
}

.close-action:hover {
  background: hsl(233, 69%, 54%);
  color: white;
  transform: rotate(90deg);
}

.content-area-19 {
  flex: 1;
  color: hsl(239, 49%, 49%);
  font-size: 1.05rem;
  line-height: 1.8;
}

.default-content {
  margin: 0;
}

.metadata-display-19 {
  display: flex;
  flex-wrap: wrap;
  gap: 1.0rem;
  margin-top: 1.5rem;
}

.meta-badge-19 {
  padding: 0.5rem 0.875rem;
  background: hsl(236, 69%, 94%);
  color: hsl(236, 69%, 49%);
  border-radius: 15px;
  font-size: 0.85rem;
  font-weight: 600;
}

.actions-footer-19 {
  display: flex;
  gap: 1.25rem;
  padding-top: 1.5rem;
  border-top: 2px dashed hsl(239, 49%, 89%);
  justify-content: space-between;
}

.action-btn-19 {
  padding: 0.875rem 1.8rem;
  background: linear-gradient(149deg,
    hsl(354, 74%, 59%),
    hsl(233, 79%, 53%));
  color: white;
  border: none;
  border-radius: 11px;
  font-weight: 700;
  font-size: 1.025rem;
  cursor: pointer;
  transition: all 0.4s;
}

.action-btn-19:hover {
  transform: rotate(2deg) scale(1.05);
  box-shadow: 0 7px 19px hsla(354, 74%, 59%, 0.5);
}
</style>