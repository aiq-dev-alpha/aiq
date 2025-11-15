import React, { useState } from 'react';

export interface ComponentProps {
  totalPages?: number;
  currentPage?: number;
  onPageChange?: (page: number) => void;
  theme?: { primary?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  totalPages = 10,
  currentPage: controlledPage,
  onPageChange,
  theme = {},
  className = ''
}) => {
  const [internalPage, setInternalPage] = useState(1);
  const currentPage = controlledPage || internalPage;
  const primary = theme.primary || '#ef4444';
  
  const handlePageChange = (page: number) => {
    if (page < 1 || page > totalPages) return;
    if (!controlledPage) setInternalPage(page);
    onPageChange?.(page);
  };
  
  return (
    <div
      className={className}
      style={{
        display: 'flex',
        gap: '2px',
        alignItems: 'center',
        flexWrap: 'wrap'
      }}
    >
      <button
        onClick={() => handlePageChange(currentPage - 1)}
        disabled={currentPage === 1}
        style={{
          padding: '22px 36px',
          backgroundColor: '#fff',
          border: `1px solid ${primary}`,
          borderRadius: '21px',
          cursor: currentPage === 1 ? 'not-allowed' : 'pointer',
          opacity: currentPage === 1 ? 0.5 : 1,
          fontWeight: '300'
        }}
      >
        «
      </button>
      
      {Array.from({ length: totalPages }, (_, i) => i + 1)
        .filter(page => 
          page === 1 || 
          page === totalPages || 
          Math.abs(page - currentPage) <= 1
        )
        .map(page => (
          <button
            key={page}
            onClick={() => handlePageChange(page)}
            style={{
              padding: '22px 36px',
              backgroundColor: page === currentPage ? primary : '#fff',
              color: page === currentPage ? '#fff' : '#374151',
              border: `1px solid ${primary}`,
              borderRadius: '21px',
              cursor: 'pointer',
              fontWeight: '300',
              minWidth: '44px'
            }}
          >
            {page}
          </button>
        ))}
      
      <button
        onClick={() => handlePageChange(currentPage + 1)}
        disabled={currentPage === totalPages}
        style={{
          padding: '22px 36px',
          backgroundColor: '#fff',
          border: `1px solid ${primary}`,
          borderRadius: '21px',
          cursor: currentPage === totalPages ? 'not-allowed' : 'pointer',
          opacity: currentPage === totalPages ? 0.5 : 1,
          fontWeight: '300'
        }}
      >
        »
      </button>
    </div>
  );
};