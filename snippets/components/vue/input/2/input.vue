<template>
  <div class="input-wrapper" :class="{ 'has-error': error, 'is-disabled': disabled, 'is-focused': isFocused }">
    <label v-if="label" class="input-label" :class="{ 'required': required }">
      {{ label }}
    </label>
    <div class="input-container" :class="[`size-${size}`, `variant-${variant}`]">
      <span v-if="icon && iconPosition === 'left'" class="input-icon left">
        {{ icon }}
      </span>
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
        :class="{ 'has-icon-left': icon && iconPosition === 'left', 'has-icon-right': icon && iconPosition === 'right' || showClear }"
        :style="inputStyles"
      />
      <button
        v-if="showClear && modelValue && !disabled"
        @click="clearInput"
        class="clear-button"
        type="button"
      >
        ×
      </button>
      <span v-else-if="icon && iconPosition === 'right'" class="input-icon right">
        {{ icon }}
      </span>
    </div>
    <div v-if="error || helperText || showCounter" class="input-footer">
      <span v-if="error" class="error-message">{{ error }}</span>
      <span v-else-if="helperText" class="helper-text">{{ helperText }}</span>
      <span v-if="showCounter" class="character-counter">
        {{ characterCount }}/{{ maxLength }}
      </span>
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
    modelValue: {
      type: [String, Number],
      default: ''
    },
    type: {
      type: String,
      default: 'text'
    },
    label: {
      type: String,
      default: ''
    },
    placeholder: {
      type: String,
      default: ''
    },
    error: {
      type: String,
      default: ''
    },
    helperText: {
      type: String,
      default: ''
    },
    disabled: {
      type: Boolean,
      default: false
    },
    required: {
      type: Boolean,
      default: false
    },
    icon: {
      type: String,
      default: ''
    },
    iconPosition: {
      type: String as PropType<'left' | 'right'>,
      default: 'left'
    },
    variant: {
      type: String as PropType<'default' | 'filled' | 'outlined' | 'underlined' | 'floating'>,
      default: 'outlined'
    },
    size: {
      type: String as PropType<'sm' | 'md' | 'lg'>,
      default: 'md'
    },
    theme: {
      type: Object as PropType<Partial<InputTheme>>,
      default: () => ({})
    },
    showClear: {
      type: Boolean,
      default: false
    },
    showCounter: {
      type: Boolean,
      default: false
    },
    maxLength: {
      type: Number,
      default: 100
    }
  },
  emits: ['update:modelValue'],
  setup(props, { emit }) {
    const isFocused = ref(false);

    const defaultTheme: InputTheme = {
      primary: '#8b5cf6',
      background: '#ffffff',
      border: '#d1d5db',
      text: '#111827',
      error: '#f43f5e',
      success: '#22c55e'
    };

    const appliedTheme = { ...defaultTheme, ...props.theme };

    const handleInput = (event: Event) => {
      const target = event.target as HTMLInputElement;
      emit('update:modelValue', target.value);
    };

    const clearInput = () => {
      emit('update:modelValue', '');
    };

    const characterCount = computed(() => {
      return String(props.modelValue).length;
    });

    const inputStyles = computed(() => ({
      '--primary-color': appliedTheme.primary,
      '--bg-color': appliedTheme.background,
      '--border-color': appliedTheme.border,
      '--text-color': appliedTheme.text,
      '--error-color': appliedTheme.error,
      '--success-color': appliedTheme.success
    }));

    return {
      isFocused,
      handleInput,
      clearInput,
      characterCount,
      inputStyles
    };
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
  text-transform: uppercase;
  letter-spacing: 0.05em;
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
  border-radius: 0.75rem;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  outline: none;
}

.input-field:focus {
  border-color: var(--primary-color);
  box-shadow: 0 4px 12px rgba(139, 92, 246, 0.15);
  transform: translateY(-1px);
}

.input-field:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  background-color: #fafafa;
}

.has-error .input-field {
  border-color: var(--error-color);
  animation: shake 0.3s ease;
}

.has-error .input-field:focus {
  box-shadow: 0 4px 12px rgba(244, 63, 94, 0.15);
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  75% { transform: translateX(5px); }
}

/* Size variants */
.size-sm .input-field {
  padding: 0.5rem 0.875rem;
  font-size: 0.875rem;
}

.size-md .input-field {
  padding: 0.75rem 1.125rem;
  font-size: 1rem;
}

.size-lg .input-field {
  padding: 1rem 1.375rem;
  font-size: 1.125rem;
}

/* Style variants */
.variant-filled .input-field {
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  border: 2px solid transparent;
}

.variant-filled .input-field:focus {
  background-color: var(--bg-color);
  border-color: var(--primary-color);
}

.variant-outlined .input-field {
  background-color: transparent;
  border: 2px solid var(--border-color);
}

.variant-underlined .input-field {
  border: none;
  border-bottom: 2px solid var(--border-color);
  border-radius: 0;
  padding-left: 0;
  background: linear-gradient(to bottom, transparent 95%, var(--primary-color) 95%);
  background-size: 0 100%;
  background-repeat: no-repeat;
  transition: background-size 0.3s ease;
}

.variant-underlined .input-field:focus {
  background-size: 100% 100%;
  box-shadow: none;
  transform: none;
}

/* Icon styles */
.input-icon {
  position: absolute;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--primary-color);
  pointer-events: none;
  font-weight: 600;
}

.input-icon.left {
  left: 0.875rem;
}

.input-icon.right {
  right: 0.875rem;
}

.input-field.has-icon-left {
  padding-left: 2.75rem;
}

.input-field.has-icon-right {
  padding-right: 2.75rem;
}

.clear-button {
  position: absolute;
  right: 0.875rem;
  background: var(--primary-color);
  color: white;
  border: none;
  font-size: 1.25rem;
  cursor: pointer;
  padding: 0;
  width: 1.25rem;
  height: 1.25rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.2s;
}

.clear-button:hover {
  transform: scale(1.1);
  box-shadow: 0 2px 8px rgba(139, 92, 246, 0.3);
}

/* Footer */
.input-footer {
  display: flex;
  justify-content: space-between;
  margin-top: 0.375rem;
  font-size: 0.75rem;
}

.error-message {
  color: var(--error-color);
  font-weight: 500;
}

.helper-text {
  color: #6b7280;
}

.character-counter {
  color: #9ca3af;
  margin-left: auto;
  font-weight: 500;
}
</style>
