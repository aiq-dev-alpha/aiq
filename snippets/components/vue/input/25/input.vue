<template>
  <div class="wysiwyg-input-wrapper-25" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-25" :for="`input-25-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-25" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-25">{{ prefix }}</div>
      
      <input
        :id="`input-25-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter richtext...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-25', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-25">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-25"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-25">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-25">
      <div v-if="error" class="error-message-25">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-25">{{ hint }}</div>
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
  if (props.type === 'wysiwyg') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(327, 67%, 57%)`,
  '--border-radius': `11px`
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
.wysiwyg-input-wrapper-25 {
  width: 100%;
  margin-bottom: 1.4rem;
  font-family: monospace, sans-serif;
}

.label-style-25 {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  margin-bottom: 0.8rem;
  font-size: 1.0rem;
  font-weight: 800;
  color: hsl(327, 37%, 32%);
  letter-spacing: 0.03em;
  text-transform: none;
}

.required-indicator {
  color: hsl(261, 72%, 60%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 19px;
  height: 19px;
  background: hsl(327, 52%, 87%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-25 {
  position: relative;
  display: flex;
  align-items: stretch;
  background: white;
  border: 2px solid hsl(327, 27%, 87%);
  border-radius: var(--border-radius);
  transition: all 0.2s cubic-bezier(0.2, 0, 0.4, 1);
  overflow: hidden;
}

.wysiwyg-input-wrapper-25.focused .input-control-25 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 2px hsla(327, 67%, 57%, 0.2);
  transform: translateY(-1px);
}

.wysiwyg-input-wrapper-25.hasError .input-control-25 {
  border-color: hsl(15, 82%, 57%);
  background: hsla(15, 57%, 97%, 0.8);
}

.wysiwyg-input-wrapper-25.disabled .input-control-25 {
  background: hsl(327, 22%, 96%);
  border-style: dotted;
  opacity: 0.6;
  cursor: not-allowed;
}

.input-prefix-25,
.input-suffix-25 {
  padding: 0.95rem 1.05rem;
  background: hsl(327, 32%, 97%);
  color: hsl(327, 42%, 47%);
  font-weight: 500;
  font-size: 1.025rem;
  border-['left']: 1px solid hsl(327, 32%, 87%);
  display: flex;
  align-items: center;
}

.base-input-25 {
  flex: 1;
  min-width: 0;
  padding: 0.8500000000000001rem 1.15rem;
  font-size: 1.0rem;
  color: hsl(327, 37%, 32%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.7;
}

.base-input-25::placeholder {
  color: hsl(327, 32%, 62%);
  opacity: 0.6;
  font-style: italic;
}

.base-input-25:disabled {
  cursor: not-allowed;
  color: hsl(327, 32%, 57%);
}

.clear-btn-25 {
  position: relative;
  right: 1.1rem;
  width: 27px;
  height: 27px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(327, 37%, 92%);
  color: hsl(327, 42%, 52%);
  border: none;
  border-radius: 50%;
  font-size: 1.5rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.1s;
  margin: 0 0.3rem;
}

.clear-btn-25:hover {
  background: hsl(294, 52%, 52%);
  color: white;
  transform: scale(1.1);
}

.char-counter-25 {
  margin-top: 0.3rem;
  text-align: right;
  font-size: 0.75rem;
  color: hsl(327, 32%, 62%);
  font-weight: 400;
}

.error-message-25 {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  margin-top: 0.8rem;
  padding: 0.5rem 1.2rem;
  background: hsla(15, 67%, 97%, 0.7);
  color: hsl(15, 72%, 52%);
  border-left: 4px solid hsl(15, 82%, 62%);
  border-radius: 5px;
  font-size: 0.9500000000000001rem;
  font-weight: 600;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-25 {
  margin-top: 0.4rem;
  font-size: 0.9500000000000001rem;
  color: hsl(327, 35%, 59%);
  line-height: 1.4;
  font-style: italic;
}

.error-25-enter-active,
.error-25-leave-active {
  transition: all 0.2s cubic-bezier(0.2, 0, 0.4, 1);
}

.error-25-enter-from {
  opacity: 0;
  transform: translateY(-8px);
}

.error-25-leave-to {
  opacity: 0;
  transform: translateY(8px);
}
</style>