import React, { useState, useRef } from 'react';
import './product_list_screen.css';

// Version 2: Carousel/Slider layout with categories

const ProductListScreen = () => {
  const [selectedCategory, setSelectedCategory] = useState(0);
  const carouselRefs = useRef([]);

  const categories = [
    { name: 'Featured', items: 12 },
    { name: 'Electronics', items: 8 },
    { name: 'Fashion', items: 15 },
    { name: 'Home & Garden', items: 10 },
    { name: 'Sports & Outdoors', items: 9 },
  ];

  const scrollCarousel = (categoryIndex, direction) => {
    const carousel = carouselRefs.current[categoryIndex];
    if (carousel) {
      const scrollAmount = 320;
      carousel.scrollBy({
        left: direction === 'left' ? -scrollAmount : scrollAmount,
        behavior: 'smooth'
      });
    }
  };

  const ProductCard = ({ index, category }) => (
    <div className="carousel-product-card">
      <div className="product-badge">New</div>
      <div className="product-image-large">
        <div className="image-placeholder">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
            <circle cx="8.5" cy="8.5" r="1.5" />
            <polyline points="21 15 16 10 5 21" />
          </svg>
        </div>
        <button className="wishlist-btn">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
          </svg>
        </button>
      </div>
      <div className="product-content">
        <div className="product-category">{category}</div>
        <h3 className="product-title">Premium Product {index}</h3>
        <div className="product-rating">
          <div className="stars">
            {[...Array(5)].map((_, i) => (
              <svg key={i} viewBox="0 0 20 20" fill={i < 4 ? "currentColor" : "none"} stroke="currentColor">
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
              </svg>
            ))}
          </div>
          <span className="rating-count">4.5 (234)</span>
        </div>
        <div className="product-footer">
          <div className="price-section">
            <span className="original-price">${(index * 15 + 20).99}</span>
            <span className="current-price">${(index * 10).99}</span>
          </div>
          <button className="add-btn">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
            </svg>
          </button>
        </div>
      </div>
    </div>
  );

  const CategorySection = ({ category, index }) => (
    <div className="category-section">
      <div className="category-header">
        <div>
          <h2>{category.name}</h2>
          <p>{category.items} items available</p>
        </div>
        <button className="see-all-btn">
          See All
          <svg viewBox="0 0 20 20" fill="currentColor">
            <path fillRule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clipRule="evenodd" />
          </svg>
        </button>
      </div>

      <div className="carousel-container">
        <button
          className="carousel-nav left"
          onClick={() => scrollCarousel(index, 'left')}
        >
          <svg viewBox="0 0 20 20" fill="currentColor">
            <path fillRule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clipRule="evenodd" />
          </svg>
        </button>

        <div
          className="products-carousel"
          ref={(el) => (carouselRefs.current[index] = el)}
        >
          {[...Array(category.items)].map((_, i) => (
            <ProductCard key={i} index={i + 1} category={category.name} />
          ))}
        </div>

        <button
          className="carousel-nav right"
          onClick={() => scrollCarousel(index, 'right')}
        >
          <svg viewBox="0 0 20 20" fill="currentColor">
            <path fillRule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clipRule="evenodd" />
          </svg>
        </button>
      </div>
    </div>
  );

  return (
    <div className="carousel-product-screen">
      <header className="main-header">
        <div className="header-content">
          <h1>Discover Products</h1>
          <div className="header-actions">
            <button className="icon-btn">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </button>
            <button className="icon-btn cart">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
              </svg>
              <span className="cart-badge">3</span>
            </button>
          </div>
        </div>

        <div className="category-tabs">
          {categories.map((cat, idx) => (
            <button
              key={cat.name}
              className={`category-tab ${selectedCategory === idx ? 'active' : ''}`}
              onClick={() => setSelectedCategory(idx)}
            >
              {cat.name}
            </button>
          ))}
        </div>
      </header>

      <div className="sections-container">
        {categories.map((category, index) => (
          <CategorySection key={category.name} category={category} index={index} />
        ))}
      </div>
    </div>
  );
};

export default ProductListScreen;
