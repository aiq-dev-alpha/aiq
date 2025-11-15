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
    const defaultTheme: InputTheme = { primary: '#f59e0b', background: '#fffbeb', border: '#fcd34d', text: '#78350f', error: '#dc2626', success: '#16a34a' };
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
.input-wrapper { width: 100%; margin-bottom: 1rem; }
.input-label { display: block; margin-bottom: 0.5rem; font-size: 0.875rem; font-weight: 700; color: var(--text-color); letter-spacing: 0.025em; }
.input-label.required::after { content: ' *'; color: var(--error-color); }
.input-container { position: relative; display: flex; align-items: center; }
.input-field { width: 100%; font-family: inherit; font-size: 1rem; color: var(--text-color); background: linear-gradient(to bottom, var(--bg-color), #fef3c7); border: 2px solid var(--border-color); border-radius: 0.375rem; transition: all 0.25s ease-out; outline: none; box-shadow: 0 1px 3px rgba(245, 158, 11, 0.1); }
.input-field:focus { border-color: var(--primary-color); box-shadow: 0 4px 14px rgba(245, 158, 11, 0.25), 0 0 0 3px rgba(245, 158, 11, 0.1); transform: translateY(-2px); }
.input-field:disabled { opacity: 0.6; cursor: not-allowed; }
.has-error .input-field { border-color: var(--error-color); animation: pulse-error 0.5s ease; }
@keyframes pulse-error { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.01); } }
.size-sm .input-field { padding: 0.5rem 0.875rem; font-size: 0.875rem; }
.size-md .input-field { padding: 0.75rem 1.125rem; font-size: 1rem; }
.size-lg .input-field { padding: 1rem 1.375rem; font-size: 1.125rem; }
.variant-default .input-field { background-color: var(--bg-color); }
.variant-outlined .input-field { background-color: transparent; }
.variant-underlined .input-field { border: none; border-bottom: 3px solid var(--border-color); border-radius: 0; background: transparent; box-shadow: none; }
.input-icon { position: absolute; color: var(--primary-color); pointer-events: none; font-weight: 600; }
.input-icon.left { left: 1rem; }
.input-icon.right { right: 1rem; }
.clear-button { position: absolute; right: 1rem; background: var(--primary-color); color: white; border: none; border-radius: 50%; width: 1.375rem; height: 1.375rem; font-size: 1.25rem; cursor: pointer; transition: all 0.2s; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 6px rgba(245, 158, 11, 0.3); }
.clear-button:hover { transform: scale(1.15); }
.input-footer { display: flex; justify-content: space-between; margin-top: 0.5rem; font-size: 0.75rem; }
.error-message { color: var(--error-color); font-weight: 600; }
.helper-text { color: #92400e; }
.character-counter { color: #b45309; margin-left: auto; font-weight: 500; }
</style>
