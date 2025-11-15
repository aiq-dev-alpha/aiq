<template>
  <div class="range-input-wrapper-17" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-17" :for="`input-17-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-17" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-17">{{ prefix }}</div>
      
      <input
        :id="`input-17-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter slider...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-17', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-17">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-17"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-17">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-17">
      <div v-if="error" class="error-message-17">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-17">{{ hint }}</div>
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
  if (props.type === 'range') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(188, 68%, 58%)`,
  '--border-radius': `8px`
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
.range-input-wrapper-17 {
  width: 100%;
  margin-bottom: 1.6rem;
  font-family: -apple-system, sans-serif;
}

.label-style-17 {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-bottom: 0.5rem;
  font-size: 0.85rem;
  font-weight: 500;
  color: hsl(188, 38%, 33%);
  letter-spacing: 0.00em;
  text-transform: uppercase;
}

.required-indicator {
  color: hsl(204, 73%, 56%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 16px;
  height: 16px;
  background: hsl(188, 53%, 88%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-17 {
  position: relative;
  display: flex;
  align-items: baseline;
  background: #f5f5f5;
  border: 1px double hsl(188, 28%, 83%);
  border-radius: var(--border-radius);
  transition: all 0.4s cubic-bezier(0.3, 0, 0.1, 1);
  overflow: hidden;
}

.range-input-wrapper-17.focused .input-control-17 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 4px hsla(188, 68%, 58%, 0.1);
  transform: translateY(-2px) scale(1.005);
}

.range-input-wrapper-17.hasError .input-control-17 {
  border-color: hsl(10, 78%, 58%);
  background: hsla(10, 58%, 98%, 0.5);
}

.range-input-wrapper-17.disabled .input-control-17 {
  background: hsl(188, 18%, 97%);
  border-style: dashed;
  opacity: 0.8;
  cursor: not-allowed;
}

.input-prefix-17,
.input-suffix-17 {
  padding: 0.5rem 1.2rem;
  background: hsl(188, 33%, 94%);
  color: hsl(188, 43%, 48%);
  font-weight: 700;
  font-size: 0.875rem;
  border-['left']: 1px solid hsl(188, 28%, 88%);
  display: flex;
  align-items: center;
}

.base-input-17 {
  flex: 1;
  min-width: 0;
  padding: 0.9500000000000001rem 1.05rem;
  font-size: 1.05rem;
  color: hsl(188, 38%, 28%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.4;
}

.base-input-17::placeholder {
  color: hsl(188, 28%, 63%);
  opacity: 0.8;
  font-style: normal;
}

.base-input-17:disabled {
  cursor: not-allowed;
  color: hsl(188, 28%, 58%);
}

.clear-btn-17 {
  position: absolute;
  right: 0.5rem;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(188, 38%, 93%);
  color: hsl(188, 43%, 53%);
  border: none;
  border-radius: 6px;
  font-size: 1.2rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.3s;
  margin: 0 0.5rem;
}

.clear-btn-17:hover {
  background: hsl(16, 53%, 48%);
  color: white;
  transform: scale(1.15) rotate(90deg);
}

.char-counter-17 {
  margin-top: 0.5rem;
  text-align: right;
  font-size: 0.85rem;
  color: hsl(188, 33%, 63%);
  font-weight: 600;
}

.error-message-17 {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-top: 0.5rem;
  padding: 0.7rem 0.75rem;
  background: hsla(10, 68%, 98%, 0.9);
  color: hsl(10, 73%, 48%);
  border-left: 3px solid hsl(10, 78%, 58%);
  border-radius: 4px;
  font-size: 0.8rem;
  font-weight: 500;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-17 {
  margin-top: 0.6rem;
  font-size: 0.8rem;
  color: hsl(188, 36%, 60%);
  line-height: 1.6;
  font-style: normal;
}

.error-17-enter-active,
.error-17-leave-active {
  transition: all 0.4s cubic-bezier(0.3, 0, 0.1, 1);
}

.error-17-enter-from {
  opacity: 0;
  transform: scale(0.9);
}

.error-17-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>