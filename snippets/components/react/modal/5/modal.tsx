import React from 'react';

export interface ModalTheme {
  backdrop: string;
  surface: string;
  text: string;
  border: string;
  shadow: string;
}

export interface ModalProps {
  open: boolean;
  onRequestClose: () => void;
  heading?: React.ReactNode;
  actions?: React.ReactNode;
  theme?: Partial<ModalTheme>;
  width?: 'narrow' | 'medium' | 'wide' | 'extra-wide';
  dismissible?: boolean;
  centered?: boolean;
  children: React.ReactNode;
}

const defaultTheme: ModalTheme = {
  backdrop: 'rgba(17, 24, 39, 0.6)',
  surface: '#ffffff',
  text: '#111827',
  border: '#e5e7eb',
  shadow: 'rgba(0, 0, 0, 0.25)'
};

export const Modal: React.FC<ModalProps> = ({
  open,
  onRequestClose,
  heading,
  actions,
  theme = {},
  width = 'medium',
  dismissible = true,
  centered = true,
  children
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const widthMap = {
    narrow: '28rem',
    medium: '36rem',
    wide: '48rem',
    'extra-wide': '64rem'
  };

  if (!open) return null;

  const backdropStyles: React.CSSProperties = {
    position: 'fixed',
    inset: 0,
    backgroundColor: appliedTheme.backdrop,
    display: 'flex',
    alignItems: centered ? 'center' : 'flex-start',
    justifyContent: 'center',
    zIndex: 1000,
    padding: '2rem',
    overflowY: 'auto'
  };

  const containerStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.surface,
    borderRadius: '0.875rem',
    maxWidth: widthMap[width],
    width: '100%',
    boxShadow: `0 25px 50px -12px ${appliedTheme.shadow}`,
    margin: centered ? 'auto' : '0 auto'
  };

  return (
    <div style={backdropStyles} onClick={dismissible ? onRequestClose : undefined}>
      <div style={containerStyles} onClick={(e) => e.stopPropagation()}>
        {heading && (
          <div style={{ padding: '1.75rem', borderBottom: `1px solid ${appliedTheme.border}` }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
              <h3 style={{ margin: 0, fontSize: '1.375rem', fontWeight: 700, color: appliedTheme.text }}>{heading}</h3>
              {dismissible && (
                <button onClick={onRequestClose} style={{ background: 'none', border: 'none', fontSize: '1.75rem', cursor: 'pointer', color: '#6b7280', lineHeight: 1 }}>×</button>
              )}
            </div>
          </div>
        )}
        <div style={{ padding: '1.75rem', color: appliedTheme.text }}>{children}</div>
        {actions && (
          <div style={{ padding: '1.75rem', borderTop: `1px solid ${appliedTheme.border}`, display: 'flex', gap: '1rem', justifyContent: 'flex-end' }}>
            {actions}
          </div>
        )}
      </div>
    </div>
  );
};
