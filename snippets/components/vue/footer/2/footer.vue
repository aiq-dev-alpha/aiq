<template>
  <footer class="footer" :class="`footer-${variant}`" :style="computedStyles">
    <div class="footer-container">
      <!-- Logo Section -->
      <div class="footer-logo-section">
        <div class="footer-logo">
          <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
            <circle cx="24" cy="24" r="24" :fill="currentTheme.primaryColor"/>
            <path d="M16 24L22 30L32 18" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
        <h2 class="brand-name">Your Brand</h2>
        <p class="footer-tagline">
          Creating beautiful digital experiences
        </p>
      </div>
      <!-- Navigation Links (Centered) -->
      <nav class="footer-nav">
        <div
          v-for="section in sections"
          :key="section.id"
          class="nav-section"
        >
          <h3 class="nav-title">{{ section.title }}</h3>
          <ul class="nav-links">
            <li v-for="link in section.links" :key="link.id">
              <a :href="link.url" class="nav-link">
                <i v-if="link.icon" :class="link.icon"></i>
                {{ link.label }}
              </a>
            </li>
          </ul>
        </div>
      </nav>
      <!-- Social Links -->
      <div class="social-section">
        <p class="social-title">Connect With Us</p>
        <div class="social-links">
          <a
            v-for="social in socialLinks"
            :key="social.id"
            :href="social.url"
            :aria-label="social.label"
            class="social-link"
          >
            <i :class="social.icon"></i>
          </a>
        </div>
      </div>
      <!-- Copyright -->
      <div class="footer-bottom">
        <p class="copyright">{{ copyright }}</p>
        <button
          @click="scrollToTop"
          class="back-to-top"
          aria-label="Back to top"
        >
          <i class="fas fa-chevron-up"></i>
        </button>
      </div>
    </div>
    <!-- Decorative Elements -->
    <div class="decorative-circles">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
    </div>
  </footer>
</template>
<script setup lang="ts">
import { computed, defineProps, withDefaults } from 'vue';
interface FooterTheme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  linkColor: string;
  borderColor: string;
}
interface FooterLink {
  id: string;
  label: string;
  url: string;
  icon?: string;
}
interface FooterSection {
  id: string;
  title: string;
  links: FooterLink[];
}
interface SocialLink {
  id: string;
  label: string;
  url: string;
  icon: string;
}
type FooterVariant = 'simple' | 'multi-column' | 'centered' | 'minimal' | 'newsletter';
interface Props {
  sections?: FooterSection[];
  copyright?: string;
  socialLinks?: SocialLink[];
  variant?: FooterVariant;
  theme?: Partial<FooterTheme>;
}
const props = withDefaults(defineProps<Props>(), {
  sections: () => [
    {
      id: 'product',
      title: 'Product',
      links: [
        { id: 'features', label: 'Features', url: '#features' },
        { id: 'pricing', label: 'Pricing', url: '#pricing' },
        { id: 'download', label: 'Download', url: '#download' }
      ]
    },
    {
      id: 'company',
      title: 'Company',
      links: [
        { id: 'about', label: 'About', url: '#about' },
        { id: 'team', label: 'Team', url: '#team' },
        { id: 'blog', label: 'Blog', url: '#blog' }
      ]
    },
    {
      id: 'support',
      title: 'Support',
      links: [
        { id: 'help', label: 'Help Center', url: '#help', icon: 'fas fa-question-circle' },
        { id: 'contact', label: 'Contact', url: '#contact', icon: 'fas fa-envelope' },
        { id: 'faq', label: 'FAQ', url: '#faq', icon: 'fas fa-comments' }
      ]
    }
  ],
  copyright: () => `© ${new Date().getFullYear()} Your Brand. Crafted with care.`,
  socialLinks: () => [
    { id: 'facebook', label: 'Facebook', url: '#facebook', icon: 'fab fa-facebook' },
    { id: 'twitter', label: 'Twitter', url: '#twitter', icon: 'fab fa-twitter' },
    { id: 'instagram', label: 'Instagram', url: '#instagram', icon: 'fab fa-instagram' },
    { id: 'youtube', label: 'YouTube', url: '#youtube', icon: 'fab fa-youtube' },
    { id: 'linkedin', label: 'LinkedIn', url: '#linkedin', icon: 'fab fa-linkedin' }
  ],
  variant: 'centered',
  theme: () => ({})
});
const defaultTheme: FooterTheme = {
  primaryColor: '#ec4899',
  backgroundColor: '#0f172a',
  textColor: '#cbd5e1',
  linkColor: '#f1f5f9',
  borderColor: '#1e293b'
};
const currentTheme = computed<FooterTheme>(() => ({
  ...defaultTheme,
  ...props.theme
}));
const computedStyles = computed(() => ({
  '--primary-color': currentTheme.value.primaryColor,
  '--background-color': currentTheme.value.backgroundColor,
  '--text-color': currentTheme.value.textColor,
  '--link-color': currentTheme.value.linkColor,
  '--border-color': currentTheme.value.borderColor
}));
const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' });
};
</script>
<style scoped>
.footer {
  position: relative;
  background: linear-gradient(135deg, var(--background-color) 0%, #1e293b 100%);
  color: var(--text-color);
  padding: 5rem 2rem 2rem;
  overflow: hidden;
}
.footer-container {
  max-width: 900px;
  margin: 0 auto;
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 3rem;
}
.footer-logo-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}
.footer-logo svg {
  filter: drop-shadow(0 4px 12px rgba(236, 72, 153, 0.3));
}
.brand-name {
  font-size: 1.75rem;
  font-weight: 700;
  color: var(--link-color);
  margin: 0;
  background: linear-gradient(135deg, var(--primary-color), #f472b6);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.footer-tagline {
  font-size: 1rem;
  color: var(--text-color);
  margin: 0;
  max-width: 400px;
}
.footer-nav {
  display: flex;
  justify-content: center;
  gap: 4rem;
  flex-wrap: wrap;
}
.nav-section {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  min-width: 150px;
}
.nav-title {
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--primary-color);
  text-transform: uppercase;
  letter-spacing: 0.1em;
  margin: 0;
}
.nav-links {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}
.nav-link {
  color: var(--text-color);
  text-decoration: none;
  font-size: 0.95rem;
  transition: all 0.3s ease;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  justify-content: center;
}
.nav-link:hover {
  color: var(--primary-color);
  transform: translateX(4px);
}
.nav-link i {
  font-size: 0.875rem;
}
.social-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1.5rem;
  padding: 2rem 0;
}
.social-title {
  font-size: 1rem;
  font-weight: 600;
  color: var(--link-color);
  margin: 0;
}
.social-links {
  display: flex;
  gap: 1rem;
}
.social-link {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(236, 72, 153, 0.1), rgba(244, 114, 182, 0.1));
  color: var(--link-color);
  text-decoration: none;
  transition: all 0.4s ease;
  border: 2px solid transparent;
}
.social-link:hover {
  background: linear-gradient(135deg, var(--primary-color), #f472b6);
  color: white;
  transform: translateY(-4px) scale(1.1);
  border-color: var(--primary-color);
  box-shadow: 0 8px 20px rgba(236, 72, 153, 0.4);
}
.social-link i {
  font-size: 1.25rem;
}
.footer-bottom {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1.5rem;
  padding-top: 2rem;
  border-top: 1px solid var(--border-color);
  width: 100%;
}
.copyright {
  margin: 0;
  font-size: 0.875rem;
  color: var(--text-color);
}
.back-to-top {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--primary-color), #f472b6);
  color: white;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(236, 72, 153, 0.3);
}
.back-to-top:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(236, 72, 153, 0.5);
}
.back-to-top i {
  font-size: 1rem;
}
/* Decorative Elements */
.decorative-circles {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  opacity: 0.1;
}
.circle {
  position: absolute;
  border-radius: 50%;
  background: radial-gradient(circle, var(--primary-color), transparent);
}
.circle-1 {
  width: 300px;
  height: 300px;
  top: -100px;
  left: -100px;
}
.circle-2 {
  width: 200px;
  height: 200px;
  top: 50%;
  right: -50px;
}
.circle-3 {
  width: 150px;
  height: 150px;
  bottom: -50px;
  left: 50%;
  transform: translateX(-50%);
}
/* Responsive Design */
@media (max-width: 768px) {
  .footer {
    padding: 4rem 1.5rem 2rem;
  }
  .footer-nav {
    gap: 2rem;
  }
  .nav-section {
    min-width: 120px;
  }
  .social-links {
    flex-wrap: wrap;
    justify-content: center;
  }
}
@media (max-width: 640px) {
  .footer-nav {
    flex-direction: column;
    gap: 2rem;
  }
  .brand-name {
    font-size: 1.5rem;
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
