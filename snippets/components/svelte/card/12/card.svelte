<script lang="ts">
  export let variant: 'default' | 'outlined' | 'elevated' = 'default';
  export let hoverable: boolean = false;
  $: variantClasses = {
    default: 'bg-white shadow-md',
    outlined: 'bg-white border-2 border-gray-200',
    elevated: 'bg-white shadow-2xl'
  };
  $: hoverClass = hoverable ? 'hover:shadow-sm hover:-translate-y-1 transition-all duration-150 cursor-pointer' : '';
</script>
<div class="rounded-xl overflow-hidden {variantClasses[variant]} {hoverClass}">
  {#if $$slots.header}
    <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
      <slot name="header" />
    </div>
  {/if}
  <div class="px-6 py-4">
    <slot />
  </div>
  {#if $$slots.footer}
    <div class="px-6 py-4 border-t border-gray-200 bg-gray-50">
      <slot name="footer" />
    </div>
  {/if}
</div>
<style>
  div {
    transition-property: box-shadow, transform;
  }
</style>
