// Variant 9: Card with expandable accordion content
import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [expandedSection, setExpandedSection] = useState<number | null>(null);

  useEffect(() => { setIsVisible(true); }, []);

  const sections = [
    { title: 'Features', icon: '⚡', content: 'Advanced features including real-time collaboration, cloud sync, and AI-powered insights.' },
    { title: 'Pricing', icon: '💰', content: 'Flexible pricing plans starting at $9/month with a 14-day free trial. No credit card required.' },
    { title: 'Support', icon: '🛟', content: '24/7 customer support via email, chat, and phone. Average response time under 2 hours.' },
  ];

  return (
    <div
      className={className}
      style={{
        opacity: isVisible ? 1 : 0,
        transform: isVisible ? 'translateY(0)' : 'translateY(20px)',
        transition: 'all 350ms cubic-bezier(0.4, 0, 0.2, 1)',
        backgroundColor: theme.background || '#ffffff',
        borderRadius: '16px',
        boxShadow: isHovered ? '0 12px 28px rgba(0,0,0,0.15)' : '0 4px 12px rgba(0,0,0,0.08)',
        cursor: 'pointer',
        width: '360px',
        overflow: 'hidden',
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{ padding: '24px', borderBottom: '1px solid #e5e7eb' }}>
        <h3 style={{ fontSize: '22px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '8px' }}>
          Product Information
        </h3>
        <p style={{ fontSize: '14px', color: '#6b7280' }}>Click sections to expand</p>
      </div>
      {sections.map((section, index) => {
        const isExpanded = expandedSection === index;
        return (
          <div key={index} style={{ borderBottom: '1px solid #e5e7eb', transition: 'all 250ms ease' }}>
            <div
              style={{
                padding: '18px 24px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                cursor: 'pointer',
                backgroundColor: isExpanded ? '#f9fafb' : 'transparent',
                transition: 'background-color 200ms ease',
              }}
              onClick={(e) => { e.stopPropagation(); setExpandedSection(isExpanded ? null : index); }}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                <span style={{ fontSize: '20px' }}>{section.icon}</span>
                <span style={{ fontSize: '16px', fontWeight: '600', color: theme.text || '#111827' }}>{section.title}</span>
              </div>
              <span style={{ transition: 'transform 250ms ease', transform: isExpanded ? 'rotate(180deg)' : 'rotate(0deg)', fontSize: '12px' }}>▼</span>
            </div>
            <div style={{
              maxHeight: isExpanded ? '200px' : '0',
              overflow: 'hidden',
              transition: 'max-height 300ms cubic-bezier(0.4, 0, 0.2, 1)',
            }}>
              <div style={{ padding: '0 24px 18px 24px', fontSize: '14px', color: '#6b7280', lineHeight: '1.6' }}>
                {section.content}
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};
