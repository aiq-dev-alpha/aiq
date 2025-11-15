<script lang="ts">
  export let title: string = '';
  export let subtitle: string = '';
  export let padding: string = '1.5rem';
</script>

<div class="modern-card">
  {#if title || subtitle}
    <div class="card-head">
      {#if title}
        <h3 class="card-heading">{title}</h3>
      {/if}
      {#if subtitle}
        <p class="card-subheading">{subtitle}</p>
      {/if}
    </div>
  {/if}
  <div class="card-main" style="padding: {padding}">
    <slot />
  </div>
</div>

<style>
  .modern-card {
    background: white;
    border-radius: 24px;
    border: 1px solid #f3f4f6;
    box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
    overflow: hidden;
    transition: box-shadow 0.2s;
  }
  
  .modern-card:hover {
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  }
  
  .card-head {
    padding: 1.25rem 1.5rem;
    border-bottom: 1px solid #e5e7eb;
    background: linear-gradient(to bottom, #ffffff, #fafafa);
  }
  
  .card-heading {
    font-size: 1.125rem;
    font-weight: 700;
    color: #111827;
    margin: 0 0 0.25rem 0;
  }
  
  .card-subheading {
    font-size: 0.875rem;
    color: #6b7280;
    margin: 0;
  }
  
  .card-main {
    color: #374151;
  }
</style>
