import React, { useState } from 'react';
import './form_input.css';

// Version 3: Minimal underline input

interface FormInputProps {
  label: string;
  type?: 'text' | 'email' | 'password' | 'number' | 'tel';
  value: string;
  onChange: (value: string) => void;
  error?: string;
  required?: boolean;
  disabled?: boolean;
  className?: string;
}

export const FormInput: React.FC<FormInputProps> = ({
  label,
  type = 'text',
  value,
  onChange,
  error,
  required = false,
  disabled = false,
  className = ''
}) => {
  const [isFocused, setIsFocused] = useState(false);

  return (
    <div className={`form_input_v3 ${className}`}>
      <div className={`form_input_v3_wrapper ${isFocused || value ? 'active' : ''} ${error ? 'error' : ''}`}>
        <label className="form_input_v3_label">
          {label}
          {required && ' *'}
        </label>
        
        <input
          type={type}
          value={value}
          onChange={(e) => onChange(e.target.value)}
          onFocus={() => setIsFocused(true)}
          onBlur={() => setIsFocused(false)}
          disabled={disabled}
          className="form_input_v3_field"
        />
        
        <div className="form_input_v3_underline"></div>
      </div>
      
      {error && (
        <p className="form_input_v3_error">{error}</p>
      )}
    </div>
  );
};

export default FormInput;
