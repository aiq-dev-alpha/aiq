<template>
  <div
    :class="['card', `card--${variant}`, { 'card--hoverable': hoverable, 'card--clickable': clickable }]"
    :style="cardStyles"
    @click="handleClick"
  >
    <div v-if="image" class="card__media">
      <img :src="image" :alt="imageAlt || title" class="card__image" />
      <div v-if="$slots.overlay" class="card__overlay">
        <slot name="overlay" />
      </div>
    </div>

    <div class="card__header" v-if="title || subtitle || $slots.actions">
      <div class="card__header-content">
        <h3 v-if="title" class="card__title">{{ title }}</h3>
        <p v-if="subtitle" class="card__subtitle">{{ subtitle }}</p>
      </div>
      <div v-if="$slots.actions" class="card__actions">
        <slot name="actions" />
      </div>
    </div>

    <div class="card__body">
      <p v-if="description" class="card__description">{{ description }}</p>
      <slot />
    </div>

    <div v-if="$slots.footer || actions?.length" class="card__footer">
      <slot name="footer">
        <button
          v-for="(action, index) in actions"
          :key="index"
          @click.stop="action.onClick"
          class="card__button"
        >
          {{ action.label }}
        </button>
      </slot>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed, PropType } from 'vue';

interface CardTheme {
  background: string;
  foreground: string;
  border: string;
  accent: string;
  shadow: string;
  muted: string;
}

interface CardAction {
  label: string;
  onClick: () => void;
}

export default defineComponent({
  name: 'Card',
  props: {
    variant: {
      type: String as PropType<'default' | 'elevated' | 'outlined' | 'gradient' | 'glass' | 'neumorphic'>,
      default: 'default'
    },
    title: {
      type: String,
      default: ''
    },
    subtitle: {
      type: String,
      default: ''
    },
    description: {
      type: String,
      default: ''
    },
    image: {
      type: String,
      default: ''
    },
    imageAlt: {
      type: String,
      default: ''
    },
    hoverable: {
      type: Boolean,
      default: true
    },
    clickable: {
      type: Boolean,
      default: false
    },
    actions: {
      type: Array as PropType<CardAction[]>,
      default: () => []
    },
    theme: {
      type: Object as PropType<Partial<CardTheme>>,
      default: () => ({})
    }
  },
  emits: ['click'],
  setup(props, { emit }) {
    // Midnight Theme - Dark blues and black
    const defaultTheme: CardTheme = {
      background: 'linear-gradient(135deg, #0a0e27 0%, #1a1d3a 50%, #2d3250 100%)',
      foreground: '#e5e7eb',
      border: '#4f46e5',
      accent: '#6366f1',
      shadow: 'rgba(79, 70, 229, 0.5)',
      muted: '#9ca3af'
    };

    const appliedTheme = { ...defaultTheme, ...props.theme };

    const cardStyles = computed(() => ({
      '--card-background': appliedTheme.background,
      '--card-foreground': appliedTheme.foreground,
      '--card-border': appliedTheme.border,
      '--card-accent': appliedTheme.accent,
      '--card-shadow': appliedTheme.shadow,
      '--card-muted': appliedTheme.muted,
    }));

    const handleClick = () => {
      if (props.clickable) {
        emit('click');
      }
    };

    return { cardStyles, handleClick };
  }
});
</script>

<style scoped>
.card {
  background: var(--card-background);
  color: var(--card-foreground);
  border-radius: 18px;
  overflow: hidden;
  transition: all 0.35s ease;
  position: relative;
  border: 1px solid rgba(79, 70, 229, 0.1);
}

.card--default {
  box-shadow:
    0 4px 12px var(--card-shadow),
    0 0 0 1px rgba(79, 70, 229, 0.1);
}

.card--elevated {
  box-shadow:
    0 15px 40px -12px var(--card-shadow),
    0 0 0 1px rgba(79, 70, 229, 0.15);
  transform: translateY(0);
}

.card--outlined {
  border: 2px solid var(--card-border);
  box-shadow: 0 0 20px rgba(79, 70, 229, 0.2);
}

.card--gradient {
  background: var(--card-background);
  box-shadow: 0 8px 24px var(--card-shadow);
}

.card--glass {
  background: rgba(26, 29, 58, 0.5);
  backdrop-filter: blur(16px);
  border: 1px solid rgba(99, 102, 241, 0.2);
  box-shadow:
    0 8px 32px var(--card-shadow),
    inset 0 0 20px rgba(99, 102, 241, 0.05);
}

.card--neumorphic {
  background: #1a1d3a;
  box-shadow:
    10px 10px 20px rgba(5, 7, 20, 0.8),
    -10px -10px 20px rgba(40, 45, 70, 0.2);
}

.card--hoverable:hover {
  transform: translateY(-5px);
  box-shadow:
    0 25px 50px -15px var(--card-shadow),
    0 0 30px rgba(79, 70, 229, 0.2);
  border-color: rgba(79, 70, 229, 0.3);
}

.card--clickable {
  cursor: pointer;
}

.card--clickable:active {
  transform: translateY(-2px);
}

.card__media {
  position: relative;
  width: 100%;
  aspect-ratio: 16 / 9;
  overflow: hidden;
}

.card__image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s ease, filter 0.4s ease;
  filter: brightness(0.85);
}

.card--hoverable:hover .card__image {
  transform: scale(1.07);
  filter: brightness(1);
}

.card__overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(10, 14, 39, 0.95) 0%, transparent 100%);
  display: flex;
  align-items: flex-end;
  padding: 1.5rem;
}

.card__header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 1.5rem 1.5rem 0;
  gap: 1rem;
}

.card__header-content {
  flex: 1;
}

.card__title {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--card-foreground);
  letter-spacing: -0.025em;
}

.card__subtitle {
  margin: 0.5rem 0 0;
  font-size: 0.875rem;
  color: var(--card-muted);
  font-weight: 500;
}

.card__actions {
  display: flex;
  gap: 0.5rem;
}

.card__body {
  padding: 1.5rem;
}

.card__description {
  margin: 0;
  font-size: 1rem;
  line-height: 1.6;
  color: var(--card-muted);
}

.card__footer {
  padding: 1rem 1.5rem 1.5rem;
  display: flex;
  gap: 0.75rem;
  border-top: 1px solid rgba(99, 102, 241, 0.15);
}

.card__button {
  padding: 0.625rem 1.25rem;
  background: var(--card-accent);
  color: #ffffff;
  border: none;
  border-radius: 10px;
  font-weight: 600;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.25s ease;
  box-shadow: 0 0 20px rgba(79, 70, 229, 0.3);
}

.card__button:hover {
  background: var(--card-border);
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(79, 70, 229, 0.5);
}


@keyframes enter {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}

@keyframes slideDown {
  from { transform: translateY(-10px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

@keyframes glow {
  0%, 100% { box-shadow: 0 0 5px currentColor; }
  50% { box-shadow: 0 0 20px currentColor; }
}
</style>
