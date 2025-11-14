import React, { useState } from 'react';
import './ProductListScreen.css';

const ProductListScreen = () => {
  const [searchText, setSearchText] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [isGridView, setIsGridView] = useState(true);
  const [selectedSort, setSelectedSort] = useState('Featured');

  const categories = ['All', 'Electronics', 'Fashion', 'Home', 'Sports'];
  const sortOptions = ['Featured', 'Price: Low to High', 'Price: High to Low', 'Newest'];

  const ProductCard = ({ index }) => (
    <div className="product-card">
      <div className="product-image">
        <div className="placeholder-image">
          <i className="icon-image"></i>
        </div>
      </div>
      <div className="product-info">
        <h3>Product {index}</h3>
        <div className="rating">
          <div className="stars">
            {[...Array(5)].map((_, i) => (
              <i key={i} className={`star ${i < 4 ? 'filled' : ''}`}>★</i>
            ))}
          </div>
          <span>4.5 (120)</span>
        </div>
        <div className="price-row">
          <span className="price">${index * 10}.99</span>
          <button className="add-to-cart-btn" onClick={() => {}}>
            <i className="plus-icon">+</i>
          </button>
        </div>
      </div>
    </div>
  );

  const ProductListItem = ({ index }) => (
    <div className="product-list-item">
      <div className="product-image-small">
        <div className="placeholder-image">
          <i className="icon-image"></i>
        </div>
      </div>
      <div className="product-details">
        <h3>Product {index}</h3>
        <div className="rating">
          <div className="stars">
            {[...Array(5)].map((_, i) => (
              <i key={i} className={`star ${i < 4 ? 'filled' : ''}`}>★</i>
            ))}
          </div>
          <span>4.5 (120)</span>
        </div>
        <span className="price">${index * 10}.99</span>
      </div>
      <button className="add-to-cart-btn" onClick={() => {}}>
        <i className="cart-icon">🛒</i>
      </button>
    </div>
  );

  return (
    <div className="product-list-screen">
      <header className="header">
        <h1>Products</h1>
        <div className="header-actions">
          <button
            className="view-toggle"
            onClick={() => setIsGridView(!isGridView)}
          >
            {isGridView ? '☰' : '⊞'}
          </button>
          <button className="cart-btn">🛒</button>
        </div>
      </header>

      {/* Search Bar */}
      <div className="search-container">
        <div className="search-bar">
          <i className="search-icon">🔍</i>
          <input
            type="text"
            placeholder="Search products..."
            value={searchText}
            onChange={(e) => setSearchText(e.target.value)}
          />
        </div>
      </div>

      {/* Filter Bar */}
      <div className="filter-bar">
        <div className="category-filters">
          {categories.map((category) => (
            <button
              key={category}
              className={`filter-chip ${selectedCategory === category ? 'active' : ''}`}
              onClick={() => setSelectedCategory(category)}
            >
              {category}
            </button>
          ))}
        </div>
        <div className="sort-dropdown">
          <select
            value={selectedSort}
            onChange={(e) => setSelectedSort(e.target.value)}
          >
            {sortOptions.map((option) => (
              <option key={option} value={option}>{option}</option>
            ))}
          </select>
        </div>
      </div>

      {/* Products Grid/List */}
      <div className={`products-container ${isGridView ? 'grid-view' : 'list-view'}`}>
        {[...Array(20)].map((_, index) => (
          isGridView ?
            <ProductCard key={index} index={index + 1} /> :
            <ProductListItem key={index} index={index + 1} />
        ))}
      </div>
    </div>
  );
};

export default ProductListScreen;