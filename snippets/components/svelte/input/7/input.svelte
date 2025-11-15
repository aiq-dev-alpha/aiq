<script lang="ts">
  import { slide, fade, blur } from 'svelte/transition';

  export interface InputTheme {
    primary: string;
    background: string;
    border: string;
    text: string;
    error: string;
    success: string;
  }

  export let value = '';
  export let type: string = 'text';
  export let label = '';
  export let placeholder = '';
  export let error = '';
  export let helperText = '';
  export let disabled = false;
  export let required = false;
  export let icon = '';
  export let iconPosition: 'left' | 'right' = 'left';
  export let variant: 'default' | 'filled' | 'outlined' | 'underlined' | 'floating' = 'filled';
  export let size: 'sm' | 'md' | 'lg' = 'md';
  export let theme: Partial<InputTheme> = {};
  export let showCharCount = false;
  export let maxLength: number | undefined = undefined;
  export let showClear = false;

  const defaultTheme: InputTheme = {
    primary: '#a855f7',
    background: '#faf5ff',
    border: '#e9d5ff',
    text: '#581c87',
    error: '#dc2626',
    success: '#15803d'
  };

  $: appliedTheme = { ...defaultTheme, ...theme };
  $: hasError = !!error;
  $: showSuccess = !hasError && value.length > 0 && !disabled;

  let focused = false;
  let inputElement: HTMLInputElement;

  function handleClear() {
    value = '';
    inputElement?.focus();
  }

  $: sizeClasses = {
    sm: 'text-sm py-2 px-4',
    md: 'text-base py-3 px-5',
    lg: 'text-lg py-4 px-6'
  }[size];
</script>

<div class="input-wrapper" class:disabled>
  {#if label && variant !== 'floating'}
    <label class="label" class:required>
      {label}
    </label>
  {/if}

  <div class="input-container" class:focused class:error={hasError} class:success={showSuccess}>
    {#if icon && iconPosition === 'left'}
      <span class="icon icon-left">{icon}</span>
    {/if}

    <div class="input-inner">
      {#if variant === 'floating'}
        <label class="floating-label" class:floating={focused || value} class:required>
          {label}
        </label>
      {/if}

      <input
        bind:this={inputElement}
        bind:value
        {type}
        {placeholder}
        {disabled}
        {required}
        maxlength={maxLength}
        class="input {sizeClasses}"
        class:with-icon-left={icon && iconPosition === 'left'}
        class:with-icon-right={icon && iconPosition === 'right' || showClear}
        on:focus={() => focused = true}
        on:blur={() => focused = false}
        on:input
        on:change
        on:keydown
        on:keyup
      />
    </div>

    {#if showClear && value && !disabled}
      <button type="button" class="clear-btn" on:click={handleClear} transition:blur={{ duration: 150 }}>
        ×
      </button>
    {/if}

    {#if icon && iconPosition === 'right' && !showClear}
      <span class="icon icon-right">{icon}</span>
    {/if}
  </div>

  {#if error}
    <div class="message error-message" transition:slide={{ duration: 200 }}>
      {error}
    </div>
  {:else if helperText}
    <div class="message helper-message">
      {helperText}
    </div>
  {/if}

  {#if showCharCount && maxLength}
    <div class="char-count">
      {value.length}/{maxLength}
    </div>
  {/if}
</div>

<style>
  .input-wrapper {
    width: 100%;
    font-family: system-ui, -apple-system, sans-serif;
  }

  .label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 700;
    color: v-bind('appliedTheme.primary');
    font-size: 0.875rem;
    letter-spacing: 0.025em;
  }

  .label.required::after {
    content: ' *';
    color: v-bind('appliedTheme.error');
  }

  .input-container {
    position: relative;
    display: flex;
    align-items: center;
    background: v-bind('appliedTheme.background');
    border: none;
    border-radius: 0.375rem;
    transition: all 0.3s ease;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  }

  .input-container:hover:not(.disabled) {
    box-shadow: 0 4px 12px rgba(168, 85, 247, 0.2);
    transform: translateY(-1px);
  }

  .input-container.focused {
    box-shadow: 0 8px 20px rgba(168, 85, 247, 0.3);
    transform: translateY(-2px);
    background: linear-gradient(135deg, v-bind('appliedTheme.background'), white);
  }

  .input-container.error {
    background: #fef2f2;
    box-shadow: 0 0 0 2px v-bind('appliedTheme.error');
  }

  .input-container.success {
    background: #f0fdf4;
    box-shadow: 0 0 0 2px v-bind('appliedTheme.success');
  }

  .input-inner {
    flex: 1;
    position: relative;
  }

  .input {
    width: 100%;
    border: none;
    outline: none;
    background: transparent;
    color: v-bind('appliedTheme.text');
    font-family: inherit;
    font-weight: 600;
  }

  .input.with-icon-left {
    padding-left: 2.5rem;
  }

  .input.with-icon-right {
    padding-right: 2.5rem;
  }

  .icon {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    color: v-bind('appliedTheme.primary');
    opacity: 0.7;
    pointer-events: none;
    font-size: 1.15rem;
  }

  .icon-left {
    left: 1.25rem;
  }

  .icon-right {
    right: 1.25rem;
  }

  .clear-btn {
    position: absolute;
    right: 1rem;
    top: 50%;
    transform: translateY(-50%);
    background: v-bind('appliedTheme.primary');
    border: none;
    border-radius: 0.25rem;
    width: 1.5rem;
    height: 1.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    font-size: 1.25rem;
    line-height: 1;
    color: white;
    transition: all 0.2s;
  }

  .clear-btn:hover {
    background: v-bind('appliedTheme.error');
    transform: translateY(-50%) scale(1.1);
  }

  .floating-label {
    position: absolute;
    left: 1.25rem;
    top: 50%;
    transform: translateY(-50%);
    color: v-bind('appliedTheme.text');
    opacity: 0.6;
    pointer-events: none;
    transition: all 0.3s ease;
    background: v-bind('appliedTheme.background');
    padding: 0 0.25rem;
    font-weight: 500;
  }

  .floating-label.floating {
    top: 0;
    font-size: 0.75rem;
    opacity: 1;
    color: v-bind('appliedTheme.primary');
    font-weight: 700;
  }

  .floating-label.required::after {
    content: ' *';
    color: v-bind('appliedTheme.error');
  }

  .message {
    margin-top: 0.5rem;
    font-size: 0.875rem;
    font-weight: 500;
  }

  .error-message {
    color: v-bind('appliedTheme.error');
  }

  .helper-message {
    color: v-bind('appliedTheme.text');
    opacity: 0.7;
  }

  .char-count {
    margin-top: 0.25rem;
    font-size: 0.75rem;
    text-align: right;
    color: v-bind('appliedTheme.primary');
    font-weight: 600;
  }

  .disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  .disabled .input-container {
    background: #f9fafb;
    transform: none !important;
    box-shadow: none !important;
  }

  .disabled input {
    cursor: not-allowed;
  }
</style>
