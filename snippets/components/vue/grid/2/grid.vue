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
    <div v-else class="grid uniform-grid" :style="gridStyles">
      <div
        v-for="item in items"
        :key="item.id"
        class="grid-item uniform-item"
        :style="itemStyles"
        @click="handleItemClick(item)"
      >
        <div class="item-overlay"></div>
        <div v-if="item.image" class="item-image-bg" :style="{ backgroundImage: `url(${item.image})` }">
          <div class="item-gradient"></div>
        </div>
        <div class="item-content-overlay">
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
  columns: 4,
  gap: 'sm',
  variant: 'uniform',
  loading: false,
  theme: () => ({
    primaryColor: '#ec4899',
    backgroundColor: '#fdf2f8',
    cardColor: '#ffffff',
    textColor: '#ffffff',
    borderColor: '#fce7f3',
    shadowColor: 'rgba(236, 72, 153, 0.15)'
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
  backgroundColor: props.theme?.backgroundColor || '#fdf2f8',
  padding: gapSizes[props.gap]
}));

const gridStyles = computed(() => ({
  display: 'grid',
  gap: gapSizes[props.gap],
  gridTemplateColumns: `repeat(${props.columns}, 1fr)`,
  gridAutoRows: '250px'
}));

const itemStyles = computed(() => ({
  borderColor: props.theme?.borderColor || '#fce7f3',
  '--primary-color': props.theme?.primaryColor || '#ec4899',
  '--text-color': props.theme?.textColor || '#ffffff',
  '--shadow-color': props.theme?.shadowColor || 'rgba(236, 72, 153, 0.15)'
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

.uniform-grid {
  grid-auto-rows: 250px;
}

.grid-item {
  position: relative;
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.uniform-item {
  display: flex;
  align-items: flex-end;
  justify-content: center;
  border: 2px solid;
  box-shadow: 0 4px 6px -1px var(--shadow-color);
}

.item-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: var(--primary-color);
  opacity: 0;
  transition: opacity 0.4s ease;
  z-index: 1;
}

.grid-item:hover .item-overlay {
  opacity: 0.1;
}

.grid-item:hover {
  transform: scale(1.05) rotate(1deg);
  box-shadow: 0 25px 50px -12px var(--shadow-color);
  z-index: 10;
}

.item-image-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-size: cover;
  background-position: center;
  transition: transform 0.4s ease;
}

.grid-item:hover .item-image-bg {
  transform: scale(1.15);
}

.item-gradient {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.8) 0%, transparent 100%);
}

.item-content-overlay {
  position: relative;
  z-index: 2;
  padding: 1.5rem;
  width: 100%;
  color: var(--text-color);
  transform: translateY(0);
  transition: transform 0.4s ease;
}

.grid-item:hover .item-content-overlay {
  transform: translateY(-8px);
}

.item-title {
  margin: 0 0 0.5rem 0;
  font-size: 1.125rem;
  font-weight: 700;
  line-height: 1.3;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.item-description {
  margin: 0 0 0.25rem 0;
  font-size: 0.875rem;
  line-height: 1.5;
  opacity: 0.95;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

.item-text {
  font-size: 0.8125rem;
  line-height: 1.5;
  opacity: 0.9;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

/* Skeleton Loading */
.skeleton {
  pointer-events: none;
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

.skeleton-image {
  width: 100%;
  height: 150px;
  background: linear-gradient(90deg, #fce7f3 25%, #fdf2f8 50%, #fce7f3 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
}

.skeleton-content {
  padding: 1.5rem;
}

.skeleton-title {
  height: 1.125rem;
  background: linear-gradient(90deg, #fce7f3 25%, #fdf2f8 50%, #fce7f3 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
  border-radius: 4px;
  margin-bottom: 0.5rem;
  width: 60%;
}

.skeleton-description {
  height: 2.5rem;
  background: linear-gradient(90deg, #fce7f3 25%, #fdf2f8 50%, #fce7f3 75%);
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
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)) !important;
  }
}

@media (max-width: 640px) {
  .grid {
    grid-template-columns: repeat(2, 1fr) !important;
  }

  .uniform-grid {
    grid-auto-rows: 200px;
  }
}
</style>
