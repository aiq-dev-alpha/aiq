import React, { useState } from 'react';

interface SearchResult {
  id: string;
  title: string;
  description: string;
  category: string;
  relevance: number;
}

const results: SearchResult[] = [
  { id: '1', title: 'Getting Started Guide', description: 'Learn the basics of our platform', category: 'Documentation', relevance: 95 },
  { id: '2', title: 'API Reference', description: 'Complete API documentation', category: 'Technical', relevance: 88 },
  { id: '3', title: 'Best Practices', description: 'Tips and tricks for optimal usage', category: 'Guide', relevance: 82 },
  { id: '4', title: 'Troubleshooting', description: 'Common issues and solutions', category: 'Support', relevance: 75 }
];

export const SearchResultsScreen: React.FC = () => {
  const [query, setQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('All');

  const categories = ['All', ...Array.from(new Set(results.map(r => r.category)))];
  const filteredResults = results.filter(r =>
    (selectedCategory === 'All' || r.category === selectedCategory) &&
    (r.title.toLowerCase().includes(query.toLowerCase()) ||
     r.description.toLowerCase().includes(query.toLowerCase()))
  );

  return (
    <div style={{ minHeight: '100vh', backgroundColor: '#f9fafb', padding: '2rem', fontFamily: 'system-ui, sans-serif' }}>
      <div style={{ maxWidth: '800px', margin: '0 auto' }}>
        <div style={{ marginBottom: '2rem' }}>
          <input
            type="text"
            placeholder="Search..."
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            style={{
              width: '100%',
              padding: '1rem 1.5rem',
              border: '1px solid #d1d5db',
              borderRadius: '0.75rem',
              fontSize: '1.125rem',
              boxShadow: '0 2px 4px rgba(0,0,0,0.05)'
            }}
          />
        </div>

        <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.5rem', flexWrap: 'wrap' }}>
          {categories.map(cat => (
            <button
              key={cat}
              onClick={() => setSelectedCategory(cat)}
              style={{
                padding: '0.5rem 1rem',
                border: 'none',
                borderRadius: '0.5rem',
                backgroundColor: selectedCategory === cat ? '#3b82f6' : '#fff',
                color: selectedCategory === cat ? '#fff' : '#374151',
                fontSize: '0.875rem',
                fontWeight: 500,
                cursor: 'pointer',
                boxShadow: '0 1px 2px rgba(0,0,0,0.05)'
              }}
            >
              {cat}
            </button>
          ))}
        </div>

        <div style={{ marginBottom: '1rem', color: '#6b7280' }}>
          {filteredResults.length} results
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
          {filteredResults.map(result => (
            <div
              key={result.id}
              style={{
                backgroundColor: '#fff',
                borderRadius: '0.75rem',
                padding: '1.5rem',
                boxShadow: '0 1px 3px rgba(0,0,0,0.1)',
                cursor: 'pointer',
                transition: 'transform 0.2s'
              }}
              onMouseEnter={(e) => e.currentTarget.style.transform = 'translateY(-2px)'}
              onMouseLeave={(e) => e.currentTarget.style.transform = 'translateY(0)'}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem', marginBottom: '0.5rem' }}>
                <h3 style={{ fontSize: '1.25rem', fontWeight: 600, margin: 0 }}>{result.title}</h3>
                <span style={{
                  padding: '0.25rem 0.75rem',
                  borderRadius: '0.375rem',
                  backgroundColor: '#eff6ff',
                  color: '#3b82f6',
                  fontSize: '0.75rem',
                  fontWeight: 500
                }}>
                  {result.category}
                </span>
              </div>
              <p style={{ color: '#6b7280', marginBottom: '0.5rem' }}>{result.description}</p>
              <div style={{ fontSize: '0.875rem', color: '#9ca3af' }}>
                Relevance: {result.relevance}%
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
