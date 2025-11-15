<template>
  <div :class="['skeleton-card', { loading }]">
    <div v-if="loading" class="skeleton-content">
      <div class="skeleton-header">
        <div class="skeleton-avatar shimmer"></div>
        <div class="skeleton-title-group">
          <div class="skeleton-title shimmer"></div>
          <div class="skeleton-subtitle shimmer"></div>
        </div>
      </div>
      <div class="skeleton-body">
        <div class="skeleton-line shimmer"></div>
        <div class="skeleton-line shimmer"></div>
        <div class="skeleton-line short shimmer"></div>
      </div>
      <div class="skeleton-footer">
        <div class="skeleton-button shimmer"></div>
        <div class="skeleton-button shimmer"></div>
      </div>
    </div>
    <div v-else class="actual-content">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  loading?: boolean;
}

withDefaults(defineProps<Props>(), {
  loading: false
});
</script>

<style scoped>
.skeleton-card {
  background: white;
  border-radius: 16px;
  padding: 1.5rem;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
}

.skeleton-header {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.skeleton-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: #e5e7eb;
}

.skeleton-title-group {
  flex: 1;
}

.skeleton-title {
  width: 60%;
  height: 16px;
  margin-bottom: 0.5rem;
  background: #e5e7eb;
  border-radius: 4px;
}

.skeleton-subtitle {
  width: 40%;
  height: 12px;
  background: #e5e7eb;
  border-radius: 4px;
}

.skeleton-body {
  margin-bottom: 1.5rem;
}

.skeleton-line {
  width: 100%;
  height: 12px;
  margin-bottom: 0.75rem;
  background: #e5e7eb;
  border-radius: 4px;
}

.skeleton-line.short {
  width: 70%;
}

.skeleton-footer {
  display: flex;
  gap: 1rem;
}

.skeleton-button {
  width: 100px;
  height: 36px;
  background: #e5e7eb;
  border-radius: 8px;
}

.shimmer {
  position: relative;
  overflow: hidden;
}

.shimmer::after {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.6),
    transparent
  );
  animation: shimmer-animation 1.5s infinite;
}

@keyframes shimmer-animation {
  to {
    left: 100%;
  }
}

.actual-content {
  animation: fade-in 0.3s ease;
}

@keyframes fade-in {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}
</style>
