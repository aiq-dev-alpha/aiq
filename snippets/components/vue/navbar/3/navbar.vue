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
    <transition name="mobile-menu-overlay">
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
  variant: 'gradient',
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
// Default theme for variant 3 - Gradient Vibrant
const defaultTheme: NavbarTheme = {
  primary: '#ff006e',
  background: 'linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%)',
  text: '#ffffff',
  activeColor: '#ffbe0b',
  hoverColor: 'rgba(255, 190, 11, 0.2)'
}
const mergedTheme = computed<NavbarTheme>(() => ({
  ...defaultTheme,
  ...props.theme
}))
// Computed Styles
const navbarStyles = computed(() => ({
  background: props.transparent ? 'transparent' : mergedTheme.value.background,
  color: mergedTheme.value.text,
  boxShadow: '0 10px 40px rgba(102, 126, 234, 0.3)'
}))
const dropdownStyles = computed(() => ({
  background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
  boxShadow: '0 10px 40px rgba(102, 126, 234, 0.4)',
  border: '2px solid rgba(255, 255, 255, 0.2)'
}))
const dropdownItemStyles = computed(() => ({
  color: mergedTheme.value.text
}))
const actionButtonStyles = computed(() => ({
  color: mergedTheme.value.text,
  background: 'rgba(255, 255, 255, 0.15)',
  border: '2px solid rgba(255, 255, 255, 0.3)'
}))
const badgeStyles = computed(() => ({
  backgroundColor: mergedTheme.value.activeColor,
  color: '#000',
  fontWeight: '800',
  boxShadow: `0 0 20px ${mergedTheme.value.activeColor}`
}))
const mobileOverlayStyles = computed(() => ({
  background: mergedTheme.value.background
}))
// Methods
const getItemStyles = (itemId: string) => {
  const isActive = activeItem.value === itemId
  const isHovered = hoveredItem.value === itemId
  return {
    color: isActive ? mergedTheme.value.activeColor : mergedTheme.value.text,
    background: isHovered || isActive
      ? 'linear-gradient(135deg, rgba(255, 255, 255, 0.2) 0%, rgba(255, 255, 255, 0.1) 100%)'
      : 'transparent',
    border: isActive ? `2px solid ${mergedTheme.value.activeColor}` : '2px solid transparent',
    transform: isHovered ? 'scale(1.05)' : 'scale(1)'
  }
}
const getMobileItemStyles = (itemId: string) => ({
  color: activeItem.value === itemId ? mergedTheme.value.activeColor : mergedTheme.value.text,
  background: activeItem.value === itemId
    ? 'linear-gradient(135deg, rgba(255, 255, 255, 0.2) 0%, rgba(255, 255, 255, 0.1) 100%)'
    : 'transparent',
  border: activeItem.value === itemId ? `2px solid ${mergedTheme.value.activeColor}` : '2px solid rgba(255, 255, 255, 0.2)'
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
  transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
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
  padding: 1.25rem 2.5rem;
}
.navbar-brand {
  display: flex;
  align-items: center;
  gap: 0.875rem;
  font-size: 1.75rem;
  font-weight: 800;
  cursor: pointer;
  text-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  letter-spacing: 0.5px;
}
.navbar-brand:hover {
  transform: scale(1.1) rotate(-2deg);
  text-shadow: 0 6px 30px rgba(255, 190, 11, 0.6);
}
.navbar-logo {
  height: 48px;
  width: auto;
  filter: drop-shadow(0 4px 12px rgba(255, 255, 255, 0.3));
  transition: all 0.3s ease;
}
.navbar-brand:hover .navbar-logo {
  transform: rotate(10deg);
}
.navbar-menu {
  display: none;
  gap: 1rem;
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
  gap: 0.625rem;
  padding: 1rem 1.75rem;
  text-decoration: none;
  transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  font-weight: 600;
  white-space: nowrap;
  letter-spacing: 0.5px;
  border-radius: 16px;
  text-transform: uppercase;
  font-size: 0.9rem;
}
.navbar-item.active {
  font-weight: 800;
  text-shadow: 0 0 15px currentColor;
}
.navbar-item-icon {
  font-size: 1.2rem;
  transition: transform 0.3s ease;
}
.navbar-item:hover .navbar-item-icon {
  transform: scale(1.2) rotate(12deg);
}
.navbar-item-arrow {
  font-size: 0.7rem;
  margin-left: 0.25rem;
  transition: transform 0.3s ease;
}
.navbar-item:hover .navbar-item-arrow {
  transform: translateY(3px) rotate(180deg);
}
.navbar-dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  min-width: 240px;
  margin-top: 1rem;
  padding: 1rem;
  border-radius: 20px;
  opacity: 0;
  visibility: hidden;
  transform: translateY(-20px) scale(0.9) rotateX(-10deg);
  transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  z-index: 100;
  transform-origin: top center;
}
.navbar-dropdown.active {
  opacity: 1;
  visibility: visible;
  transform: translateY(0) scale(1) rotateX(0);
}
.navbar-dropdown-item {
  display: flex;
  align-items: center;
  gap: 0.875rem;
  padding: 1rem 1.25rem;
  text-decoration: none;
  border-radius: 12px;
  transition: all 0.3s ease;
  font-weight: 500;
  letter-spacing: 0.3px;
}
.navbar-dropdown-item:hover {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.25) 0%, rgba(255, 255, 255, 0.15) 100%);
  transform: translateX(8px) scale(1.05);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
}
.navbar-dropdown-icon {
  font-size: 1.1rem;
}
.navbar-actions {
  display: flex;
  align-items: center;
  gap: 1.25rem;
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
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}
.navbar-notification-btn:hover {
  transform: scale(1.2) rotate(-15deg);
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.3) 0%, rgba(255, 255, 255, 0.2) 100%);
  box-shadow: 0 8px 24px rgba(255, 190, 11, 0.4);
}
.navbar-notification-icon {
  font-size: 1.4rem;
}
.navbar-notification-badge {
  position: absolute;
  top: 0;
  right: 0;
  min-width: 24px;
  height: 24px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  padding: 0 7px;
  animation: bounceScale 1s infinite;
}
@keyframes bounceScale {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.2);
  }
}
.navbar-mobile-toggle {
  display: flex;
  border-radius: 12px;
  padding: 0.75rem 1rem;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}
@media (min-width: 768px) {
  .navbar-mobile-toggle {
    display: none;
  }
}
.navbar-mobile-toggle:hover {
  transform: scale(1.15) rotate(5deg);
  box-shadow: 0 6px 20px rgba(255, 190, 11, 0.4);
}
.navbar-hamburger {
  font-size: 1.6rem;
  font-weight: 700;
}
.navbar-mobile-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100vh;
  z-index: 999;
  overflow-y: auto;
  padding-top: 100px;
}
@media (min-width: 768px) {
  .navbar-mobile-overlay {
    display: none;
  }
}
.navbar-mobile-menu {
  padding: 2.5rem 2rem;
}
.navbar-mobile-item-wrapper {
  margin-bottom: 1rem;
}
.navbar-mobile-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1.25rem 2rem;
  text-decoration: none;
  border-radius: 16px;
  transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  font-size: 1.15rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
.navbar-mobile-icon {
  font-size: 1.5rem;
}
.navbar-mobile-arrow {
  margin-left: auto;
  font-size: 0.9rem;
  transition: transform 0.3s ease;
}
.navbar-mobile-dropdown {
  margin-left: 3rem;
  margin-top: 0.75rem;
  animation: slideDown 0.3s ease;
}
@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
.navbar-mobile-dropdown-item {
  display: flex;
  align-items: center;
  gap: 0.875rem;
  padding: 1rem 1.75rem;
  text-decoration: none;
  border-radius: 12px;
  transition: all 0.3s ease;
  opacity: 0.9;
  font-weight: 500;
  border: 2px solid rgba(255, 255, 255, 0.15);
  margin-bottom: 0.5rem;
}
.navbar-mobile-dropdown-item:hover {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.2) 0%, rgba(255, 255, 255, 0.1) 100%);
  opacity: 1;
  transform: translateX(8px) scale(1.02);
}
.mobile-menu-overlay-enter-active,
.mobile-menu-overlay-leave-active {
  transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}
.mobile-menu-overlay-enter-from {
  opacity: 0;
  transform: scale(0.8) rotateX(-10deg);
}
.mobile-menu-overlay-leave-to {
  opacity: 0;
  transform: scale(0.8) rotateX(10deg);
}
</style>
