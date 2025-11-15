<template>
  <div class="wizard-detailed" :class="[orientationClass]" :style="containerStyles">
    <div class="wizard-container">
      <aside class="wizard-sidebar">
        <div class="sidebar-header">
          <h3 class="sidebar-title">Your Progress</h3>
          <div class="progress-circle" :style="{ '--progress': progressPercentage }">
            <svg viewBox="0 0 100 100">
              <circle cx="50" cy="50" r="45" class="progress-bg" />
              <circle cx="50" cy="50" r="45" class="progress-value" />
            </svg>
            <div class="progress-number">{{ progressPercentage }}%</div>
          </div>
        </div>
        <nav class="steps-nav">
          <div
            v-for="(step, index) in steps"
            :key="step.id"
            class="nav-step"
            :class="navStepClasses(index)"
            @click="handleStepClick(index)"
          >
            <div class="step-timeline">
              <div class="step-marker">
                <svg v-if="step.completed || index < internalStep" class="step-icon-check" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                </svg>
                <svg v-else-if="index === internalStep" class="step-icon-active" viewBox="0 0 24 24" fill="currentColor">
                  <circle cx="12" cy="12" r="10"/>
                </svg>
                <div v-else class="step-icon-pending">{{ index + 1 }}</div>
              </div>
              <div v-if="index < steps.length - 1" class="step-line"></div>
            </div>
            <div class="step-details">
              <div class="step-status">
                <span v-if="step.completed || index < internalStep" class="status-badge completed">Completed</span>
                <span v-else-if="index === internalStep" class="status-badge active">In Progress</span>
                <span v-else class="status-badge pending">Pending</span>
              </div>
              <h4 class="step-title">{{ step.label }}</h4>
              <p v-if="step.description" class="step-desc">{{ step.description }}</p>
            </div>
          </div>
        </nav>
      </aside>
      <main class="wizard-main">
        <div class="main-header">
          <div class="step-breadcrumb">
            <span class="breadcrumb-step">Step {{ internalStep + 1 }}</span>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-total">{{ steps.length }}</span>
          </div>
          <h2 class="main-title">{{ currentStepData?.label }}</h2>
          <p v-if="currentStepData?.description" class="main-description">
            {{ currentStepData.description }}
          </p>
        </div>
        <div class="main-content">
          <transition name="slide-fade" mode="out-in">
            <div :key="internalStep" class="content-wrapper">
              <slot :current-step="currentStepData" :step-index="internalStep" :is-last-step="isLastStep"></slot>
            </div>
          </transition>
        </div>
        <div class="main-actions">
          <button
            v-if="!isFirstStep"
            class="btn btn-secondary"
            @click="handlePrevious"
            :style="buttonStyles.secondary"
          >
            <svg class="btn-icon-left" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path d="M15 18l-6-6 6-6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            Previous Step
          </button>
          <div class="spacer"></div>
          <button
            v-if="!isLastStep"
            class="btn btn-primary"
            @click="handleNext"
            :style="buttonStyles.primary"
          >
            Next Step
            <svg class="btn-icon-right" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path d="M9 18l6-6-6-6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </button>
          <button
            v-else
            class="btn btn-success"
            @click="handleComplete"
            :style="buttonStyles.success"
          >
            <svg class="btn-icon-left" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path d="M5 13l4 4L19 7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            Complete Wizard
          </button>
        </div>
      </main>
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
  variant: 'detailed',
  orientation: 'vertical',
  theme: () => ({
    primaryColor: '#6366f1',
    backgroundColor: '#f8f9fa',
    textColor: '#1e293b',
    activeColor: '#818cf8',
    completedColor: '#059669',
    borderColor: '#e2e8f0'
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
  const completed = props.steps.filter((s, i) => s.completed || i < internalStep.value).length
  return Math.round((completed / props.steps.length) * 100)
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
const buttonStyles = computed(() => ({
  primary: {
    backgroundColor: props.theme.primaryColor,
    borderColor: props.theme.primaryColor
  },
  secondary: {
    borderColor: props.theme.borderColor,
    color: props.theme.textColor
  },
  success: {
    backgroundColor: props.theme.completedColor,
    borderColor: props.theme.completedColor
  }
}))
const navStepClasses = (index: number) => ({
  'step-completed': props.steps[index].completed || index < internalStep.value,
  'step-active': index === internalStep.value,
  'step-pending': index > internalStep.value,
  'step-clickable': props.allowStepNavigation && index <= internalStep.value
})
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
.wizard-detailed {
  background: var(--background-color);
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05), 0 1px 3px rgba(0, 0, 0, 0.1);
}
.wizard-container {
  display: grid;
  grid-template-columns: 320px 1fr;
  min-height: 600px;
}
.wizard-sidebar {
  background: linear-gradient(180deg, #ffffff 0%, #f8f9ff 100%);
  border-right: 2px solid var(--border-color);
  padding: 2rem 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}
.sidebar-header {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  padding-bottom: 1.5rem;
  border-bottom: 2px solid var(--border-color);
}
.sidebar-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--text-color);
  margin: 0;
}
.progress-circle {
  position: relative;
  width: 120px;
  height: 120px;
  margin: 0 auto;
}
.progress-circle svg {
  transform: rotate(-90deg);
  width: 100%;
  height: 100%;
}
.progress-bg {
  fill: none;
  stroke: var(--border-color);
  stroke-width: 8;
}
.progress-value {
  fill: none;
  stroke: var(--primary-color);
  stroke-width: 8;
  stroke-linecap: round;
  stroke-dasharray: 283;
  stroke-dashoffset: calc(283 - (283 * var(--progress)) / 100);
  transition: stroke-dashoffset 0.5s ease;
}
.progress-number {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 1.75rem;
  font-weight: 700;
  color: var(--primary-color);
}
.steps-nav {
  display: flex;
  flex-direction: column;
  gap: 0;
}
.nav-step {
  display: grid;
  grid-template-columns: 48px 1fr;
  gap: 1rem;
  padding: 1rem 0;
  transition: all 0.3s ease;
}
.step-clickable {
  cursor: pointer;
}
.step-clickable:hover {
  background: rgba(99, 102, 241, 0.05);
  margin: 0 -1rem;
  padding: 1rem;
  border-radius: 8px;
}
.step-timeline {
  display: flex;
  flex-direction: column;
  align-items: center;
}
.step-marker {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: all 0.3s ease;
  background: #e2e8f0;
  z-index: 1;
}
.step-completed .step-marker {
  background: var(--completed-color);
  box-shadow: 0 0 0 4px rgba(5, 150, 105, 0.1);
}
.step-active .step-marker {
  background: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.2);
  animation: pulse-ring 2s ease-in-out infinite;
}
@keyframes pulse-ring {
  0%, 100% {
    box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.2);
  }
  50% {
    box-shadow: 0 0 0 8px rgba(99, 102, 241, 0.1);
  }
}
.step-icon-check {
  width: 28px;
  height: 28px;
  color: white;
}
.step-icon-active {
  width: 24px;
  height: 24px;
  color: white;
}
.step-icon-pending {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 1rem;
  color: #64748b;
}
.step-line {
  width: 3px;
  flex: 1;
  background: var(--border-color);
  margin-top: 0.5rem;
  transition: background 0.3s ease;
}
.step-completed .step-line {
  background: var(--completed-color);
}
.step-details {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  padding-top: 0.25rem;
}
.step-status {
  margin-bottom: 0.25rem;
}
.status-badge {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.status-badge.completed {
  background: rgba(5, 150, 105, 0.1);
  color: var(--completed-color);
}
.status-badge.active {
  background: rgba(99, 102, 241, 0.1);
  color: var(--primary-color);
}
.status-badge.pending {
  background: #f1f5f9;
  color: #94a3b8;
}
.step-title {
  font-size: 1rem;
  font-weight: 600;
  color: var(--text-color);
  margin: 0;
  line-height: 1.4;
}
.step-active .step-title {
  color: var(--primary-color);
  font-size: 1.0625rem;
}
.step-desc {
  font-size: 0.8125rem;
  color: #64748b;
  line-height: 1.5;
  margin: 0;
}
.wizard-main {
  background: white;
  padding: 2.5rem;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}
.main-header {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  padding-bottom: 2rem;
  border-bottom: 2px solid var(--border-color);
}
.step-breadcrumb {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  font-weight: 600;
}
.breadcrumb-step {
  color: var(--primary-color);
}
.breadcrumb-separator {
  color: #cbd5e1;
}
.breadcrumb-total {
  color: #94a3b8;
}
.main-title {
  font-size: 2rem;
  font-weight: 700;
  color: var(--text-color);
  margin: 0;
}
.main-description {
  font-size: 1rem;
  color: #64748b;
  line-height: 1.6;
  margin: 0;
}
.main-content {
  flex: 1;
  min-height: 300px;
}
.content-wrapper {
  width: 100%;
}
.slide-fade-enter-active,
.slide-fade-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.slide-fade-enter-from {
  opacity: 0;
  transform: translateY(10px);
}
.slide-fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
.main-actions {
  display: flex;
  gap: 1rem;
  padding-top: 2rem;
  border-top: 2px solid var(--border-color);
}
.spacer {
  flex: 1;
}
.btn {
  display: flex;
  align-items: center;
  gap: 0.625rem;
  padding: 0.875rem 1.75rem;
  border-radius: 10px;
  font-weight: 600;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 2px solid;
}
.btn-icon-left,
.btn-icon-right {
  width: 20px;
  height: 20px;
}
.btn-primary {
  background: var(--primary-color);
  color: white;
  border-color: var(--primary-color);
}
.btn-primary:hover {
  background: var(--active-color);
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(99, 102, 241, 0.3);
}
.btn-secondary {
  background: white;
  color: var(--text-color);
  border-color: var(--border-color);
}
.btn-secondary:hover {
  background: #f8fafc;
  border-color: var(--text-color);
  transform: translateY(-2px);
}
.btn-success {
  background: var(--completed-color);
  color: white;
  border-color: var(--completed-color);
}
.btn-success:hover {
  opacity: 0.9;
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(5, 150, 105, 0.3);
}
button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none !important;
}
@media (max-width: 768px) {
  .wizard-container {
    grid-template-columns: 1fr;
  }
  .wizard-sidebar {
    border-right: none;
    border-bottom: 2px solid var(--border-color);
  }
}
</style>
