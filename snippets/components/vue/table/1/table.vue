<template>
  <div class="table-container" :style="containerStyles">
    <!-- Search Bar -->
    <div class="table-header">
      <input
        v-model="searchQuery"
        type="text"
        placeholder="Search..."
        class="search-input"
        :style="searchStyles"
      />
    </div>

    <!-- Table -->
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
              {{ column.label }}
              <span v-if="column.sortable && sortKey === column.key" class="sort-icon">
                {{ sortOrder === 'asc' ? '▲' : '▼' }}
              </span>
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
                      Edit
                    </button>
                    <button
                      @click.stop="$emit('delete', row)"
                      class="action-btn delete-btn"
                      :style="deleteBtnStyles"
                    >
                      Delete
                    </button>
                  </div>
                </td>
              </tr>
              <tr
                v-if="expandableRows && expandedRows.includes(row.id || index)"
                :style="expandedRowStyles"
              >
                <td :colspan="totalColumns" :style="tdStyles">
                  <div class="expanded-content">
                    <slot name="expanded" :row="row">
                      <pre>{{ JSON.stringify(row, null, 2) }}</pre>
                    </slot>
                  </div>
                </td>
              </tr>
            </template>
          </template>
          <tr v-else>
            <td :colspan="totalColumns" :style="{ ...tdStyles, textAlign: 'center', padding: '2rem' }">
              <div class="empty-state">No data available</div>
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
      <button
        @click="currentPage--"
        :disabled="currentPage === 1"
        class="page-btn"
        :style="pageBtnStyles"
      >
        Previous
      </button>
      <span class="page-info">
        Page {{ currentPage }} of {{ totalPages }}
      </span>
      <button
        @click="currentPage++"
        :disabled="currentPage === totalPages"
        class="page-btn"
        :style="pageBtnStyles"
      >
        Next
      </button>
    </div>
  </div>
</template>

<script>
import { ref, computed, watch } from 'vue';

export default {
  name: 'StripedModernTable',
  props: {
    columns: {
      type: Array,
      required: true,
      // Example: [{ key: 'name', label: 'Name', sortable: true, width: '200px' }]
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
        border: '#e5e7eb',
        headerColor: '#1f2937',
        rowHover: '#f3f4f6',
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
      borderRadius: '12px',
      overflow: 'hidden',
      boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
    }));

    const searchStyles = computed(() => ({
      border: `1px solid ${props.theme.border}`,
      color: props.theme.headerColor,
    }));

    const tableStyles = computed(() => ({
      borderCollapse: 'separate',
      borderSpacing: 0,
    }));

    const theadStyles = computed(() => ({
      backgroundColor: props.theme.primary,
      color: '#ffffff',
      position: 'sticky',
      top: 0,
      zIndex: 10,
    }));

    const thStyles = computed(() => ({
      padding: '1rem',
      textAlign: 'left',
      fontWeight: '600',
      fontSize: '0.875rem',
      textTransform: 'uppercase',
      letterSpacing: '0.05em',
      borderBottom: `2px solid ${props.theme.border}`,
    }));

    const tdStyles = computed(() => ({
      padding: '1rem',
      borderBottom: `1px solid ${props.theme.border}`,
      color: props.theme.headerColor,
    }));

    const getTrStyles = (index) => ({
      backgroundColor: index % 2 === 0 ? '#ffffff' : '#f9fafb',
      transition: 'background-color 0.2s',
    });

    const editBtnStyles = computed(() => ({
      backgroundColor: props.theme.primary,
      color: '#ffffff',
    }));

    const deleteBtnStyles = computed(() => ({
      backgroundColor: '#ef4444',
      color: '#ffffff',
    }));

    const paginationStyles = computed(() => ({
      borderTop: `1px solid ${props.theme.border}`,
      color: props.theme.headerColor,
    }));

    const pageBtnStyles = computed(() => ({
      backgroundColor: props.theme.primary,
      color: '#ffffff',
    }));

    const expandedRowStyles = computed(() => ({
      backgroundColor: '#f9fafb',
    }));

    return {
      searchQuery,
      sortKey,
      sortOrder,
      currentPage,
      selectedRows,
      expandedRows,
      paginatedData,
      allSelected,
      totalPages,
      totalColumns,
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
      expandedRowStyles,
    };
  },
};
</script>

<style scoped>
.table-container {
  font-family: system-ui, -apple-system, sans-serif;
}

.table-header {
  padding: 1.5rem;
  border-bottom: 1px solid #e5e7eb;
}

.search-input {
  width: 100%;
  max-width: 400px;
  padding: 0.625rem 1rem;
  border-radius: 8px;
  font-size: 0.875rem;
  outline: none;
  transition: border-color 0.2s;
}

.search-input:focus {
  border-color: #6366f1;
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
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
  background-color: rgba(0, 0, 0, 0.1);
}

.sort-icon {
  margin-left: 0.5rem;
  font-size: 0.75rem;
}

.data-table tbody tr:hover {
  background-color: #f3f4f6 !important;
}

.data-table tbody tr.selected {
  background-color: rgba(99, 102, 241, 0.1) !important;
}

.checkbox {
  width: 1rem;
  height: 1rem;
  cursor: pointer;
  accent-color: #6366f1;
}

.action-buttons {
  display: flex;
  gap: 0.5rem;
}

.action-btn {
  padding: 0.375rem 0.75rem;
  border: none;
  border-radius: 6px;
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: opacity 0.2s;
}

.action-btn:hover {
  opacity: 0.8;
}

.action-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagination {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.5rem;
  gap: 1rem;
}

.page-info {
  font-size: 0.875rem;
  font-weight: 500;
}

.page-btn {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 6px;
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: opacity 0.2s;
}

.page-btn:hover:not(:disabled) {
  opacity: 0.8;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.empty-state {
  font-size: 0.875rem;
  color: #9ca3af;
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
  padding: 1rem;
  background-color: #ffffff;
  border-radius: 8px;
  margin: 0.5rem;
}

.select-column,
.actions-column {
  width: 100px;
}
</style>
