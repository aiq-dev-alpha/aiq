<script lang="ts">
  import { slide, fade, scale } from 'svelte/transition';
  import { elasticOut } from 'svelte/easing';

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
  export let variant: 'default' | 'filled' | 'outlined' | 'underlined' | 'floating' = 'floating';
  export let size: 'sm' | 'md' | 'lg' = 'md';
  export let theme: Partial<InputTheme> = {};
  export let showCharCount = false;
  export let maxLength: number | undefined = undefined;
  export let showClear = false;

  const defaultTheme: InputTheme = {
    primary: '#ec4899',
    background: '#fdf2f8',
    border: '#fbcfe8',
    text: '#831843',
    error: '#dc2626',
    success: '#16a34a'
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
    sm: 'text-sm py-2 px-3',
    md: 'text-base py-3 px-4',
    lg: 'text-lg py-4 px-5'
  }[size];
</script>

<div class="input-wrapper" class:disabled>
  <div class="input-container" class:focused class:error={hasError} class:success={showSuccess}>
    {#if icon && iconPosition === 'left'}
      <span class="icon icon-left">{icon}</span>
    {/if}

    <div class="input-inner">
      {#if variant === 'floating' || label}
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
      <button type="button" class="clear-btn" on:click={handleClear} transition:scale={{ duration: 200, easing: elasticOut }}>
        ×
      </button>
    {/if}

    {#if icon && iconPosition === 'right' && !showClear}
      <span class="icon icon-right">{icon}</span>
    {/if}

    <div class="glow-ring"></div>
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

  .input-container {
    position: relative;
    display: flex;
    align-items: center;
    background: white;
    border: 2px solid v-bind('appliedTheme.border');
    border-radius: 0.625rem;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  }

  .input-container:hover:not(.disabled) {
    border-color: v-bind('appliedTheme.primary');
  }

  .input-container.focused {
    border-color: v-bind('appliedTheme.primary');
    transform: translateY(-2px);
  }

  .input-container.focused .glow-ring {
    opacity: 1;
    transform: scale(1.02);
  }

  .input-container.error {
    border-color: v-bind('appliedTheme.error');
  }

  .input-container.success {
    border-color: v-bind('appliedTheme.success');
  }

  .glow-ring {
    position: absolute;
    inset: -4px;
    border-radius: 0.75rem;
    background: linear-gradient(135deg, v-bind('appliedTheme.primary'), #f9a8d4);
    opacity: 0;
    z-index: -1;
    filter: blur(8px);
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
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

  .input::placeholder {
    color: transparent;
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
    font-size: 1.25rem;
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
    background: v-bind('appliedTheme.primary');
    border: none;
    border-radius: 50%;
    width: 1.75rem;
    height: 1.75rem;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    font-size: 1.25rem;
    line-height: 1;
    color: white;
    transition: all 0.3s;
    box-shadow: 0 2px 8px rgba(236, 72, 153, 0.3);
  }

  .clear-btn:hover {
    background: v-bind('appliedTheme.error');
    transform: translateY(-50%) scale(1.1);
  }

  .floating-label {
    position: absolute;
    left: 1rem;
    top: 50%;
    transform: translateY(-50%);
    color: v-bind('appliedTheme.text');
    opacity: 0.5;
    pointer-events: none;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    background: white;
    padding: 0 0.375rem;
    font-weight: 500;
  }

  .floating-label.floating {
    top: 0;
    transform: translateY(-50%);
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
  }

  .disabled input {
    cursor: not-allowed;
  }


@keyframes fade {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes expand {
  from { transform: scale(0.9); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}
</style>
