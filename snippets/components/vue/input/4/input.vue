<template>
  <div class="password-input-wrapper">
    <label v-if="label" class="input-label">{{ label }}</label>
    <div class="input-container">
      <input
        v-model="password"
        :type="showPassword ? 'text' : 'password'"
        class="password-input"
        :placeholder="placeholder"
        @input="checkStrength"
      />
      <button type="button" class="toggle-visibility" @click="showPassword = !showPassword">
        {{ showPassword ? '👁️' : '👁️‍🗨️' }}
      </button>
    </div>
    <div class="strength-meter">
      <div class="strength-bar" :class="strengthClass" :style="{ width: `${strengthPercent}%` }"></div>
    </div>
    <p class="strength-text" :class="strengthClass">{{ strengthText }}</p>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';

interface Props {
  label?: string;
  placeholder?: string;
  modelValue?: string;
}

const props = withDefaults(defineProps<Props>(), {
  placeholder: 'Enter password'
});

const emit = defineEmits<{
  'update:modelValue': [value: string];
}>();

const password = ref(props.modelValue || '');
const showPassword = ref(false);
const strength = ref(0);

const checkStrength = () => {
  let score = 0;
  if (password.value.length >= 8) score++;
  if (password.value.length >= 12) score++;
  if (/[a-z]/.test(password.value) && /[A-Z]/.test(password.value)) score++;
  if (/\d/.test(password.value)) score++;
  if (/[^a-zA-Z\d]/.test(password.value)) score++;
  
  strength.value = score;
  emit('update:modelValue', password.value);
};

const strengthPercent = computed(() => (strength.value / 5) * 100);

const strengthClass = computed(() => {
  if (strength.value <= 1) return 'weak';
  if (strength.value <= 3) return 'medium';
  return 'strong';
});

const strengthText = computed(() => {
  if (!password.value) return '';
  if (strength.value <= 1) return 'Weak password';
  if (strength.value <= 3) return 'Medium password';
  return 'Strong password';
});
</script>

<style scoped>
.password-input-wrapper {
  width: 100%;
}

.input-label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #374151;
}

.input-container {
  position: relative;
}

.password-input {
  width: 100%;
  padding: 0.875rem 3rem 0.875rem 1rem;
  font-size: 1rem;
  border: 2px solid #e5e7eb;
  border-radius: 8px;
  outline: none;
  transition: all 0.2s;
}

.password-input:focus {
  border-color: #3b82f6;
}

.toggle-visibility {
  position: absolute;
  right: 1rem;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1.25rem;
}

.strength-meter {
  height: 4px;
  background: #e5e7eb;
  border-radius: 2px;
  margin-top: 0.5rem;
  overflow: hidden;
}

.strength-bar {
  height: 100%;
  transition: all 0.3s ease;
  border-radius: 2px;
}

.strength-bar.weak {
  background: #ef4444;
}

.strength-bar.medium {
  background: #f59e0b;
}

.strength-bar.strong {
  background: #10b981;
}

.strength-text {
  margin-top: 0.25rem;
  font-size: 0.875rem;
  font-weight: 600;
}

.strength-text.weak {
  color: #ef4444;
}

.strength-text.medium {
  color: #f59e0b;
}

.strength-text.strong {
  color: #10b981;
}
</style>