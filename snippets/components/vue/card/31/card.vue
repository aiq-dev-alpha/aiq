<template>
  <div
    :style="cardStyles"
    :class="cardClasses"
    @click="handleClick"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false">
    <div v-if="badge" class="card-badge">{{ badge }}</div>

    <div v-if="image" class="card-image">
      <img :src="image" :alt="imageAlt" />
    </div>

    <div class="card-content">
      <header v-if="title || subtitle || $slots.header" class="card-header">
        <div class="header-text">
          <p v-if="subtitle" class="card-subtitle">{{ subtitle }}</p>
          <h3 v-if="title" class="card-title">{{ title }}</h3>
        </div>
        <div v-if="$slots.headerAction" class="header-action">
          <slot name="headerAction"></slot>
        </div>
        <slot name="header"></slot>
      </header>

      <div class="card-body">
        <slot></slot>
      </div>

      <footer v-if="$slots.footer || actions" class="card-footer">
        <slot name="footer"></slot>
        <div v-if="actions" class="footer-actions">
          <slot name="actions"></slot>
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
}

type CardVariant = 'flat' | 'elevated' | 'outlined' | 'filled';

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
      default: ''
    },
    badge: {
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
      type: Boolean,
      default: false
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
      background: '#fafafa',
      foreground: '#18181b',
      border: '#d4d4d8',
      accent: '#8b5cf6',
      shadow: 'rgba(139, 92, 246, 0.15)'
    };

    const appliedTheme = computed(() => ({
      ...defaultTheme,
      ...props.theme
    }));

    const paddingMap: Record<string, string> = {
      none: '0',
      sm: '12px',
      md: '16px',
      lg: '24px',
      xl: '32px'
    };

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
          boxShadow: `0 8px 16px ${t.shadow}, 0 2px 4px rgba(0, 0, 0, 0.06)`
        },
        outlined: {
          background: t.background,
          border: `2px solid ${t.border}`,
          boxShadow: `0 2px 4px rgba(0, 0, 0, 0.04)`
        },
        filled: {
          background: `linear-gradient(135deg, ${t.accent}12, ${t.accent}20)`,
          border: `1px solid ${t.accent}25`,
          boxShadow: `0 4px 8px ${t.shadow}`
        }
      };
    });

    const cardStyles = computed(() => ({
      ...variantMap.value[props.variant],
      color: appliedTheme.value.foreground,
      borderRadius: '16px',
      overflow: 'hidden',
      cursor: props.clickable ? 'pointer' : 'default',
      transition: 'all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1)',
      transform: props.hoverable && isHovered.value ? 'translateY(-6px) scale(1.01)' : 'none',
      boxShadow: props.hoverable && isHovered.value
        ? `0 16px 32px ${appliedTheme.value.shadow}, 0 4px 8px rgba(0, 0, 0, 0.1)`
        : variantMap.value[props.variant].boxShadow
    }));

    const cardClasses = computed(() => ({
      [`variant-${props.variant}`]: true,
      'is-hoverable': props.hoverable,
      'is-clickable': props.clickable,
      'is-hovered': isHovered.value
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
      handleClick,
      paddingMap
    };
  }
});
</script>

<style scoped>
.card-badge {
  position: absolute;
  top: 14px;
  right: 14px;
  background: linear-gradient(135deg, #8b5cf6, #6d28d9);
  color: white;
  padding: 5px 14px;
  border-radius: 14px;
  font-size: 12px;
  font-weight: 700;
  z-index: 1;
  box-shadow: 0 2px 8px rgba(139, 92, 246, 0.4);
  letter-spacing: 0.5px;
}
.card-image {
  width: 100%;
  overflow: hidden;
}
.card-image img {
  width: 100%;
  height: 200px;
  object-fit: cover;
  display: block;
}
.card-content {
  padding: 16px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 1rem;
  margin-bottom: 16px;
}
.header-text {
  flex: 1;
}
.card-subtitle {
  margin: 0 0 8px;
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  opacity: 0.7;
  font-weight: 600;
}
.card-title {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 700;
  line-height: 1.3;
}
.card-body {
  font-size: 0.875rem;
  line-height: 1.6;
  opacity: 0.9;
}
.card-footer {
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid rgba(0, 0, 0, 0.08);
}
.footer-actions {
  display: flex;
  gap: 12px;
  align-items: center;
}
</style>
