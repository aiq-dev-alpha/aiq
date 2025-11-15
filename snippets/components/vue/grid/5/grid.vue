<template>
  <div class="grid-container" :style="containerStyles">
    <div v-if="loading" class="grid" :style="gridStyles">
      <div
        v-for="i in skeletonCount"
        :key="`skeleton-${i}`"
        class="grid-item skeleton"
        :style="itemStyles"
      >
        <div class="skeleton-header">
          <div class="skeleton-avatar"></div>
          <div class="skeleton-meta"></div>
        </div>
        <div class="skeleton-image"></div>
        <div class="skeleton-content">
          <div class="skeleton-title"></div>
          <div class="skeleton-description"></div>
        </div>
        <div class="skeleton-footer"></div>
      </div>
    </div>
    <div v-else class="grid detailed-grid" :style="gridStyles">
      <div
        v-for="item in items"
        :key="item.id"
        class="grid-item detailed-item"
        :style="itemStyles"
        @click="handleItemClick(item)"
      >
        <div class="detailed-header">
          <div class="header-avatar"></div>
          <div class="header-meta">
            <div class="meta-label">Featured</div>
            <div class="meta-date">{{ new Date().toLocaleDateString() }}</div>
          </div>
        </div>
        <div v-if="item.image" class="detailed-image">
          <img :src="item.image" :alt="item.title || 'Grid item'" />
          <div class="image-gradient"></div>
          <div class="image-indicator"></div>
        </div>
        <div class="detailed-body">
          <div class="body-tags">
            <span class="tag">Premium</span>
            <span class="tag">New</span>
          </div>
          <h3 v-if="item.title" class="detailed-title">{{ item.title }}</h3>
          <p v-if="item.description" class="detailed-description">{{ item.description }}</p>
          <div v-if="item.content" class="detailed-content">{{ item.content }}</div>
        </div>
        <div class="detailed-footer">
          <div class="footer-stats">
            <div class="stat">
              <span class="stat-icon">&#9829;</span>
              <span class="stat-value">245</span>
            </div>
            <div class="stat">
              <span class="stat-icon">&#9733;</span>
              <span class="stat-value">4.8</span>
            </div>
          </div>
          <button class="footer-action">Explore</button>
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
  gap: 'xl',
  variant: 'detailed',
  loading: false,
  theme: () => ({
    primaryColor: '#8b5cf6',
    backgroundColor: '#faf5ff',
    cardColor: '#ffffff',
    textColor: '#4c1d95',
    borderColor: '#ede9fe',
    shadowColor: 'rgba(139, 92, 246, 0.15)'
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

const skeletonCount = computed(() => props.columns * 2);

const containerStyles = computed(() => ({
  backgroundColor: props.theme?.backgroundColor || '#faf5ff',
  padding: gapSizes[props.gap]
}));

const gridStyles = computed(() => ({
  display: 'grid',
  gap: gapSizes[props.gap],
  gridTemplateColumns: `repeat(${props.columns}, 1fr)`
}));

const itemStyles = computed(() => ({
  backgroundColor: props.theme?.cardColor || '#ffffff',
  borderColor: props.theme?.borderColor || '#ede9fe',
  color: props.theme?.textColor || '#4c1d95',
  '--primary-color': props.theme?.primaryColor || '#8b5cf6',
  '--shadow-color': props.theme?.shadowColor || 'rgba(139, 92, 246, 0.15)'
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

.detailed-grid {
  grid-auto-rows: auto;
}

.grid-item {
  border-radius: 24px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  display: flex;
  flex-direction: column;
}

.detailed-item {
  border: 2px solid;
  box-shadow: 0 10px 15px -3px var(--shadow-color), 0 4px 6px -2px var(--shadow-color);
  background: linear-gradient(to bottom, #ffffff 0%, #faf5ff 100%);
}

.detailed-item:hover {
  transform: translateY(-12px);
  box-shadow: 0 25px 50px -12px var(--shadow-color), 0 0 0 2px var(--primary-color);
  border-color: var(--primary-color);
}

.detailed-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1.25rem 1.5rem;
  background: linear-gradient(135deg, rgba(139, 92, 246, 0.05) 0%, transparent 100%);
}

.header-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #c084fc 0%, #a855f7 100%);
  flex-shrink: 0;
  box-shadow: 0 4px 6px -1px rgba(139, 92, 246, 0.3);
}

.header-meta {
  flex-grow: 1;
  min-width: 0;
}

.meta-label {
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--primary-color);
}

.meta-date {
  font-size: 0.6875rem;
  opacity: 0.6;
  margin-top: 0.125rem;
}

.detailed-image {
  width: 100%;
  height: 240px;
  overflow: hidden;
  position: relative;
  background: linear-gradient(135deg, #ddd6fe 0%, #c4b5fd 100%);
}

.detailed-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.detailed-item:hover .detailed-image img {
  transform: scale(1.15);
}

.image-gradient {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to top, rgba(139, 92, 246, 0.2) 0%, transparent 50%);
}

.image-indicator {
  position: absolute;
  bottom: 1rem;
  right: 1rem;
  width: 8px;
  height: 8px;
  background: var(--primary-color);
  border-radius: 50%;
  box-shadow: 0 0 0 4px rgba(255, 255, 255, 0.5);
  animation: pulse-indicator 2s infinite;
}

@keyframes pulse-indicator {
  0%, 100% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.5);
    opacity: 0.7;
  }
}

.detailed-body {
  padding: 1.5rem;
  flex-grow: 1;
  display: flex;
  flex-direction: column;
}

.body-tags {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.tag {
  font-size: 0.6875rem;
  font-weight: 600;
  padding: 0.25rem 0.75rem;
  background: var(--primary-color);
  color: white;
  border-radius: 12px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.detailed-title {
  margin: 0 0 0.875rem 0;
  font-size: 1.5rem;
  font-weight: 700;
  line-height: 1.3;
  color: var(--primary-color);
}

.detailed-description {
  margin: 0 0 0.75rem 0;
  font-size: 1rem;
  line-height: 1.7;
  opacity: 0.85;
}

.detailed-content {
  font-size: 0.875rem;
  line-height: 1.6;
  opacity: 0.75;
  flex-grow: 1;
}

.detailed-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.25rem 1.5rem;
  border-top: 2px solid;
  border-color: inherit;
  background: linear-gradient(to top, rgba(139, 92, 246, 0.03) 0%, transparent 100%);
}

.footer-stats {
  display: flex;
  gap: 1.25rem;
}

.stat {
  display: flex;
  align-items: center;
  gap: 0.375rem;
  font-size: 0.875rem;
  font-weight: 600;
}

.stat-icon {
  color: var(--primary-color);
  font-size: 1rem;
}

.stat-value {
  opacity: 0.8;
}

.footer-action {
  padding: 0.5rem 1.5rem;
  background: var(--primary-color);
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.25s ease;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.footer-action:hover {
  background: var(--primary-color);
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(139, 92, 246, 0.4);
}

/* Skeleton Loading */
.skeleton {
  pointer-events: none;
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

.skeleton-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1.25rem 1.5rem;
}

.skeleton-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(90deg, #ede9fe 25%, #faf5ff 50%, #ede9fe 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
  flex-shrink: 0;
}

.skeleton-meta {
  flex-grow: 1;
  height: 30px;
  background: linear-gradient(90deg, #ede9fe 25%, #faf5ff 50%, #ede9fe 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
  border-radius: 4px;
}

.skeleton-image {
  width: 100%;
  height: 240px;
  background: linear-gradient(90deg, #ede9fe 25%, #faf5ff 50%, #ede9fe 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
}

.skeleton-content {
  padding: 1.5rem;
  flex-grow: 1;
}

.skeleton-title {
  height: 1.5rem;
  background: linear-gradient(90deg, #ede9fe 25%, #faf5ff 50%, #ede9fe 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
  border-radius: 4px;
  margin-bottom: 0.875rem;
  width: 75%;
}

.skeleton-description {
  height: 4rem;
  background: linear-gradient(90deg, #ede9fe 25%, #faf5ff 50%, #ede9fe 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
  border-radius: 4px;
}

.skeleton-footer {
  height: 60px;
  background: linear-gradient(90deg, #ede9fe 25%, #faf5ff 50%, #ede9fe 75%);
  background-size: 200% 100%;
  animation: shimmer 2s infinite;
  border-top: 2px solid;
  border-color: inherit;
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
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)) !important;
  }
}

@media (max-width: 640px) {
  .grid {
    grid-template-columns: 1fr !important;
  }

  .detailed-image {
    height: 200px;
  }

  .detailed-body {
    padding: 1.25rem;
  }

  .detailed-footer {
    flex-direction: column;
    gap: 1rem;
    align-items: stretch;
  }

  .footer-action {
    width: 100%;
  }
}
</style>
