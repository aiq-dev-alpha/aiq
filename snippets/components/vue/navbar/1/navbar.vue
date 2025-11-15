<template>
  <nav
    :class="[
      'navbar',
      `navbar-${variant}`,
      { 'navbar-sticky': sticky, 'navbar-transparent': transparent }
    ]"
    :style="navbarStyles"
  >
    <div class="navbar-container">
      <!-- Logo/Brand Section -->
      <div class="navbar-brand">
        <img v-if="logo" :src="logo" alt="Logo" class="navbar-logo" />
        <span class="navbar-brand-text">{{ brandName }}</span>
      </div>
      <!-- Desktop Menu -->
      <div class="navbar-menu" :class="{ 'navbar-menu-open': mobileMenuOpen }">
        <div
          v-for="item in items"
          :key="item.id"
          class="navbar-item-wrapper"
          @mouseenter="handleMouseEnter(item.id)"
          @mouseleave="handleMouseLeave"
        >
          <a
            :href="item.route"
            :class="['navbar-item', { active: activeItem === item.id }]"
            :style="getItemStyles(item.id)"
            @click.prevent="handleItemClick(item)"
          >
            <span v-if="item.icon" class="navbar-item-icon">{{ item.icon }}</span>
            <span class="navbar-item-label">{{ item.label }}</span>
            <span v-if="item.dropdown" class="navbar-item-arrow">▼</span>
          </a>
          <!-- Dropdown Menu -->
          <div
            v-if="item.dropdown && item.dropdown.length"
            :class="['navbar-dropdown', { active: hoveredItem === item.id || activeDropdown === item.id }]"
            :style="dropdownStyles"
          >
            <a
              v-for="child in item.dropdown"
              :key="child.id"
              :href="child.route"
              class="navbar-dropdown-item"
              :style="dropdownItemStyles"
              @click.prevent="handleItemClick(child)"
            >
              <span v-if="child.icon" class="navbar-dropdown-icon">{{ child.icon }}</span>
              <span>{{ child.label }}</span>
            </a>
          </div>
        </div>
      </div>
      <!-- Right Section -->
      <div class="navbar-actions">
        <!-- Search Bar Slot -->
        <div v-if="$slots.search" class="navbar-search">
          <slot name="search"></slot>
        </div>
        <!-- Notifications -->
        <div v-if="showNotifications" class="navbar-notification">
          <button class="navbar-notification-btn" :style="actionButtonStyles">
            <span class="navbar-notification-icon">🔔</span>
            <span v-if="notificationCount > 0" class="navbar-notification-badge" :style="badgeStyles">
              {{ notificationCount }}
            </span>
          </button>
        </div>
        <!-- User Profile Slot -->
        <div v-if="$slots.profile" class="navbar-profile">
          <slot name="profile"></slot>
        </div>
        <!-- Mobile Menu Toggle -->
        <button
          class="navbar-mobile-toggle"
          :style="actionButtonStyles"
          @click="toggleMobileMenu"
        >
          <span class="navbar-hamburger">{{ mobileMenuOpen ? '✕' : '☰' }}</span>
        </button>
      </div>
    </div>
    <!-- Mobile Menu Overlay -->
    <transition name="mobile-menu">
      <div v-if="mobileMenuOpen" class="navbar-mobile-overlay" :style="mobileOverlayStyles">
        <div class="navbar-mobile-menu">
          <div
            v-for="item in items"
            :key="item.id"
            class="navbar-mobile-item-wrapper"
          >
            <a
              :href="item.route"
              :class="['navbar-mobile-item', { active: activeItem === item.id }]"
              :style="getMobileItemStyles(item.id)"
              @click="handleMobileItemClick(item)"
            >
              <span v-if="item.icon" class="navbar-mobile-icon">{{ item.icon }}</span>
              <span>{{ item.label }}</span>
              <span v-if="item.dropdown" class="navbar-mobile-arrow">▼</span>
            </a>
            <!-- Mobile Dropdown -->
            <div
              v-if="item.dropdown && item.dropdown.length && activeDropdown === item.id"
              class="navbar-mobile-dropdown"
            >
              <a
                v-for="child in item.dropdown"
                :key="child.id"
                :href="child.route"
                class="navbar-mobile-dropdown-item"
                @click="handleMobileItemClick(child)"
              >
                <span v-if="child.icon">{{ child.icon }}</span>
                <span>{{ child.label }}</span>
              </a>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </nav>
</template>
<script setup lang="ts">
import { ref, computed, defineProps, withDefaults } from 'vue'
interface NavbarTheme {
  primary: string
  background: string
  text: string
  activeColor: string
  hoverColor: string
}
interface NavItem {
  id: string
  label: string
  icon?: string
  route: string
  dropdown?: NavItem[]
}
interface Props {
  items: NavItem[]
  logo?: string
  brandName?: string
  variant?: 'solid' | 'transparent' | 'blur' | 'gradient' | 'minimal'
  sticky?: boolean
  transparent?: boolean
  theme?: Partial<NavbarTheme>
  showNotifications?: boolean
  notificationCount?: number
}
const props = withDefaults(defineProps<Props>(), {
  items: () => [],
  brandName: 'Brand',
  variant: 'solid',
  sticky: false,
  transparent: false,
  theme: () => ({}),
  showNotifications: true,
  notificationCount: 0
})
// State
const mobileMenuOpen = ref(false)
const activeItem = ref<string | null>(null)
const hoveredItem = ref<string | null>(null)
const activeDropdown = ref<string | null>(null)
// Default theme for variant 1 - Solid Dark Theme
const defaultTheme: NavbarTheme = {
  primary: '#1a1a2e',
  background: '#16213e',
  text: '#e4e4e4',
  activeColor: '#0f3460',
  hoverColor: '#533483'
}
const mergedTheme = computed<NavbarTheme>(() => ({
  ...defaultTheme,
  ...props.theme
}))
// Computed Styles
const navbarStyles = computed(() => ({
  backgroundColor: props.transparent ? 'transparent' : mergedTheme.value.background,
  color: mergedTheme.value.text,
  borderBottom: `2px solid ${mergedTheme.value.primary}`
}))
const dropdownStyles = computed(() => ({
  backgroundColor: mergedTheme.value.background,
  borderColor: mergedTheme.value.primary
}))
const dropdownItemStyles = computed(() => ({
  color: mergedTheme.value.text
}))
const actionButtonStyles = computed(() => ({
  color: mergedTheme.value.text,
  borderColor: mergedTheme.value.primary
}))
const badgeStyles = computed(() => ({
  backgroundColor: mergedTheme.value.activeColor,
  color: '#fff'
}))
const mobileOverlayStyles = computed(() => ({
  backgroundColor: mergedTheme.value.background
}))
// Methods
const getItemStyles = (itemId: string) => ({
  color: activeItem.value === itemId ? mergedTheme.value.activeColor : mergedTheme.value.text,
  backgroundColor: hoveredItem.value === itemId ? mergedTheme.value.hoverColor : 'transparent',
  borderBottomColor: activeItem.value === itemId ? mergedTheme.value.activeColor : 'transparent'
})
const getMobileItemStyles = (itemId: string) => ({
  color: activeItem.value === itemId ? mergedTheme.value.activeColor : mergedTheme.value.text,
  backgroundColor: activeItem.value === itemId ? mergedTheme.value.hoverColor : 'transparent'
})
const handleMouseEnter = (itemId: string) => {
  hoveredItem.value = itemId
}
const handleMouseLeave = () => {
  hoveredItem.value = null
}
const handleItemClick = (item: NavItem) => {
  if (item.dropdown && item.dropdown.length) {
    activeDropdown.value = activeDropdown.value === item.id ? null : item.id
  } else {
    activeItem.value = item.id
    activeDropdown.value = null
  }
}
const handleMobileItemClick = (item: NavItem) => {
  if (item.dropdown && item.dropdown.length) {
    activeDropdown.value = activeDropdown.value === item.id ? null : item.id
  } else {
    activeItem.value = item.id
    mobileMenuOpen.value = false
    activeDropdown.value = null
  }
}
const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value
}
</script>
<style scoped>
.navbar {
  position: relative;
  width: 100%;
  padding: 0;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}
.navbar-sticky {
  position: sticky;
  top: 0;
  z-index: 1000;
}
.navbar-container {
  max-width: 1400px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem 2rem;
}
.navbar-brand {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 1.5rem;
  font-weight: 700;
  cursor: pointer;
}
.navbar-logo {
  height: 40px;
  width: auto;
}
.navbar-menu {
  display: none;
  gap: 0.5rem;
  flex: 1;
  justify-content: center;
}
@media (min-width: 768px) {
  .navbar-menu {
    display: flex;
  }
}
.navbar-item-wrapper {
  position: relative;
}
.navbar-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.25rem;
  text-decoration: none;
  border-radius: 8px;
  transition: all 0.3s ease;
  border-bottom: 3px solid transparent;
  font-weight: 500;
  white-space: nowrap;
}
.navbar-item:hover {
  transform: translateY(-2px);
}
.navbar-item.active {
  font-weight: 700;
}
.navbar-item-icon {
  font-size: 1.1rem;
}
.navbar-item-arrow {
  font-size: 0.7rem;
  margin-left: 0.25rem;
}
.navbar-dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  min-width: 200px;
  margin-top: 0.5rem;
  padding: 0.5rem;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
  opacity: 0;
  visibility: hidden;
  transform: translateY(-10px);
  transition: all 0.3s ease;
  z-index: 100;
  border: 1px solid;
}
.navbar-dropdown.active {
  opacity: 1;
  visibility: visible;
  transform: translateY(0);
}
.navbar-dropdown-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1rem;
  text-decoration: none;
  border-radius: 6px;
  transition: all 0.2s ease;
}
.navbar-dropdown-item:hover {
  background-color: rgba(255, 255, 255, 0.1);
  transform: translateX(4px);
}
.navbar-dropdown-icon {
  font-size: 1rem;
}
.navbar-actions {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.navbar-search {
  display: none;
}
@media (min-width: 768px) {
  .navbar-search {
    display: block;
  }
}
.navbar-notification {
  position: relative;
}
.navbar-notification-btn {
  position: relative;
  background: transparent;
  border: 1px solid;
  border-radius: 50%;
  width: 42px;
  height: 42px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
}
.navbar-notification-btn:hover {
  transform: scale(1.1);
  background-color: rgba(255, 255, 255, 0.1);
}
.navbar-notification-icon {
  font-size: 1.25rem;
}
.navbar-notification-badge {
  position: absolute;
  top: -4px;
  right: -4px;
  min-width: 20px;
  height: 20px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.7rem;
  font-weight: 700;
  padding: 0 6px;
}
.navbar-mobile-toggle {
  display: flex;
  background: transparent;
  border: 1px solid;
  border-radius: 8px;
  padding: 0.5rem 0.75rem;
  cursor: pointer;
  transition: all 0.3s ease;
}
@media (min-width: 768px) {
  .navbar-mobile-toggle {
    display: none;
  }
}
.navbar-mobile-toggle:hover {
  background-color: rgba(255, 255, 255, 0.1);
}
.navbar-hamburger {
  font-size: 1.5rem;
}
.navbar-mobile-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100vh;
  z-index: 999;
  overflow-y: auto;
  padding-top: 80px;
}
@media (min-width: 768px) {
  .navbar-mobile-overlay {
    display: none;
  }
}
.navbar-mobile-menu {
  padding: 2rem;
}
.navbar-mobile-item-wrapper {
  margin-bottom: 0.5rem;
}
.navbar-mobile-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1.5rem;
  text-decoration: none;
  border-radius: 8px;
  transition: all 0.3s ease;
  font-size: 1.1rem;
  font-weight: 500;
}
.navbar-mobile-icon {
  font-size: 1.3rem;
}
.navbar-mobile-arrow {
  margin-left: auto;
  font-size: 0.8rem;
}
.navbar-mobile-dropdown {
  margin-left: 2rem;
  margin-top: 0.5rem;
}
.navbar-mobile-dropdown-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1.25rem;
  text-decoration: none;
  border-radius: 6px;
  transition: all 0.2s ease;
  opacity: 0.9;
}
.navbar-mobile-dropdown-item:hover {
  background-color: rgba(255, 255, 255, 0.1);
  opacity: 1;
}
.mobile-menu-enter-active,
.mobile-menu-leave-active {
  transition: all 0.3s ease;
}
.mobile-menu-enter-from {
  opacity: 0;
  transform: translateX(-100%);
}
.mobile-menu-leave-to {
  opacity: 0;
  transform: translateX(-100%);
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
