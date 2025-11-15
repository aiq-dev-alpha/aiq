import React, { useEffect, CSSProperties, ReactNode } from 'react';

interface ModalTheme {
  overlay: string;
  background: string;
  text: string;
  border: string;
  accent: string;
  shadow: string;
}

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  children: ReactNode;
  footer?: ReactNode;
  size?: 'small' | 'medium' | 'large' | 'full';
  closeOnOverlay?: boolean;
  showCloseButton?: boolean;
  theme?: Partial<ModalTheme>;
  position?: 'center' | 'top' | 'bottom';
}

const defaultTheme: ModalTheme = {
  overlay: 'rgba(0, 0, 0, 0.6)',
  background: '#ffffff',
  text: '#0f172a',
  border: '#e2e8f0',
  accent: '#3b82f6',
  shadow: 'rgba(0, 0, 0, 0.2)'
};

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title,
  children,
  footer,
  size = 'medium',
  closeOnOverlay = true,
  showCloseButton = true,
  theme = {},
  position = 'center'
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    return () => {
      document.body.style.overflow = '';
    };
  }, [isOpen]);

  if (!isOpen) return null;

  const sizeMap: Record<string, CSSProperties> = {
    small: { maxWidth: '400px', width: '90%' },
    medium: { maxWidth: '600px', width: '90%' },
    large: { maxWidth: '900px', width: '90%' },
    full: { maxWidth: '95vw', width: '95%', height: '95vh' }
  };

  const positionMap: Record<string, CSSProperties> = {
    center: { alignItems: 'center', justifyContent: 'center' },
    top: { alignItems: 'flex-start', justifyContent: 'center', paddingTop: '60px' },
    bottom: { alignItems: 'flex-end', justifyContent: 'center', paddingBottom: '60px' }
  };

  const overlayStyle: CSSProperties = {
    position: 'fixed',
    inset: 0,
    background: appliedTheme.overlay,
    backdropFilter: 'blur(4px)',
    display: 'flex',
    zIndex: 9999,
    animation: 'fadeIn 0.2s ease-out',
    ...positionMap[position]
  };

  const modalStyle: CSSProperties = {
    ...sizeMap[size],
    background: appliedTheme.background,
    borderRadius: '16px',
    boxShadow: `0 20px 60px ${appliedTheme.shadow}`,
    display: 'flex',
    flexDirection: 'column',
    maxHeight: position === 'center' ? '90vh' : undefined,
    animation: position === 'center' ? 'scaleIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1)' : 'slideUp 0.3s ease-out',
    border: `1px solid ${appliedTheme.border}20`
  };

  const headerStyle: CSSProperties = {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '24px 28px',
    borderBottom: `2px solid ${appliedTheme.border}`,
    color: appliedTheme.text
  };

  const titleStyle: CSSProperties = {
    margin: 0,
    fontSize: '20px',
    fontWeight: 700,
    color: appliedTheme.text,
    letterSpacing: '0.3px'
  };

  const closeButtonStyle: CSSProperties = {
    background: 'transparent',
    border: 'none',
    fontSize: '24px',
    cursor: 'pointer',
    padding: '4px 8px',
    borderRadius: '6px',
    color: appliedTheme.text,
    transition: 'all 0.2s ease',
    lineHeight: 1,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center'
  };

  const contentStyle: CSSProperties = {
    padding: '28px',
    flex: 1,
    overflow: 'auto',
    color: appliedTheme.text,
    fontSize: '15px',
    lineHeight: 1.6
  };

  const footerStyle: CSSProperties = {
    padding: '20px 28px',
    borderTop: `2px solid ${appliedTheme.border}`,
    display: 'flex',
    gap: '12px',
    justifyContent: 'flex-end'
  };

  return (
    <>
      <style>{`
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes scaleIn {
          from { opacity: 0; transform: scale(0.9); }
          to { opacity: 1; transform: scale(1); }
        }
        @keyframes slideUp {
          from { opacity: 0; transform: translateY(40px); }
          to { opacity: 1; transform: translateY(0); }
        }
        .modal-close-btn:hover {
          background: ${appliedTheme.border}40 !important;
          transform: rotate(90deg);
        }
      `}</style>
      <div style={overlayStyle} onClick={closeOnOverlay ? onClose : undefined}>
        <div style={modalStyle} onClick={(e) => e.stopPropagation()}>
          {(title || showCloseButton) && (
            <div style={headerStyle}>
              {title && <h2 style={titleStyle}>{title}</h2>}
              {showCloseButton && (
                <button
                  className="modal-close-btn"
                  style={closeButtonStyle}
                  onClick={onClose}
                  aria-label="Close modal"
                >
                  ✕
                </button>
              )}
            </div>
          )}

          <div style={contentStyle}>{children}</div>

          {footer && <div style={footerStyle}>{footer}</div>}
        </div>
      </div>
    </>
  );
};

export default Modal;
