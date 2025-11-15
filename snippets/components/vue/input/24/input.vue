<template>
  <div class="address-input-wrapper-24" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-24" :for="`input-24-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-24" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-24">{{ prefix }}</div>
      
      <input
        :id="`input-24-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter location...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-24', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-24">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-24"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-24">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-24">
      <div v-if="error" class="error-message-24">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-24">{{ hint }}</div>
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
  if (props.type === 'address') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(109, 69%, 59%)`,
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
.address-input-wrapper-24 {
  width: 100%;
  margin-bottom: 1.8rem;
  font-family: Georgia, sans-serif;
}

.label-style-24 {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.6rem;
  font-size: 0.9rem;
  font-weight: 600;
  color: hsl(109, 59%, 34%);
  letter-spacing: 0.01em;
  text-transform: capitalize;
}

.required-indicator {
  color: hsl(327, 74%, 52%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 17px;
  height: 17px;
  background: hsl(109, 54%, 89%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-24 {
  position: relative;
  display: flex;
  align-items: center;
  background: #fafafa;
  border: 2px dashed hsl(109, 29%, 79%);
  border-radius: var(--border-radius);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.3, 1);
  overflow: hidden;
}

.address-input-wrapper-24.focused .input-control-24 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 3px hsla(109, 69%, 59%, 0.2);
  transform: scale(1.01);
}

.address-input-wrapper-24.hasError .input-control-24 {
  border-color: hsl(5, 74%, 59%);
  background: hsla(5, 59%, 99%, 0.6);
}

.address-input-wrapper-24.disabled .input-control-24 {
  background: hsl(109, 14%, 98%);
  border-style: dotted;
  opacity: 0.7;
  cursor: not-allowed;
}

.input-prefix-24,
.input-suffix-24 {
  padding: 0.65rem 1.35rem;
  background: hsl(109, 34%, 95%);
  color: hsl(109, 44%, 49%);
  font-weight: 600;
  font-size: 0.925rem;
  border-['left']: 1px solid hsl(109, 24%, 89%);
  display: flex;
  align-items: center;
}

.base-input-24 {
  flex: 1;
  min-width: 0;
  padding: 1.05rem 0.95rem;
  font-size: 1.1rem;
  color: hsl(109, 39%, 24%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.5;
}

.base-input-24::placeholder {
  color: hsl(109, 24%, 64%);
  opacity: 0.7;
  font-style: italic;
}

.base-input-24:disabled {
  cursor: not-allowed;
  color: hsl(109, 24%, 59%);
}

.clear-btn-24 {
  position: relative;
  right: 0.7rem;
  width: 25px;
  height: 25px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(109, 39%, 94%);
  color: hsl(109, 44%, 54%);
  border: none;
  border-radius: 4px;
  font-size: 1.3rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.2s;
  margin: 0 0.4rem;
}

.clear-btn-24:hover {
  background: hsl(218, 54%, 44%);
  color: white;
  transform: rotate(90deg);
}

.char-counter-24 {
  margin-top: 0.4rem;
  text-align: right;
  font-size: 0.8rem;
  color: hsl(109, 34%, 64%);
  font-weight: 500;
}

.error-message-24 {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.6rem;
  padding: 0.6rem 0.9rem;
  background: hsla(5, 69%, 99%, 0.8);
  color: hsl(5, 74%, 44%);
  border-left: 4px solid hsl(5, 74%, 54%);
  border-radius: 3px;
  font-size: 0.8500000000000001rem;
  font-weight: 600;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-24 {
  margin-top: 0.5rem;
  font-size: 0.8500000000000001rem;
  color: hsl(109, 37%, 61%);
  line-height: 1.5;
  font-style: italic;
}

.error-24-enter-active,
.error-24-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.3, 1);
}

.error-24-enter-from {
  opacity: 0;
  transform: translateX(-8px);
}

.error-24-leave-to {
  opacity: 0;
  transform: translateX(8px);
}
</style>