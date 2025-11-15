<template>
  <div class="input-wrapper" :class="{ 'has-error': error, 'is-disabled': disabled }">
    <label v-if="label" class="input-label" :class="{ 'required': required }">{{ label }}</label>
    <div class="input-container" :class="[`size-${size}`, `variant-${variant}`]">
      <span v-if="icon && iconPosition === 'left'" class="input-icon left">{{ icon }}</span>
      <input :type="type" :value="modelValue" :placeholder="placeholder" :disabled="disabled" :required="required" @input="handleInput" @focus="isFocused = true" @blur="isFocused = false" class="input-field" :style="inputStyles" />
      <button v-if="showClear && modelValue && !disabled" @click="clearInput" class="clear-button" type="button">×</button>
      <span v-else-if="icon && iconPosition === 'right'" class="input-icon right">{{ icon }}</span>
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

interface InputTheme { primary: string; background: string; border: string; text: string; error: string; success: string; }

export default defineComponent({
  name: 'Input',
  props: {
    modelValue: { type: [String, Number], default: '' }, type: { type: String, default: 'text' }, label: { type: String, default: '' }, placeholder: { type: String, default: '' }, error: { type: String, default: '' }, helperText: { type: String, default: '' }, disabled: { type: Boolean, default: false }, required: { type: Boolean, default: false }, icon: { type: String, default: '' }, iconPosition: { type: String as PropType<'left' | 'right'>, default: 'left' }, variant: { type: String as PropType<'default' | 'filled' | 'outlined' | 'underlined' | 'floating'>, default: 'filled' }, size: { type: String as PropType<'sm' | 'md' | 'lg'>, default: 'md' }, theme: { type: Object as PropType<Partial<InputTheme>>, default: () => ({}) }, showClear: { type: Boolean, default: false }, showCounter: { type: Boolean, default: false }, maxLength: { type: Number, default: 100 }
  },
  emits: ['update:modelValue'],
  setup(props, { emit }) {
    const isFocused = ref(false);
    const defaultTheme: InputTheme = { primary: '#ef4444', background: '#fef2f2', border: '#fca5a5', text: '#7f1d1d', error: '#dc2626', success: '#16a34a' };
    const appliedTheme = { ...defaultTheme, ...props.theme };
    const handleInput = (event: Event) => { emit('update:modelValue', (event.target as HTMLInputElement).value); };
    const clearInput = () => { emit('update:modelValue', ''); };
    const characterCount = computed(() => String(props.modelValue).length);
    const inputStyles = computed(() => ({ '--primary-color': appliedTheme.primary, '--bg-color': appliedTheme.background, '--border-color': appliedTheme.border, '--text-color': appliedTheme.text, '--error-color': appliedTheme.error, '--success-color': appliedTheme.success }));
    return { isFocused, handleInput, clearInput, characterCount, inputStyles };
  }
});
</script>

<style scoped>
.input-wrapper { width: 100%; margin-bottom: 1.25rem; }
.input-label { display: block; margin-bottom: 0.5rem; font-size: 0.875rem; font-weight: 600; color: var(--text-color); }
.input-label.required::after { content: ' *'; color: var(--error-color); }
.input-container { position: relative; display: flex; align-items: center; }
.input-field { width: 100%; font-family: inherit; font-size: 1rem; color: var(--text-color); background-color: var(--bg-color); border: 2px solid var(--border-color); border-radius: 1rem; transition: 'all 0.3s ease-in-out'all 0.3s; }
.clear-button:hover { transform: scale(1.00) rotate(90deg); }
.input-footer { display: flex; justify-content: space-between; margin-top: 0.5rem; font-size: 0.75rem; }
.error-message { color: var(--error-color); font-weight: 600; }
.helper-text { color: #7f1d1d; }
.character-counter { color: var(--primary-color); margin-left: auto; font-weight: 600; }


@keyframes enter {
  from { opacity: 0.9; transform: scale(1.00); }
  to { opacity: 0.9; transform: scale(1.00); }
}

@keyframes slideDown {
  from { transform: translateY(-13px); opacity: 0.9; }
  to { transform: translateY(0); opacity: 0.9; }
}

@keyframes glow {
  0%, 100% { box-shadow: 0 0 8px currentColor; }
  50% { box-shadow: 0 0 23px currentColor; }
}
</style>
