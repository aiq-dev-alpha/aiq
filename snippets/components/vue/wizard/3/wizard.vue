<template>
  <div class="wizard-progress-bar" :class="[orientationClass]" :style="containerStyles">
    <div class="wizard-header">
      <div class="header-content">
        <h3 class="wizard-title">{{ currentStepData?.label }}</h3>
        <p class="wizard-subtitle">{{ currentStepData?.description || `Step ${internalStep + 1} of ${steps.length}` }}</p>
      </div>
      <div class="progress-indicator">
        <div class="progress-count">{{ internalStep + 1 }}/{{ steps.length }}</div>
      </div>
    </div>
    <div class="main-progress-bar">
      <div class="progress-track">
        <div class="progress-fill" :style="{ width: progressWidth + '%' }">
          <div class="progress-shine"></div>
        </div>
      </div>
      <div class="progress-steps">
        <div
          v-for="(step, index) in steps"
          :key="step.id"
          class="progress-step"
          :class="progressStepClasses(index)"
          :style="{ left: (index / (steps.length - 1)) * 100 + '%' }"
          @click="handleStepClick(index)"
        >
          <div class="step-dot">
            <svg v-if="step.completed" class="check-icon" viewBox="0 0 16 16" fill="none" stroke="currentColor">
              <path d="M3 8l3 3 7-7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="step-tooltip">{{ step.label }}</div>
        </div>
      </div>
    </div>
    <div class="wizard-body">
      <transition name="fade-scale" mode="out-in">
        <div :key="internalStep" class="step-content">
          <slot :current-step="currentStepData" :step-index="internalStep" :total-steps="steps.length"></slot>
        </div>
      </transition>
    </div>
    <div class="wizard-actions">
      <div class="actions-left">
        <button
          v-if="!isFirstStep"
          class="btn-back"
          @click="handlePrevious"
          :style="buttonStyles.back"
        >
          <svg class="btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <path d="M19 12H5M12 19l-7-7 7-7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          Back
        </button>
      </div>
      <div class="actions-right">
        <button
          v-if="!isLastStep"
          class="btn-continue"
          @click="handleNext"
          :style="buttonStyles.continue"
        >
          Continue
          <svg class="btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <path d="M5 12h14M12 5l7 7-7 7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </button>
        <button
          v-else
          class="btn-finish"
          @click="handleComplete"
          :style="buttonStyles.finish"
        >
          <svg class="btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <path d="M5 13l4 4L19 7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          Finish
        </button>
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
  variant: 'progress-bar',
  orientation: 'horizontal',
  theme: () => ({
    primaryColor: '#06b6d4',
    backgroundColor: '#ffffff',
    textColor: '#0f172a',
    activeColor: '#22d3ee',
    completedColor: '#14b8a6',
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
const progressWidth = computed(() => {
  return ((internalStep.value + 1) / props.steps.length) * 100
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
  back: {
    color: props.theme.textColor,
    borderColor: props.theme.borderColor
  },
  continue: {
    backgroundColor: props.theme.primaryColor,
    borderColor: props.theme.primaryColor
  },
  finish: {
    backgroundColor: props.theme.completedColor,
    borderColor: props.theme.completedColor
  }
}))
const progressStepClasses = (index: number) => ({
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
.wizard-progress-bar {
  display: flex;
  flex-direction: column;
  gap: 2rem;
  padding: 2rem;
  background: var(--background-color);
  border-radius: 16px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
  max-width: 100%;
}
.wizard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}
.header-content {
  flex: 1;
}
.wizard-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--text-color);
  margin: 0 0 0.5rem 0;
}
.wizard-subtitle {
  font-size: 0.875rem;
  color: #64748b;
  margin: 0;
}
.progress-indicator {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}
.progress-count {
  font-size: 1rem;
  font-weight: 700;
  color: var(--primary-color);
  background: rgba(6, 182, 212, 0.1);
  padding: 0.5rem 1rem;
  border-radius: 20px;
}
.main-progress-bar {
  position: relative;
  padding: 1rem 0;
}
.progress-track {
  height: 12px;
  background: #f1f5f9;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.06);
}
.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, var(--completed-color), var(--primary-color), var(--active-color));
  border-radius: 12px;
  transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}
.progress-shine {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
  animation: shine 2s infinite;
}
@keyframes shine {
  0% {
    transform: translateX(-100%);
  }
  100% {
    transform: translateX(100%);
  }
}
.progress-steps {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 100%;
  pointer-events: none;
}
.progress-step {
  position: absolute;
  top: 50%;
  transform: translate(-50%, -50%);
  pointer-events: all;
  transition: all 0.3s ease;
}
.step-clickable {
  cursor: pointer;
}
.step-clickable:hover .step-dot {
  transform: scale(1.2);
}
.step-dot {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: #cbd5e1;
  border: 3px solid var(--background-color);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
.step-completed .step-dot {
  background: var(--completed-color);
  box-shadow: 0 2px 6px rgba(20, 184, 166, 0.4);
}
.step-active .step-dot {
  background: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(6, 182, 212, 0.2), 0 2px 8px rgba(6, 182, 212, 0.4);
  animation: pulse-glow 2s ease-in-out infinite;
}
@keyframes pulse-glow {
  0%, 100% {
    box-shadow: 0 0 0 4px rgba(6, 182, 212, 0.2), 0 2px 8px rgba(6, 182, 212, 0.4);
  }
  50% {
    box-shadow: 0 0 0 6px rgba(6, 182, 212, 0.3), 0 2px 12px rgba(6, 182, 212, 0.6);
  }
}
.check-icon {
  width: 16px;
  height: 16px;
  stroke: white;
}
.step-tooltip {
  position: absolute;
  top: 100%;
  left: 50%;
  transform: translateX(-50%);
  margin-top: 0.75rem;
  padding: 0.375rem 0.75rem;
  background: var(--text-color);
  color: white;
  font-size: 0.75rem;
  font-weight: 500;
  white-space: nowrap;
  border-radius: 6px;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.2s ease;
}
.step-clickable:hover .step-tooltip,
.step-active .step-tooltip {
  opacity: 1;
}
.wizard-body {
  background: #f8fafc;
  border-radius: 12px;
  padding: 2rem;
  min-height: 250px;
  border: 1px solid var(--border-color);
}
.step-content {
  width: 100%;
}
.fade-scale-enter-active,
.fade-scale-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.fade-scale-enter-from {
  opacity: 0;
  transform: scale(0.95);
}
.fade-scale-leave-to {
  opacity: 0;
  transform: scale(1.05);
}
.wizard-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}
.actions-left,
.actions-right {
  display: flex;
  gap: 0.75rem;
}
.btn-back,
.btn-continue,
.btn-finish {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  border-radius: 10px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 2px solid;
  font-size: 0.9375rem;
}
.btn-icon {
  width: 18px;
  height: 18px;
}
.btn-back {
  background: transparent;
  color: var(--text-color);
  border-color: var(--border-color);
}
.btn-back:hover {
  background: #f8fafc;
  border-color: var(--text-color);
  transform: translateX(-2px);
}
.btn-continue {
  background: var(--primary-color);
  color: white;
  border-color: var(--primary-color);
}
.btn-continue:hover {
  background: var(--active-color);
  transform: translateX(2px);
  box-shadow: 0 4px 12px rgba(6, 182, 212, 0.3);
}
.btn-finish {
  background: var(--completed-color);
  color: white;
  border-color: var(--completed-color);
}
.btn-finish:hover {
  opacity: 0.9;
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(20, 184, 166, 0.3);
}
button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none !important;
}
</style>
