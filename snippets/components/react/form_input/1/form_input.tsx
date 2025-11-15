import React, { useState } from 'react';
import './form_input.css';

// Version 1: Traditional labeled input with validation

interface FormInputProps {
  label: string;
  type?: 'text' | 'email' | 'password' | 'number' | 'tel';
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  error?: string;
  helperText?: string;
  required?: boolean;
  disabled?: boolean;
  className?: string;
}

export const FormInput: React.FC<FormInputProps> = ({
  label,
  type = 'text',
  value,
  onChange,
  placeholder,
  error,
  helperText,
  required = false,
  disabled = false,
  className = ''
}) => {
  const [isFocused, setIsFocused] = useState(false);

  return (
    <div className={`form_input_v1 ${className}`}>
      <label className="form_input_v1_label">
        {label}
        {required && <span className="form_input_v1_required">*</span>}
      </label>
      
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        onFocus={() => setIsFocused(true)}
        onBlur={() => setIsFocused(false)}
        placeholder={placeholder}
        disabled={disabled}
        className={`form_input_v1_field ${error ? 'error' : ''} ${isFocused ? 'focused' : ''}`}
      />
      
      {(helperText || error) && (
        <p className={`form_input_v1_helper ${error ? 'error' : ''}`}>
          {error || helperText}
        </p>
      )}
    </div>
  );
};

export default FormInput;
