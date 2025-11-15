<script lang="ts">
  import { writable } from 'svelte/store';
  import { scale, fly } from 'svelte/transition';

  // Tag/Chip Input - Unique in CAPABILITIES (multi-value), USE CASE (tags/keywords), STRUCTURE (array of values)
  export let tags: string[] = [];
  export let placeholder: string = 'Add tag...';
  export let label: string = '';
  export let maxTags: number = 10;
  export let allowDuplicates: boolean = false;
  export let disabled: boolean = false;
  export let variant: 'default' | 'colored' | 'outlined' = 'default';

  let inputValue = '';
  let inputElement: HTMLInputElement;
  const tagColors = ['#3b82f6', '#8b5cf6', '#ec4899', '#f59e0b', '#10b981', '#06b6d4'];

  function addTag() {
    const trimmed = inputValue.trim();
    if (!trimmed) return;

    if (tags.length >= maxTags) {
      return;
    }

    if (!allowDuplicates && tags.includes(trimmed)) {
      inputValue = '';
      return;
    }

    tags = [...tags, trimmed];
    inputValue = '';
  }

  function removeTag(index: number) {
    tags = tags.filter((_, i) => i !== index);
    inputElement?.focus();
  }

  function handleKeyDown(event: KeyboardEvent) {
    if (event.key === 'Enter' || event.key === ',') {
      event.preventDefault();
      addTag();
    } else if (event.key === 'Backspace' && !inputValue && tags.length > 0) {
      removeTag(tags.length - 1);
    }
  }

  function getTagColor(index: number) {
    return tagColors[index % tagColors.length];
  }
</script>

<div class="tag-input-wrapper">
  {#if label}
    <label class="tag-label">{label}</label>
  {/if}

  <div class="tag-input-container variant-{variant}" class:disabled>
    <div class="tags-list">
      {#each tags as tag, index (tag + index)}
        <div
          class="tag"
          style="background-color: {variant === 'colored' ? getTagColor(index) : '#e5e7eb'}; color: {variant === 'colored' ? 'white' : '#374151'};"
          transition:scale={{ duration: 200 }}
        >
          <span class="tag-text">{tag}</span>
          <button
            class="tag-remove"
            on:click={() => removeTag(index)}
            type="button"
            disabled={disabled}
            aria-label="Remove tag {tag}"
          >
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
              <path d="M10.5 3.5L3.5 10.5M3.5 3.5L10.5 10.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            </svg>
          </button>
        </div>
      {/each}
    </div>

    <input
      bind:this={inputElement}
      bind:value={inputValue}
      type="text"
      class="tag-input"
      {placeholder}
      {disabled}
      on:keydown={handleKeyDown}
      on:blur={addTag}
    />
  </div>

  {#if tags.length >= maxTags}
    <p class="tag-limit-message" transition:fly="{{ y: -5, duration: 200 }}">
      Maximum {maxTags} tags reached
    </p>
  {/if}
</div>

<style>
  .tag-input-wrapper {
    width: 100%;
  }

  .tag-label {
    display: block;
    margin-bottom: 0.5rem;
    font-size: 0.875rem;
    font-weight: 600;
    color: #1f2937;
  }

  .tag-input-container {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    padding: 0.625rem;
    border: 2px solid #e5e7eb;
    border-radius: 10px;
    background: white;
    min-height: 42px;
    transition: all 0.2s ease;
  }

  .tag-input-container:focus-within {
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
  }

  .variant-outlined {
    background: transparent;
  }

  .tag-input-container.disabled {
    background: #f9fafb;
    cursor: not-allowed;
  }

  .tags-list {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
  }

  .tag {
    display: inline-flex;
    align-items: center;
    gap: 0.375rem;
    padding: 0.375rem 0.625rem;
    border-radius: 6px;
    font-size: 0.875rem;
    font-weight: 500;
    transition: all 0.2s ease;
  }

  .variant-outlined .tag {
    border: 1.5px solid currentColor;
    background: transparent !important;
    color: #374151 !important;
  }

  .tag-text {
    line-height: 1;
  }

  .tag-remove {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0;
    border: none;
    background: none;
    cursor: pointer;
    color: currentColor;
    opacity: 0.7;
    transition: opacity 0.2s ease;
  }

  .tag-remove:hover:not(:disabled) {
    opacity: 1;
  }

  .tag-remove:disabled {
    cursor: not-allowed;
  }

  .tag-input {
    flex: 1;
    min-width: 120px;
    border: none;
    outline: none;
    font-size: 1rem;
    background: transparent;
  }

  .tag-input::placeholder {
    color: #9ca3af;
  }

  .tag-input:disabled {
    cursor: not-allowed;
  }

  .tag-limit-message {
    margin-top: 0.5rem;
    font-size: 0.875rem;
    color: #f59e0b;
    font-weight: 500;
  }
</style>
