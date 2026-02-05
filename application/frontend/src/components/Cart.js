import React from 'react';

const Cart = ({ cart, onCartUpdate }) => {
  if (!cart || !cart.items || cart.items.length === 0) {
    return (
      <div className="cart-container">
        <h2>Your Cart</h2>
        <p>Your cart is empty. Add some delicious coffee to get started!</p>
      </div>
    );
  }

  return (
    <div className="cart-container">
      <h2>Your Cart</h2>
      {cart.items.map((item, index) => (
        <div key={index} className="cart-item">
          <div>
            <h4>{item.productId?.name || 'Product'}</h4>
            <p>Quantity: {item.quantity}</p>
          </div>
          <div className="price">
            ${(item.price * item.quantity).toFixed(2)}
          </div>
        </div>
      ))}
      <div className="cart-total">
        Total: ${cart.total?.toFixed(2) || '0.00'}
      </div>
      <button className="btn" style={{ marginTop: '1rem' }}>
        Proceed to Checkout
      </button>
    </div>
  );
};

export default Cart;