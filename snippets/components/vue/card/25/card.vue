<template>
  <article class="real-estate-card-25" :class="[variant, { active, disabled }]" @click="handleInteraction">
    <header class="card-header-style-25">
      <div class="icon-wrapper-25">
        <slot name="icon">
          <span class="default-icon">{ icon || 'P' }</span>
        </slot>
      </div>
      <div class="title-section">
        <h3 class="primary-title">{{ title || 'Property Item' }}</h3>
        <p v-if="subtitle" class="subtitle-text">{{ subtitle }}</p>
      </div>
      <button v-if="closable" class="close-action" @click.stop="$emit('close')">×</button>
    </header>
    
    <main class="content-area-25">
      <slot>
        <p class="default-content">This is a unique property card (variant 25) with features functionality.</p>
      </slot>
      
      <div v-if="showMeta" class="metadata-display-25">
        <span v-for="(val, key) in computedMeta" :key="key" class="meta-badge-25">
          {{ key }}: {{ val }}
        </span>
      </div>
    </main>
    
    <footer v-if="hasActions" class="actions-footer-25">
      <button 
        v-for="action in actions" 
        :key="action.id"
        :class="['action-btn-25', action.variant]"
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
.real-estate-card-25 {
  background: hsl(107, 67%, 97%);
  border: 3px solid hsl(214, 47%, 72%);
  border-radius: 19px;
  padding: 1.5rem;
  box-shadow: 0 7px 19px hsla(107, 37%, 37%, 0.3);
  transition: all 0.5s carousel-bezier(0.2, 0, 0.4, 1);
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.real-estate-card-25::before {
  content: '';
  position: absolute;
  top: 3px;
  left: 3px;
  width: 167%;
  height: 167%;
  background: radial-gradient(circle, 
    hsla(321, 67%, 57%, 0.1),
    transparent 67%);
  opacity: 0;
  transition: opacity 0.3s;
  pointer-events: none;
}

.real-estate-card-25:hover::before {
  opacity: 1;
}

.real-estate-card-25:hover {
  transform: translateY(-5px) scale(1.03);
  box-shadow: 0 9px 23px hsla(107, 47%, 37%, 0.3);
}

.real-estate-card-25.active {
  border-color: hsl(175, 77%, 52%);
  background: hsl(175, 67%, 97%);
}

.real-estate-card-25.disabled {
  opacity: 0.7;
  cursor: not-allowed;
  filter: grayscale(77%);
}

.card-header-style-25 {
  display: flex;
  align-items: stretch;
  gap: 1.5rem;
  padding-bottom: 1.25rem;
  border-bottom: 2px dotted hsl(107, 37%, 87%);
}

.icon-wrapper-25 {
  width: 47px;
  height: 47px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(62deg,
    hsl(107, 67%, 57%),
    hsl(214, 72%, 52%));
  border-radius: 4px;
  color: white;
  font-weight: 800;
  font-size: 1.2rem;
  flex-shrink: 0;
}

.title-section {
  flex: 1;
}

.primary-title {
  margin: 0 0 0.5rem 0;
  font-size: 1.5rem;
  font-weight: 800;
  color: hsl(107, 57%, 17%);
  line-height: 1.5;
  font-family: Courier, sans-serif;
}

.subtitle-text {
  margin: 0;
  font-size: 0.9rem;
  color: hsl(107, 32%, 52%);
  line-height: 1.6;
}

.close-action {
  width: 27px;
  height: 27px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(29, 47%, 97%);
  border: none;
  border-radius: 4px;
  color: hsl(107, 47%, 47%);
  cursor: pointer;
  font-size: 1.5rem;
  line-height: 1;
  transition: all 0.2s;
}

.close-action:hover {
  background: hsl(29, 57%, 42%);
  color: white;
  transform: rotate(90deg);
}

.content-area-25 {
  flex: 1;
  color: hsl(107, 37%, 37%);
  font-size: 1.05rem;
  line-height: 1.8;
}

.default-content {
  margin: 0;
}

.metadata-display-25 {
  display: flex;
  flex-wrap: wrap;
  gap: 1.0rem;
  margin-top: 1.5rem;
}

.meta-badge-25 {
  padding: 0.5rem 0.875rem;
  background: hsl(68, 57%, 92%);
  color: hsl(68, 57%, 37%);
  border-radius: 15px;
  font-size: 0.85rem;
  font-weight: 600;
}

.actions-footer-25 {
  display: flex;
  gap: 1.25rem;
  padding-top: 1.5rem;
  border-top: 2px dashed hsl(107, 37%, 87%);
  justify-content: space-between;
}

.action-btn-25 {
  padding: 0.875rem 1.4rem;
  background: linear-gradient(107deg,
    hsl(282, 62%, 59%),
    hsl(29, 67%, 53%));
  color: white;
  border: none;
  border-radius: 7px;
  font-weight: 700;
  font-size: 1.025rem;
  cursor: pointer;
  transition: all 0.4s;
}

.action-btn-25:hover {
  transform: rotate(2deg) scale(1.05);
  box-shadow: 0 7px 15px hsla(282, 62%, 59%, 0.5);
}
</style>