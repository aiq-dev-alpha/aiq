<template>
  <section
    class="hero-centered"
    :style="heroStyles"
  >
    <div
      v-if="backgroundImage"
      class="hero-background"
      :style="{ backgroundImage: `url(${backgroundImage})` }"
    >
      <div class="hero-overlay" :style="{ backgroundColor: currentTheme.overlayColor }"></div>
    </div>
    <div class="hero-content">
      <div
        v-if="image"
        class="hero-image animate-scale-in"
      >
        <img :src="image" :alt="title" />
      </div>
      <h1
        class="hero-title animate-fade-in delay-1"
        :style="{ color: currentTheme.textColor }"
      >
        {{ title }}
      </h1>
      <p
        v-if="subtitle"
        class="hero-subtitle animate-fade-in delay-2"
        :style="{ color: currentTheme.textColor }"
      >
        {{ subtitle }}
      </p>
      <p
        v-if="description"
        class="hero-description animate-fade-in delay-3"
        :style="{ color: currentTheme.textColor }"
      >
        {{ description }}
      </p>
      <div
        v-if="ctaButtons && ctaButtons.length"
        class="hero-cta animate-fade-in delay-4"
      >
        <button
          v-for="(button, index) in ctaButtons"
          :key="index"
          :class="['hero-button', `button-${button.variant || 'primary'}`]"
          :style="getButtonStyles(button.variant)"
          @click="button.onClick"
        >
          {{ button.label }}
        </button>
      </div>
    </div>
  </section>
</template>
<script setup lang="ts">
import { computed, PropType } from 'vue'
interface HeroTheme {
  primaryColor: string
  backgroundColor: string
  textColor: string
  accentColor: string
  overlayColor: string
}
interface CtaButton {
  label: string
  onClick: () => void
  variant?: 'primary' | 'secondary' | 'outline'
}
type VariantType = 'full-screen' | 'split' | 'centered' | 'minimal' | 'video-bg' | 'gradient'
const props = defineProps({
  title: {
    type: String,
    required: true
  },
  subtitle: {
    type: String,
    default: ''
  },
  description: {
    type: String,
    default: ''
  },
  image: {
    type: String,
    default: ''
  },
  backgroundImage: {
    type: String,
    default: ''
  },
  ctaButtons: {
    type: Array as PropType<CtaButton[]>,
    default: () => []
  },
  variant: {
    type: String as PropType<VariantType>,
    default: 'centered'
  },
  theme: {
    type: Object as PropType<Partial<HeroTheme>>,
    default: () => ({})
  }
})
const defaultTheme: HeroTheme = {
  primaryColor: '#f59e0b',
  backgroundColor: '#fffbeb',
  textColor: '#78350f',
  accentColor: '#fbbf24',
  overlayColor: 'rgba(255, 251, 235, 0.95)'
}
const currentTheme = computed(() => ({
  ...defaultTheme,
  ...props.theme
}))
const heroStyles = computed(() => ({
  backgroundColor: currentTheme.value.backgroundColor
}))
const getButtonStyles = (variant?: string) => {
  if (variant === 'secondary') {
    return {
      backgroundColor: currentTheme.value.accentColor,
      borderColor: currentTheme.value.accentColor,
      color: '#78350f'
    }
  } else if (variant === 'outline') {
    return {
      backgroundColor: 'transparent',
      borderColor: currentTheme.value.primaryColor,
      color: currentTheme.value.primaryColor
    }
  }
  return {
    backgroundColor: currentTheme.value.primaryColor,
    borderColor: currentTheme.value.primaryColor,
    color: '#ffffff'
  }
}
</script>
<style scoped>
.hero-centered {
  position: relative;
  min-height: 90vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 4rem 2rem;
}
.hero-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  z-index: 0;
}
.hero-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}
.hero-content {
  position: relative;
  z-index: 1;
  text-align: center;
  max-width: 800px;
  margin: 0 auto;
}
.hero-image {
  width: 120px;
  height: 120px;
  margin: 0 auto 2rem;
  border-radius: 50%;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}
.hero-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.hero-title {
  font-size: 3rem;
  font-weight: 700;
  line-height: 1.2;
  margin-bottom: 1rem;
  letter-spacing: -0.02em;
}
.hero-subtitle {
  font-size: 1.25rem;
  font-weight: 500;
  margin-bottom: 0.75rem;
  opacity: 0.9;
}
.hero-description {
  font-size: 1.125rem;
  line-height: 1.6;
  margin-bottom: 2rem;
  opacity: 0.8;
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}
.hero-cta {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}
.hero-button {
  padding: 0.875rem 2rem;
  font-size: 1rem;
  font-weight: 600;
  border: 2px solid;
  border-radius: 2rem;
  cursor: pointer;
  transition: all 0.3s ease;
  min-width: 140px;
}
.hero-button:hover {
  transform: scale(1.05);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
}
.animate-scale-in {
  animation: scaleIn 0.6s ease-out forwards;
  opacity: 0;
}
.animate-fade-in {
  animation: fadeIn 0.8s ease-out forwards;
  opacity: 0;
}
.delay-1 {
  animation-delay: 0.15s;
}
.delay-2 {
  animation-delay: 0.3s;
}
.delay-3 {
  animation-delay: 0.45s;
}
.delay-4 {
  animation-delay: 0.6s;
}
@keyframes scaleIn {
  from {
    opacity: 0;
    transform: scale(0.8);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
@media (max-width: 768px) {
  .hero-centered {
    min-height: 80vh;
    padding: 3rem 1.5rem;
  }
  .hero-title {
    font-size: 2rem;
  }
  .hero-subtitle {
    font-size: 1.125rem;
  }
  .hero-description {
    font-size: 1rem;
  }
  .hero-image {
    width: 100px;
    height: 100px;
  }
  .hero-cta {
    flex-direction: column;
    align-items: center;
  }
  .hero-button {
    width: 100%;
    max-width: 300px;
  }
}
</style>
