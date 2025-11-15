<template>
  <div class="wizard-numbered" :class="[orientationClass]" :style="containerStyles">
    <div class="wizard-steps">
      <div
        v-for="(step, index) in steps"
        :key="step.id"
        class="step-item"
        :class="stepClasses(index)"
        @click="handleStepClick(index)"
      >
        <div class="step-indicator">
          <div class="step-number">
            <svg v-if="step.completed" class="checkmark" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path d="M5 13l4 4L19 7" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span v-else>{{ index + 1 }}</span>
          </div>
          <div v-if="index < steps.length - 1" class="step-connector"></div>
        </div>
        <div class="step-content">
          <div class="step-label">{{ step.label }}</div>
          <div v-if="step.description" class="step-description">{{ step.description }}</div>
        </div>
      </div>
    </div>

    <div class="wizard-progress">
      <div class="progress-bar">
        <div class="progress-fill" :style="{ width: progressPercentage + '%' }"></div>
      </div>
      <div class="progress-text">{{ progressPercentage }}% Complete</div>
    </div>

    <div class="wizard-body">
      <slot :current-step="currentStepData"></slot>
    </div>

    <div class="wizard-actions">
      <button
        class="btn-secondary"
        @click="handlePrevious"
        :disabled="isFirstStep"
        :style="buttonStyles.secondary"
      >
        Previous
      </button>
      <button
        v-if="!isLastStep"
        class="btn-primary"
        @click="handleNext"
        :style="buttonStyles.primary"
      >
        Next
      </button>
      <button
        v-else
        class="btn-primary"
        @click="handleComplete"
        :style="buttonStyles.primary"
      >
        Finish
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
  variant: 'numbered',
  orientation: 'horizontal',
  theme: () => ({
    primaryColor: '#2563eb',
    backgroundColor: '#ffffff',
    textColor: '#1f2937',
    activeColor: '#3b82f6',
    completedColor: '#10b981',
    borderColor: '#e5e7eb'
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
  const completed = props.steps.filter(s => s.completed).length
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
  }
}))

const stepClasses = (index: number) => ({
  'step-completed': props.steps[index].completed,
  'step-active': index === internalStep.value,
  'step-pending': !props.steps[index].completed && index !== internalStep.value,
  'step-clickable': props.allowStepNavigation
})

const handleStepClick = (index: number) => {
  if (props.allowStepNavigation) {
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
.wizard-numbered {
  display: flex;
  flex-direction: column;
  gap: 2rem;
  padding: 2rem;
  background: var(--background-color);
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.wizard-steps {
  display: flex;
  gap: 1rem;
}

.orientation-vertical .wizard-steps {
  flex-direction: column;
}

.step-item {
  display: flex;
  align-items: flex-start;
  gap: 1rem;
  flex: 1;
  position: relative;
  transition: all 0.3s ease;
}

.orientation-vertical .step-item {
  flex-direction: row;
}

.step-clickable {
  cursor: pointer;
}

.step-clickable:hover .step-indicator {
  transform: scale(1.05);
}

.step-indicator {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  transition: transform 0.3s ease;
}

.orientation-vertical .step-indicator {
  flex-direction: row;
}

.step-number {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 1.125rem;
  background: #f3f4f6;
  color: #6b7280;
  border: 3px solid var(--border-color);
  transition: all 0.3s ease;
  flex-shrink: 0;
}

.step-completed .step-number {
  background: var(--completed-color);
  color: white;
  border-color: var(--completed-color);
}

.step-active .step-number {
  background: var(--active-color);
  color: white;
  border-color: var(--active-color);
  box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.2);
}

.checkmark {
  width: 24px;
  height: 24px;
}

.step-connector {
  flex: 1;
  height: 3px;
  background: var(--border-color);
  position: relative;
  top: 24px;
  transition: background 0.3s ease;
}

.orientation-vertical .step-connector {
  width: 3px;
  height: 40px;
  top: 0;
  left: 24px;
}

.step-completed .step-connector {
  background: var(--completed-color);
}

.step-content {
  flex: 1;
  min-width: 0;
}

.step-label {
  font-weight: 600;
  color: var(--text-color);
  margin-bottom: 0.25rem;
  transition: color 0.3s ease;
}

.step-active .step-label {
  color: var(--active-color);
}

.step-description {
  font-size: 0.875rem;
  color: #6b7280;
}

.wizard-progress {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.progress-bar {
  height: 8px;
  background: #f3f4f6;
  border-radius: 9999px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, var(--primary-color), var(--active-color));
  transition: width 0.5s ease;
  border-radius: 9999px;
}

.progress-text {
  font-size: 0.875rem;
  color: #6b7280;
  text-align: center;
  font-weight: 500;
}

.wizard-body {
  padding: 1.5rem;
  background: #f9fafb;
  border-radius: 8px;
  min-height: 200px;
}

.wizard-actions {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
}

.btn-primary,
.btn-secondary {
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 2px solid;
  font-size: 1rem;
}

.btn-primary {
  background: var(--primary-color);
  color: white;
  border-color: var(--primary-color);
}

.btn-primary:hover:not(:disabled) {
  opacity: 0.9;
  transform: translateY(-1px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.btn-secondary {
  background: white;
  color: var(--text-color);
  border-color: var(--border-color);
}

.btn-secondary:hover:not(:disabled) {
  background: #f9fafb;
  transform: translateY(-1px);
}

button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}


@keyframes enter {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}

@keyframes slideDown {
  from { transform: translateY(-10px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

@keyframes glow {
  0%, 100% { box-shadow: 0 0 5px currentColor; }
  50% { box-shadow: 0 0 20px currentColor; }
}
</style>
