import React, { useEffect, useRef, CSSProperties, ReactNode } from 'react';

interface ModalTheme {
  background: string;
  overlay: string;
  border: string;
  shadow: string;
}

interface ModalProps {
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
  background: '#1e293b',
  overlay: 'rgba(15, 23, 42, 0.75)',
  border: '#334155',
  shadow: 'rgba(0, 0, 0, 0.5)'
};

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title = 'Drawer Modal',
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
    sm: { width: '320px' },
    md: { width: '450px' },
    lg: { width: '600px' },
    xl: { width: '800px' },
    full: { width: '100vw' }
  };

  const overlayStyle: CSSProperties = {
    position: 'fixed',
    inset: 0,
    background: appliedTheme.overlay,
    backdropFilter: 'blur(4px)',
    display: 'flex',
    alignItems: 'stretch',
    justifyContent: 'flex-end',
    zIndex: 9999,
    animation: 'fadeIn 0.3s ease-out'
  };

  const modalStyle: CSSProperties = {
    ...sizeMap[size],
    background: appliedTheme.background,
    height: '100vh',
    boxShadow: `-8px 0 24px ${appliedTheme.shadow}`,
    display: 'flex',
    flexDirection: 'column',
    animation: 'slideInRight 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94)',
    position: 'relative',
    borderLeft: `3px solid ${appliedTheme.border}`
  };

  const headerStyle: CSSProperties = {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '28px 32px',
    borderBottom: `2px solid ${appliedTheme.border}`,
    background: `linear-gradient(180deg, ${appliedTheme.background} 0%, #0f172a 100%)`
  };

  const titleStyle: CSSProperties = {
    margin: 0,
    fontSize: '22px',
    fontWeight: 700,
    background: 'linear-gradient(135deg, #06b6d4 0%, #3b82f6 100%)',
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
    letterSpacing: '-0.3px'
  };

  const closeButtonStyle: CSSProperties = {
    background: 'rgba(6, 182, 212, 0.15)',
    border: '2px solid #06b6d4',
    borderRadius: '8px',
    width: '32px',
    height: '32px',
    fontSize: '18px',
    cursor: 'pointer',
    color: '#06b6d4',
    transition: 'all 0.3s ease',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center'
  };

  const contentStyle: CSSProperties = {
    padding: '32px',
    flex: 1,
    overflow: 'auto',
    fontSize: '15px',
    lineHeight: 1.6,
    color: '#cbd5e1'
  };

  const footerStyle: CSSProperties = {
    padding: '24px 32px',
    borderTop: `2px solid ${appliedTheme.border}`,
    display: 'flex',
    gap: '12px',
    justifyContent: 'flex-end',
    background: '#0f172a'
  };

  const buttonStyle: CSSProperties = {
    padding: '10px 24px',
    borderRadius: '8px',
    border: 'none',
    fontSize: '14px',
    fontWeight: 600,
    cursor: 'pointer',
    transition: 'all 0.3s ease'
  };

  const primaryButtonStyle: CSSProperties = {
    ...buttonStyle,
    background: 'linear-gradient(135deg, #06b6d4 0%, #3b82f6 100%)',
    color: '#fff',
    boxShadow: '0 4px 12px rgba(6, 182, 212, 0.3)'
  };

  const secondaryButtonStyle: CSSProperties = {
    ...buttonStyle,
    background: '#334155',
    color: '#cbd5e1',
    border: '1px solid #475569'
  };

  return (
    <>
      <style>{`
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes slideInRight {
          from { transform: translateX(100%); opacity: 0; }
          to { transform: translateX(0); opacity: 1; }
        }
        .modal-v2-close-btn:hover {
          background: rgba(6, 182, 212, 0.25);
          border-color: #22d3ee;
          color: #22d3ee;
          transform: scale(1.05);
        }
        .modal-v2-primary-btn:hover {
          transform: translateY(-2px);
          box-shadow: 0 6px 16px rgba(6, 182, 212, 0.5);
        }
        .modal-v2-secondary-btn:hover {
          background: #475569;
          transform: translateY(-2px);
        }
      `}</style>
      <div style={overlayStyle} onClick={closeOnOverlay ? onClose : undefined}>
        <div ref={modalRef} style={modalStyle} onClick={(e) => e.stopPropagation()} role="dialog" aria-modal="true" aria-labelledby="modal-title">
          <div style={headerStyle}>
            <h2 id="modal-title" style={titleStyle}>{title}</h2>
            {showCloseButton && (
              <button
                className="modal-v2-close-btn"
                style={closeButtonStyle}
                onClick={onClose}
                aria-label="Close modal"
              >
                ✕
              </button>
            )}
          </div>

          <div style={contentStyle}>{children}</div>

          <div style={footerStyle}>
            <button className="modal-v2-secondary-btn" style={secondaryButtonStyle} onClick={onClose}>
              Cancel
            </button>
            <button className="modal-v2-primary-btn" style={primaryButtonStyle} onClick={onClose}>
              Save Changes
            </button>
          </div>
        </div>
      </div>
    </>
  );
};

export default Modal;
