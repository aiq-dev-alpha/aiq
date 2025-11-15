import React, { useEffect, useRef, CSSProperties, ReactNode } from 'react';

export interface ModalTheme {
  background: string;
  overlay: string;
  border: string;
  shadow: string;
}

export interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  children: ReactNode;
  size?: 'sm' | 'md' | 'lg' | 'xl' | 'full';
  variant?: 'default' | 'centered' | 'drawer' | 'fullscreen' | 'bottom-sheet';
  closeOnOverlay?: boolean;
  closeOnEsc?: boolean;
  showCloseButton?: boolean;
  theme?: Partial<ModalTheme>;
}

const defaultTheme: ModalTheme = {
  background: '#10b981',
  overlay: 'rgba(16, 185, 129, 0.15)',
  border: '#34d399',
  shadow: 'rgba(16, 185, 129, 0.3)'
};

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title = 'Emerald Slide Modal',
  children,
  size = 'md',
  variant = 'drawer',
  closeOnOverlay = true,
  closeOnEsc = true,
  showCloseButton = true,
  theme = {}
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };
  const modalRef = useRef<HTMLDivElement>(null);

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

  useEffect(() => {
    const handleEsc = (e: KeyboardEvent) => {
      if (closeOnEsc && e.key === 'Escape') {
        onClose();
      }
    };
    if (isOpen) {
      document.addEventListener('keydown', handleEsc);
    }
    return () => document.removeEventListener('keydown', handleEsc);
  }, [isOpen, closeOnEsc, onClose]);

  useEffect(() => {
    if (!isOpen || !modalRef.current) return;
    const focusableElements = modalRef.current.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );
    const firstElement = focusableElements[0] as HTMLElement;
    const lastElement = focusableElements[focusableElements.length - 1] as HTMLElement;
    const handleTab = (e: KeyboardEvent) => {
      if (e.key !== 'Tab') return;
      if (e.shiftKey) {
        if (document.activeElement === firstElement) {
          lastElement?.focus();
          e.preventDefault();
        }
      } else {
        if (document.activeElement === lastElement) {
          firstElement?.focus();
          e.preventDefault();
        }
      }
    };
    document.addEventListener('keydown', handleTab);
    return () => document.removeEventListener('keydown', handleTab);
  }, [isOpen]);

  if (!isOpen) return null;

  const sizeMap: Record<string, CSSProperties> = {
    sm: { width: '360px' },
    md: { width: '500px' },
    lg: { width: '680px' },
    xl: { width: '860px' },
    full: { width: '100vw' }
  };

  const overlayStyle: CSSProperties = {
    position: 'fixed',
    inset: 0,
    background: appliedTheme.overlay,
    backdropFilter: 'blur(6px)',
    display: 'flex',
    alignItems: 'stretch',
    justifyContent: 'flex-start',
    zIndex: 9999,
    animation: 'fadeIn 0.3s ease-out'
  };

  const modalStyle: CSSProperties = {
    ...sizeMap[size],
    background: '#fff',
    height: '100vh',
    boxShadow: `8px 0 30px ${appliedTheme.shadow}`,
    display: 'flex',
    flexDirection: 'column',
    animation: 'slideInLeft 0.45s cubic-bezier(0.25, 0.46, 0.45, 0.94)',
    borderRight: `4px solid ${appliedTheme.border}`
  };

  const headerStyle: CSSProperties = {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '26px 30px',
    borderBottom: `2px solid ${appliedTheme.border}`,
    background: `linear-gradient(180deg, ${appliedTheme.background}15 0%, transparent 100%)`
  };

  const titleStyle: CSSProperties = {
    margin: 0,
    fontSize: '23px',
    fontWeight: 700,
    color: appliedTheme.background
  };

  const closeButtonStyle: CSSProperties = {
    background: appliedTheme.background,
    border: 'none',
    borderRadius: '10px',
    padding: '8px 16px',
    fontSize: '16px',
    cursor: 'pointer',
    color: '#fff',
    transition: 'all 0.3s ease',
    fontWeight: 600
  };

  const contentStyle: CSSProperties = {
    padding: '30px',
    flex: 1,
    overflow: 'auto',
    fontSize: '15px',
    lineHeight: 1.6,
    color: '#374151'
  };

  const footerStyle: CSSProperties = {
    padding: '22px 30px',
    borderTop: `2px solid ${appliedTheme.border}`,
    display: 'flex',
    gap: '12px',
    justifyContent: 'flex-end',
    background: '#f0fdf4'
  };

  const buttonStyle: CSSProperties = {
    padding: '11px 26px',
    borderRadius: '9px',
    border: 'none',
    fontSize: '14px',
    fontWeight: 600,
    cursor: 'pointer',
    transition: 'all 0.3s ease'
  };

  const primaryButtonStyle: CSSProperties = {
    ...buttonStyle,
    background: appliedTheme.background,
    color: '#fff'
  };

  const secondaryButtonStyle: CSSProperties = {
    ...buttonStyle,
    background: '#d1fae5',
    color: appliedTheme.background
  };

  return (
    <>
      <style>{`
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes slideInLeft {
          from { transform: translateX(-100%); opacity: 0; }
          to { transform: translateX(0); opacity: 1; }
        }
        .modal-v7-close-btn:hover {
          background: #059669;
          transform: scale(1.05);
        }
        .modal-v7-primary-btn:hover {
          background: #059669;
          transform: translateY(-2px);
        }
        .modal-v7-secondary-btn:hover {
          background: #a7f3d0;
        }
      `}</style>
      <div style={overlayStyle} onClick={closeOnOverlay ? onClose : undefined}>
        <div ref={modalRef} style={modalStyle} onClick={(e) => e.stopPropagation()} role="dialog" aria-modal="true" aria-labelledby="modal-title">
          <div style={headerStyle}>
            <h2 id="modal-title" style={titleStyle}>{title}</h2>
            {showCloseButton && (
              <button
                className="modal-v7-close-btn"
                style={closeButtonStyle}
                onClick={onClose}
                aria-label="Close modal"
              >
                Close
              </button>
            )}
          </div>
          <div style={contentStyle}>{children}</div>
          <div style={footerStyle}>
            <button className="modal-v7-secondary-btn" style={secondaryButtonStyle} onClick={onClose}>
              Cancel
            </button>
            <button className="modal-v7-primary-btn" style={primaryButtonStyle} onClick={onClose}>
              Save
            </button>
          </div>
        </div>
      </div>
    </>
  );
};
