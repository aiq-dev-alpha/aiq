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
  export let variant: 'default' | 'centered' | 'drawer' | 'fullscreen' | 'bottom-sheet' = 'drawer';
  export let closeOnOverlay = true;
  export let closeOnEsc = true;
  export let showCloseButton = true;
  export let theme: ModalTheme = {};

  const dispatch = createEventDispatcher();

  const defaultTheme: ModalTheme = {
    background: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
    overlay: 'rgba(245, 87, 108, 0.3)',
    border: '#f5576c',
    shadow: '0 20px 60px rgba(245, 87, 108, 0.4)'
  };

  $: appliedTheme = { ...defaultTheme, ...theme };
  $: modalWidth = size === 'sm' ? '350px' : size === 'md' ? '450px' : size === 'lg' ? '550px' : size === 'xl' ? '650px' : '100%';

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
  <div class="modal-overlay" style="background: {appliedTheme.overlay};" on:click={handleOverlayClick} transition:fade={{ duration: 250 }}>
    <div class="modal-drawer" style="width: {modalWidth}; background: {appliedTheme.background}; border-left: 3px solid {appliedTheme.border}; box-shadow: {appliedTheme.shadow};" on:click|stopPropagation transition:fly={{ x: 300, duration: 400 }}>
      <div class="modal-header">
        <h2>{title}</h2>
        {#if showCloseButton}
          <button class="close-btn" on:click={close}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        {/if}
      </div>

      <div class="modal-body">
        <slot />
      </div>

      <div class="modal-footer">
        <slot name="footer">
          <button class="btn-cancel" on:click={close}>Cancel</button>
          <button class="btn-primary">Confirm</button>
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
    backdrop-filter: blur(2px);
  }

  .modal-drawer {
    position: fixed;
    top: 0;
    right: 0;
    height: 100%;
    overflow-y: auto;
    color: white;
    display: flex;
    flex-direction: column;
  }

  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 2rem 1.5rem 1rem;
    border-bottom: 1px solid rgba(255, 255, 255, 0.15);
  }

  .modal-header h2 {
    margin: 0;
    font-size: 1.75rem;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }

  .close-btn {
    background: transparent;
    border: 2px solid rgba(255, 255, 255, 0.3);
    cursor: pointer;
    color: white;
    width: 36px;
    height: 36px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s;
  }

  .close-btn:hover {
    background: rgba(255, 255, 255, 0.2);
    border-color: rgba(255, 255, 255, 0.5);
    transform: scale(1.1);
  }

  .modal-body {
    flex: 1;
    padding: 1.5rem;
    overflow-y: auto;
  }

  .modal-footer {
    padding: 1.5rem;
    border-top: 1px solid rgba(255, 255, 255, 0.15);
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
  }

  .btn-cancel {
    padding: 0.75rem 1.25rem;
    background: transparent;
    border: 2px solid rgba(255, 255, 255, 0.4);
    border-radius: 10px;
    color: white;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.3s;
  }

  .btn-cancel:hover {
    background: rgba(255, 255, 255, 0.1);
  }

  .btn-primary {
    padding: 0.75rem 1.25rem;
    background: rgba(255, 255, 255, 0.25);
    border: 2px solid rgba(255, 255, 255, 0.5);
    border-radius: 10px;
    color: white;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.3s;
  }

  .btn-primary:hover {
    background: rgba(255, 255, 255, 0.35);
    transform: translateY(-2px);
  }
</style>
