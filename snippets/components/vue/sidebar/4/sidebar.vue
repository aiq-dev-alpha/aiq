<template>
  <div class="responsive-sidebar-container">
    <!-- Backdrop overlay for mobile -->
    <Transition name="backdrop-fade">
      <div
        v-if="isOpen && isMobileView"
        class="sidebar-backdrop"
        @click="handleToggle"
      />
    </Transition>

    <!-- Hamburger menu button -->
    <button
      class="menu-button"
      :class="{ 'menu-open': isOpen }"
      @click="handleToggle"
      :style="menuButtonStyles"
    >
      <div class="menu-lines">
        <span class="line"></span>
        <span class="line"></span>
        <span class="line"></span>
      </div>
    </button>

    <!-- Responsive Sidebar -->
    <Transition :name="isMobileView ? 'slide-mobile' : 'slide-desktop'">
      <aside
        v-if="isOpen || !isMobileView"
        class="responsive-sidebar"
        :class="[
          `side-${position}`,
          { 'mobile-mode': isMobileView, 'desktop-mode': !isMobileView }
        ]"
        :style="responsiveSidebarStyles"
      >
        <!-- Header -->
        <header class="sidebar-header-section">
          <slot name="header">
            <div class="header-wrapper">
              <div class="logo-container">
                <div class="logo-badge">🌅</div>
                <div class="brand-info">
                  <h1 class="brand-text">Dashboard</h1>
                  <p class="brand-tagline">Control Panel</p>
                </div>
              </div>
              <button
                v-if="isMobileView"
                class="close-btn"
                @click="handleToggle"
                aria-label="Close sidebar"
              >
                ✕
              </button>
            </div>
          </slot>
        </header>

        <!-- Main Navigation -->
        <nav class="navigation-section">
          <div class="nav-title">Main Menu</div>
          <ul class="navigation-list">
            <li
              v-for="item in items"
              :key="item.id"
              class="navigation-item"
            >
              <div
                class="nav-item-link"
                :class="{
                  'is-active': activeItemId === item.id,
                  'has-children': item.children?.length
                }"
                @click="handleItemClick(item)"
              >
                <div class="nav-item-content">
                  <span v-if="item.icon" class="nav-item-icon">{{ item.icon }}</span>
                  <span class="nav-item-text">{{ item.label }}</span>
                </div>
                <span
                  v-if="item.children && item.children.length > 0"
                  class="expand-indicator"
                  :class="{ 'is-expanded': expandedItems.has(item.id) }"
                >
                  ❯
                </span>
              </div>

              <!-- Submenu items -->
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
                      class="submenu-item-link"
                      :class="{ 'is-active': activeItemId === child.id }"
                      @click="handleItemClick(child)"
                    >
                      <span v-if="child.icon" class="submenu-item-icon">{{ child.icon }}</span>
                      <span class="submenu-item-text">{{ child.label }}</span>
                    </div>
                  </li>
                </ul>
              </Transition>
            </li>
          </ul>
        </nav>

        <!-- Quick Actions -->
        <div class="quick-actions">
          <div class="nav-title">Quick Actions</div>
          <div class="action-buttons">
            <button class="action-btn" :style="{ borderColor: mergedTheme.borderColor }">
              <span class="action-icon">➕</span>
              <span class="action-text">New Item</span>
            </button>
            <button class="action-btn" :style="{ borderColor: mergedTheme.borderColor }">
              <span class="action-icon">⚙️</span>
              <span class="action-text">Settings</span>
            </button>
          </div>
        </div>

        <!-- Footer -->
        <footer class="sidebar-footer-section">
          <slot name="footer">
            <div class="user-profile-card">
              <div class="user-avatar-wrapper">
                <div class="user-avatar">👩</div>
                <div class="status-indicator"></div>
              </div>
              <div class="user-info">
                <p class="user-name-text">Sarah Johnson</p>
                <p class="user-role-text">Product Manager</p>
              </div>
              <button class="logout-btn" aria-label="Logout">
                <span>⎋</span>
              </button>
            </div>
          </slot>
        </footer>
      </aside>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue';

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
  width: '320px',
  variant: 'responsive'
});

// Sunset Orange theme
const defaultTheme: SidebarTheme = {
  primaryColor: '#F97316',
  backgroundColor: '#9A3412',
  textColor: '#FFEDD5',
  activeColor: '#FB923C',
  hoverColor: '#7C2D12',
  borderColor: '#EA580C'
};

// Emits
const emit = defineEmits<{
  'item-clicked': [item: SidebarItem];
  'toggle': [isOpen: boolean];
}>();

// State
const activeItemId = ref<string | null>(null);
const expandedItems = ref<Set<string>>(new Set());
const isMobileView = ref(false);

// Computed
const mergedTheme = computed<SidebarTheme>(() => ({
  ...defaultTheme,
  ...props.theme
}));

const responsiveSidebarStyles = computed(() => ({
  width: props.width,
  backgroundColor: mergedTheme.value.backgroundColor,
  color: mergedTheme.value.textColor,
  borderColor: mergedTheme.value.borderColor,
  [props.position]: 0
}));

const menuButtonStyles = computed(() => ({
  backgroundColor: mergedTheme.value.primaryColor,
  borderColor: mergedTheme.value.borderColor
}));

// Methods
const handleToggle = () => {
  emit('toggle', !props.isOpen);
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

    // Auto-close on mobile after selection
    if (isMobileView.value) {
      emit('toggle', false);
    }
  }
};

const checkMobileView = () => {
  isMobileView.value = window.innerWidth < 1024;
};

// Lifecycle
onMounted(() => {
  checkMobileView();
  window.addEventListener('resize', checkMobileView);
});

onUnmounted(() => {
  window.removeEventListener('resize', checkMobileView);
});
</script>

<style scoped>
.responsive-sidebar-container {
  position: relative;
}

/* Backdrop */
.sidebar-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.7);
  z-index: 998;
  backdrop-filter: blur(3px);
}

/* Menu button */
.menu-button {
  position: fixed;
  top: 1.5rem;
  left: 1.5rem;
  width: 3.75rem;
  height: 3.75rem;
  border: 3px solid;
  border-radius: 12px;
  cursor: pointer;
  z-index: 1002;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 10px 25px rgba(249, 115, 22, 0.3);
}

.menu-button:hover {
  transform: scale(1.08) rotate(5deg);
  box-shadow: 0 15px 35px rgba(249, 115, 22, 0.5);
}

.menu-button:active {
  transform: scale(0.95);
}

.menu-lines {
  display: flex;
  flex-direction: column;
  gap: 6px;
  width: 26px;
}

.line {
  width: 100%;
  height: 3px;
  background-color: white;
  border-radius: 3px;
  transition: all 0.35s ease;
}

.menu-open .line:nth-child(1) {
  transform: translateY(9px) rotate(45deg);
}

.menu-open .line:nth-child(2) {
  opacity: 0;
  transform: translateX(20px);
}

.menu-open .line:nth-child(3) {
  transform: translateY(-9px) rotate(-45deg);
}

/* Responsive Sidebar */
.responsive-sidebar {
  position: fixed;
  top: 0;
  bottom: 0;
  height: 100vh;
  z-index: 999;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  box-shadow: 6px 0 30px rgba(249, 115, 22, 0.25);
  background: linear-gradient(180deg, #9A3412 0%, #7C2D12 100%);
}

.side-left {
  left: 0;
  border-right: 3px solid;
}

.side-right {
  right: 0;
  border-left: 3px solid;
}

/* Header */
.sidebar-header-section {
  padding: 2rem 1.5rem 1.5rem;
  border-bottom: 2px solid rgba(234, 88, 12, 0.4);
  background: linear-gradient(135deg, rgba(251, 146, 60, 0.15) 0%, transparent 100%);
}

.header-wrapper {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
}

.logo-container {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex: 1;
}

.logo-badge {
  width: 3.5rem;
  height: 3.5rem;
  background: linear-gradient(135deg, #FB923C 0%, #F97316 100%);
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.75rem;
  box-shadow: 0 6px 16px rgba(249, 115, 22, 0.4);
  flex-shrink: 0;
}

.brand-info {
  flex: 1;
}

.brand-text {
  margin: 0;
  font-size: 1.75rem;
  font-weight: 800;
  color: #FFEDD5;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.4);
  line-height: 1.2;
}

.brand-tagline {
  margin: 0.25rem 0 0;
  font-size: 0.875rem;
  color: #FED7AA;
  opacity: 0.9;
  font-weight: 500;
}

.close-btn {
  width: 2.5rem;
  height: 2.5rem;
  background: rgba(249, 115, 22, 0.3);
  border: 2px solid rgba(234, 88, 12, 0.5);
  border-radius: 8px;
  color: #FFEDD5;
  font-size: 1.5rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.close-btn:hover {
  background: rgba(249, 115, 22, 0.5);
  transform: rotate(90deg);
}

/* Navigation */
.navigation-section {
  flex: 1;
  padding: 1.5rem 0;
  overflow-y: auto;
}

.nav-title {
  padding: 0.75rem 1.5rem;
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1.5px;
  color: #FED7AA;
  opacity: 0.8;
}

.navigation-list {
  list-style: none;
  margin: 0;
  padding: 0;
}

.navigation-item {
  margin: 0.375rem 0.75rem;
}

.nav-item-link {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem 1.25rem;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 12px;
  position: relative;
  overflow: hidden;
}

.nav-item-link::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(90deg, rgba(251, 146, 60, 0.2) 0%, transparent 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.nav-item-link:hover::before {
  opacity: 1;
}

.nav-item-link:hover {
  background: rgba(124, 45, 18, 0.6);
  transform: translateX(6px);
  box-shadow: 0 4px 12px rgba(249, 115, 22, 0.2);
}

.nav-item-link.is-active {
  background: linear-gradient(90deg, rgba(251, 146, 60, 0.4) 0%, rgba(251, 146, 60, 0.15) 100%);
  box-shadow: 0 4px 16px rgba(249, 115, 22, 0.3), inset 0 0 20px rgba(251, 146, 60, 0.2);
  border-left: 4px solid #FB923C;
  font-weight: 600;
}

.nav-item-content {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex: 1;
}

.nav-item-icon {
  font-size: 1.5rem;
  width: 2rem;
  text-align: center;
  flex-shrink: 0;
  filter: drop-shadow(0 2px 6px rgba(0, 0, 0, 0.3));
}

.nav-item-text {
  font-size: 1.0625rem;
  font-weight: 500;
  letter-spacing: 0.3px;
}

.expand-indicator {
  font-size: 0.875rem;
  transition: transform 0.3s ease;
  color: #FED7AA;
  font-weight: bold;
}

.expand-indicator.is-expanded {
  transform: rotate(90deg);
}

/* Submenu */
.submenu-list {
  list-style: none;
  margin: 0.5rem 0 0;
  padding: 0.5rem 0;
  background: rgba(0, 0, 0, 0.25);
  border-radius: 8px;
  border-left: 3px solid rgba(234, 88, 12, 0.5);
  margin-left: 1.5rem;
}

.submenu-item {
  margin: 0.25rem 0;
}

.submenu-item-link {
  display: flex;
  align-items: center;
  gap: 0.875rem;
  padding: 0.875rem 1.25rem;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 8px;
}

.submenu-item-link:hover {
  background: rgba(124, 45, 18, 0.5);
  padding-left: 1.5rem;
}

.submenu-item-link.is-active {
  background: linear-gradient(90deg, rgba(251, 146, 60, 0.3) 0%, transparent 100%);
  border-left: 2px solid #FB923C;
  font-weight: 600;
}

.submenu-item-icon {
  font-size: 1.125rem;
  width: 1.5rem;
  text-align: center;
  flex-shrink: 0;
}

.submenu-item-text {
  font-size: 0.9375rem;
  font-weight: 500;
}

/* Quick Actions */
.quick-actions {
  padding: 1rem 0.75rem;
  border-top: 2px solid rgba(234, 88, 12, 0.3);
  border-bottom: 2px solid rgba(234, 88, 12, 0.3);
}

.action-buttons {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.75rem;
  padding: 0 0.75rem;
}

.action-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  padding: 1rem 0.5rem;
  background: rgba(249, 115, 22, 0.15);
  border: 2px solid;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s ease;
  color: #FFEDD5;
}

.action-btn:hover {
  background: rgba(249, 115, 22, 0.3);
  transform: translateY(-3px);
  box-shadow: 0 6px 16px rgba(249, 115, 22, 0.3);
}

.action-icon {
  font-size: 1.5rem;
}

.action-text {
  font-size: 0.8125rem;
  font-weight: 600;
  text-align: center;
}

/* Footer */
.sidebar-footer-section {
  padding: 1.5rem;
  background: linear-gradient(0deg, rgba(251, 146, 60, 0.1) 0%, transparent 100%);
}

.user-profile-card {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: rgba(249, 115, 22, 0.2);
  border-radius: 14px;
  border: 2px solid rgba(234, 88, 12, 0.4);
}

.user-avatar-wrapper {
  position: relative;
  flex-shrink: 0;
}

.user-avatar {
  width: 3rem;
  height: 3rem;
  background: linear-gradient(135deg, #FB923C 0%, #F97316 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  box-shadow: 0 4px 12px rgba(249, 115, 22, 0.4);
}

.status-indicator {
  position: absolute;
  bottom: 0;
  right: 0;
  width: 0.875rem;
  height: 0.875rem;
  background: #22C55E;
  border: 2px solid #9A3412;
  border-radius: 50%;
  box-shadow: 0 0 10px #22C55E;
  animation: status-pulse 2s ease-in-out infinite;
}

@keyframes status-pulse {
  0%, 100% {
    opacity: 1;
    transform: scale(1);
  }
  50% {
    opacity: 0.7;
    transform: scale(0.9);
  }
}

.user-info {
  flex: 1;
  min-width: 0;
}

.user-name-text {
  margin: 0;
  font-size: 1rem;
  font-weight: 600;
  color: #FFEDD5;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.user-role-text {
  margin: 0.25rem 0 0;
  font-size: 0.8125rem;
  color: #FED7AA;
  opacity: 0.9;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.logout-btn {
  width: 2.25rem;
  height: 2.25rem;
  background: rgba(249, 115, 22, 0.3);
  border: 2px solid rgba(234, 88, 12, 0.5);
  border-radius: 8px;
  color: #FFEDD5;
  font-size: 1.25rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  flex-shrink: 0;
}

.logout-btn:hover {
  background: rgba(239, 68, 68, 0.4);
  border-color: #DC2626;
  transform: scale(1.1);
}

/* Transitions */
.backdrop-fade-enter-active,
.backdrop-fade-leave-active {
  transition: opacity 0.3s ease;
}

.backdrop-fade-enter-from,
.backdrop-fade-leave-to {
  opacity: 0;
}

.slide-mobile-enter-active,
.slide-mobile-leave-active {
  transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.side-left.slide-mobile-enter-from,
.side-left.slide-mobile-leave-to {
  transform: translateX(-100%);
}

.side-right.slide-mobile-enter-from,
.side-right.slide-mobile-leave-to {
  transform: translateX(100%);
}

.slide-desktop-enter-active,
.slide-desktop-leave-active {
  transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1);
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
  max-height: 700px;
}

/* Scrollbar */
.navigation-section::-webkit-scrollbar,
.responsive-sidebar::-webkit-scrollbar {
  width: 8px;
}

.navigation-section::-webkit-scrollbar-track,
.responsive-sidebar::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 4px;
}

.navigation-section::-webkit-scrollbar-thumb,
.responsive-sidebar::-webkit-scrollbar-thumb {
  background: rgba(234, 88, 12, 0.6);
  border-radius: 4px;
}

.navigation-section::-webkit-scrollbar-thumb:hover,
.responsive-sidebar::-webkit-scrollbar-thumb:hover {
  background: rgba(251, 146, 60, 0.8);
}

/* Mobile responsive */
@media (max-width: 1024px) {
  .responsive-sidebar.mobile-mode {
    width: 90vw !important;
    max-width: 380px;
  }
}

@media (min-width: 1024px) {
  .menu-button {
    display: none;
  }

  .close-btn {
    display: none;
  }

  .sidebar-backdrop {
    display: none;
  }
}
</style>
