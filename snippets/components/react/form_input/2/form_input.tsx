import React, { useState } from 'react';
import './form_input.css';

// Version 2: Modern floating label with icon support

interface FormInputProps {
  label: string;
  type?: 'text' | 'email' | 'password' | 'number' | 'tel';
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  icon?: React.ReactNode;
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
  placeholder = ' ',
  icon,
  error,
  required = false,
  disabled = false,
  className = ''
}) => {
  const [isFocused, setIsFocused] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  return (
    <div className={`form_input_v2 ${className}`}>
      <div className={`form_input_v2_wrapper ${error ? 'error' : ''} ${isFocused || value ? 'active' : ''}`}>
        {icon && <div className="form_input_v2_icon">{icon}</div>}
        
        <div className="form_input_v2_field_wrapper">
          <input
            type={type === 'password' && showPassword ? 'text' : type}
            value={value}
            onChange={(e) => onChange(e.target.value)}
            onFocus={() => setIsFocused(true)}
            onBlur={() => setIsFocused(false)}
            placeholder={placeholder}
            disabled={disabled}
            className="form_input_v2_field"
          />
          
          <label className="form_input_v2_label">
            {label}
            {required && <span className="form_input_v2_required">*</span>}
          </label>
        </div>

        {type === 'password' && (
          <button
            type="button"
            className="form_input_v2_toggle"
            onClick={() => setShowPassword(!showPassword)}
          >
            {showPassword ? '👁️' : '👁️‍🗨️'}
          </button>
        )}
      </div>
      
      {error && (
        <p className="form_input_v2_error">
          ⚠️ {error}
        </p>
      )}
    </div>
  );
};

export default FormInput;
