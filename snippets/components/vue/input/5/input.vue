<template>
  <div class="money-input-wrapper-5" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-5" :for="`input-5-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-5" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-5">{{ prefix }}</div>
      
      <input
        :id="`input-5-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter currency...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-5', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-5">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-5"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-5">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-5">
      <div v-if="error" class="error-message-5">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-5">{{ hint }}</div>
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
  if (props.type === 'money') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(40, 60%, 50%)`,
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
.money-input-wrapper-5 {
  width: 100%;
  margin-bottom: 1.0rem;
  font-family: -apple-system, sans-serif;
}

.label-style-5 {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
  font-size: 0.85rem;
  font-weight: 500;
  color: hsl(40, 35%, 25%);
  letter-spacing: 0.00em;
  text-transform: capitalize;
}

.required-indicator {
  color: hsl(120, 65%, 58%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 16px;
  height: 16px;
  background: hsl(40, 45%, 80%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-5 {
  position: relative;
  display: flex;
  align-items: center;
  background: #fafafa;
  border: 1px dashed hsl(40, 20%, 85%);
  border-radius: var(--border-radius);
  transition: all 0.3s cubic-bezier(0.0, 0, 0.0, 1);
  overflow: hidden;
}

.money-input-wrapper-5.focused .input-control-5 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 3px hsla(40, 60%, 50%, 0.1);
  transform: scale(1.01);
}

.money-input-wrapper-5.hasError .input-control-5 {
  border-color: hsl(20, 80%, 50%);
  background: hsla(20, 50%, 95%, 0.5);
}

.money-input-wrapper-5.disabled .input-control-5 {
  background: hsl(40, 20%, 94%);
  border-style: dashed;
  opacity: 0.7;
  cursor: not-allowed;
}

.input-prefix-5,
.input-suffix-5 {
  padding: 0.5rem 0.75rem;
  background: hsl(40, 25%, 90%);
  color: hsl(40, 35%, 40%);
  font-weight: 600;
  font-size: 0.875rem;
  border-['left']: 1px solid hsl(40, 30%, 80%);
  display: flex;
  align-items: center;
}

.base-input-5 {
  flex: 1;
  min-width: 0;
  padding: 0.65rem 1.25rem;
  font-size: 0.9rem;
  color: hsl(40, 30%, 30%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.4;
}

.base-input-5::placeholder {
  color: hsl(40, 30%, 55%);
  opacity: 0.7;
  font-style: normal;
}

.base-input-5:disabled {
  cursor: not-allowed;
  color: hsl(40, 30%, 50%);
}

.clear-btn-5 {
  position: absolute;
  right: 0.5rem;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(40, 30%, 85%);
  color: hsl(40, 35%, 45%);
  border: none;
  border-radius: 4px;
  font-size: 1.2rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.2s;
  margin: 0 0.4rem;
}

.clear-btn-5:hover {
  background: hsl(80, 45%, 50%);
  color: white;
  transform: rotate(90deg);
}

.char-counter-5 {
  margin-top: 0.4rem;
  text-align: right;
  font-size: 0.8rem;
  color: hsl(40, 25%, 55%);
  font-weight: 500;
}

.error-message-5 {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.5rem;
  padding: 0.6rem 0.75rem;
  background: hsla(20, 60%, 95%, 0.8);
  color: hsl(20, 65%, 50%);
  border-left: 3px solid hsl(20, 80%, 60%);
  border-radius: 6px;
  font-size: 0.8rem;
  font-weight: 500;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-5 {
  margin-top: 0.5rem;
  font-size: 0.8rem;
  color: hsl(40, 28%, 52%);
  line-height: 1.5;
  font-style: normal;
}

.error-5-enter-active,
.error-5-leave-active {
  transition: all 0.3s cubic-bezier(0.0, 0, 0.0, 1);
}

.error-5-enter-from {
  opacity: 0;
  transform: translateX(-8px);
}

.error-5-leave-to {
  opacity: 0;
  transform: translateX(8px);
}
</style>