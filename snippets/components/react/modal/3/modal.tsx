import React, { useEffect } from 'react';
import './modal.css';

// Version 3: Minimal dialog with backdrop blur

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  children: React.ReactNode;
  actions?: React.ReactNode;
  width?: string;
}

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title,
  children,
  actions,
  width = '480px'
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
    <div className="modal_v3_overlay" onClick={onClose}>
      <div 
        className="modal_v3"
        style={{ maxWidth: width }}
        onClick={(e) => e.stopPropagation()}
      >
        {title && (
          <div className="modal_v3_header">
            <h2 className="modal_v3_title">{title}</h2>
          </div>
        )}

        <div className="modal_v3_content">
          {children}
        </div>

        {actions && (
          <div className="modal_v3_actions">
            {actions}
          </div>
        )}

        <button className="modal_v3_close" onClick={onClose}>
          ✕
        </button>
      </div>
    </div>
  );
};

export default Modal;
