<template>
  <div class="table-container" :style="containerStyles">
    <!-- Enhanced Search Header -->
    <div class="table-header" :style="headerStyles">
      <div class="header-main">
        <h2 class="header-title">Data Table</h2>
        <div class="search-wrapper">
          <span class="search-icon">🔍</span>
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search across all fields..."
            class="search-input"
            :style="searchInputStyles"
          />
        </div>
      </div>
      <div class="header-stats">
        <div class="stat-item">
          <span class="stat-label">Total</span>
          <span class="stat-value" :style="statValueStyles">{{ data.length }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">Filtered</span>
          <span class="stat-value" :style="statValueStyles">{{ filteredData.length }}</span>
        </div>
        <div class="stat-item" v-if="selectable">
          <span class="stat-label">Selected</span>
          <span class="stat-value" :style="statValueStyles">{{ selectedRows.length }}</span>
        </div>
      </div>
    </div>
    <!-- Elevated Table with Shadows -->
    <div class="table-wrapper" :style="tableWrapperStyles">
      <table class="data-table">
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
              <div class="th-wrapper">
                {{ column.label }}
                <span v-if="column.sortable" class="sort-indicator">
                  <span v-if="sortKey === column.key" class="sort-active">
                    {{ sortOrder === 'asc' ? '▲' : '▼' }}
                  </span>
                  <span v-else class="sort-inactive">⇅</span>
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
                :class="{
                  selected: selectedRows.includes(row.id || index),
                  clickable: expandableRows
                }"
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
                  <div class="cell-content">
                    {{ row[column.key] }}
                  </div>
                </td>
                <td v-if="hasActions" :style="tdStyles">
                  <div class="action-buttons">
                    <button
                      @click.stop="$emit('edit', row)"
                      class="action-btn edit-btn"
                      :style="editBtnStyles"
                      title="Edit"
                    >
                      <span class="btn-icon">✏</span>
                    </button>
                    <button
                      @click.stop="$emit('delete', row)"
                      class="action-btn delete-btn"
                      :style="deleteBtnStyles"
                      title="Delete"
                    >
                      <span class="btn-icon">🗑</span>
                    </button>
                  </div>
                </td>
              </tr>
              <tr
                v-if="expandableRows && expandedRows.includes(row.id || index)"
                class="expanded-row"
              >
                <td :colspan="totalColumns" :style="expandedTdStyles">
                  <div class="expanded-content" :style="expandedContentStyles">
                    <slot name="expanded" :row="row">
                      <div class="expanded-grid">
                        <div
                          v-for="column in columns"
                          :key="column.key"
                          class="expanded-item"
                        >
                          <div class="expanded-label" :style="expandedLabelStyles">
                            {{ column.label }}
                          </div>
                          <div class="expanded-value">
                            {{ row[column.key] }}
                          </div>
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
              <div class="empty-state">
                <div class="empty-icon">📊</div>
                <div class="empty-title">No Data Found</div>
                <div class="empty-message">Try adjusting your search or filters</div>
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
    <!-- Enhanced Pagination -->
    <div v-if="pagination && !loading && paginatedData.length > 0" class="pagination" :style="paginationStyles">
      <div class="pagination-left">
        <select
          v-model="itemsPerPageLocal"
          class="items-select"
          :style="itemsSelectStyles"
        >
          <option :value="5">5 per page</option>
          <option :value="10">10 per page</option>
          <option :value="25">25 per page</option>
          <option :value="50">50 per page</option>
        </select>
      </div>
      <div class="pagination-center">
        <button
          @click="currentPage = 1"
          :disabled="currentPage === 1"
          class="page-btn"
          :style="pageBtnStyles"
        >
          ««
        </button>
        <button
          @click="currentPage--"
          :disabled="currentPage === 1"
          class="page-btn"
          :style="pageBtnStyles"
        >
          ‹
        </button>
        <div class="page-numbers">
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
        </div>
        <button
          @click="currentPage++"
          :disabled="currentPage === totalPages"
          class="page-btn"
          :style="pageBtnStyles"
        >
          ›
        </button>
        <button
          @click="currentPage = totalPages"
          :disabled="currentPage === totalPages"
          class="page-btn"
          :style="pageBtnStyles"
        >
          »»
        </button>
      </div>
      <div class="pagination-right">
        <span class="page-summary">
          {{ startItem }}-{{ endItem }} of {{ filteredData.length }}
        </span>
      </div>
    </div>
  </div>
</template>
<script lang="ts">
import { ref, computed, watch } from 'vue';
export default {
  name: 'ShadowElevationTable',
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
        primary: '#6366f1',
        background: '#ffffff',
        border: '#e0e7ff',
        headerColor: '#312e81',
        rowHover: '#eef2ff',
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
    const itemsPerPageLocal = ref(props.itemsPerPage);
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
      return Math.ceil(sortedData.value.length / itemsPerPageLocal.value);
    });
    const paginatedData = computed(() => {
      if (!props.pagination) return sortedData.value;
      const start = (currentPage.value - 1) * itemsPerPageLocal.value;
      const end = start + itemsPerPageLocal.value;
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
      return Math.min((currentPage.value - 1) * itemsPerPageLocal.value + 1, filteredData.value.length);
    });
    const endItem = computed(() => {
      return Math.min(currentPage.value * itemsPerPageLocal.value, filteredData.value.length);
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
    watch(itemsPerPageLocal, () => {
      currentPage.value = 1;
    });
    // Styles
    const containerStyles = computed(() => ({
      backgroundColor: props.theme.background,
      borderRadius: '16px',
      boxShadow: '0 10px 30px rgba(99, 102, 241, 0.15)',
      overflow: 'hidden',
    }));
    const headerStyles = computed(() => ({
      background: `linear-gradient(135deg, ${props.theme.primary} 0%, #8b5cf6 100%)`,
      color: '#ffffff',
    }));
    const searchInputStyles = computed(() => ({
      backgroundColor: 'rgba(255, 255, 255, 0.95)',
      border: '2px solid rgba(255, 255, 255, 0.3)',
      color: props.theme.headerColor,
    }));
    const statValueStyles = computed(() => ({
      color: '#ffffff',
    }));
    const tableWrapperStyles = computed(() => ({
      boxShadow: 'inset 0 2px 8px rgba(0, 0, 0, 0.05)',
    }));
    const theadStyles = computed(() => ({
      background: `linear-gradient(to bottom, #f5f3ff, #ede9fe)`,
      borderBottom: `3px solid ${props.theme.primary}`,
      position: 'sticky',
      top: 0,
      zIndex: 10,
    }));
    const thStyles = computed(() => ({
      padding: '1rem 1.25rem',
      textAlign: 'left',
      fontWeight: '700',
      fontSize: '0.813rem',
      color: props.theme.primary,
      textTransform: 'uppercase',
      letterSpacing: '0.075em',
    }));
    const tdStyles = computed(() => ({
      padding: '1rem 1.25rem',
      color: props.theme.headerColor,
      fontSize: '0.875rem',
      borderBottom: `1px solid ${props.theme.border}`,
    }));
    const getTrStyles = (index) => ({
      backgroundColor: props.theme.background,
      transition: 'all 0.2s ease',
      boxShadow: '0 1px 2px rgba(0, 0, 0, 0.02)',
    });
    const editBtnStyles = computed(() => ({
      backgroundColor: props.theme.primary,
      color: '#ffffff',
      boxShadow: '0 2px 4px rgba(99, 102, 241, 0.3)',
    }));
    const deleteBtnStyles = computed(() => ({
      backgroundColor: '#ef4444',
      color: '#ffffff',
      boxShadow: '0 2px 4px rgba(239, 68, 68, 0.3)',
    }));
    const paginationStyles = computed(() => ({
      borderTop: `2px solid ${props.theme.border}`,
      backgroundColor: '#fafafa',
    }));
    const pageBtnStyles = computed(() => ({
      backgroundColor: props.theme.background,
      color: props.theme.primary,
      border: `1px solid ${props.theme.border}`,
      boxShadow: '0 1px 2px rgba(0, 0, 0, 0.05)',
    }));
    const pageNumberStyles = computed(() => ({
      backgroundColor: props.theme.background,
      color: props.theme.headerColor,
      border: `1px solid ${props.theme.border}`,
    }));
    const activePageStyles = computed(() => ({
      backgroundColor: props.theme.primary,
      color: '#ffffff',
      border: `1px solid ${props.theme.primary}`,
      boxShadow: '0 2px 4px rgba(99, 102, 241, 0.3)',
    }));
    const itemsSelectStyles = computed(() => ({
      border: `1px solid ${props.theme.border}`,
      color: props.theme.headerColor,
    }));
    const expandedTdStyles = computed(() => ({
      padding: 0,
      borderBottom: `2px solid ${props.theme.border}`,
    }));
    const expandedContentStyles = computed(() => ({
      backgroundColor: '#f5f3ff',
      borderTop: `2px solid ${props.theme.primary}`,
    }));
    const expandedLabelStyles = computed(() => ({
      color: props.theme.primary,
    }));
    return {
      searchQuery,
      sortKey,
      sortOrder,
      currentPage,
      selectedRows,
      expandedRows,
      itemsPerPageLocal,
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
      headerStyles,
      searchInputStyles,
      statValueStyles,
      tableWrapperStyles,
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
      itemsSelectStyles,
      expandedTdStyles,
      expandedContentStyles,
      expandedLabelStyles,
    };
  },
};
</script>
<style scoped>
.table-container {
  font-family: system-ui, -apple-system, sans-serif;
}
.table-header {
  padding: 2rem;
}
.header-main {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1.5rem;
  margin-bottom: 1.5rem;
}
.header-title {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
  color: #ffffff;
}
.search-wrapper {
  position: relative;
  flex: 1;
  max-width: 500px;
}
.search-icon {
  position: absolute;
  left: 1rem;
  top: 50%;
  transform: translateY(-50%);
  font-size: 1rem;
  opacity: 0.5;
}
.search-input {
  width: 100%;
  padding: 0.75rem 1rem 0.75rem 3rem;
  border-radius: 10px;
  font-size: 0.875rem;
  outline: none;
  transition: all 0.2s;
  font-weight: 500;
}
.search-input:focus {
  box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.3);
}
.header-stats {
  display: flex;
  gap: 2rem;
}
.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.25rem;
}
.stat-label {
  font-size: 0.75rem;
  opacity: 0.9;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.stat-value {
  font-size: 1.5rem;
  font-weight: 700;
}
.table-wrapper {
  overflow-x: auto;
  max-height: 600px;
  overflow-y: auto;
}
.data-table {
  width: 100%;
  min-width: 600px;
  border-collapse: collapse;
}
.data-table thead th.sortable {
  cursor: pointer;
  user-select: none;
}
.data-table thead th.sortable:hover {
  background-color: rgba(99, 102, 241, 0.1);
}
.th-wrapper {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.5rem;
}
.sort-indicator {
  font-size: 0.75rem;
}
.sort-active {
  color: #6366f1;
}
.sort-inactive {
  color: #d1d5db;
}
.data-table tbody tr:hover {
  background-color: #eef2ff !important;
  box-shadow: 0 2px 8px rgba(99, 102, 241, 0.1) !important;
  transform: scale(1.001);
}
.data-table tbody tr.clickable {
  cursor: pointer;
}
.data-table tbody tr.selected {
  background-color: rgba(99, 102, 241, 0.08) !important;
  box-shadow: inset 3px 0 0 #6366f1;
}
.cell-content {
  line-height: 1.5;
}
.checkbox {
  width: 1.125rem;
  height: 1.125rem;
  cursor: pointer;
  accent-color: #6366f1;
}
.action-buttons {
  display: flex;
  gap: 0.625rem;
  justify-content: center;
}
.action-btn {
  padding: 0.5rem;
  width: 2.25rem;
  height: 2.25rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 0.875rem;
}
.action-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}
.btn-icon {
  font-size: 1rem;
}
.expanded-content {
  padding: 1.5rem;
  animation: expandDown 0.2s ease-out;
}
@keyframes expandDown {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
.expanded-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.25rem;
}
.expanded-item {
  display: flex;
  flex-direction: column;
  gap: 0.375rem;
}
.expanded-label {
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.expanded-value {
  font-size: 0.875rem;
  color: #374151;
  font-weight: 500;
}
.pagination {
  padding: 1.25rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}
.pagination-left,
.pagination-right {
  flex: 1;
}
.pagination-center {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}
.items-select {
  padding: 0.5rem 0.75rem;
  border-radius: 6px;
  font-size: 0.875rem;
  outline: none;
  cursor: pointer;
  background-color: #ffffff;
}
.page-numbers {
  display: flex;
  gap: 0.25rem;
}
.page-btn,
.page-number {
  padding: 0.5rem 0.75rem;
  min-width: 2.5rem;
  border-radius: 6px;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  text-align: center;
}
.page-btn:hover:not(:disabled),
.page-number:hover {
  transform: translateY(-1px);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
.page-btn:disabled {
  opacity: 0.3;
  cursor: not-allowed;
  box-shadow: none;
}
.page-summary {
  font-size: 0.875rem;
  color: #6b7280;
  font-weight: 500;
  text-align: right;
  display: block;
}
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}
.empty-icon {
  font-size: 3rem;
  opacity: 0.4;
}
.empty-title {
  font-size: 1.125rem;
  font-weight: 700;
  color: #374151;
}
.empty-message {
  font-size: 0.875rem;
  color: #6b7280;
}
.skeleton {
  height: 1rem;
  background: linear-gradient(90deg, #e0e7ff 25%, #c7d2fe 50%, #e0e7ff 75%);
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
.select-column {
  width: 70px;
}
.actions-column {
  width: 140px;
  text-align: center;
}
</style>
