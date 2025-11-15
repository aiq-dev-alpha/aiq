<template>
  <div class="drawer-sidebar-wrapper">
    <!-- Overlay backdrop -->
    <Transition name="overlay-fade">
      <div
        v-if="isOpen"
        class="drawer-overlay"
        @click="handleToggle"
      />
    </Transition>
    <!-- Floating action button to open drawer -->
    <button
      class="drawer-fab"
      :class="{ 'fab-hidden': isOpen }"
      @click="handleToggle"
      :style="fabStyles"
      aria-label="Open menu"
    >
      <span class="fab-icon">☰</span>
      <span class="fab-label">Menu</span>
    </button>
    <!-- Drawer Sidebar -->
    <Transition name="drawer-slide">
      <aside
        v-if="isOpen"
        class="drawer-sidebar"
        :class="[`drawer-${position}`]"
        :style="drawerStyles"
      >
        <!-- Drawer handle/grip -->
        <div class="drawer-handle" @click="handleToggle">
          <div class="handle-bar"></div>
        </div>
        <!-- Header with close -->
        <header class="drawer-header">
          <slot name="header">
            <div class="header-layout">
              <div class="brand-section">
                <div class="brand-icon-circle">🌸</div>
                <div class="brand-content">
                  <h1 class="brand-heading">Navigation</h1>
                  <p class="brand-subtitle">Explore Menu</p>
                </div>
              </div>
              <button
                class="close-drawer-btn"
                @click="handleToggle"
                aria-label="Close drawer"
              >
                <span>✕</span>
              </button>
            </div>
          </slot>
        </header>
        <!-- Search bar -->
        <div class="drawer-search">
          <div class="search-input-wrapper">
            <span class="search-icon">🔍</span>
            <input
              type="text"
              placeholder="Search menu..."
              class="search-input"
              v-model="searchQuery"
            />
          </div>
        </div>
        <!-- Navigation menu -->
        <nav class="drawer-nav">
          <ul class="drawer-menu">
            <li
              v-for="item in filteredItems"
              :key="item.id"
              class="drawer-menu-item"
            >
              <div
                class="drawer-link"
                :class="{
                  'link-active': activeItemId === item.id,
                  'has-submenu': item.children?.length
                }"
                @click="handleItemClick(item)"
              >
                <div class="link-main">
                  <span v-if="item.icon" class="link-icon">{{ item.icon }}</span>
                  <span class="link-text">{{ item.label }}</span>
                </div>
                <span
                  v-if="item.children && item.children.length > 0"
                  class="chevron-icon"
                  :class="{ 'chevron-rotated': expandedItems.has(item.id) }"
                >
                  ›
                </span>
              </div>
              <!-- Nested submenu -->
              <Transition name="drawer-submenu">
                <ul
                  v-if="item.children && expandedItems.has(item.id)"
                  class="drawer-submenu"
                >
                  <li
                    v-for="child in item.children"
                    :key="child.id"
                    class="drawer-submenu-item"
                  >
                    <div
                      class="drawer-sublink"
                      :class="{ 'link-active': activeItemId === child.id }"
                      @click="handleItemClick(child)"
                    >
                      <span v-if="child.icon" class="sublink-icon">{{ child.icon }}</span>
                      <span class="sublink-text">{{ child.label }}</span>
                    </div>
                  </li>
                </ul>
              </Transition>
            </li>
          </ul>
        </nav>
        <!-- Drawer divider -->
        <div class="drawer-divider"></div>
        <!-- Additional info section -->
        <div class="drawer-info-section">
          <div class="info-card">
            <div class="info-icon">ℹ️</div>
            <div class="info-content">
              <h3 class="info-title">Quick Tip</h3>
              <p class="info-text">Tap outside to close the menu</p>
            </div>
          </div>
        </div>
        <!-- Footer -->
        <footer class="drawer-footer">
          <slot name="footer">
            <div class="footer-profile">
              <div class="profile-card">
                <div class="profile-img-wrapper">
                  <div class="profile-img">👤</div>
                  <div class="online-badge"></div>
                </div>
                <div class="profile-details">
                  <p class="profile-name">Jessica Williams</p>
                  <p class="profile-email">jessica@example.com</p>
                </div>
              </div>
              <div class="footer-actions">
                <button class="action-icon-btn" aria-label="Settings">
                  ⚙️
                </button>
                <button class="action-icon-btn" aria-label="Notifications">
                  🔔
                </button>
              </div>
            </div>
          </slot>
        </footer>
      </aside>
    </Transition>
  </div>
</template>
<script setup lang="ts">
import { ref, computed } from 'vue';
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
const props = withDefaults(defineProps<{
  items: SidebarItem[];
  isOpen?: boolean;
  position?: PositionType;
  width?: string;
  variant?: VariantType;
  theme?: Partial<SidebarTheme>;
}>(), {
  isOpen: false,
  position: 'left',
  width: '360px',
  variant: 'drawer'
});
// Rose Pink theme
const defaultTheme: SidebarTheme = {
  primaryColor: '#EC4899',
  backgroundColor: '#881337',
  textColor: '#FCE7F3',
  activeColor: '#F472B6',
  hoverColor: '#9F1239',
  borderColor: '#DB2777'
};
// Emits
const emit = defineEmits<{
  'item-clicked': [item: SidebarItem];
  'toggle': [isOpen: boolean];
}>();
// State
const activeItemId = ref<string | null>(null);
const expandedItems = ref<Set<string>>(new Set());
const searchQuery = ref('');
// Computed
const mergedTheme = computed<SidebarTheme>(() => ({
  ...defaultTheme,
  ...props.theme
}));
const drawerStyles = computed(() => ({
  width: props.width,
  backgroundColor: mergedTheme.value.backgroundColor,
  color: mergedTheme.value.textColor,
  borderColor: mergedTheme.value.borderColor,
  [props.position]: 0
}));
const fabStyles = computed(() => ({
  backgroundColor: mergedTheme.value.primaryColor,
  borderColor: mergedTheme.value.borderColor
}));
const filteredItems = computed(() => {
  if (!searchQuery.value.trim()) {
    return props.items;
  }
  const query = searchQuery.value.toLowerCase();
  return props.items.filter(item => {
    const matchesParent = item.label.toLowerCase().includes(query);
    const matchesChild = item.children?.some(child =>
      child.label.toLowerCase().includes(query)
    );
    return matchesParent || matchesChild;
  });
});
// Methods
const handleToggle = () => {
  emit('toggle', !props.isOpen);
  // Clear search when closing
  if (props.isOpen) {
    searchQuery.value = '';
  }
};
const handleItemClick = (item: SidebarItem) => {
  if (item.children && item.children.length > 0) {
    // Toggle submenu
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
.drawer-sidebar-wrapper {
  position: relative;
}
/* Overlay */
.drawer-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.65);
  z-index: 999;
  backdrop-filter: blur(4px);
}
/* Floating Action Button */
.drawer-fab {
  position: fixed;
  bottom: 2rem;
  right: 2rem;
  width: 4rem;
  height: 4rem;
  border: 3px solid;
  border-radius: 50%;
  cursor: pointer;
  z-index: 998;
  transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 0.25rem;
  box-shadow: 0 12px 28px rgba(236, 72, 153, 0.4);
}
.drawer-fab:hover {
  transform: scale(1.15) rotate(10deg);
  box-shadow: 0 16px 40px rgba(236, 72, 153, 0.6);
}
.drawer-fab:active {
  transform: scale(0.95);
}
.drawer-fab.fab-hidden {
  opacity: 0;
  pointer-events: none;
  transform: scale(0.5) rotate(180deg);
}
.fab-icon {
  font-size: 1.5rem;
  color: white;
  font-weight: bold;
}
.fab-label {
  font-size: 0.625rem;
  color: white;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
/* Drawer Sidebar */
.drawer-sidebar {
  position: fixed;
  top: 0;
  bottom: 0;
  height: 100vh;
  z-index: 1000;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: -8px 0 40px rgba(236, 72, 153, 0.3);
  background: linear-gradient(180deg, #881337 0%, #9F1239 100%);
}
.drawer-left {
  left: 0;
  border-right: 4px solid;
}
.drawer-right {
  right: 0;
  border-left: 4px solid;
}
/* Drawer handle */
.drawer-handle {
  padding: 1rem;
  display: flex;
  justify-content: center;
  cursor: pointer;
  background: rgba(219, 39, 119, 0.2);
}
.handle-bar {
  width: 4rem;
  height: 5px;
  background: rgba(252, 231, 243, 0.4);
  border-radius: 3px;
  transition: all 0.3s ease;
}
.drawer-handle:hover .handle-bar {
  background: rgba(252, 231, 243, 0.7);
  width: 5rem;
}
/* Header */
.drawer-header {
  padding: 1.5rem 1.75rem;
  border-bottom: 2px solid rgba(219, 39, 119, 0.4);
  background: linear-gradient(135deg, rgba(244, 114, 182, 0.15) 0%, transparent 100%);
}
.header-layout {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
}
.brand-section {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex: 1;
}
.brand-icon-circle {
  width: 3.5rem;
  height: 3.5rem;
  background: linear-gradient(135deg, #F472B6 0%, #EC4899 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.75rem;
  box-shadow: 0 6px 20px rgba(236, 72, 153, 0.5);
  flex-shrink: 0;
  border: 3px solid rgba(219, 39, 119, 0.4);
}
.brand-content {
  flex: 1;
}
.brand-heading {
  margin: 0;
  font-size: 1.625rem;
  font-weight: 800;
  color: #FCE7F3;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.4);
  line-height: 1.2;
}
.brand-subtitle {
  margin: 0.25rem 0 0;
  font-size: 0.875rem;
  color: #FBCFE8;
  opacity: 0.9;
  font-weight: 500;
}
.close-drawer-btn {
  width: 2.75rem;
  height: 2.75rem;
  background: rgba(236, 72, 153, 0.25);
  border: 2px solid rgba(219, 39, 119, 0.5);
  border-radius: 50%;
  color: #FCE7F3;
  font-size: 1.5rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  flex-shrink: 0;
}
.close-drawer-btn:hover {
  background: rgba(236, 72, 153, 0.4);
  transform: rotate(90deg) scale(1.1);
}
/* Search bar */
.drawer-search {
  padding: 1.25rem 1.75rem;
  background: rgba(0, 0, 0, 0.15);
}
.search-input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.1);
  border: 2px solid rgba(219, 39, 119, 0.3);
  border-radius: 12px;
  padding: 0.75rem 1rem;
  transition: all 0.3s ease;
}
.search-input-wrapper:focus-within {
  background: rgba(255, 255, 255, 0.15);
  border-color: rgba(244, 114, 182, 0.6);
  box-shadow: 0 0 16px rgba(236, 72, 153, 0.3);
}
.search-icon {
  font-size: 1.25rem;
  margin-right: 0.75rem;
  flex-shrink: 0;
}
.search-input {
  flex: 1;
  background: transparent;
  border: none;
  outline: none;
  color: #FCE7F3;
  font-size: 1rem;
  font-weight: 500;
}
.search-input::placeholder {
  color: rgba(252, 231, 243, 0.5);
}
/* Navigation */
.drawer-nav {
  flex: 1;
  overflow-y: auto;
  padding: 1.25rem 0;
}
.drawer-menu {
  list-style: none;
  margin: 0;
  padding: 0 1rem;
}
.drawer-menu-item {
  margin: 0.5rem 0;
}
.drawer-link {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem 1.25rem;
  cursor: pointer;
  transition: all 0.35s ease;
  border-radius: 14px;
  position: relative;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.05);
  border: 2px solid transparent;
}
.drawer-link::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, rgba(244, 114, 182, 0.2) 0%, transparent 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
}
.drawer-link:hover {
  background: rgba(159, 18, 57, 0.5);
  border-color: rgba(219, 39, 119, 0.4);
  transform: translateX(8px);
  box-shadow: 0 6px 20px rgba(236, 72, 153, 0.2);
}
.drawer-link:hover::before {
  opacity: 1;
}
.drawer-link.link-active {
  background: linear-gradient(135deg, rgba(244, 114, 182, 0.35) 0%, rgba(244, 114, 182, 0.15) 100%);
  border-color: #F472B6;
  box-shadow: 0 6px 24px rgba(244, 114, 182, 0.4), inset 0 0 24px rgba(236, 72, 153, 0.2);
  font-weight: 600;
}
.link-main {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex: 1;
}
.link-icon {
  font-size: 1.625rem;
  width: 2.25rem;
  text-align: center;
  flex-shrink: 0;
  filter: drop-shadow(0 3px 6px rgba(0, 0, 0, 0.3));
}
.link-text {
  font-size: 1.0625rem;
  font-weight: 500;
  letter-spacing: 0.3px;
}
.chevron-icon {
  font-size: 1.5rem;
  transition: transform 0.35s ease;
  color: #FBCFE8;
  font-weight: bold;
}
.chevron-icon.chevron-rotated {
  transform: rotate(90deg);
}
/* Submenu */
.drawer-submenu {
  list-style: none;
  margin: 0.75rem 0 0;
  padding: 0.75rem 0;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 10px;
  border-left: 3px solid rgba(219, 39, 119, 0.6);
  margin-left: 2rem;
}
.drawer-submenu-item {
  margin: 0.25rem 0;
}
.drawer-sublink {
  display: flex;
  align-items: center;
  gap: 0.875rem;
  padding: 0.875rem 1.25rem;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 8px;
}
.drawer-sublink:hover {
  background: rgba(159, 18, 57, 0.4);
  padding-left: 1.75rem;
}
.drawer-sublink.link-active {
  background: linear-gradient(90deg, rgba(244, 114, 182, 0.3) 0%, transparent 100%);
  border-left: 3px solid #F472B6;
  font-weight: 600;
}
.sublink-icon {
  font-size: 1.25rem;
  width: 1.75rem;
  text-align: center;
  flex-shrink: 0;
}
.sublink-text {
  font-size: 0.9375rem;
  font-weight: 500;
}
/* Divider */
.drawer-divider {
  height: 2px;
  background: linear-gradient(90deg, transparent 0%, rgba(219, 39, 119, 0.5) 50%, transparent 100%);
  margin: 1rem 1.75rem;
}
/* Info section */
.drawer-info-section {
  padding: 1rem 1.75rem;
}
.info-card {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: rgba(236, 72, 153, 0.15);
  border: 2px solid rgba(219, 39, 119, 0.3);
  border-radius: 12px;
}
.info-icon {
  font-size: 2rem;
  flex-shrink: 0;
  filter: drop-shadow(0 2px 6px rgba(0, 0, 0, 0.3));
}
.info-content {
  flex: 1;
}
.info-title {
  margin: 0;
  font-size: 0.9375rem;
  font-weight: 700;
  color: #FCE7F3;
}
.info-text {
  margin: 0.25rem 0 0;
  font-size: 0.8125rem;
  color: #FBCFE8;
  opacity: 0.9;
}
/* Footer */
.drawer-footer {
  padding: 1.75rem;
  border-top: 2px solid rgba(219, 39, 119, 0.4);
  background: linear-gradient(0deg, rgba(244, 114, 182, 0.1) 0%, transparent 100%);
  margin-top: auto;
}
.footer-profile {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}
.profile-card {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: rgba(236, 72, 153, 0.2);
  border-radius: 16px;
  border: 2px solid rgba(219, 39, 119, 0.4);
}
.profile-img-wrapper {
  position: relative;
  flex-shrink: 0;
}
.profile-img {
  width: 3.25rem;
  height: 3.25rem;
  background: linear-gradient(135deg, #F472B6 0%, #EC4899 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.625rem;
  box-shadow: 0 4px 16px rgba(236, 72, 153, 0.5);
  border: 3px solid rgba(219, 39, 119, 0.3);
}
.online-badge {
  position: absolute;
  bottom: 2px;
  right: 2px;
  width: 1rem;
  height: 1rem;
  background: #10B981;
  border: 3px solid #881337;
  border-radius: 50%;
  box-shadow: 0 0 12px #10B981;
  animation: online-pulse 2s ease-in-out infinite;
}
@keyframes online-pulse {
  0%, 100% {
    opacity: 1;
    box-shadow: 0 0 12px #10B981;
  }
  50% {
    opacity: 0.7;
    box-shadow: 0 0 6px #10B981;
  }
}
.profile-details {
  flex: 1;
  min-width: 0;
}
.profile-name {
  margin: 0;
  font-size: 1.0625rem;
  font-weight: 700;
  color: #FCE7F3;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.profile-email {
  margin: 0.375rem 0 0;
  font-size: 0.8125rem;
  color: #FBCFE8;
  opacity: 0.85;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.footer-actions {
  display: flex;
  gap: 0.75rem;
  justify-content: center;
}
.action-icon-btn {
  width: 3rem;
  height: 3rem;
  background: rgba(236, 72, 153, 0.25);
  border: 2px solid rgba(219, 39, 119, 0.5);
  border-radius: 12px;
  font-size: 1.375rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}
.action-icon-btn:hover {
  background: rgba(236, 72, 153, 0.4);
  transform: translateY(-4px);
  box-shadow: 0 8px 20px rgba(236, 72, 153, 0.3);
}
/* Transitions */
.overlay-fade-enter-active,
.overlay-fade-leave-active {
  transition: opacity 0.35s ease;
}
.overlay-fade-enter-from,
.overlay-fade-leave-to {
  opacity: 0;
}
.drawer-slide-enter-active,
.drawer-slide-leave-active {
  transition: transform 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}
.drawer-left.drawer-slide-enter-from,
.drawer-left.drawer-slide-leave-to {
  transform: translateX(-100%);
}
.drawer-right.drawer-slide-enter-from,
.drawer-right.drawer-slide-leave-to {
  transform: translateX(100%);
}
.drawer-submenu-enter-active,
.drawer-submenu-leave-active {
  transition: all 0.4s ease;
  overflow: hidden;
}
.drawer-submenu-enter-from,
.drawer-submenu-leave-to {
  opacity: 0;
  max-height: 0;
  margin-top: 0;
  padding-top: 0;
  padding-bottom: 0;
}
.drawer-submenu-enter-to,
.drawer-submenu-leave-from {
  opacity: 1;
  max-height: 800px;
}
/* Scrollbar */
.drawer-nav::-webkit-scrollbar {
  width: 8px;
}
.drawer-nav::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.25);
  border-radius: 4px;
}
.drawer-nav::-webkit-scrollbar-thumb {
  background: rgba(219, 39, 119, 0.6);
  border-radius: 4px;
}
.drawer-nav::-webkit-scrollbar-thumb:hover {
  background: rgba(244, 114, 182, 0.8);
}
/* Mobile responsive */
@media (max-width: 768px) {
  .drawer-sidebar {
    width: 92vw !important;
    max-width: 400px;
  }
  .drawer-fab {
    bottom: 1.5rem;
    right: 1.5rem;
    width: 3.5rem;
    height: 3.5rem;
  }
}
</style>
