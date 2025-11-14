import React, { useState } from 'react';
import './cart_screen.css';

// Version 2: Modern slide-out cart with product images and animations

const CartScreen = () => {
  const [items, setItems] = useState([
    { id: 1, name: 'Premium Wireless Headphones', price: 299, quantity: 1, image: '🎧' },
    { id: 2, name: 'Smart Watch Series 8', price: 449, quantity: 1, image: '⌚' },
    { id: 3, name: 'Leather Laptop Bag', price: 129, quantity: 2, image: '💼' },
  ]);

  const [promoCode, setPromoCode] = useState('');
  const [promoApplied, setPromoApplied] = useState(false);

  const updateQty = (id, delta) => {
    setItems(items.map(item =>
      item.id === id
        ? { ...item, quantity: Math.max(1, Math.min(99, item.quantity + delta)) }
        : item
    ));
  };

  const removeItem = (id) => {
    setItems(items.filter(item => item.id !== id));
  };

  const applyPromo = () => {
    if (promoCode.toUpperCase() === 'SAVE10') {
      setPromoApplied(true);
    }
  };

  const subtotal = items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  const discount = promoApplied ? subtotal * 0.1 : 0;
  const tax = (subtotal - discount) * 0.08;
  const total = subtotal - discount + tax;

  return (
    <div className="modern-cart">
      <div className="modern-cart-container">
        <header className="modern-cart-header">
          <div>
            <h1 className="cart-title-modern">Shopping Cart</h1>
            <p className="cart-count-modern">{items.length} items</p>
          </div>
          <button className="close-btn-modern">✕</button>
        </header>

        <div className="cart-items-modern">
          {items.map(item => (
            <div key={item.id} className="cart-item-modern">
              <div className="item-image-modern">
                <span className="image-emoji">{item.image}</span>
              </div>

              <div className="item-details-modern">
                <h3 className="item-name-modern">{item.name}</h3>
                <p className="item-price-modern">${item.price}</p>

                <div className="quantity-controls-modern">
                  <button
                    className="qty-btn-modern"
                    onClick={() => updateQty(item.id, -1)}
                    disabled={item.quantity === 1}
                  >
                    −
                  </button>
                  <span className="qty-display-modern">{item.quantity}</span>
                  <button
                    className="qty-btn-modern"
                    onClick={() => updateQty(item.id, 1)}
                  >
                    +
                  </button>
                </div>
              </div>

              <div className="item-actions-modern">
                <p className="item-total-modern">
                  ${(item.price * item.quantity).toFixed(2)}
                </p>
                <button
                  className="remove-btn-modern"
                  onClick={() => removeItem(item.id)}
                >
                  Remove
                </button>
              </div>
            </div>
          ))}
        </div>

        <div className="promo-section-modern">
          <input
            type="text"
            placeholder="Enter promo code"
            value={promoCode}
            onChange={(e) => setPromoCode(e.target.value)}
            className="promo-input-modern"
          />
          <button className="promo-apply-modern" onClick={applyPromo}>
            Apply
          </button>
        </div>

        {promoApplied && (
          <div className="promo-success">
            ✓ Promo code applied! You saved ${discount.toFixed(2)}
          </div>
        )}

        <div className="cart-summary-modern">
          <div className="summary-row">
            <span>Subtotal</span>
            <span>${subtotal.toFixed(2)}</span>
          </div>
          {promoApplied && (
            <div className="summary-row discount">
              <span>Discount (SAVE10)</span>
              <span>−${discount.toFixed(2)}</span>
            </div>
          )}
          <div className="summary-row">
            <span>Tax</span>
            <span>${tax.toFixed(2)}</span>
          </div>
          <div className="summary-row total">
            <span>Total</span>
            <span>${total.toFixed(2)}</span>
          </div>
        </div>

        <button className="checkout-btn-modern">
          Proceed to Checkout
        </button>

        <button className="continue-shopping-modern">
          ← Continue Shopping
        </button>
      </div>
    </div>
  );
};

export default CartScreen;
