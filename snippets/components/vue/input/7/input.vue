<template>
  <div class="chips-input-wrapper-7" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-7" :for="`input-7-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-7" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-7">{{ prefix }}</div>
      
      <input
        :id="`input-7-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter tags...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-7', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-7">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-7"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-7">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-7">
      <div v-if="error" class="error-message-7">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-7">{{ hint }}</div>
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
  if (props.type === 'chips') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(98, 78%, 68%)`,
  '--border-radius': `6px`
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
.chips-input-wrapper-7 {
  width: 100%;
  margin-bottom: 1.6rem;
  font-family: Consolas, sans-serif;
}

.label-style-7 {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-bottom: 0.7rem;
  font-size: 0.95rem;
  font-weight: 700;
  color: hsl(98, 38%, 43%);
  letter-spacing: 0.02em;
  text-transform: uppercase;
}

.required-indicator {
  color: hsl(294, 83%, 56%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 18px;
  height: 18px;
  background: hsl(98, 63%, 88%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-7 {
  position: relative;
  display: flex;
  align-items: baseline;
  background: #f5f5f5;
  border: 1px double hsl(98, 38%, 83%);
  border-radius: var(--border-radius);
  transition: all 0.4s cubic-bezier(0.3, 0, 0.1, 1);
  overflow: hidden;
}

.chips-input-wrapper-7.focused .input-control-7 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 4px hsla(98, 78%, 68%, 0.1);
  transform: translateY(-2px) scale(1.005);
}

.chips-input-wrapper-7.hasError .input-control-7 {
  border-color: hsl(10, 78%, 58%);
  background: hsla(10, 68%, 98%, 0.7);
}

.chips-input-wrapper-7.disabled .input-control-7 {
  background: hsl(98, 18%, 97%);
  border-style: dashed;
  opacity: 0.8;
  cursor: not-allowed;
}

.input-prefix-7,
.input-suffix-7 {
  padding: 0.8rem 1.2rem;
  background: hsl(98, 43%, 92%);
  color: hsl(98, 53%, 58%);
  font-weight: 700;
  font-size: 0.975rem;
  border-['left']: 1px solid hsl(98, 28%, 88%);
  display: flex;
  align-items: center;
}

.base-input-7 {
  flex: 1;
  min-width: 0;
  padding: 0.9500000000000001rem 1.05rem;
  font-size: 1.05rem;
  color: hsl(98, 48%, 28%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.6;
}

.base-input-7::placeholder {
  color: hsl(98, 28%, 73%);
  opacity: 0.8;
  font-style: normal;
}

.base-input-7:disabled {
  cursor: not-allowed;
  color: hsl(98, 28%, 68%);
}

.clear-btn-7 {
  position: absolute;
  right: 0.9rem;
  width: 22px;
  height: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(98, 48%, 93%);
  color: hsl(98, 53%, 63%);
  border: none;
  border-radius: 6px;
  font-size: 1.4rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.3s;
  margin: 0 0.5rem;
}

.clear-btn-7:hover {
  background: hsl(196, 63%, 48%);
  color: white;
  transform: scale(1.15) rotate(90deg);
}

.char-counter-7 {
  margin-top: 0.5rem;
  text-align: right;
  font-size: 0.85rem;
  color: hsl(98, 43%, 73%);
  font-weight: 600;
}

.error-message-7 {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-top: 0.7rem;
  padding: 0.7rem 1.05rem;
  background: hsla(10, 78%, 98%, 0.9);
  color: hsl(10, 83%, 48%);
  border-left: 3px solid hsl(10, 78%, 58%);
  border-radius: 4px;
  font-size: 0.9rem;
  font-weight: 500;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-7 {
  margin-top: 0.6rem;
  font-size: 0.9rem;
  color: hsl(98, 46%, 70%);
  line-height: 1.6;
  font-style: normal;
}

.error-7-enter-active,
.error-7-leave-active {
  transition: all 0.4s cubic-bezier(0.3, 0, 0.1, 1);
}

.error-7-enter-from {
  opacity: 0;
  transform: scale(0.9);
}

.error-7-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>