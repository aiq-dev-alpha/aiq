<template>
  <div class="wizard-gradient" :class="[orientationClass]" :style="containerStyles">
    <div class="wizard-background">
      <div class="gradient-orb orb-1"></div>
      <div class="gradient-orb orb-2"></div>
      <div class="gradient-orb orb-3"></div>
    </div>
    <div class="wizard-content">
      <div class="wizard-progress-section">
        <div class="progress-header">
          <div class="progress-stats">
            <span class="current-step-num">{{ internalStep + 1 }}</span>
            <span class="step-divider">/</span>
            <span class="total-steps">{{ steps.length }}</span>
          </div>
          <div class="progress-label">Steps Completed</div>
        </div>
        <div class="steps-indicator">
          <div
            v-for="(step, index) in steps"
            :key="step.id"
            class="step-bubble"
            :class="bubbleClasses(index)"
            @click="handleStepClick(index)"
          >
            <div class="bubble-inner">
              <svg v-if="step.completed || index < internalStep" class="bubble-icon check" viewBox="0 0 24 24" fill="none">
                <circle cx="12" cy="12" r="11" :fill="getBubbleColor(index)" opacity="0.2"/>
                <circle cx="12" cy="12" r="9" :stroke="getBubbleColor(index)" stroke-width="2" fill="none"/>
                <path d="M7 12l3 3 7-7" :stroke="getBubbleColor(index)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              <div v-else-if="index === internalStep" class="bubble-icon active">
                <div class="pulse-ring"></div>
                <div class="bubble-dot"></div>
              </div>
              <div v-else class="bubble-icon pending">
                <div class="bubble-number">{{ index + 1 }}</div>
              </div>
            </div>
            <div class="bubble-label">{{ step.label }}</div>
          </div>
        </div>
      </div>
      <div class="wizard-card">
        <div class="card-header">
          <div class="header-badge">
            <svg class="badge-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M9 12l2 2 4-4" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span>Step {{ internalStep + 1 }}</span>
          </div>
          <h2 class="card-title">{{ currentStepData?.label }}</h2>
          <p v-if="currentStepData?.description" class="card-description">
            {{ currentStepData.description }}
          </p>
        </div>
        <div class="card-body">
          <transition name="fade-zoom" mode="out-in">
            <div :key="internalStep" class="step-container">
              <slot :current-step="currentStepData" :step-index="internalStep" :progress="progressPercentage"></slot>
            </div>
          </transition>
        </div>
        <div class="card-footer">
          <div class="footer-progress">
            <div class="progress-track-modern">
              <div
                class="progress-fill-modern"
                :style="{ width: progressPercentage + '%' }"
              >
                <div class="progress-glow"></div>
              </div>
            </div>
            <div class="progress-percentage">{{ progressPercentage }}% Complete</div>
          </div>
          <div class="footer-actions">
            <button
              v-if="!isFirstStep"
              class="btn btn-ghost"
              @click="handlePrevious"
            >
              <svg class="btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path d="M19 12H5M12 19l-7-7 7-7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              Back
            </button>
            <button
              v-if="!isLastStep"
              class="btn btn-gradient"
              @click="handleNext"
            >
              Continue
              <svg class="btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path d="M5 12h14M12 5l7 7-7 7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </button>
            <button
              v-else
              class="btn btn-success-gradient"
              @click="handleComplete"
            >
              <svg class="btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path d="M5 13l4 4L19 7" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              Complete
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup lang="ts">
import { ref, computed, watch } from 'vue'
interface WizardTheme {
  primaryColor?: string
  backgroundColor?: string
  textColor?: string
  activeColor?: string
  completedColor?: string
  borderColor?: string
}
interface WizardStep {
  id: string | number
  label: string
  description?: string
  icon?: string
  completed?: boolean
  active?: boolean
}
interface Props {
  steps: WizardStep[]
  currentStep?: number
  variant?: 'numbered' | 'icons' | 'progress-bar' | 'minimal' | 'detailed'
  orientation?: 'horizontal' | 'vertical'
  theme?: WizardTheme
  allowStepNavigation?: boolean
}
const props = withDefaults(defineProps<Props>(), {
  currentStep: 0,
  variant: 'minimal',
  orientation: 'horizontal',
  theme: () => ({
    primaryColor: '#ec4899',
    backgroundColor: '#0f172a',
    textColor: '#f1f5f9',
    activeColor: '#f472b6',
    completedColor: '#10b981',
    borderColor: '#334155'
  }),
  allowStepNavigation: true
})
const emit = defineEmits<{
  (e: 'step-changed', step: number): void
  (e: 'completed'): void
  (e: 'update:currentStep', step: number): void
}>()
const internalStep = ref(props.currentStep)
watch(() => props.currentStep, (newVal) => {
  internalStep.value = newVal
})
const currentStepData = computed(() => props.steps[internalStep.value])
const isFirstStep = computed(() => internalStep.value === 0)
const isLastStep = computed(() => internalStep.value === props.steps.length - 1)
const progressPercentage = computed(() => {
  return Math.round(((internalStep.value + 1) / props.steps.length) * 100)
})
const orientationClass = computed(() => `orientation-${props.orientation}`)
const containerStyles = computed(() => ({
  '--primary-color': props.theme.primaryColor,
  '--background-color': props.theme.backgroundColor,
  '--text-color': props.theme.textColor,
  '--active-color': props.theme.activeColor,
  '--completed-color': props.theme.completedColor,
  '--border-color': props.theme.borderColor
}))
const bubbleClasses = (index: number) => ({
  'bubble-completed': props.steps[index].completed || index < internalStep.value,
  'bubble-active': index === internalStep.value,
  'bubble-pending': index > internalStep.value,
  'bubble-clickable': props.allowStepNavigation && index <= internalStep.value
})
const getBubbleColor = (index: number) => {
  if (props.steps[index].completed || index < internalStep.value) {
    return props.theme.completedColor
  }
  if (index === internalStep.value) {
    return props.theme.primaryColor
  }
  return '#64748b'
}
const handleStepClick = (index: number) => {
  if (props.allowStepNavigation && index <= internalStep.value) {
    internalStep.value = index
    emit('update:currentStep', index)
    emit('step-changed', index)
  }
}
const handleNext = () => {
  if (!isLastStep.value) {
    internalStep.value++
    emit('update:currentStep', internalStep.value)
    emit('step-changed', internalStep.value)
  }
}
const handlePrevious = () => {
  if (!isFirstStep.value) {
    internalStep.value--
    emit('update:currentStep', internalStep.value)
    emit('step-changed', internalStep.value)
  }
}
const handleComplete = () => {
  emit('completed')
}
</script>
<style scoped>
.wizard-gradient {
  position: relative;
  min-height: 600px;
  background: var(--background-color);
  border-radius: 20px;
  overflow: hidden;
  padding: 3rem;
}
.wizard-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  overflow: hidden;
  pointer-events: none;
}
.gradient-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.4;
  animation: float 20s ease-in-out infinite;
}
.orb-1 {
  width: 400px;
  height: 400px;
  background: radial-gradient(circle, var(--primary-color), transparent);
  top: -200px;
  right: -100px;
  animation-delay: 0s;
}
.orb-2 {
  width: 300px;
  height: 300px;
  background: radial-gradient(circle, var(--active-color), transparent);
  bottom: -150px;
  left: -100px;
  animation-delay: 7s;
}
.orb-3 {
  width: 250px;
  height: 250px;
  background: radial-gradient(circle, #8b5cf6, transparent);
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  animation-delay: 14s;
}
@keyframes float {
  0%, 100% {
    transform: translate(0, 0) scale(1);
  }
  33% {
    transform: translate(30px, -30px) scale(1.1);
  }
  66% {
    transform: translate(-20px, 20px) scale(0.9);
  }
}
.wizard-content {
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}
.wizard-progress-section {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}
.progress-header {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.progress-stats {
  display: flex;
  align-items: baseline;
  gap: 0.5rem;
  font-weight: 700;
}
.current-step-num {
  font-size: 3rem;
  background: linear-gradient(135deg, var(--primary-color), var(--active-color));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  line-height: 1;
}
.step-divider {
  font-size: 2rem;
  color: var(--border-color);
}
.total-steps {
  font-size: 2rem;
  color: #64748b;
}
.progress-label {
  font-size: 0.875rem;
  color: #94a3b8;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  font-weight: 600;
}
.steps-indicator {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}
.step-bubble {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.75rem;
  transition: all 0.3s ease;
}
.bubble-clickable {
  cursor: pointer;
}
.bubble-clickable:hover .bubble-inner {
  transform: scale(1.1);
}
.bubble-inner {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border: 2px solid rgba(255, 255, 255, 0.1);
}
.bubble-completed .bubble-inner {
  background: rgba(16, 185, 129, 0.1);
  border-color: var(--completed-color);
  box-shadow: 0 0 20px rgba(16, 185, 129, 0.3);
}
.bubble-active .bubble-inner {
  background: rgba(236, 72, 153, 0.1);
  border-color: var(--primary-color);
  box-shadow: 0 0 30px rgba(236, 72, 153, 0.4);
}
.bubble-icon {
  width: 48px;
  height: 48px;
}
.bubble-icon.check {
  width: 100%;
  height: 100%;
}
.bubble-icon.active {
  position: relative;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}
.pulse-ring {
  position: absolute;
  width: 100%;
  height: 100%;
  border-radius: 50%;
  border: 2px solid var(--primary-color);
  animation: pulse-animation 2s ease-out infinite;
}
@keyframes pulse-animation {
  0% {
    transform: scale(0.5);
    opacity: 1;
  }
  100% {
    transform: scale(1.2);
    opacity: 0;
  }
}
.bubble-dot {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--primary-color), var(--active-color));
  box-shadow: 0 0 15px var(--primary-color);
}
.bubble-icon.pending {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}
.bubble-number {
  font-size: 1.25rem;
  font-weight: 700;
  color: #64748b;
}
.bubble-label {
  font-size: 0.8125rem;
  font-weight: 500;
  color: var(--text-color);
  text-align: center;
  max-width: 80px;
  line-height: 1.3;
}
.bubble-active .bubble-label {
  color: var(--primary-color);
  font-weight: 600;
}
.wizard-card {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(20px);
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}
.card-header {
  padding: 2rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  flex-direction: column;
  gap: 1rem;
}
.header-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background: linear-gradient(135deg, var(--primary-color), var(--active-color));
  border-radius: 20px;
  font-size: 0.875rem;
  font-weight: 600;
  color: white;
  width: fit-content;
  box-shadow: 0 4px 12px rgba(236, 72, 153, 0.3);
}
.badge-icon {
  width: 18px;
  height: 18px;
}
.card-title {
  font-size: 1.75rem;
  font-weight: 700;
  color: var(--text-color);
  margin: 0;
}
.card-description {
  font-size: 1rem;
  color: #94a3b8;
  line-height: 1.6;
  margin: 0;
}
.card-body {
  padding: 2rem;
  min-height: 250px;
}
.step-container {
  width: 100%;
}
.fade-zoom-enter-active,
.fade-zoom-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}
.fade-zoom-enter-from {
  opacity: 0;
  transform: scale(0.9) translateY(20px);
}
.fade-zoom-leave-to {
  opacity: 0;
  transform: scale(1.1) translateY(-20px);
}
.card-footer {
  padding: 2rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}
.footer-progress {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}
.progress-track-modern {
  height: 6px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  overflow: hidden;
  position: relative;
}
.progress-fill-modern {
  height: 100%;
  background: linear-gradient(90deg, var(--completed-color), var(--primary-color), var(--active-color));
  border-radius: 10px;
  transition: width 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}
.progress-glow {
  position: absolute;
  top: -50%;
  left: -50%;
  right: -50%;
  bottom: -50%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
  animation: glow-slide 2s infinite;
}
@keyframes glow-slide {
  0% {
    transform: translateX(-100%) rotate(45deg);
  }
  100% {
    transform: translateX(200%) rotate(45deg);
  }
}
.progress-percentage {
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--text-color);
  text-align: center;
}
.footer-actions {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
}
.btn {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.875rem 1.75rem;
  border-radius: 12px;
  font-weight: 600;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  border: none;
}
.btn-icon {
  width: 20px;
  height: 20px;
}
.btn-ghost {
  background: rgba(255, 255, 255, 0.05);
  color: var(--text-color);
  border: 1px solid rgba(255, 255, 255, 0.2);
}
.btn-ghost:hover {
  background: rgba(255, 255, 255, 0.1);
  transform: translateX(-4px);
}
.btn-gradient {
  background: linear-gradient(135deg, var(--primary-color), var(--active-color));
  color: white;
  box-shadow: 0 4px 16px rgba(236, 72, 153, 0.4);
}
.btn-gradient:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 24px rgba(236, 72, 153, 0.5);
}
.btn-success-gradient {
  background: linear-gradient(135deg, var(--completed-color), #34d399);
  color: white;
  box-shadow: 0 4px 16px rgba(16, 185, 129, 0.4);
}
.btn-success-gradient:hover {
  transform: scale(1.05);
  box-shadow: 0 6px 24px rgba(16, 185, 129, 0.5);
}
button:disabled {
  opacity: 0.4;
  cursor: not-allowed;
  transform: none !important;
}
</style>
