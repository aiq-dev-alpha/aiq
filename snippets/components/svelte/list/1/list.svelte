<script lang="ts">
  export let theme = {};
  export let size = 'md';
  const defaultTheme = {
    primaryColor: '#3b82f6',
    backgroundColor: '#ffffff',
    textColor: '#111827'
  };
  $: appliedTheme = { ...defaultTheme, ...theme };
  $: padding = size === 'sm' ? '0.5rem' : size === 'lg' ? '1.5rem' : '1rem';
</script>
<div
  style="
    padding: {padding};
    background-color: {appliedTheme.backgroundColor};
    color: {appliedTheme.textColor};
    border-radius: 0.5rem;
  "
>
  <slot />
</div>
