import React, { useState } from 'react';
import './CartScreen.css';

const CartScreen = () => {
  const [cartItems, setCartItems] = useState([
    {
      id: '1',
      name: 'Premium Cotton T-Shirt',
      price: 29.99,
      quantity: 2,
      size: 'M',
      color: 'Blue',
      image: 'tshirt.jpg'
    },
    {
      id: '2',
      name: 'Wireless Headphones',
      price: 89.99,
      quantity: 1,
      size: null,
      color: 'Black',
      image: 'headphones.jpg'
    },
    {
      id: '3',
      name: 'Running Shoes',
      price: 129.99,
      quantity: 1,
      size: '9',
      color: 'White',
      image: 'shoes.jpg'
    }
  ]);

  const [promoCode, setPromoCode] = useState('');

  const updateQuantity = (id, newQuantity) => {
    setCartItems(items =>
      items.map(item =>
        item.id === id ? { ...item, quantity: Math.max(1, newQuantity) } : item
      )
    );
  };

  const removeItem = (id) => {
    setCartItems(items => items.filter(item => item.id !== id));
  };

  const subtotal = cartItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  const shipping = 9.99;
  const tax = subtotal * 0.08;
  const total = subtotal + shipping + tax;

  const CartItem = ({ item }) => (
    <div className="cart-item">
      <div className="item-image">
        <div className="placeholder-image">
          <i className="image-icon">📷</i>
        </div>
      </div>

      <div className="item-details">
        <h3>{item.name}</h3>
        {(item.size || item.color) && (
          <p className="item-attributes">
            {[item.size, item.color].filter(Boolean).join(' • ')}
          </p>
        )}
        <p className="item-price">${item.price.toFixed(2)}</p>
      </div>

      <div className="item-actions">
        <div className="quantity-controls">
          <button
            className="qty-btn"
            onClick={() => updateQuantity(item.id, item.quantity - 1)}
            disabled={item.quantity <= 1}
          >
            -
          </button>
          <span className="quantity">{item.quantity}</span>
          <button
            className="qty-btn"
            onClick={() => updateQuantity(item.id, item.quantity + 1)}
          >
            +
          </button>
        </div>

        <div className="item-buttons">
          <button className="wishlist-btn" title="Add to Wishlist">
            🤍
          </button>
          <button
            className="remove-btn"
            onClick={() => removeItem(item.id)}
            title="Remove"
          >
            🗑️
          </button>
        </div>
      </div>
    </div>
  );

  const EmptyCart = () => (
    <div className="empty-cart">
      <div className="empty-cart-icon">🛒</div>
      <h2>Your cart is empty</h2>
      <p>Add some items to get started</p>
      <button className="continue-shopping-btn">
        Continue Shopping
      </button>
    </div>
  );

  if (cartItems.length === 0) {
    return (
      <div className="cart-screen">
        <header className="header">
          <button className="back-btn">←</button>
          <h1>Shopping Cart</h1>
        </header>
        <EmptyCart />
      </div>
    );
  }

  return (
    <div className="cart-screen">
      <header className="header">
        <button className="back-btn">←</button>
        <h1>Shopping Cart ({cartItems.length})</h1>
        <button
          className="clear-all-btn"
          onClick={() => setCartItems([])}
        >
          Clear All
        </button>
      </header>

      <div className="cart-content">
        <div className="cart-items">
          {cartItems.map(item => (
            <CartItem key={item.id} item={item} />
          ))}
        </div>

        <div className="order-summary">
          {/* Promo Code */}
          <div className="promo-section">
            <input
              type="text"
              placeholder="Enter promo code"
              value={promoCode}
              onChange={(e) => setPromoCode(e.target.value)}
              className="promo-input"
            />
            <button className="apply-btn">Apply</button>
          </div>

          {/* Summary */}
          <div className="summary">
            <div className="summary-row">
              <span>Subtotal</span>
              <span>${subtotal.toFixed(2)}</span>
            </div>
            <div className="summary-row">
              <span>Shipping</span>
              <span>${shipping.toFixed(2)}</span>
            </div>
            <div className="summary-row">
              <span>Tax</span>
              <span>${tax.toFixed(2)}</span>
            </div>
            <div className="summary-divider"></div>
            <div className="summary-row total">
              <span>Total</span>
              <span>${total.toFixed(2)}</span>
            </div>
          </div>

          <button className="checkout-btn">
            PROCEED TO CHECKOUT
          </button>
        </div>
      </div>
    </div>
  );
};

export default CartScreen;