<template>
  <div class="preview-input-wrapper-13" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-13" :for="`input-13-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-13" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-13">{{ prefix }}</div>
      
      <input
        :id="`input-13-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter markdown...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-13', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-13">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-13"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-13">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-13">
      <div v-if="error" class="error-message-13">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-13">{{ hint }}</div>
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
  if (props.type === 'preview') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(13, 73%, 63%)`,
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
.preview-input-wrapper-13 {
  width: 100%;
  margin-bottom: 1.6rem;
  font-family: Georgia, sans-serif;
}

.label-style-13 {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.6rem;
  font-size: 0.9rem;
  font-weight: 600;
  color: hsl(13, 43%, 38%);
  letter-spacing: 0.01em;
  text-transform: capitalize;
}

.required-indicator {
  color: hsl(39, 78%, 61%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 17px;
  height: 17px;
  background: hsl(13, 58%, 83%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-13 {
  position: relative;
  display: flex;
  align-items: center;
  background: #fafafa;
  border: 2px dashed hsl(13, 33%, 88%);
  border-radius: var(--border-radius);
  transition: all 0.3s cubic-bezier(0.3, 0, 0.1, 1);
  overflow: hidden;
}

.preview-input-wrapper-13.focused .input-control-13 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 3px hsla(13, 73%, 63%, 0.2);
  transform: scale(1.01);
}

.preview-input-wrapper-13.hasError .input-control-13 {
  border-color: hsl(5, 83%, 53%);
  background: hsla(5, 63%, 98%, 0.6);
}

.preview-input-wrapper-13.disabled .input-control-13 {
  background: hsl(13, 23%, 97%);
  border-style: dotted;
  opacity: 0.7;
  cursor: not-allowed;
}

.input-prefix-13,
.input-suffix-13 {
  padding: 0.65rem 1.2rem;
  background: hsl(13, 38%, 95%);
  color: hsl(13, 48%, 53%);
  font-weight: 600;
  font-size: 0.925rem;
  border-['left']: 1px solid hsl(13, 33%, 83%);
  display: flex;
  align-items: center;
}

.base-input-13 {
  flex: 1;
  min-width: 0;
  padding: 0.9500000000000001rem 0.95rem;
  font-size: 1.05rem;
  color: hsl(13, 43%, 33%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.5;
}

.base-input-13::placeholder {
  color: hsl(13, 33%, 68%);
  opacity: 0.7;
  font-style: italic;
}

.base-input-13:disabled {
  cursor: not-allowed;
  color: hsl(13, 33%, 63%);
}

.clear-btn-13 {
  position: relative;
  right: 0.7rem;
  width: 25px;
  height: 25px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(13, 43%, 88%);
  color: hsl(13, 48%, 58%);
  border: none;
  border-radius: 4px;
  font-size: 1.3rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.2s;
  margin: 0 0.4rem;
}

.clear-btn-13:hover {
  background: hsl(26, 58%, 53%);
  color: white;
  transform: rotate(90deg);
}

.char-counter-13 {
  margin-top: 0.4rem;
  text-align: right;
  font-size: 0.8rem;
  color: hsl(13, 38%, 68%);
  font-weight: 500;
}

.error-message-13 {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.6rem;
  padding: 0.6rem 0.9rem;
  background: hsla(5, 73%, 98%, 0.8);
  color: hsl(5, 78%, 53%);
  border-left: 4px solid hsl(5, 83%, 63%);
  border-radius: 3px;
  font-size: 0.8500000000000001rem;
  font-weight: 600;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-13 {
  margin-top: 0.5rem;
  font-size: 0.8500000000000001rem;
  color: hsl(13, 41%, 65%);
  line-height: 1.5;
  font-style: italic;
}

.error-13-enter-active,
.error-13-leave-active {
  transition: all 0.3s cubic-bezier(0.3, 0, 0.1, 1);
}

.error-13-enter-from {
  opacity: 0;
  transform: translateX(-8px);
}

.error-13-leave-to {
  opacity: 0;
  transform: translateX(8px);
}
</style>