<template>
  <div class="search-input-wrapper">
    <div class="search-container">
      <span class="search-icon">🔍</span>
      <input
        v-model="searchQuery"
        type="text"
        class="search-input"
        :placeholder="placeholder"
        @input="handleInput"
        @focus="showResults = true"
      />
      <button v-if="searchQuery" class="clear-btn" @click="clearSearch">×</button>
    </div>
    <Transition name="dropdown">
      <div v-if="showResults && filteredResults.length > 0" class="results-dropdown">
        <div
          v-for="(result, i) in filteredResults"
          :key="i"
          class="result-item"
          @click="selectResult(result)"
        >
          {{ result }}
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';

interface Props {
  placeholder?: string;
  suggestions?: string[];
}

const props = withDefaults(defineProps<Props>(), {
  placeholder: 'Search...',
  suggestions: () => []
});

const emit = defineEmits<{
  search: [query: string];
  select: [result: string];
}>();

const searchQuery = ref('');
const showResults = ref(false);

const filteredResults = computed(() => {
  if (!searchQuery.value) return [];
  return props.suggestions.filter(s =>
    s.toLowerCase().includes(searchQuery.value.toLowerCase())
  ).slice(0, 5);
});

const handleInput = () => {
  emit('search', searchQuery.value);
};

const selectResult = (result: string) => {
  searchQuery.value = result;
  showResults.value = false;
  emit('select', result);
};

const clearSearch = () => {
  searchQuery.value = '';
  emit('search', '');
};
</script>

<style scoped>
.search-input-wrapper {
  position: relative;
  width: 100%;
}

.search-container {
  position: relative;
  display: flex;
  align-items: center;
}

.search-icon {
  position: absolute;
  left: 1rem;
  font-size: 1.25rem;
  pointer-events: none;
}

.search-input {
  width: 100%;
  padding: 0.875rem 3rem 0.875rem 3rem;
  font-size: 1rem;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  outline: none;
  transition: all 0.2s;
}

.search-input:focus {
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.clear-btn {
  position: absolute;
  right: 1rem;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #e5e7eb;
  border: none;
  border-radius: 50%;
  font-size: 1.25rem;
  cursor: pointer;
  line-height: 1;
}

.results-dropdown {
  position: absolute;
  top: calc(100% + 0.5rem);
  left: 0;
  right: 0;
  background: white;
  border-radius: 12px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  z-index: 100;
}

.result-item {
  padding: 0.875rem 1rem;
  cursor: pointer;
  transition: background 0.15s;
}

.result-item:hover {
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