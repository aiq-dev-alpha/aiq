<template>
  <div class="table-container" :style="containerStyles">
    <!-- Search and Filter Bar -->
    <div class="table-header">
      <div class="header-content">
        <input
          v-model="searchQuery"
          type="text"
          placeholder="Search table..."
          class="search-input"
          :style="searchStyles"
        />
        <div class="header-info">
          <span class="item-count">{{ filteredData.length }} items</span>
        </div>
      </div>
    </div>
    <!-- Bordered Table -->
    <div class="table-wrapper">
      <table class="data-table" :style="tableStyles">
        <thead :style="theadStyles">
          <tr>
            <th v-if="selectable" class="select-column" :style="thStyles">
              <input
                type="checkbox"
                :checked="allSelected"
                @change="toggleSelectAll"
                class="checkbox"
              />
            </th>
            <th
              v-for="column in columns"
              :key="column.key"
              :style="{ ...thStyles, width: column.width || 'auto' }"
              @click="column.sortable ? toggleSort(column.key) : null"
              :class="{ sortable: column.sortable }"
            >
              <div class="th-content">
                {{ column.label }}
                <span v-if="column.sortable && sortKey === column.key" class="sort-icon">
                  {{ sortOrder === 'asc' ? '↑' : '↓' }}
                </span>
              </div>
            </th>
            <th v-if="hasActions" :style="thStyles" class="actions-column">Actions</th>
          </tr>
        </thead>
        <tbody v-if="!loading">
          <template v-if="paginatedData.length > 0">
            <template v-for="(row, index) in paginatedData" :key="row.id || index">
              <tr
                :style="getTrStyles(index)"
                :class="{ selected: selectedRows.includes(row.id || index) }"
                @click="expandableRows ? toggleExpand(row.id || index) : null"
              >
                <td v-if="selectable" :style="tdStyles">
                  <input
                    type="checkbox"
                    :checked="selectedRows.includes(row.id || index)"
                    @change="toggleSelect(row.id || index)"
                    @click.stop
                    class="checkbox"
                  />
                </td>
                <td
                  v-for="column in columns"
                  :key="column.key"
                  :style="tdStyles"
                >
                  {{ row[column.key] }}
                </td>
                <td v-if="hasActions" :style="tdStyles">
                  <div class="action-buttons">
                    <button
                      @click.stop="$emit('edit', row)"
                      class="action-btn edit-btn"
                      :style="editBtnStyles"
                    >
                      <span class="btn-icon">✎</span>
                    </button>
                    <button
                      @click.stop="$emit('delete', row)"
                      class="action-btn delete-btn"
                      :style="deleteBtnStyles"
                    >
                      <span class="btn-icon">×</span>
                    </button>
                  </div>
                </td>
              </tr>
              <tr
                v-if="expandableRows && expandedRows.includes(row.id || index)"
                :style="expandedRowStyles"
              >
                <td :colspan="totalColumns" :style="expandedTdStyles">
                  <div class="expanded-content">
                    <slot name="expanded" :row="row">
                      <div class="expanded-details">
                        <div v-for="column in columns" :key="column.key" class="detail-row">
                          <strong>{{ column.label }}:</strong> {{ row[column.key] }}
                        </div>
                      </div>
                    </slot>
                  </div>
                </td>
              </tr>
            </template>
          </template>
          <tr v-else>
            <td :colspan="totalColumns" :style="{ ...tdStyles, textAlign: 'center', padding: '3rem' }">
              <div class="empty-state" :style="emptyStateStyles">
                <div class="empty-icon">📋</div>
                <div class="empty-text">No data available</div>
              </div>
            </td>
          </tr>
        </tbody>
        <tbody v-else>
          <tr v-for="i in 5" :key="i" :style="getTrStyles(i)">
            <td v-if="selectable" :style="tdStyles">
              <div class="skeleton"></div>
            </td>
            <td v-for="column in columns" :key="column.key" :style="tdStyles">
              <div class="skeleton"></div>
            </td>
            <td v-if="hasActions" :style="tdStyles">
              <div class="skeleton"></div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <!-- Pagination -->
    <div v-if="pagination && !loading" class="pagination" :style="paginationStyles">
      <div class="pagination-info">
        Showing {{ startItem }} to {{ endItem }} of {{ filteredData.length }}
      </div>
      <div class="pagination-controls">
        <button
          @click="currentPage--"
          :disabled="currentPage === 1"
          class="page-btn"
          :style="pageBtnStyles"
        >
          ‹
        </button>
        <span class="page-numbers">
          <button
            v-for="page in visiblePages"
            :key="page"
            @click="currentPage = page"
            class="page-number"
            :class="{ active: currentPage === page }"
            :style="currentPage === page ? activePageStyles : pageNumberStyles"
          >
            {{ page }}
          </button>
        </span>
        <button
          @click="currentPage++"
          :disabled="currentPage === totalPages"
          class="page-btn"
          :style="pageBtnStyles"
        >
          ›
        </button>
      </div>
    </div>
  </div>
</template>
<script lang="ts">
import { ref, computed, watch } from 'vue';
export default {
  name: 'BorderedMinimalTable',
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
        primary: '#14b8a6',
        background: '#ffffff',
        border: '#d1d5db',
        headerColor: '#374151',
        rowHover: '#f0fdfa',
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
      default: 10,
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
    const allSelected = computed(() => {
      return paginatedData.value.length > 0 &&
        paginatedData.value.every(row => selectedRows.value.includes(row.id || paginatedData.value.indexOf(row)));
    });
    const totalColumns = computed(() => {
      let count = props.columns.length;
      if (props.selectable) count++;
      if (props.hasActions) count++;
      return count;
    });
    const startItem = computed(() => {
      return (currentPage.value - 1) * props.itemsPerPage + 1;
    });
    const endItem = computed(() => {
      return Math.min(currentPage.value * props.itemsPerPage, filteredData.value.length);
    });
    const visiblePages = computed(() => {
      const pages = [];
      const maxVisible = 5;
      let start = Math.max(1, currentPage.value - Math.floor(maxVisible / 2));
      let end = Math.min(totalPages.value, start + maxVisible - 1);
      if (end - start < maxVisible - 1) {
        start = Math.max(1, end - maxVisible + 1);
      }
      for (let i = start; i <= end; i++) {
        pages.push(i);
      }
      return pages;
    });
    const toggleSort = (key) => {
      if (sortKey.value === key) {
        sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
      } else {
        sortKey.value = key;
        sortOrder.value = 'asc';
      }
    };
    const toggleSelect = (rowId) => {
      const index = selectedRows.value.indexOf(rowId);
      if (index > -1) {
        selectedRows.value.splice(index, 1);
      } else {
        selectedRows.value.push(rowId);
      }
      emit('selection-change', selectedRows.value);
    };
    const toggleSelectAll = () => {
      if (allSelected.value) {
        selectedRows.value = [];
      } else {
        selectedRows.value = paginatedData.value.map((row, index) => row.id || index);
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
    const containerStyles = computed(() => ({
      backgroundColor: props.theme.background,
      border: `2px solid ${props.theme.border}`,
      borderRadius: '8px',
      overflow: 'hidden',
    }));
    const searchStyles = computed(() => ({
      border: `1px solid ${props.theme.border}`,
      color: props.theme.headerColor,
      backgroundColor: props.theme.background,
    }));
    const tableStyles = computed(() => ({
      borderCollapse: 'collapse',
    }));
    const theadStyles = computed(() => ({
      backgroundColor: '#fafafa',
      borderBottom: `2px solid ${props.theme.border}`,
      position: 'sticky',
      top: 0,
      zIndex: 10,
    }));
    const thStyles = computed(() => ({
      padding: '0.875rem 1rem',
      textAlign: 'left',
      fontWeight: '600',
      fontSize: '0.813rem',
      color: props.theme.headerColor,
      borderRight: `1px solid ${props.theme.border}`,
      borderBottom: `2px solid ${props.theme.border}`,
    }));
    const tdStyles = computed(() => ({
      padding: '0.875rem 1rem',
      borderRight: `1px solid ${props.theme.border}`,
      borderBottom: `1px solid ${props.theme.border}`,
      color: props.theme.headerColor,
      fontSize: '0.875rem',
    }));
    const getTrStyles = (index) => ({
      backgroundColor: props.theme.background,
      transition: 'background-color 0.15s',
    });
    const editBtnStyles = computed(() => ({
      backgroundColor: 'transparent',
      color: props.theme.primary,
      border: `1px solid ${props.theme.primary}`,
    }));
    const deleteBtnStyles = computed(() => ({
      backgroundColor: 'transparent',
      color: '#dc2626',
      border: '1px solid #dc2626',
    }));
    const paginationStyles = computed(() => ({
      borderTop: `2px solid ${props.theme.border}`,
      color: props.theme.headerColor,
    }));
    const pageBtnStyles = computed(() => ({
      border: `1px solid ${props.theme.border}`,
      color: props.theme.headerColor,
      backgroundColor: props.theme.background,
    }));
    const pageNumberStyles = computed(() => ({
      border: `1px solid ${props.theme.border}`,
      color: props.theme.headerColor,
      backgroundColor: props.theme.background,
    }));
    const activePageStyles = computed(() => ({
      border: `1px solid ${props.theme.primary}`,
      backgroundColor: props.theme.primary,
      color: '#ffffff',
    }));
    const expandedRowStyles = computed(() => ({
      backgroundColor: '#f9fafb',
    }));
    const expandedTdStyles = computed(() => ({
      padding: 0,
      borderRight: `1px solid ${props.theme.border}`,
      borderBottom: `1px solid ${props.theme.border}`,
    }));
    const emptyStateStyles = computed(() => ({
      color: '#9ca3af',
    }));
    return {
      searchQuery,
      sortKey,
      sortOrder,
      currentPage,
      selectedRows,
      expandedRows,
      paginatedData,
      filteredData,
      allSelected,
      totalPages,
      totalColumns,
      startItem,
      endItem,
      visiblePages,
      toggleSort,
      toggleSelect,
      toggleSelectAll,
      toggleExpand,
      containerStyles,
      searchStyles,
      tableStyles,
      theadStyles,
      thStyles,
      tdStyles,
      getTrStyles,
      editBtnStyles,
      deleteBtnStyles,
      paginationStyles,
      pageBtnStyles,
      pageNumberStyles,
      activePageStyles,
      expandedRowStyles,
      expandedTdStyles,
      emptyStateStyles,
    };
  },
};
</script>
<style scoped>
.table-container {
  font-family: system-ui, -apple-system, sans-serif;
}
.table-header {
  padding: 1.25rem;
  background-color: #fafafa;
  border-bottom: 2px solid #d1d5db;
}
.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}
.search-input {
  flex: 1;
  max-width: 350px;
  padding: 0.5rem 0.875rem;
  border-radius: 4px;
  font-size: 0.875rem;
  outline: none;
  transition: all 0.2s;
}
.search-input:focus {
  border-color: #14b8a6;
  box-shadow: 0 0 0 2px rgba(20, 184, 166, 0.1);
}
.header-info {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.item-count {
  font-size: 0.875rem;
  font-weight: 500;
  color: #6b7280;
}
.table-wrapper {
  overflow-x: auto;
  max-height: 600px;
  overflow-y: auto;
}
.data-table {
  width: 100%;
  min-width: 600px;
}
.data-table thead th.sortable {
  cursor: pointer;
  user-select: none;
}
.data-table thead th.sortable:hover {
  background-color: #f3f4f6;
}
.data-table thead th:last-child,
.data-table tbody td:last-child {
  border-right: none;
}
.th-content {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  justify-content: space-between;
}
.sort-icon {
  font-size: 0.875rem;
  color: #14b8a6;
}
.data-table tbody tr:hover {
  background-color: #f0fdfa !important;
}
.data-table tbody tr.selected {
  background-color: rgba(20, 184, 166, 0.08) !important;
}
.checkbox {
  width: 1.125rem;
  height: 1.125rem;
  cursor: pointer;
  accent-color: #14b8a6;
}
.action-buttons {
  display: flex;
  gap: 0.5rem;
  justify-content: center;
}
.action-btn {
  padding: 0.375rem;
  width: 2rem;
  height: 2rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.2s;
}
.action-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
.btn-icon {
  font-size: 1rem;
  line-height: 1;
}
.pagination {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.25rem;
  gap: 1rem;
  background-color: #fafafa;
}
.pagination-info {
  font-size: 0.875rem;
  color: #6b7280;
}
.pagination-controls {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.page-numbers {
  display: flex;
  gap: 0.25rem;
}
.page-btn,
.page-number {
  padding: 0.375rem 0.625rem;
  min-width: 2rem;
  border-radius: 4px;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.2s;
  text-align: center;
}
.page-btn:hover:not(:disabled),
.page-number:hover {
  background-color: #f3f4f6;
}
.page-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.75rem;
}
.empty-icon {
  font-size: 2.5rem;
  opacity: 0.5;
}
.empty-text {
  font-size: 0.875rem;
}
.skeleton {
  height: 1rem;
  background: linear-gradient(90deg, #f3f4f6 25%, #e5e7eb 50%, #f3f4f6 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
  border-radius: 4px;
}
@keyframes loading {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}
.expanded-content {
  padding: 1.25rem;
  background-color: #f9fafb;
}
.expanded-details {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 0.875rem;
}
.detail-row {
  font-size: 0.875rem;
  line-height: 1.5;
}
.detail-row strong {
  color: #14b8a6;
  margin-right: 0.5rem;
}
.select-column {
  width: 60px;
}
.actions-column {
  width: 120px;
  text-align: center;
}
</style>
