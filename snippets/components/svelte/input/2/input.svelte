<script lang="ts">
  import { slide, fade, scale } from 'svelte/transition';

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
    primary: '#8b5cf6',
    background: '#faf5ff',
    border: '#ddd6fe',
    text: '#1f2937',
    error: '#dc2626',
    success: '#059669'
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
      <button type="button" class="clear-btn" on:click={handleClear} transition:scale={{ duration: 150 }}>
        ×
      </button>
    {/if}

    {#if icon && iconPosition === 'right' && !showClear}
      <span class="icon icon-right">{icon}</span>
    {/if}

    <div class="focus-bar" class:active={focused}></div>
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
    font-weight: 600;
    color: v-bind('appliedTheme.primary');
    font-size: 0.875rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
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
    border-radius: 1rem;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    overflow: hidden;
  }

  .input-container:hover:not(.disabled) {
    background: linear-gradient(135deg, v-bind('appliedTheme.background') 0%, #ede9fe 100%);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(139, 92, 246, 0.15);
  }

  .input-container.focused {
    background: linear-gradient(135deg, v-bind('appliedTheme.background') 0%, #ede9fe 100%);
    box-shadow: 0 8px 20px rgba(139, 92, 246, 0.25);
    transform: translateY(-2px);
  }

  .input-container.error {
    background: #fef2f2;
  }

  .input-container.success {
    background: #f0fdf4;
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
    font-weight: 500;
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
    font-size: 1.5rem;
    line-height: 1;
    color: white;
    transition: all 0.2s;
  }

  .clear-btn:hover {
    transform: translateY(-50%) rotate(90deg);
    background: v-bind('appliedTheme.error');
  }

  .focus-bar {
    position: absolute;
    bottom: 0;
    left: 50%;
    transform: translateX(-50%) scaleX(0);
    width: 100%;
    height: 3px;
    background: linear-gradient(90deg, v-bind('appliedTheme.primary'), #c084fc);
    transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  }

  .focus-bar.active {
    transform: translateX(-50%) scaleX(1);
  }

  .floating-label {
    position: absolute;
    left: 1rem;
    top: 50%;
    transform: translateY(-50%);
    color: v-bind('appliedTheme.text');
    opacity: 0.6;
    pointer-events: none;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    background: v-bind('appliedTheme.background');
    padding: 0 0.25rem;
    font-weight: 500;
  }

  .floating-label.floating {
    top: 0;
    font-size: 0.75rem;
    opacity: 1;
    color: v-bind('appliedTheme.primary');
    font-weight: 600;
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
