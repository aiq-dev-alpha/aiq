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
    <transition name="mobile-menu-fade">
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
  variant: 'minimal',
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

// Default theme for variant 4 - Minimal Light
const defaultTheme: NavbarTheme = {
  primary: '#2563eb',
  background: '#ffffff',
  text: '#1f2937',
  activeColor: '#2563eb',
  hoverColor: '#f3f4f6'
}

const mergedTheme = computed<NavbarTheme>(() => ({
  ...defaultTheme,
  ...props.theme
}))

// Computed Styles
const navbarStyles = computed(() => ({
  backgroundColor: props.transparent ? 'transparent' : mergedTheme.value.background,
  color: mergedTheme.value.text,
  borderBottom: `1px solid #e5e7eb`
}))

const dropdownStyles = computed(() => ({
  backgroundColor: mergedTheme.value.background,
  border: `1px solid #e5e7eb`,
  boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)'
}))

const dropdownItemStyles = computed(() => ({
  color: mergedTheme.value.text
}))

const actionButtonStyles = computed(() => ({
  color: mergedTheme.value.text,
  backgroundColor: 'transparent',
  border: '1px solid #e5e7eb'
}))

const badgeStyles = computed(() => ({
  backgroundColor: mergedTheme.value.activeColor,
  color: '#ffffff'
}))

const mobileOverlayStyles = computed(() => ({
  backgroundColor: mergedTheme.value.background
}))

// Methods
const getItemStyles = (itemId: string) => {
  const isActive = activeItem.value === itemId
  const isHovered = hoveredItem.value === itemId

  return {
    color: isActive ? mergedTheme.value.activeColor : mergedTheme.value.text,
    backgroundColor: isHovered ? mergedTheme.value.hoverColor : 'transparent',
    borderBottom: isActive ? `2px solid ${mergedTheme.value.activeColor}` : '2px solid transparent'
  }
}

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
  transition: all 0.2s ease;
}

.navbar-sticky {
  position: sticky;
  top: 0;
  z-index: 1000;
}

.navbar-container {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.75rem 1.5rem;
}

.navbar-brand {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1.25rem;
  font-weight: 600;
  cursor: pointer;
  transition: opacity 0.2s ease;
}

.navbar-brand:hover {
  opacity: 0.8;
}

.navbar-logo {
  height: 32px;
  width: auto;
}

.navbar-menu {
  display: none;
  gap: 0.25rem;
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
  gap: 0.375rem;
  padding: 0.625rem 1rem;
  text-decoration: none;
  transition: all 0.2s ease;
  font-weight: 500;
  white-space: nowrap;
  font-size: 0.875rem;
  border-radius: 0;
}

.navbar-item.active {
  font-weight: 600;
}

.navbar-item-icon {
  font-size: 1rem;
}

.navbar-item-arrow {
  font-size: 0.625rem;
  margin-left: 0.125rem;
}

.navbar-dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  min-width: 180px;
  margin-top: 0.25rem;
  padding: 0.5rem;
  border-radius: 6px;
  opacity: 0;
  visibility: hidden;
  transform: translateY(-8px);
  transition: all 0.2s ease;
  z-index: 100;
}

.navbar-dropdown.active {
  opacity: 1;
  visibility: visible;
  transform: translateY(0);
}

.navbar-dropdown-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.625rem 0.875rem;
  text-decoration: none;
  border-radius: 4px;
  transition: all 0.15s ease;
  font-size: 0.875rem;
  font-weight: 500;
}

.navbar-dropdown-item:hover {
  background-color: #f3f4f6;
}

.navbar-dropdown-icon {
  font-size: 0.95rem;
}

.navbar-actions {
  display: flex;
  align-items: center;
  gap: 0.75rem;
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
  border-radius: 6px;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
}

.navbar-notification-btn:hover {
  background-color: #f3f4f6;
}

.navbar-notification-icon {
  font-size: 1.1rem;
}

.navbar-notification-badge {
  position: absolute;
  top: -4px;
  right: -4px;
  min-width: 18px;
  height: 18px;
  border-radius: 9px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.65rem;
  font-weight: 600;
  padding: 0 5px;
}

.navbar-mobile-toggle {
  display: flex;
  border-radius: 6px;
  padding: 0.5rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

@media (min-width: 768px) {
  .navbar-mobile-toggle {
    display: none;
  }
}

.navbar-mobile-toggle:hover {
  background-color: #f3f4f6;
}

.navbar-hamburger {
  font-size: 1.25rem;
}

.navbar-mobile-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100vh;
  z-index: 999;
  overflow-y: auto;
  padding-top: 60px;
  border-top: 1px solid #e5e7eb;
}

@media (min-width: 768px) {
  .navbar-mobile-overlay {
    display: none;
  }
}

.navbar-mobile-menu {
  padding: 1.5rem 1rem;
}

.navbar-mobile-item-wrapper {
  margin-bottom: 0.25rem;
}

.navbar-mobile-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.875rem 1rem;
  text-decoration: none;
  border-radius: 6px;
  transition: all 0.2s ease;
  font-size: 1rem;
  font-weight: 500;
}

.navbar-mobile-icon {
  font-size: 1.25rem;
}

.navbar-mobile-arrow {
  margin-left: auto;
  font-size: 0.75rem;
}

.navbar-mobile-dropdown {
  margin-left: 2rem;
  margin-top: 0.25rem;
}

.navbar-mobile-dropdown-item {
  display: flex;
  align-items: center;
  gap: 0.625rem;
  padding: 0.75rem 1rem;
  text-decoration: none;
  border-radius: 4px;
  transition: all 0.15s ease;
  opacity: 0.9;
  font-size: 0.9rem;
  font-weight: 500;
  margin-bottom: 0.125rem;
}

.navbar-mobile-dropdown-item:hover {
  background-color: #f3f4f6;
  opacity: 1;
}

.mobile-menu-fade-enter-active,
.mobile-menu-fade-leave-active {
  transition: all 0.2s ease;
}

.mobile-menu-fade-enter-from {
  opacity: 0;
}

.mobile-menu-fade-leave-to {
  opacity: 0;
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
