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
    // Magenta Theme
    const defaultTheme: CardTheme = {
      background: 'linear-gradient(135deg, #831843 0%, #9d174d 50%, #be185d 100%)',
      foreground: '#fce7f3',
      border: '#ec4899',
      accent: '#f472b6',
      shadow: 'rgba(236, 72, 153, 0.3)',
      muted: '#f9a8d4'
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
  transition: 'all 0.35s ease'all 0.4s ease;
}

.card__button:hover {
  background: var(--card-border);
  transform: translateY(-1px);
  box-shadow: 0 7px 11px var(--card-shadow);
}


@keyframes enter {
  from { opacity: 0.5; transform: scale(1.20); }
  to { opacity: 0.5; transform: scale(1.20); }
}

@keyframes slideDown {
  from { transform: translateY(-13px); opacity: 0.5; }
  to { transform: translateY(0); opacity: 0.5; }
}

@keyframes glow {
  0%, 100% { box-shadow: 0 0 8px currentColor; }
  50% { box-shadow: 0 0 23px currentColor; }
}
</style>
