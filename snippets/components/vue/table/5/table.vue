<template>
  <div class="table-container" :style="containerStyles">
    <!-- Compact Toolbar -->
    <div class="toolbar" :style="toolbarStyles">
      <div class="toolbar-left">
        <div class="search-box">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Quick search..."
            class="search-input"
            :style="searchInputStyles"
          />
        </div>
        <div class="view-toggle">
          <button
            @click="density = 'compact'"
            :class="{ active: density === 'compact' }"
            :style="density === 'compact' ? activeBtnStyles : toggleBtnStyles"
            class="density-btn"
          >
            Compact
          </button>
          <button
            @click="density = 'normal'"
            :class="{ active: density === 'normal' }"
            :style="density === 'normal' ? activeBtnStyles : toggleBtnStyles"
            class="density-btn"
          >
            Normal
          </button>
        </div>
      </div>
      <div class="toolbar-right">
        <span class="results-count" :style="resultsCountStyles">
          {{ filteredData.length }} results
        </span>
      </div>
    </div>
    <!-- Compact Dense Table -->
    <div class="table-wrapper">
      <table class="data-table" :class="{ compact: density === 'compact' }">
        <thead :style="theadStyles">
          <tr>
            <th v-if="selectable" class="select-column" :style="getThStyles(true)">
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
              :style="getThStyles(false, column.width)"
              @click="column.sortable ? toggleSort(column.key) : null"
              :class="{ sortable: column.sortable, sorted: sortKey === column.key }"
            >
              <div class="th-inner">
                <span>{{ column.label }}</span>
                <span v-if="column.sortable" class="sort-icons">
                  <span
                    class="sort-asc"
                    :class="{ active: sortKey === column.key && sortOrder === 'asc' }"
                  >▴</span>
                  <span
                    class="sort-desc"
                    :class="{ active: sortKey === column.key && sortOrder === 'desc' }"
                  >▾</span>
                </span>
              </div>
            </th>
            <th v-if="hasActions" :style="getThStyles(true)" class="actions-column">
              Actions
            </th>
          </tr>
        </thead>
        <tbody v-if="!loading">
          <template v-if="paginatedData.length > 0">
            <template v-for="(row, index) in paginatedData" :key="row.id || index">
              <tr
                :style="getTrStyles(index)"
                :class="{
                  selected: selectedRows.includes(row.id || index),
                  expandable: expandableRows,
                  expanded: expandedRows.includes(row.id || index)
                }"
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
                  <span class="cell-text">{{ row[column.key] }}</span>
                </td>
                <td v-if="hasActions" :style="tdStyles">
                  <div class="action-group">
                    <button
                      v-if="expandableRows"
                      @click="toggleExpand(row.id || index)"
                      class="icon-btn expand-btn"
                      :style="iconBtnStyles"
                      title="Expand"
                    >
                      {{ expandedRows.includes(row.id || index) ? '−' : '+' }}
                    </button>
                    <button
                      @click.stop="$emit('edit', row)"
                      class="icon-btn edit-btn"
                      :style="editIconBtnStyles"
                      title="Edit"
                    >
                      ✎
                    </button>
                    <button
                      @click.stop="$emit('delete', row)"
                      class="icon-btn delete-btn"
                      :style="deleteIconBtnStyles"
                      title="Delete"
                    >
                      ×
                    </button>
                  </div>
                </td>
              </tr>
              <tr
                v-if="expandableRows && expandedRows.includes(row.id || index)"
                class="expanded-row"
                :style="expandedRowStyles"
              >
                <td :colspan="totalColumns" :style="expandedTdStyles">
                  <div class="expanded-panel">
                    <slot name="expanded" :row="row">
                      <table class="inner-table">
                        <tr v-for="column in columns" :key="column.key">
                          <td class="inner-label" :style="innerLabelStyles">
                            {{ column.label }}
                          </td>
                          <td class="inner-value">{{ row[column.key] }}</td>
                        </tr>
                      </table>
                    </slot>
                  </div>
                </td>
              </tr>
            </template>
          </template>
          <tr v-else>
            <td :colspan="totalColumns" :style="{ ...tdStyles, textAlign: 'center', padding: '2rem' }">
              <div class="empty-message">
                <span class="empty-icon">⊘</span>
                <span>No matching records</span>
              </div>
            </td>
          </tr>
        </tbody>
        <tbody v-else>
          <tr v-for="i in 8" :key="i" :style="getTrStyles(i)">
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
    <!-- Compact Pagination -->
    <div v-if="pagination && !loading && paginatedData.length > 0" class="pagination" :style="paginationStyles">
      <div class="pagination-controls">
        <button
          @click="currentPage--"
          :disabled="currentPage === 1"
          class="nav-btn"
          :style="navBtnStyles"
        >
          ‹
        </button>
        <div class="page-input-group">
          <input
            v-model.number="currentPageInput"
            @blur="goToPage"
            @keyup.enter="goToPage"
            type="number"
            min="1"
            :max="totalPages"
            class="page-input"
            :style="pageInputStyles"
          />
          <span class="page-total">/ {{ totalPages }}</span>
        </div>
        <button
          @click="currentPage++"
          :disabled="currentPage === totalPages"
          class="nav-btn"
          :style="navBtnStyles"
        >
          ›
        </button>
      </div>
      <div class="pagination-info">
        <select
          v-model="itemsPerPageLocal"
          class="per-page-select"
          :style="perPageSelectStyles"
        >
          <option :value="10">10</option>
          <option :value="25">25</option>
          <option :value="50">50</option>
          <option :value="100">100</option>
        </select>
        <span class="info-text">
          {{ startItem }}-{{ endItem }} of {{ filteredData.length }}
        </span>
      </div>
    </div>
  </div>
</template>
<script lang="ts">
import { ref, computed, watch } from 'vue';
export default {
  name: 'CompactDenseTable',
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
        primary: '#f43f5e',
        background: '#ffffff',
        border: '#fecdd3',
        headerColor: '#881337',
        rowHover: '#ffe4e6',
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
      default: 25,
    },
  },
  emits: ['edit', 'delete', 'selection-change'],
  setup(props, { emit }) {
    const searchQuery = ref('');
    const sortKey = ref('');
    const sortOrder = ref('asc');
    const currentPage = ref(1);
    const currentPageInput = ref(1);
    const selectedRows = ref([]);
    const expandedRows = ref([]);
    const itemsPerPageLocal = ref(props.itemsPerPage);
    const density = ref('compact');
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
    const goToPage = () => {
      if (currentPageInput.value >= 1 && currentPageInput.value <= totalPages.value) {
        currentPage.value = currentPageInput.value;
      } else {
        currentPageInput.value = currentPage.value;
      }
    };
    watch(currentPage, (newVal) => {
      currentPageInput.value = newVal;
    });
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
      border: `1px solid ${props.theme.border}`,
      borderRadius: '6px',
    }));
    const toolbarStyles = computed(() => ({
      backgroundColor: '#fff5f7',
      borderBottom: `1px solid ${props.theme.border}`,
    }));
    const searchInputStyles = computed(() => ({
      border: `1px solid ${props.theme.border}`,
      color: props.theme.headerColor,
    }));
    const toggleBtnStyles = computed(() => ({
      backgroundColor: props.theme.background,
      color: props.theme.headerColor,
      border: `1px solid ${props.theme.border}`,
    }));
    const activeBtnStyles = computed(() => ({
      backgroundColor: props.theme.primary,
      color: '#ffffff',
      border: `1px solid ${props.theme.primary}`,
    }));
    const resultsCountStyles = computed(() => ({
      color: props.theme.headerColor,
    }));
    const theadStyles = computed(() => ({
      backgroundColor: '#fda4af',
      borderBottom: `2px solid ${props.theme.primary}`,
      position: 'sticky',
      top: 0,
      zIndex: 10,
    }));
    const getThStyles = (isFixed, width = null) => ({
      padding: density.value === 'compact' ? '0.5rem 0.75rem' : '0.75rem 1rem',
      textAlign: 'left',
      fontWeight: '700',
      fontSize: '0.75rem',
      color: props.theme.headerColor,
      textTransform: 'uppercase',
      letterSpacing: '0.05em',
      width: width || (isFixed ? 'auto' : null),
      whiteSpace: 'nowrap',
    });
    const tdStyles = computed(() => ({
      padding: density.value === 'compact' ? '0.375rem 0.75rem' : '0.625rem 1rem',
      fontSize: '0.813rem',
      color: props.theme.headerColor,
      borderBottom: `1px solid ${props.theme.border}`,
      lineHeight: '1.3',
    }));
    const getTrStyles = (index) => ({
      backgroundColor: index % 2 === 0 ? props.theme.background : '#fff9fa',
      transition: 'background-color 0.15s',
    });
    const iconBtnStyles = computed(() => ({
      backgroundColor: 'transparent',
      color: props.theme.primary,
      border: `1px solid ${props.theme.border}`,
    }));
    const editIconBtnStyles = computed(() => ({
      backgroundColor: 'transparent',
      color: props.theme.primary,
      border: `1px solid ${props.theme.primary}`,
    }));
    const deleteIconBtnStyles = computed(() => ({
      backgroundColor: 'transparent',
      color: '#dc2626',
      border: '1px solid #fecdd3',
    }));
    const paginationStyles = computed(() => ({
      borderTop: `1px solid ${props.theme.border}`,
      backgroundColor: '#fff5f7',
    }));
    const navBtnStyles = computed(() => ({
      backgroundColor: props.theme.background,
      color: props.theme.primary,
      border: `1px solid ${props.theme.border}`,
    }));
    const pageInputStyles = computed(() => ({
      border: `1px solid ${props.theme.border}`,
      color: props.theme.headerColor,
    }));
    const perPageSelectStyles = computed(() => ({
      border: `1px solid ${props.theme.border}`,
      color: props.theme.headerColor,
    }));
    const expandedRowStyles = computed(() => ({
      backgroundColor: '#ffe4e6',
    }));
    const expandedTdStyles = computed(() => ({
      padding: 0,
      borderBottom: `1px solid ${props.theme.border}`,
    }));
    const innerLabelStyles = computed(() => ({
      color: props.theme.primary,
    }));
    return {
      searchQuery,
      sortKey,
      sortOrder,
      currentPage,
      currentPageInput,
      selectedRows,
      expandedRows,
      itemsPerPageLocal,
      density,
      paginatedData,
      filteredData,
      allSelected,
      totalPages,
      totalColumns,
      startItem,
      endItem,
      toggleSort,
      toggleSelect,
      toggleSelectAll,
      toggleExpand,
      goToPage,
      containerStyles,
      toolbarStyles,
      searchInputStyles,
      toggleBtnStyles,
      activeBtnStyles,
      resultsCountStyles,
      theadStyles,
      getThStyles,
      tdStyles,
      getTrStyles,
      iconBtnStyles,
      editIconBtnStyles,
      deleteIconBtnStyles,
      paginationStyles,
      navBtnStyles,
      pageInputStyles,
      perPageSelectStyles,
      expandedRowStyles,
      expandedTdStyles,
      innerLabelStyles,
    };
  },
};
</script>
<style scoped>
.table-container {
  font-family: system-ui, -apple-system, sans-serif;
  font-size: 0.875rem;
}
.toolbar {
  padding: 0.75rem 1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}
.toolbar-left {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex: 1;
}
.toolbar-right {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}
.search-box {
  flex: 1;
  max-width: 300px;
}
.search-input {
  width: 100%;
  padding: 0.375rem 0.625rem;
  border-radius: 4px;
  font-size: 0.813rem;
  outline: none;
  transition: border-color 0.15s;
}
.search-input:focus {
  border-color: #f43f5e;
}
.view-toggle {
  display: flex;
  gap: 0;
  border-radius: 4px;
  overflow: hidden;
}
.density-btn {
  padding: 0.375rem 0.75rem;
  font-size: 0.75rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.15s;
  border: none;
  text-transform: uppercase;
  letter-spacing: 0.025em;
}
.density-btn:first-child {
  border-top-left-radius: 4px;
  border-bottom-left-radius: 4px;
}
.density-btn:last-child {
  border-top-right-radius: 4px;
  border-bottom-right-radius: 4px;
}
.results-count {
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
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
  background-color: rgba(244, 63, 94, 0.2);
}
.data-table thead th.sorted {
  background-color: rgba(244, 63, 94, 0.15);
}
.th-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.375rem;
}
.sort-icons {
  display: flex;
  flex-direction: column;
  line-height: 0.6;
  font-size: 0.625rem;
  opacity: 0.4;
}
.sort-icons .active {
  opacity: 1;
  color: #881337;
}
.data-table tbody tr:hover {
  background-color: #ffe4e6 !important;
}
.data-table tbody tr.expandable {
  cursor: pointer;
}
.data-table tbody tr.selected {
  background-color: rgba(244, 63, 94, 0.1) !important;
  border-left: 2px solid #f43f5e;
}
.data-table tbody tr.expanded {
  border-bottom: none;
}
.cell-text {
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.checkbox {
  width: 0.875rem;
  height: 0.875rem;
  cursor: pointer;
  accent-color: #f43f5e;
}
.action-group {
  display: flex;
  gap: 0.25rem;
  justify-content: center;
}
.icon-btn {
  padding: 0.25rem;
  width: 1.5rem;
  height: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 3px;
  font-size: 0.875rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.15s;
  line-height: 1;
}
.icon-btn:hover {
  transform: scale(1.1);
}
.expanded-panel {
  padding: 1rem;
  animation: slideDown 0.2s ease-out;
}
@keyframes slideDown {
  from {
    opacity: 0;
    max-height: 0;
  }
  to {
    opacity: 1;
    max-height: 500px;
  }
}
.inner-table {
  width: 100%;
  border-collapse: collapse;
}
.inner-table tr {
  border-bottom: 1px solid #fecdd3;
}
.inner-table tr:last-child {
  border-bottom: none;
}
.inner-table td {
  padding: 0.5rem;
  font-size: 0.813rem;
}
.inner-label {
  font-weight: 700;
  width: 200px;
  text-transform: uppercase;
  font-size: 0.688rem;
  letter-spacing: 0.05em;
}
.inner-value {
  color: #4b5563;
}
.pagination {
  padding: 0.75rem 1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}
.pagination-controls {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.nav-btn {
  padding: 0.375rem 0.625rem;
  min-width: 2rem;
  border-radius: 3px;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.15s;
}
.nav-btn:hover:not(:disabled) {
  background-color: #ffe4e6;
}
.nav-btn:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}
.page-input-group {
  display: flex;
  align-items: center;
  gap: 0.375rem;
  font-size: 0.813rem;
}
.page-input {
  width: 3rem;
  padding: 0.375rem 0.5rem;
  border-radius: 3px;
  font-size: 0.813rem;
  text-align: center;
  outline: none;
}
.page-input::-webkit-inner-spin-button,
.page-input::-webkit-outer-spin-button {
  opacity: 1;
}
.page-total {
  color: #6b7280;
  font-weight: 500;
}
.pagination-info {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}
.per-page-select {
  padding: 0.375rem 0.5rem;
  border-radius: 3px;
  font-size: 0.813rem;
  cursor: pointer;
  outline: none;
  background-color: #ffffff;
}
.info-text {
  font-size: 0.813rem;
  color: #6b7280;
  font-weight: 500;
  white-space: nowrap;
}
.empty-message {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  color: #9ca3af;
}
.empty-icon {
  font-size: 2rem;
  opacity: 0.5;
}
.skeleton {
  height: 0.875rem;
  background: linear-gradient(90deg, #fecdd3 25%, #fda4af 50%, #fecdd3 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
  border-radius: 3px;
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
  width: 50px;
}
.actions-column {
  width: 120px;
  text-align: center;
}
</style>
