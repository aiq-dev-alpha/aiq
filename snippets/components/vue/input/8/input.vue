<template>
  <div class="palette-input-wrapper-8" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-8" :for="`input-8-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-8" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-8">{{ prefix }}</div>
      
      <input
        :id="`input-8-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter colorpicker...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-8', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-8">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-8"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-8">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-8">
      <div v-if="error" class="error-message-8">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-8">{{ hint }}</div>
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
  if (props.type === 'palette') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(144, 64%, 54%)`,
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
.palette-input-wrapper-8 {
  width: 100%;
  margin-bottom: 1.8rem;
  font-family: -apple-system, sans-serif;
}

.label-style-8 {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  margin-bottom: 0.5rem;
  font-size: 0.85rem;
  font-weight: 500;
  color: hsl(144, 39%, 29%);
  letter-spacing: 0.00em;
  text-transform: none;
}

.required-indicator {
  color: hsl(72, 69%, 57%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 16px;
  height: 16px;
  background: hsl(144, 49%, 84%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-8 {
  position: relative;
  display: flex;
  align-items: stretch;
  background: white;
  border: 1px solid hsl(144, 24%, 84%);
  border-radius: var(--border-radius);
  transition: all 0.2s cubic-bezier(0.4, 0, 0.3, 1);
  overflow: hidden;
}

.palette-input-wrapper-8.focused .input-control-8 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 2px hsla(144, 64%, 54%, 0.1);
  transform: translateY(-1px);
}

.palette-input-wrapper-8.hasError .input-control-8 {
  border-color: hsl(0, 79%, 54%);
  background: hsla(0, 54%, 99%, 0.5);
}

.palette-input-wrapper-8.disabled .input-control-8 {
  background: hsl(144, 19%, 98%);
  border-style: dashed;
  opacity: 0.6;
  cursor: not-allowed;
}

.input-prefix-8,
.input-suffix-8 {
  padding: 0.5rem 1.35rem;
  background: hsl(144, 29%, 90%);
  color: hsl(144, 39%, 44%);
  font-weight: 500;
  font-size: 0.875rem;
  border-['left']: 1px solid hsl(144, 29%, 84%);
  display: flex;
  align-items: center;
}

.base-input-8 {
  flex: 1;
  min-width: 0;
  padding: 1.05rem 0.85rem;
  font-size: 1.1rem;
  color: hsl(144, 34%, 29%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.4;
}

.base-input-8::placeholder {
  color: hsl(144, 29%, 59%);
  opacity: 0.6;
  font-style: normal;
}

.base-input-8:disabled {
  cursor: not-allowed;
  color: hsl(144, 29%, 54%);
}

.clear-btn-8 {
  position: absolute;
  right: 0.5rem;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(144, 34%, 89%);
  color: hsl(144, 39%, 49%);
  border: none;
  border-radius: 50%;
  font-size: 1.2rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.1s;
  margin: 0 0.3rem;
}

.clear-btn-8:hover {
  background: hsl(288, 49%, 49%);
  color: white;
  transform: scale(1.1);
}

.char-counter-8 {
  margin-top: 0.3rem;
  text-align: right;
  font-size: 0.75rem;
  color: hsl(144, 29%, 59%);
  font-weight: 400;
}

.error-message-8 {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  margin-top: 0.5rem;
  padding: 0.5rem 0.75rem;
  background: hsla(0, 64%, 99%, 0.7);
  color: hsl(0, 69%, 49%);
  border-left: 3px solid hsl(0, 79%, 59%);
  border-radius: 2px;
  font-size: 0.8rem;
  font-weight: 500;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-8 {
  margin-top: 0.4rem;
  font-size: 0.8rem;
  color: hsl(144, 32%, 56%);
  line-height: 1.4;
  font-style: normal;
}

.error-8-enter-active,
.error-8-leave-active {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.3, 1);
}

.error-8-enter-from {
  opacity: 0;
  transform: translateY(-8px);
}

.error-8-leave-to {
  opacity: 0;
  transform: translateY(8px);
}
</style>