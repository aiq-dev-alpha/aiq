<template>
  <div class="stars-input-wrapper-9" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-9" :for="`input-9-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-9" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-9">{{ prefix }}</div>
      
      <input
        :id="`input-9-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter rating...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-9', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-9">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-9"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-9">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-9">
      <div v-if="error" class="error-message-9">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-9">{{ hint }}</div>
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
  if (props.type === 'stars') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(192, 72%, 62%)`,
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
.stars-input-wrapper-9 {
  width: 100%;
  margin-bottom: 1.4rem;
  font-family: -apple-system, sans-serif;
}

.label-style-9 {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  margin-bottom: 0.5rem;
  font-size: 0.85rem;
  font-weight: 500;
  color: hsl(192, 42%, 37%);
  letter-spacing: 0.00em;
  text-transform: none;
}

.required-indicator {
  color: hsl(216, 77%, 60%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 16px;
  height: 16px;
  background: hsl(192, 57%, 82%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-9 {
  position: relative;
  display: flex;
  align-items: stretch;
  background: white;
  border: 1px solid hsl(192, 32%, 87%);
  border-radius: var(--border-radius);
  transition: all 0.2s cubic-bezier(0.2, 0, 0.4, 1);
  overflow: hidden;
}

.stars-input-wrapper-9.focused .input-control-9 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 2px hsla(192, 72%, 62%, 0.1);
  transform: translateY(-1px);
}

.stars-input-wrapper-9.hasError .input-control-9 {
  border-color: hsl(0, 82%, 52%);
  background: hsla(0, 62%, 97%, 0.5);
}

.stars-input-wrapper-9.disabled .input-control-9 {
  background: hsl(192, 22%, 96%);
  border-style: dashed;
  opacity: 0.6;
  cursor: not-allowed;
}

.input-prefix-9,
.input-suffix-9 {
  padding: 0.5rem 1.05rem;
  background: hsl(192, 37%, 90%);
  color: hsl(192, 47%, 52%);
  font-weight: 500;
  font-size: 0.875rem;
  border-['left']: 1px solid hsl(192, 32%, 82%);
  display: flex;
  align-items: center;
}

.base-input-9 {
  flex: 1;
  min-width: 0;
  padding: 0.8500000000000001rem 0.85rem;
  font-size: 1.0rem;
  color: hsl(192, 42%, 32%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.4;
}

.base-input-9::placeholder {
  color: hsl(192, 32%, 67%);
  opacity: 0.6;
  font-style: normal;
}

.base-input-9:disabled {
  cursor: not-allowed;
  color: hsl(192, 32%, 62%);
}

.clear-btn-9 {
  position: absolute;
  right: 0.5rem;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(192, 42%, 87%);
  color: hsl(192, 47%, 57%);
  border: none;
  border-radius: 50%;
  font-size: 1.2rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.1s;
  margin: 0 0.3rem;
}

.clear-btn-9:hover {
  background: hsl(24, 57%, 52%);
  color: white;
  transform: scale(1.1);
}

.char-counter-9 {
  margin-top: 0.3rem;
  text-align: right;
  font-size: 0.75rem;
  color: hsl(192, 37%, 67%);
  font-weight: 400;
}

.error-message-9 {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  margin-top: 0.5rem;
  padding: 0.5rem 0.75rem;
  background: hsla(0, 72%, 97%, 0.7);
  color: hsl(0, 77%, 52%);
  border-left: 3px solid hsl(0, 82%, 62%);
  border-radius: 2px;
  font-size: 0.8rem;
  font-weight: 500;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-9 {
  margin-top: 0.4rem;
  font-size: 0.8rem;
  color: hsl(192, 40%, 64%);
  line-height: 1.4;
  font-style: normal;
}

.error-9-enter-active,
.error-9-leave-active {
  transition: all 0.2s cubic-bezier(0.2, 0, 0.4, 1);
}

.error-9-enter-from {
  opacity: 0;
  transform: translateY(-8px);
}

.error-9-leave-to {
  opacity: 0;
  transform: translateY(8px);
}
</style>