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
  background: '#ffffff',
  overlay: 'rgba(0, 0, 0, 0.6)',
  border: '#e2e8f0',
  shadow: 'rgba(0, 0, 0, 0.25)'
};

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title = 'Modal Title',
  children,
  size = 'md',
  variant = 'default',
  closeOnOverlay = true,
  closeOnEsc = true,
  showCloseButton = true,
  theme = {}
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };
  const modalRef = useRef<HTMLDivElement>(null);
  const firstFocusableRef = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
      firstFocusableRef.current?.focus();
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
    sm: { maxWidth: '400px', width: '90%' },
    md: { maxWidth: '600px', width: '90%' },
    lg: { maxWidth: '900px', width: '90%' },
    xl: { maxWidth: '1200px', width: '95%' },
    full: { maxWidth: '100vw', width: '100%', height: '100vh', borderRadius: 0 }
  };

  const variantStyles: Record<string, CSSProperties> = {
    default: { transform: 'none' },
    centered: { margin: 'auto' },
    drawer: { marginLeft: 'auto', height: '100vh', borderRadius: '0' },
    fullscreen: { width: '100vw', height: '100vh', borderRadius: '0', maxWidth: '100vw' },
    'bottom-sheet': { marginTop: 'auto', borderRadius: '24px 24px 0 0', maxHeight: '85vh' }
  };

  const overlayStyle: CSSProperties = {
    position: 'fixed',
    inset: 0,
    background: appliedTheme.overlay,
    backdropFilter: 'blur(8px)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 9999,
    animation: 'fadeIn 0.3s ease-out'
  };

  const modalStyle: CSSProperties = {
    ...sizeMap[size],
    ...variantStyles[variant],
    background: appliedTheme.background,
    borderRadius: '20px',
    boxShadow: `0 25px 50px -12px ${appliedTheme.shadow}`,
    display: 'flex',
    flexDirection: 'column',
    maxHeight: variant === 'bottom-sheet' ? '85vh' : '90vh',
    animation: 'bounceIn 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55)',
    border: `1px solid ${appliedTheme.border}`,
    position: 'relative'
  };

  const headerStyle: CSSProperties = {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '24px 32px',
    borderBottom: `2px solid ${appliedTheme.border}`,
    background: `linear-gradient(135deg, ${appliedTheme.background} 0%, #f8fafc 100%)`
  };

  const titleStyle: CSSProperties = {
    margin: 0,
    fontSize: '24px',
    fontWeight: 800,
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
    letterSpacing: '-0.5px'
  };

  const closeButtonStyle: CSSProperties = {
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    border: 'none',
    borderRadius: '50%',
    width: '36px',
    height: '36px',
    fontSize: '20px',
    cursor: 'pointer',
    color: '#fff',
    transition: 'all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    boxShadow: '0 4px 12px rgba(102, 126, 234, 0.4)'
  };

  const contentStyle: CSSProperties = {
    padding: '32px',
    flex: 1,
    overflow: 'auto',
    fontSize: '16px',
    lineHeight: 1.7,
    color: '#334155'
  };

  const footerStyle: CSSProperties = {
    padding: '20px 32px',
    borderTop: `2px solid ${appliedTheme.border}`,
    display: 'flex',
    gap: '12px',
    justifyContent: 'flex-end',
    background: '#f8fafc'
  };

  const buttonStyle: CSSProperties = {
    padding: '12px 28px',
    borderRadius: '12px',
    border: 'none',
    fontSize: '15px',
    fontWeight: 600,
    cursor: 'pointer',
    transition: 'all 0.3s ease'
  };

  const primaryButtonStyle: CSSProperties = {
    ...buttonStyle,
    background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    color: '#fff',
    boxShadow: '0 4px 12px rgba(102, 126, 234, 0.4)'
  };

  const secondaryButtonStyle: CSSProperties = {
    ...buttonStyle,
    background: '#e2e8f0',
    color: '#475569'
  };

  return (
    <>
      <style>{`
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes bounceIn {
          0% { opacity: 0; transform: scale(0.3) rotate(-10deg); }
          50% { opacity: 1; transform: scale(1.05) rotate(2deg); }
          70% { transform: scale(0.9) rotate(-1deg); }
          100% { transform: scale(1) rotate(0deg); }
        }
        .modal-v1-close-btn:hover {
          transform: scale(1.15) rotate(90deg);
          box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        }
        .modal-v1-primary-btn:hover {
          transform: translateY(-2px);
          box-shadow: 0 8px 20px rgba(102, 126, 234, 0.6);
        }
        .modal-v1-secondary-btn:hover {
          background: #cbd5e1;
          transform: translateY(-2px);
        }
      `}</style>
      <div style={overlayStyle} onClick={closeOnOverlay ? onClose : undefined}>
        <div ref={modalRef} style={modalStyle} onClick={(e) => e.stopPropagation()} role="dialog" aria-modal="true" aria-labelledby="modal-title">
          <div style={headerStyle}>
            <h2 id="modal-title" style={titleStyle}>{title}</h2>
            {showCloseButton && (
              <button
                ref={firstFocusableRef}
                className="modal-v1-close-btn"
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
            <button className="modal-v1-secondary-btn" style={secondaryButtonStyle} onClick={onClose}>
              Cancel
            </button>
            <button className="modal-v1-primary-btn" style={primaryButtonStyle} onClick={onClose}>
              Confirm
            </button>
          </div>
        </div>
      </div>
    </>
  );
};

export default Modal;
