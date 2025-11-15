import React, { useState } from 'react';

interface Product {
  id: string;
  name: string;
  price: number;
  image: string;
  category: string;
  rating: number;
}

interface Theme {
  backgroundColor: string;
  cardBackground: string;
  primaryColor: string;
  textPrimary: string;
  textSecondary: string;
}

const defaultTheme: Theme = {
  backgroundColor: '#f9fafb',
  cardBackground: '#ffffff',
  primaryColor: '#3b82f6',
  textPrimary: '#111827',
  textSecondary: '#6b7280'
};

const products: Product[] = [
  { id: '1', name: 'Wireless Headphones', price: 99.99, image: '🎧', category: 'Audio', rating: 4.5 },
  { id: '2', name: 'Smart Watch', price: 199.99, image: '⌚', category: 'Wearables', rating: 4.8 },
  { id: '3', name: 'Laptop Stand', price: 49.99, image: '💻', category: 'Accessories', rating: 4.3 },
  { id: '4', name: 'Bluetooth Speaker', price: 79.99, image: '🔊', category: 'Audio', rating: 4.6 }
];

export const EcommerceScreen: React.FC<{ theme?: Partial<Theme> }> = ({ theme = {} }) => {
  const [selectedCategory, setSelectedCategory] = useState('All');
  const appliedTheme = { ...defaultTheme, ...theme };

  const categories = ['All', ...Array.from(new Set(products.map(p => p.category)))];
  const filteredProducts = selectedCategory === 'All'
    ? products
    : products.filter(p => p.category === selectedCategory);

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.backgroundColor,
    padding: '2rem'
  };

  const gridStyles: React.CSSProperties = {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(250px, 1fr))',
    gap: '1.5rem',
    marginTop: '1.5rem'
  };

  const cardStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.cardBackground,
    borderRadius: '0.75rem',
    overflow: 'hidden',
    boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
    cursor: 'pointer',
    transition: 'transform 0.2s'
  };

  return (
    <div style={containerStyles}>
      <h1 style={{ fontSize: '2rem', fontWeight: 700, marginBottom: '1rem' }}>Shop</h1>

      <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.5rem' }}>
        {categories.map(cat => (
          <button
            key={cat}
            onClick={() => setSelectedCategory(cat)}
            style={{
              padding: '0.5rem 1rem',
              borderRadius: '0.5rem',
              border: 'none',
              backgroundColor: selectedCategory === cat ? appliedTheme.primaryColor : appliedTheme.cardBackground,
              color: selectedCategory === cat ? '#fff' : appliedTheme.textPrimary,
              cursor: 'pointer'
            }}
          >
            {cat}
          </button>
        ))}
      </div>

      <div style={gridStyles}>
        {filteredProducts.map(product => (
          <div key={product.id} style={cardStyles}>
            <div style={{ fontSize: '6rem', textAlign: 'center', padding: '2rem' }}>{product.image}</div>
            <div style={{ padding: '1rem' }}>
              <h3 style={{ fontSize: '1.125rem', fontWeight: 600, marginBottom: '0.5rem' }}>{product.name}</h3>
              <p style={{ color: appliedTheme.textSecondary, fontSize: '0.875rem', marginBottom: '0.5rem' }}>
                {product.category}
              </p>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <span style={{ fontSize: '1.25rem', fontWeight: 700, color: appliedTheme.primaryColor }}>
                  ${product.price}
                </span>
                <span style={{ fontSize: '0.875rem' }}>⭐ {product.rating}</span>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
