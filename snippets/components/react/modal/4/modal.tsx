import React from 'react';

export interface ModalTheme {
  overlayColor: string;
  backgroundColor: string;
  textColor: string;
  borderRadius: string;
  maxWidth: string;
}

export interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: React.ReactNode;
  footer?: React.ReactNode;
  theme?: Partial<ModalTheme>;
  size?: 'sm' | 'md' | 'lg' | 'xl' | 'full';
  closeOnOverlay?: boolean;
  children: React.ReactNode;
}

const defaultTheme: ModalTheme = {
  overlayColor: 'rgba(0, 0, 0, 0.5)',
  backgroundColor: '#ffffff',
  textColor: '#1f2937',
  borderRadius: '0.75rem',
  maxWidth: '42rem'
};

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title,
  footer,
  theme = {},
  size = 'md',
  closeOnOverlay = true,
  children
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const sizeMap = {
    sm: '24rem',
    md: '32rem',
    lg: '42rem',
    xl: '56rem',
    full: '90vw'
  };

  if (!isOpen) return null;

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
    borderRadius: appliedTheme.borderRadius,
    maxWidth: sizeMap[size],
    width: '100%',
    maxHeight: '90vh',
    overflow: 'hidden',
    display: 'flex',
    flexDirection: 'column',
    boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)'
  };

  const headerStyles: React.CSSProperties = {
    padding: '1.5rem',
    borderBottom: '1px solid #e5e7eb',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between'
  };

  const contentStyles: React.CSSProperties = {
    padding: '1.5rem',
    flex: 1,
    overflow: 'auto',
    color: appliedTheme.textColor
  };

  const footerStyles: React.CSSProperties = {
    padding: '1.5rem',
    borderTop: '1px solid #e5e7eb',
    display: 'flex',
    gap: '0.75rem',
    justifyContent: 'flex-end'
  };

  return (
    <div style={overlayStyles} onClick={closeOnOverlay ? onClose : undefined}>
      <div style={modalStyles} onClick={(e) => e.stopPropagation()}>
        {title && (
          <div style={headerStyles}>
            <h2 style={{ margin: 0, fontSize: '1.25rem', fontWeight: 700, color: appliedTheme.textColor }}>{title}</h2>
            <button onClick={onClose} style={{ background: 'none', border: 'none', fontSize: '1.5rem', cursor: 'pointer', padding: '0.25rem' }}>×</button>
          </div>
        )}
        <div style={contentStyles}>{children}</div>
        {footer && <div style={footerStyles}>{footer}</div>}
      </div>
    </div>
  );
};
