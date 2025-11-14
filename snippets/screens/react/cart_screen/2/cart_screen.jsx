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
    <div className="modern_cart">
      <div className="modern_cart_container">
        <header className="modern_cart_header">
          <div>
            <h1 className="cart_title_modern">Shopping Cart</h1>
            <p className="cart_count_modern">{items.length} items</p>
          </div>
          <button className="close_btn_modern">✕</button>
        </header>

        <div className="cart_items_modern">
          {items.map(item => (
            <div key={item.id} className="cart_item_modern">
              <div className="item_image_modern">
                <span className="image_emoji">{item.image}</span>
              </div>

              <div className="item_details_modern">
                <h3 className="item_name_modern">{item.name}</h3>
                <p className="item_price_modern">${item.price}</p>

                <div className="quantity_controls_modern">
                  <button
                    className="qty_btn_modern"
                    onClick={() => updateQty(item.id, -1)}
                    disabled={item.quantity === 1}
                  >
                    −
                  </button>
                  <span className="qty_display_modern">{item.quantity}</span>
                  <button
                    className="qty_btn_modern"
                    onClick={() => updateQty(item.id, 1)}
                  >
                    +
                  </button>
                </div>
              </div>

              <div className="item_actions_modern">
                <p className="item_total_modern">
                  ${(item.price * item.quantity).toFixed(2)}
                </p>
                <button
                  className="remove_btn_modern"
                  onClick={() => removeItem(item.id)}
                >
                  Remove
                </button>
              </div>
            </div>
          ))}
        </div>

        <div className="promo_section_modern">
          <input
            type="text"
            placeholder="Enter promo code"
            value={promoCode}
            onChange={(e) => setPromoCode(e.target.value)}
            className="promo_input_modern"
          />
          <button className="promo_apply_modern" onClick={applyPromo}>
            Apply
          </button>
        </div>

        {promoApplied && (
          <div className="promo_success">
            ✓ Promo code applied! You saved ${discount.toFixed(2)}
          </div>
        )}

        <div className="cart_summary_modern">
          <div className="summary_row">
            <span>Subtotal</span>
            <span>${subtotal.toFixed(2)}</span>
          </div>
          {promoApplied && (
            <div className="summary_row discount">
              <span>Discount (SAVE10)</span>
              <span>−${discount.toFixed(2)}</span>
            </div>
          )}
          <div className="summary_row">
            <span>Tax</span>
            <span>${tax.toFixed(2)}</span>
          </div>
          <div className="summary_row total">
            <span>Total</span>
            <span>${total.toFixed(2)}</span>
          </div>
        </div>

        <button className="checkout_btn_modern">
          Proceed to Checkout
        </button>

        <button className="continue_shopping_modern">
          ← Continue Shopping
        </button>
      </div>
    </div>
  );
};

export default CartScreen;
