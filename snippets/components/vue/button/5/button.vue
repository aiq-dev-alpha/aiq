<template>
  <div class="split-btn-wrapper" ref="wrapper">
    <button
      :class="['split-btn-main', { disabled }]"
      :disabled="disabled"
      @click="$emit('click', $event)"
    >
      <slot />
    </button>
    <button
      :class="['split-btn-toggle', { disabled }]"
      :disabled="disabled"
      @click="toggleDropdown"
    >
      <span :class="['arrow', { open: isOpen }]">▼</span>
    </button>
    <Transition name="dropdown">
      <div v-if="isOpen" class="dropdown-menu">
        <button
          v-for="(option, index) in options"
          :key="index"
          class="dropdown-item"
          @click="handleOptionClick(option, $event)"
        >
          {{ option.label }}
        </button>
      </div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';

interface Option {
  label: string;
  value: string;
}

interface Props {
  options?: Option[];
  disabled?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  options: () => [],
  disabled: false
});

const emit = defineEmits<{
  click: [event: MouseEvent];
  optionClick: [option: Option, event: MouseEvent];
}>();

const isOpen = ref(false);
const wrapper = ref<HTMLElement | null>(null);

const toggleDropdown = () => {
  if (!props.disabled) {
    isOpen.value = !isOpen.value;
  }
};

const handleOptionClick = (option: Option, event: MouseEvent) => {
  emit('optionClick', option, event);
  isOpen.value = false;
};

const handleClickOutside = (event: MouseEvent) => {
  if (wrapper.value && !wrapper.value.contains(event.target as Node)) {
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
.split-btn-wrapper {
  position: relative;
  display: inline-flex;
}

.split-btn-main,
.split-btn-toggle {
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  border: none;
  cursor: pointer;
  transition: all 0.2s ease;
}

.split-btn-main {
  border-radius: 8px 0 0 8px;
  border-right: 1px solid rgba(255, 255, 255, 0.2);
}

.split-btn-toggle {
  padding: 0.75rem 1rem;
  border-radius: 0 8px 8px 0;
}

.split-btn-main:hover:not(.disabled),
.split-btn-toggle:hover:not(.disabled) {
  background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
}

.split-btn-main.disabled,
.split-btn-toggle.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.arrow {
  display: inline-block;
  transition: transform 0.2s ease;
  font-size: 0.75rem;
}

.arrow.open {
  transform: rotate(180deg);
}

.dropdown-menu {
  position: absolute;
  top: calc(100% + 4px);
  right: 0;
  min-width: 180px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
  overflow: hidden;
  z-index: 1000;
}

.dropdown-item {
  width: 100%;
  padding: 0.75rem 1rem;
  text-align: left;
  background: white;
  border: none;
  color: #374151;
  cursor: pointer;
  transition: background 0.15s ease;
  font-size: 0.875rem;
}

.dropdown-item:hover {
  background: #f3f4f6;
}

.dropdown-enter-active,
.dropdown-leave-active {
  transition: all 0.2s ease;
}

.dropdown-enter-from,
.dropdown-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}
</style>
