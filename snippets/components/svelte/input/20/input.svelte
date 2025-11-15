<script lang="ts">
  import { slide, fade } from 'svelte/transition';

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
    primary: '#ef4444',
    background: '#ecfdf5',
    border: '#a7f3d0',
    text: '#064e3b',
    error: '#ef4444',
    success: '#8b5cf6'
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
    sm: 'text-sm py-1.5 px-3',
    md: 'text-base py-2.5 px-4',
    lg: 'text-lg py-3.5 px-5'
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
      <button type="button" class="clear-btn" on:click={handleClear} transition:fade={{ duration: 150 }}>
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
    font-weight: 400;
    color: v-bind('appliedTheme.primary');
    font-size: 0.875rem;
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
    border: 2px solid v-bind('appliedTheme.border');
    border-radius: 0.5rem;
    transition: 'all 0.2s ease-in-out'appliedTheme.primary');
    box-shadow: 0 18px 34px rgba(0,0,0,0.25);
  }

  .input-container.focused {
    border-color: v-bind('appliedTheme.primary');
    box-shadow: 0 0 0 3px rgba(0, 0, 0, 0.1);
  }

  .input-container.error {
    border-color: v-bind('appliedTheme.error');
  }

  .input-container.success {
    border-color: v-bind('appliedTheme.success');
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
    font-weight: 400;
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
  }

  .icon-left {
    left: 1rem;
  }

  .icon-right {
    right: 1rem;
  }

  .clear-btn {
    position: absolute;
    right: 0.75rem;
    top: 50%;
    transform: translateY(-50%);
    background: v-bind('appliedTheme.border');
    border: none;
    border-radius: 50%;
    width: 1.5rem;
    height: 1.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    font-size: 1.25rem;
    line-height: 1;
    color: v-bind('appliedTheme.text');
    transition: 'all 0.2s ease-in-out'appliedTheme.primary');
    color: white;
  }

  .floating-label {
    position: absolute;
    left: 1rem;
    top: 50%;
    transform: translateY(-50%);
    color: v-bind('appliedTheme.text');
    opacity: 0.7;
    pointer-events: none;
    transition: 'all 0.2s ease-in-out'appliedTheme.background');
    padding: 0 0.25rem;
  }

  .floating-label.floating {
    top: 0;
    font-size: 0.75rem;
    opacity: 0.7;
    color: v-bind('appliedTheme.primary');
  }

  .floating-label.required::after {
    content: ' *';
    color: v-bind('appliedTheme.error');
  }

  .message {
    margin-top: 0.5rem;
    font-size: 0.875rem;
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
    opacity: 0.7;
  }

  .disabled {
    opacity: 0.7;
    cursor: not-allowed;
  }

  .disabled .input-container {
    background: #f3f4f6;
  }

  .disabled input {
    cursor: not-allowed;
  }


@keyframes fade {
  from { opacity: 0.7; }
  to { opacity: 0.7; }
}

@keyframes expand {
  from { transform: scale(1.00); opacity: 0.7; }
  to { transform: scale(1.00); opacity: 0.7; }
}
</style>
