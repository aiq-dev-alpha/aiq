<template>
  <div class="wizard-icons" :class="[orientationClass]" :style="containerStyles">
    <div class="wizard-header">
      <h2 class="wizard-title">Step {{ internalStep + 1 }} of {{ steps.length }}</h2>
      <div class="wizard-progress-ring">
        <svg class="progress-ring" viewBox="0 0 120 120">
          <circle
            class="progress-ring-bg"
            cx="60"
            cy="60"
            r="54"
            fill="none"
            stroke-width="8"
          />
          <circle
            class="progress-ring-fill"
            cx="60"
            cy="60"
            r="54"
            fill="none"
            stroke-width="8"
            :stroke-dasharray="circumference"
            :stroke-dashoffset="progressOffset"
          />
          <text x="60" y="60" text-anchor="middle" dy=".3em" class="progress-text">
            {{ progressPercentage }}%
          </text>
        </svg>
      </div>
    </div>
    <div class="wizard-steps">
      <div
        v-for="(step, index) in steps"
        :key="step.id"
        class="step-item"
        :class="stepClasses(index)"
        @click="handleStepClick(index)"
      >
        <div class="step-icon-wrapper">
          <div class="step-icon">
            <svg v-if="step.completed" class="icon-completed" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <circle cx="12" cy="12" r="10" stroke-width="2"/>
              <path d="M8 12l2.5 2.5L16 9" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <svg v-else-if="index === internalStep" class="icon-active" viewBox="0 0 24 24" fill="currentColor">
              <circle cx="12" cy="12" r="10"/>
              <circle cx="12" cy="12" r="4" fill="white"/>
            </svg>
            <svg v-else class="icon-pending" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <circle cx="12" cy="12" r="10" stroke-width="2"/>
            </svg>
          </div>
          <div v-if="index < steps.length - 1" class="step-line"></div>
        </div>
        <div class="step-info">
          <div class="step-number">Step {{ index + 1 }}</div>
          <div class="step-label">{{ step.label }}</div>
        </div>
      </div>
    </div>
    <div class="wizard-body">
      <div class="step-content-wrapper">
        <transition name="fade-slide" mode="out-in">
          <div :key="internalStep" class="step-content">
            <slot :current-step="currentStepData" :step-index="internalStep"></slot>
          </div>
        </transition>
      </div>
    </div>
    <div class="wizard-actions">
      <button
        class="btn-outlined"
        @click="handlePrevious"
        :disabled="isFirstStep"
        :style="buttonStyles.outlined"
      >
        <svg class="btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor">
          <path d="M15 18l-6-6 6-6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        Previous
      </button>
      <button
        v-if="!isLastStep"
        class="btn-filled"
        @click="handleNext"
        :style="buttonStyles.filled"
      >
        Next
        <svg class="btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor">
          <path d="M9 18l6-6-6-6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </button>
      <button
        v-else
        class="btn-filled"
        @click="handleComplete"
        :style="buttonStyles.filled"
      >
        Complete
        <svg class="btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor">
          <path d="M5 13l4 4L19 7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </button>
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
  variant: 'icons',
  orientation: 'horizontal',
  theme: () => ({
    primaryColor: '#8b5cf6',
    backgroundColor: '#faf5ff',
    textColor: '#1f2937',
    activeColor: '#a78bfa',
    completedColor: '#10b981',
    borderColor: '#e9d5ff'
  }),
  allowStepNavigation: false
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
const circumference = computed(() => 2 * Math.PI * 54)
const progressOffset = computed(() => {
  const progress = ((internalStep.value + 1) / props.steps.length) * 100
  return circumference.value - (progress / 100) * circumference.value
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
  filled: {
    backgroundColor: props.theme.primaryColor,
    borderColor: props.theme.primaryColor
  },
  outlined: {
    borderColor: props.theme.primaryColor,
    color: props.theme.primaryColor
  }
}))
const stepClasses = (index: number) => ({
  'step-completed': props.steps[index].completed,
  'step-active': index === internalStep.value,
  'step-pending': !props.steps[index].completed && index !== internalStep.value,
  'step-clickable': props.allowStepNavigation && (props.steps[index].completed || index < internalStep.value)
})
const handleStepClick = (index: number) => {
  const canNavigate = props.allowStepNavigation && (props.steps[index].completed || index < internalStep.value)
  if (canNavigate) {
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
.wizard-icons {
  display: flex;
  flex-direction: column;
  gap: 2rem;
  padding: 2.5rem;
  background: var(--background-color);
  border-radius: 16px;
  box-shadow: 0 4px 6px rgba(139, 92, 246, 0.1);
  border: 1px solid var(--border-color);
}
.wizard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}
.wizard-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--text-color);
  margin: 0;
}
.wizard-progress-ring {
  flex-shrink: 0;
}
.progress-ring {
  width: 100px;
  height: 100px;
  transform: rotate(-90deg);
}
.progress-ring-bg {
  stroke: var(--border-color);
}
.progress-ring-fill {
  stroke: var(--primary-color);
  transition: stroke-dashoffset 0.5s ease;
  stroke-linecap: round;
}
.progress-text {
  font-size: 1.5rem;
  font-weight: 700;
  fill: var(--primary-color);
}
.wizard-steps {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1rem;
}
.orientation-vertical .wizard-steps {
  flex-direction: column;
  gap: 1rem;
}
.step-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
  transition: all 0.3s ease;
}
.orientation-vertical .step-item {
  flex-direction: row;
  align-items: flex-start;
}
.step-clickable {
  cursor: pointer;
}
.step-clickable:hover .step-icon {
  transform: scale(1.1);
}
.step-icon-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  margin-bottom: 0.75rem;
}
.orientation-vertical .step-icon-wrapper {
  flex-direction: row;
  width: auto;
  margin-bottom: 0;
  margin-right: 1rem;
}
.step-icon {
  width: 56px;
  height: 56px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  flex-shrink: 0;
}
.icon-completed {
  width: 100%;
  height: 100%;
  stroke: var(--completed-color);
  filter: drop-shadow(0 2px 4px rgba(16, 185, 129, 0.3));
}
.icon-active {
  width: 100%;
  height: 100%;
  fill: var(--active-color);
  filter: drop-shadow(0 2px 8px rgba(167, 139, 250, 0.4));
  animation: pulse 2s ease-in-out infinite;
}
.icon-pending {
  width: 100%;
  height: 100%;
  stroke: #d1d5db;
}
@keyframes pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
}
.step-line {
  flex: 1;
  height: 2px;
  background: linear-gradient(90deg, var(--border-color) 0%, var(--border-color) 100%);
  margin-top: -28px;
  margin-left: 56px;
  transition: background 0.3s ease;
}
.orientation-vertical .step-line {
  width: 2px;
  height: 40px;
  margin-top: 0;
  margin-left: 28px;
}
.step-completed + .step-item .step-line,
.step-active .step-line {
  background: linear-gradient(90deg, var(--completed-color) 0%, var(--active-color) 100%);
}
.step-info {
  text-align: center;
  min-width: 0;
}
.orientation-vertical .step-info {
  text-align: left;
  flex: 1;
}
.step-number {
  font-size: 0.75rem;
  font-weight: 600;
  color: #9ca3af;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 0.25rem;
}
.step-active .step-number {
  color: var(--active-color);
}
.step-label {
  font-size: 0.875rem;
  font-weight: 600;
  color: #6b7280;
  line-height: 1.3;
}
.step-active .step-label {
  color: var(--text-color);
  font-size: 1rem;
}
.step-completed .step-label {
  color: var(--completed-color);
}
.wizard-body {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  min-height: 300px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  border: 1px solid var(--border-color);
}
.step-content-wrapper {
  position: relative;
}
.step-content {
  width: 100%;
}
.fade-slide-enter-active,
.fade-slide-leave-active {
  transition: all 0.3s ease;
}
.fade-slide-enter-from {
  opacity: 0;
  transform: translateX(20px);
}
.fade-slide-leave-to {
  opacity: 0;
  transform: translateX(-20px);
}
.wizard-actions {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
}
.btn-filled,
.btn-outlined {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.875rem 1.75rem;
  border-radius: 10px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 2px solid;
  font-size: 1rem;
}
.btn-icon {
  width: 20px;
  height: 20px;
}
.btn-filled {
  background: var(--primary-color);
  color: white;
  border-color: var(--primary-color);
}
.btn-filled:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(139, 92, 246, 0.3);
}
.btn-outlined {
  background: white;
  color: var(--primary-color);
  border-color: var(--primary-color);
}
.btn-outlined:hover:not(:disabled) {
  background: var(--background-color);
  transform: translateY(-2px);
}
button:disabled {
  opacity: 0.4;
  cursor: not-allowed;
  transform: none !important;
}
</style>
