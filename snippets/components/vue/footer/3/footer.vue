<template>
  <footer class="footer" :class="`footer-${variant}`" :style="computedStyles">
    <div class="footer-container">
      <!-- Newsletter Section -->
      <div class="newsletter-section">
        <div class="newsletter-content">
          <h2 class="newsletter-title">Stay Updated</h2>
          <p class="newsletter-description">
            Subscribe to our newsletter for the latest updates, tips, and exclusive content delivered to your inbox.
          </p>
        </div>
        <form @submit.prevent="handleNewsletterSubmit" class="newsletter-form">
          <div class="form-group">
            <input
              v-model="email"
              type="email"
              placeholder="Enter your email"
              class="newsletter-input"
              required
              aria-label="Email address"
            />
            <button type="submit" class="newsletter-button">
              <span>Subscribe</span>
              <i class="fas fa-paper-plane"></i>
            </button>
          </div>
          <p v-if="subscriptionMessage" class="subscription-message" :class="{ success: subscriptionSuccess }">
            {{ subscriptionMessage }}
          </p>
        </form>
      </div>

      <!-- Main Footer Content -->
      <div class="footer-main">
        <!-- Brand Section -->
        <div class="footer-brand">
          <div class="brand-logo">
            <svg width="44" height="44" viewBox="0 0 44 44" fill="none">
              <rect width="44" height="44" rx="10" :fill="currentTheme.primaryColor"/>
              <path d="M14 22L20 28L30 16" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span class="brand-name">InnovateCo</span>
          </div>
          <p class="brand-description">
            Empowering businesses with cutting-edge technology solutions and innovative digital experiences.
          </p>
          <div class="brand-social">
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

        <!-- Footer Links -->
        <div class="footer-links">
          <div
            v-for="section in sections"
            :key="section.id"
            class="link-group"
          >
            <h3 class="link-group-title">{{ section.title }}</h3>
            <ul class="link-list">
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
        <div class="footer-bottom-content">
          <p class="copyright">{{ copyright }}</p>
          <div class="footer-badges">
            <span class="badge">Secure</span>
            <span class="badge">SSL</span>
            <span class="badge">GDPR</span>
          </div>
        </div>
        <button
          @click="scrollToTop"
          class="back-to-top"
          aria-label="Back to top"
        >
          <i class="fas fa-arrow-up"></i>
        </button>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { ref, computed, defineProps, withDefaults } from 'vue';

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
      id: 'solutions',
      title: 'Solutions',
      links: [
        { id: 'enterprise', label: 'Enterprise', url: '#enterprise' },
        { id: 'small-business', label: 'Small Business', url: '#small-business' },
        { id: 'startups', label: 'Startups', url: '#startups' },
        { id: 'developers', label: 'Developers', url: '#developers' }
      ]
    },
    {
      id: 'resources',
      title: 'Resources',
      links: [
        { id: 'blog', label: 'Blog', url: '#blog', icon: 'fas fa-book-open' },
        { id: 'guides', label: 'Guides', url: '#guides', icon: 'fas fa-map' },
        { id: 'webinars', label: 'Webinars', url: '#webinars', icon: 'fas fa-video' },
        { id: 'case-studies', label: 'Case Studies', url: '#case-studies', icon: 'fas fa-chart-line' }
      ]
    },
    {
      id: 'company',
      title: 'Company',
      links: [
        { id: 'about', label: 'About Us', url: '#about' },
        { id: 'careers', label: 'Careers', url: '#careers' },
        { id: 'partners', label: 'Partners', url: '#partners' },
        { id: 'news', label: 'News', url: '#news' }
      ]
    },
    {
      id: 'support',
      title: 'Support',
      links: [
        { id: 'help', label: 'Help Center', url: '#help' },
        { id: 'contact', label: 'Contact Us', url: '#contact' },
        { id: 'status', label: 'System Status', url: '#status' },
        { id: 'terms', label: 'Terms', url: '#terms' }
      ]
    }
  ],
  copyright: () => `© ${new Date().getFullYear()} InnovateCo. All rights reserved.`,
  socialLinks: () => [
    { id: 'twitter', label: 'Twitter', url: '#twitter', icon: 'fab fa-twitter' },
    { id: 'facebook', label: 'Facebook', url: '#facebook', icon: 'fab fa-facebook' },
    { id: 'linkedin', label: 'LinkedIn', url: '#linkedin', icon: 'fab fa-linkedin' },
    { id: 'github', label: 'GitHub', url: '#github', icon: 'fab fa-github' },
    { id: 'youtube', label: 'YouTube', url: '#youtube', icon: 'fab fa-youtube' }
  ],
  variant: 'newsletter',
  theme: () => ({})
});

const defaultTheme: FooterTheme = {
  primaryColor: '#8b5cf6',
  backgroundColor: '#18181b',
  textColor: '#a1a1aa',
  linkColor: '#e4e4e7',
  borderColor: '#27272a'
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

const email = ref('');
const subscriptionMessage = ref('');
const subscriptionSuccess = ref(false);

const handleNewsletterSubmit = () => {
  if (email.value) {
    subscriptionSuccess.value = true;
    subscriptionMessage.value = 'Thanks for subscribing! Check your inbox.';
    email.value = '';
    setTimeout(() => {
      subscriptionMessage.value = '';
    }, 5000);
  }
};

const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' });
};
</script>

<style scoped>
.footer {
  background-color: var(--background-color);
  color: var(--text-color);
  border-top: 1px solid var(--border-color);
}

.footer-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

/* Newsletter Section */
.newsletter-section {
  padding: 4rem 0;
  border-bottom: 1px solid var(--border-color);
  display: grid;
  grid-template-columns: 1fr 1.2fr;
  gap: 3rem;
  align-items: center;
}

.newsletter-content {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.newsletter-title {
  font-size: 2rem;
  font-weight: 700;
  color: var(--link-color);
  margin: 0;
  background: linear-gradient(135deg, var(--primary-color), #a78bfa);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.newsletter-description {
  font-size: 1rem;
  line-height: 1.6;
  color: var(--text-color);
  margin: 0;
}

.newsletter-form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.form-group {
  display: flex;
  gap: 0.75rem;
}

.newsletter-input {
  flex: 1;
  padding: 1rem 1.5rem;
  background: var(--border-color);
  border: 2px solid transparent;
  border-radius: 12px;
  color: var(--link-color);
  font-size: 1rem;
  transition: all 0.3s ease;
}

.newsletter-input:focus {
  outline: none;
  border-color: var(--primary-color);
  background: rgba(139, 92, 246, 0.1);
}

.newsletter-input::placeholder {
  color: var(--text-color);
}

.newsletter-button {
  padding: 1rem 2rem;
  background: linear-gradient(135deg, var(--primary-color), #a78bfa);
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.newsletter-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(139, 92, 246, 0.4);
}

.subscription-message {
  margin: 0;
  padding: 0.75rem 1rem;
  border-radius: 8px;
  font-size: 0.875rem;
  background: rgba(139, 92, 246, 0.1);
  color: var(--primary-color);
  border: 1px solid var(--primary-color);
}

.subscription-message.success {
  background: rgba(34, 197, 94, 0.1);
  color: #22c55e;
  border-color: #22c55e;
}

/* Main Footer */
.footer-main {
  padding: 4rem 0;
  display: grid;
  grid-template-columns: 1.5fr 2fr;
  gap: 4rem;
}

.footer-brand {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.brand-logo {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.brand-name {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--link-color);
}

.brand-description {
  font-size: 0.95rem;
  line-height: 1.6;
  color: var(--text-color);
  margin: 0;
}

.brand-social {
  display: flex;
  gap: 0.75rem;
}

.social-link {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 8px;
  background: var(--border-color);
  color: var(--text-color);
  text-decoration: none;
  transition: all 0.3s ease;
}

.social-link:hover {
  background: var(--primary-color);
  color: white;
  transform: translateY(-2px);
}

.footer-links {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 2rem;
}

.link-group {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.link-group-title {
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--link-color);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin: 0;
}

.link-list {
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
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.footer-link:hover {
  color: var(--primary-color);
  padding-left: 0.25rem;
}

.footer-link i {
  font-size: 0.875rem;
}

/* Footer Bottom */
.footer-bottom {
  padding: 2rem 0;
  border-top: 1px solid var(--border-color);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.footer-bottom-content {
  display: flex;
  align-items: center;
  gap: 2rem;
}

.copyright {
  margin: 0;
  font-size: 0.875rem;
  color: var(--text-color);
}

.footer-badges {
  display: flex;
  gap: 0.5rem;
}

.badge {
  padding: 0.25rem 0.75rem;
  background: var(--border-color);
  color: var(--text-color);
  font-size: 0.75rem;
  font-weight: 600;
  border-radius: 6px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.back-to-top {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  border-radius: 12px;
  background: linear-gradient(135deg, var(--primary-color), #a78bfa);
  color: white;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
}

.back-to-top:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(139, 92, 246, 0.4);
}

/* Responsive Design */
@media (max-width: 1024px) {
  .newsletter-section {
    grid-template-columns: 1fr;
    gap: 2rem;
  }

  .footer-main {
    grid-template-columns: 1fr;
    gap: 3rem;
  }

  .footer-links {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .footer-container {
    padding: 0 1.5rem;
  }

  .newsletter-section {
    padding: 3rem 0;
  }

  .newsletter-title {
    font-size: 1.5rem;
  }

  .form-group {
    flex-direction: column;
  }

  .footer-main {
    padding: 3rem 0;
  }

  .footer-links {
    grid-template-columns: 1fr;
  }

  .footer-bottom {
    flex-direction: column;
    gap: 1.5rem;
  }

  .footer-bottom-content {
    flex-direction: column;
    gap: 1rem;
    text-align: center;
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
