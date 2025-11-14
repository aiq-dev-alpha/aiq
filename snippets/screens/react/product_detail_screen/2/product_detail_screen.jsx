import React, { useState } from 'react';
import './ProductDetailScreen.css';

const ProductDetailScreen = ({ productId }) => {
  const [selectedImageIndex, setSelectedImageIndex] = useState(0);
  const [selectedSize, setSelectedSize] = useState('M');
  const [selectedColor, setSelectedColor] = useState('Red');
  const [quantity, setQuantity] = useState(1);
  const [isFavorite, setIsFavorite] = useState(false);

  const sizes = ['XS', 'S', 'M', 'L', 'XL'];
  const colors = ['Red', 'Blue', 'Green', 'Black', 'White'];
  const productImages = Array(5).fill(null);

  const getColorStyle = (colorName) => {
    const colorMap = {
      'Red': '#ff0000',
      'Blue': '#0000ff',
      'Green': '#008000',
      'Black': '#000000',
      'White': '#ffffff'
    };
    return { backgroundColor: colorMap[colorName] || '#gray' };
  };

  return (
    <div className="product-detail-screen">
      <header className="header">
        <button className="back-btn">←</button>
        <div className="header-actions">
          <button className="share-btn">📤</button>
          <button
            className={`favorite-btn ${isFavorite ? 'active' : ''}`}
            onClick={() => setIsFavorite(!isFavorite)}
          >
            {isFavorite ? '❤️' : '🤍'}
          </button>
        </div>
      </header>

      <div className="content">
        {/* Product Images */}
        <div className="image-section">
          <div className="main-image">
            <div className="placeholder-image">
              <i className="image-icon">📷</i>
            </div>
          </div>

          <div className="image-thumbnails">
            {productImages.map((_, index) => (
              <div
                key={index}
                className={`thumbnail ${selectedImageIndex === index ? 'active' : ''}`}
                onClick={() => setSelectedImageIndex(index)}
              >
                <div className="placeholder-image">
                  <i className="image-icon">📷</i>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Product Info */}
        <div className="product-info">
          <h1>Premium Cotton T-Shirt</h1>

          <div className="rating">
            <div className="stars">
              {[...Array(5)].map((_, i) => (
                <span key={i} className={`star ${i < 4 ? 'filled' : ''}`}>★</span>
              ))}
            </div>
            <span>4.5 (120 reviews)</span>
          </div>

          <div className="price-section">
            <span className="current-price">$29.99</span>
            <span className="original-price">$39.99</span>
            <span className="discount-badge">25% OFF</span>
          </div>

          {/* Size Selection */}
          <div className="selection-section">
            <h3>Size</h3>
            <div className="options">
              {sizes.map((size) => (
                <button
                  key={size}
                  className={`option-btn ${selectedSize === size ? 'active' : ''}`}
                  onClick={() => setSelectedSize(size)}
                >
                  {size}
                </button>
              ))}
            </div>
          </div>

          {/* Color Selection */}
          <div className="selection-section">
            <h3>Color</h3>
            <div className="options">
              {colors.map((color) => (
                <button
                  key={color}
                  className={`option-btn color-option ${selectedColor === color ? 'active' : ''}`}
                  onClick={() => setSelectedColor(color)}
                >
                  <span
                    className="color-circle"
                    style={getColorStyle(color)}
                  ></span>
                  {color}
                </button>
              ))}
            </div>
          </div>

          {/* Quantity */}
          <div className="quantity-section">
            <h3>Quantity</h3>
            <div className="quantity-controls">
              <button
                className="qty-btn"
                onClick={() => quantity > 1 && setQuantity(quantity - 1)}
                disabled={quantity <= 1}
              >
                -
              </button>
              <span className="quantity">{quantity}</span>
              <button
                className="qty-btn"
                onClick={() => setQuantity(quantity + 1)}
              >
                +
              </button>
            </div>
          </div>

          {/* Description */}
          <div className="description-section">
            <h3>Description</h3>
            <p>
              This premium cotton t-shirt is made from 100% organic cotton with a comfortable fit.
              Perfect for casual wear and everyday comfort. Machine washable and available in multiple
              colors and sizes.
            </p>
          </div>

          {/* Features */}
          <div className="features-section">
            <h3>Features</h3>
            <ul className="features-list">
              <li>✅ 100% Organic Cotton</li>
              <li>✅ Machine Washable</li>
              <li>✅ Comfortable Fit</li>
              <li>✅ Sustainable Production</li>
            </ul>
          </div>
        </div>
      </div>

      {/* Add to Cart Button */}
      <div className="bottom-actions">
        <button className="add-to-cart-btn">
          ADD TO CART - ${(29.99 * quantity).toFixed(2)}
        </button>
        <button className="buy-now-btn">
          BUY NOW
        </button>
      </div>
    </div>
  );
};

export default ProductDetailScreen;