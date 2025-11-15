<script lang="ts">
  export let value: string = '';
  export let label: string = '';
  export let type: string = 'text';
  export let placeholder: string = '';
  export let disabled: boolean = false;
  export let required: boolean = false;
  export let error: string = '';
  export let hint: string = '';
  let isFocused = false;
  function handleInput(event: Event) {
    const target = event.target as HTMLInputElement;
    value = target.value;
  }
</script>
<div class="relative">
  {#if label}
    <label class="block text-sm font-medium text-gray-700 mb-1">
      {label}
      {#if required}
        <span class="text-pink-500">*</span>
      {/if}
    </label>
  {/if}
  <div class="relative">
    {#if $$slots.prefix}
      <div class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">
        <slot name="prefix" />
      </div>
    {/if}
    <input
      {type}
      {value}
      {placeholder}
      {disabled}
      {required}
      class="w-full px-4 py-2.5 border rounded-lg transition-all duration-300 focus:outline-none focus:ring-2 {
        $$slots.prefix ? 'pl-10' : ''
      } {
        $$slots.suffix ? 'pr-10' : ''
      } {
        error ? 'border-pink-300 focus:ring-pink-500' : 'border-gray-300 focus:ring-pink-500'
      } {
        disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white'
      }"
      on:input={handleInput}
      on:focus={() => isFocused = true}
      on:blur={() => isFocused = false}
    />
    {#if $$slots.suffix}
      <div class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400">
        <slot name="suffix" />
      </div>
    {/if}
  </div>
  {#if error}
    <p class="mt-1 text-sm text-pink-600">{error}</p>
  {:else if hint}
    <p class="mt-1 text-sm text-gray-500">{hint}</p>
  {/if}
</div>
