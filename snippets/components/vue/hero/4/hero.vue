<template>
  <section
    class="hero-video-bg"
    :style="heroStyles"
  >
    <div class="hero-background-container">
      <div
        v-if="backgroundImage"
        class="hero-video-placeholder"
        :style="{ backgroundImage: `url(${backgroundImage})` }"
      >
        <div class="video-play-icon">
          <svg width="80" height="80" viewBox="0 0 80 80" fill="none" xmlns="http://www.w3.org/2000/svg">
            <circle cx="40" cy="40" r="40" fill="rgba(255, 255, 255, 0.3)"/>
            <path d="M32 24L56 40L32 56V24Z" fill="white"/>
          </svg>
        </div>
      </div>
      <div class="hero-overlay" :style="{ backgroundColor: currentTheme.overlayColor }"></div>
      <div class="animated-gradient"></div>
    </div>

    <div class="hero-content">
      <div class="content-wrapper">
        <div class="badge animate-bounce-in" :style="{ backgroundColor: currentTheme.accentColor }">
          <span :style="{ color: currentTheme.textColor }">NEW</span>
        </div>

        <h1
          class="hero-title animate-zoom-in delay-1"
          :style="{ color: currentTheme.textColor }"
        >
          {{ title }}
        </h1>

        <p
          v-if="subtitle"
          class="hero-subtitle animate-zoom-in delay-2"
          :style="{ color: currentTheme.textColor }"
        >
          {{ subtitle }}
        </p>

        <p
          v-if="description"
          class="hero-description animate-zoom-in delay-3"
          :style="{ color: currentTheme.textColor }"
        >
          {{ description }}
        </p>

        <div
          v-if="ctaButtons && ctaButtons.length"
          class="hero-cta animate-zoom-in delay-4"
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

        <div class="hero-features animate-fade-in delay-5">
          <div class="feature-item">
            <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
              <path d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"/>
            </svg>
            <span>No credit card required</span>
          </div>
          <div class="feature-item">
            <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
              <path d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"/>
            </svg>
            <span>Free 14-day trial</span>
          </div>
          <div class="feature-item">
            <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
              <path d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"/>
            </svg>
            <span>Cancel anytime</span>
          </div>
        </div>
      </div>
    </div>

    <div class="floating-shapes">
      <div class="shape shape-1" :style="{ backgroundColor: currentTheme.primaryColor }"></div>
      <div class="shape shape-2" :style="{ backgroundColor: currentTheme.accentColor }"></div>
      <div class="shape shape-3" :style="{ backgroundColor: currentTheme.primaryColor }"></div>
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
    default: 'video-bg'
  },
  theme: {
    type: Object as PropType<Partial<HeroTheme>>,
    default: () => ({})
  }
})

const defaultTheme: HeroTheme = {
  primaryColor: '#ec4899',
  backgroundColor: '#1f2937',
  textColor: '#ffffff',
  accentColor: '#f472b6',
  overlayColor: 'rgba(31, 41, 55, 0.75)'
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
      backgroundColor: 'rgba(255, 255, 255, 0.2)',
      borderColor: 'rgba(255, 255, 255, 0.3)',
      color: '#ffffff',
      backdropFilter: 'blur(10px)'
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
.hero-video-bg {
  position: relative;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.hero-background-container {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
}

.hero-video-placeholder {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  display: flex;
  align-items: center;
  justify-content: center;
}

.video-play-icon {
  animation: pulse 2s ease-in-out infinite;
}

.hero-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
}

.animated-gradient {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(45deg,
    rgba(236, 72, 153, 0.3) 0%,
    rgba(244, 114, 182, 0.2) 50%,
    rgba(236, 72, 153, 0.3) 100%);
  background-size: 200% 200%;
  animation: gradientShift 10s ease infinite;
  z-index: 2;
}

.hero-content {
  position: relative;
  z-index: 3;
  max-width: 1000px;
  padding: 2rem;
  width: 100%;
}

.content-wrapper {
  text-align: center;
}

.badge {
  display: inline-block;
  padding: 0.5rem 1.25rem;
  border-radius: 2rem;
  font-size: 0.875rem;
  font-weight: 700;
  margin-bottom: 1.5rem;
  letter-spacing: 0.05em;
}

.hero-title {
  font-size: 4rem;
  font-weight: 900;
  line-height: 1.1;
  margin-bottom: 1.5rem;
  letter-spacing: -0.03em;
  text-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}

.hero-subtitle {
  font-size: 1.75rem;
  font-weight: 600;
  margin-bottom: 1rem;
  opacity: 0.95;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
}

.hero-description {
  font-size: 1.25rem;
  line-height: 1.6;
  margin-bottom: 2rem;
  max-width: 700px;
  margin-left: auto;
  margin-right: auto;
  opacity: 0.9;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
}

.hero-cta {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
  margin-bottom: 2rem;
}

.hero-button {
  padding: 1.125rem 2.5rem;
  font-size: 1.125rem;
  font-weight: 600;
  border: 2px solid;
  border-radius: 0.75rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.hero-button:hover {
  transform: translateY(-3px);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
}

.hero-features {
  display: flex;
  gap: 2rem;
  justify-content: center;
  flex-wrap: wrap;
  opacity: 0.95;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: white;
  font-size: 0.95rem;
}

.floating-shapes {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
  pointer-events: none;
}

.shape {
  position: absolute;
  border-radius: 50%;
  opacity: 0.1;
}

.shape-1 {
  width: 300px;
  height: 300px;
  top: 10%;
  left: 10%;
  animation: float 20s ease-in-out infinite;
}

.shape-2 {
  width: 200px;
  height: 200px;
  top: 60%;
  right: 15%;
  animation: float 15s ease-in-out infinite reverse;
}

.shape-3 {
  width: 150px;
  height: 150px;
  bottom: 20%;
  left: 20%;
  animation: float 25s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
    opacity: 0.7;
  }
  50% {
    transform: scale(1.1);
    opacity: 1;
  }
}

@keyframes gradientShift {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

@keyframes float {
  0%, 100% {
    transform: translateY(0) rotate(0deg);
  }
  50% {
    transform: translateY(-30px) rotate(180deg);
  }
}

.animate-bounce-in {
  animation: bounceIn 0.6s ease-out forwards;
  opacity: 0;
}

.animate-zoom-in {
  animation: zoomIn 0.8s ease-out forwards;
  opacity: 0;
}

.animate-fade-in {
  animation: fadeIn 1s ease-out forwards;
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

.delay-4 {
  animation-delay: 0.8s;
}

.delay-5 {
  animation-delay: 1s;
}

@keyframes bounceIn {
  0% {
    opacity: 0;
    transform: scale(0.3) translateY(-20px);
  }
  50% {
    transform: scale(1.05);
  }
  70% {
    transform: scale(0.9);
  }
  100% {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

@keyframes zoomIn {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 2.25rem;
  }

  .hero-subtitle {
    font-size: 1.25rem;
  }

  .hero-description {
    font-size: 1rem;
  }

  .hero-button {
    padding: 1rem 2rem;
    font-size: 1rem;
  }

  .hero-features {
    flex-direction: column;
    gap: 1rem;
    align-items: center;
  }

  .shape {
    display: none;
  }
}
</style>
