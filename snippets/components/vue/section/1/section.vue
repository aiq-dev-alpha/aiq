<template>
  <section
    ref="sectionRef"
    :class="['animated-section', variant, { visible: isVisible }]"
    :style="sectionStyles"
  >
    <div class="section-background" v-if="backgroundImage">
      <img :src="backgroundImage" :alt="title" />
      <div class="overlay" :style="{ opacity: overlayOpacity }"></div>
    </div>

    <div class="section-container">
      <div v-if="title || subtitle || $slots.header" class="section-header">
        <slot name="header">
          <p v-if="subtitle" class="section-subtitle">{{ subtitle }}</p>
          <h2 v-if="title" class="section-title">{{ title }}</h2>
        </slot>
      </div>

      <div class="section-content">
        <slot />
      </div>

      <div v-if="$slots.footer" class="section-footer">
        <slot name="footer" />
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue';

interface Props {
  title?: string;
  subtitle?: string;
  variant?: 'default' | 'primary' | 'dark' | 'gradient';
  backgroundImage?: string;
  overlayOpacity?: number;
  fullHeight?: boolean;
  centered?: boolean;
  animateOnScroll?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default',
  overlayOpacity: 0.5,
  fullHeight: false,
  centered: false,
  animateOnScroll: true
});

const sectionRef = ref<HTMLElement | null>(null);
const isVisible = ref(false);

const sectionStyles = computed(() => ({
  minHeight: props.fullHeight ? '100vh' : 'auto',
  display: props.centered ? 'flex' : 'block',
  alignItems: props.centered ? 'center' : 'flex-start',
  justifyContent: props.centered ? 'center' : 'flex-start'
}));

const handleIntersection = (entries: IntersectionObserverEntry[]) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      isVisible.value = true;
    }
  });
};

onMounted(() => {
  if (props.animateOnScroll && sectionRef.value) {
    const observer = new IntersectionObserver(handleIntersection, {
      threshold: 0.2
    });
    observer.observe(sectionRef.value);

    onUnmounted(() => observer.disconnect());
  } else {
    isVisible.value = true;
  }
});
</script>

<style scoped>
.animated-section {
  position: relative;
  padding: 4rem 0;
  overflow: hidden;
  opacity: 0;
  transform: translateY(30px);
  transition: all 0.8s cubic-bezier(0.4, 0, 0.2, 1);
}

.animated-section.visible {
  opacity: 1;
  transform: translateY(0);
}

.animated-section.default {
  background: white;
}

.animated-section.primary {
  background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
}

.animated-section.dark {
  background: #111827;
  color: white;
}

.animated-section.gradient {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.section-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
}

.section-background img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.5));
}

.section-container {
  position: relative;
  z-index: 1;
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 2rem;
}

.section-header {
  text-align: center;
  margin-bottom: 3rem;
}

.section-subtitle {
  margin: 0 0 1rem 0;
  font-size: 0.875rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: currentColor;
  opacity: 0.8;
}

.section-title {
  margin: 0;
  font-size: 2.5rem;
  font-weight: 800;
  line-height: 1.2;
}

.section-content {
  margin-bottom: 2rem;
}

.section-footer {
  margin-top: 3rem;
  text-align: center;
}

@media (max-width: 768px) {
  .animated-section {
    padding: 3rem 0;
  }

  .section-title {
    font-size: 2rem;
  }
}
</style>
