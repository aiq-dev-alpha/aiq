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
  background: '#0f172a',
  overlay: 'rgba(0, 0, 0, 0.85)',
  border: '#1e293b',
  shadow: 'rgba(139, 92, 246, 0.5)'
};

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title = 'Neon Modal',
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
    sm: { maxWidth: '400px', width: '90%' },
    md: { maxWidth: '600px', width: '90%' },
    lg: { maxWidth: '850px', width: '90%' },
    xl: { maxWidth: '1100px', width: '95%' },
    full: { maxWidth: '100vw', width: '100%', height: '100vh' }
  };

  const overlayStyle: CSSProperties = {
    position: 'fixed',
    inset: 0,
    background: appliedTheme.overlay,
    backdropFilter: 'blur(2px)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 9999,
    animation: 'fadeIn 0.3s ease-out'
  };

  const modalStyle: CSSProperties = {
    ...sizeMap[size],
    background: appliedTheme.background,
    borderRadius: '16px',
    boxShadow: `0 0 40px ${appliedTheme.shadow}, 0 0 80px rgba(139, 92, 246, 0.3), inset 0 0 0 2px #8b5cf6`,
    display: 'flex',
    flexDirection: 'column',
    maxHeight: '90vh',
    animation: 'neonPulse 0.6s ease-out',
    border: '2px solid #8b5cf6',
    position: 'relative'
  };

  const headerStyle: CSSProperties = {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '26px 32px',
    borderBottom: '2px solid #8b5cf6',
    background: 'linear-gradient(180deg, rgba(139, 92, 246, 0.1) 0%, transparent 100%)',
    boxShadow: '0 4px 20px rgba(139, 92, 246, 0.2)'
  };

  const titleStyle: CSSProperties = {
    margin: 0,
    fontSize: '24px',
    fontWeight: 800,
    color: '#a78bfa',
    textShadow: '0 0 20px rgba(139, 92, 246, 0.8), 0 0 40px rgba(139, 92, 246, 0.5)',
    letterSpacing: '1px',
    textTransform: 'uppercase'
  };

  const closeButtonStyle: CSSProperties = {
    background: 'transparent',
    border: '2px solid #8b5cf6',
    borderRadius: '8px',
    width: '36px',
    height: '36px',
    fontSize: '20px',
    cursor: 'pointer',
    color: '#a78bfa',
    transition: 'all 0.3s ease',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    boxShadow: '0 0 15px rgba(139, 92, 246, 0.5)'
  };

  const contentStyle: CSSProperties = {
    padding: '32px',
    flex: 1,
    overflow: 'auto',
    fontSize: '16px',
    lineHeight: 1.7,
    color: '#e0e7ff'
  };

  const footerStyle: CSSProperties = {
    padding: '24px 32px',
    borderTop: '2px solid #8b5cf6',
    display: 'flex',
    gap: '12px',
    justifyContent: 'flex-end',
    background: 'linear-gradient(0deg, rgba(139, 92, 246, 0.1) 0%, transparent 100%)',
    boxShadow: '0 -4px 20px rgba(139, 92, 246, 0.2)'
  };

  const buttonStyle: CSSProperties = {
    padding: '11px 28px',
    borderRadius: '10px',
    border: 'none',
    fontSize: '15px',
    fontWeight: 700,
    cursor: 'pointer',
    transition: 'all 0.3s ease',
    textTransform: 'uppercase',
    letterSpacing: '0.5px'
  };

  const primaryButtonStyle: CSSProperties = {
    ...buttonStyle,
    background: '#8b5cf6',
    color: '#fff',
    border: '2px solid #8b5cf6',
    boxShadow: '0 0 20px rgba(139, 92, 246, 0.6), 0 4px 15px rgba(139, 92, 246, 0.4)'
  };

  const secondaryButtonStyle: CSSProperties = {
    ...buttonStyle,
    background: 'transparent',
    color: '#a78bfa',
    border: '2px solid #8b5cf6',
    boxShadow: '0 0 15px rgba(139, 92, 246, 0.3)'
  };

  return (
    <>
      <style>{`
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes neonPulse {
          0% {
            opacity: 0;
            transform: scale(0.8);
            box-shadow: 0 0 0px rgba(139, 92, 246, 0), inset 0 0 0 0px #8b5cf6;
          }
          50% {
            box-shadow: 0 0 60px rgba(139, 92, 246, 0.8), 0 0 100px rgba(139, 92, 246, 0.5), inset 0 0 0 2px #a78bfa;
          }
          100% {
            opacity: 1;
            transform: scale(1);
            box-shadow: 0 0 40px rgba(139, 92, 246, 0.5), 0 0 80px rgba(139, 92, 246, 0.3), inset 0 0 0 2px #8b5cf6;
          }
        }
        .modal-v4-close-btn:hover {
          background: rgba(139, 92, 246, 0.2);
          border-color: #a78bfa;
          color: #c4b5fd;
          box-shadow: 0 0 25px rgba(139, 92, 246, 0.8);
          transform: scale(1.05) rotate(90deg);
        }
        .modal-v4-primary-btn:hover {
          background: #a78bfa;
          transform: translateY(-2px);
          box-shadow: 0 0 30px rgba(139, 92, 246, 0.9), 0 6px 20px rgba(139, 92, 246, 0.6);
        }
        .modal-v4-secondary-btn:hover {
          background: rgba(139, 92, 246, 0.2);
          border-color: #a78bfa;
          box-shadow: 0 0 25px rgba(139, 92, 246, 0.5);
          transform: translateY(-2px);
        }
      `}</style>
      <div style={overlayStyle} onClick={closeOnOverlay ? onClose : undefined}>
        <div ref={modalRef} style={modalStyle} onClick={(e) => e.stopPropagation()} role="dialog" aria-modal="true" aria-labelledby="modal-title">
          <div style={headerStyle}>
            <h2 id="modal-title" style={titleStyle}>{title}</h2>
            {showCloseButton && (
              <button
                className="modal-v4-close-btn"
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
            <button className="modal-v4-secondary-btn" style={secondaryButtonStyle} onClick={onClose}>
              Cancel
            </button>
            <button className="modal-v4-primary-btn" style={primaryButtonStyle} onClick={onClose}>
              Confirm
            </button>
          </div>
        </div>
      </div>
    </>
  );
};
