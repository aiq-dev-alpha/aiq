<template>
  <div
    :style="cardStyles"
    :class="cardClasses"
    @click="handleClick"
    @mouseenter="handleMouseEnter"
    @mouseleave="handleMouseLeave">
    <div v-if="tag" class="card-tag" :style="tagStyles">
      <span class="tag-icon" v-if="tagIcon">{{ tagIcon }}</span>
      <span>{{ tag }}</span>
    </div>

    <div v-if="image || $slots.media" class="card-media-wrapper">
      <div class="media-gradient"></div>
      <img v-if="image" :src="image" :alt="imageAlt" class="card-media" />
      <slot name="media"></slot>
      <div v-if="$slots.mediaOverlay" class="media-overlay-content">
        <slot name="mediaOverlay"></slot>
      </div>
    </div>

    <div class="card-container" :style="containerStyles">
      <header v-if="title || subtitle || $slots.header" class="card-head">
        <div class="head-content">
          <span v-if="label" class="card-label">{{ label }}</span>
          <p v-if="subtitle" class="card-subtitle">{{ subtitle }}</p>
          <h3 v-if="title" class="card-title">{{ title }}</h3>
          <p v-if="description" class="card-description">{{ description }}</p>
        </div>
        <div v-if="$slots.headerAction" class="head-actions">
          <slot name="headerAction"></slot>
        </div>
        <slot name="header"></slot>
      </header>

      <div class="card-body">
        <slot></slot>
      </div>

      <footer v-if="$slots.footer || actions.length > 0" class="card-foot">
        <slot name="footer"></slot>
        <div v-if="actions.length > 0" class="foot-actions">
          <button
            v-for="(action, idx) in actions"
            :key="idx"
            @click.stop="action.onClick"
            class="action-item"
            :style="actionItemStyles">
            <span v-if="action.icon" class="action-icon">{{ action.icon }}</span>
            <span>{{ action.label }}</span>
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
  overlay: string;
}

interface CardAction {
  label: string;
  icon?: string;
  onClick: () => void;
}

type CardVariant = 'default' | 'elevated' | 'outlined' | 'gradient';

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
    description: {
      type: String,
      default: ''
    },
    label: {
      type: String,
      default: ''
    },
    image: {
      type: String,
      default: ''
    },
    imageAlt: {
      type: String,
      default: 'Card media'
    },
    tag: {
      type: String,
      default: ''
    },
    tagIcon: {
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
      default: 'lg'
    }
  },
  emits: ['click', 'hover'],
  setup(props, { emit }) {
    const isHovered = ref(false);

    const defaultTheme: CardTheme = {
      background: '#ffffff',
      foreground: '#0f172a',
      border: '#cbd5e1',
      accent: '#0ea5e9',
      shadow: 'rgba(14, 165, 233, 0.18)',
      muted: '#64748b',
      gradient: 'linear-gradient(135deg, #0ea5e9, #06b6d4)',
      overlay: 'linear-gradient(to top, rgba(0,0,0,0.8), transparent)'
    };

    const appliedTheme = computed(() => ({
      ...defaultTheme,
      ...props.theme
    }));

    const paddingMap: Record<string, string> = {
      none: '0',
      sm: '16px',
      md: '24px',
      lg: '32px',
      xl: '40px'
    };

    const containerStyles = computed(() => ({
      padding: paddingMap[props.padding]
    }));

    const variantMap = computed(() => {
      const t = appliedTheme.value;
      return {
        default: {
          background: t.background,
          border: `1px solid ${t.border}`,
          boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)'
        },
        elevated: {
          background: t.background,
          border: 'none',
          boxShadow: `0 10px 30px ${t.shadow}, 0 4px 8px rgba(0, 0, 0, 0.08)`
        },
        outlined: {
          background: t.background,
          border: `3px solid ${t.border}`,
          boxShadow: '0 2px 6px rgba(0, 0, 0, 0.05)'
        },
        gradient: {
          background: `linear-gradient(135deg, ${t.background}, ${t.accent}08)`,
          border: `1px solid ${t.accent}30`,
          boxShadow: `0 8px 24px ${t.shadow}`
        }
      };
    });

    const cardStyles = computed(() => ({
      ...variantMap.value[props.variant],
      color: appliedTheme.value.foreground,
      borderRadius: '20px',
      overflow: 'hidden',
      cursor: props.clickable ? 'pointer' : 'default',
      transition: 'all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1)',
      transform: props.hoverable && isHovered.value ? 'translateY(-8px) scale(1.02)' : 'none',
      boxShadow: props.hoverable && isHovered.value
        ? `0 24px 48px ${appliedTheme.value.shadow}, 0 8px 16px rgba(0, 0, 0, 0.12)`
        : variantMap.value[props.variant].boxShadow,
      position: 'relative' as const
    }));

    const cardClasses = computed(() => ({
      [`variant-${props.variant}`]: true,
      'is-hoverable': props.hoverable,
      'is-clickable': props.clickable,
      'is-hovered': isHovered.value
    }));

    const tagStyles = computed(() => ({
      background: appliedTheme.value.gradient,
      boxShadow: `0 4px 12px ${appliedTheme.value.shadow}`
    }));

    const actionItemStyles = computed(() => ({
      background: `${appliedTheme.value.accent}10`,
      color: appliedTheme.value.accent,
      border: `2px solid ${appliedTheme.value.accent}30`
    }));

    const handleMouseEnter = () => {
      isHovered.value = true;
      emit('hover', true);
    };

    const handleMouseLeave = () => {
      isHovered.value = false;
      emit('hover', false);
    };

    const handleClick = (event: MouseEvent) => {
      if (props.clickable) {
        emit('click', event);
      }
    };

    return {
      isHovered,
      cardStyles,
      cardClasses,
      containerStyles,
      tagStyles,
      actionItemStyles,
      handleClick,
      handleMouseEnter,
      handleMouseLeave
    };
  }
});
</script>

<style scoped>
.card-tag {
  position: absolute;
  top: 20px;
  left: 20px;
  color: white;
  padding: 8px 18px;
  font-size: 12px;
  font-weight: 800;
  z-index: 10;
  border-radius: 16px;
  letter-spacing: 0.8px;
  text-transform: uppercase;
  display: flex;
  align-items: center;
  gap: 6px;
}
.tag-icon {
  font-size: 14px;
}
.card-media-wrapper {
  width: 100%;
  position: relative;
  overflow: hidden;
}
.media-gradient {
  position: absolute;
  inset: 0;
  background: linear-gradient(to bottom, transparent 60%, rgba(0,0,0,0.1));
  z-index: 1;
  pointer-events: none;
}
.card-media {
  width: 100%;
  height: 260px;
  object-fit: cover;
  display: block;
  transition: transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.is-hoverable:hover .card-media {
  transform: scale(1.1) rotate(1deg);
}
.media-overlay-content {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(0,0,0,0.8), transparent 50%);
  display: flex;
  align-items: flex-end;
  padding: 28px;
  color: white;
  z-index: 2;
}
.card-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 20px;
  margin-bottom: 20px;
}
.head-content {
  flex: 1;
}
.card-label {
  display: inline-block;
  margin: 0 0 10px;
  font-size: 0.6875rem;
  text-transform: uppercase;
  letter-spacing: 1.2px;
  opacity: 0.7;
  font-weight: 900;
  color: currentColor;
}
.card-subtitle {
  margin: 0 0 10px;
  font-size: 0.875rem;
  opacity: 0.75;
  font-weight: 600;
  letter-spacing: 0.3px;
  line-height: 1.4;
}
.card-title {
  margin: 0 0 12px;
  font-size: 1.625rem;
  font-weight: 900;
  line-height: 1.2;
  letter-spacing: -0.6px;
}
.card-description {
  margin: 0;
  font-size: 0.9375rem;
  opacity: 0.8;
  font-weight: 500;
  line-height: 1.6;
  letter-spacing: 0.1px;
}
.card-body {
  font-size: 0.9375rem;
  line-height: 1.75;
  opacity: 0.9;
  letter-spacing: 0.2px;
}
.card-foot {
  margin-top: 28px;
  padding-top: 28px;
  border-top: 2px solid rgba(0, 0, 0, 0.06);
}
.foot-actions {
  display: flex;
  gap: 14px;
  align-items: center;
  flex-wrap: wrap;
}
.action-item {
  padding: 10px 20px;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  letter-spacing: 0.5px;
  display: flex;
  align-items: center;
  gap: 6px;
}
.action-item:hover {
  transform: translateY(-3px);
  filter: brightness(1.2);
}
.action-icon {
  font-size: 16px;
}
</style>
