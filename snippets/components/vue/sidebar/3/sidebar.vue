<template>
  <div class="mini-sidebar-wrapper">
    <!-- Toggle button -->
    <button
      class="mini-toggle"
      @click="handleToggle"
      :style="toggleStyles"
      :class="{ 'expanded': isOpen }"
    >
      <span class="toggle-icon">{{ isOpen ? '◀' : '▶' }}</span>
    </button>
    <!-- Mini Sidebar - Always visible, expands on hover or click -->
    <aside
      class="mini-sidebar"
      :class="[`position-${position}`, { 'expanded': isOpen }]"
      :style="sidebarStyles"
      @mouseenter="handleMouseEnter"
      @mouseleave="handleMouseLeave"
    >
      <!-- Brand section -->
      <div class="brand-section">
        <Transition name="fade-slide">
          <div v-if="isOpen || isHovered" class="brand-expanded">
            <div class="brand-icon">🍃</div>
            <h2 class="brand-name">Dashboard</h2>
          </div>
          <div v-else class="brand-mini">
            <div class="brand-icon-mini">🍃</div>
          </div>
        </Transition>
      </div>
      <!-- Navigation -->
      <nav class="mini-nav">
        <ul class="nav-list">
          <li
            v-for="item in items"
            :key="item.id"
            class="nav-item"
          >
            <div
              class="nav-link"
              :class="{
                'active': activeItemId === item.id,
                'has-submenu': item.children?.length
              }"
              @click="handleItemClick(item)"
            >
              <span class="nav-icon" :title="item.label">{{ item.icon || '●' }}</span>
              <Transition name="fade-slide">
                <span v-if="isOpen || isHovered" class="nav-label">{{ item.label }}</span>
              </Transition>
              <Transition name="fade-slide">
                <span
                  v-if="(isOpen || isHovered) && item.children && item.children.length > 0"
                  class="nav-chevron"
                  :class="{ 'rotated': expandedItems.has(item.id) }"
                >
                  ▸
                </span>
              </Transition>
            </div>
            <!-- Nested submenu -->
            <Transition name="submenu-slide">
              <ul
                v-if="(isOpen || isHovered) && item.children && expandedItems.has(item.id)"
                class="submenu"
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
                    <span class="submenu-icon">{{ child.icon || '○' }}</span>
                    <span class="submenu-label">{{ child.label }}</span>
                  </div>
                </li>
              </ul>
            </Transition>
          </li>
        </ul>
      </nav>
      <!-- Footer section -->
      <div class="mini-footer">
        <Transition name="fade-slide">
          <div v-if="isOpen || isHovered" class="footer-expanded">
            <slot name="footer">
              <div class="profile-section">
                <div class="profile-avatar">👨</div>
                <div class="profile-info">
                  <p class="profile-name">User</p>
                  <p class="profile-status">Online</p>
                </div>
              </div>
            </slot>
          </div>
          <div v-else class="footer-mini">
            <div class="avatar-mini">👨</div>
          </div>
        </Transition>
      </div>
    </aside>
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
  width: '260px',
  variant: 'mini'
});
// Emerald Green theme
const defaultTheme: SidebarTheme = {
  primaryColor: '#10B981',
  backgroundColor: '#065F46',
  textColor: '#D1FAE5',
  activeColor: '#34D399',
  hoverColor: '#047857',
  borderColor: '#059669'
};
// Emits
const emit = defineEmits<{
  'item-clicked': [item: SidebarItem];
  'toggle': [isOpen: boolean];
}>();
// State
const activeItemId = ref<string | null>(null);
const expandedItems = ref<Set<string>>(new Set());
const isHovered = ref(false);
// Computed
const mergedTheme = computed<SidebarTheme>(() => ({
  ...defaultTheme,
  ...props.theme
}));
const sidebarStyles = computed(() => ({
  width: (isOpen.value || isHovered.value) ? props.width : '80px',
  backgroundColor: mergedTheme.value.backgroundColor,
  color: mergedTheme.value.textColor,
  borderColor: mergedTheme.value.borderColor,
  [props.position]: 0
}));
const toggleStyles = computed(() => ({
  backgroundColor: mergedTheme.value.primaryColor,
  borderColor: mergedTheme.value.borderColor,
  [props.position]: (isOpen.value || isHovered.value) ? props.width : '80px'
}));
// Methods
const handleToggle = () => {
  emit('toggle', !props.isOpen);
};
const handleMouseEnter = () => {
  if (!props.isOpen && props.variant === 'mini') {
    isHovered.value = true;
  }
};
const handleMouseLeave = () => {
  isHovered.value = false;
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
.mini-sidebar-wrapper {
  position: relative;
  height: 100vh;
}
/* Toggle button */
.mini-toggle {
  position: fixed;
  top: 50%;
  transform: translateY(-50%);
  width: 2.5rem;
  height: 3.5rem;
  border: 2px solid;
  border-radius: 0 0.5rem 0.5rem 0;
  cursor: pointer;
  z-index: 1001;
  transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 2px 0 12px rgba(16, 185, 129, 0.3);
}
.mini-toggle:hover {
  transform: translateY(-50%) translateX(5px);
  box-shadow: 4px 0 20px rgba(16, 185, 129, 0.5);
}
.mini-toggle.expanded {
  border-radius: 0.5rem 0 0 0.5rem;
}
.toggle-icon {
  color: white;
  font-size: 1.125rem;
  font-weight: bold;
}
/* Mini Sidebar */
.mini-sidebar {
  position: fixed;
  top: 0;
  bottom: 0;
  height: 100vh;
  z-index: 1000;
  display: flex;
  flex-direction: column;
  transition: width 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  overflow: hidden;
  background: linear-gradient(180deg, #065F46 0%, #047857 100%);
  box-shadow: 4px 0 16px rgba(5, 150, 105, 0.25);
}
.position-left {
  left: 0;
  border-right: 3px solid;
}
.position-right {
  right: 0;
  border-left: 3px solid;
}
/* Brand section */
.brand-section {
  padding: 1.5rem;
  border-bottom: 2px solid rgba(5, 150, 105, 0.4);
  min-height: 5rem;
  display: flex;
  align-items: center;
  background: linear-gradient(135deg, rgba(52, 211, 153, 0.15) 0%, transparent 100%);
}
.brand-expanded {
  display: flex;
  align-items: center;
  gap: 1rem;
  width: 100%;
}
.brand-icon,
.brand-icon-mini {
  font-size: 2rem;
  flex-shrink: 0;
  width: 3rem;
  height: 3rem;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #34D399 0%, #10B981 100%);
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
}
.brand-mini {
  display: flex;
  justify-content: center;
  width: 100%;
}
.brand-name {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
  color: #D1FAE5;
  white-space: nowrap;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}
/* Navigation */
.mini-nav {
  flex: 1;
  overflow-y: auto;
  padding: 1rem 0;
}
.nav-list {
  list-style: none;
  margin: 0;
  padding: 0;
}
.nav-item {
  margin: 0.375rem 0;
}
.nav-link {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem 1.25rem;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  white-space: nowrap;
}
.nav-link::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 5px;
  height: 0;
  background: linear-gradient(180deg, #34D399 0%, #10B981 100%);
  transition: height 0.3s ease;
  border-radius: 0 3px 3px 0;
}
.nav-link:hover {
  background: rgba(4, 120, 87, 0.5);
}
.nav-link:hover::before {
  height: 70%;
}
.nav-link.active {
  background: linear-gradient(90deg, rgba(52, 211, 153, 0.3) 0%, rgba(52, 211, 153, 0.1) 100%);
  font-weight: 600;
  box-shadow: inset 0 0 16px rgba(16, 185, 129, 0.2);
}
.nav-link.active::before {
  height: 100%;
}
.nav-icon {
  font-size: 1.5rem;
  width: 2rem;
  text-align: center;
  flex-shrink: 0;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
}
.nav-label {
  flex: 1;
  font-size: 1rem;
  font-weight: 500;
}
.nav-chevron {
  font-size: 1rem;
  transition: transform 0.3s ease;
  color: #6EE7B7;
}
.nav-chevron.rotated {
  transform: rotate(90deg);
}
/* Submenu */
.submenu {
  list-style: none;
  margin: 0;
  padding: 0;
  background: rgba(0, 0, 0, 0.2);
  border-left: 3px solid rgba(5, 150, 105, 0.5);
  margin-left: 2.5rem;
  border-radius: 0 0 8px 0;
}
.submenu-item {
  margin: 0;
}
.submenu-link {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1.25rem;
  cursor: pointer;
  transition: all 0.3s ease;
  white-space: nowrap;
}
.submenu-link:hover {
  background: rgba(4, 120, 87, 0.4);
  padding-left: 1.5rem;
}
.submenu-link.active {
  background: linear-gradient(90deg, rgba(52, 211, 153, 0.25) 0%, transparent 100%);
  font-weight: 600;
  border-left: 2px solid #34D399;
}
.submenu-icon {
  font-size: 1.125rem;
  width: 1.5rem;
  text-align: center;
  flex-shrink: 0;
}
.submenu-label {
  flex: 1;
  font-size: 0.9375rem;
}
/* Footer section */
.mini-footer {
  padding: 1.5rem;
  border-top: 2px solid rgba(5, 150, 105, 0.4);
  margin-top: auto;
  min-height: 5rem;
  display: flex;
  align-items: center;
  background: linear-gradient(0deg, rgba(52, 211, 153, 0.1) 0%, transparent 100%);
}
.footer-expanded {
  width: 100%;
}
.footer-mini {
  display: flex;
  justify-content: center;
  width: 100%;
}
.profile-section {
  display: flex;
  align-items: center;
  gap: 0.875rem;
  padding: 0.75rem;
  background: rgba(16, 185, 129, 0.2);
  border-radius: 12px;
  border: 1px solid rgba(5, 150, 105, 0.4);
}
.profile-avatar,
.avatar-mini {
  width: 2.75rem;
  height: 2.75rem;
  background: linear-gradient(135deg, #34D399 0%, #10B981 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.375rem;
  flex-shrink: 0;
  box-shadow: 0 2px 8px rgba(16, 185, 129, 0.3);
}
.profile-info {
  flex: 1;
}
.profile-name {
  margin: 0;
  font-size: 0.9375rem;
  font-weight: 600;
  color: #D1FAE5;
}
.profile-status {
  margin: 0.25rem 0 0;
  font-size: 0.8125rem;
  color: #6EE7B7;
  display: flex;
  align-items: center;
  gap: 0.375rem;
}
.profile-status::before {
  content: '';
  width: 8px;
  height: 8px;
  background: #34D399;
  border-radius: 50%;
  box-shadow: 0 0 8px #34D399;
  animation: pulse 2s ease-in-out infinite;
}
@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}
/* Transitions */
.fade-slide-enter-active,
.fade-slide-leave-active {
  transition: all 0.3s ease;
}
.fade-slide-enter-from,
.fade-slide-leave-to {
  opacity: 0;
  transform: translateX(-10px);
}
.submenu-slide-enter-active,
.submenu-slide-leave-active {
  transition: all 0.3s ease;
  overflow: hidden;
}
.submenu-slide-enter-from,
.submenu-slide-leave-to {
  opacity: 0;
  max-height: 0;
}
.submenu-slide-enter-to,
.submenu-slide-leave-from {
  opacity: 1;
  max-height: 500px;
}
/* Scrollbar */
.mini-nav::-webkit-scrollbar {
  width: 6px;
}
.mini-nav::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.2);
}
.mini-nav::-webkit-scrollbar-thumb {
  background: rgba(5, 150, 105, 0.6);
  border-radius: 3px;
}
.mini-nav::-webkit-scrollbar-thumb:hover {
  background: rgba(16, 185, 129, 0.8);
}
/* Mobile responsive */
@media (max-width: 768px) {
  .mini-sidebar {
    width: 80px !important;
  }
  .mini-sidebar.expanded {
    width: 85vw !important;
    max-width: 300px !important;
  }
  .mini-toggle {
    display: none;
  }
}
</style>
