<script lang="ts">
  import { fade, fly } from 'svelte/transition';
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
  export let variant: 'default' | 'centered' | 'drawer' | 'fullscreen' | 'bottom-sheet' = 'bottom-sheet';
  export let closeOnOverlay = true;
  export let closeOnEsc = true;
  export let showCloseButton = true;
  export let theme: ModalTheme = {};
  const dispatch = createEventDispatcher();
  const defaultTheme: ModalTheme = {
    background: 'linear-gradient(135deg, #d299c2 0%, #fef9d7 100%)',
    overlay: 'rgba(210, 153, 194, 0.3)',
    border: '#fef9d7',
    shadow: '0 -20px 50px rgba(254, 249, 215, 0.35)'
  };
  $: appliedTheme = { ...defaultTheme, ...theme };
  $: modalHeight = size === 'sm' ? '35vh' : size === 'md' ? '55vh' : size === 'lg' ? '75vh' : size === 'xl' ? '90vh' : '100vh';
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
    <div class="modal-sheet" style="max-height: {modalHeight}; background: {appliedTheme.background}; border-top: 5px solid {appliedTheme.border}; box-shadow: {appliedTheme.shadow};" on:click|stopPropagation transition:fly={{ y: 600, duration: 500 }}>
      <div class="drag-indicator">
        <div class="drag-bar"></div>
        <div class="drag-bar"></div>
      </div>
      <div class="modal-header">
        <h2>{title}</h2>
        {#if showCloseButton}
          <button class="close-btn" on:click={close}>
            <span>CLOSE</span>
          </button>
        {/if}
      </div>
      <div class="modal-body">
        <slot />
      </div>
      <div class="modal-footer">
        <slot name="footer">
          <button class="btn-pill" on:click={close}>Done</button>
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
    z-index: 1000;
    display: flex;
    align-items: flex-end;
    backdrop-filter: blur(4px);
  }
  .modal-sheet {
    width: 100%;
    border-radius: 28px 28px 0 0;
    overflow-y: auto;
    color: #44337a;
    position: relative;
  }
  .drag-indicator {
    display: flex;
    gap: 0.5rem;
    justify-content: center;
    padding: 1.25rem 0 0.75rem;
  }
  .drag-bar {
    width: 30px;
    height: 4px;
    background: rgba(68, 51, 122, 0.3);
    border-radius: 4px;
  }
  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1.25rem 1.75rem;
    border-bottom: 2px solid rgba(254, 249, 215, 0.6);
  }
  .modal-header h2 {
    margin: 0;
    font-size: 1.65rem;
    font-weight: 800;
  }
  .close-btn {
    background: rgba(210, 153, 194, 0.3);
    border: 2px solid rgba(210, 153, 194, 0.5);
    cursor: pointer;
    color: #44337a;
    padding: 0.5rem 1.25rem;
    border-radius: 8px;
    font-weight: 700;
    font-size: 0.85rem;
    transition: all 0.3s;
    letter-spacing: 0.05em;
  }
  .close-btn:hover {
    background: rgba(210, 153, 194, 0.5);
    transform: scale(1.05);
  }
  .modal-body {
    padding: 1.75rem;
  }
  .modal-footer {
    padding: 1.75rem;
    border-top: 2px solid rgba(254, 249, 215, 0.6);
    display: flex;
    justify-content: center;
  }
  .btn-pill {
    padding: 1.1rem 4rem;
    background: rgba(254, 249, 215, 0.6);
    border: 3px solid rgba(254, 249, 215, 0.9);
    border-radius: 100px;
    color: #44337a;
    cursor: pointer;
    font-weight: 800;
    font-size: 1.1rem;
    transition: all 0.3s;
  }
  .btn-pill:hover {
    background: rgba(254, 249, 215, 0.8);
    transform: scale(1.08);
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
