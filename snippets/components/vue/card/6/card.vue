<template>
  <div class="product-card">
    <div class="product-image">
      <img :src="image" :alt="name" />
      <span v-if="onSale" class="sale-badge">Sale</span>
      <button class="wishlist-btn" @click="toggleWishlist">
        {{ inWishlist ? '❤️' : '🤍' }}
      </button>
    </div>
    <div class="product-info">
      <h3 class="product-name">{{ name }}</h3>
      <div class="rating">
        <span v-for="i in 5" :key="i" class="star" :class="{ filled: i <= rating }">★</span>
        <span class="reviews">({{ reviewCount }})</span>
      </div>
      <div class="price-section">
        <span v-if="onSale" class="original-price">${{ originalPrice }}</span>
        <span class="current-price">${{ price }}</span>
      </div>
      <button class="add-to-cart" @click="$emit('add-to-cart')">
        <span>🛒</span>Add to Cart
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  image: string;
  name: string;
  price: number;
  originalPrice?: number;
  rating: number;
  reviewCount: number;
  onSale?: boolean;
}

defineProps<Props>();

defineEmits<{
  'add-to-cart': [];
}>();

const inWishlist = ref(false);
const toggleWishlist = () => {
  inWishlist.value = !inWishlist.value;
};
</script>

<style scoped>
.product-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.product-card:hover {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  transform: translateY(-4px);
}

.product-image {
  position: relative;
  padding-top: 100%;
  overflow: hidden;
  background: #f3f4f6;
}

.product-image img {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.sale-badge {
  position: absolute;
  top: 1rem;
  left: 1rem;
  padding: 0.25rem 0.75rem;
  background: #ef4444;
  color: white;
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: 700;
}

.wishlist-btn {
  position: absolute;
  top: 1rem;
  right: 1rem;
  width: 36px;
  height: 36px;
  background: white;
  border: none;
  border-radius: 50%;
  font-size: 1.25rem;
  cursor: pointer;
  transition: transform 0.2s;
}

.wishlist-btn:hover {
  transform: scale(1.1);
}

.product-info {
  padding: 1.25rem;
}

.product-name {
  margin: 0 0 0.5rem 0;
  font-size: 1.125rem;
  font-weight: 600;
  color: #111827;
}

.rating {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  margin-bottom: 0.75rem;
}

.star {
  color: #d1d5db;
  font-size: 1rem;
}

.star.filled {
  color: #fbbf24;
}

.reviews {
  margin-left: 0.5rem;
  font-size: 0.875rem;
  color: #6b7280;
}

.price-section {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1rem;
}

.original-price {
  color: #9ca3af;
  text-decoration: line-through;
  font-size: 0.875rem;
}

.current-price {
  color: #111827;
  font-size: 1.5rem;
  font-weight: 700;
}

.add-to-cart {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.75rem;
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.add-to-cart:hover {
  transform: scale(1.02);
}
</style>