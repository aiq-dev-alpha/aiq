<template>
  <div class="grid-container" :style="containerStyles">
    <div v-if="loading" class="grid" :style="gridStyles">
      <div
        v-for="i in skeletonCount"
        :key="`skeleton-${i}`"
        class="grid-item skeleton"
        :style="itemStyles"
      >
        <div class="skeleton-badge"></div>
        <div class="skeleton-image"></div>
        <div class="skeleton-content">
          <div class="skeleton-title"></div>
          <div class="skeleton-description"></div>
        </div>
      </div>
    </div>
    <div v-else class="grid card-grid" :style="gridStyles">
      <div
        v-for="item in items"
        :key="item.id"
        class="grid-item card-item"
        :style="itemStyles"
        @click="handleItemClick(item)"
      >
        <div class="card-badge"></div>
        <div v-if="item.image" class="card-image">
          <img :src="item.image" :alt="item.title || 'Grid item'" />
          <div class="image-overlay"></div>
        </div>
        <div class="card-body">
          <div class="card-header">
            <h3 v-if="item.title" class="card-title">{{ item.title }}</h3>
          </div>
          <p v-if="item.description" class="card-description">{{ item.description }}</p>
          <div v-if="item.content" class="card-content">{{ item.content }}</div>
          <div class="card-footer">
            <span class="card-action">View Details</span>
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
  columns: 3,
  gap: 'lg',
  variant: 'card',
  loading: false,
  theme: () => ({
    primaryColor: '#10b981',
    backgroundColor: '#ecfdf5',
    cardColor: '#ffffff',
    textColor: '#064e3b',
    borderColor: '#d1fae5',
    shadowColor: 'rgba(16, 185, 129, 0.12)'
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
  backgroundColor: props.theme?.backgroundColor || '#ecfdf5',
  padding: gapSizes[props.gap]
}));
const gridStyles = computed(() => ({
  display: 'grid',
  gap: gapSizes[props.gap],
  gridTemplateColumns: `repeat(${props.columns}, 1fr)`
}));
const itemStyles = computed(() => ({
  backgroundColor: props.theme?.cardColor || '#ffffff',
  borderColor: props.theme?.borderColor || '#d1fae5',
  color: props.theme?.textColor || '#064e3b',
  '--primary-color': props.theme?.primaryColor || '#10b981',
  '--shadow-color': props.theme?.shadowColor || 'rgba(16, 185, 129, 0.12)'
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
.card-grid {
  grid-auto-rows: auto;
}
.grid-item {
  border-radius: 20px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
}
.card-item {
  border: 3px solid;
  box-shadow: 0 10px 15px -3px var(--shadow-color), 0 4px 6px -2px var(--shadow-color);
  background: linear-gradient(135deg, transparent 0%, rgba(16, 185, 129, 0.03) 100%);
}
.card-item:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: 0 20px 25px -5px var(--shadow-color), 0 10px 10px -5px var(--shadow-color);
  border-color: var(--primary-color);
}
.card-badge {
  position: absolute;
  top: 1rem;
  right: 1rem;
  width: 12px;
  height: 12px;
  background: var(--primary-color);
  border-radius: 50%;
  z-index: 10;
  box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.2);
  animation: pulse-badge 2s infinite;
}
@keyframes pulse-badge {
  0%, 100% {
    box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.2);
  }
  50% {
    box-shadow: 0 0 0 8px rgba(16, 185, 129, 0.1);
  }
}
.card-image {
  width: 100%;
  height: 220px;
  overflow: hidden;
  position: relative;
  background: linear-gradient(135deg, #a7f3d0 0%, #6ee7b7 100%);
}
.card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.card-item:hover .card-image img {
  transform: scale(1.2) rotate(2deg);
}
.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, transparent 0%, rgba(0, 0, 0, 0.1) 100%);
}
.card-body {
  padding: 1.75rem;
}
.card-header {
  margin-bottom: 1rem;
  padding-bottom: 0.75rem;
  border-bottom: 2px solid var(--primary-color);
}
.card-title {
  margin: 0;
  font-size: 1.375rem;
  font-weight: 700;
  line-height: 1.3;
  color: var(--primary-color);
  transition: color 0.3s ease;
}
.card-item:hover .card-title {
  color: var(--primary-color);
}
.card-description {
  margin: 0 0 1rem 0;
  font-size: 0.9375rem;
  line-height: 1.7;
  opacity: 0.85;
}
.card-content {
  font-size: 0.875rem;
  line-height: 1.6;
  opacity: 0.75;
  margin-bottom: 1rem;
}
.card-footer {
  padding-top: 1rem;
  border-top: 1px solid;
  border-color: inherit;
  opacity: 0.5;
}
.card-action {
  font-size: 0.8125rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--primary-color);
  transition: opacity 0.3s ease;
}
.card-item:hover .card-action {
  opacity: 1;
}
/* Skeleton Loading */
.skeleton {
  pointer-events: none;
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
.skeleton-badge {
  position: absolute;
  top: 1rem;
  right: 1rem;
  width: 12px;
  height: 12px;
  background: linear-gradient(90deg, #d1fae5 25%, #ecfdf5 50%, #d1fae5 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
  border-radius: 50%;
  z-index: 10;
}
.skeleton-image {
  width: 100%;
  height: 220px;
  background: linear-gradient(90deg, #d1fae5 25%, #ecfdf5 50%, #d1fae5 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
}
.skeleton-content {
  padding: 1.75rem;
}
.skeleton-title {
  height: 1.375rem;
  background: linear-gradient(90deg, #d1fae5 25%, #ecfdf5 50%, #d1fae5 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
  border-radius: 4px;
  margin-bottom: 1rem;
  width: 65%;
}
.skeleton-description {
  height: 3.5rem;
  background: linear-gradient(90deg, #d1fae5 25%, #ecfdf5 50%, #d1fae5 75%);
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
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)) !important;
  }
}
@media (max-width: 640px) {
  .grid {
    grid-template-columns: 1fr !important;
  }
  .card-image {
    height: 200px;
  }
  .card-body {
    padding: 1.5rem;
  }
}
</style>
