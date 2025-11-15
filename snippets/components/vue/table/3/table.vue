<template>
  <div class="table-container">
    <!-- Search Bar -->
    <div class="search-bar" :style="searchBarStyles">
      <input
        v-model="searchQuery"
        type="text"
        placeholder="Search records..."
        class="search-input"
        :style="searchInputStyles"
      />
      <div class="search-meta">
        {{ filteredData.length }} records
      </div>
    </div>
    <!-- Card Grid Table -->
    <div v-if="!loading" class="cards-grid">
      <div
        v-for="(row, index) in paginatedData"
        :key="row.id || index"
        class="table-card"
        :style="getCardStyles(index)"
        :class="{ selected: selectedRows.includes(row.id || index) }"
      >
        <!-- Card Header -->
        <div class="card-header" :style="cardHeaderStyles">
          <input
            v-if="selectable"
            type="checkbox"
            :checked="selectedRows.includes(row.id || index)"
            @change="toggleSelect(row.id || index)"
            class="checkbox"
          />
          <div class="card-title">
            {{ row[columns[0]?.key] || 'No Title' }}
          </div>
        </div>
        <!-- Card Body -->
        <div class="card-body">
          <div
            v-for="column in columns.slice(1)"
            :key="column.key"
            class="card-field"
          >
            <div class="field-label" :style="fieldLabelStyles">
              {{ column.label }}
            </div>
            <div class="field-value" :style="fieldValueStyles">
              {{ row[column.key] }}
            </div>
          </div>
        </div>
        <!-- Expandable Section -->
        <div
          v-if="expandableRows && expandedRows.includes(row.id || index)"
          class="card-expanded"
          :style="cardExpandedStyles"
        >
          <slot name="expanded" :row="row">
            <pre class="expanded-data">{{ JSON.stringify(row, null, 2) }}</pre>
          </slot>
        </div>
        <!-- Card Footer -->
        <div class="card-footer" :style="cardFooterStyles">
          <button
            v-if="expandableRows"
            @click="toggleExpand(row.id || index)"
            class="expand-btn"
            :style="expandBtnStyles"
          >
            {{ expandedRows.includes(row.id || index) ? 'Show Less' : 'Show More' }}
          </button>
          <div v-if="hasActions" class="card-actions">
            <button
              @click="$emit('edit', row)"
              class="action-btn edit-btn"
              :style="editBtnStyles"
            >
              Edit
            </button>
            <button
              @click="$emit('delete', row)"
              class="action-btn delete-btn"
              :style="deleteBtnStyles"
            >
              Delete
            </button>
          </div>
        </div>
      </div>
      <!-- Empty State -->
      <div v-if="paginatedData.length === 0" class="empty-state" :style="emptyStateStyles">
        <div class="empty-icon">📦</div>
        <div class="empty-text">No records found</div>
        <div class="empty-subtext">Try adjusting your search</div>
      </div>
    </div>
    <!-- Loading State -->
    <div v-else class="cards-grid">
      <div
        v-for="i in 6"
        :key="i"
        class="table-card loading-card"
        :style="getCardStyles(i)"
      >
        <div class="skeleton skeleton-header"></div>
        <div class="skeleton skeleton-body"></div>
        <div class="skeleton skeleton-footer"></div>
      </div>
    </div>
    <!-- Pagination -->
    <div v-if="pagination && !loading && paginatedData.length > 0" class="pagination" :style="paginationStyles">
      <button
        @click="currentPage--"
        :disabled="currentPage === 1"
        class="page-btn"
        :style="pageBtnStyles"
      >
        « Previous
      </button>
      <div class="page-dots">
        <span
          v-for="page in totalPages"
          :key="page"
          class="page-dot"
          :class="{ active: currentPage === page }"
          :style="currentPage === page ? activeDotStyles : dotStyles"
          @click="currentPage = page"
        ></span>
      </div>
      <button
        @click="currentPage++"
        :disabled="currentPage === totalPages"
        class="page-btn"
        :style="pageBtnStyles"
      >
        Next »
      </button>
    </div>
  </div>
</template>
<script lang="ts">
import { ref, computed, watch } from 'vue';
export default {
  name: 'CardStyleTable',
  props: {
    columns: {
      type: Array,
      required: true,
    },
    data: {
      type: Array,
      required: true,
    },
    sortable: {
      type: Boolean,
      default: true,
    },
    selectable: {
      type: Boolean,
      default: false,
    },
    pagination: {
      type: Boolean,
      default: true,
    },
    loading: {
      type: Boolean,
      default: false,
    },
    theme: {
      type: Object,
      default: () => ({
        primary: '#f59e0b',
        background: '#ffffff',
        border: '#fed7aa',
        headerColor: '#78350f',
        rowHover: '#fef3c7',
      }),
    },
    expandableRows: {
      type: Boolean,
      default: false,
    },
    hasActions: {
      type: Boolean,
      default: true,
    },
    itemsPerPage: {
      type: Number,
      default: 6,
    },
  },
  emits: ['edit', 'delete', 'selection-change'],
  setup(props, { emit }) {
    const searchQuery = ref('');
    const sortKey = ref('');
    const sortOrder = ref('asc');
    const currentPage = ref(1);
    const selectedRows = ref([]);
    const expandedRows = ref([]);
    const filteredData = computed(() => {
      if (!searchQuery.value) return props.data;
      return props.data.filter(row => {
        return props.columns.some(column => {
          const value = row[column.key];
          return value && value.toString().toLowerCase().includes(searchQuery.value.toLowerCase());
        });
      });
    });
    const sortedData = computed(() => {
      if (!sortKey.value) return filteredData.value;
      return [...filteredData.value].sort((a, b) => {
        const aVal = a[sortKey.value];
        const bVal = b[sortKey.value];
        if (aVal < bVal) return sortOrder.value === 'asc' ? -1 : 1;
        if (aVal > bVal) return sortOrder.value === 'asc' ? 1 : -1;
        return 0;
      });
    });
    const totalPages = computed(() => {
      if (!props.pagination) return 1;
      return Math.ceil(sortedData.value.length / props.itemsPerPage);
    });
    const paginatedData = computed(() => {
      if (!props.pagination) return sortedData.value;
      const start = (currentPage.value - 1) * props.itemsPerPage;
      const end = start + props.itemsPerPage;
      return sortedData.value.slice(start, end);
    });
    const toggleSelect = (rowId) => {
      const index = selectedRows.value.indexOf(rowId);
      if (index > -1) {
        selectedRows.value.splice(index, 1);
      } else {
        selectedRows.value.push(rowId);
      }
      emit('selection-change', selectedRows.value);
    };
    const toggleExpand = (rowId) => {
      const index = expandedRows.value.indexOf(rowId);
      if (index > -1) {
        expandedRows.value.splice(index, 1);
      } else {
        expandedRows.value.push(rowId);
      }
    };
    watch(() => props.data, () => {
      currentPage.value = 1;
      selectedRows.value = [];
    });
    // Styles
    const searchBarStyles = computed(() => ({
      backgroundColor: '#fffbeb',
      borderBottom: `3px solid ${props.theme.border}`,
    }));
    const searchInputStyles = computed(() => ({
      border: `2px solid ${props.theme.border}`,
      color: props.theme.headerColor,
      backgroundColor: props.theme.background,
    }));
    const getCardStyles = (index) => ({
      backgroundColor: props.theme.background,
      border: `2px solid ${props.theme.border}`,
      borderLeft: `4px solid ${props.theme.primary}`,
      transition: 'all 0.3s ease',
    });
    const cardHeaderStyles = computed(() => ({
      backgroundColor: '#fffbeb',
      borderBottom: `2px solid ${props.theme.border}`,
      color: props.theme.headerColor,
    }));
    const cardFooterStyles = computed(() => ({
      backgroundColor: '#fef3c7',
      borderTop: `1px solid ${props.theme.border}`,
    }));
    const fieldLabelStyles = computed(() => ({
      color: props.theme.primary,
    }));
    const fieldValueStyles = computed(() => ({
      color: props.theme.headerColor,
    }));
    const cardExpandedStyles = computed(() => ({
      backgroundColor: '#fffbeb',
      borderTop: `1px solid ${props.theme.border}`,
    }));
    const expandBtnStyles = computed(() => ({
      backgroundColor: 'transparent',
      color: props.theme.primary,
      border: `1px solid ${props.theme.primary}`,
    }));
    const editBtnStyles = computed(() => ({
      backgroundColor: props.theme.primary,
      color: '#ffffff',
    }));
    const deleteBtnStyles = computed(() => ({
      backgroundColor: '#dc2626',
      color: '#ffffff',
    }));
    const paginationStyles = computed(() => ({
      borderTop: `3px solid ${props.theme.border}`,
      backgroundColor: '#fffbeb',
    }));
    const pageBtnStyles = computed(() => ({
      backgroundColor: props.theme.primary,
      color: '#ffffff',
      border: 'none',
    }));
    const dotStyles = computed(() => ({
      backgroundColor: props.theme.border,
    }));
    const activeDotStyles = computed(() => ({
      backgroundColor: props.theme.primary,
    }));
    const emptyStateStyles = computed(() => ({
      color: '#92400e',
    }));
    return {
      searchQuery,
      currentPage,
      selectedRows,
      expandedRows,
      paginatedData,
      filteredData,
      totalPages,
      toggleSelect,
      toggleExpand,
      searchBarStyles,
      searchInputStyles,
      getCardStyles,
      cardHeaderStyles,
      cardFooterStyles,
      fieldLabelStyles,
      fieldValueStyles,
      cardExpandedStyles,
      expandBtnStyles,
      editBtnStyles,
      deleteBtnStyles,
      paginationStyles,
      pageBtnStyles,
      dotStyles,
      activeDotStyles,
      emptyStateStyles,
    };
  },
};
</script>
<style scoped>
.table-container {
  font-family: system-ui, -apple-system, sans-serif;
  background-color: #fef3c7;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
.search-bar {
  padding: 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}
.search-input {
  flex: 1;
  max-width: 400px;
  padding: 0.75rem 1rem;
  border-radius: 10px;
  font-size: 0.875rem;
  outline: none;
  transition: all 0.2s;
  font-weight: 500;
}
.search-input:focus {
  border-color: #f59e0b;
  box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.2);
}
.search-meta {
  font-size: 0.875rem;
  font-weight: 600;
  color: #92400e;
}
.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 1.25rem;
  padding: 1.5rem;
  min-height: 400px;
}
.table-card {
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  display: flex;
  flex-direction: column;
}
.table-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(245, 158, 11, 0.2);
}
.table-card.selected {
  border-color: #f59e0b;
  box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.2);
}
.card-header {
  padding: 1rem 1.25rem;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}
.card-title {
  font-size: 1rem;
  font-weight: 700;
  flex: 1;
}
.checkbox {
  width: 1.125rem;
  height: 1.125rem;
  cursor: pointer;
  accent-color: #f59e0b;
}
.card-body {
  padding: 1.25rem;
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 0.875rem;
}
.card-field {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}
.field-label {
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.field-value {
  font-size: 0.875rem;
  font-weight: 500;
}
.card-expanded {
  padding: 1rem 1.25rem;
  max-height: 200px;
  overflow-y: auto;
}
.expanded-data {
  font-size: 0.75rem;
  margin: 0;
  white-space: pre-wrap;
  word-wrap: break-word;
}
.card-footer {
  padding: 0.875rem 1.25rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 0.75rem;
}
.expand-btn {
  padding: 0.5rem 0.875rem;
  border-radius: 6px;
  font-size: 0.75rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.expand-btn:hover {
  opacity: 0.8;
}
.card-actions {
  display: flex;
  gap: 0.5rem;
}
.action-btn {
  padding: 0.5rem 0.875rem;
  border: none;
  border-radius: 6px;
  font-size: 0.75rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.action-btn:hover {
  opacity: 0.9;
  transform: translateY(-1px);
}
.pagination {
  padding: 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}
.page-btn {
  padding: 0.625rem 1.25rem;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}
.page-btn:hover:not(:disabled) {
  opacity: 0.9;
  transform: translateY(-1px);
}
.page-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}
.page-dots {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}
.page-dot {
  width: 0.625rem;
  height: 0.625rem;
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.2s;
}
.page-dot:hover {
  transform: scale(1.2);
}
.page-dot.active {
  width: 2rem;
  border-radius: 0.5rem;
}
.empty-state {
  grid-column: 1 / -1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  padding: 4rem 2rem;
}
.empty-icon {
  font-size: 4rem;
  opacity: 0.5;
}
.empty-text {
  font-size: 1.25rem;
  font-weight: 700;
}
.empty-subtext {
  font-size: 0.875rem;
  opacity: 0.7;
}
.loading-card {
  pointer-events: none;
}
.skeleton {
  background: linear-gradient(90deg, #fed7aa 25%, #fdba74 50%, #fed7aa 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
  border-radius: 8px;
}
.skeleton-header {
  height: 3rem;
  margin-bottom: 1rem;
}
.skeleton-body {
  height: 8rem;
  margin: 1.25rem;
}
.skeleton-footer {
  height: 2.5rem;
  margin-top: auto;
}
@keyframes loading {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}
</style>
