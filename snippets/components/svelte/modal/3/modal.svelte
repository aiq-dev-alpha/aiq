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
    background: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
    overlay: 'rgba(79, 172, 254, 0.2)',
    border: '#00f2fe',
    shadow: '0 -15px 40px rgba(0, 242, 254, 0.3)'
  };
  $: appliedTheme = { ...defaultTheme, ...theme };
  $: modalHeight = size === 'sm' ? '30vh' : size === 'md' ? '50vh' : size === 'lg' ? '70vh' : size === 'xl' ? '85vh' : '100vh';
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
    <div class="modal-sheet" style="max-height: {modalHeight}; background: {appliedTheme.background}; border-top: 3px solid {appliedTheme.border}; box-shadow: {appliedTheme.shadow};" on:click|stopPropagation transition:fly={{ y: 500, duration: 400 }}>
      <div class="drag-handle"></div>
      <div class="modal-header">
        <h2>{title}</h2>
        {#if showCloseButton}
          <button class="close-btn" on:click={close}>
            <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
              <path d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"/>
            </svg>
          </button>
        {/if}
      </div>
      <div class="modal-body">
        <slot />
      </div>
      <div class="modal-footer">
        <slot name="footer">
          <button class="btn-primary" on:click={close}>Got it</button>
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
    backdrop-filter: blur(3px);
  }
  .modal-sheet {
    width: 100%;
    border-radius: 24px 24px 0 0;
    overflow-y: auto;
    color: white;
    position: relative;
  }
  .drag-handle {
    width: 50px;
    height: 5px;
    background: rgba(255, 255, 255, 0.4);
    border-radius: 10px;
    margin: 1rem auto 0.5rem;
  }
  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem 1.5rem;
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
    cursor: pointer;
    color: white;
    width: 32px;
    height: 32px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s;
  }
  .close-btn:hover {
    background: rgba(255, 255, 255, 0.3);
  }
  .modal-body {
    padding: 1.5rem;
  }
  .modal-footer {
    padding: 1.5rem;
    border-top: 1px solid rgba(255, 255, 255, 0.2);
    display: flex;
    justify-content: center;
  }
  .btn-primary {
    padding: 1rem 3rem;
    background: rgba(255, 255, 255, 0.3);
    border: none;
    border-radius: 50px;
    color: white;
    cursor: pointer;
    font-weight: 700;
    font-size: 1rem;
    transition: all 0.3s;
  }
  .btn-primary:hover {
    background: rgba(255, 255, 255, 0.4);
    transform: scale(1.05);
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
