import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import ProductList from './components/ProductList';
import Cart from './components/Cart';
import UserRegistration from './components/UserRegistration';
import { getProducts, getCart } from './services/api';
import './App.css';

function App() {
  const [products, setProducts] = useState([]);
  const [cart, setCart] = useState({ items: [], total: 0 });
  const [user, setUser] = useState(null);

  useEffect(() => {
    loadProducts();
    if (user) {
      loadCart();
    }
  }, [user]);

  const loadProducts = async () => {
    try {
      const data = await getProducts();
      setProducts(data);
    } catch (error) {
      console.error('Error loading products:', error);
    }
  };

  const loadCart = async () => {
    if (!user) return;
    try {
      const data = await getCart(user.id);
      setCart(data);
    } catch (error) {
      console.error('Error loading cart:', error);
    }
  };

  return (
    <Router>
      <div className="App">
        <header className="App-header">
          <nav>
            <Link to="/" className="logo">☕ Coffee Shop</Link>
            <div className="nav-links">
              <Link to="/">Products</Link>
              <Link to="/cart">Cart ({cart.items?.length || 0})</Link>
              {!user ? (
                <Link to="/register">Register</Link>
              ) : (
                <span>Welcome, {user.username}!</span>
              )}
            </div>
          </nav>
        </header>

        <main>
          <Routes>
            <Route 
              path="/" 
              element={
                <ProductList 
                  products={products} 
                  user={user}
                  onCartUpdate={loadCart}
                />
              } 
            />
            <Route 
              path="/cart" 
              element={<Cart cart={cart} onCartUpdate={loadCart} />} 
            />
            <Route 
              path="/register" 
              element={<UserRegistration onUserRegistered={setUser} />} 
            />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;