import React from 'react';

interface ModalProps {
  variant?: 'outlined' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Modal: React.FC<ModalProps> = ({
  variant = 'outlined',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-2xl p-4 border-2 border-purple-500 bg-transparent ${className}`}>
      {children}
    </div>
  );
};

export default Modal;