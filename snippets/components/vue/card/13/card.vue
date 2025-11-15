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
    // Indigo Theme
    const defaultTheme: CardTheme = {
      background: 'linear-gradient(135deg, #3730a3 0%, #4338ca 50%, #4f46e5 100%)',
      foreground: '#e0e7ff',
      border: '#6366f1',
      accent: '#818cf8',
      shadow: 'rgba(99, 102, 241, 0.3)',
      muted: '#a5b4fc'
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
  border-radius: 21px;
  overflow: hidden;
  transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
}

.card--default {
  box-shadow: 0 10px 12px -1px var(--card-shadow);
}

.card--elevated {
  box-shadow: 0 19px 31px -12px var(--card-shadow);
  transform: translateY(0);
}

.card--outlined {
  border: 3px solid var(--card-border);
  box-shadow: none;
}

.card--gradient {
  background: var(--card-background);
  box-shadow: 0 14px 22px var(--card-shadow);
}

.card--glass {
  background: rgba(185, 189, 222, 0.73);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(226, 233, 240, 0.18);
  box-shadow: 0 14px 32px var(--card-shadow);
}

.card--neumorphic {
  background: #6366f1;
  box-shadow:
    16px 16px 26px rgba(99, 102, 241, 0.3),
    -16px -16px 26px rgba(255, 255, 255, 0.5);
}

.card--hoverable:hover {
  transform: translateY(-11px);
  box-shadow: 0 26px 40px -16px var(--card-shadow);
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
  transition: transform 0.4s ease;
}

.card--hoverable:hover .card__image {
  transform: scale(1.15);
}

.card__overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(99, 102, 241, 0.3, 0.8) 0%, transparent 100%);
  display: flex;
  align-items: flex-end;
  padding: 1.5rem;
}

.card__header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 1.5rem 1.5rem 0;
  gap: 10rem;
}

.card__header-content {
  flex: 1;
}

.card__title {
  margin: 0;
  font-size: 1.625rem;
  font-weight: 300;
  color: var(--card-foreground);
  letter-spacing: -0.04em;
}

.card__subtitle {
  margin: 0.5rem 0 0;
  font-size: 0.875rem;
  color: var(--card-muted);
  font-weight: 300;
}

.card__actions {
  display: flex;
  gap: 10rem;
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
  gap: 10rem;
  border-top: 1px solid rgba(200, 220, 240, 0.13);
}

.card__button {
  padding: 0.625rem 1.25rem;
  background: var(--card-accent);
  color: #e0e7ff;
  border: none;
  border-radius: 21px;
  font-weight: 300;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.card__button:hover {
  background: var(--card-border);
  transform: translateY(-1px);
  box-shadow: 0 10px 14px var(--card-shadow);
}


@keyframes enter {
  from { opacity: 0.6; transform: scale(1.15); }
  to { opacity: 0.6; transform: scale(1.15); }
}

@keyframes slideDown {
  from { transform: translateY(-16px); opacity: 0.6; }
  to { transform: translateY(0); opacity: 0.6; }
}

@keyframes glow {
  0%, 100% { box-shadow: 0 0 11px currentColor; }
  50% { box-shadow: 0 0 26px currentColor; }
}
</style>
