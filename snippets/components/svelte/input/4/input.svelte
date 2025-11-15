<script lang="ts">
  import { slide, fade, fly } from 'svelte/transition';

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
  export let variant: 'default' | 'filled' | 'outlined' | 'underlined' | 'floating' = 'underlined';
  export let size: 'sm' | 'md' | 'lg' = 'md';
  export let theme: Partial<InputTheme> = {};
  export let showCharCount = false;
  export let maxLength: number | undefined = undefined;
  export let showClear = false;

  const defaultTheme: InputTheme = {
    primary: '#f59e0b',
    background: '#fffbeb',
    border: '#fde68a',
    text: '#78350f',
    error: '#ef4444',
    success: '#22c55e'
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
    sm: 'text-sm py-1 px-0',
    md: 'text-base py-2 px-0',
    lg: 'text-lg py-3 px-0'
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
      <button type="button" class="clear-btn" on:click={handleClear} transition:fly={{ y: -10, duration: 200 }}>
        ×
      </button>
    {/if}

    {#if icon && iconPosition === 'right' && !showClear}
      <span class="icon icon-right">{icon}</span>
    {/if}

    <div class="underline" class:active={focused}></div>
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
  }

  .label.required::after {
    content: ' *';
    color: v-bind('appliedTheme.error');
  }

  .input-container {
    position: relative;
    display: flex;
    align-items: center;
    background: transparent;
    border: none;
    border-bottom: 2px solid v-bind('appliedTheme.border');
    transition: all 0.3s ease;
  }

  .input-container:hover:not(.disabled) {
    border-bottom-color: v-bind('appliedTheme.primary');
  }

  .input-container.focused {
    border-bottom-color: v-bind('appliedTheme.primary');
  }

  .input-container.error {
    border-bottom-color: v-bind('appliedTheme.error');
  }

  .input-container.success {
    border-bottom-color: v-bind('appliedTheme.success');
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
    color: v-bind('appliedTheme.text');
    opacity: 0.4;
    font-weight: 400;
  }

  .input.with-icon-left {
    padding-left: 2rem;
  }

  .input.with-icon-right {
    padding-right: 2rem;
  }

  .icon {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    color: v-bind('appliedTheme.primary');
    opacity: 0.8;
    pointer-events: none;
    font-size: 1.1rem;
  }

  .icon-left {
    left: 0;
  }

  .icon-right {
    right: 0;
  }

  .clear-btn {
    position: absolute;
    right: 0;
    top: 50%;
    transform: translateY(-50%);
    background: transparent;
    border: none;
    width: 1.5rem;
    height: 1.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    font-size: 1.5rem;
    line-height: 1;
    color: v-bind('appliedTheme.primary');
    transition: all 0.2s;
  }

  .clear-btn:hover {
    color: v-bind('appliedTheme.error');
    transform: translateY(-50%) scale(1.2);
  }

  .underline {
    position: absolute;
    bottom: -2px;
    left: 0;
    width: 100%;
    height: 2px;
    background: linear-gradient(90deg, v-bind('appliedTheme.primary'), #fbbf24);
    transform: scaleX(0);
    transition: transform 0.3s ease;
  }

  .underline.active {
    transform: scaleX(1);
  }

  .floating-label {
    position: absolute;
    left: 0;
    top: 50%;
    transform: translateY(-50%);
    color: v-bind('appliedTheme.text');
    opacity: 0.6;
    pointer-events: none;
    transition: all 0.3s ease;
    font-weight: 500;
  }

  .floating-label.floating {
    top: -1.25rem;
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
    border-bottom-style: dashed;
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
