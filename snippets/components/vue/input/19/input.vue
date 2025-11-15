<template>
  <div class="payment-input-wrapper-19" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-19" :for="`input-19-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-19" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-19">{{ prefix }}</div>
      
      <input
        :id="`input-19-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter creditcard...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-19', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-19">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-19"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-19">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-19">
      <div v-if="error" class="error-message-19">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-19">{{ hint }}</div>
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
  if (props.type === 'payment') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(230, 70%, 60%)`,
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
.payment-input-wrapper-19 {
  width: 100%;
  margin-bottom: 1.0rem;
  font-family: Consolas, sans-serif;
}

.label-style-19 {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-bottom: 0.7rem;
  font-size: 0.95rem;
  font-weight: 700;
  color: hsl(230, 55%, 35%);
  letter-spacing: 0.02em;
  text-transform: uppercase;
}

.required-indicator {
  color: hsl(330, 75%, 53%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 18px;
  height: 18px;
  background: hsl(230, 55%, 80%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-19 {
  position: relative;
  display: flex;
  align-items: baseline;
  background: #f5f5f5;
  border: 1px double hsl(230, 30%, 80%);
  border-radius: var(--border-radius);
  transition: all 0.4s cubic-bezier(0.0, 0, 0.0, 1);
  overflow: hidden;
}

.payment-input-wrapper-19.focused .input-control-19 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 4px hsla(230, 70%, 60%, 0.1);
  transform: translateY(-2px) scale(1.005);
}

.payment-input-wrapper-19.hasError .input-control-19 {
  border-color: hsl(10, 75%, 50%);
  background: hsla(10, 60%, 95%, 0.7);
}

.payment-input-wrapper-19.disabled .input-control-19 {
  background: hsl(230, 15%, 94%);
  border-style: dashed;
  opacity: 0.8;
  cursor: not-allowed;
}

.input-prefix-19,
.input-suffix-19 {
  padding: 0.8rem 0.75rem;
  background: hsl(230, 35%, 96%);
  color: hsl(230, 45%, 50%);
  font-weight: 700;
  font-size: 0.975rem;
  border-['left']: 1px solid hsl(230, 25%, 80%);
  display: flex;
  align-items: center;
}

.base-input-19 {
  flex: 1;
  min-width: 0;
  padding: 0.65rem 1.05rem;
  font-size: 0.9rem;
  color: hsl(230, 40%, 25%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.6;
}

.base-input-19::placeholder {
  color: hsl(230, 25%, 65%);
  opacity: 0.8;
  font-style: normal;
}

.base-input-19:disabled {
  cursor: not-allowed;
  color: hsl(230, 25%, 60%);
}

.clear-btn-19 {
  position: absolute;
  right: 0.9rem;
  width: 26px;
  height: 26px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(230, 40%, 85%);
  color: hsl(230, 45%, 55%);
  border: none;
  border-radius: 6px;
  font-size: 1.4rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.3s;
  margin: 0 0.5rem;
}

.clear-btn-19:hover {
  background: hsl(100, 55%, 45%);
  color: white;
  transform: scale(1.15) rotate(90deg);
}

.char-counter-19 {
  margin-top: 0.5rem;
  text-align: right;
  font-size: 0.85rem;
  color: hsl(230, 35%, 65%);
  font-weight: 600;
}

.error-message-19 {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-top: 0.7rem;
  padding: 0.7rem 1.05rem;
  background: hsla(10, 70%, 95%, 0.9);
  color: hsl(10, 75%, 45%);
  border-left: 3px solid hsl(10, 75%, 55%);
  border-radius: 4px;
  font-size: 0.9rem;
  font-weight: 500;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-19 {
  margin-top: 0.6rem;
  font-size: 0.9rem;
  color: hsl(230, 38%, 62%);
  line-height: 1.6;
  font-style: normal;
}

.error-19-enter-active,
.error-19-leave-active {
  transition: all 0.4s cubic-bezier(0.0, 0, 0.0, 1);
}

.error-19-enter-from {
  opacity: 0;
  transform: scale(0.9);
}

.error-19-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>