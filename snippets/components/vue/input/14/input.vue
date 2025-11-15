<template>
  <div class="emoticons-input-wrapper-14" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-14" :for="`input-14-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-14" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-14">{{ prefix }}</div>
      
      <input
        :id="`input-14-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter emojipicker...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-14', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-14">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-14"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-14">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-14">
      <div v-if="error" class="error-message-14">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-14">{{ hint }}</div>
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
  if (props.type === 'emoticons') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(65, 65%, 55%)`,
  '--border-radius': `5px`
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
.emoticons-input-wrapper-14 {
  width: 100%;
  margin-bottom: 1.0rem;
  font-family: Georgia, sans-serif;
}

.label-style-14 {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-bottom: 0.6rem;
  font-size: 0.9rem;
  font-weight: 600;
  color: hsl(65, 35%, 30%);
  letter-spacing: 0.01em;
  text-transform: uppercase;
}

.required-indicator {
  color: hsl(195, 70%, 53%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 17px;
  height: 17px;
  background: hsl(65, 50%, 85%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-14 {
  position: relative;
  display: flex;
  align-items: baseline;
  background: #f5f5f5;
  border: 2px double hsl(65, 25%, 80%);
  border-radius: var(--border-radius);
  transition: all 0.4s cubic-bezier(0.0, 0, 0.0, 1);
  overflow: hidden;
}

.emoticons-input-wrapper-14.focused .input-control-14 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 4px hsla(65, 65%, 55%, 0.2);
  transform: translateY(-2px) scale(1.005);
}

.emoticons-input-wrapper-14.hasError .input-control-14 {
  border-color: hsl(25, 75%, 55%);
  background: hsla(25, 55%, 95%, 0.6);
}

.emoticons-input-wrapper-14.disabled .input-control-14 {
  background: hsl(65, 15%, 94%);
  border-style: dotted;
  opacity: 0.8;
  cursor: not-allowed;
}

.input-prefix-14,
.input-suffix-14 {
  padding: 0.65rem 0.75rem;
  background: hsl(65, 30%, 91%);
  color: hsl(65, 40%, 45%);
  font-weight: 700;
  font-size: 0.925rem;
  border-['left']: 1px solid hsl(65, 25%, 85%);
  display: flex;
  align-items: center;
}

.base-input-14 {
  flex: 1;
  min-width: 0;
  padding: 0.65rem 1.35rem;
  font-size: 0.9rem;
  color: hsl(65, 35%, 25%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.5;
}

.base-input-14::placeholder {
  color: hsl(65, 25%, 60%);
  opacity: 0.8;
  font-style: italic;
}

.base-input-14:disabled {
  cursor: not-allowed;
  color: hsl(65, 25%, 55%);
}

.clear-btn-14 {
  position: relative;
  right: 0.7rem;
  width: 21px;
  height: 21px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(65, 35%, 90%);
  color: hsl(65, 40%, 50%);
  border: none;
  border-radius: 6px;
  font-size: 1.3rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.3s;
  margin: 0 0.5rem;
}

.clear-btn-14:hover {
  background: hsl(130, 50%, 45%);
  color: white;
  transform: scale(1.15) rotate(90deg);
}

.char-counter-14 {
  margin-top: 0.5rem;
  text-align: right;
  font-size: 0.85rem;
  color: hsl(65, 30%, 60%);
  font-weight: 600;
}

.error-message-14 {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-top: 0.6rem;
  padding: 0.7rem 0.9rem;
  background: hsla(25, 65%, 95%, 0.9);
  color: hsl(25, 70%, 45%);
  border-left: 4px solid hsl(25, 75%, 55%);
  border-radius: 7px;
  font-size: 0.8500000000000001rem;
  font-weight: 600;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-14 {
  margin-top: 0.6rem;
  font-size: 0.8500000000000001rem;
  color: hsl(65, 33%, 57%);
  line-height: 1.6;
  font-style: italic;
}

.error-14-enter-active,
.error-14-leave-active {
  transition: all 0.4s cubic-bezier(0.0, 0, 0.0, 1);
}

.error-14-enter-from {
  opacity: 0;
  transform: scale(0.9);
}

.error-14-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>