<template>
  <section
    class="hero-full-screen"
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
      <div class="hero-text">
        <h1
          class="hero-title animate-fade-in-up"
          :style="{ color: currentTheme.textColor }"
        >
          {{ title }}
        </h1>
        <p
          v-if="subtitle"
          class="hero-subtitle animate-fade-in-up delay-1"
          :style="{ color: currentTheme.textColor }"
        >
          {{ subtitle }}
        </p>
        <p
          v-if="description"
          class="hero-description animate-fade-in-up delay-2"
          :style="{ color: currentTheme.textColor }"
        >
          {{ description }}
        </p>
        <div
          v-if="ctaButtons && ctaButtons.length"
          class="hero-cta animate-fade-in-up delay-3"
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
    <div class="hero-scroll-indicator">
      <div class="scroll-arrow"></div>
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
    default: 'full-screen'
  },
  theme: {
    type: Object as PropType<Partial<HeroTheme>>,
    default: () => ({})
  }
})
const defaultTheme: HeroTheme = {
  primaryColor: '#6366f1',
  backgroundColor: '#0f172a',
  textColor: '#ffffff',
  accentColor: '#818cf8',
  overlayColor: 'rgba(15, 23, 42, 0.7)'
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
      borderColor: currentTheme.value.accentColor
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
    borderColor: currentTheme.value.primaryColor
  }
}
</script>
<style scoped>
.hero-full-screen {
  position: relative;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}
.hero-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  z-index: 0;
}
.hero-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(99, 102, 241, 0.3) 0%, rgba(15, 23, 42, 0.8) 100%);
}
.hero-content {
  position: relative;
  z-index: 1;
  max-width: 1200px;
  padding: 2rem;
  width: 100%;
}
.hero-text {
  text-align: center;
}
.hero-title {
  font-size: 4.5rem;
  font-weight: 800;
  line-height: 1.1;
  margin-bottom: 1.5rem;
  letter-spacing: -0.02em;
}
.hero-subtitle {
  font-size: 1.5rem;
  font-weight: 600;
  margin-bottom: 1rem;
  opacity: 0.95;
}
.hero-description {
  font-size: 1.25rem;
  line-height: 1.6;
  margin-bottom: 2rem;
  max-width: 700px;
  margin-left: auto;
  margin-right: auto;
  opacity: 0.9;
}
.hero-cta {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}
.hero-button {
  padding: 1rem 2.5rem;
  font-size: 1.125rem;
  font-weight: 600;
  border: 2px solid;
  border-radius: 0.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
  color: white;
}
.hero-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
}
.hero-scroll-indicator {
  position: absolute;
  bottom: 2rem;
  left: 50%;
  transform: translateX(-50%);
  z-index: 1;
}
.scroll-arrow {
  width: 24px;
  height: 24px;
  border-right: 2px solid white;
  border-bottom: 2px solid white;
  transform: rotate(45deg);
  animation: bounce 2s infinite;
  opacity: 0.7;
}
@keyframes bounce {
  0%, 20%, 50%, 80%, 100% {
    transform: rotate(45deg) translateY(0);
  }
  40% {
    transform: rotate(45deg) translateY(-10px);
  }
  60% {
    transform: rotate(45deg) translateY(-5px);
  }
}
.animate-fade-in-up {
  animation: fadeInUp 0.8s ease-out forwards;
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
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
@media (max-width: 768px) {
  .hero-title {
    font-size: 2.5rem;
  }
  .hero-subtitle {
    font-size: 1.25rem;
  }
  .hero-description {
    font-size: 1rem;
  }
  .hero-button {
    padding: 0.875rem 2rem;
    font-size: 1rem;
  }
}
</style>
