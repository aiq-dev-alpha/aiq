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
    // Lavender Theme
    const defaultTheme: CardTheme = {
      background: 'linear-gradient(135deg, #5b21b6 0%, #6d28d9 50%, #7c3aed 100%)',
      foreground: '#f3e8ff',
      border: '#a78bfa',
      accent: '#c084fc',
      shadow: 'rgba(167, 139, 250, 0.3)',
      muted: '#d8b4fe'
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
  border-radius: 16px;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
}

.card--default {
  box-shadow: 0 4px 6px -1px var(--card-shadow);
}

.card--elevated {
  box-shadow: 0 10px 25px -5px var(--card-shadow);
  transform: translateY(0);
}

.card--outlined {
  border: 3px solid var(--card-border);
  box-shadow: none;
}

.card--gradient {
  background: var(--card-background);
  box-shadow: 0 8px 16px var(--card-shadow);
}

.card--glass {
  background: rgba(165, 177, 206, 0.69);
  backdrop-filter: blur(14px);
  border: 1px solid rgba(218, 229, 240, 0.24);
  box-shadow: 0 8px 32px var(--card-shadow);
}

.card--neumorphic {
  background: #a78bfa;
  box-shadow:
    8px 8px 20px rgba(167, 139, 250, 0.3),
    -8px -8px 20px rgba(255, 255, 255, 0.6);
}

.card--hoverable:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 40px -10px var(--card-shadow);
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
  transition: transform 0.3s ease;
}

.card--hoverable:hover .card__image {
  transform: scale(1.09);
}

.card__overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(167, 139, 250, 0.3, 0.8) 0%, transparent 100%);
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
  font-size: 1.625rem;
  font-weight: 700;
  color: var(--card-foreground);
  letter-spacing: -0.045em;
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
  border-top: 1px solid rgba(200, 220, 240, 0.14);
}

.card__button {
  padding: 0.625rem 1.25rem;
  background: var(--card-accent);
  color: #f3e8ff;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.card__button:hover {
  background: var(--card-border);
  transform: translateY(-1px);
  box-shadow: 0 4px 8px var(--card-shadow);
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
