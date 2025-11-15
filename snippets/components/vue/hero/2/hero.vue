<template>
  <section
    class="hero-split"
    :style="heroStyles"
  >
    <div class="hero-grid">
      <div class="hero-content-side">
        <div class="hero-text">
          <h1
            class="hero-title animate-slide-in-left"
            :style="{ color: currentTheme.textColor }"
          >
            {{ title }}
          </h1>
          <p
            v-if="subtitle"
            class="hero-subtitle animate-slide-in-left delay-1"
            :style="{ color: currentTheme.textColor }"
          >
            {{ subtitle }}
          </p>
          <p
            v-if="description"
            class="hero-description animate-slide-in-left delay-2"
            :style="{ color: currentTheme.textColor }"
          >
            {{ description }}
          </p>
          <div
            v-if="ctaButtons && ctaButtons.length"
            class="hero-cta animate-slide-in-left delay-3"
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
      </div>
      <div class="hero-image-side">
        <div
          class="hero-image-container animate-slide-in-right"
          :style="{
            backgroundImage: image || backgroundImage ? `url(${image || backgroundImage})` : 'none',
            backgroundColor: !image && !backgroundImage ? currentTheme.accentColor : 'transparent'
          }"
        >
          <div class="image-overlay" :style="{ backgroundColor: currentTheme.overlayColor }"></div>
        </div>
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
    default: 'split'
  },
  theme: {
    type: Object as PropType<Partial<HeroTheme>>,
    default: () => ({})
  }
})
const defaultTheme: HeroTheme = {
  primaryColor: '#10b981',
  backgroundColor: '#ffffff',
  textColor: '#111827',
  accentColor: '#34d399',
  overlayColor: 'rgba(16, 185, 129, 0.1)'
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
      color: '#ffffff'
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
.hero-split {
  position: relative;
  min-height: 100vh;
  overflow: hidden;
}
.hero-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  min-height: 100vh;
  align-items: center;
}
.hero-content-side {
  padding: 4rem;
  display: flex;
  align-items: center;
  justify-content: center;
}
.hero-text {
  max-width: 600px;
}
.hero-title {
  font-size: 3.5rem;
  font-weight: 900;
  line-height: 1.1;
  margin-bottom: 1.5rem;
  letter-spacing: -0.03em;
}
.hero-subtitle {
  font-size: 1.5rem;
  font-weight: 600;
  margin-bottom: 1rem;
  opacity: 0.85;
}
.hero-description {
  font-size: 1.125rem;
  line-height: 1.7;
  margin-bottom: 2rem;
  opacity: 0.75;
}
.hero-cta {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}
.hero-button {
  padding: 1rem 2rem;
  font-size: 1rem;
  font-weight: 600;
  border: 2px solid;
  border-radius: 0.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
}
.hero-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}
.hero-image-side {
  height: 100vh;
  position: relative;
  overflow: hidden;
}
.hero-image-container {
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
}
.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  mix-blend-mode: multiply;
}
.animate-slide-in-left {
  animation: slideInLeft 0.8s ease-out forwards;
  opacity: 0;
}
.animate-slide-in-right {
  animation: slideInRight 1s ease-out forwards;
  opacity: 0;
}
.delay-1 {
  animation-delay: 0.2s;
}
.delay-2 {
  animation-delay: 0.4s;
}
.delay-3 {
  animation-delay: 0.6s;
}
@keyframes slideInLeft {
  from {
    opacity: 0;
    transform: translateX(-50px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}
@keyframes slideInRight {
  from {
    opacity: 0;
    transform: translateX(50px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}
@media (max-width: 1024px) {
  .hero-grid {
    grid-template-columns: 1fr;
    grid-template-rows: auto auto;
  }
  .hero-content-side {
    padding: 3rem 2rem;
  }
  .hero-image-side {
    height: 50vh;
    min-height: 400px;
  }
  .hero-title {
    font-size: 2.5rem;
  }
  .hero-subtitle {
    font-size: 1.25rem;
  }
  .hero-description {
    font-size: 1rem;
  }
}
@media (max-width: 640px) {
  .hero-content-side {
    padding: 2rem 1.5rem;
  }
  .hero-title {
    font-size: 2rem;
  }
  .hero-cta {
    flex-direction: column;
  }
  .hero-button {
    width: 100%;
    text-align: center;
  }
}
</style>
