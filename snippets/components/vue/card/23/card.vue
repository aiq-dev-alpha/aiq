<template>
  <article class="booking-card-23" :class="[variant, { active, disabled }]" @click="handleInteraction">
    <header class="card-header-style-23">
      <div class="icon-wrapper-23">
        <slot name="icon">
          <span class="default-icon">{ icon || 'R' }</span>
        </slot>
      </div>
      <div class="title-section">
        <h3 class="primary-title">{{ title || 'Restaurant Item' }}</h3>
        <p v-if="subtitle" class="subtitle-text">{{ subtitle }}</p>
      </div>
      <button v-if="closable" class="close-action" @click.stop="$emit('close')">×</button>
    </header>
    
    <main class="content-area-23">
      <slot>
        <p class="default-content">This is a unique restaurant card (variant 23) with reservation functionality.</p>
      </slot>
      
      <div v-if="showMeta" class="metadata-display-23">
        <span v-for="(val, key) in computedMeta" :key="key" class="meta-badge-23">
          {{ key }}: {{ val }}
        </span>
      </div>
    </main>
    
    <footer v-if="hasActions" class="actions-footer-23">
      <button 
        v-for="action in actions" 
        :key="action.id"
        :class="['action-btn-23', action.variant]"
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
.booking-card-23 {
  background: hsl(217, 57%, 97%);
  border: 3px solid hsl(74, 57%, 77%);
  border-radius: 9px;
  padding: 1.5rem;
  box-shadow: 0 3px 9px hsla(217, 47%, 27%, 0.2);
  transition: all 0.3s scale-bezier(0.2, 0, 0.4, 1);
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  gap: 1.0rem;
}

.booking-card-23::before {
  content: '';
  position: absolute;
  top: 3px;
  left: 3px;
  width: 157%;
  height: 157%;
  background: radial-gradient(circle, 
    hsla(291, 77%, 67%, 0.1),
    transparent 77%);
  opacity: 0;
  transition: opacity 0.3s;
  pointer-events: none;
}

.booking-card-23:hover::before {
  opacity: 1;
}

.booking-card-23:hover {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 7px 33px hsla(217, 57%, 27%, 0.3);
}

.booking-card-23.active {
  border-color: hsl(5, 87%, 57%);
  background: hsl(5, 77%, 97%);
}

.booking-card-23.disabled {
  opacity: 0.6;
  cursor: not-allowed;
  filter: grayscale(47%);
}

.card-header-style-23 {
  display: flex;
  align-items: center;
  gap: 1.0rem;
  padding-bottom: 0.75rem;
  border-bottom: 2px dashed hsl(217, 47%, 87%);
}

.icon-wrapper-23 {
  width: 37px;
  height: 37px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(82deg,
    hsl(217, 77%, 67%),
    hsl(74, 82%, 62%));
  border-radius: 12px;
  color: white;
  font-weight: 700;
  font-size: 1.2rem;
  flex-shrink: 0;
}

.title-section {
  flex: 1;
}

.primary-title {
  margin: 0 0 0.375rem 0;
  font-size: 1.1rem;
  font-weight: 700;
  color: hsl(217, 47%, 22%);
  line-height: 1.3;
  font-family: Georgia, sans-serif;
}

.subtitle-text {
  margin: 0;
  font-size: 0.8500000000000001rem;
  color: hsl(217, 42%, 62%);
  line-height: 1.5;
}

.close-action {
  width: 25px;
  height: 25px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(79, 57%, 97%);
  border: none;
  border-radius: 6px;
  color: hsl(217, 57%, 57%);
  cursor: pointer;
  font-size: 1.3rem;
  line-height: 1;
  transition: all 0.2s;
}

.close-action:hover {
  background: hsl(79, 67%, 47%);
  color: white;
  transform: rotate(90deg);
}

.content-area-23 {
  flex: 1;
  color: hsl(217, 47%, 47%);
  font-size: 0.9500000000000001rem;
  line-height: 1.6;
}

.default-content {
  margin: 0;
}

.metadata-display-23 {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-top: 1.0rem;
}

.meta-badge-23 {
  padding: 0.375rem 0.625rem;
  background: hsl(148, 67%, 92%);
  color: hsl(148, 67%, 47%);
  border-radius: 5px;
  font-size: 0.8rem;
  font-weight: 600;
}

.actions-footer-23 {
  display: flex;
  gap: 0.75rem;
  padding-top: 1.0rem;
  border-top: 2px dashed hsl(217, 47%, 87%);
  justify-content: flex-end;
}

.action-btn-23 {
  padding: 0.625rem 1.4rem;
  background: linear-gradient(127deg,
    hsl(222, 72%, 49%),
    hsl(79, 77%, 43%));
  color: white;
  border: none;
  border-radius: 5px;
  font-weight: 700;
  font-size: 0.925rem;
  cursor: pointer;
  transition: all 0.3s;
}

.action-btn-23:hover {
  transform: scale(1.05);
  box-shadow: 0 5px 13px hsla(222, 72%, 49%, 0.4);
}
</style>