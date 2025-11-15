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
  background: '#fff',
  overlay: 'rgba(0, 0, 0, 0.4)',
  border: '#e2e8f0',
  shadow: 'rgba(0, 0, 0, 0.15)'
};

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title = 'Bottom Sheet',
  children,
  size = 'md',
  variant = 'bottom-sheet',
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

  const overlayStyle: CSSProperties = {
    position: 'fixed',
    inset: 0,
    background: appliedTheme.overlay,
    backdropFilter: 'blur(3px)',
    display: 'flex',
    alignItems: 'flex-end',
    justifyContent: 'center',
    zIndex: 9999,
    animation: 'fadeIn 0.3s ease-out'
  };

  const modalStyle: CSSProperties = {
    width: '100%',
    maxHeight: '85vh',
    background: appliedTheme.background,
    borderRadius: '32px 32px 0 0',
    boxShadow: `0 -10px 40px ${appliedTheme.shadow}`,
    display: 'flex',
    flexDirection: 'column',
    animation: 'slideUpBottom 0.4s cubic-bezier(0.16, 1, 0.3, 1)',
    position: 'relative'
  };

  const handleStyle: CSSProperties = {
    width: '48px',
    height: '5px',
    background: '#cbd5e1',
    borderRadius: '10px',
    margin: '16px auto 8px',
    cursor: 'pointer'
  };

  const headerStyle: CSSProperties = {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '20px 28px',
    borderBottom: `1px solid ${appliedTheme.border}`
  };

  const titleStyle: CSSProperties = {
    margin: 0,
    fontSize: '20px',
    fontWeight: 700,
    color: '#1e293b'
  };

  const closeButtonStyle: CSSProperties = {
    background: '#f1f5f9',
    border: 'none',
    borderRadius: '50%',
    width: '32px',
    height: '32px',
    fontSize: '18px',
    cursor: 'pointer',
    color: '#64748b',
    transition: 'all 0.2s ease',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center'
  };

  const contentStyle: CSSProperties = {
    padding: '28px',
    flex: 1,
    overflow: 'auto',
    fontSize: '15px',
    lineHeight: 1.6,
    color: '#475569'
  };

  const footerStyle: CSSProperties = {
    padding: '20px 28px',
    borderTop: `1px solid ${appliedTheme.border}`,
    display: 'flex',
    gap: '12px',
    justifyContent: 'flex-end',
    background: '#f8fafc'
  };

  const buttonStyle: CSSProperties = {
    padding: '11px 24px',
    borderRadius: '10px',
    border: 'none',
    fontSize: '14px',
    fontWeight: 600,
    cursor: 'pointer',
    transition: 'all 0.2s ease'
  };

  const primaryButtonStyle: CSSProperties = {
    ...buttonStyle,
    background: '#3b82f6',
    color: '#fff'
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
        @keyframes slideUpBottom {
          from { transform: translateY(100%); opacity: 0; }
          to { transform: translateY(0); opacity: 1; }
        }
        .modal-v5-close-btn:hover {
          background: #e2e8f0;
          transform: scale(1.05);
        }
        .modal-v5-primary-btn:hover {
          background: #2563eb;
          transform: translateY(-1px);
        }
        .modal-v5-secondary-btn:hover {
          background: #cbd5e1;
        }
      `}</style>
      <div style={overlayStyle} onClick={closeOnOverlay ? onClose : undefined}>
        <div ref={modalRef} style={modalStyle} onClick={(e) => e.stopPropagation()} role="dialog" aria-modal="true" aria-labelledby="modal-title">
          <div style={handleStyle} onClick={onClose} />

          <div style={headerStyle}>
            <h2 id="modal-title" style={titleStyle}>{title}</h2>
            {showCloseButton && (
              <button
                className="modal-v5-close-btn"
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
            <button className="modal-v5-secondary-btn" style={secondaryButtonStyle} onClick={onClose}>
              Cancel
            </button>
            <button className="modal-v5-primary-btn" style={primaryButtonStyle} onClick={onClose}>
              Done
            </button>
          </div>
        </div>
      </div>
    </>
  );
};
