<template>
  <div
    :style="cardStyles"
    :class="cardClasses"
    @click="handleClick"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false">
    <div v-if="ribbon" class="card-ribbon" :style="ribbonStyles">{{ ribbon }}</div>

    <div v-if="image || $slots.media" class="card-media">
      <img v-if="image" :src="image" :alt="imageAlt" class="card-image" />
      <slot name="media"></slot>
    </div>

    <div class="card-body" :style="bodyStyles">
      <header v-if="title || subtitle || $slots.header" class="card-header">
        <div class="header-content">
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
            @click="action.onClick"
            class="action-btn"
            :style="actionButtonStyles">
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
}

interface CardAction {
  label: string;
  onClick: () => void;
}

type CardVariant = 'flat' | 'elevated' | 'outlined' | 'glass';

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
    image: {
      type: String,
      default: ''
    },
    imageAlt: {
      type: String,
      default: 'Card image'
    },
    ribbon: {
      type: String,
      default: ''
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
      background: '#ffffff',
      foreground: '#0f172a',
      border: '#e2e8f0',
      accent: '#3b82f6',
      shadow: 'rgba(59, 130, 246, 0.12)',
      muted: '#64748b'
    };

    const appliedTheme = computed(() => ({
      ...defaultTheme,
      ...props.theme
    }));

    const paddingMap: Record<string, string> = {
      none: '0',
      sm: '12px',
      md: '20px',
      lg: '28px',
      xl: '36px'
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
          boxShadow: `0 4px 12px ${t.shadow}, 0 1px 3px rgba(0, 0, 0, 0.08)`
        },
        outlined: {
          background: t.background,
          border: `2px solid ${t.border}`,
          boxShadow: '0 1px 2px rgba(0, 0, 0, 0.05)'
        },
        glass: {
          background: `${t.background}dd`,
          border: `1px solid ${t.border}60`,
          boxShadow: `0 8px 32px ${t.shadow}`,
          backdropFilter: 'blur(12px)'
        }
      };
    });

    const cardStyles = computed(() => ({
      ...variantMap.value[props.variant],
      color: appliedTheme.value.foreground,
      borderRadius: '14px',
      overflow: 'hidden',
      cursor: props.clickable ? 'pointer' : 'default',
      transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
      transform: props.hoverable && isHovered.value ? 'translateY(-4px)' : 'none',
      boxShadow: props.hoverable && isHovered.value
        ? `0 16px 28px ${appliedTheme.value.shadow}, 0 4px 8px rgba(0, 0, 0, 0.1)`
        : variantMap.value[props.variant].boxShadow
    }));

    const cardClasses = computed(() => ({
      [`variant-${props.variant}`]: true,
      'is-hoverable': props.hoverable,
      'is-clickable': props.clickable,
      'is-hovered': isHovered.value
    }));

    const ribbonStyles = computed(() => ({
      background: `linear-gradient(135deg, ${appliedTheme.value.accent}, ${appliedTheme.value.accent}dd)`,
      boxShadow: `0 2px 8px ${appliedTheme.value.accent}60`
    }));

    const actionButtonStyles = computed(() => ({
      background: `${appliedTheme.value.accent}12`,
      color: appliedTheme.value.accent,
      border: `1px solid ${appliedTheme.value.accent}30`
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
      ribbonStyles,
      actionButtonStyles,
      handleClick
    };
  }
});
</script>

<style scoped>
.card-ribbon {
  position: absolute;
  top: 16px;
  right: -32px;
  color: white;
  padding: 6px 40px;
  font-size: 12px;
  font-weight: 700;
  z-index: 1;
  transform: rotate(45deg);
  letter-spacing: 0.5px;
  text-transform: uppercase;
}
.card-media {
  width: 100%;
  overflow: hidden;
  position: relative;
}
.card-image {
  width: 100%;
  height: 220px;
  object-fit: cover;
  display: block;
  transition: transform 0.3s ease;
}
.is-hoverable:hover .card-image {
  transform: scale(1.05);
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 16px;
}
.header-content {
  flex: 1;
}
.card-subtitle {
  margin: 0 0 6px;
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.8px;
  opacity: 0.7;
  font-weight: 700;
}
.card-title {
  margin: 0;
  font-size: 1.375rem;
  font-weight: 800;
  line-height: 1.3;
  letter-spacing: -0.3px;
}
.card-content {
  font-size: 0.9375rem;
  line-height: 1.65;
  opacity: 0.9;
}
.card-footer {
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid rgba(0, 0, 0, 0.08);
}
.footer-actions {
  display: flex;
  gap: 10px;
  align-items: center;
  flex-wrap: wrap;
}
.action-btn {
  padding: 8px 16px;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  letter-spacing: 0.3px;
}
.action-btn:hover {
  transform: translateY(-1px);
  filter: brightness(1.1);
}
</style>
