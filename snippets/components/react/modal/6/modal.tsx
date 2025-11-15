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
  background: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
  overlay: 'rgba(240, 147, 251, 0.2)',
  border: 'rgba(255, 255, 255, 0.5)',
  shadow: 'rgba(245, 87, 108, 0.4)'
};

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title = 'Gradient Modal',
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
    sm: { maxWidth: '450px', width: '90%' },
    md: { maxWidth: '620px', width: '90%' },
    lg: { maxWidth: '880px', width: '90%' },
    xl: { maxWidth: '1150px', width: '95%' },
    full: { maxWidth: '98vw', width: '98%', height: '98vh' }
  };

  const overlayStyle: CSSProperties = {
    position: 'fixed',
    inset: 0,
    background: appliedTheme.overlay,
    backdropFilter: 'blur(12px)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 9999,
    animation: 'fadeIn 0.3s ease-out'
  };

  const modalStyle: CSSProperties = {
    ...sizeMap[size],
    background: 'rgba(255, 255, 255, 0.95)',
    borderRadius: '24px',
    boxShadow: `0 20px 60px ${appliedTheme.shadow}`,
    display: 'flex',
    flexDirection: 'column',
    maxHeight: '88vh',
    animation: 'flipIn 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55)',
    border: `2px solid ${appliedTheme.border}`,
    position: 'relative',
    overflow: 'hidden'
  };

  const gradientBar: CSSProperties = {
    height: '6px',
    background: appliedTheme.background,
    width: '100%'
  };

  const headerStyle: CSSProperties = {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '26px 32px',
    borderBottom: `2px solid #fce7f3`
  };

  const titleStyle: CSSProperties = {
    margin: 0,
    fontSize: '25px',
    fontWeight: 800,
    background: appliedTheme.background,
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
    letterSpacing: '-0.6px'
  };

  const closeButtonStyle: CSSProperties = {
    background: appliedTheme.background,
    border: 'none',
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
    boxShadow: `0 4px 14px ${appliedTheme.shadow}`
  };

  const contentStyle: CSSProperties = {
    padding: '32px',
    flex: 1,
    overflow: 'auto',
    fontSize: '16px',
    lineHeight: 1.7,
    color: '#374151'
  };

  const footerStyle: CSSProperties = {
    padding: '22px 32px',
    borderTop: '2px solid #fce7f3',
    display: 'flex',
    gap: '12px',
    justifyContent: 'flex-end',
    background: '#fef3f8'
  };

  const buttonStyle: CSSProperties = {
    padding: '12px 30px',
    borderRadius: '12px',
    border: 'none',
    fontSize: '15px',
    fontWeight: 600,
    cursor: 'pointer',
    transition: 'all 0.3s ease'
  };

  const primaryButtonStyle: CSSProperties = {
    ...buttonStyle,
    background: appliedTheme.background,
    color: '#fff',
    boxShadow: `0 4px 14px ${appliedTheme.shadow}`
  };

  const secondaryButtonStyle: CSSProperties = {
    ...buttonStyle,
    background: '#fce7f3',
    color: '#ec4899'
  };

  return (
    <>
      <style>{`
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes flipIn {
          0% { opacity: 0; transform: perspective(800px) rotateY(-90deg); }
          50% { opacity: 1; transform: perspective(800px) rotateY(10deg); }
          100% { opacity: 1; transform: perspective(800px) rotateY(0deg); }
        }
        .modal-v6-close-btn:hover {
          transform: scale(1.12) rotate(90deg);
          box-shadow: 0 6px 20px ${appliedTheme.shadow};
        }
        .modal-v6-primary-btn:hover {
          transform: translateY(-2px);
          box-shadow: 0 6px 20px ${appliedTheme.shadow};
        }
        .modal-v6-secondary-btn:hover {
          background: #fbcfe8;
          transform: translateY(-2px);
        }
      `}</style>
      <div style={overlayStyle} onClick={closeOnOverlay ? onClose : undefined}>
        <div ref={modalRef} style={modalStyle} onClick={(e) => e.stopPropagation()} role="dialog" aria-modal="true" aria-labelledby="modal-title">
          <div style={gradientBar} />
          <div style={headerStyle}>
            <h2 id="modal-title" style={titleStyle}>{title}</h2>
            {showCloseButton && (
              <button
                className="modal-v6-close-btn"
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
            <button className="modal-v6-secondary-btn" style={secondaryButtonStyle} onClick={onClose}>
              Cancel
            </button>
            <button className="modal-v6-primary-btn" style={primaryButtonStyle} onClick={onClose}>
              Continue
            </button>
          </div>
        </div>
      </div>
    </>
  );
};
