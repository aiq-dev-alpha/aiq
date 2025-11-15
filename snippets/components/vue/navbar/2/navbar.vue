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
    <transition name="mobile-menu-slide">
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
  variant: 'transparent',
  sticky: false,
  transparent: true,
  theme: () => ({}),
  showNotifications: true,
  notificationCount: 0
})

// State
const mobileMenuOpen = ref(false)
const activeItem = ref<string | null>(null)
const hoveredItem = ref<string | null>(null)
const activeDropdown = ref<string | null>(null)

// Default theme for variant 2 - Transparent Glass
const defaultTheme: NavbarTheme = {
  primary: '#00d4ff',
  background: 'rgba(255, 255, 255, 0.08)',
  text: '#ffffff',
  activeColor: '#00d4ff',
  hoverColor: 'rgba(0, 212, 255, 0.15)'
}

const mergedTheme = computed<NavbarTheme>(() => ({
  ...defaultTheme,
  ...props.theme
}))

// Computed Styles
const navbarStyles = computed(() => ({
  backgroundColor: props.transparent ? mergedTheme.value.background : mergedTheme.value.background,
  color: mergedTheme.value.text,
  backdropFilter: 'blur(20px) saturate(180%)',
  WebkitBackdropFilter: 'blur(20px) saturate(180%)',
  borderBottom: `1px solid rgba(255, 255, 255, 0.1)`,
  boxShadow: '0 8px 32px rgba(0, 0, 0, 0.1)'
}))

const dropdownStyles = computed(() => ({
  backgroundColor: mergedTheme.value.background,
  backdropFilter: 'blur(20px) saturate(180%)',
  WebkitBackdropFilter: 'blur(20px) saturate(180%)',
  border: `1px solid rgba(255, 255, 255, 0.1)`,
  boxShadow: '0 8px 32px rgba(0, 0, 0, 0.2)'
}))

const dropdownItemStyles = computed(() => ({
  color: mergedTheme.value.text
}))

const actionButtonStyles = computed(() => ({
  color: mergedTheme.value.text,
  backgroundColor: 'rgba(255, 255, 255, 0.1)',
  border: '1px solid rgba(255, 255, 255, 0.2)'
}))

const badgeStyles = computed(() => ({
  backgroundColor: mergedTheme.value.activeColor,
  color: '#000',
  boxShadow: `0 0 12px ${mergedTheme.value.activeColor}`
}))

const mobileOverlayStyles = computed(() => ({
  backgroundColor: mergedTheme.value.background,
  backdropFilter: 'blur(20px) saturate(180%)',
  WebkitBackdropFilter: 'blur(20px) saturate(180%)'
}))

// Methods
const getItemStyles = (itemId: string) => ({
  color: activeItem.value === itemId ? mergedTheme.value.activeColor : mergedTheme.value.text,
  backgroundColor: hoveredItem.value === itemId ? mergedTheme.value.hoverColor : 'transparent',
  boxShadow: activeItem.value === itemId ? `0 0 16px ${mergedTheme.value.activeColor}40` : 'none',
  borderRadius: '12px'
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
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
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
  padding: 1.25rem 2rem;
}

.navbar-brand {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 1.5rem;
  font-weight: 700;
  cursor: pointer;
  text-shadow: 0 0 20px rgba(0, 212, 255, 0.5);
  transition: all 0.3s ease;
}

.navbar-brand:hover {
  transform: scale(1.05);
  text-shadow: 0 0 30px rgba(0, 212, 255, 0.8);
}

.navbar-logo {
  height: 42px;
  width: auto;
  filter: drop-shadow(0 0 8px rgba(0, 212, 255, 0.5));
}

.navbar-menu {
  display: none;
  gap: 0.75rem;
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
  padding: 0.875rem 1.5rem;
  text-decoration: none;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-weight: 500;
  white-space: nowrap;
  letter-spacing: 0.3px;
}

.navbar-item:hover {
  transform: translateY(-3px);
}

.navbar-item.active {
  font-weight: 700;
  text-shadow: 0 0 10px currentColor;
}

.navbar-item-icon {
  font-size: 1.15rem;
}

.navbar-item-arrow {
  font-size: 0.65rem;
  margin-left: 0.25rem;
  transition: transform 0.3s ease;
}

.navbar-item:hover .navbar-item-arrow {
  transform: translateY(2px);
}

.navbar-dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  min-width: 220px;
  margin-top: 0.75rem;
  padding: 0.75rem;
  border-radius: 16px;
  opacity: 0;
  visibility: hidden;
  transform: translateY(-15px) scale(0.95);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  z-index: 100;
}

.navbar-dropdown.active {
  opacity: 1;
  visibility: visible;
  transform: translateY(0) scale(1);
}

.navbar-dropdown-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.875rem 1.125rem;
  text-decoration: none;
  border-radius: 10px;
  transition: all 0.2s ease;
  backdrop-filter: blur(10px);
}

.navbar-dropdown-item:hover {
  background-color: rgba(255, 255, 255, 0.15);
  transform: translateX(6px);
  box-shadow: 0 4px 12px rgba(0, 212, 255, 0.2);
}

.navbar-dropdown-icon {
  font-size: 1.05rem;
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
  border-radius: 50%;
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.navbar-notification-btn:hover {
  transform: scale(1.15) rotate(12deg);
  background-color: rgba(255, 255, 255, 0.2);
  box-shadow: 0 4px 16px rgba(0, 212, 255, 0.3);
}

.navbar-notification-icon {
  font-size: 1.3rem;
}

.navbar-notification-badge {
  position: absolute;
  top: -2px;
  right: -2px;
  min-width: 22px;
  height: 22px;
  border-radius: 11px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.7rem;
  font-weight: 700;
  padding: 0 6px;
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.7;
  }
}

.navbar-mobile-toggle {
  display: flex;
  border-radius: 10px;
  padding: 0.625rem 0.875rem;
  cursor: pointer;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

@media (min-width: 768px) {
  .navbar-mobile-toggle {
    display: none;
  }
}

.navbar-mobile-toggle:hover {
  transform: scale(1.1);
  box-shadow: 0 4px 16px rgba(0, 212, 255, 0.3);
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
  padding-top: 90px;
}

@media (min-width: 768px) {
  .navbar-mobile-overlay {
    display: none;
  }
}

.navbar-mobile-menu {
  padding: 2rem 1.5rem;
}

.navbar-mobile-item-wrapper {
  margin-bottom: 0.75rem;
}

.navbar-mobile-item {
  display: flex;
  align-items: center;
  gap: 0.875rem;
  padding: 1.125rem 1.75rem;
  text-decoration: none;
  border-radius: 12px;
  transition: all 0.3s ease;
  font-size: 1.1rem;
  font-weight: 500;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.navbar-mobile-icon {
  font-size: 1.35rem;
}

.navbar-mobile-arrow {
  margin-left: auto;
  font-size: 0.85rem;
}

.navbar-mobile-dropdown {
  margin-left: 2.5rem;
  margin-top: 0.5rem;
}

.navbar-mobile-dropdown-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.875rem 1.5rem;
  text-decoration: none;
  border-radius: 8px;
  transition: all 0.2s ease;
  opacity: 0.9;
  backdrop-filter: blur(10px);
}

.navbar-mobile-dropdown-item:hover {
  background-color: rgba(255, 255, 255, 0.15);
  opacity: 1;
  transform: translateX(4px);
}

.mobile-menu-slide-enter-active,
.mobile-menu-slide-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.mobile-menu-slide-enter-from {
  opacity: 0;
  transform: translateY(-20px);
}

.mobile-menu-slide-leave-to {
  opacity: 0;
  transform: translateY(-20px);
}
</style>
