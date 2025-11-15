<template>
  <footer class="footer" :class="`footer-${variant}`" :style="computedStyles">
    <div class="footer-container">
      <!-- Top Section -->
      <div class="footer-top">
        <!-- Brand Column -->
        <div class="brand-column">
          <div class="brand-header">
            <svg width="50" height="50" viewBox="0 0 50 50" fill="none">
              <circle cx="25" cy="25" r="25" :fill="currentTheme.primaryColor"/>
              <path d="M15 25L22 32L35 18" stroke="white" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <div class="brand-text">
              <h2 class="brand-name">BrandName</h2>
              <p class="brand-motto">Excellence in Every Detail</p>
            </div>
          </div>
          <p class="brand-description">
            We create exceptional digital experiences that help businesses grow and succeed in the modern world. Innovation meets creativity.
          </p>
        </div>

        <!-- Link Columns -->
        <div class="link-columns">
          <div
            v-for="section in sections"
            :key="section.id"
            class="link-column"
          >
            <h3 class="column-title">{{ section.title }}</h3>
            <ul class="column-links">
              <li v-for="link in section.links" :key="link.id">
                <a :href="link.url" class="link-item">
                  <i v-if="link.icon" :class="link.icon"></i>
                  <span>{{ link.label }}</span>
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Middle Section - Social & CTA -->
      <div class="footer-middle">
        <div class="social-section">
          <p class="social-heading">Follow us on social media</p>
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
        <button
          @click="scrollToTop"
          class="scroll-top-button"
          aria-label="Scroll to top"
        >
          <i class="fas fa-chevron-up"></i>
          <span>Back to Top</span>
        </button>
      </div>

      <!-- Bottom Section -->
      <div class="footer-bottom">
        <p class="copyright">{{ copyright }}</p>
        <div class="footer-badges">
          <span class="badge">
            <i class="fas fa-shield-alt"></i>
            Secure
          </span>
          <span class="badge">
            <i class="fas fa-award"></i>
            Trusted
          </span>
        </div>
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
      id: 'products',
      title: 'Products',
      links: [
        { id: 'web-design', label: 'Web Design', url: '#web-design' },
        { id: 'app-dev', label: 'App Development', url: '#app-dev' },
        { id: 'branding', label: 'Branding', url: '#branding' },
        { id: 'marketing', label: 'Marketing', url: '#marketing' }
      ]
    },
    {
      id: 'company',
      title: 'Company',
      links: [
        { id: 'about', label: 'About Us', url: '#about', icon: 'fas fa-users' },
        { id: 'team', label: 'Our Team', url: '#team', icon: 'fas fa-user-friends' },
        { id: 'careers', label: 'Careers', url: '#careers', icon: 'fas fa-briefcase' },
        { id: 'press', label: 'Press', url: '#press', icon: 'fas fa-newspaper' }
      ]
    },
    {
      id: 'support',
      title: 'Support',
      links: [
        { id: 'help', label: 'Help Center', url: '#help' },
        { id: 'contact', label: 'Contact', url: '#contact' },
        { id: 'faq', label: 'FAQ', url: '#faq' },
        { id: 'feedback', label: 'Feedback', url: '#feedback' }
      ]
    },
    {
      id: 'legal',
      title: 'Legal',
      links: [
        { id: 'privacy', label: 'Privacy Policy', url: '#privacy' },
        { id: 'terms', label: 'Terms of Use', url: '#terms' },
        { id: 'cookies', label: 'Cookie Policy', url: '#cookies' },
        { id: 'licenses', label: 'Licenses', url: '#licenses' }
      ]
    }
  ],
  copyright: () => `© ${new Date().getFullYear()} BrandName Inc. All rights reserved worldwide.`,
  socialLinks: () => [
    { id: 'facebook', label: 'Facebook', url: '#facebook', icon: 'fab fa-facebook-f' },
    { id: 'twitter', label: 'Twitter', url: '#twitter', icon: 'fab fa-twitter' },
    { id: 'linkedin', label: 'LinkedIn', url: '#linkedin', icon: 'fab fa-linkedin-in' },
    { id: 'instagram', label: 'Instagram', url: '#instagram', icon: 'fab fa-instagram' },
    { id: 'youtube', label: 'YouTube', url: '#youtube', icon: 'fab fa-youtube' },
    { id: 'github', label: 'GitHub', url: '#github', icon: 'fab fa-github' }
  ],
  variant: 'simple',
  theme: () => ({})
});

const defaultTheme: FooterTheme = {
  primaryColor: '#f59e0b',
  backgroundColor: '#111827',
  textColor: '#9ca3af',
  linkColor: '#f3f4f6',
  borderColor: '#1f2937'
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
  position: relative;
}

.footer::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), #fbbf24, var(--primary-color));
}

.footer-container {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 3rem;
}

/* Top Section */
.footer-top {
  display: grid;
  grid-template-columns: 1.5fr 2.5fr;
  gap: 4rem;
}

.brand-column {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.brand-header {
  display: flex;
  align-items: flex-start;
  gap: 1rem;
}

.brand-text {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.brand-name {
  font-size: 1.75rem;
  font-weight: 700;
  color: var(--link-color);
  margin: 0;
  line-height: 1.2;
}

.brand-motto {
  font-size: 0.875rem;
  color: var(--primary-color);
  margin: 0;
  font-weight: 500;
}

.brand-description {
  font-size: 0.95rem;
  line-height: 1.7;
  color: var(--text-color);
  margin: 0;
}

.link-columns {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 2rem;
}

.link-column {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.column-title {
  font-size: 0.875rem;
  font-weight: 700;
  color: var(--primary-color);
  text-transform: uppercase;
  letter-spacing: 0.1em;
  margin: 0;
  padding-bottom: 0.5rem;
  border-bottom: 2px solid var(--border-color);
}

.column-links {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 0.875rem;
}

.link-item {
  color: var(--text-color);
  text-decoration: none;
  font-size: 0.95rem;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.link-item:hover {
  color: var(--primary-color);
  transform: translateX(4px);
}

.link-item i {
  font-size: 0.875rem;
  width: 16px;
  color: var(--primary-color);
}

/* Middle Section */
.footer-middle {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 2.5rem 0;
  border-top: 1px solid var(--border-color);
  border-bottom: 1px solid var(--border-color);
}

.social-section {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.social-heading {
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--link-color);
  margin: 0;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.social-links {
  display: flex;
  gap: 1rem;
}

.social-link {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  border-radius: 8px;
  background: var(--border-color);
  color: var(--text-color);
  text-decoration: none;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.social-link::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, var(--primary-color), transparent);
  transition: left 0.5s ease;
}

.social-link:hover::before {
  left: 100%;
}

.social-link:hover {
  background: var(--primary-color);
  color: var(--background-color);
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(245, 158, 11, 0.4);
}

.social-link i {
  font-size: 1.125rem;
  position: relative;
  z-index: 1;
}

.scroll-top-button {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.875rem 1.75rem;
  background: linear-gradient(135deg, var(--primary-color), #fbbf24);
  color: var(--background-color);
  border: none;
  border-radius: 8px;
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.scroll-top-button:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 24px rgba(245, 158, 11, 0.5);
}

.scroll-top-button i {
  font-size: 0.875rem;
}

/* Bottom Section */
.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 1.5rem;
}

.copyright {
  margin: 0;
  font-size: 0.875rem;
  color: var(--text-color);
}

.footer-badges {
  display: flex;
  gap: 1rem;
}

.badge {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background: var(--border-color);
  color: var(--text-color);
  font-size: 0.8rem;
  font-weight: 600;
  border-radius: 6px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.badge i {
  color: var(--primary-color);
  font-size: 0.875rem;
}

/* Responsive Design */
@media (max-width: 1024px) {
  .footer-top {
    grid-template-columns: 1fr;
    gap: 3rem;
  }

  .link-columns {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .footer {
    padding: 3rem 1.5rem 2rem;
  }

  .link-columns {
    grid-template-columns: 1fr;
    gap: 2rem;
  }

  .footer-middle {
    flex-direction: column;
    gap: 2rem;
    text-align: center;
  }

  .social-section {
    align-items: center;
  }

  .footer-bottom {
    flex-direction: column;
    gap: 1.5rem;
    text-align: center;
  }
}

@media (max-width: 640px) {
  .brand-header {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }

  .social-links {
    flex-wrap: wrap;
    justify-content: center;
  }

  .footer-badges {
    flex-direction: column;
    width: 100%;
  }

  .badge {
    justify-content: center;
  }
}
</style>
