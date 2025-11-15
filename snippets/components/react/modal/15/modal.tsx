import React from 'react';

export interface ModalTheme {
  overlayColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
}

export interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  footer?: React.ReactNode;
  theme?: Partial<ModalTheme>;
  size?: 'sm' | 'md' | 'lg' | 'xl';
  children: React.ReactNode;
}

const defaultTheme: ModalTheme = {
  overlayColor: 'rgba(0, 0, 0, 0.5)',
  backgroundColor: '#ffffff',
  textColor: '#111827',
  borderColor: '#e5e7eb'
};

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title,
  footer,
  theme = {},
  size = 'md',
  children
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  if (!isOpen) return null;

  const sizeMap = {
    sm: '28rem',
    md: '36rem',
    lg: '48rem',
    xl: '64rem'
  };

  const overlayStyles: React.CSSProperties = {
    position: 'fixed',
    inset: 0,
    backgroundColor: appliedTheme.overlayColor,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 1000,
    padding: '1rem'
  };

  const modalStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.backgroundColor,
    borderRadius: '0.75rem',
    maxWidth: sizeMap[size],
    width: '100%',
    maxHeight: '90vh',
    display: 'flex',
    flexDirection: 'column',
    boxShadow: '0 20px 25px rgba(0, 0, 0, 0.1)'
  };

  return (
    <div style={overlayStyles} onClick={onClose}>
      <div style={modalStyles} onClick={(e) => e.stopPropagation()}>
        {title && (
          <div style={{ padding: '1.5rem', borderBottom: `1px solid ${appliedTheme.borderColor}`, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <h2 style={{ margin: 0, fontSize: '1.25rem', fontWeight: 700, color: appliedTheme.textColor }}>{title}</h2>
            <button onClick={onClose} style={{ background: 'none', border: 'none', fontSize: '1.5rem', cursor: 'pointer' }}>×</button>
          </div>
        )}
        <div style={{ padding: '1.5rem', flex: 1, overflow: 'auto', color: appliedTheme.textColor }}>{children}</div>
        {footer && <div style={{ padding: '1.5rem', borderTop: `1px solid ${appliedTheme.borderColor}` }}>{footer}</div>}
      </div>
    </div>
  );
};
