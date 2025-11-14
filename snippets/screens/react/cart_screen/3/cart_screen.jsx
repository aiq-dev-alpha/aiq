import React, { useState } from 'react';
import './cart_screen.css';

// Version 3: Minimal text-focused cart

const CartScreen = () => {
  const [items, setItems] = useState([
    { id: 1, name: 'Ceramic Coffee Mug', price: 24, quantity: 2 },
    { id: 2, name: 'Linen Kitchen Towel Set', price: 32, quantity: 1 },
    { id: 3, name: 'Oak Cutting Board', price: 58, quantity: 1 },
  ]);

  const updateQuantity = (id, newQty) => {
    if (newQty === 0) {
      setItems(items.filter(item => item.id !== id));
    } else {
      setItems(items.map(item =>
        item.id === id ? { ...item, quantity: newQty } : item
      ));
    }
  };

  const subtotal = items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  const shipping = subtotal > 100 ? 0 : 12;
  const total = subtotal + shipping;

  return (
    <div className="minimal-cart">
      <div className="minimal-cart-content">
        <header className="minimal-cart-header">
          <h1>Cart</h1>
          <a href="#" className="continue-link">Continue shopping</a>
        </header>

        <div className="cart-list-minimal">
          {items.map((item, index) => (
            <div key={item.id} className="minimal-cart-item">
              <div className="item-number">{String(index + 1).padStart(2, '0')}</div>
              
              <div className="item-info-minimal">
                <h2 className="item-name-minimal">{item.name}</h2>
                <p className="item-price-minimal">${item.price}</p>
              </div>

              <div className="item-qty-minimal">
                <button
                  className="qty-adjust"
                  onClick={() => updateQuantity(item.id, item.quantity - 1)}
                >
                  −
                </button>
                <span className="qty-value">{item.quantity}</span>
                <button
                  className="qty-adjust"
                  onClick={() => updateQuantity(item.id, item.quantity + 1)}
                >
                  +
                </button>
              </div>

              <div className="item-subtotal-minimal">
                ${(item.price * item.quantity).toFixed(2)}
              </div>

              <div className="item-divider"></div>
            </div>
          ))}
        </div>

        {items.length === 0 && (
          <div className="empty-cart">
            <p>Your cart is empty</p>
            <a href="#">Start shopping</a>
          </div>
        )}

        {items.length > 0 && (
          <>
            <div className="cart-totals-minimal">
              <div className="total-row">
                <span>Subtotal</span>
                <span>${subtotal.toFixed(2)}</span>
              </div>
              <div className="total-row">
                <span>Shipping</span>
                <span>{shipping === 0 ? 'Free' : `$${shipping.toFixed(2)}`}</span>
              </div>
              {shipping > 0 && subtotal < 100 && (
                <p className="shipping-note">
                  Add ${(100 - subtotal).toFixed(2)} more for free shipping
                </p>
              )}
              <div className="total-row final">
                <span>Total</span>
                <span>${total.toFixed(2)}</span>
              </div>
            </div>

            <button className="checkout-btn-minimal">
              Checkout
            </button>
          </>
        )}
      </div>
    </div>
  );
};

export default CartScreen;
