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
        <div class="skeleton-content">
          <div class="skeleton-title"></div>
          <div class="skeleton-description"></div>
        </div>
      </div>
    </div>
    <div v-else class="grid" :style="gridStyles">
      <div
        v-for="item in items"
        :key="item.id"
        class="grid-item"
        :style="itemStyles"
        @click="handleItemClick(item)"
      >
        <div v-if="item.image" class="item-image">
          <img :src="item.image" :alt="item.title || 'Grid item'" />
        </div>
        <div class="item-content">
          <h3 v-if="item.title" class="item-title">{{ item.title }}</h3>
          <p v-if="item.description" class="item-description">{{ item.description }}</p>
          <div v-if="item.content" class="item-text">{{ item.content }}</div>
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
  columns: 3,
  gap: 'md',
  variant: 'masonry',
  loading: false,
  theme: () => ({
    primaryColor: '#6366f1',
    backgroundColor: '#f8fafc',
    cardColor: '#ffffff',
    textColor: '#1e293b',
    borderColor: '#e2e8f0',
    shadowColor: 'rgba(99, 102, 241, 0.1)'
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
  backgroundColor: props.theme?.backgroundColor || '#f8fafc',
  padding: gapSizes[props.gap]
}));
const gridStyles = computed(() => {
  const baseStyles: Record<string, string> = {
    display: 'grid',
    gap: gapSizes[props.gap],
    gridTemplateColumns: `repeat(${props.columns}, 1fr)`
  };
  if (props.variant === 'masonry') {
    baseStyles.gridAutoRows = '10px';
  }
  return baseStyles;
});
const itemStyles = computed(() => ({
  backgroundColor: props.theme?.cardColor || '#ffffff',
  borderColor: props.theme?.borderColor || '#e2e8f0',
  color: props.theme?.textColor || '#1e293b',
  boxShadow: `0 4px 6px -1px ${props.theme?.shadowColor || 'rgba(99, 102, 241, 0.1)'}`
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
.grid-item {
  border: 1px solid;
  border-radius: 12px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
}
.grid-item:hover {
  transform: translateY(-4px) scale(1.02);
  box-shadow: 0 20px 25px -5px rgba(99, 102, 241, 0.2), 0 10px 10px -5px rgba(99, 102, 241, 0.1) !important;
}
.item-image {
  width: 100%;
  height: 200px;
  overflow: hidden;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
.item-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}
.grid-item:hover .item-image img {
  transform: scale(1.1);
}
.item-content {
  padding: 1.5rem;
}
.item-title {
  margin: 0 0 0.75rem 0;
  font-size: 1.25rem;
  font-weight: 600;
  line-height: 1.3;
}
.item-description {
  margin: 0 0 0.5rem 0;
  font-size: 0.875rem;
  line-height: 1.6;
  opacity: 0.8;
}
.item-text {
  font-size: 0.875rem;
  line-height: 1.6;
  opacity: 0.7;
}
/* Skeleton Loading */
.skeleton {
  pointer-events: none;
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
.skeleton-image {
  width: 100%;
  height: 200px;
  background: linear-gradient(90deg, #e2e8f0 25%, #f1f5f9 50%, #e2e8f0 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
}
.skeleton-content {
  padding: 1.5rem;
}
.skeleton-title {
  height: 1.25rem;
  background: linear-gradient(90deg, #e2e8f0 25%, #f1f5f9 50%, #e2e8f0 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
  border-radius: 4px;
  margin-bottom: 0.75rem;
  width: 70%;
}
.skeleton-description {
  height: 3rem;
  background: linear-gradient(90deg, #e2e8f0 25%, #f1f5f9 50%, #e2e8f0 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
  border-radius: 4px;
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
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)) !important;
  }
}
@media (max-width: 640px) {
  .grid {
    grid-template-columns: 1fr !important;
  }
  .item-image {
    height: 180px;
  }
}
</style>
