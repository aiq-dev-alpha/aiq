import React, { useEffect } from 'react';
import './modal.css';

// Version 2: Modern slide-in drawer modal

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  children: React.ReactNode;
  footer?: React.ReactNode;
  position?: 'right' | 'left' | 'bottom';
}

export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title,
  children,
  footer,
  position = 'right'
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
    <>
      <div className="modal_v2_overlay" onClick={onClose} />
      <div className={`modal_v2 modal_v2_${position}`}>
        <div className="modal_v2_header">
          <div>
            {title && <h2 className="modal_v2_title">{title}</h2>}
          </div>
          <button className="modal_v2_close" onClick={onClose}>
            ✕
          </button>
        </div>

        <div className="modal_v2_content">
          {children}
        </div>

        {footer && (
          <div className="modal_v2_footer">
            {footer}
          </div>
        )}
      </div>
    </>
  );
};

export default Modal;
