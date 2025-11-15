<template>
  <div class="link-input-wrapper-18" :class="{ focused, hasError: !!error, disabled }">
    <label v-if="label" class="label-style-18" :for="`input-18-${_uid}`">
      {{ label }}
      <span v-if="required" class="required-indicator">*</span>
      <span v-if="hint && !error" class="hint-icon" :title="hint">?</span>
    </label>
    
    <div class="input-control-18" :style="inputWrapperStyle">
      <div v-if="prefix" class="input-prefix-18">{{ prefix }}</div>
      
      <input
        :id="`input-18-${_uid}`"
        ref="inputRef"
        v-model="internalValue"
        :type="computedType"
        :placeholder="placeholder || 'Enter url...'"
        :disabled="disabled"
        :required="required"
        :class="['base-input-18', inputClass]"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @keydown="handleKeydown"
      />
      
      <div v-if="suffix" class="input-suffix-18">{{ suffix }}</div>
      
      <button 
        v-if="clearable && internalValue && !disabled"
        type="button"
        class="clear-btn-18"
        @click="clearInput"
        tabindex="-1"
      >
        ×
      </button>
    </div>
    
    <div v-if="showCharCount" class="char-counter-18">
      {{ internalValue.length }} / {{ maxLength || '∞' }}
    </div>
    
    <transition name="error-18">
      <div v-if="error" class="error-message-18">
        <span class="error-icon">⚠</span>
        {{ error }}
      </div>
    </transition>
    
    <div v-if="hint && !error" class="hint-message-18">{{ hint }}</div>
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
  if (props.type === 'link') return 'text';
  return props.type;
});

const inputWrapperStyle = computed(() => ({
  '--focus-color': `hsl(254, 74%, 64%)`,
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
.link-input-wrapper-18 {
  width: 100%;
  margin-bottom: 1.8rem;
  font-family: Consolas, sans-serif;
}

.label-style-18 {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-bottom: 0.7rem;
  font-size: 0.95rem;
  font-weight: 700;
  color: hsl(254, 44%, 39%);
  letter-spacing: 0.02em;
  text-transform: uppercase;
}

.required-indicator {
  color: hsl(42, 79%, 62%);
  font-weight: 700;
  font-size: 1.1em;
}

.hint-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 18px;
  height: 18px;
  background: hsl(254, 59%, 84%);
  border-radius: 50%;
  font-size: 0.75em;
  cursor: help;
  font-style: normal;
}

.input-control-18 {
  position: relative;
  display: flex;
  align-items: baseline;
  background: #f5f5f5;
  border: 1px double hsl(254, 34%, 89%);
  border-radius: var(--border-radius);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.3, 1);
  overflow: hidden;
}

.link-input-wrapper-18.focused .input-control-18 {
  border-color: var(--focus-color);
  box-shadow: 0 0 0 4px hsla(254, 74%, 64%, 0.1);
  transform: translateY(-2px) scale(1.005);
}

.link-input-wrapper-18.hasError .input-control-18 {
  border-color: hsl(10, 84%, 54%);
  background: hsla(10, 64%, 99%, 0.7);
}

.link-input-wrapper-18.disabled .input-control-18 {
  background: hsl(254, 24%, 98%);
  border-style: dashed;
  opacity: 0.8;
  cursor: not-allowed;
}

.input-prefix-18,
.input-suffix-18 {
  padding: 0.8rem 1.35rem;
  background: hsl(254, 39%, 96%);
  color: hsl(254, 49%, 54%);
  font-weight: 700;
  font-size: 0.975rem;
  border-['left']: 1px solid hsl(254, 34%, 84%);
  display: flex;
  align-items: center;
}

.base-input-18 {
  flex: 1;
  min-width: 0;
  padding: 1.05rem 1.05rem;
  font-size: 1.1rem;
  color: hsl(254, 44%, 34%);
  background: transparent;
  border: none;
  outline: none;
  line-height: 1.6;
}

.base-input-18::placeholder {
  color: hsl(254, 34%, 69%);
  opacity: 0.8;
  font-style: normal;
}

.base-input-18:disabled {
  cursor: not-allowed;
  color: hsl(254, 34%, 64%);
}

.clear-btn-18 {
  position: absolute;
  right: 0.9rem;
  width: 26px;
  height: 26px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: hsl(254, 44%, 89%);
  color: hsl(254, 49%, 59%);
  border: none;
  border-radius: 6px;
  font-size: 1.4rem;
  line-height: 1;
  cursor: pointer;
  transition: all 0.3s;
  margin: 0 0.5rem;
}

.clear-btn-18:hover {
  background: hsl(148, 59%, 54%);
  color: white;
  transform: scale(1.15) rotate(90deg);
}

.char-counter-18 {
  margin-top: 0.5rem;
  text-align: right;
  font-size: 0.85rem;
  color: hsl(254, 39%, 69%);
  font-weight: 600;
}

.error-message-18 {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-top: 0.7rem;
  padding: 0.7rem 1.05rem;
  background: hsla(10, 74%, 99%, 0.9);
  color: hsl(10, 79%, 54%);
  border-left: 3px solid hsl(10, 84%, 64%);
  border-radius: 4px;
  font-size: 0.9rem;
  font-weight: 500;
}

.error-icon {
  font-size: 1.1em;
}

.hint-message-18 {
  margin-top: 0.6rem;
  font-size: 0.9rem;
  color: hsl(254, 42%, 66%);
  line-height: 1.6;
  font-style: normal;
}

.error-18-enter-active,
.error-18-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.3, 1);
}

.error-18-enter-from {
  opacity: 0;
  transform: scale(0.9);
}

.error-18-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>