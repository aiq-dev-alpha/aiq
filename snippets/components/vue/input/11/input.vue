<template>
  <div class="upload-input-wrapper-11" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-11" :for="`input-11-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-11" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-11">{{ prefix }}</div>
      
      <input
        :id="`input-11-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter filedrop...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-11', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-11">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-11"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-11">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-11">
      <div v-if="error" class="error-message-11">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-11">{{ hint }}</div>
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
  if (props.type === 'upload') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(187, 67%, 57%)`,
  '--border-radius': `7px`
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
.upload-input-wrapper-11 {
  width: 100%;
  margin-bottom: 1.4rem;
  font-family: monospace, sans-serif;
}

.label-style-11 {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.8rem;
  font-size: 1.0rem;
  font-weight: 800;
  color: hsl(187, 42%, 32%);
  letter-spacing: 0.03em;
  text-transform: capitalize;
}

.required-indicator {
  color: hsl(201, 72%, 55%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 19px;
  height: 19px;
  background: hsl(187, 52%, 87%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-11 {
  position: relative;
  display: flex;
  align-items: center;
  background: #fafafa;
  border: 2px dashed hsl(187, 27%, 82%);
  border-radius: var(--border-radius);
  transition: all 0.3s cubic-bezier(0.2, 0, 0.4, 1);
  overflow: hidden;
}

.upload-input-wrapper-11.focused .input-control-11 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 3px hsla(187, 67%, 57%, 0.2);
  transform: scale(1.01);
}

.upload-input-wrapper-11.hasError .input-control-11 {
  border-color: hsl(5, 77%, 57%);
  background: hsla(5, 57%, 97%, 0.8);
}

.upload-input-wrapper-11.disabled .input-control-11 {
  background: hsl(187, 17%, 96%);
  border-style: dotted;
  opacity: 0.7;
  cursor: not-allowed;
}

.input-prefix-11,
.input-suffix-11 {
  padding: 0.95rem 1.05rem;
  background: hsl(187, 32%, 93%);
  color: hsl(187, 42%, 47%);
  font-weight: 600;
  font-size: 1.025rem;
  border-['left']: 1px solid hsl(187, 27%, 87%);
  display: flex;
  align-items: center;
}

.base-input-11 {
  flex: 1;
  min-width: 0;
  padding: 0.8500000000000001rem 0.95rem;
  font-size: 1.0rem;
  color: hsl(187, 37%, 27%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.7;
}

.base-input-11::placeholder {
  color: hsl(187, 27%, 62%);
  opacity: 0.7;
  font-style: italic;
}

.base-input-11:disabled {
  cursor: not-allowed;
  color: hsl(187, 27%, 57%);
}

.clear-btn-11 {
  position: relative;
  right: 1.1rem;
  width: 23px;
  height: 23px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(187, 37%, 92%);
  color: hsl(187, 42%, 52%);
  border: none;
  border-radius: 4px;
  font-size: 1.5rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.2s;
  margin: 0 0.4rem;
}

.clear-btn-11:hover {
  background: hsl(14, 52%, 47%);
  color: white;
  transform: rotate(90deg);
}

.char-counter-11 {
  margin-top: 0.4rem;
  text-align: right;
  font-size: 0.8rem;
  color: hsl(187, 32%, 62%);
  font-weight: 500;
}

.error-message-11 {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.8rem;
  padding: 0.6rem 1.2rem;
  background: hsla(5, 67%, 97%, 0.8);
  color: hsl(5, 72%, 47%);
  border-left: 4px solid hsl(5, 77%, 57%);
  border-radius: 3px;
  font-size: 0.9500000000000001rem;
  font-weight: 600;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-11 {
  margin-top: 0.5rem;
  font-size: 0.9500000000000001rem;
  color: hsl(187, 35%, 59%);
  line-height: 1.5;
  font-style: italic;
}

.error-11-enter-active,
.error-11-leave-active {
  transition: all 0.3s cubic-bezier(0.2, 0, 0.4, 1);
}

.error-11-enter-from {
  opacity: 0;
  transform: translateX(-8px);
}

.error-11-leave-to {
  opacity: 0;
  transform: translateX(8px);
}
</style>