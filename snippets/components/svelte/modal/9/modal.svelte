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
  export let variant: 'default' | 'centered' | 'drawer' | 'fullscreen' | 'bottom-sheet' = 'centered';
  export let closeOnOverlay = true;
  export let closeOnEsc = true;
  export let showCloseButton = true;
  export let theme: ModalTheme = {};

  const dispatch = createEventDispatcher();

  const defaultTheme: ModalTheme = {
    background: 'linear-gradient(135deg, #232526 0%, #414345 100%)',
    overlay: 'rgba(35, 37, 38, 0.85)',
    border: '#414345',
    shadow: '0 25px 60px rgba(65, 67, 69, 0.6)'
  };

  $: appliedTheme = { ...defaultTheme, ...theme };
  $: modalWidth = size === 'sm' ? '340px' : size === 'md' ? '520px' : size === 'lg' ? '700px' : size === 'xl' ? '880px' : '100%';

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
  <div class="modal-overlay" style="background: {appliedTheme.overlay};" on:click={handleOverlayClick} transition:fade={{ duration: 280 }}>
    <div class="modal-content" style="max-width: {modalWidth}; background: {appliedTheme.background}; border: 1px solid {appliedTheme.border}; box-shadow: {appliedTheme.shadow};" on:click|stopPropagation transition:scale={{ duration: 600, start: 0.8 }}>
      <div class="modal-header">
        <h2>{title}</h2>
        {#if showCloseButton}
          <button class="close-btn" on:click={close}>
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M12 4L4 12M4 4l8 8"/>
            </svg>
          </button>
        {/if}
      </div>

      <div class="modal-body">
        <slot />
      </div>

      <div class="modal-footer">
        <slot name="footer">
          <button class="btn-dark" on:click={close}>Dismiss</button>
          <button class="btn-light">Accept</button>
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
    backdrop-filter: blur(10px);
  }

  .modal-content {
    border-radius: 14px;
    width: 90%;
    max-height: 90vh;
    overflow: auto;
    color: #e2e8f0;
  }

  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1.75rem 2rem;
    border-bottom: 1px solid rgba(226, 232, 240, 0.15);
  }

  .modal-header h2 {
    margin: 0;
    font-size: 1.65rem;
    font-weight: 700;
    letter-spacing: -0.01em;
  }

  .close-btn {
    background: rgba(226, 232, 240, 0.1);
    border: 1px solid rgba(226, 232, 240, 0.2);
    cursor: pointer;
    color: #e2e8f0;
    width: 34px;
    height: 34px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s;
  }

  .close-btn:hover {
    background: rgba(226, 232, 240, 0.2);
    border-color: rgba(226, 232, 240, 0.3);
  }

  .modal-body {
    padding: 2rem;
  }

  .modal-footer {
    padding: 1.75rem 2rem;
    border-top: 1px solid rgba(226, 232, 240, 0.15);
    display: flex;
    justify-content: flex-end;
    gap: 0.75rem;
  }

  .btn-dark {
    padding: 0.75rem 1.5rem;
    background: rgba(0, 0, 0, 0.3);
    border: 1px solid rgba(226, 232, 240, 0.2);
    border-radius: 8px;
    color: #e2e8f0;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.3s;
  }

  .btn-dark:hover {
    background: rgba(0, 0, 0, 0.4);
  }

  .btn-light {
    padding: 0.75rem 1.5rem;
    background: rgba(226, 232, 240, 0.15);
    border: 1px solid rgba(226, 232, 240, 0.3);
    border-radius: 8px;
    color: #e2e8f0;
    cursor: pointer;
    font-weight: 700;
    transition: all 0.3s;
  }

  .btn-light:hover {
    background: rgba(226, 232, 240, 0.25);
    transform: translateY(-2px);
  }
</style>
