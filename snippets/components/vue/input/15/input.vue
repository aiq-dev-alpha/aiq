<template>
  <div class="autocomplete-input-wrapper-15" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-15" :for="`input-15-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-15" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-15">{{ prefix }}</div>
      
      <input
        :id="`input-15-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter mention...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-15', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-15">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-15"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-15">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-15">
      <div v-if="error" class="error-message-15">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-15">{{ hint }}</div>
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
  if (props.type === 'autocomplete') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(213, 73%, 63%)`,
  '--border-radius': `9px`
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
.autocomplete-input-wrapper-15 {
  width: 100%;
  margin-bottom: 1.6rem;
  font-family: Georgia, sans-serif;
}

.label-style-15 {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  margin-bottom: 0.6rem;
  font-size: 0.9rem;
  font-weight: 600;
  color: hsl(213, 38%, 38%);
  letter-spacing: 0.01em;
  text-transform: none;
}

.required-indicator {
  color: hsl(279, 78%, 51%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 17px;
  height: 17px;
  background: hsl(213, 58%, 83%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-15 {
  position: relative;
  display: flex;
  align-items: stretch;
  background: white;
  border: 2px solid hsl(213, 33%, 78%);
  border-radius: var(--border-radius);
  transition: all 0.2s cubic-bezier(0.3, 0, 0.1, 1);
  overflow: hidden;
}

.autocomplete-input-wrapper-15.focused .input-control-15 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 2px hsla(213, 73%, 63%, 0.2);
  transform: translateY(-1px);
}

.autocomplete-input-wrapper-15.hasError .input-control-15 {
  border-color: hsl(15, 73%, 53%);
  background: hsla(15, 63%, 98%, 0.6);
}

.autocomplete-input-wrapper-15.disabled .input-control-15 {
  background: hsl(213, 13%, 97%);
  border-style: dotted;
  opacity: 0.6;
  cursor: not-allowed;
}

.input-prefix-15,
.input-suffix-15 {
  padding: 0.65rem 1.2rem;
  background: hsl(213, 38%, 95%);
  color: hsl(213, 48%, 53%);
  font-weight: 500;
  font-size: 0.925rem;
  border-['left']: 1px solid hsl(213, 23%, 83%);
  display: flex;
  align-items: center;
}

.base-input-15 {
  flex: 1;
  min-width: 0;
  padding: 0.9500000000000001rem 1.15rem;
  font-size: 1.05rem;
  color: hsl(213, 43%, 23%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.5;
}

.base-input-15::placeholder {
  color: hsl(213, 23%, 68%);
  opacity: 0.6;
  font-style: italic;
}

.base-input-15:disabled {
  cursor: not-allowed;
  color: hsl(213, 23%, 63%);
}

.clear-btn-15 {
  position: relative;
  right: 0.7rem;
  width: 25px;
  height: 25px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(213, 43%, 88%);
  color: hsl(213, 48%, 58%);
  border: none;
  border-radius: 50%;
  font-size: 1.3rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.1s;
  margin: 0 0.3rem;
}

.clear-btn-15:hover {
  background: hsl(66, 58%, 43%);
  color: white;
  transform: scale(1.1);
}

.char-counter-15 {
  margin-top: 0.3rem;
  text-align: right;
  font-size: 0.75rem;
  color: hsl(213, 38%, 68%);
  font-weight: 400;
}

.error-message-15 {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  margin-top: 0.6rem;
  padding: 0.5rem 0.9rem;
  background: hsla(15, 73%, 98%, 0.7);
  color: hsl(15, 78%, 43%);
  border-left: 4px solid hsl(15, 73%, 53%);
  border-radius: 5px;
  font-size: 0.8500000000000001rem;
  font-weight: 600;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-15 {
  margin-top: 0.4rem;
  font-size: 0.8500000000000001rem;
  color: hsl(213, 41%, 65%);
  line-height: 1.4;
  font-style: italic;
}

.error-15-enter-active,
.error-15-leave-active {
  transition: all 0.2s cubic-bezier(0.3, 0, 0.1, 1);
}

.error-15-enter-from {
  opacity: 0;
  transform: translateY(-8px);
}

.error-15-leave-to {
  opacity: 0;
  transform: translateY(8px);
}
</style>