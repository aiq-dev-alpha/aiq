<script lang="ts">
  import { writable } from 'svelte/store';
  import { fly, scale } from 'svelte/transition';

  // Expandable Accordion Card - Unique in STRUCTURE (collapsible sections), USE CASE (FAQs/content organization), CAPABILITIES (multi-section)
  export let sections: Array<{ title: string; content?: string; expanded?: boolean }> = [];
  export let allowMultiple: boolean = false;
  export let variant: 'default' | 'bordered' | 'elevated' = 'default';

  const expandedSections = writable<Set<number>>(new Set(
    sections.map((s, i) => s.expanded ? i : -1).filter(i => i >= 0)
  ));

  function toggleSection(index: number) {
    expandedSections.update(set => {
      const newSet = allowMultiple ? new Set(set) : new Set<number>();
      if (set.has(index)) {
        newSet.delete(index);
      } else {
        newSet.add(index);
      }
      return newSet;
    });
  }
</script>

<div class="accordion-card variant-{variant}">
  {#each sections as section, index}
    <div class="accordion-section" class:expanded={$expandedSections.has(index)}>
      <button
        class="accordion-header"
        on:click={() => toggleSection(index)}
        type="button"
      >
        <span class="accordion-title">{section.title}</span>
        <svg
          class="accordion-icon"
          class:rotated={$expandedSections.has(index)}
          width="20"
          height="20"
          viewBox="0 0 20 20"
          fill="none"
        >
          <path d="M6 8L10 12L14 8" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </button>

      {#if $expandedSections.has(index)}
        <div class="accordion-content" transition:fly="{{ y: -10, duration: 300 }}">
          {#if section.content}
            <p>{section.content}</p>
          {:else}
            <slot name="section-{index}" />
          {/if}
        </div>
      {/if}
    </div>
  {/each}
</div>

<style>
  .accordion-card {
    background: white;
    overflow: hidden;
  }

  .variant-default {
    border-radius: 12px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  }

  .variant-bordered {
    border: 2px solid #e5e7eb;
    border-radius: 12px;
  }

  .variant-elevated {
    border-radius: 12px;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  }

  .accordion-section {
    border-bottom: 1px solid #e5e7eb;
    transition: background-color 0.2s ease;
  }

  .accordion-section:last-child {
    border-bottom: none;
  }

  .accordion-section:hover {
    background-color: #f9fafb;
  }

  .accordion-section.expanded {
    background-color: #f0f9ff;
  }

  .accordion-header {
    width: 100%;
    padding: 1.25rem 1.5rem;
    background: none;
    border: none;
    display: flex;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
    text-align: left;
    transition: all 0.2s ease;
  }

  .accordion-header:hover {
    background-color: rgba(0, 0, 0, 0.02);
  }

  .accordion-title {
    font-size: 1rem;
    font-weight: 600;
    color: #111827;
  }

  .accordion-icon {
    color: #6b7280;
    transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
    flex-shrink: 0;
  }

  .accordion-icon.rotated {
    transform: rotate(180deg);
    color: #3b82f6;
  }

  .accordion-content {
    padding: 0 1.5rem 1.25rem 1.5rem;
    color: #4b5563;
    line-height: 1.6;
  }

  .accordion-content p {
    margin: 0;
  }
</style>
