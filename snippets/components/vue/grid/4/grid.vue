<template>
  <div class="grid-container" :style="containerStyles">
    <div v-if="loading" class="grid" :style="gridStyles">
      <div
        v-for="i in skeletonCount"
        :key="`skeleton-${i}`"
        class="grid-item skeleton"
        :style="itemStyles"
      >
        <div class="skeleton-image"></div>
        <div class="skeleton-title"></div>
      </div>
    </div>
    <div v-else class="grid minimal-grid" :style="gridStyles">
      <div
        v-for="item in items"
        :key="item.id"
        class="grid-item minimal-item"
        :style="itemStyles"
        @click="handleItemClick(item)"
      >
        <div class="minimal-wrapper">
          <div v-if="item.image" class="minimal-image">
            <img :src="item.image" :alt="item.title || 'Grid item'" />
            <div class="minimal-overlay"></div>
          </div>
          <div class="minimal-content">
            <h3 v-if="item.title" class="minimal-title">{{ item.title }}</h3>
            <p v-if="item.description" class="minimal-description">{{ item.description }}</p>
            <div v-if="item.content" class="minimal-text">{{ item.content }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup lang="ts">
import { computed } from 'vue';
interface GridTheme {
  primaryColor?: string;
  backgroundColor?: string;
  cardColor?: string;
  textColor?: string;
  borderColor?: string;
  shadowColor?: string;
}
interface GridItem {
  id: string | number;
  content?: string;
  image?: string;
  title?: string;
  description?: string;
}
type GridVariant = 'masonry' | 'uniform' | 'card' | 'minimal' | 'detailed';
type GridGap = 'xs' | 'sm' | 'md' | 'lg' | 'xl';
interface Props {
  items?: GridItem[];
  columns?: number;
  gap?: GridGap;
  variant?: GridVariant;
  loading?: boolean;
  theme?: GridTheme;
}
const props = withDefaults(defineProps<Props>(), {
  items: () => [],
  columns: 4,
  gap: 'xs',
  variant: 'minimal',
  loading: false,
  theme: () => ({
    primaryColor: '#f59e0b',
    backgroundColor: '#fffbeb',
    cardColor: '#fef3c7',
    textColor: '#78350f',
    borderColor: '#fde68a',
    shadowColor: 'rgba(245, 158, 11, 0.08)'
  })
});
const emit = defineEmits<{
  itemClick: [item: GridItem];
}>();
const gapSizes = {
  xs: '0.5rem',
  sm: '1rem',
  md: '1.5rem',
  lg: '2rem',
  xl: '3rem'
};
const skeletonCount = computed(() => props.columns * 3);
const containerStyles = computed(() => ({
  backgroundColor: props.theme?.backgroundColor || '#fffbeb',
  padding: gapSizes[props.gap]
}));
const gridStyles = computed(() => ({
  display: 'grid',
  gap: gapSizes[props.gap],
  gridTemplateColumns: `repeat(${props.columns}, 1fr)`
}));
const itemStyles = computed(() => ({
  backgroundColor: props.theme?.cardColor || '#fef3c7',
  borderColor: props.theme?.borderColor || '#fde68a',
  color: props.theme?.textColor || '#78350f',
  '--primary-color': props.theme?.primaryColor || '#f59e0b',
  '--shadow-color': props.theme?.shadowColor || 'rgba(245, 158, 11, 0.08)'
}));
const handleItemClick = (item: GridItem) => {
  emit('itemClick', item);
};
</script>
<style scoped>
.grid-container {
  width: 100%;
  min-height: 200px;
}
.grid {
  width: 100%;
}
.minimal-grid {
  grid-auto-rows: auto;
}
.grid-item {
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.25s ease;
  position: relative;
}
.minimal-item {
  border: 1px solid;
  box-shadow: 0 1px 3px 0 var(--shadow-color);
  background: transparent;
}
.minimal-item:hover {
  transform: scale(1.03);
  box-shadow: 0 10px 20px -5px var(--shadow-color);
  border-color: var(--primary-color);
}
.minimal-wrapper {
  display: flex;
  flex-direction: column;
  height: 100%;
}
.minimal-image {
  width: 100%;
  height: 160px;
  overflow: hidden;
  position: relative;
  flex-shrink: 0;
  background: linear-gradient(135deg, #fcd34d 0%, #fbbf24 100%);
}
.minimal-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: opacity 0.25s ease;
}
.minimal-item:hover .minimal-image img {
  opacity: 0.9;
}
.minimal-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: var(--primary-color);
  opacity: 0;
  transition: opacity 0.25s ease;
  mix-blend-mode: multiply;
}
.minimal-item:hover .minimal-overlay {
  opacity: 0.15;
}
.minimal-content {
  padding: 1rem;
  flex-grow: 1;
  display: flex;
  flex-direction: column;
}
.minimal-title {
  margin: 0 0 0.5rem 0;
  font-size: 1rem;
  font-weight: 600;
  line-height: 1.4;
  color: var(--primary-color);
}
.minimal-description {
  margin: 0 0 0.25rem 0;
  font-size: 0.8125rem;
  line-height: 1.5;
  opacity: 0.8;
}
.minimal-text {
  font-size: 0.75rem;
  line-height: 1.5;
  opacity: 0.7;
  margin-top: auto;
}
/* Skeleton Loading */
.skeleton {
  pointer-events: none;
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
.skeleton-image {
  width: 100%;
  height: 160px;
  background: linear-gradient(90deg, #fde68a 25%, #fffbeb 50%, #fde68a 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
}
.skeleton-title {
  height: 1rem;
  background: linear-gradient(90deg, #fde68a 25%, #fffbeb 50%, #fde68a 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
  border-radius: 4px;
  margin: 1rem;
  width: calc(100% - 2rem);
}
@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}
@keyframes shimmer {
  0% {
    background-position: -200% 0;
  }
  100% {
    background-position: 200% 0;
  }
}
/* Responsive */
@media (max-width: 1024px) {
  .grid {
    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)) !important;
  }
}
@media (max-width: 640px) {
  .grid {
    grid-template-columns: repeat(2, 1fr) !important;
  }
  .minimal-image {
    height: 140px;
  }
}
</style>
