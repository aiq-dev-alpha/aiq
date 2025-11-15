<template>
  <div class="virtual-list" ref="containerRef">
    <div class="scroll-container" :style="{ height: `${totalHeight}px` }">
      <div class="visible-items" :style="{ transform: `translateY(${offsetY}px)` }">
        <div
          v-for="item in visibleItems"
          :key="getItemKey(item)"
          class="list-item"
          :style="{ height: `${itemHeight}px` }"
        >
          <slot :item="item" :index="item.index">
            {{ item }}
          </slot>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts" generic="T">
import { ref, computed, onMounted, onUnmounted } from 'vue';

interface Props {
  items: T[];
  itemHeight?: number;
  buffer?: number;
}

const props = withDefaults(defineProps<Props>(), {
  itemHeight: 50,
  buffer: 5
});

const containerRef = ref<HTMLElement | null>(null);
const scrollTop = ref(0);

const totalHeight = computed(() => props.items.length * props.itemHeight);

const visibleStart = computed(() => {
  return Math.max(0, Math.floor(scrollTop.value / props.itemHeight) - props.buffer);
});

const visibleEnd = computed(() => {
  if (!containerRef.value) return props.buffer * 2;
  const visibleCount = Math.ceil(containerRef.value.clientHeight / props.itemHeight);
  return Math.min(props.items.length, visibleStart.value + visibleCount + props.buffer);
});

const visibleItems = computed(() => {
  return props.items.slice(visibleStart.value, visibleEnd.value).map((item, idx) => ({
    ...item,
    index: visibleStart.value + idx
  }));
});

const offsetY = computed(() => visibleStart.value * props.itemHeight);

const handleScroll = (e: Event) => {
  scrollTop.value = (e.target as HTMLElement).scrollTop;
};

const getItemKey = (item: any): string | number => {
  return item.id ?? item.index;
};

onMounted(() => {
  containerRef.value?.addEventListener('scroll', handleScroll);
});

onUnmounted(() => {
  containerRef.value?.removeEventListener('scroll', handleScroll);
});
</script>

<style scoped>
.virtual-list {
  width: 100%;
  height: 100%;
  overflow-y: auto;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
}

.scroll-container {
  position: relative;
  width: 100%;
}

.visible-items {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
}

.list-item {
  display: flex;
  align-items: center;
  padding: 0 1rem;
  border-bottom: 1px solid #f3f4f6;
  transition: background 0.15s ease;
}

.list-item:hover {
  background: #f9fafb;
}

.list-item:last-child {
  border-bottom: none;
}
</style>
