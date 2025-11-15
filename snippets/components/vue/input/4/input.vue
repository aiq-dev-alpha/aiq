<template>
  <div class="input-wrapper" :class="{ 'has-error': error, 'is-disabled': disabled }">
    <label v-if="label" class="input-label" :class="{ 'required': required }">{{ label }}</label>
    <div class="input-container" :class="[`size-${size}`, `variant-${variant}`]">
      <span v-if="icon && iconPosition === 'left'" class="input-icon left">{{ icon }}</span>
      <input
        :type="type"
        :value="modelValue"
        :placeholder="placeholder"
        :disabled="disabled"
        :required="required"
        @input="handleInput"
        @focus="isFocused = true"
        @blur="isFocused = false"
        class="input-field"
        :style="inputStyles"
      />
      <button v-if="showClear && modelValue && !disabled" @click="clearInput" class="clear-button" type="button">×</button>
      <span v-else-if="icon && iconPosition === 'right'" class="input-icon right">{{ icon }}</span>
      <div class="input-glow"></div>
    </div>
    <div v-if="error || helperText || showCounter" class="input-footer">
      <span v-if="error" class="error-message">{{ error }}</span>
      <span v-else-if="helperText" class="helper-text">{{ helperText }}</span>
      <span v-if="showCounter" class="character-counter">{{ characterCount }}/{{ maxLength }}</span>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed, ref, PropType } from 'vue';

interface InputTheme {
  primary: string;
  background: string;
  border: string;
  text: string;
  error: string;
  success: string;
}

export default defineComponent({
  name: 'Input',
  props: {
    modelValue: { type: [String, Number], default: '' },
    type: { type: String, default: 'text' },
    label: { type: String, default: '' },
    placeholder: { type: String, default: '' },
    error: { type: String, default: '' },
    helperText: { type: String, default: '' },
    disabled: { type: Boolean, default: false },
    required: { type: Boolean, default: false },
    icon: { type: String, default: '' },
    iconPosition: { type: String as PropType<'left' | 'right'>, default: 'left' },
    variant: { type: String as PropType<'default' | 'filled' | 'outlined' | 'underlined' | 'floating'>, default: 'default' },
    size: { type: String as PropType<'sm' | 'md' | 'lg'>, default: 'md' },
    theme: { type: Object as PropType<Partial<InputTheme>>, default: () => ({}) },
    showClear: { type: Boolean, default: false },
    showCounter: { type: Boolean, default: false },
    maxLength: { type: Number, default: 100 }
  },
  emits: ['update:modelValue'],
  setup(props, { emit }) {
    const isFocused = ref(false);

    const defaultTheme: InputTheme = {
      primary: '#ec4899',
      background: '#fdf2f8',
      border: '#f9a8d4',
      text: '#831843',
      error: '#be123c',
      success: '#15803d'
    };

    const appliedTheme = { ...defaultTheme, ...props.theme };

    const handleInput = (event: Event) => {
      emit('update:modelValue', (event.target as HTMLInputElement).value);
    };

    const clearInput = () => {
      emit('update:modelValue', '');
    };

    const characterCount = computed(() => String(props.modelValue).length);
    const inputStyles = computed(() => ({
      '--primary-color': appliedTheme.primary,
      '--bg-color': appliedTheme.background,
      '--border-color': appliedTheme.border,
      '--text-color': appliedTheme.text,
      '--error-color': appliedTheme.error,
      '--success-color': appliedTheme.success
    }));

    return { isFocused, handleInput, clearInput, characterCount, inputStyles };
  }
});
</script>

<style scoped>
.input-wrapper {
  width: 100%;
  margin-bottom: 1rem;
}

.input-label {
  display: block;
  margin-bottom: 0.5rem;
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--text-color);
}

.input-label.required::after {
  content: ' *';
  color: var(--error-color);
}

.input-container {
  position: relative;
  display: flex;
  align-items: center;
}

.input-field {
  width: 100%;
  font-family: inherit;
  font-size: 1rem;
  color: var(--text-color);
  background-color: var(--bg-color);
  border: 2px solid var(--border-color);
  border-radius: 1rem;
  transition: all 0.3s ease;
  outline: none;
  position: relative;
  z-index: 1;
}

.input-glow {
  position: absolute;
  inset: -2px;
  border-radius: 1rem;
  background: linear-gradient(45deg, var(--primary-color), var(--border-color), var(--primary-color));
  opacity: 0;
  transition: opacity 0.3s ease;
  z-index: 0;
  background-size: 200% 200%;
  animation: gradient-shift 3s ease infinite;
}

.input-field:focus ~ .input-glow {
  opacity: 0.5;
}

@keyframes gradient-shift {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.input-field:focus {
  border-color: var(--primary-color);
  transform: scale(1.01);
}

.has-error .input-field {
  border-color: var(--error-color);
}

.size-sm .input-field { padding: 0.5rem 1rem; font-size: 0.875rem; }
.size-md .input-field { padding: 0.75rem 1.25rem; font-size: 1rem; }
.size-lg .input-field { padding: 1rem 1.5rem; font-size: 1.125rem; }

.variant-filled .input-field {
  background: linear-gradient(135deg, #fce7f3 0%, #fbcfe8 100%);
  border-color: transparent;
}

.variant-outlined .input-field {
  background-color: transparent;
}

.variant-underlined .input-field {
  border: none;
  border-bottom: 2px solid var(--border-color);
  border-radius: 0;
  background-color: transparent;
}

.input-icon {
  position: absolute;
  color: var(--primary-color);
  pointer-events: none;
  z-index: 2;
}

.input-icon.left { left: 1rem; }
.input-icon.right { right: 1rem; }

.clear-button {
  position: absolute;
  right: 1rem;
  background: var(--primary-color);
  color: white;
  border: none;
  border-radius: 50%;
  width: 1.5rem;
  height: 1.5rem;
  cursor: pointer;
  z-index: 2;
  transition: transform 0.2s;
}

.clear-button:hover {
  transform: rotate(90deg) scale(1.1);
}

.input-footer {
  display: flex;
  justify-content: space-between;
  margin-top: 0.5rem;
  font-size: 0.75rem;
}

.error-message { color: var(--error-color); font-weight: 500; }
.helper-text { color: #9f1239; }
.character-counter { color: #be185d; margin-left: auto; }
</style>
