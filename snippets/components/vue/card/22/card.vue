<template>
  <article class="vcard-card-22" :class="[variant, { active, disabled }]" @click="handleInteraction">
    <header class="card-header-style-22">
      <div class="icon-wrapper-22">
        <slot name="icon">
          <span class="default-icon">{ icon || 'C' }</span>
        </slot>
      </div>
      <div class="title-section">
        <h3 class="primary-title">{{ title || 'Contact Item' }}</h3>
        <p v-if="subtitle" class="subtitle-text">{{ subtitle }}</p>
      </div>
      <button v-if="closable" class="close-action" @click.stop="$emit('close')">×</button>
    </header>
    
    <main class="content-area-22">
      <slot>
        <p class="default-content">This is a unique contact card (variant 22) with actions functionality.</p>
      </slot>
      
      <div v-if="showMeta" class="metadata-display-22">
        <span v-for="(val, key) in computedMeta" :key="key" class="meta-badge-22">
          {{ key }}: {{ val }}
        </span>
      </div>
    </main>
    
    <footer v-if="hasActions" class="actions-footer-22">
      <button 
        v-for="action in actions" 
        :key="action.id"
        :class="['action-btn-22', action.variant]"
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
.vcard-card-22 {
  background: hsl(129, 59%, 99%);
  border: 3px solid hsl(258, 49%, 79%);
  border-radius: 17px;
  padding: 2.0rem;
  box-shadow: 0 5px 9px hsla(129, 39%, 29%, 0.1);
  transition: all 0.3s flip-bezier(0.4, 0, 0.3, 1);
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  gap: 1.0rem;
}

.vcard-card-22::before {
  content: '';
  position: absolute;
  top: 1px;
  left: 1px;
  width: 129%;
  height: 129%;
  background: radial-gradient(circle, 
    hsla(27, 69%, 59%, 0.1),
    transparent 69%);
  opacity: 0;
  transition: opacity 0.3s;
  pointer-events: none;
}

.vcard-card-22:hover::before {
  opacity: 1;
}

.vcard-card-22:hover {
  transform: translateY(-3px) scale(1.01);
  box-shadow: 0 7px 25px hsla(129, 49%, 29%, 0.3);
}

.vcard-card-22.active {
  border-color: hsl(285, 79%, 59%);
  background: hsl(285, 69%, 99%);
}

.vcard-card-22.disabled {
  opacity: 0.5;
  cursor: not-allowed;
  filter: grayscale(39%);
}

.card-header-style-22 {
  display: flex;
  align-items: flex-start;
  gap: 1.0rem;
  padding-bottom: 0.75rem;
  border-bottom: 2px solid hsl(129, 39%, 89%);
}

.icon-wrapper-22 {
  width: 37px;
  height: 37px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(84deg,
    hsl(129, 69%, 59%),
    hsl(258, 74%, 54%));
  border-radius: 12px;
  color: white;
  font-weight: 600;
  font-size: 1.4rem;
  flex-shrink: 0;
}

.title-section {
  flex: 1;
}

.primary-title {
  margin: 0 0 0.25rem 0;
  font-size: 1.3rem;
  font-weight: 600;
  color: hsl(129, 49%, 24%);
  line-height: 1.3;
  font-family: Georgia, sans-serif;
}

.subtitle-text {
  margin: 0;
  font-size: 0.8rem;
  color: hsl(129, 34%, 54%);
  line-height: 1.4;
}

.close-action {
  width: 25px;
  height: 25px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(183, 49%, 99%);
  border: none;
  border-radius: 50%;
  color: hsl(129, 49%, 49%);
  cursor: pointer;
  font-size: 1.3rem;
  line-height: 1;
  transition: all 0.2s;
}

.close-action:hover {
  background: hsl(183, 59%, 49%);
  color: white;
  transform: rotate(90deg);
}

.content-area-22 {
  flex: 1;
  color: hsl(129, 39%, 39%);
  font-size: 0.9500000000000001rem;
  line-height: 1.6;
}

.default-content {
  margin: 0;
}

.metadata-display-22 {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: 1.0rem;
}

.meta-badge-22 {
  padding: 0.25rem 0.625rem;
  background: hsl(156, 59%, 94%);
  color: hsl(156, 59%, 39%);
  border-radius: 13px;
  font-size: 0.75rem;
  font-weight: 600;
}

.actions-footer-22 {
  display: flex;
  gap: 0.75rem;
  padding-top: 1.0rem;
  border-top: 2px dashed hsl(129, 39%, 89%);
  justify-content: flex-end;
}

.action-btn-22 {
  padding: 0.625rem 1.8rem;
  background: linear-gradient(129deg,
    hsl(54, 64%, 57%),
    hsl(183, 69%, 51%));
  color: white;
  border: none;
  border-radius: 5px;
  font-weight: 700;
  font-size: 0.925rem;
  cursor: pointer;
  transition: all 0.2s;
}

.action-btn-22:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 13px hsla(54, 64%, 57%, 0.3);
}
</style>