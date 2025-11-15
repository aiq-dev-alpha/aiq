import React, { useEffect } from 'react';
import './modal.css';

// Version 1: Traditional centered modal with overlay

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  children: React.ReactNode;
  footer?: React.ReactNode;
  size?: 'small' | 'medium' | 'large';
  closeOnOverlay?: boolean;
}

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title,
  children,
  footer,
  size = 'medium',
  closeOnOverlay = true
}) => {
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

  return (
    <div 
      className="modal_v1_overlay"
      onClick={closeOnOverlay ? onClose : undefined}
    >
      <div 
        className={`modal_v1 modal_v1_${size}`}
        onClick={(e) => e.stopPropagation()}
      >
        <div className="modal_v1_header">
          {title && <h2 className="modal_v1_title">{title}</h2>}
          <button className="modal_v1_close" onClick={onClose}>
            ✕
          </button>
        </div>

        <div className="modal_v1_content">
          {children}
        </div>

        {footer && (
          <div className="modal_v1_footer">
            {footer}
          </div>
        )}
      </div>
    </div>
  );
};

export default Modal;
