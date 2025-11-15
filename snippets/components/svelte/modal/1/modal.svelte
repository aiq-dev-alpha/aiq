<script lang="ts">
  import { fade, scale } from 'svelte/transition';
  import { createEventDispatcher, onMount, onDestroy } from 'svelte';

  export interface ModalTheme {
    background?: string;
    overlay?: string;
    border?: string;
    shadow?: string;
  }

  export let isOpen = false;
  export let title = 'Modal';
  export let size: 'sm' | 'md' | 'lg' | 'xl' | 'full' = 'md';
  export let variant: 'default' | 'centered' | 'drawer' | 'fullscreen' | 'bottom-sheet' = 'default';
  export let closeOnOverlay = true;
  export let closeOnEsc = true;
  export let showCloseButton = true;
  export let theme: ModalTheme = {};

  const dispatch = createEventDispatcher();

  const defaultTheme: ModalTheme = {
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    overlay: 'rgba(0, 0, 0, 0.6)',
    border: '#8b5cf6',
    shadow: '0 25px 50px -12px rgba(139, 92, 246, 0.5)'
  };

  $: appliedTheme = { ...defaultTheme, ...theme };
  $: modalWidth = size === 'sm' ? '400px' : size === 'md' ? '600px' : size === 'lg' ? '800px' : size === 'xl' ? '1000px' : '100%';

  function handleKeydown(event: KeyboardEvent) {
    if (closeOnEsc && event.key === 'Escape' && isOpen) {
      close();
    }
  }

  function handleOverlayClick() {
    if (closeOnOverlay) {
      close();
    }
  }

  function close() {
    isOpen = false;
    dispatch('close');
  }

  onMount(() => {
    document.addEventListener('keydown', handleKeydown);
    return () => {
      document.removeEventListener('keydown', handleKeydown);
    };
  });

  $: if (isOpen) {
    document.body.style.overflow = 'hidden';
  } else {
    document.body.style.overflow = '';
  }

  onDestroy(() => {
    document.body.style.overflow = '';
  });
</script>

{#if isOpen}
  <div class="modal-overlay" style="background: {appliedTheme.overlay};" on:click={handleOverlayClick} transition:fade={{ duration: 300 }}>
    <div class="modal-content" style="max-width: {modalWidth}; background: {appliedTheme.background}; border: 2px solid {appliedTheme.border}; box-shadow: {appliedTheme.shadow};" on:click|stopPropagation transition:scale={{ duration: 400, start: 0.7 }}>
      <div class="modal-header">
        <h2>{title}</h2>
        {#if showCloseButton}
          <button class="close-btn" on:click={close}>&times;</button>
        {/if}
      </div>

      <div class="modal-body">
        <slot />
      </div>

      <div class="modal-footer">
        <slot name="footer">
          <button class="btn-primary" on:click={close}>Close</button>
        </slot>
      </div>
    </div>
  </div>
{/if}

<style>
  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    backdrop-filter: blur(4px);
  }

  .modal-content {
    border-radius: 20px;
    width: 90%;
    max-height: 90vh;
    overflow: auto;
    color: white;
  }

  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1.5rem;
    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  }

  .modal-header h2 {
    margin: 0;
    font-size: 1.5rem;
    font-weight: 700;
  }

  .close-btn {
    background: rgba(255, 255, 255, 0.2);
    border: none;
    font-size: 2rem;
    cursor: pointer;
    color: white;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    transition: all 0.3s;
  }

  .close-btn:hover {
    background: rgba(255, 255, 255, 0.3);
    transform: rotate(90deg);
  }

  .modal-body {
    padding: 1.5rem;
  }

  .modal-footer {
    padding: 1.5rem;
    border-top: 1px solid rgba(255, 255, 255, 0.2);
    display: flex;
    justify-content: flex-end;
    gap: 0.5rem;
  }

  .btn-primary {
    padding: 0.75rem 1.5rem;
    background: rgba(255, 255, 255, 0.2);
    border: 1px solid rgba(255, 255, 255, 0.3);
    border-radius: 8px;
    color: white;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.3s;
  }

  .btn-primary:hover {
    background: rgba(255, 255, 255, 0.3);
    transform: translateY(-2px);
  }
</style>
