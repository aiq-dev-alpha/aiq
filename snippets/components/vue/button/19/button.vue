<template>
  <div class="share-btn-wrapper" ref="wrapper">
    <button
      :class="['share-btn', { disabled }]"
      :disabled="disabled"
      @click="toggleShare"
    >
      <span class="share-icon">📤</span>
      <span><slot>Share</slot></span>
    </button>
    <Transition name="platforms">
      <div v-if="isOpen" class="platforms">
        <button
          v-for="platform in platforms"
          :key="platform.name"
          :class="['platform-btn', platform.name.toLowerCase()]"
          @click="handleShare(platform)"
        >
          <span class="platform-icon">{{ platform.icon }}</span>
        </button>
      </div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';

interface Platform {
  name: string;
  icon: string;
  url: string;
}

interface Props {
  platforms?: Platform[];
  disabled?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  platforms: () => [
    { name: 'Twitter', icon: '𝕏', url: 'https://twitter.com/share' },
    { name: 'Facebook', icon: 'f', url: 'https://facebook.com/share' },
    { name: 'LinkedIn', icon: 'in', url: 'https://linkedin.com/share' }
  ],
  disabled: false
});

const emit = defineEmits<{
  share: [platform: Platform];
}>();

const wrapper = ref<HTMLElement | null>(null);
const isOpen = ref(false);

const toggleShare = () => {
  if (!props.disabled) {
    isOpen.value = !isOpen.value;
  }
};

const handleShare = (platform: Platform) => {
  emit('share', platform);
  isOpen.value = false;
};

const handleClickOutside = (e: MouseEvent) => {
  if (wrapper.value && !wrapper.value.contains(e.target as Node)) {
    isOpen.value = false;
  }
};

onMounted(() => {
  document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside);
});
</script>

<style scoped>
.share-btn-wrapper {
  position: relative;
  display: inline-block;
}

.share-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.875rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.share-btn:hover:not(.disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.3);
}

.share-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.platforms {
  position: absolute;
  top: calc(100% + 8px);
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 0.5rem;
  padding: 0.5rem;
  background: white;
  border-radius: 12px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
}

.platform-btn {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: bold;
  transition: transform 0.2s ease;
}

.platform-btn:hover {
  transform: scale(1.1);
}

.platform-btn.twitter {
  background: #000000;
  color: white;
}

.platform-btn.facebook {
  background: #1877f2;
  color: white;
}

.platform-btn.linkedin {
  background: #0a66c2;
  color: white;
}

.platforms-enter-active,
.platforms-leave-active {
  transition: all 0.2s ease;
}

.platforms-enter-from,
.platforms-leave-to {
  opacity: 0;
  transform: translateX(-50%) translateY(-8px);
}
</style>