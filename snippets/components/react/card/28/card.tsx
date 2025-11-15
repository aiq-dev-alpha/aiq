// Variant 28: Comparison card (two column)
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'scale(1)' : 'scale(0.95)', transition: 'all 300ms ease', backgroundColor: theme.background || '#ffffff', borderRadius: '16px', overflow: 'hidden', boxShadow: isHovered ? '0 16px 32px rgba(0,0,0,0.12)' : '0 6px 16px rgba(0,0,0,0.08)', cursor: 'pointer', width: '420px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ padding: '24px', borderBottom: '1px solid #e5e7eb' }}>
        <h3 style={{ fontSize: '20px', fontWeight: 'bold', color: theme.text || '#111827' }}>Plan Comparison</h3>
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr' }}>
        {[
          { name: 'Basic', price: '$9', features: ['5 Projects', 'Basic Support', '1 GB Storage'] },
          { name: 'Pro', price: '$29', features: ['Unlimited Projects', 'Priority Support', '100 GB Storage'], highlight: true }
        ].map((plan, i) => (
          <div key={i} style={{ padding: '24px', backgroundColor: plan.highlight ? `${theme.primary || '#3b82f6'}08` : 'transparent', borderLeft: i === 1 ? '1px solid #e5e7eb' : 'none' }}>
            <div style={{ fontSize: '16px', fontWeight: '700', color: theme.text || '#111827', marginBottom: '8px' }}>{plan.name}</div>
            <div style={{ fontSize: '32px', fontWeight: 'bold', color: theme.primary || '#3b82f6', marginBottom: '16px' }}>{plan.price}<span style={{ fontSize: '14px', color: '#9ca3af' }}>/mo</span></div>
            <ul style={{ listStyle: 'none', padding: 0, margin: 0, fontSize: '13px', color: '#6b7280', lineHeight: '2' }}>
              {plan.features.map((f, j) => (
                <li key={j} style={{ display: 'flex', gap: '8px' }}><span>✓</span><span>{f}</span></li>
              ))}
            </ul>
          </div>
        ))}
      </div>
    </div>
  );
};
