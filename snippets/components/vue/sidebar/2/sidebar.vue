<template>
  <div class="sidebar-container">
    <!-- Toggle button -->
    <button
      class="sidebar-toggle-btn"
      :class="{ 'sidebar-open': isOpen }"
      @click="handleToggle"
      :style="toggleStyles"
    >
      <div class="hamburger-icon">
        <span></span>
        <span></span>
        <span></span>
      </div>
    </button>
    <!-- Main content wrapper that gets pushed -->
    <div class="content-wrapper" :class="{ 'pushed': isOpen && variant === 'push' }" :style="contentWrapperStyles">
      <!-- Sidebar -->
      <Transition name="slide-push">
        <aside
          v-if="isOpen"
          class="sidebar-push"
          :class="[`position-${position}`]"
          :style="sidebarStyles"
        >
          <!-- Header section -->
          <header class="sidebar-header">
            <slot name="header">
              <div class="header-content">
                <div class="logo-section">
                  <div class="logo-icon">
                    <span>🌊</span>
                  </div>
                  <h1 class="brand-title">Navigation</h1>
                </div>
              </div>
            </slot>
          </header>
          <!-- Navigation menu -->
          <nav class="sidebar-navigation">
            <ul class="menu-list">
              <li
                v-for="item in items"
                :key="item.id"
                class="menu-item"
              >
                <div
                  class="menu-link"
                  :class="{ 'active': activeItemId === item.id, 'has-children': item.children?.length }"
                  @click="handleItemClick(item)"
                >
                  <span v-if="item.icon" class="item-icon">{{ item.icon }}</span>
                  <span class="item-label">{{ item.label }}</span>
                  <span
                    v-if="item.children && item.children.length > 0"
                    class="expand-icon"
                    :class="{ 'expanded': expandedItems.has(item.id) }"
                  >
                    ›
                  </span>
                </div>
                <!-- Submenu -->
                <Transition name="submenu-expand">
                  <ul
                    v-if="item.children && expandedItems.has(item.id)"
                    class="submenu-list"
                  >
                    <li
                      v-for="child in item.children"
                      :key="child.id"
                      class="submenu-item"
                    >
                      <div
                        class="submenu-link"
                        :class="{ 'active': activeItemId === child.id }"
                        @click="handleItemClick(child)"
                      >
                        <span v-if="child.icon" class="item-icon">{{ child.icon }}</span>
                        <span class="item-label">{{ child.label }}</span>
                      </div>
                    </li>
                  </ul>
                </Transition>
              </li>
            </ul>
          </nav>
          <!-- Footer section -->
          <footer class="sidebar-footer">
            <slot name="footer">
              <div class="footer-content">
                <div class="user-info">
                  <div class="avatar">👤</div>
                  <div class="user-details">
                    <p class="user-name">User Profile</p>
                    <p class="user-role">Administrator</p>
                  </div>
                </div>
              </div>
            </slot>
          </footer>
        </aside>
      </Transition>
      <!-- Main content slot -->
      <main class="main-content">
        <slot />
      </main>
    </div>
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
  width: '280px',
  variant: 'push'
});
// Ocean Blue theme
const defaultTheme: SidebarTheme = {
  primaryColor: '#0284C7',
  backgroundColor: '#0C4A6E',
  textColor: '#E0F2FE',
  activeColor: '#0EA5E9',
  hoverColor: '#075985',
  borderColor: '#0891B2'
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
  width: props.width,
  backgroundColor: mergedTheme.value.backgroundColor,
  color: mergedTheme.value.textColor,
  borderColor: mergedTheme.value.borderColor,
  [props.position]: 0
}));
const toggleStyles = computed(() => ({
  backgroundColor: mergedTheme.value.primaryColor,
  borderColor: mergedTheme.value.borderColor
}));
const contentWrapperStyles = computed(() => {
  if (props.isOpen && props.variant === 'push') {
    return {
      marginLeft: props.position === 'left' ? props.width : '0',
      marginRight: props.position === 'right' ? props.width : '0'
    };
  }
  return {};
});
// Methods
const handleToggle = () => {
  emit('toggle', !props.isOpen);
};
const handleItemClick = (item: SidebarItem) => {
  if (item.children && item.children.length > 0) {
    // Toggle submenu expansion
    if (expandedItems.value.has(item.id)) {
      expandedItems.value.delete(item.id);
    } else {
      expandedItems.value.add(item.id);
    }
  } else {
    // Set as active and emit event
    activeItemId.value = item.id;
    emit('item-clicked', item);
  }
};
</script>
<style scoped>
.sidebar-container {
  position: relative;
  min-height: 100vh;
}
/* Toggle button */
.sidebar-toggle-btn {
  position: fixed;
  top: 1.25rem;
  left: 1.25rem;
  width: 3.5rem;
  height: 3.5rem;
  border: 3px solid;
  border-radius: 50%;
  cursor: pointer;
  z-index: 1001;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 8px 16px rgba(2, 132, 199, 0.25);
  display: flex;
  align-items: center;
  justify-content: center;
}
.sidebar-toggle-btn:hover {
  transform: rotate(90deg) scale(1.1);
  box-shadow: 0 12px 24px rgba(2, 132, 199, 0.4);
}
.sidebar-toggle-btn.sidebar-open {
  left: calc(280px + 1.25rem);
}
.hamburger-icon {
  display: flex;
  flex-direction: column;
  gap: 5px;
  width: 24px;
}
.hamburger-icon span {
  width: 100%;
  height: 3px;
  background-color: white;
  border-radius: 2px;
  transition: all 0.3s ease;
}
.sidebar-open .hamburger-icon span:nth-child(1) {
  transform: translateY(8px) rotate(45deg);
}
.sidebar-open .hamburger-icon span:nth-child(2) {
  opacity: 0;
  transform: translateX(-10px);
}
.sidebar-open .hamburger-icon span:nth-child(3) {
  transform: translateY(-8px) rotate(-45deg);
}
/* Content wrapper */
.content-wrapper {
  transition: margin 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  min-height: 100vh;
}
/* Sidebar */
.sidebar-push {
  position: fixed;
  top: 0;
  bottom: 0;
  height: 100vh;
  z-index: 1000;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: 4px 0 24px rgba(2, 132, 199, 0.2);
  background: linear-gradient(180deg, #0C4A6E 0%, #164E63 100%);
}
.position-left {
  left: 0;
  border-right: 3px solid;
}
.position-right {
  right: 0;
  border-left: 3px solid;
}
/* Header */
.sidebar-header {
  padding: 2rem 1.75rem;
  border-bottom: 2px solid rgba(8, 145, 178, 0.3);
  background: linear-gradient(135deg, rgba(14, 165, 233, 0.1) 0%, transparent 100%);
}
.header-content {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.logo-section {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.logo-icon {
  width: 3rem;
  height: 3rem;
  background: linear-gradient(135deg, #0EA5E9 0%, #0284C7 100%);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
}
.brand-title {
  margin: 0;
  font-size: 1.625rem;
  font-weight: 700;
  color: #E0F2FE;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
  letter-spacing: 0.5px;
}
/* Navigation */
.sidebar-navigation {
  flex: 1;
  overflow-y: auto;
  padding: 1.5rem 0;
}
.menu-list {
  list-style: none;
  margin: 0;
  padding: 0;
}
.menu-item {
  margin: 0.5rem 0;
}
.menu-link,
.submenu-link {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem 1.75rem;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  border-left: 4px solid transparent;
}
.menu-link::after {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 0;
  height: 70%;
  background: linear-gradient(90deg, #0EA5E9 0%, transparent 100%);
  transition: width 0.3s ease;
  border-radius: 0 4px 4px 0;
}
.menu-link:hover {
  background-color: rgba(7, 89, 133, 0.6);
  padding-left: 2rem;
}
.menu-link:hover::after {
  width: 6px;
}
.menu-link.active {
  background: linear-gradient(90deg, rgba(14, 165, 233, 0.3) 0%, rgba(14, 165, 233, 0.1) 100%);
  border-left-color: #0EA5E9;
  font-weight: 600;
  box-shadow: inset 0 0 20px rgba(14, 165, 233, 0.2);
}
.menu-link.active::after {
  width: 6px;
}
.item-icon {
  font-size: 1.375rem;
  width: 2rem;
  text-align: center;
  flex-shrink: 0;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.2));
}
.item-label {
  flex: 1;
  font-size: 1rem;
  font-weight: 500;
  letter-spacing: 0.3px;
}
.expand-icon {
  font-size: 1.25rem;
  transition: transform 0.3s ease;
  font-weight: bold;
  color: #7DD3FC;
}
.expand-icon.expanded {
  transform: rotate(90deg);
}
/* Submenu */
.submenu-list {
  list-style: none;
  margin: 0;
  padding: 0;
  background: rgba(0, 0, 0, 0.25);
  border-left: 3px solid rgba(8, 145, 178, 0.4);
  margin-left: 2rem;
  margin-top: 0.5rem;
}
.submenu-link {
  padding: 0.875rem 1.5rem;
  font-size: 0.9375rem;
  border-left: none;
}
.submenu-link:hover {
  background-color: rgba(7, 89, 133, 0.5);
}
.submenu-link.active {
  background: linear-gradient(90deg, rgba(14, 165, 233, 0.25) 0%, transparent 100%);
  border-left: 3px solid #0EA5E9;
  font-weight: 600;
}
/* Footer */
.sidebar-footer {
  padding: 1.75rem;
  border-top: 2px solid rgba(8, 145, 178, 0.3);
  margin-top: auto;
  background: linear-gradient(0deg, rgba(14, 165, 233, 0.05) 0%, transparent 100%);
}
.footer-content {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}
.user-info {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.75rem;
  background: rgba(14, 165, 233, 0.15);
  border-radius: 12px;
  border: 1px solid rgba(8, 145, 178, 0.3);
}
.avatar {
  width: 2.5rem;
  height: 2.5rem;
  background: linear-gradient(135deg, #0EA5E9 0%, #0284C7 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.25rem;
  flex-shrink: 0;
}
.user-details {
  flex: 1;
}
.user-name {
  margin: 0;
  font-size: 0.9375rem;
  font-weight: 600;
  color: #E0F2FE;
}
.user-role {
  margin: 0.25rem 0 0;
  font-size: 0.8125rem;
  color: #7DD3FC;
  opacity: 0.9;
}
/* Main content */
.main-content {
  min-height: 100vh;
}
/* Transitions */
.slide-push-enter-active,
.slide-push-leave-active {
  transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}
.position-left.slide-push-enter-from,
.position-left.slide-push-leave-to {
  transform: translateX(-100%);
}
.position-right.slide-push-enter-from,
.position-right.slide-push-leave-to {
  transform: translateX(100%);
}
.submenu-expand-enter-active,
.submenu-expand-leave-active {
  transition: all 0.35s ease;
  overflow: hidden;
}
.submenu-expand-enter-from,
.submenu-expand-leave-to {
  opacity: 0;
  max-height: 0;
  margin-top: 0;
}
.submenu-expand-enter-to,
.submenu-expand-leave-from {
  opacity: 1;
  max-height: 600px;
}
/* Scrollbar */
.sidebar-navigation::-webkit-scrollbar {
  width: 8px;
}
.sidebar-navigation::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 4px;
}
.sidebar-navigation::-webkit-scrollbar-thumb {
  background: rgba(8, 145, 178, 0.6);
  border-radius: 4px;
}
.sidebar-navigation::-webkit-scrollbar-thumb:hover {
  background: rgba(14, 165, 233, 0.8);
}
/* Mobile responsive */
@media (max-width: 768px) {
  .sidebar-push {
    width: 90vw !important;
    max-width: 340px;
  }
  .content-wrapper.pushed {
    margin-left: 0 !important;
    margin-right: 0 !important;
  }
  .sidebar-toggle-btn.sidebar-open {
    left: 1.25rem;
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
