<script lang="ts">
  import { fade, scale } from 'svelte/transition';
  import { createEventDispatcher, onMount, onDestroy } from 'svelte';
  import { elasticOut } from 'svelte/easing';

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
    background: 'linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%)',
    overlay: 'rgba(132, 250, 176, 0.35)',
    border: '#8fd3f4',
    shadow: '0 35px 70px rgba(143, 211, 244, 0.45)'
  };

  $: appliedTheme = { ...defaultTheme, ...theme };
  $: modalWidth = size === 'sm' ? '360px' : size === 'md' ? '540px' : size === 'lg' ? '720px' : size === 'xl' ? '900px' : '100%';

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
  <div class="modal-overlay" style="background: {appliedTheme.overlay};" on:click={handleOverlayClick} transition:fade={{ duration: 320 }}>
    <div class="modal-content" style="max-width: {modalWidth}; background: {appliedTheme.background}; border: 4px solid {appliedTheme.border}; box-shadow: {appliedTheme.shadow};" on:click|stopPropagation transition:scale={{ duration: 800, start: 0.3, easing: elasticOut }}>
      <div class="modal-header">
        <h2>{title}</h2>
        {#if showCloseButton}
          <button class="close-btn" on:click={close}>
            <span class="close-icon">✕</span>
          </button>
        {/if}
      </div>

      <div class="modal-body">
        <slot />
      </div>

      <div class="modal-footer">
        <slot name="footer">
          <button class="btn-ghost" on:click={close}>Maybe Later</button>
          <button class="btn-primary">Continue</button>
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
    backdrop-filter: blur(8px);
  }

  .modal-content {
    border-radius: 24px;
    width: 90%;
    max-height: 90vh;
    overflow: auto;
    color: #1a365d;
  }

  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 2rem 2.25rem;
    border-bottom: 3px dotted rgba(143, 211, 244, 0.4);
  }

  .modal-header h2 {
    margin: 0;
    font-size: 2rem;
    font-weight: 900;
  }

  .close-btn {
    background: rgba(143, 211, 244, 0.3);
    border: 3px solid rgba(143, 211, 244, 0.5);
    cursor: pointer;
    color: #1a365d;
    width: 44px;
    height: 44px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s;
  }

  .close-icon {
    font-size: 1.5rem;
    font-weight: 700;
  }

  .close-btn:hover {
    background: rgba(143, 211, 244, 0.5);
    transform: rotate(180deg) scale(1.15);
  }

  .modal-body {
    padding: 2.25rem;
  }

  .modal-footer {
    padding: 2rem 2.25rem;
    border-top: 3px dotted rgba(143, 211, 244, 0.4);
    display: flex;
    justify-content: space-between;
    gap: 1rem;
  }

  .btn-ghost {
    padding: 0.85rem 1.75rem;
    background: transparent;
    border: 2px solid rgba(132, 250, 176, 0.5);
    border-radius: 12px;
    color: #1a365d;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.3s;
  }

  .btn-ghost:hover {
    background: rgba(132, 250, 176, 0.2);
    border-color: rgba(132, 250, 176, 0.8);
  }

  .btn-primary {
    padding: 0.85rem 1.75rem;
    background: rgba(143, 211, 244, 0.5);
    border: 2px solid rgba(143, 211, 244, 0.8);
    border-radius: 12px;
    color: #1a365d;
    cursor: pointer;
    font-weight: 700;
    transition: all 0.3s;
  }

  .btn-primary:hover {
    background: rgba(143, 211, 244, 0.7);
    transform: translateY(-3px);
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
