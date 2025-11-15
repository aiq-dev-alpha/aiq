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
  background: '#22c55e',
  overlay: 'rgba(0, 0, 0, 0.4)',
  border: "#22c55e",
  shadow: 'rgba(0, 0, 0, 0.2)'
};

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title = 'Green Elastic Modal',
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
    sm: { maxWidth: '420px', width: '90%' },
    md: { maxWidth: '600px', width: '90%' },
    lg: { maxWidth: '840px', width: '90%' },
    xl: { maxWidth: '1080px', width: '95%' },
    full: { maxWidth: '100vw', width: '100%', height: '100vh' }
  };

  const overlayStyle: CSSProperties = {
    position: 'fixed',
    inset: 0,
    background: appliedTheme.overlay,
    backdropFilter: 'blur(5px)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 9999,
    animation: 'fadeIn 0.3s ease-out'
  };

  const modalStyle: CSSProperties = {
    ...sizeMap[size],
    background: '#fff',
    borderRadius: '18px',
    boxShadow: `0 20px 50px ${appliedTheme.shadow}`,
    display: 'flex',
    flexDirection: 'column',
    maxHeight: '90vh',
    animation: 'elasticIn 0.5s cubic-bezier(0.34, 1.56, 0.64, 1)',
    position: 'relative'
  };

  const headerStyle: CSSProperties = {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '24px 30px',
    borderBottom: '2px solid #e5e7eb'
  };

  const titleStyle: CSSProperties = {
    margin: 0,
    fontSize: '22px',
    fontWeight: 700,
    color: '#1f2937'
  };

  const closeButtonStyle: CSSProperties = {
    background: appliedTheme.background,
    border: 'none',
    borderRadius: '50%',
    width: '36px',
    height: '36px',
    fontSize: '18px',
    cursor: 'pointer',
    color: '#fff',
    transition: 'all 0.3s ease',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center'
  };

  const contentStyle: CSSProperties = {
    padding: '30px',
    flex: 1,
    overflow: 'auto',
    fontSize: '15px',
    lineHeight: 1.6,
    color: '#4b5563'
  };

  const footerStyle: CSSProperties = {
    padding: '20px 30px',
    borderTop: '2px solid #e5e7eb',
    display: 'flex',
    gap: '12px',
    justifyContent: 'flex-end',
    background: '#f9fafb'
  };

  const buttonStyle: CSSProperties = {
    padding: '11px 26px',
    borderRadius: '10px',
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
    background: '#e5e7eb',
    color: '#374151'
  };

  return (
    <>
      <style>{`
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes elasticIn {
          0% { opacity: 0; transform: scale(0); } 50% { transform: scale(1.2); } 75% { transform: scale(0.9); } 100% { opacity: 1; transform: scale(1); }
        }
        .modal-v19-close-btn:hover {
          transform: scale(1.1) rotate(90deg);
        }
        .modal-v19-primary-btn:hover {
          transform: translateY(-2px);
          filter: brightness(110%);
        }
        .modal-v19-secondary-btn:hover {
          background: #d1d5db;
        }
      `}</style>
      <div style={overlayStyle} onClick={closeOnOverlay ? onClose : undefined}>
        <div ref={modalRef} style={modalStyle} onClick={(e) => e.stopPropagation()} role="dialog" aria-modal="true" aria-labelledby="modal-title">
          <div style={headerStyle}>
            <h2 id="modal-title" style={titleStyle}>{title}</h2>
            {showCloseButton && (
              <button
                className="modal-v19-close-btn"
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
            <button className="modal-v19-secondary-btn" style={secondaryButtonStyle} onClick={onClose}>
              Cancel
            </button>
            <button className="modal-v19-primary-btn" style={primaryButtonStyle} onClick={onClose}>
              Confirm
            </button>
          </div>
        </div>
      </div>
    </>
  );
};
