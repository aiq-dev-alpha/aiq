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
  background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
  overlay: 'rgba(102, 126, 234, 0.2)',
  border: 'rgba(255, 255, 255, 0.3)',
  shadow: 'rgba(102, 126, 234, 0.5)'
};

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title = 'Glassmorphic Modal',
  children,
  size = 'md',
  variant = 'centered',
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
    sm: { maxWidth: '420px', width: '90%' },
    md: { maxWidth: '560px', width: '90%' },
    lg: { maxWidth: '780px', width: '90%' },
    xl: { maxWidth: '1000px', width: '95%' },
    full: { maxWidth: '95vw', width: '95%', height: '95vh' }
  };

  const overlayStyle: CSSProperties = {
    position: 'fixed',
    inset: 0,
    background: appliedTheme.overlay,
    backdropFilter: 'blur(20px) saturate(180%)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 9999,
    animation: 'fadeIn 0.4s ease-out'
  };

  const modalStyle: CSSProperties = {
    ...sizeMap[size],
    background: 'rgba(255, 255, 255, 0.15)',
    backdropFilter: 'blur(30px) saturate(180%)',
    borderRadius: '28px',
    boxShadow: `0 8px 32px ${appliedTheme.shadow}, inset 0 0 0 1px ${appliedTheme.border}`,
    display: 'flex',
    flexDirection: 'column',
    maxHeight: '90vh',
    animation: 'glassSlideUp 0.6s cubic-bezier(0.34, 1.56, 0.64, 1)',
    border: `1px solid ${appliedTheme.border}`,
    position: 'relative'
  };

  const headerStyle: CSSProperties = {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '28px 36px',
    borderBottom: `1px solid ${appliedTheme.border}`,
    background: 'rgba(255, 255, 255, 0.05)'
  };

  const titleStyle: CSSProperties = {
    margin: 0,
    fontSize: '26px',
    fontWeight: 800,
    color: '#fff',
    textShadow: '0 2px 10px rgba(0, 0, 0, 0.2)',
    letterSpacing: '-0.5px'
  };

  const closeButtonStyle: CSSProperties = {
    background: 'rgba(255, 255, 255, 0.2)',
    border: `1px solid ${appliedTheme.border}`,
    borderRadius: '50%',
    width: '38px',
    height: '38px',
    fontSize: '20px',
    cursor: 'pointer',
    color: '#fff',
    transition: 'all 0.3s ease',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    backdropFilter: 'blur(10px)'
  };

  const contentStyle: CSSProperties = {
    padding: '36px',
    flex: 1,
    overflow: 'auto',
    fontSize: '16px',
    lineHeight: 1.7,
    color: '#fff',
    textShadow: '0 1px 3px rgba(0, 0, 0, 0.2)'
  };

  const footerStyle: CSSProperties = {
    padding: '24px 36px',
    borderTop: `1px solid ${appliedTheme.border}`,
    display: 'flex',
    gap: '14px',
    justifyContent: 'flex-end',
    background: 'rgba(255, 255, 255, 0.05)'
  };

  const buttonStyle: CSSProperties = {
    padding: '12px 32px',
    borderRadius: '14px',
    border: 'none',
    fontSize: '15px',
    fontWeight: 600,
    cursor: 'pointer',
    transition: 'all 0.3s ease',
    backdropFilter: 'blur(10px)'
  };

  const primaryButtonStyle: CSSProperties = {
    ...buttonStyle,
    background: 'rgba(255, 255, 255, 0.9)',
    color: '#667eea',
    boxShadow: '0 4px 15px rgba(255, 255, 255, 0.3)'
  };

  const secondaryButtonStyle: CSSProperties = {
    ...buttonStyle,
    background: 'rgba(255, 255, 255, 0.15)',
    color: '#fff',
    border: `1px solid ${appliedTheme.border}`
  };

  return (
    <>
      <style>{`
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes glassSlideUp {
          0% { opacity: 0; transform: translateY(60px) scale(0.9) rotateX(10deg); }
          100% { opacity: 1; transform: translateY(0) scale(1) rotateX(0deg); }
        }
        .modal-v3-close-btn:hover {
          background: rgba(255, 255, 255, 0.35);
          transform: scale(1.1) rotate(90deg);
        }
        .modal-v3-primary-btn:hover {
          transform: translateY(-3px);
          box-shadow: 0 6px 20px rgba(255, 255, 255, 0.5);
          background: rgba(255, 255, 255, 1);
        }
        .modal-v3-secondary-btn:hover {
          background: rgba(255, 255, 255, 0.25);
          transform: translateY(-3px);
        }
      `}</style>
      <div style={overlayStyle} onClick={closeOnOverlay ? onClose : undefined}>
        <div ref={modalRef} style={modalStyle} onClick={(e) => e.stopPropagation()} role="dialog" aria-modal="true" aria-labelledby="modal-title">
          <div style={headerStyle}>
            <h2 id="modal-title" style={titleStyle}>{title}</h2>
            {showCloseButton && (
              <button
                className="modal-v3-close-btn"
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
            <button className="modal-v3-secondary-btn" style={secondaryButtonStyle} onClick={onClose}>
              Dismiss
            </button>
            <button className="modal-v3-primary-btn" style={primaryButtonStyle} onClick={onClose}>
              Accept
            </button>
          </div>
        </div>
      </div>
    </>
  );
};

export default Modal;
