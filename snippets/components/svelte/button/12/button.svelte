<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { writable, derived } from 'svelte/store';

  // Split Button - Unique in STRUCTURE (main + dropdown), USE CASE (multi-action), CAPABILITIES (action menu)
  export let variant: 'primary' | 'secondary' | 'success' | 'danger' | 'warning' | 'info' = 'primary';
  export let size: 'sm' | 'md' | 'lg' = 'md';
  export let disabled: boolean = false;
  export let actions: Array<{ label: string; value: string; icon?: string }> = [];
  export let mainLabel: string = 'Action';

  const dispatch = createEventDispatcher();
  const menuOpen = writable(false);
  const selectedIndex = writable(0);

  const variants = {
    primary: { bg: '#3b82f6', hover: '#2563eb', text: 'white' },
    secondary: { bg: '#8b5cf6', hover: '#7c3aed', text: 'white' },
    success: { bg: '#10b981', hover: '#059669', text: 'white' },
    danger: { bg: '#ef4444', hover: '#dc2626', text: 'white' },
    warning: { bg: '#f59e0b', hover: '#d97706', text: 'white' },
    info: { bg: '#06b6d4', hover: '#0891b2', text: 'white' }
  };

  const sizes = {
    sm: { btn: 'px-3 py-1.5 text-sm', dropdown: 'px-2', menu: 'text-sm' },
    md: { btn: 'px-4 py-2 text-base', dropdown: 'px-3', menu: 'text-base' },
    lg: { btn: 'px-6 py-3 text-lg', dropdown: 'px-4', menu: 'text-lg' }
  };

  function handleMainClick() {
    if (!disabled) {
      const action = actions[0] || { value: 'default', label: mainLabel };
      dispatch('action', { value: action.value });
      dispatch('click');
    }
  }

  function toggleMenu() {
    if (!disabled && actions.length > 0) {
      menuOpen.update(v => !v);
    }
  }

  function selectAction(index: number) {
    selectedIndex.set(index);
    const action = actions[index];
    dispatch('action', { value: action.value });
    menuOpen.set(false);
  }

  function handleClickOutside(event: MouseEvent) {
    if ($menuOpen) {
      menuOpen.set(false);
    }
  }
</script>

<svelte:window on:click={handleClickOutside} />

<div class="split-button-container">
  <div class="split-button {variant} {size}">
    <button
      class="split-button-main {sizes[size].btn}"
      on:click|stopPropagation={handleMainClick}
      {disabled}
      type="button"
      style="background: {variants[variant].bg}; color: {variants[variant].text};"
    >
      <slot>{mainLabel}</slot>
    </button>

    {#if actions.length > 0}
      <button
        class="split-button-dropdown {sizes[size].dropdown}"
        on:click|stopPropagation={toggleMenu}
        {disabled}
        type="button"
        style="background: {variants[variant].bg}; color: {variants[variant].text};"
      >
        <svg
          class="dropdown-icon"
          class:open={$menuOpen}
          width="12"
          height="12"
          viewBox="0 0 12 12"
          fill="none"
        >
          <path d="M2 4L6 8L10 4" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
        </svg>
      </button>
    {/if}
  </div>

  {#if $menuOpen && actions.length > 0}
    <div class="split-button-menu {sizes[size].menu}" on:click|stopPropagation>
      {#each actions as action, index}
        <button
          class="menu-item"
          on:click={() => selectAction(index)}
          type="button"
        >
          {#if action.icon}
            <span class="menu-icon">{action.icon}</span>
          {/if}
          <span>{action.label}</span>
        </button>
      {/each}
    </div>
  {/if}
</div>

<style>
  .split-button-container {
    position: relative;
    display: inline-block;
  }

  .split-button {
    display: flex;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }

  .split-button-main {
    border: none;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
    border-right: 1px solid rgba(255, 255, 255, 0.2);
  }

  .split-button-main:hover:not(:disabled) {
    filter: brightness(1.1);
  }

  .split-button-main:active:not(:disabled) {
    transform: translateY(1px);
  }

  .split-button-dropdown {
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;
  }

  .split-button-dropdown:hover:not(:disabled) {
    filter: brightness(1.1);
  }

  .dropdown-icon {
    transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  }

  .dropdown-icon.open {
    transform: rotate(180deg);
  }

  .split-button-menu {
    position: absolute;
    top: calc(100% + 4px);
    right: 0;
    background: white;
    border-radius: 8px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    min-width: 150px;
    overflow: hidden;
    animation: slideDown 0.2s ease;
    z-index: 1000;
  }

  @keyframes slideDown {
    from {
      opacity: 0;
      transform: translateY(-10px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .menu-item {
    width: 100%;
    padding: 10px 16px;
    border: none;
    background: white;
    text-align: left;
    cursor: pointer;
    transition: background 0.2s ease;
    display: flex;
    align-items: center;
    gap: 8px;
    color: #1f2937;
    font-weight: 500;
  }

  .menu-item:hover {
    background: #f3f4f6;
  }

  .menu-item:active {
    background: #e5e7eb;
  }

  .menu-icon {
    font-size: 1.1em;
  }

  .split-button button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
