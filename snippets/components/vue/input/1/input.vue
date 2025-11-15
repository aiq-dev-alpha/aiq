<template>
  <div class="input-wrapper" :class="{ 'has-error': error, 'is-disabled': disabled }">
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
      default: 'default'
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
      primary: '#6366f1',
      background: '#ffffff',
      border: '#e5e7eb',
      text: '#1f2937',
      error: '#ef4444',
      success: '#10b981'
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
  font-weight: 500;
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
  border-radius: 0.5rem;
  transition: all 0.2s ease;
  outline: none;
}

.input-field:focus {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
}

.input-field:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  background-color: #f9fafb;
}

.has-error .input-field {
  border-color: var(--error-color);
}

.has-error .input-field:focus {
  box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
}

/* Size variants */
.size-sm .input-field {
  padding: 0.5rem 0.75rem;
  font-size: 0.875rem;
}

.size-md .input-field {
  padding: 0.75rem 1rem;
  font-size: 1rem;
}

.size-lg .input-field {
  padding: 1rem 1.25rem;
  font-size: 1.125rem;
}

/* Style variants */
.variant-filled .input-field {
  background-color: #f3f4f6;
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
}

.variant-underlined .input-field:focus {
  box-shadow: none;
}

/* Icon styles */
.input-icon {
  position: absolute;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #9ca3af;
  pointer-events: none;
}

.input-icon.left {
  left: 0.75rem;
}

.input-icon.right {
  right: 0.75rem;
}

.input-field.has-icon-left {
  padding-left: 2.5rem;
}

.input-field.has-icon-right {
  padding-right: 2.5rem;
}

.clear-button {
  position: absolute;
  right: 0.75rem;
  background: none;
  border: none;
  font-size: 1.5rem;
  color: #9ca3af;
  cursor: pointer;
  padding: 0;
  width: 1.5rem;
  height: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: color 0.2s;
}

.clear-button:hover {
  color: var(--text-color);
}

/* Footer */
.input-footer {
  display: flex;
  justify-content: space-between;
  margin-top: 0.25rem;
  font-size: 0.75rem;
}

.error-message {
  color: var(--error-color);
}

.helper-text {
  color: #6b7280;
}

.character-counter {
  color: #9ca3af;
  margin-left: auto;
}
</style>
