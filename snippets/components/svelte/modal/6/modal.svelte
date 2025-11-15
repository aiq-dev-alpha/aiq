<script lang="ts">
  import { fade, fly } from 'svelte/transition';
  import { createEventDispatcher, onMount, onDestroy } from 'svelte';
  import { backOut } from 'svelte/easing';

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
    background: 'linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #ffecd2 100%)',
    overlay: 'rgba(255, 154, 158, 0.25)',
    border: '#fecfef',
    shadow: '0 20px 70px rgba(254, 207, 239, 0.4)'
  };

  $: appliedTheme = { ...defaultTheme, ...theme };
  $: modalWidth = size === 'sm' ? '320px' : size === 'md' ? '420px' : size === 'lg' ? '520px' : size === 'xl' ? '620px' : '100%';

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
    <div class="modal-drawer" style="width: {modalWidth}; background: {appliedTheme.background}; border-right: 4px solid {appliedTheme.border}; box-shadow: {appliedTheme.shadow};" on:click|stopPropagation transition:fly={{ x: -400, duration: 450, easing: backOut }}>
      <div class="modal-header">
        <h2>{title}</h2>
        {#if showCloseButton}
          <button class="close-btn" on:click={close}>
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round">
              <line x1="6" y1="18" x2="18" y2="6"></line>
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
          <button class="btn-tertiary" on:click={close}>Dismiss</button>
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
    backdrop-filter: blur(6px);
  }

  .modal-drawer {
    position: fixed;
    top: 0;
    left: 0;
    height: 100%;
    overflow-y: auto;
    color: #2d3748;
    display: flex;
    flex-direction: column;
  }

  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 2rem 1.75rem 1.25rem;
    border-bottom: 2px solid rgba(254, 207, 239, 0.5);
  }

  .modal-header h2 {
    margin: 0;
    font-size: 1.85rem;
    font-weight: 900;
    letter-spacing: -0.02em;
  }

  .close-btn {
    background: rgba(255, 154, 158, 0.2);
    border: 2px solid rgba(255, 154, 158, 0.4);
    cursor: pointer;
    color: #2d3748;
    width: 42px;
    height: 42px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s;
  }

  .close-btn:hover {
    background: rgba(255, 154, 158, 0.3);
    border-color: rgba(255, 154, 158, 0.6);
    transform: rotate(180deg);
  }

  .modal-body {
    flex: 1;
    padding: 1.75rem;
    overflow-y: auto;
  }

  .modal-footer {
    padding: 1.75rem;
    border-top: 2px solid rgba(254, 207, 239, 0.5);
    display: flex;
    justify-content: center;
  }

  .btn-tertiary {
    padding: 0.85rem 2rem;
    background: rgba(254, 207, 239, 0.4);
    border: 2px solid rgba(254, 207, 239, 0.7);
    border-radius: 50px;
    color: #2d3748;
    cursor: pointer;
    font-weight: 700;
    font-size: 1.05rem;
    transition: all 0.3s;
  }

  .btn-tertiary:hover {
    background: rgba(254, 207, 239, 0.6);
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
