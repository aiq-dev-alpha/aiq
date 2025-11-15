import React from 'react';

export interface ModalTheme {
  overlayBg: string;
  surfaceBg: string;
  textColor: string;
  accentColor: string;
  borderColor: string;
}

export interface ModalProps {
  visible: boolean;
  onClose: () => void;
  title?: string;
  footer?: React.ReactNode;
  theme?: Partial<ModalTheme>;
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl' | 'full';
  closeOnClickOutside?: boolean;
  showCloseButton?: boolean;
  children: React.ReactNode;
}

const defaultTheme: ModalTheme = {
  overlayBg: 'rgba(0, 0, 0, 0.5)',
  surfaceBg: '#ffffff',
  textColor: '#1f2937',
  accentColor: '#3b82f6',
  borderColor: '#e5e7eb'
};

export const Modal: React.FC<ModalProps> = ({
  visible,
  onClose,
  title,
  footer,
  theme = {},
  size = 'md',
  closeOnClickOutside = true,
  showCloseButton = true,
  children
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  if (!visible) return null;

  const sizeMap = {
    xs: '20rem',
    sm: '28rem',
    md: '36rem',
    lg: '48rem',
    xl: '64rem',
    full: '95vw'
  };

  const overlayStyles: React.CSSProperties = {
    position: 'fixed',
    inset: 0,
    backgroundColor: appliedTheme.overlayBg,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 1000,
    padding: '1.5rem',
    animation: 'fadeIn 0.2s ease'
  };

  const modalStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.surfaceBg,
    borderRadius: '0.875rem',
    maxWidth: sizeMap[size],
    width: '100%',
    maxHeight: '90vh',
    display: 'flex',
    flexDirection: 'column',
    boxShadow: '0 25px 50px rgba(0, 0, 0, 0.25)',
    animation: 'slideUp 0.3s ease'
  };

  return (
    <div
      style={overlayStyles}
      onClick={closeOnClickOutside ? onClose : undefined}
    >
      <div
        style={modalStyles}
        onClick={(e) => e.stopPropagation()}
      >
        {title && (
          <div style={{
            padding: '1.5rem',
            borderBottom: `1px solid ${appliedTheme.borderColor}`,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between'
          }}>
            <h2 style={{ margin: 0, fontSize: '1.5rem', fontWeight: 700, color: appliedTheme.textColor }}>{title}</h2>
            {showCloseButton && (
              <button
                onClick={onClose}
                style={{
                  background: 'none',
                  border: 'none',
                  fontSize: '1.75rem',
                  cursor: 'pointer',
                  color: '#9ca3af',
                  padding: '0',
                  lineHeight: 1
                }}
              >
                ×
              </button>
            )}
          </div>
        )}
        <div style={{
          padding: '1.5rem',
          flex: 1,
          overflowY: 'auto',
          color: appliedTheme.textColor
        }}>
          {children}
        </div>
        {footer && (
          <div style={{
            padding: '1.5rem',
            borderTop: `1px solid ${appliedTheme.borderColor}`,
            display: 'flex',
            gap: '0.75rem',
            justifyContent: 'flex-end'
          }}>
            {footer}
          </div>
        )}
      </div>
    </div>
  );
};
