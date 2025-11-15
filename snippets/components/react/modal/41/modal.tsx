import React, { CSSProperties, ReactNode, useEffect } from 'react';

interface ModalTheme {
  overlay: string;
  background: string;
  text: string;
  border: string;
  shadow: string;
}

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  size?: 'sm' | 'md' | 'lg' | 'xl' | 'full';
  position?: 'center' | 'top' | 'bottom';
  animation?: 'fade' | 'slide' | 'zoom' | 'flip';
  title?: string;
  subtitle?: string;
  closeButton?: boolean;
  closeOnOverlay?: boolean;
  closeOnEscape?: boolean;
  header?: ReactNode;
  footer?: ReactNode;
  theme?: Partial<ModalTheme>;
  className?: string;
  children: ReactNode;
}

const defaultTheme: ModalTheme = {
  overlay: 'rgba(0, 0, 0, 0.6)',
  background: '#ffffff',
  text: '#111827',
  border: '#e5e7eb',
  shadow: 'rgba(0, 0, 0, 0.3)'
};

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  size = 'md',
  position = 'center',
  animation = 'slide',
  title,
  subtitle,
  closeButton = true,
  closeOnOverlay = true,
  closeOnEscape = true,
  header,
  footer,
  theme = {},
  className = '',
  children
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  useEffect(() => {
    const handleEscape = (e: KeyboardEvent) => {
      if (closeOnEscape && e.key === 'Escape' && isOpen) {
        onClose();
      }
    };

    if (isOpen) {
      document.addEventListener('keydown', handleEscape);
      document.body.style.overflow = 'hidden';
    }

    return () => {
      document.removeEventListener('keydown', handleEscape);
      document.body.style.overflow = '';
    };
  }, [isOpen, closeOnEscape, onClose]);

  if (!isOpen) return null;

  const sizeMap: Record<string, string> = {
    sm: '400px',
    md: '600px',
    lg: '800px',
    xl: '1200px',
    full: 'calc(100vw - 32px)'
  };

  const positionMap: Record<string, CSSProperties> = {
    center: { alignItems: 'center', justifyContent: 'center' },
    top: { alignItems: 'flex-start', justifyContent: 'center', paddingTop: '60px' },
    bottom: { alignItems: 'flex-end', justifyContent: 'center', paddingBottom: '60px' }
  };

  const animationMap: Record<string, string> = {
    fade: 'modalFade',
    slide: 'modalSlide',
    zoom: 'modalZoom',
    flip: 'modalFlip'
  };

  const overlayStyle: CSSProperties = {
    position: 'fixed',
    inset: 0,
    backgroundColor: appliedTheme.overlay,
    backdropFilter: 'blur(4px)',
    display: 'flex',
    ...positionMap[position],
    zIndex: 9999,
    padding: '16px',
    animation: 'overlayFade 0.3s ease'
  };

  const containerStyle: CSSProperties = {
    position: 'relative',
    width: '100%',
    maxWidth: sizeMap[size],
    maxHeight: '90vh',
    backgroundColor: appliedTheme.background,
    color: appliedTheme.text,
    borderRadius: '16px',
    boxShadow: `0 20px 25px ${appliedTheme.shadow}`,
    display: 'flex',
    flexDirection: 'column',
    overflow: 'hidden',
    animation: `${animationMap[animation]} 0.4s cubic-bezier(0.34, 1.56, 0.64, 1)`,
    fontFamily: 'system-ui, -apple-system, sans-serif'
  };

  const headerStyle: CSSProperties = {
    padding: '24px',
    borderBottom: `1px solid ${appliedTheme.border}`,
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    gap: '16px'
  };

  const titleContainerStyle: CSSProperties = {
    flex: 1
  };

  const titleStyle: CSSProperties = {
    margin: 0,
    fontSize: '1.5rem',
    fontWeight: 700,
    lineHeight: 1.3
  };

  const subtitleStyle: CSSProperties = {
    margin: '8px 0 0',
    fontSize: '0.875rem',
    opacity: 0.7
  };

  const closeButtonStyle: CSSProperties = {
    background: 'none',
    border: 'none',
    fontSize: '24px',
    cursor: 'pointer',
    padding: '8px',
    borderRadius: '6px',
    lineHeight: 1,
    transition: 'background 0.2s',
    color: appliedTheme.text
  };

  const bodyStyle: CSSProperties = {
    flex: 1,
    padding: '24px',
    overflowY: 'auto'
  };

  const footerStyle: CSSProperties = {
    padding: '24px',
    borderTop: `1px solid ${appliedTheme.border}`,
    display: 'flex',
    gap: '12px',
    justifyContent: 'flex-end'
  };

  return (
    <>
      <style>{`
        @keyframes overlayFade {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes modalFade {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes modalSlide {
          from { transform: translateY(40px); opacity: 0; }
          to { transform: translateY(0); opacity: 1; }
        }
        @keyframes modalZoom {
          from { transform: scale(0.9); opacity: 0; }
          to { transform: scale(1); opacity: 1; }
        }
        @keyframes modalFlip {
          from { transform: rotateX(-20deg); opacity: 0; }
          to { transform: rotateX(0); opacity: 1; }
        }
      `}</style>
      <div
        style={overlayStyle}
        onClick={closeOnOverlay ? onClose : undefined}>
        <div
          style={containerStyle}
          className={className}
          onClick={(e) => e.stopPropagation()}>
          {(header || title || closeButton) && (
            <div style={headerStyle}>
              <div style={titleContainerStyle}>
                {title && <h2 style={titleStyle}>{title}</h2>}
                {subtitle && <p style={subtitleStyle}>{subtitle}</p>}
                {header}
              </div>
              {closeButton && (
                <button
                  style={closeButtonStyle}
                  onClick={onClose}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.background = 'rgba(0, 0, 0, 0.05)';
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.background = 'none';
                  }}
                  aria-label="Close">
                  ×
                </button>
              )}
            </div>
          )}
          <div style={bodyStyle}>{children}</div>
          {footer && <div style={footerStyle}>{footer}</div>}
        </div>
      </div>
    </>
  );
};
