<template>
  <footer class="footer" :class="`footer-${variant}`" :style="computedStyles">
    <div class="footer-container">
      <!-- Main Content -->
      <div class="footer-content">
        <!-- Brand and Social -->
        <div class="footer-brand-section">
          <div class="brand-info">
            <svg width="36" height="36" viewBox="0 0 36 36" fill="none">
              <rect width="36" height="36" rx="6" :fill="currentTheme.primaryColor"/>
              <circle cx="18" cy="18" r="6" fill="white"/>
            </svg>
            <span class="brand-text">Minimalist</span>
          </div>
          <p class="tagline">Simple, elegant, effective.</p>
        </div>

        <!-- Quick Links -->
        <nav class="footer-links">
          <template v-for="section in sections" :key="section.id">
            <a
              v-for="link in section.links"
              :key="link.id"
              :href="link.url"
              class="footer-link"
            >
              {{ link.label }}
            </a>
          </template>
        </nav>

        <!-- Social Links -->
        <div class="footer-social">
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

      <!-- Divider -->
      <div class="footer-divider"></div>

      <!-- Bottom -->
      <div class="footer-bottom">
        <p class="copyright">{{ copyright }}</p>
        <button
          @click="scrollToTop"
          class="back-to-top"
          aria-label="Scroll to top"
        >
          <i class="fas fa-arrow-up"></i>
        </button>
      </div>
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
      id: 'main',
      title: 'Main',
      links: [
        { id: 'home', label: 'Home', url: '#home' },
        { id: 'about', label: 'About', url: '#about' },
        { id: 'services', label: 'Services', url: '#services' },
        { id: 'work', label: 'Work', url: '#work' },
        { id: 'contact', label: 'Contact', url: '#contact' },
        { id: 'blog', label: 'Blog', url: '#blog' },
        { id: 'privacy', label: 'Privacy', url: '#privacy' },
        { id: 'terms', label: 'Terms', url: '#terms' }
      ]
    }
  ],
  copyright: () => `© ${new Date().getFullYear()} Minimalist. Clean & Simple.`,
  socialLinks: () => [
    { id: 'twitter', label: 'Twitter', url: '#twitter', icon: 'fab fa-twitter' },
    { id: 'dribbble', label: 'Dribbble', url: '#dribbble', icon: 'fab fa-dribbble' },
    { id: 'behance', label: 'Behance', url: '#behance', icon: 'fab fa-behance' },
    { id: 'instagram', label: 'Instagram', url: '#instagram', icon: 'fab fa-instagram' }
  ],
  variant: 'minimal',
  theme: () => ({})
});

const defaultTheme: FooterTheme = {
  primaryColor: '#14b8a6',
  backgroundColor: '#fafafa',
  textColor: '#71717a',
  linkColor: '#27272a',
  borderColor: '#e4e4e7'
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
  background-color: var(--background-color);
  color: var(--text-color);
  padding: 3rem 2rem 2rem;
  border-top: 1px solid var(--border-color);
}

.footer-container {
  max-width: 1100px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.footer-content {
  display: grid;
  grid-template-columns: 1fr 2fr 1fr;
  gap: 3rem;
  align-items: start;
}

.footer-brand-section {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.brand-info {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.brand-text {
  font-size: 1.125rem;
  font-weight: 600;
  color: var(--link-color);
}

.tagline {
  margin: 0;
  font-size: 0.875rem;
  color: var(--text-color);
  font-style: italic;
}

.footer-links {
  display: flex;
  flex-wrap: wrap;
  gap: 1.5rem;
  justify-content: center;
  align-items: center;
}

.footer-link {
  color: var(--text-color);
  text-decoration: none;
  font-size: 0.95rem;
  transition: color 0.2s ease;
  position: relative;
}

.footer-link:hover {
  color: var(--primary-color);
}

.footer-link::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 0;
  height: 1px;
  background-color: var(--primary-color);
  transition: width 0.3s ease;
}

.footer-link:hover::after {
  width: 100%;
}

.footer-social {
  display: flex;
  gap: 0.75rem;
  justify-content: flex-end;
}

.social-link {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: transparent;
  color: var(--text-color);
  text-decoration: none;
  transition: all 0.3s ease;
  border: 1px solid var(--border-color);
}

.social-link:hover {
  background: var(--primary-color);
  color: white;
  border-color: var(--primary-color);
  transform: translateY(-2px);
}

.social-link i {
  font-size: 0.95rem;
}

.footer-divider {
  height: 1px;
  background-color: var(--border-color);
  margin: 1rem 0;
}

.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 0.5rem;
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
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: var(--primary-color);
  color: white;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
}

.back-to-top:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 12px rgba(20, 184, 166, 0.3);
}

.back-to-top i {
  font-size: 0.875rem;
}

/* Responsive Design */
@media (max-width: 768px) {
  .footer {
    padding: 2.5rem 1.5rem 1.5rem;
  }

  .footer-content {
    grid-template-columns: 1fr;
    gap: 2rem;
    text-align: center;
  }

  .footer-social {
    justify-content: center;
  }

  .footer-links {
    gap: 1rem;
  }

  .footer-bottom {
    flex-direction: column;
    gap: 1.5rem;
  }
}

@media (max-width: 480px) {
  .footer-links {
    flex-direction: column;
    gap: 0.75rem;
  }

  .footer-link::after {
    display: none;
  }
}
</style>
