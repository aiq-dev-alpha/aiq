<template>
  <header :class="['app-header', { scrolled, transparent }]">
    <div class="header-container">
      <div class="header-left">
        <slot name="logo">
          <div class="logo">{{ logoText }}</div>
        </slot>
      </div>

      <nav class="header-nav">
        <slot name="nav" />
      </nav>

      <div class="header-right">
        <slot name="actions" />
      </div>

      <button
        class="mobile-menu-toggle"
        @click="$emit('toggle-menu')"
        aria-label="Toggle menu"
      >
        <span class="hamburger"></span>
      </button>
    </div>

    <div class="progress-bar" v-if="showProgress" :style="{ width: `${progress}%` }"></div>
  </header>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';

interface Props {
  logoText?: string;
  transparent?: boolean;
  showProgress?: boolean;
  stickyThreshold?: number;
}

const props = withDefaults(defineProps<Props>(), {
  logoText: 'Logo',
  transparent: false,
  showProgress: false,
  stickyThreshold: 50
});

defineEmits<{
  'toggle-menu': [];
}>();

const scrolled = ref(false);
const progress = ref(0);

const handleScroll = () => {
  const scrollPosition = window.scrollY;
  scrolled.value = scrollPosition > props.stickyThreshold;

  if (props.showProgress) {
    const windowHeight = document.documentElement.scrollHeight - window.innerHeight;
    progress.value = (scrollPosition / windowHeight) * 100;
  }
};

onMounted(() => {
  window.addEventListener('scroll', handleScroll);
  handleScroll();
});

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll);
});
</script>

<style scoped>
.app-header {
  position: sticky;
  top: 0;
  z-index: 1000;
  background: white;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.app-header.transparent {
  background: transparent;
  box-shadow: none;
}

.app-header.scrolled {
  background: white;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.app-header.transparent.scrolled {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
}

.header-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  max-width: 1280px;
  margin: 0 auto;
  padding: 1rem 2rem;
}

.header-left {
  flex-shrink: 0;
}

.logo {
  font-size: 1.5rem;
  font-weight: 800;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.header-nav {
  display: flex;
  align-items: center;
  gap: 2rem;
  flex: 1;
  justify-content: center;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.mobile-menu-toggle {
  display: none;
  width: 40px;
  height: 40px;
  background: transparent;
  border: none;
  cursor: pointer;
  padding: 8px;
}

.hamburger {
  display: block;
  width: 100%;
  height: 2px;
  background: #374151;
  position: relative;
  transition: background 0.3s ease;
}

.hamburger::before,
.hamburger::after {
  content: '';
  position: absolute;
  left: 0;
  width: 100%;
  height: 2px;
  background: #374151;
  transition: all 0.3s ease;
}

.hamburger::before {
  top: -8px;
}

.hamburger::after {
  bottom: -8px;
}

.progress-bar {
  position: absolute;
  bottom: 0;
  left: 0;
  height: 3px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  transition: width 0.1s ease;
}

@media (max-width: 768px) {
  .header-nav {
    display: none;
  }

  .mobile-menu-toggle {
    display: block;
  }
}
</style>
