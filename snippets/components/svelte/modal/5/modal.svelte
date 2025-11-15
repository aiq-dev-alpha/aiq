<script lang="ts">
  import { fade, scale } from 'svelte/transition';
  import { createEventDispatcher, onMount, onDestroy } from 'svelte';
  import { bounceOut } from 'svelte/easing';

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
    background: 'linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)',
    overlay: 'rgba(168, 237, 234, 0.4)',
    border: '#fed6e3',
    shadow: '0 30px 60px rgba(254, 214, 227, 0.5)'
  };

  $: appliedTheme = { ...defaultTheme, ...theme };
  $: modalWidth = size === 'sm' ? '380px' : size === 'md' ? '580px' : size === 'lg' ? '780px' : size === 'xl' ? '980px' : '100%';

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
    <div class="modal-content" style="max-width: {modalWidth}; background: {appliedTheme.background}; border: 3px solid {appliedTheme.border}; box-shadow: {appliedTheme.shadow};" on:click|stopPropagation transition:scale={{ duration: 600, start: 0.5, easing: bounceOut }}>
      <div class="modal-header">
        <h2>{title}</h2>
        {#if showCloseButton}
          <button class="close-btn" on:click={close}>
            <svg width="18" height="18" viewBox="0 0 18 18" fill="none" stroke="currentColor" stroke-width="2.5">
              <path d="M1 1L17 17M17 1L1 17" />
            </svg>
          </button>
        {/if}
      </div>

      <div class="modal-body">
        <slot />
      </div>

      <div class="modal-footer">
        <slot name="footer">
          <button class="btn-secondary" on:click={close}>Cancel</button>
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
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    backdrop-filter: blur(5px);
  }

  .modal-content {
    border-radius: 16px;
    width: 90%;
    max-height: 90vh;
    overflow: auto;
    color: #1a202c;
  }

  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1.75rem 2rem;
    border-bottom: 2px dashed rgba(254, 214, 227, 0.6);
  }

  .modal-header h2 {
    margin: 0;
    font-size: 1.75rem;
    font-weight: 800;
    color: #2d3748;
  }

  .close-btn {
    background: rgba(254, 214, 227, 0.3);
    border: 2px solid rgba(254, 214, 227, 0.6);
    cursor: pointer;
    color: #2d3748;
    width: 38px;
    height: 38px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s;
  }

  .close-btn:hover {
    background: rgba(254, 214, 227, 0.5);
    transform: rotate(90deg) scale(1.1);
  }

  .modal-body {
    padding: 2rem;
  }

  .modal-footer {
    padding: 1.75rem 2rem;
    border-top: 2px dashed rgba(254, 214, 227, 0.6);
    display: flex;
    justify-content: flex-end;
    gap: 0.75rem;
  }

  .btn-secondary {
    padding: 0.75rem 1.5rem;
    background: rgba(168, 237, 234, 0.3);
    border: 2px solid rgba(168, 237, 234, 0.6);
    border-radius: 10px;
    color: #2d3748;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.3s;
  }

  .btn-secondary:hover {
    background: rgba(168, 237, 234, 0.5);
  }

  .btn-primary {
    padding: 0.75rem 1.5rem;
    background: rgba(254, 214, 227, 0.5);
    border: 2px solid rgba(254, 214, 227, 0.8);
    border-radius: 10px;
    color: #2d3748;
    cursor: pointer;
    font-weight: 700;
    transition: all 0.3s;
  }

  .btn-primary:hover {
    background: rgba(254, 214, 227, 0.7);
    transform: translateY(-2px);
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
