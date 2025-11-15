<template>
  <div
    :style="cardStyles"
    :class="cardClasses"
    @click="handleClick"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false">
    <div v-if="corner" class="card-corner" :style="cornerStyles">{{ corner }}</div>

    <div v-if="image || $slots.media" class="card-media">
      <img v-if="image" :src="image" :alt="imageAlt" class="card-img" />
      <div v-if="overlay" class="media-overlay">
        <slot name="overlay"></slot>
      </div>
      <slot name="media"></slot>
    </div>

    <div class="card-body" :style="bodyStyles">
      <header v-if="title || subtitle || $slots.header" class="card-header">
        <div class="header-main">
          <span v-if="category" class="card-category">{{ category }}</span>
          <p v-if="subtitle" class="card-subtitle">{{ subtitle }}</p>
          <h3 v-if="title" class="card-title">{{ title }}</h3>
        </div>
        <div v-if="$slots.headerAction" class="header-action">
          <slot name="headerAction"></slot>
        </div>
        <slot name="header"></slot>
      </header>

      <div class="card-content">
        <slot></slot>
      </div>

      <footer v-if="$slots.footer || actions.length > 0" class="card-footer">
        <slot name="footer"></slot>
        <div v-if="actions.length > 0" class="footer-actions">
          <button
            v-for="(action, idx) in actions"
            :key="idx"
            @click.stop="action.onClick"
            class="action-button"
            :style="actionStyles">
            {{ action.label }}
          </button>
        </div>
      </footer>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed, ref, PropType } from 'vue';

interface CardTheme {
  background: string;
  foreground: string;
  border: string;
  accent: string;
  shadow: string;
  muted: string;
  gradient: string;
}

interface CardAction {
  label: string;
  onClick: () => void;
}

type CardVariant = 'flat' | 'elevated' | 'outlined' | 'neumorphic';

export default defineComponent({
  name: 'Card',
  props: {
    variant: {
      type: String as PropType<CardVariant>,
      default: 'elevated'
    },
    theme: {
      type: Object as PropType<Partial<CardTheme>>,
      default: () => ({})
    },
    title: {
      type: String,
      default: ''
    },
    subtitle: {
      type: String,
      default: ''
    },
    category: {
      type: String,
      default: ''
    },
    image: {
      type: String,
      default: ''
    },
    imageAlt: {
      type: String,
      default: 'Card image'
    },
    corner: {
      type: String,
      default: ''
    },
    overlay: {
      type: Boolean,
      default: false
    },
    hoverable: {
      type: Boolean,
      default: false
    },
    clickable: {
      type: Boolean,
      default: false
    },
    actions: {
      type: Array as PropType<CardAction[]>,
      default: () => []
    },
    padding: {
      type: String,
      default: 'md'
    }
  },
  emits: ['click'],
  setup(props, { emit }) {
    const isHovered = ref(false);

    const defaultTheme: CardTheme = {
      background: '#f9fafb',
      foreground: '#111827',
      border: '#d1d5db',
      accent: '#6366f1',
      shadow: 'rgba(99, 102, 241, 0.15)',
      muted: '#6b7280',
      gradient: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
    };

    const appliedTheme = computed(() => ({
      ...defaultTheme,
      ...props.theme
    }));

    const paddingMap: Record<string, string> = {
      none: '0',
      sm: '14px',
      md: '22px',
      lg: '30px',
      xl: '40px'
    };

    const bodyStyles = computed(() => ({
      padding: paddingMap[props.padding]
    }));

    const variantMap = computed(() => {
      const t = appliedTheme.value;
      return {
        flat: {
          background: t.background,
          border: 'none',
          boxShadow: 'none'
        },
        elevated: {
          background: t.background,
          border: 'none',
          boxShadow: `0 6px 16px ${t.shadow}, 0 2px 4px rgba(0, 0, 0, 0.06)`
        },
        outlined: {
          background: t.background,
          border: `2px solid ${t.border}`,
          boxShadow: '0 2px 4px rgba(0, 0, 0, 0.04)'
        },
        neumorphic: {
          background: t.background,
          border: 'none',
          boxShadow: `8px 8px 16px ${t.shadow}, -8px -8px 16px rgba(255, 255, 255, 0.7)`
        }
      };
    });

    const cardStyles = computed(() => ({
      ...variantMap.value[props.variant],
      color: appliedTheme.value.foreground,
      borderRadius: '18px',
      overflow: 'hidden',
      cursor: props.clickable ? 'pointer' : 'default',
      transition: 'all 0.35s cubic-bezier(0.4, 0, 0.2, 1)',
      transform: props.hoverable && isHovered.value ? 'translateY(-6px) scale(1.015)' : 'none',
      boxShadow: props.hoverable && isHovered.value
        ? `0 20px 40px ${appliedTheme.value.shadow}, 0 6px 12px rgba(0, 0, 0, 0.12)`
        : variantMap.value[props.variant].boxShadow,
      position: 'relative' as const
    }));

    const cardClasses = computed(() => ({
      [`variant-${props.variant}`]: true,
      'is-hoverable': props.hoverable,
      'is-clickable': props.clickable,
      'is-hovered': isHovered.value
    }));

    const cornerStyles = computed(() => ({
      background: appliedTheme.value.gradient,
      boxShadow: `0 3px 10px ${appliedTheme.value.shadow}`
    }));

    const actionStyles = computed(() => ({
      background: `${appliedTheme.value.accent}12`,
      color: appliedTheme.value.accent,
      border: `1.5px solid ${appliedTheme.value.accent}35`
    }));

    const handleClick = (event: MouseEvent) => {
      if (props.clickable) {
        emit('click', event);
      }
    };

    return {
      isHovered,
      cardStyles,
      cardClasses,
      bodyStyles,
      cornerStyles,
      actionStyles,
      handleClick
    };
  }
});
</script>

<style scoped>
.card-corner {
  position: absolute;
  top: 0;
  right: 0;
  color: white;
  padding: 8px 16px;
  font-size: 11px;
  font-weight: 800;
  z-index: 1;
  border-bottom-left-radius: 12px;
  letter-spacing: 0.8px;
  text-transform: uppercase;
}
.card-media {
  width: 100%;
  overflow: hidden;
  position: relative;
}
.card-img {
  width: 100%;
  height: 240px;
  object-fit: cover;
  display: block;
  transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}
.is-hoverable:hover .card-img {
  transform: scale(1.08);
}
.media-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(0,0,0,0.7), transparent);
  display: flex;
  align-items: flex-end;
  padding: 20px;
  color: white;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 18px;
  margin-bottom: 18px;
}
.header-main {
  flex: 1;
}
.card-category {
  display: inline-block;
  margin: 0 0 8px;
  font-size: 0.7rem;
  text-transform: uppercase;
  letter-spacing: 1px;
  opacity: 0.75;
  font-weight: 800;
  color: currentColor;
}
.card-subtitle {
  margin: 0 0 8px;
  font-size: 0.8125rem;
  opacity: 0.7;
  font-weight: 600;
  letter-spacing: 0.3px;
}
.card-title {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 900;
  line-height: 1.25;
  letter-spacing: -0.5px;
}
.card-content {
  font-size: 0.9375rem;
  line-height: 1.7;
  opacity: 0.88;
  letter-spacing: 0.15px;
}
.card-footer {
  margin-top: 24px;
  padding-top: 24px;
  border-top: 2px solid rgba(0, 0, 0, 0.07);
}
.footer-actions {
  display: flex;
  gap: 12px;
  align-items: center;
  flex-wrap: wrap;
}
.action-button {
  padding: 9px 18px;
  border-radius: 9px;
  font-size: 13px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.25s ease;
  letter-spacing: 0.4px;
}
.action-button:hover {
  transform: translateY(-2px);
  filter: brightness(1.15);
}
</style>
