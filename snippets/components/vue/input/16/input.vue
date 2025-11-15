<template>
  <div class="speech-input-wrapper-16" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-16" :for="`input-16-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-16" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-16">{{ prefix }}</div>
      
      <input
        :id="`input-16-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter voice...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-16', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-16">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-16"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-16">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-16">
      <div v-if="error" class="error-message-16">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-16">{{ hint }}</div>
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
  if (props.type === 'speech') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(262, 62%, 52%)`,
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
.speech-input-wrapper-16 {
  width: 100%;
  margin-bottom: 1.4rem;
  font-family: Consolas, sans-serif;
}

.label-style-16 {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.7rem;
  font-size: 0.95rem;
  font-weight: 700;
  color: hsl(262, 52%, 27%);
  letter-spacing: 0.02em;
  text-transform: capitalize;
}

.required-indicator {
  color: hsl(66, 67%, 55%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 18px;
  height: 18px;
  background: hsl(262, 47%, 82%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-16 {
  position: relative;
  display: flex;
  align-items: center;
  background: #fafafa;
  border: 1px dashed hsl(262, 22%, 82%);
  border-radius: var(--border-radius);
  transition: all 0.3s cubic-bezier(0.2, 0, 0.4, 1);
  overflow: hidden;
}

.speech-input-wrapper-16.focused .input-control-16 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 3px hsla(262, 62%, 52%, 0.1);
  transform: scale(1.01);
}

.speech-input-wrapper-16.hasError .input-control-16 {
  border-color: hsl(20, 77%, 52%);
  background: hsla(20, 52%, 97%, 0.7);
}

.speech-input-wrapper-16.disabled .input-control-16 {
  background: hsl(262, 17%, 96%);
  border-style: dashed;
  opacity: 0.7;
  cursor: not-allowed;
}

.input-prefix-16,
.input-suffix-16 {
  padding: 0.8rem 1.05rem;
  background: hsl(262, 27%, 96%);
  color: hsl(262, 37%, 42%);
  font-weight: 600;
  font-size: 0.975rem;
  border-['left']: 1px solid hsl(262, 27%, 82%);
  display: flex;
  align-items: center;
}

.base-input-16 {
  flex: 1;
  min-width: 0;
  padding: 0.8500000000000001rem 1.25rem;
  font-size: 1.0rem;
  color: hsl(262, 32%, 27%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.6;
}

.base-input-16::placeholder {
  color: hsl(262, 27%, 57%);
  opacity: 0.7;
  font-style: normal;
}

.base-input-16:disabled {
  cursor: not-allowed;
  color: hsl(262, 27%, 52%);
}

.clear-btn-16 {
  position: absolute;
  right: 0.9rem;
  width: 26px;
  height: 26px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(262, 32%, 87%);
  color: hsl(262, 37%, 47%);
  border: none;
  border-radius: 4px;
  font-size: 1.4rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.2s;
  margin: 0 0.4rem;
}

.clear-btn-16:hover {
  background: hsl(164, 47%, 47%);
  color: white;
  transform: rotate(90deg);
}

.char-counter-16 {
  margin-top: 0.4rem;
  text-align: right;
  font-size: 0.8rem;
  color: hsl(262, 27%, 57%);
  font-weight: 500;
}

.error-message-16 {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.7rem;
  padding: 0.6rem 1.05rem;
  background: hsla(20, 62%, 97%, 0.8);
  color: hsl(20, 67%, 47%);
  border-left: 3px solid hsl(20, 77%, 57%);
  border-radius: 6px;
  font-size: 0.9rem;
  font-weight: 500;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-16 {
  margin-top: 0.5rem;
  font-size: 0.9rem;
  color: hsl(262, 30%, 54%);
  line-height: 1.5;
  font-style: normal;
}

.error-16-enter-active,
.error-16-leave-active {
  transition: all 0.3s cubic-bezier(0.2, 0, 0.4, 1);
}

.error-16-enter-from {
  opacity: 0;
  transform: translateX(-8px);
}

.error-16-leave-to {
  opacity: 0;
  transform: translateX(8px);
}
</style>