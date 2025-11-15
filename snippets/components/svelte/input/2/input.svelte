<script lang="ts">
  export let value: string = '';
  export let placeholder: string = '';
  export let label: string = '';
  export let error: string = '';
  export let disabled: boolean = false;
  let focused = false;
</script>
<div class="field">
  {#if label}
    <label class="field-label">{label}</label>
  {/if}
  <input
    type="text"
    bind:value
    {placeholder}
    {disabled}
    on:focus={() => focused = true}
    on:blur={() => focused = false}
    class="field-input"
    class:focused
    class:error
  />
  {#if error}
    <p class="field-error">{error}</p>
  {/if}
</div>
<style>
  .field {
    margin: 1.25rem 0;
  }
  .field-label {
    display: block;
    margin-bottom: 0.625rem;
    font-size: 0.875rem;
    font-weight: 600;
    color: #1f2937;
  }
  .field-input {
    width: 100%;
    padding: 0.75rem 1.125rem;
    font-size: 1rem;
    border: 2px solid #e5e7eb;
    border-radius: 4px;
    outline: none;
    transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
    background: white;
  }
  .field-input:hover:not(:disabled) {
    border-color: #cbd5e1;
  }
  .field-input.focused {
    border-color: var(--blue-500, #3b82f6);
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
  }
  .field-input.error {
    border-color: #ef4444;
  }
  .field-error {
    margin-top: 0.5rem;
    font-size: 0.875rem;
    color: #dc2626;
    font-weight: 500;
  }
</style>
