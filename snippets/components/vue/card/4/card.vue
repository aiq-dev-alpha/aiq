<template>
  <div :class="['pricing-card', variant, { featured }]">
    <div v-if="featured" class="featured-badge">Popular</div>
    <div class="card-header">
      <h3 class="plan-name">{{ planName }}</h3>
      <div class="price">
        <span class="currency">$</span>
        <span class="amount">{{ price }}</span>
        <span class="period">/{{ period }}</span>
      </div>
    </div>
    <ul class="features">
      <li v-for="(feature, i) in features" :key="i" class="feature-item">
        <span class="check">✓</span>
        {{ feature }}
      </li>
    </ul>
    <button class="cta-button">
      <slot>Get Started</slot>
    </button>
  </div>
</template>

<script setup lang="ts">
interface Props {
  planName: string;
  price: number;
  period?: string;
  features: string[];
  variant?: 'basic' | 'pro' | 'enterprise';
  featured?: boolean;
}

withDefaults(defineProps<Props>(), {
  period: 'mo',
  variant: 'basic',
  featured: false
});
</script>

<style scoped>
.pricing-card {
  position: relative;
  padding: 2rem;
  background: white;
  border-radius: 20px;
  border: 2px solid #e5e7eb;
  transition: all 0.3s ease;
}

.pricing-card.featured {
  border-color: #8b5cf6;
  transform: scale(1.05);
  box-shadow: 0 20px 60px rgba(139, 92, 246, 0.2);
}

.featured-badge {
  position: absolute;
  top: -12px;
  right: 2rem;
  padding: 0.5rem 1rem;
  background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
  color: white;
  border-radius: 20px;
  font-size: 0.875rem;
  font-weight: 700;
}

.card-header {
  text-align: center;
  margin-bottom: 2rem;
  padding-bottom: 2rem;
  border-bottom: 2px solid #f3f4f6;
}

.plan-name {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1f2937;
  margin-bottom: 1rem;
}

.price {
  display: flex;
  align-items: flex-start;
  justify-content: center;
  gap: 0.25rem;
}

.currency {
  font-size: 1.5rem;
  font-weight: 600;
  color: #6b7280;
}

.amount {
  font-size: 3.5rem;
  font-weight: 800;
  color: #111827;
  line-height: 1;
}

.period {
  font-size: 1rem;
  color: #6b7280;
  align-self: flex-end;
  padding-bottom: 0.5rem;
}

.features {
  list-style: none;
  padding: 0;
  margin: 0 0 2rem 0;
}

.feature-item {
  padding: 0.75rem 0;
  color: #374151;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.check {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #dcfce7;
  color: #16a34a;
  border-radius: 50%;
  font-weight: 700;
  flex-shrink: 0;
}

.cta-button {
  width: 100%;
  padding: 1rem;
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s;
}

.pricing-card.featured .cta-button {
  background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
}

.cta-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}
</style>