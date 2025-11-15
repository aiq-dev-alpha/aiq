<template>
  <section
    class="hero-gradient"
    :style="heroStyles"
  >
    <div class="gradient-background">
      <div class="gradient-orb orb-1" :style="{ backgroundColor: currentTheme.primaryColor }"></div>
      <div class="gradient-orb orb-2" :style="{ backgroundColor: currentTheme.accentColor }"></div>
      <div class="gradient-orb orb-3" :style="{ backgroundColor: currentTheme.primaryColor }"></div>
      <div class="gradient-mesh"></div>
    </div>

    <div class="hero-content">
      <div class="content-grid">
        <div class="text-section">
          <div class="tag animate-slide-up" :style="{ color: currentTheme.primaryColor }">
            <span class="tag-dot" :style="{ backgroundColor: currentTheme.primaryColor }"></span>
            Introducing
          </div>

          <h1
            class="hero-title animate-slide-up delay-1"
            :style="{ color: currentTheme.textColor }"
          >
            {{ title }}
          </h1>

          <p
            v-if="subtitle"
            class="hero-subtitle animate-slide-up delay-2"
            :style="{ color: currentTheme.textColor }"
          >
            {{ subtitle }}
          </p>

          <p
            v-if="description"
            class="hero-description animate-slide-up delay-3"
            :style="{ color: currentTheme.textColor }"
          >
            {{ description }}
          </p>

          <div
            v-if="ctaButtons && ctaButtons.length"
            class="hero-cta animate-slide-up delay-4"
          >
            <button
              v-for="(button, index) in ctaButtons"
              :key="index"
              :class="['hero-button', `button-${button.variant || 'primary'}`]"
              :style="getButtonStyles(button.variant)"
              @click="button.onClick"
            >
              {{ button.label }}
              <svg v-if="index === 0" width="20" height="20" viewBox="0 0 20 20" fill="currentColor" class="button-icon">
                <path fill-rule="evenodd" d="M10.293 3.293a1 1 0 011.414 0l6 6a1 1 0 010 1.414l-6 6a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-4.293-4.293a1 1 0 010-1.414z" clip-rule="evenodd"/>
              </svg>
            </button>
          </div>

          <div class="stats animate-slide-up delay-5">
            <div class="stat-item">
              <div class="stat-value" :style="{ color: currentTheme.primaryColor }">10k+</div>
              <div class="stat-label">Active Users</div>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <div class="stat-value" :style="{ color: currentTheme.primaryColor }">99.9%</div>
              <div class="stat-label">Uptime</div>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <div class="stat-value" :style="{ color: currentTheme.primaryColor }">4.9/5</div>
              <div class="stat-label">Rating</div>
            </div>
          </div>
        </div>

        <div
          v-if="image"
          class="image-section animate-float"
        >
          <div class="image-wrapper">
            <img :src="image" :alt="title" />
            <div class="image-glow" :style="{ backgroundColor: currentTheme.accentColor }"></div>
          </div>
        </div>
      </div>
    </div>

    <div class="decorative-elements">
      <div class="grid-pattern"></div>
      <div class="dots-pattern"></div>
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
    default: 'gradient'
  },
  theme: {
    type: Object as PropType<Partial<HeroTheme>>,
    default: () => ({})
  }
})

const defaultTheme: HeroTheme = {
  primaryColor: '#8b5cf6',
  backgroundColor: '#faf5ff',
  textColor: '#1f2937',
  accentColor: '#a78bfa',
  overlayColor: 'rgba(139, 92, 246, 0.1)'
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
      backgroundColor: 'transparent',
      borderColor: currentTheme.value.textColor,
      color: currentTheme.value.textColor
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
.hero-gradient {
  position: relative;
  min-height: 100vh;
  overflow: hidden;
  display: flex;
  align-items: center;
}

.gradient-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
  overflow: hidden;
}

.gradient-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(100px);
  opacity: 0.3;
}

.orb-1 {
  width: 500px;
  height: 500px;
  top: -10%;
  right: -5%;
  animation: orbFloat1 20s ease-in-out infinite;
}

.orb-2 {
  width: 400px;
  height: 400px;
  bottom: -10%;
  left: -5%;
  animation: orbFloat2 15s ease-in-out infinite;
}

.orb-3 {
  width: 300px;
  height: 300px;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  animation: orbFloat3 25s ease-in-out infinite;
}

.gradient-mesh {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle at 20% 50%, rgba(139, 92, 246, 0.1) 0%, transparent 50%),
              radial-gradient(circle at 80% 80%, rgba(167, 139, 250, 0.1) 0%, transparent 50%);
}

.hero-content {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: 4rem 2rem;
}

.content-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: center;
}

.text-section {
  max-width: 600px;
}

.tag {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.tag-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  animation: pulse 2s ease-in-out infinite;
}

.hero-title {
  font-size: 4rem;
  font-weight: 900;
  line-height: 1.1;
  margin-bottom: 1.5rem;
  letter-spacing: -0.04em;
  background: linear-gradient(135deg, #1f2937 0%, #6b7280 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.hero-subtitle {
  font-size: 1.5rem;
  font-weight: 600;
  margin-bottom: 1rem;
  opacity: 0.9;
}

.hero-description {
  font-size: 1.125rem;
  line-height: 1.7;
  margin-bottom: 2.5rem;
  opacity: 0.7;
}

.hero-cta {
  display: flex;
  gap: 1rem;
  margin-bottom: 3rem;
  flex-wrap: wrap;
}

.hero-button {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 1rem 2rem;
  font-size: 1rem;
  font-weight: 600;
  border: 2px solid;
  border-radius: 0.75rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.hero-button:hover {
  transform: translateX(4px);
  box-shadow: 0 10px 30px rgba(139, 92, 246, 0.3);
}

.button-icon {
  transition: transform 0.3s ease;
}

.hero-button:hover .button-icon {
  transform: translateX(4px);
}

.stats {
  display: flex;
  gap: 2rem;
  align-items: center;
}

.stat-item {
  text-align: left;
}

.stat-value {
  font-size: 2rem;
  font-weight: 800;
  line-height: 1;
  margin-bottom: 0.25rem;
}

.stat-label {
  font-size: 0.875rem;
  opacity: 0.6;
}

.stat-divider {
  width: 1px;
  height: 40px;
  background: currentColor;
  opacity: 0.2;
}

.image-section {
  position: relative;
}

.image-wrapper {
  position: relative;
  border-radius: 1.5rem;
  overflow: hidden;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.1);
}

.image-wrapper img {
  width: 100%;
  height: auto;
  display: block;
  position: relative;
  z-index: 1;
}

.image-glow {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 80%;
  height: 80%;
  transform: translate(-50%, -50%);
  border-radius: 50%;
  filter: blur(60px);
  opacity: 0.4;
  z-index: 0;
}

.decorative-elements {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
  pointer-events: none;
}

.grid-pattern {
  position: absolute;
  top: 0;
  right: 0;
  width: 400px;
  height: 400px;
  background-image:
    linear-gradient(rgba(139, 92, 246, 0.05) 1px, transparent 1px),
    linear-gradient(90deg, rgba(139, 92, 246, 0.05) 1px, transparent 1px);
  background-size: 30px 30px;
  opacity: 0.5;
}

.dots-pattern {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 300px;
  height: 300px;
  background-image: radial-gradient(circle, rgba(139, 92, 246, 0.1) 1px, transparent 1px);
  background-size: 20px 20px;
}

@keyframes orbFloat1 {
  0%, 100% {
    transform: translate(0, 0) scale(1);
  }
  50% {
    transform: translate(-30px, 30px) scale(1.1);
  }
}

@keyframes orbFloat2 {
  0%, 100% {
    transform: translate(0, 0) scale(1);
  }
  50% {
    transform: translate(40px, -40px) scale(1.15);
  }
}

@keyframes orbFloat3 {
  0%, 100% {
    transform: translate(-50%, -50%) scale(1);
  }
  50% {
    transform: translate(-50%, -50%) scale(1.2);
  }
}

.animate-slide-up {
  animation: slideUp 0.8s ease-out forwards;
  opacity: 0;
}

.animate-float {
  animation: float 3s ease-in-out infinite, fadeIn 1s ease-out forwards;
  opacity: 0;
}

.delay-1 {
  animation-delay: 0.1s;
}

.delay-2 {
  animation-delay: 0.2s;
}

.delay-3 {
  animation-delay: 0.3s;
}

.delay-4 {
  animation-delay: 0.4s;
}

.delay-5 {
  animation-delay: 0.5s;
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-20px);
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

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

@media (max-width: 1024px) {
  .content-grid {
    grid-template-columns: 1fr;
    gap: 3rem;
  }

  .text-section {
    max-width: 100%;
  }

  .hero-title {
    font-size: 3rem;
  }

  .stats {
    justify-content: space-between;
  }
}

@media (max-width: 768px) {
  .hero-content {
    padding: 3rem 1.5rem;
  }

  .hero-title {
    font-size: 2.25rem;
  }

  .hero-subtitle {
    font-size: 1.25rem;
  }

  .hero-description {
    font-size: 1rem;
  }

  .stats {
    gap: 1rem;
  }

  .stat-value {
    font-size: 1.5rem;
  }

  .stat-label {
    font-size: 0.75rem;
  }

  .hero-cta {
    flex-direction: column;
  }

  .hero-button {
    width: 100%;
    justify-content: center;
  }

  .orb-1, .orb-2, .orb-3 {
    opacity: 0.15;
  }
}
</style>
