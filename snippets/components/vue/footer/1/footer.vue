<template>
  <footer class="footer" :class="`footer-${variant}`" :style="computedStyles">
    <div class="footer-container">
      <!-- Logo and Brand Section -->
      <div class="footer-brand">
        <div class="footer-logo">
          <svg width="40" height="40" viewBox="0 0 40 40" fill="none">
            <rect width="40" height="40" rx="8" :fill="currentTheme.primaryColor"/>
            <path d="M12 20L18 26L28 14" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
        <p class="footer-description">
          Building innovative solutions for the modern web. Join us on our journey to create exceptional digital experiences.
        </p>
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

      <!-- Footer Sections -->
      <div class="footer-sections">
        <div
          v-for="section in sections"
          :key="section.id"
          class="footer-section"
        >
          <h3 class="section-title">{{ section.title }}</h3>
          <ul class="section-links">
            <li v-for="link in section.links" :key="link.id">
              <a :href="link.url" class="footer-link">
                <i v-if="link.icon" :class="link.icon"></i>
                {{ link.label }}
              </a>
            </li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Bottom Bar -->
    <div class="footer-bottom">
      <p class="copyright">{{ copyright }}</p>
      <button
        @click="scrollToTop"
        class="back-to-top"
        aria-label="Back to top"
      >
        <i class="fas fa-arrow-up"></i>
      </button>
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
        { id: 'integrations', label: 'Integrations', url: '#integrations' },
        { id: 'changelog', label: 'Changelog', url: '#changelog' }
      ]
    },
    {
      id: 'company',
      title: 'Company',
      links: [
        { id: 'about', label: 'About Us', url: '#about' },
        { id: 'careers', label: 'Careers', url: '#careers' },
        { id: 'blog', label: 'Blog', url: '#blog' },
        { id: 'press', label: 'Press Kit', url: '#press' }
      ]
    },
    {
      id: 'resources',
      title: 'Resources',
      links: [
        { id: 'docs', label: 'Documentation', url: '#docs', icon: 'fas fa-book' },
        { id: 'guides', label: 'Guides', url: '#guides', icon: 'fas fa-graduation-cap' },
        { id: 'api', label: 'API Reference', url: '#api', icon: 'fas fa-code' },
        { id: 'support', label: 'Support', url: '#support', icon: 'fas fa-headset' }
      ]
    },
    {
      id: 'legal',
      title: 'Legal',
      links: [
        { id: 'privacy', label: 'Privacy Policy', url: '#privacy' },
        { id: 'terms', label: 'Terms of Service', url: '#terms' },
        { id: 'security', label: 'Security', url: '#security' },
        { id: 'cookies', label: 'Cookie Policy', url: '#cookies' }
      ]
    }
  ],
  copyright: () => `© ${new Date().getFullYear()} Your Company. All rights reserved.`,
  socialLinks: () => [
    { id: 'twitter', label: 'Twitter', url: '#twitter', icon: 'fab fa-twitter' },
    { id: 'github', label: 'GitHub', url: '#github', icon: 'fab fa-github' },
    { id: 'linkedin', label: 'LinkedIn', url: '#linkedin', icon: 'fab fa-linkedin' },
    { id: 'discord', label: 'Discord', url: '#discord', icon: 'fab fa-discord' }
  ],
  variant: 'multi-column',
  theme: () => ({})
});

const defaultTheme: FooterTheme = {
  primaryColor: '#6366f1',
  backgroundColor: '#1e293b',
  textColor: '#94a3b8',
  linkColor: '#e2e8f0',
  borderColor: '#334155'
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
  padding: 4rem 2rem 2rem;
  border-top: 1px solid var(--border-color);
}

.footer-container {
  max-width: 1200px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: 1fr 2fr;
  gap: 4rem;
  margin-bottom: 3rem;
}

.footer-brand {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.footer-logo svg {
  display: block;
}

.footer-description {
  font-size: 0.95rem;
  line-height: 1.6;
  margin: 0;
  color: var(--text-color);
}

.footer-social {
  display: flex;
  gap: 1rem;
}

.social-link {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.05);
  color: var(--link-color);
  text-decoration: none;
  transition: all 0.3s ease;
}

.social-link:hover {
  background: var(--primary-color);
  color: white;
  transform: translateY(-2px);
}

.footer-sections {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 2rem;
}

.footer-section {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.section-title {
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--link-color);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin: 0;
}

.section-links {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.footer-link {
  color: var(--text-color);
  text-decoration: none;
  font-size: 0.95rem;
  transition: color 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.footer-link:hover {
  color: var(--primary-color);
}

.footer-link i {
  font-size: 0.875rem;
  width: 16px;
}

.footer-bottom {
  max-width: 1200px;
  margin: 0 auto;
  padding-top: 2rem;
  border-top: 1px solid var(--border-color);
  display: flex;
  justify-content: space-between;
  align-items: center;
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
  width: 40px;
  height: 40px;
  border-radius: 8px;
  background: var(--primary-color);
  color: white;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
}

.back-to-top:hover {
  background: var(--primary-color);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
}

/* Responsive Design */
@media (max-width: 1024px) {
  .footer-container {
    grid-template-columns: 1fr;
    gap: 3rem;
  }

  .footer-sections {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 640px) {
  .footer {
    padding: 3rem 1.5rem 1.5rem;
  }

  .footer-sections {
    grid-template-columns: 1fr;
  }

  .footer-bottom {
    flex-direction: column;
    gap: 1.5rem;
    text-align: center;
  }
}
</style>
