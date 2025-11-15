<script lang="ts">
  import { fade } from 'svelte/transition';
  import { createEventDispatcher, onMount, onDestroy } from 'svelte';
  import { quintOut } from 'svelte/easing';
  export interface ModalTheme {
    background?: string;
    overlay?: string;
    border?: string;
    shadow?: string;
  }
  export let isOpen = false;
  export let title = 'Modal';
  export let size: 'sm' | 'md' | 'lg' | 'xl' | 'full' = 'md';
  export let variant: 'default' | 'centered' | 'drawer' | 'fullscreen' | 'bottom-sheet' = 'fullscreen';
  export let closeOnOverlay = false;
  export let closeOnEsc = true;
  export let showCloseButton = true;
  export let theme: ModalTheme = {};
  const dispatch = createEventDispatcher();
  const defaultTheme: ModalTheme = {
    background: 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
    overlay: 'rgba(250, 112, 154, 0.95)',
    border: '#fee140',
    shadow: 'none'
  };
  $: appliedTheme = { ...defaultTheme, ...theme };
  function handleKeydown(event: KeyboardEvent) {
    if (closeOnEsc && event.key === 'Escape' && isOpen) {
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
  <div class="modal-fullscreen" style="background: {appliedTheme.background};" transition:fade={{ duration: 500, easing: quintOut }}>
    <div class="modal-header">
      <h2>{title}</h2>
      {#if showCloseButton}
        <button class="close-btn" on:click={close}>
          <span>ESC</span>
        </button>
      {/if}
    </div>
    <div class="modal-body">
      <slot />
    </div>
    <div class="modal-footer">
      <slot name="footer">
        <button class="btn-outline" on:click={close}>Close</button>
        <button class="btn-primary">Save</button>
      </slot>
    </div>
  </div>
{/if}
<style>
  .modal-fullscreen {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1000;
    color: white;
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }
  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 2rem 3rem;
    border-bottom: 2px solid rgba(255, 255, 255, 0.3);
  }
  .modal-header h2 {
    margin: 0;
    font-size: 2.5rem;
    font-weight: 900;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
  }
  .close-btn {
    background: rgba(0, 0, 0, 0.2);
    border: 2px solid rgba(255, 255, 255, 0.4);
    cursor: pointer;
    color: white;
    padding: 0.5rem 1.5rem;
    border-radius: 50px;
    font-weight: 700;
    font-size: 0.9rem;
    transition: all 0.3s;
  }
  .close-btn:hover {
    background: rgba(0, 0, 0, 0.3);
    border-color: rgba(255, 255, 255, 0.6);
    transform: scale(1.05);
  }
  .modal-body {
    flex: 1;
    padding: 3rem;
    overflow-y: auto;
  }
  .modal-footer {
    padding: 2rem 3rem;
    border-top: 2px solid rgba(255, 255, 255, 0.3);
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
  }
  .btn-outline {
    padding: 1rem 2rem;
    background: transparent;
    border: 2px solid rgba(255, 255, 255, 0.5);
    border-radius: 12px;
    color: white;
    cursor: pointer;
    font-weight: 700;
    transition: all 0.3s;
  }
  .btn-outline:hover {
    background: rgba(255, 255, 255, 0.1);
    border-color: white;
  }
  .btn-primary {
    padding: 1rem 2rem;
    background: rgba(255, 255, 255, 0.3);
    border: 2px solid rgba(255, 255, 255, 0.6);
    border-radius: 12px;
    color: white;
    cursor: pointer;
    font-weight: 700;
    transition: all 0.3s;
  }
  .btn-primary:hover {
    background: rgba(255, 255, 255, 0.4);
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
