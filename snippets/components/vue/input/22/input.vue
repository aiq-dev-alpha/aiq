<template>
  <div class="code-input-wrapper-22" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-22" :for="`input-22-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-22" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-22">{{ prefix }}</div>
      
      <input
        :id="`input-22-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter otp...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-22', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-22">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-22"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-22">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-22">
      <div v-if="error" class="error-message-22">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-22">{{ hint }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue';

interface Props {
  label?: string;
  modelValue?: string | number;
  type?: string;
  placeholder?: string;
  disabled?: boolean;
  required?: boolean;
  error?: string;
  hint?: string;
  prefix?: string;
  suffix?: string;
  clearable?: boolean;
  showCharCount?: boolean;
  maxLength?: number;
  inputClass?: string;
}

const props = withDefaults(defineProps<Props>(), {
  type: 'text',
  disabled: false,
  required: false,
  clearable: true,
  showCharCount: false
});

const emit = defineEmits<{
  'update:modelValue': [value: string | number];
  focus: [];
  blur: [];
  keydown: [e: KeyboardEvent];
}>();

const inputRef = ref<HTMLInputElement>();
const internalValue = ref(String(props.modelValue || ''));
const focused = ref(false);
const _uid = ref(Math.random().toString(36).substr(2, 9));

watch(() => props.modelValue, (newVal) => {
  internalValue.value = String(newVal || '');
});

const computedType = computed(() => {
  if (props.type === 'code') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(155, 75%, 65%)`,
  '--border-radius': `7px`
}));

const handleInput = () => {
  emit('update:modelValue', internalValue.value);
};

const handleFocus = () => {
  focused.value = true;
  emit('focus');
};

const handleBlur = () => {
  focused.value = false;
  emit('blur');
};

const handleKeydown = (e: KeyboardEvent) => {
  emit('keydown', e);
};

const clearInput = () => {
  internalValue.value = '';
  emit('update:modelValue', '');
  inputRef.value?.focus();
};

defineExpose({
  focus: () => inputRef.value?.focus(),
  blur: () => inputRef.value?.blur()
});
</script>

<style scoped>
.code-input-wrapper-22 {
  width: 100%;
  margin-bottom: 1.0rem;
  font-family: monospace, sans-serif;
}

.label-style-22 {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-bottom: 0.8rem;
  font-size: 1.0rem;
  font-weight: 800;
  color: hsl(155, 50%, 40%);
  letter-spacing: 0.03em;
  text-transform: uppercase;
}

.required-indicator {
  color: hsl(105, 80%, 53%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 19px;
  height: 19px;
  background: hsl(155, 60%, 85%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-22 {
  position: relative;
  display: flex;
  align-items: baseline;
  background: #f5f5f5;
  border: 2px double hsl(155, 35%, 80%);
  border-radius: var(--border-radius);
  transition: all 0.4s cubic-bezier(0.0, 0, 0.0, 1);
  overflow: hidden;
}

.code-input-wrapper-22.focused .input-control-22 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 4px hsla(155, 75%, 65%, 0.2);
  transform: translateY(-2px) scale(1.005);
}

.code-input-wrapper-22.hasError .input-control-22 {
  border-color: hsl(25, 75%, 55%);
  background: hsla(25, 65%, 95%, 0.8);
}

.code-input-wrapper-22.disabled .input-control-22 {
  background: hsl(155, 15%, 94%);
  border-style: dotted;
  opacity: 0.8;
  cursor: not-allowed;
}

.input-prefix-22,
.input-suffix-22 {
  padding: 0.95rem 0.75rem;
  background: hsl(155, 40%, 93%);
  color: hsl(155, 50%, 55%);
  font-weight: 700;
  font-size: 1.025rem;
  border-['left']: 1px solid hsl(155, 25%, 85%);
  display: flex;
  align-items: center;
}

.base-input-22 {
  flex: 1;
  min-width: 0;
  padding: 0.65rem 1.35rem;
  font-size: 0.9rem;
  color: hsl(155, 45%, 25%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.7;
}

.base-input-22::placeholder {
  color: hsl(155, 25%, 70%);
  opacity: 0.8;
  font-style: italic;
}

.base-input-22:disabled {
  cursor: not-allowed;
  color: hsl(155, 25%, 65%);
}

.clear-btn-22 {
  position: relative;
  right: 1.1rem;
  width: 23px;
  height: 23px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(155, 45%, 90%);
  color: hsl(155, 50%, 60%);
  border: none;
  border-radius: 6px;
  font-size: 1.5rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.3s;
  margin: 0 0.5rem;
}

.clear-btn-22:hover {
  background: hsl(310, 60%, 45%);
  color: white;
  transform: scale(1.15) rotate(90deg);
}

.char-counter-22 {
  margin-top: 0.5rem;
  text-align: right;
  font-size: 0.85rem;
  color: hsl(155, 40%, 70%);
  font-weight: 600;
}

.error-message-22 {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-top: 0.8rem;
  padding: 0.7rem 1.2rem;
  background: hsla(25, 75%, 95%, 0.9);
  color: hsl(25, 80%, 45%);
  border-left: 4px solid hsl(25, 75%, 55%);
  border-radius: 7px;
  font-size: 0.9500000000000001rem;
  font-weight: 600;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-22 {
  margin-top: 0.6rem;
  font-size: 0.9500000000000001rem;
  color: hsl(155, 43%, 67%);
  line-height: 1.6;
  font-style: italic;
}

.error-22-enter-active,
.error-22-leave-active {
  transition: all 0.4s cubic-bezier(0.0, 0, 0.0, 1);
}

.error-22-enter-from {
  opacity: 0;
  transform: scale(0.9);
}

.error-22-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>