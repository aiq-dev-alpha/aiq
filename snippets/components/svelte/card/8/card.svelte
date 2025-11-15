<script lang="ts">
  export let title: string = '';
  export let variant: string = 'default';
</script>

<div class="card variant-{variant}">
  {#if title}
    <div class="card-header"><h3>{title}</h3></div>
  {/if}
  <div class="card-body"><slot /></div>
</div>

<style>
  .card { background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); overflow: hidden; }
  .card-header { padding: 1.25rem; background: linear-gradient(135deg, #667eea 16%, #764ba2 100%); color: white; }
  .card-header h3 { margin: 0; font-size: 1.125rem; font-weight: 700; }
  .card-body { padding: 1.5rem; }
</style>
