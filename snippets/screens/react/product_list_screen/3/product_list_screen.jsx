import React, { useState } from 'react';
import './product_list_screen.css';

// Version 3: Minimal text-focused design with asymmetric layout

const ProductListScreen = () => {
  const [selectedFilter, setSelectedFilter] = useState('All');
  const [hoveredProduct, setHoveredProduct] = useState(null);

  const filters = ['All', 'New', 'Sale', 'Popular'];

  const products = [
    { id: 1, name: 'Minimal Desk Lamp', price: 89, category: 'Lighting', inStock: true },
    { id: 2, name: 'Ceramic Vase Set', price: 45, category: 'Decor', inStock: true },
    { id: 3, name: 'Wool Throw Blanket', price: 125, category: 'Textiles', inStock: false },
    { id: 4, name: 'Oak Side Table', price: 220, category: 'Furniture', inStock: true },
    { id: 5, name: 'Brass Wall Mirror', price: 180, category: 'Decor', inStock: true },
    { id: 6, name: 'Linen Cushion', price: 35, category: 'Textiles', inStock: true },
    { id: 7, name: 'Glass Pendant Light', price: 156, category: 'Lighting', inStock: true },
    { id: 8, name: 'Marble Tray', price: 68, category: 'Accessories', inStock: true },
  ];

  return (
    <div className="minimal-product-list">
      <header className="minimal-header">
        <div className="header-top">
          <h1>Shop</h1>
          <button className="cart-link">
            Cart <span className="cart-count">3</span>
          </button>
        </div>

        <div className="filter-bar">
          {filters.map(filter => (
            <button
              key={filter}
              className={`filter-btn ${selectedFilter === filter ? 'active' : ''}`}
              onClick={() => setSelectedFilter(filter)}
            >
              {filter}
            </button>
          ))}
        </div>
      </header>

      <div className="product-grid-minimal">
        {products.map((product, index) => (
          <div
            key={product.id}
            className={`minimal-product-item ${index % 3 === 0 ? 'wide' : ''}`}
            onMouseEnter={() => setHoveredProduct(product.id)}
            onMouseLeave={() => setHoveredProduct(null)}
          >
            <div className="product-number">
              {String(index + 1).padStart(2, '0')}
            </div>

            <div className="product-main">
              <div className="product-text">
                <h2 className="product-name">{product.name}</h2>
                <p className="product-category">{product.category}</p>
              </div>

              <div className="product-meta">
                <span className="product-price">
                  ${product.price}
                </span>
                {!product.inStock && (
                  <span className="out-of-stock">Out of stock</span>
                )}
              </div>
            </div>

            <button
              className={`add-button-minimal ${hoveredProduct === product.id ? 'visible' : ''}`}
              disabled={!product.inStock}
            >
              {product.inStock ? 'Add' : 'Notify'}
            </button>

            <div className="divider-line"></div>
          </div>
        ))}
      </div>

      <footer className="minimal-footer">
        <p>Showing {products.length} items</p>
      </footer>
    </div>
  );
};

export default ProductListScreen;
