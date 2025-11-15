<template>
  <div class="calendar-input-wrapper-3" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-3" :for="`input-3-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-3" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-3">{{ prefix }}</div>
      
      <input
        :id="`input-3-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter daterange...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-3', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-3">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-3"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-3">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-3">
      <div v-if="error" class="error-message-3">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-3">{{ hint }}</div>
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
  if (props.type === 'calendar') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(157, 77%, 67%)`,
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
.calendar-input-wrapper-3 {
  width: 100%;
  margin-bottom: 1.4rem;
  font-family: Georgia, sans-serif;
}

.label-style-3 {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.6rem;
  font-size: 0.9rem;
  font-weight: 600;
  color: hsl(157, 42%, 42%);
  letter-spacing: 0.01em;
  text-transform: capitalize;
}

.required-indicator {
  color: hsl(111, 82%, 55%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 17px;
  height: 17px;
  background: hsl(157, 62%, 87%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-3 {
  position: relative;
  display: flex;
  align-items: center;
  background: #fafafa;
  border: 2px dashed hsl(157, 37%, 82%);
  border-radius: var(--border-radius);
  transition: all 0.3s cubic-bezier(0.2, 0, 0.4, 1);
  overflow: hidden;
}

.calendar-input-wrapper-3.focused .input-control-3 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 3px hsla(157, 77%, 67%, 0.2);
  transform: scale(1.01);
}

.calendar-input-wrapper-3.hasError .input-control-3 {
  border-color: hsl(5, 77%, 57%);
  background: hsla(5, 67%, 97%, 0.6);
}

.calendar-input-wrapper-3.disabled .input-control-3 {
  background: hsl(157, 17%, 96%);
  border-style: dotted;
  opacity: 0.7;
  cursor: not-allowed;
}

.input-prefix-3,
.input-suffix-3 {
  padding: 0.65rem 1.05rem;
  background: hsl(157, 42%, 95%);
  color: hsl(157, 52%, 57%);
  font-weight: 600;
  font-size: 0.925rem;
  border-['left']: 1px solid hsl(157, 27%, 87%);
  display: flex;
  align-items: center;
}

.base-input-3 {
  flex: 1;
  min-width: 0;
  padding: 0.8500000000000001rem 0.95rem;
  font-size: 1.0rem;
  color: hsl(157, 47%, 27%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.5;
}

.base-input-3::placeholder {
  color: hsl(157, 27%, 72%);
  opacity: 0.7;
  font-style: italic;
}

.base-input-3:disabled {
  cursor: not-allowed;
  color: hsl(157, 27%, 67%);
}

.clear-btn-3 {
  position: relative;
  right: 0.7rem;
  width: 25px;
  height: 25px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(157, 47%, 92%);
  color: hsl(157, 52%, 62%);
  border: none;
  border-radius: 4px;
  font-size: 1.3rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.2s;
  margin: 0 0.4rem;
}

.clear-btn-3:hover {
  background: hsl(314, 62%, 47%);
  color: white;
  transform: rotate(90deg);
}

.char-counter-3 {
  margin-top: 0.4rem;
  text-align: right;
  font-size: 0.8rem;
  color: hsl(157, 42%, 72%);
  font-weight: 500;
}

.error-message-3 {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.6rem;
  padding: 0.6rem 0.9rem;
  background: hsla(5, 77%, 97%, 0.8);
  color: hsl(5, 82%, 47%);
  border-left: 4px solid hsl(5, 77%, 57%);
  border-radius: 3px;
  font-size: 0.8500000000000001rem;
  font-weight: 600;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-3 {
  margin-top: 0.5rem;
  font-size: 0.8500000000000001rem;
  color: hsl(157, 45%, 69%);
  line-height: 1.5;
  font-style: italic;
}

.error-3-enter-active,
.error-3-leave-active {
  transition: all 0.3s cubic-bezier(0.2, 0, 0.4, 1);
}

.error-3-enter-from {
  opacity: 0;
  transform: translateX(-8px);
}

.error-3-leave-to {
  opacity: 0;
  transform: translateX(8px);
}
</style>