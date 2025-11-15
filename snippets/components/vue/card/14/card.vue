<template>
  <div class="timeline-item" :class="position">
    <div class="timeline-marker">
      <div class="marker-dot" :class="status">
        <span v-if="status === 'completed'">✓</span>
        <span v-else-if="status === 'active'">●</span>
      </div>
      <div v-if="!isLast" class="connector-line" :class="status"></div>
    </div>
    <div class="timeline-content">
      <div class="content-header">
        <h4 class="event-title">{{ title }}</h4>
        <time class="event-time">{{ timestamp }}</time>
      </div>
      <p class="event-description">{{ description }}</p>
      <div v-if="metadata" class="event-metadata">
        <span v-for="(value, key) in metadata" :key="key" class="meta-item">
          <strong>{{ key }}:</strong> {{ value }}
        </span>
      </div>
      <div v-if="attachments" class="attachments">
        <div v-for="(file, i) in attachments" :key="i" class="attachment-item">
          📎 {{ file.name }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Attachment {
  name: string;
  url: string;
}

interface Props {
  title: string;
  timestamp: string;
  description: string;
  status: 'completed' | 'active' | 'pending';
  position?: 'left' | 'right';
  isLast?: boolean;
  metadata?: Record<string, string>;
  attachments?: Attachment[];
}

withDefaults(defineProps<Props>(), {
  position: 'right',
  isLast: false
});
</script>

<style scoped>
.timeline-item {
  display: grid;
  grid-template-columns: auto 1fr;
  gap: 2rem;
  position: relative;
}

.timeline-item.left {
  grid-template-columns: 1fr auto;
}

.timeline-item.left .timeline-content {
  order: -1;
  text-align: right;
}

.timeline-marker {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.marker-dot {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 3px solid;
  background: white;
  z-index: 2;
  font-weight: 700;
}

.marker-dot.completed {
  border-color: #10b981;
  color: #10b981;
}

.marker-dot.active {
  border-color: #3b82f6;
  color: #3b82f6;
  animation: pulse 2s infinite;
}

.marker-dot.pending {
  border-color: #e5e7eb;
  color: #9ca3af;
}

.connector-line {
  width: 3px;
  flex: 1;
  min-height: 60px;
  background: #e5e7eb;
  margin-top: 8px;
}

.connector-line.completed {
  background: #10b981;
}

.connector-line.active {
  background: linear-gradient(to bottom, #3b82f6, #e5e7eb);
}

.timeline-content {
  padding-bottom: 2rem;
}

.content-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.75rem;
}

.event-title {
  margin: 0;
  font-size: 1.125rem;
  font-weight: 700;
  color: #111827;
}

.event-time {
  font-size: 0.875rem;
  color: #6b7280;
}

.event-description {
  color: #4b5563;
  line-height: 1.6;
  margin: 0 0 1rem 0;
}

.event-metadata {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 1rem;
}

.meta-item {
  font-size: 0.875rem;
  color: #6b7280;
}

.attachments {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.attachment-item {
  display: inline-flex;
  align-items: center;
  padding: 0.5rem;
  background: #f3f4f6;
  border-radius: 6px;
  font-size: 0.875rem;
  color: #374151;
}

@keyframes pulse {
  0%, 100% {
    box-shadow: 0 0 0 0 rgba(59, 130, 246, 0.7);
  }
  50% {
    box-shadow: 0 0 0 10px rgba(59, 130, 246, 0);
  }
}
</style>