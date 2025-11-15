<script lang="ts">
  import { writable, derived } from 'svelte/store';
  import { flip } from 'svelte/animate';
  import { fade, scale } from 'svelte/transition';

  // Kanban/Draggable Card - Unique in CAPABILITIES (drag & drop), USE CASE (task boards), FEEL (interactive dragging)
  export let title: string = '';
  export let items: Array<{ id: string | number; content: string; priority?: 'low' | 'medium' | 'high' }> = [];
  export let draggable: boolean = true;
  export let onReorder: (newItems: typeof items) => void = () => {};

  let draggedItem: typeof items[0] | null = null;
  let dragOverIndex = writable<number | null>(null);

  const priorityColors = {
    low: '#10b981',
    medium: '#f59e0b',
    high: '#ef4444'
  };

  function handleDragStart(event: DragEvent, item: typeof items[0]) {
    if (!draggable) return;
    draggedItem = item;
    if (event.dataTransfer) {
      event.dataTransfer.effectAllowed = 'move';
    }
  }

  function handleDragOver(event: DragEvent, index: number) {
    if (!draggable) return;
    event.preventDefault();
    dragOverIndex.set(index);
  }

  function handleDragLeave() {
    dragOverIndex.set(null);
  }

  function handleDrop(event: DragEvent, dropIndex: number) {
    if (!draggable || !draggedItem) return;
    event.preventDefault();

    const dragIndex = items.findIndex(i => i.id === draggedItem!.id);
    if (dragIndex === -1 || dragIndex === dropIndex) {
      draggedItem = null;
      dragOverIndex.set(null);
      return;
    }

    const newItems = [...items];
    const [removed] = newItems.splice(dragIndex, 1);
    newItems.splice(dropIndex, 0, removed);

    items = newItems;
    onReorder(newItems);

    draggedItem = null;
    dragOverIndex.set(null);
  }

  function handleDragEnd() {
    draggedItem = null;
    dragOverIndex.set(null);
  }
</script>

<div class="kanban-card">
  {#if title}
    <div class="kanban-header">
      <h3>{title}</h3>
      <span class="item-count">{items.length}</span>
    </div>
  {/if}

  <div class="kanban-body">
    {#if items.length === 0}
      <div class="empty-state" transition:fade>
        <p>No items yet. Add some tasks!</p>
      </div>
    {:else}
      {#each items as item, index (item.id)}
        <div
          class="kanban-item"
          class:drag-over={$dragOverIndex === index}
          class:dragging={draggedItem?.id === item.id}
          draggable={draggable}
          on:dragstart={(e) => handleDragStart(e, item)}
          on:dragover={(e) => handleDragOver(e, index)}
          on:dragleave={handleDragLeave}
          on:drop={(e) => handleDrop(e, index)}
          on:dragend={handleDragEnd}
          animate:flip={{ duration: 300 }}
          transition:scale={{ duration: 200 }}
        >
          {#if item.priority}
            <div class="priority-indicator" style="background-color: {priorityColors[item.priority]}"></div>
          {/if}
          <div class="item-content">
            <slot name="item" {item}>
              {item.content}
            </slot>
          </div>
          {#if draggable}
            <div class="drag-handle">
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <circle cx="6" cy="4" r="1.5" fill="currentColor"/>
                <circle cx="10" cy="4" r="1.5" fill="currentColor"/>
                <circle cx="6" cy="8" r="1.5" fill="currentColor"/>
                <circle cx="10" cy="8" r="1.5" fill="currentColor"/>
                <circle cx="6" cy="12" r="1.5" fill="currentColor"/>
                <circle cx="10" cy="12" r="1.5" fill="currentColor"/>
              </svg>
            </div>
          {/if}
        </div>
      {/each}
    {/if}
  </div>
</div>

<style>
  .kanban-card {
    background: #f8fafc;
    border-radius: 12px;
    border: 1px solid #e2e8f0;
    overflow: hidden;
    min-height: 200px;
  }

  .kanban-header {
    padding: 1rem 1.25rem;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .kanban-header h3 {
    margin: 0;
    font-size: 1.125rem;
    font-weight: 700;
  }

  .item-count {
    background: rgba(255, 255, 255, 0.2);
    padding: 0.25rem 0.75rem;
    border-radius: 12px;
    font-size: 0.875rem;
    font-weight: 600;
  }

  .kanban-body {
    padding: 1rem;
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
    min-height: 150px;
  }

  .empty-state {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 150px;
    color: #94a3b8;
    font-style: italic;
  }

  .empty-state p {
    margin: 0;
  }

  .kanban-item {
    background: white;
    border: 2px solid #e2e8f0;
    border-radius: 8px;
    padding: 0.875rem;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    cursor: grab;
    transition: all 0.2s ease;
    position: relative;
  }

  .kanban-item:hover {
    border-color: #cbd5e1;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  }

  .kanban-item.dragging {
    opacity: 0.5;
    cursor: grabbing;
    transform: rotate(2deg);
  }

  .kanban-item.drag-over {
    border-color: #3b82f6;
    border-style: dashed;
    background: #eff6ff;
  }

  .priority-indicator {
    width: 4px;
    height: 100%;
    position: absolute;
    left: 0;
    top: 0;
    border-radius: 8px 0 0 8px;
  }

  .item-content {
    flex: 1;
    color: #334155;
    line-height: 1.5;
  }

  .drag-handle {
    color: #94a3b8;
    flex-shrink: 0;
    display: flex;
    align-items: center;
  }

  .drag-handle:hover {
    color: #64748b;
  }
</style>
