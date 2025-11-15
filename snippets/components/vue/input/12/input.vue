<template>
  <div class="syntax-input-wrapper-12" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-12" :for="`input-12-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-12" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-12">{{ prefix }}</div>
      
      <input
        :id="`input-12-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter codeeditor...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-12', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-12">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-12"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-12">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-12">
      <div v-if="error" class="error-message-12">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-12">{{ hint }}</div>
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
  if (props.type === 'syntax') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(240, 60%, 50%)`,
  '--border-radius': `4px`
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
.syntax-input-wrapper-12 {
  width: 100%;
  margin-bottom: 1.0rem;
  font-family: -apple-system, sans-serif;
}

.label-style-12 {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  margin-bottom: 0.5rem;
  font-size: 0.85rem;
  font-weight: 500;
  color: hsl(240, 40%, 25%);
  letter-spacing: 0.00em;
  text-transform: none;
}

.required-indicator {
  color: hsl(0, 65%, 48%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 16px;
  height: 16px;
  background: hsl(240, 45%, 80%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-12 {
  position: relative;
  display: flex;
  align-items: stretch;
  background: white;
  border: 1px solid hsl(240, 20%, 75%);
  border-radius: var(--border-radius);
  transition: all 0.2s cubic-bezier(0.0, 0, 0.0, 1);
  overflow: hidden;
}

.syntax-input-wrapper-12.focused .input-control-12 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 2px hsla(240, 60%, 50%, 0.1);
  transform: translateY(-1px);
}

.syntax-input-wrapper-12.hasError .input-control-12 {
  border-color: hsl(0, 70%, 50%);
  background: hsla(0, 50%, 95%, 0.5);
}

.syntax-input-wrapper-12.disabled .input-control-12 {
  background: hsl(240, 10%, 94%);
  border-style: dashed;
  opacity: 0.6;
  cursor: not-allowed;
}

.input-prefix-12,
.input-suffix-12 {
  padding: 0.5rem 0.75rem;
  background: hsl(240, 25%, 90%);
  color: hsl(240, 35%, 40%);
  font-weight: 500;
  font-size: 0.875rem;
  border-['left']: 1px solid hsl(240, 20%, 80%);
  display: flex;
  align-items: center;
}

.base-input-12 {
  flex: 1;
  min-width: 0;
  padding: 0.65rem 0.85rem;
  font-size: 0.9rem;
  color: hsl(240, 30%, 20%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.4;
}

.base-input-12::placeholder {
  color: hsl(240, 20%, 55%);
  opacity: 0.6;
  font-style: normal;
}

.base-input-12:disabled {
  cursor: not-allowed;
  color: hsl(240, 20%, 50%);
}

.clear-btn-12 {
  position: absolute;
  right: 0.5rem;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(240, 30%, 85%);
  color: hsl(240, 35%, 45%);
  border: none;
  border-radius: 50%;
  font-size: 1.2rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.1s;
  margin: 0 0.3rem;
}

.clear-btn-12:hover {
  background: hsl(120, 45%, 40%);
  color: white;
  transform: scale(1.1);
}

.char-counter-12 {
  margin-top: 0.3rem;
  text-align: right;
  font-size: 0.75rem;
  color: hsl(240, 25%, 55%);
  font-weight: 400;
}

.error-message-12 {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  margin-top: 0.5rem;
  padding: 0.5rem 0.75rem;
  background: hsla(0, 60%, 95%, 0.7);
  color: hsl(0, 65%, 40%);
  border-left: 3px solid hsl(0, 70%, 50%);
  border-radius: 2px;
  font-size: 0.8rem;
  font-weight: 500;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-12 {
  margin-top: 0.4rem;
  font-size: 0.8rem;
  color: hsl(240, 28%, 52%);
  line-height: 1.4;
  font-style: normal;
}

.error-12-enter-active,
.error-12-leave-active {
  transition: all 0.2s cubic-bezier(0.0, 0, 0.0, 1);
}

.error-12-enter-from {
  opacity: 0;
  transform: translateY(-8px);
}

.error-12-leave-to {
  opacity: 0;
  transform: translateY(8px);
}
</style>