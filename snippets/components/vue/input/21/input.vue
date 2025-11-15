<template>
  <div class="number-input-wrapper-21" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-21" :for="`input-21-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-21" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-21">{{ prefix }}</div>
      
      <input
        :id="`input-21-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter percentage...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-21', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-21">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-21"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-21">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-21">
      <div v-if="error" class="error-message-21">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-21">{{ hint }}</div>
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
  if (props.type === 'number') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(158, 78%, 68%)`,
  '--border-radius': `10px`
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
.number-input-wrapper-21 {
  width: 100%;
  margin-bottom: 1.6rem;
  font-family: Consolas, sans-serif;
}

.label-style-21 {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-bottom: 0.7rem;
  font-size: 0.95rem;
  font-weight: 700;
  color: hsl(158, 48%, 43%);
  letter-spacing: 0.02em;
  text-transform: uppercase;
}

.required-indicator {
  color: hsl(114, 83%, 56%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 18px;
  height: 18px;
  background: hsl(158, 63%, 88%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-21 {
  position: relative;
  display: flex;
  align-items: baseline;
  background: #f5f5f5;
  border: 1px double hsl(158, 38%, 83%);
  border-radius: var(--border-radius);
  transition: all 0.4s cubic-bezier(0.3, 0, 0.1, 1);
  overflow: hidden;
}

.number-input-wrapper-21.focused .input-control-21 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 4px hsla(158, 78%, 68%, 0.1);
  transform: translateY(-2px) scale(1.005);
}

.number-input-wrapper-21.hasError .input-control-21 {
  border-color: hsl(10, 78%, 58%);
  background: hsla(10, 68%, 98%, 0.7);
}

.number-input-wrapper-21.disabled .input-control-21 {
  background: hsl(158, 18%, 97%);
  border-style: dashed;
  opacity: 0.8;
  cursor: not-allowed;
}

.input-prefix-21,
.input-suffix-21 {
  padding: 0.8rem 1.2rem;
  background: hsl(158, 43%, 96%);
  color: hsl(158, 53%, 58%);
  font-weight: 700;
  font-size: 0.975rem;
  border-['left']: 1px solid hsl(158, 28%, 88%);
  display: flex;
  align-items: center;
}

.base-input-21 {
  flex: 1;
  min-width: 0;
  padding: 0.9500000000000001rem 1.05rem;
  font-size: 1.05rem;
  color: hsl(158, 48%, 28%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.6;
}

.base-input-21::placeholder {
  color: hsl(158, 28%, 73%);
  opacity: 0.8;
  font-style: normal;
}

.base-input-21:disabled {
  cursor: not-allowed;
  color: hsl(158, 28%, 68%);
}

.clear-btn-21 {
  position: absolute;
  right: 0.9rem;
  width: 26px;
  height: 26px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(158, 48%, 93%);
  color: hsl(158, 53%, 63%);
  border: none;
  border-radius: 6px;
  font-size: 1.4rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.3s;
  margin: 0 0.5rem;
}

.clear-btn-21:hover {
  background: hsl(316, 63%, 48%);
  color: white;
  transform: scale(1.15) rotate(90deg);
}

.char-counter-21 {
  margin-top: 0.5rem;
  text-align: right;
  font-size: 0.85rem;
  color: hsl(158, 43%, 73%);
  font-weight: 600;
}

.error-message-21 {
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

.hint-message-21 {
  margin-top: 0.6rem;
  font-size: 0.9rem;
  color: hsl(158, 46%, 70%);
  line-height: 1.6;
  font-style: normal;
}

.error-21-enter-active,
.error-21-leave-active {
  transition: all 0.4s cubic-bezier(0.3, 0, 0.1, 1);
}

.error-21-enter-from {
  opacity: 0;
  transform: scale(0.9);
}

.error-21-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>