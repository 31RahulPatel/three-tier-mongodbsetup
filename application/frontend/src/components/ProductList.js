import React from 'react';
import { addToCart } from '../services/api';

const ProductList = ({ products, user, onCartUpdate }) => {
  const handleAddToCart = async (productId) => {
    if (!user) {
      alert('Please register first to add items to cart');
      return;
    }

    try {
      await addToCart(user.id, productId, 1);
      onCartUpdate();
      alert('Item added to cart!');
    } catch (error) {
      console.error('Error adding to cart:', error);
      alert('Error adding item to cart');
    }
  };

  return (
    <div>
      <h2>Our Coffee Menu</h2>
      <div className="products-grid">
        {products.map(product => (
          <div key={product._id} className="product-card">
            <h3>{product.name}</h3>
            <p>{product.description}</p>
            <div className="price">${product.price.toFixed(2)}</div>
            <button 
              className="btn"
              onClick={() => handleAddToCart(product._id)}
              disabled={!user}
            >
              {!user ? 'Register to Order' : 'Add to Cart'}
            </button>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ProductList;