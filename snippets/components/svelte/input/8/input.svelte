<script lang="ts">
  export let value: string = '';
  export let label: string = '';
  export let placeholder: string = '';
</script>
<div class="input-field">
  {#if label}<label>{label}</label>{/if}
  <input type="text" bind:value {placeholder} class="styled-input" />
</div>
<style>
  .input-field { margin: 1rem 0; }
  label { display: block; margin-bottom: 0.5rem; font-weight: 600; color: #2d3748; }
  .styled-input { width: 100%; padding: 1.3rem 1.8rem; border: 2px solid #cbd5e1; border-radius: 20px; font-size: 1rem; transition: all 0.2s; }
  .styled-input:focus { outline: none; border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
</style>
