<template>
  <div class="sidebar-wrapper">
    <!-- Overlay backdrop -->
    <Transition name="fade">
      <div
        v-if="isOpen && variant === 'overlay'"
        class="sidebar-overlay"
        @click="handleToggle"
      />
    </Transition>

    <!-- Toggle button -->
    <button
      class="sidebar-toggle"
      :class="{ 'is-open': isOpen }"
      @click="handleToggle"
      :style="toggleButtonStyles"
    >
      <span class="hamburger-line"></span>
      <span class="hamburger-line"></span>
      <span class="hamburger-line"></span>
    </button>

    <!-- Sidebar -->
    <Transition :name="variant === 'overlay' ? 'slide' : 'slide'">
      <aside
        v-if="isOpen"
        class="sidebar"
        :class="[`sidebar-${variant}`, `sidebar-${position}`]"
        :style="sidebarStyles"
      >
        <!-- Sidebar header -->
        <div class="sidebar-header">
          <slot name="header">
            <h2 class="sidebar-title">Menu</h2>
          </slot>
        </div>

        <!-- Navigation items -->
        <nav class="sidebar-nav">
          <ul class="sidebar-menu">
            <li
              v-for="item in items"
              :key="item.id"
              class="sidebar-menu-item"
            >
              <div
                class="sidebar-menu-link"
                :class="{ 'is-active': activeItemId === item.id }"
                @click="handleItemClick(item)"
              >
                <span v-if="item.icon" class="sidebar-icon">{{ item.icon }}</span>
                <span class="sidebar-label">{{ item.label }}</span>
                <span
                  v-if="item.children && item.children.length > 0"
                  class="sidebar-arrow"
                  :class="{ 'is-expanded': expandedItems.has(item.id) }"
                >
                  ▼
                </span>
              </div>

              <!-- Nested children -->
              <Transition name="expand">
                <ul
                  v-if="item.children && expandedItems.has(item.id)"
                  class="sidebar-submenu"
                >
                  <li
                    v-for="child in item.children"
                    :key="child.id"
                    class="sidebar-submenu-item"
                  >
                    <div
                      class="sidebar-submenu-link"
                      :class="{ 'is-active': activeItemId === child.id }"
                      @click="handleItemClick(child)"
                    >
                      <span v-if="child.icon" class="sidebar-icon">{{ child.icon }}</span>
                      <span class="sidebar-label">{{ child.label }}</span>
                    </div>
                  </li>
                </ul>
              </Transition>
            </li>
          </ul>
        </nav>

        <!-- Sidebar footer -->
        <div class="sidebar-footer">
          <slot name="footer" />
        </div>
      </aside>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, defineProps, defineEmits } from 'vue';

// Interfaces
interface SidebarTheme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  activeColor: string;
  hoverColor: string;
  borderColor: string;
}

interface SidebarItem {
  id: string;
  label: string;
  icon?: string;
  route?: string;
  children?: SidebarItem[];
}

type VariantType = 'overlay' | 'push' | 'mini' | 'responsive' | 'drawer';
type PositionType = 'left' | 'right';

// Props
const props = defineProps<{
  items: SidebarItem[];
  isOpen?: boolean;
  position?: PositionType;
  width?: string;
  variant?: VariantType;
  theme?: Partial<SidebarTheme>;
}>();

// Default theme - Dark Purple
const defaultTheme: SidebarTheme = {
  primaryColor: '#6B46C1',
  backgroundColor: '#2D1B4E',
  textColor: '#E9D5FF',
  activeColor: '#9333EA',
  hoverColor: '#4C1D95',
  borderColor: '#7C3AED'
};

// Emits
const emit = defineEmits<{
  'item-clicked': [item: SidebarItem];
  'toggle': [isOpen: boolean];
}>();

// State
const activeItemId = ref<string | null>(null);
const expandedItems = ref<Set<string>>(new Set());

// Computed
const mergedTheme = computed<SidebarTheme>(() => ({
  ...defaultTheme,
  ...props.theme
}));

const sidebarStyles = computed(() => ({
  width: props.width || '280px',
  backgroundColor: mergedTheme.value.backgroundColor,
  color: mergedTheme.value.textColor,
  borderColor: mergedTheme.value.borderColor,
  [props.position === 'right' ? 'right' : 'left']: 0
}));

const toggleButtonStyles = computed(() => ({
  backgroundColor: mergedTheme.value.primaryColor,
  borderColor: mergedTheme.value.borderColor
}));

// Methods
const handleToggle = () => {
  emit('toggle', !props.isOpen);
};

const handleItemClick = (item: SidebarItem) => {
  if (item.children && item.children.length > 0) {
    // Toggle expand/collapse
    if (expandedItems.value.has(item.id)) {
      expandedItems.value.delete(item.id);
    } else {
      expandedItems.value.add(item.id);
    }
  } else {
    // Set active and emit
    activeItemId.value = item.id;
    emit('item-clicked', item);
  }
};
</script>

<style scoped>
.sidebar-wrapper {
  position: relative;
}

/* Overlay backdrop */
.sidebar-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.6);
  z-index: 998;
  backdrop-filter: blur(2px);
}

/* Toggle button */
.sidebar-toggle {
  position: fixed;
  top: 1rem;
  left: 1rem;
  width: 3rem;
  height: 3rem;
  border: 2px solid;
  border-radius: 0.5rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 0.375rem;
  cursor: pointer;
  transition: all 0.3s ease;
  z-index: 1000;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
}

.sidebar-toggle:hover {
  transform: scale(1.05);
  box-shadow: 0 6px 12px rgba(107, 70, 193, 0.4);
}

.hamburger-line {
  width: 1.5rem;
  height: 2px;
  background-color: white;
  transition: all 0.3s ease;
  border-radius: 2px;
}

.sidebar-toggle.is-open .hamburger-line:nth-child(1) {
  transform: translateY(7px) rotate(45deg);
}

.sidebar-toggle.is-open .hamburger-line:nth-child(2) {
  opacity: 0;
}

.sidebar-toggle.is-open .hamburger-line:nth-child(3) {
  transform: translateY(-7px) rotate(-45deg);
}

/* Sidebar */
.sidebar {
  position: fixed;
  top: 0;
  bottom: 0;
  height: 100vh;
  overflow-y: auto;
  z-index: 999;
  border-width: 0;
  box-shadow: 4px 0 20px rgba(107, 70, 193, 0.3);
  display: flex;
  flex-direction: column;
}

.sidebar-overlay .sidebar-left {
  border-right-width: 2px;
  border-right-style: solid;
}

.sidebar-overlay .sidebar-right {
  border-left-width: 2px;
  border-left-style: solid;
}

/* Sidebar header */
.sidebar-header {
  padding: 2rem 1.5rem 1.5rem;
  border-bottom: 1px solid rgba(124, 58, 237, 0.3);
}

.sidebar-title {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
  background: linear-gradient(135deg, #E9D5FF 0%, #C084FC 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* Navigation */
.sidebar-nav {
  flex: 1;
  padding: 1rem 0;
  overflow-y: auto;
}

.sidebar-menu {
  list-style: none;
  margin: 0;
  padding: 0;
}

.sidebar-menu-item {
  margin: 0.25rem 0;
}

.sidebar-menu-link,
.sidebar-submenu-link {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.875rem 1.5rem;
  cursor: pointer;
  transition: all 0.25s ease;
  position: relative;
  overflow: hidden;
}

.sidebar-menu-link::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 4px;
  background: linear-gradient(180deg, #9333EA 0%, #7C3AED 100%);
  transform: scaleY(0);
  transition: transform 0.25s ease;
}

.sidebar-menu-link:hover,
.sidebar-submenu-link:hover {
  background-color: var(--hover-color, #4C1D95);
  padding-left: 1.75rem;
}

.sidebar-menu-link.is-active,
.sidebar-submenu-link.is-active {
  background-color: var(--active-color, #9333EA);
  font-weight: 600;
  box-shadow: inset 0 0 20px rgba(147, 51, 234, 0.3);
}

.sidebar-menu-link.is-active::before {
  transform: scaleY(1);
}

.sidebar-icon {
  font-size: 1.25rem;
  flex-shrink: 0;
  width: 1.5rem;
  text-align: center;
}

.sidebar-label {
  flex: 1;
  font-size: 0.9375rem;
}

.sidebar-arrow {
  font-size: 0.625rem;
  transition: transform 0.3s ease;
  color: rgba(233, 213, 255, 0.7);
}

.sidebar-arrow.is-expanded {
  transform: rotate(180deg);
}

/* Submenu */
.sidebar-submenu {
  list-style: none;
  margin: 0;
  padding: 0;
  background-color: rgba(0, 0, 0, 0.2);
  border-left: 2px solid rgba(124, 58, 237, 0.5);
  margin-left: 1.5rem;
}

.sidebar-submenu-link {
  padding: 0.75rem 1.5rem;
  font-size: 0.875rem;
}

/* Sidebar footer */
.sidebar-footer {
  padding: 1.5rem;
  border-top: 1px solid rgba(124, 58, 237, 0.3);
  margin-top: auto;
}

/* Transitions */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.slide-enter-active,
.slide-leave-active {
  transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.sidebar-left.slide-enter-from,
.sidebar-left.slide-leave-to {
  transform: translateX(-100%);
}

.sidebar-right.slide-enter-from,
.sidebar-right.slide-leave-to {
  transform: translateX(100%);
}

.expand-enter-active,
.expand-leave-active {
  transition: all 0.3s ease;
  overflow: hidden;
}

.expand-enter-from,
.expand-leave-to {
  opacity: 0;
  max-height: 0;
}

.expand-enter-to,
.expand-leave-from {
  opacity: 1;
  max-height: 500px;
}

/* Scrollbar styling */
.sidebar::-webkit-scrollbar {
  width: 6px;
}

.sidebar::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.2);
}

.sidebar::-webkit-scrollbar-thumb {
  background: rgba(124, 58, 237, 0.5);
  border-radius: 3px;
}

.sidebar::-webkit-scrollbar-thumb:hover {
  background: rgba(147, 51, 234, 0.7);
}

/* Mobile responsive */
@media (max-width: 768px) {
  .sidebar {
    width: 85vw !important;
    max-width: 320px;
  }

  .sidebar-overlay {
    display: block;
  }
}


@keyframes enter {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}

@keyframes slideDown {
  from { transform: translateY(-10px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

@keyframes glow {
  0%, 100% { box-shadow: 0 0 5px currentColor; }
  50% { box-shadow: 0 0 20px currentColor; }
}
</style>
