<script lang="ts">
  import { writable } from 'svelte/store';
  import { fly } from 'svelte/transition';

  // Password Strength Input - Unique in USE CASE (password validation), CAPABILITIES (strength meter), FEEL (real-time feedback)
  export let value: string = '';
  export let placeholder: string = 'Enter password';
  export let label: string = 'Password';
  export let showStrength: boolean = true;
  export let showRequirements: boolean = true;
  export let disabled: boolean = false;
  export let minLength: number = 8;

  let showPassword = false;
  let focused = false;

  interface PasswordRequirement {
    label: string;
    test: (pwd: string) => boolean;
    met: boolean;
  }

  $: requirements: PasswordRequirement[] = [
    { label: `At least ${minLength} characters`, test: (p) => p.length >= minLength, met: value.length >= minLength },
    { label: 'Contains uppercase letter', test: (p) => /[A-Z]/.test(p), met: /[A-Z]/.test(value) },
    { label: 'Contains lowercase letter', test: (p) => /[a-z]/.test(p), met: /[a-z]/.test(value) },
    { label: 'Contains number', test: (p) => /[0-9]/.test(p), met: /[0-9]/.test(value) },
    { label: 'Contains special character', test: (p) => /[^A-Za-z0-9]/.test(p), met: /[^A-Za-z0-9]/.test(value) }
  ];

  $: metRequirements = requirements.filter(r => r.met).length;
  $: strength = value.length === 0 ? 0 : Math.min(100, (metRequirements / requirements.length) * 100);
  $: strengthLevel = strength === 0 ? 'none' : strength < 40 ? 'weak' : strength < 70 ? 'medium' : 'strong';

  const strengthColors = {
    none: '#e5e7eb',
    weak: '#ef4444',
    medium: '#f59e0b',
    strong: '#10b981'
  };

  const strengthLabels = {
    none: '',
    weak: 'Weak',
    medium: 'Medium',
    strong: 'Strong'
  };
</script>

<div class="password-input-wrapper">
  {#if label}
    <label class="password-label">{label}</label>
  {/if}

  <div class="password-input-container">
    <input
      type={showPassword ? 'text' : 'password'}
      bind:value
      {placeholder}
      {disabled}
      on:focus={() => focused = true}
      on:blur={() => focused = false}
      class="password-input"
      class:focused
    />

    <button
      class="toggle-password"
      on:click={() => showPassword = !showPassword}
      type="button"
      disabled={disabled}
      aria-label={showPassword ? 'Hide password' : 'Show password'}
    >
      {#if showPassword}
        <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
          <path d="M3 3L17 17M10 7C11.66 7 13 8.34 13 10C13 10.34 12.94 10.66 12.84 10.96M7.16 9.04C7.06 9.34 7 9.66 7 10C7 11.66 8.34 13 10 13C10.34 13 10.66 12.94 10.96 12.84M10 4C14.42 4 18 10 18 10C17.27 11.2 16.33 12.28 15.22 13.17M4.78 6.83C3.67 7.72 2.73 8.8 2 10C2 10 5.58 16 10 16C11.22 16 12.36 15.69 13.4 15.15" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
        </svg>
      {:else}
        <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
          <path d="M2 10C2 10 5.58 4 10 4C14.42 4 18 10 18 10C18 10 14.42 16 10 16C5.58 16 2 10 2 10Z" stroke="currentColor" stroke-width="2"/>
          <circle cx="10" cy="10" r="3" stroke="currentColor" stroke-width="2"/>
        </svg>
      {/if}
    </button>
  </div>

  {#if showStrength && value.length > 0}
    <div class="strength-indicator" transition:fly="{{ y: -5, duration: 200 }}">
      <div class="strength-bar-container">
        <div
          class="strength-bar"
          style="width: {strength}%; background-color: {strengthColors[strengthLevel]};"
        ></div>
      </div>
      {#if strengthLevel !== 'none'}
        <span class="strength-label" style="color: {strengthColors[strengthLevel]};">
          {strengthLabels[strengthLevel]}
        </span>
      {/if}
    </div>
  {/if}

  {#if showRequirements && (focused || value.length > 0)}
    <div class="requirements-list" transition:fly="{{ y: -5, duration: 200 }}">
      {#each requirements as requirement}
        <div class="requirement" class:met={requirement.met}>
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
            {#if requirement.met}
              <circle cx="8" cy="8" r="7" fill="#10b981"/>
              <path d="M5 8L7 10L11 6" stroke="white" stroke-width="2" stroke-linecap="round"/>
            {:else}
              <circle cx="8" cy="8" r="7" stroke="#d1d5db" stroke-width="2" fill="none"/>
            {/if}
          </svg>
          <span>{requirement.label}</span>
        </div>
      {/each}
    </div>
  {/if}
</div>

<style>
  .password-input-wrapper {
    width: 100%;
  }

  .password-label {
    display: block;
    margin-bottom: 0.5rem;
    font-size: 0.875rem;
    font-weight: 600;
    color: #1f2937;
  }

  .password-input-container {
    position: relative;
    display: flex;
    align-items: center;
  }

  .password-input {
    width: 100%;
    padding: 0.75rem 3rem 0.75rem 1rem;
    font-size: 1rem;
    border: 2px solid #e5e7eb;
    border-radius: 10px;
    outline: none;
    transition: all 0.2s ease;
    background: white;
  }

  .password-input:hover:not(:disabled) {
    border-color: #cbd5e1;
  }

  .password-input.focused {
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
  }

  .password-input:disabled {
    background: #f9fafb;
    cursor: not-allowed;
  }

  .toggle-password {
    position: absolute;
    right: 0.75rem;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0.25rem;
    border: none;
    background: none;
    cursor: pointer;
    color: #6b7280;
    transition: color 0.2s ease;
  }

  .toggle-password:hover:not(:disabled) {
    color: #374151;
  }

  .toggle-password:disabled {
    cursor: not-allowed;
    opacity: 0.5;
  }

  .strength-indicator {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    margin-top: 0.5rem;
  }

  .strength-bar-container {
    flex: 1;
    height: 6px;
    background: #e5e7eb;
    border-radius: 3px;
    overflow: hidden;
  }

  .strength-bar {
    height: 100%;
    transition: all 0.3s ease;
    border-radius: 3px;
  }

  .strength-label {
    font-size: 0.875rem;
    font-weight: 600;
    min-width: 60px;
    text-align: right;
  }

  .requirements-list {
    margin-top: 0.75rem;
    padding: 0.75rem;
    background: #f9fafb;
    border-radius: 8px;
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  .requirement {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.875rem;
    color: #6b7280;
    transition: color 0.2s ease;
  }

  .requirement.met {
    color: #10b981;
  }
</style>
