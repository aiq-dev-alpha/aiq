import React, { useState } from 'react';
import './form_input.css';

// Version 3: Minimal Grid Form with Teal/Cyan Theme and Underline Inputs

interface FormTheme {
  primary: string;
  background: string;
  border: string;
  text: string;
  error: string;
  success: string;
}

interface FieldConfig {
  name: string;
  label: string;
  type: 'text' | 'email' | 'password' | 'number' | 'textarea' | 'select' | 'checkbox' | 'radio';
  placeholder?: string;
  required?: boolean;
  options?: { label: string; value: string }[];
  validation?: (value: any) => string | undefined;
  span?: 1 | 2 | 3;
}

interface FormInputProps {
  onSubmit: (data: Record<string, any>) => void | Promise<void>;
  fields: FieldConfig[];
  loading?: boolean;
  submitText?: string;
  variant?: 'grid' | 'compact';
  theme?: Partial<FormTheme>;
  successMessage?: string;
  errorMessage?: string;
}

const defaultTheme: FormTheme = {
  primary: '#14b8a6',
  background: '#f0fdfa',
  border: '#99f6e4',
  text: '#134e4a',
  error: '#f43f5e',
  success: '#10b981',
};

export const FormInput: React.FC<FormInputProps> = ({
  onSubmit,
  fields,
  loading = false,
  submitText = 'Submit',
  variant = 'grid',
  theme: customTheme,
  successMessage,
  errorMessage,
}) => {
  const theme = { ...defaultTheme, ...customTheme };
  const [formData, setFormData] = useState<Record<string, any>>(() => {
    const initial: Record<string, any> = {};
    fields.forEach(field => {
      initial[field.name] = field.type === 'checkbox' ? false : '';
    });
    return initial;
  });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [touched, setTouched] = useState<Record<string, boolean>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [showSuccess, setShowSuccess] = useState(false);
  const [showError, setShowError] = useState(false);
  const [focusedField, setFocusedField] = useState<string | null>(null);

  const validateField = (field: FieldConfig, value: any): string | undefined => {
    if (field.required && !value) {
      return `Required`;
    }
    if (field.validation) {
      return field.validation(value);
    }
    if (field.type === 'email' && value) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(value)) {
        return 'Invalid email';
      }
    }
    if (field.type === 'password' && value && value.length < 6) {
      return 'Min 6 characters';
    }
    return undefined;
  };

  const handleChange = (fieldName: string, value: any) => {
    setFormData(prev => ({ ...prev, [fieldName]: value }));
    setShowSuccess(false);
    setShowError(false);

    const field = fields.find(f => f.name === fieldName);
    if (field && touched[fieldName]) {
      const error = validateField(field, value);
      setErrors(prev => ({
        ...prev,
        [fieldName]: error || '',
      }));
    }
  };

  const handleBlur = (fieldName: string) => {
    setTouched(prev => ({ ...prev, [fieldName]: true }));
    setFocusedField(null);
    const field = fields.find(f => f.name === fieldName);
    if (field) {
      const error = validateField(field, formData[fieldName]);
      setErrors(prev => ({
        ...prev,
        [fieldName]: error || '',
      }));
    }
  };

  const handleFocus = (fieldName: string) => {
    setFocusedField(fieldName);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const newErrors: Record<string, string> = {};
    const newTouched: Record<string, boolean> = {};

    fields.forEach(field => {
      newTouched[field.name] = true;
      const error = validateField(field, formData[field.name]);
      if (error) {
        newErrors[field.name] = error;
      }
    });

    setTouched(newTouched);
    setErrors(newErrors);

    if (Object.keys(newErrors).length === 0) {
      setIsSubmitting(true);
      setShowError(false);
      try {
        await onSubmit(formData);
        setShowSuccess(true);
        setTimeout(() => setShowSuccess(false), 5000);
      } catch (error) {
        setShowError(true);
      } finally {
        setIsSubmitting(false);
      }
    }
  };

  const renderField = (field: FieldConfig) => {
    const hasError = touched[field.name] && errors[field.name];
    const isFocused = focusedField === field.name;
    const hasValue = formData[field.name];
    const isActive = isFocused || hasValue;
    const fieldId = `field-${field.name}`;

    switch (field.type) {
      case 'textarea':
        return (
          <div key={field.name} className={`form_input_v3_field_group span-${field.span || 1}`}>
            <div className={`form_input_v3_wrapper ${isActive ? 'active' : ''} ${hasError ? 'error' : ''}`}>
              <label htmlFor={fieldId} className="form_input_v3_label" style={{ color: isActive ? theme.primary : theme.text }}>
                {field.label}{field.required && ' *'}
              </label>
              <textarea
                id={fieldId}
                value={formData[field.name]}
                onChange={(e) => handleChange(field.name, e.target.value)}
                onFocus={() => handleFocus(field.name)}
                onBlur={() => handleBlur(field.name)}
                disabled={loading || isSubmitting}
                className="form_input_v3_field form_input_v3_textarea"
                style={{
                  color: theme.text,
                  backgroundColor: 'transparent',
                }}
                aria-required={field.required}
                aria-invalid={!!hasError}
                aria-describedby={hasError ? `${fieldId}-error` : undefined}
              />
              <div className="form_input_v3_underline" style={{
                backgroundColor: hasError ? theme.error : isFocused ? theme.primary : theme.border,
              }}></div>
            </div>
            {hasError && (
              <p id={`${fieldId}-error`} className="form_input_v3_error" style={{ color: theme.error }}>
                {errors[field.name]}
              </p>
            )}
          </div>
        );

      case 'select':
        return (
          <div key={field.name} className={`form_input_v3_field_group span-${field.span || 1}`}>
            <div className={`form_input_v3_wrapper ${isActive ? 'active' : ''} ${hasError ? 'error' : ''}`}>
              <label htmlFor={fieldId} className="form_input_v3_label" style={{ color: isActive ? theme.primary : theme.text }}>
                {field.label}{field.required && ' *'}
              </label>
              <select
                id={fieldId}
                value={formData[field.name]}
                onChange={(e) => handleChange(field.name, e.target.value)}
                onFocus={() => handleFocus(field.name)}
                onBlur={() => handleBlur(field.name)}
                disabled={loading || isSubmitting}
                className="form_input_v3_field form_input_v3_select"
                style={{
                  color: theme.text,
                  backgroundColor: 'transparent',
                }}
                aria-required={field.required}
                aria-invalid={!!hasError}
                aria-describedby={hasError ? `${fieldId}-error` : undefined}
              >
                <option value="">Select</option>
                {field.options?.map(option => (
                  <option key={option.value} value={option.value}>
                    {option.label}
                  </option>
                ))}
              </select>
              <div className="form_input_v3_underline" style={{
                backgroundColor: hasError ? theme.error : isFocused ? theme.primary : theme.border,
              }}></div>
            </div>
            {hasError && (
              <p id={`${fieldId}-error`} className="form_input_v3_error" style={{ color: theme.error }}>
                {errors[field.name]}
              </p>
            )}
          </div>
        );

      case 'checkbox':
        return (
          <div key={field.name} className={`form_input_v3_checkbox_group span-${field.span || 1}`}>
            <label className="form_input_v3_checkbox_label" style={{ color: theme.text }}>
              <input
                type="checkbox"
                checked={formData[field.name]}
                onChange={(e) => handleChange(field.name, e.target.checked)}
                onBlur={() => handleBlur(field.name)}
                disabled={loading || isSubmitting}
                className="form_input_v3_checkbox"
                style={{ accentColor: theme.primary }}
                aria-required={field.required}
              />
              <span className="form_input_v3_checkbox_text">
                {field.label}{field.required && ' *'}
              </span>
            </label>
            {hasError && (
              <p className="form_input_v3_error" style={{ color: theme.error }}>
                {errors[field.name]}
              </p>
            )}
          </div>
        );

      case 'radio':
        return (
          <div key={field.name} className={`form_input_v3_field_group span-${field.span || 1}`}>
            <label className="form_input_v3_radio_title" style={{ color: theme.text }}>
              {field.label}{field.required && ' *'}
            </label>
            <div className="form_input_v3_radio_group">
              {field.options?.map(option => (
                <label key={option.value} className="form_input_v3_radio_label" style={{ color: theme.text }}>
                  <input
                    type="radio"
                    name={field.name}
                    value={option.value}
                    checked={formData[field.name] === option.value}
                    onChange={(e) => handleChange(field.name, e.target.value)}
                    onBlur={() => handleBlur(field.name)}
                    disabled={loading || isSubmitting}
                    className="form_input_v3_radio"
                    style={{ accentColor: theme.primary }}
                    aria-required={field.required}
                  />
                  <span>{option.label}</span>
                </label>
              ))}
            </div>
            {hasError && (
              <p className="form_input_v3_error" style={{ color: theme.error }}>
                {errors[field.name]}
              </p>
            )}
          </div>
        );

      default:
        return (
          <div key={field.name} className={`form_input_v3_field_group span-${field.span || 1}`}>
            <div className={`form_input_v3_wrapper ${isActive ? 'active' : ''} ${hasError ? 'error' : ''}`}>
              <label htmlFor={fieldId} className="form_input_v3_label" style={{ color: isActive ? theme.primary : theme.text }}>
                {field.label}{field.required && ' *'}
              </label>
              <input
                id={fieldId}
                type={field.type}
                value={formData[field.name]}
                onChange={(e) => handleChange(field.name, e.target.value)}
                onFocus={() => handleFocus(field.name)}
                onBlur={() => handleBlur(field.name)}
                disabled={loading || isSubmitting}
                className="form_input_v3_field"
                style={{
                  color: theme.text,
                  backgroundColor: 'transparent',
                }}
                aria-required={field.required}
                aria-invalid={!!hasError}
                aria-describedby={hasError ? `${fieldId}-error` : undefined}
              />
              <div className="form_input_v3_underline" style={{
                backgroundColor: hasError ? theme.error : isFocused ? theme.primary : theme.border,
              }}></div>
            </div>
            {hasError && (
              <p id={`${fieldId}-error`} className="form_input_v3_error" style={{ color: theme.error }}>
                {errors[field.name]}
              </p>
            )}
          </div>
        );
    }
  };

  return (
    <form
      onSubmit={handleSubmit}
      className={`form_input_v3 form_input_v3_${variant}`}
      style={{ backgroundColor: theme.background }}
      noValidate
    >
      <div className="form_input_v3_fields">
        {fields.map(renderField)}
      </div>

      {showSuccess && successMessage && (
        <div className="form_input_v3_success" style={{
          backgroundColor: `${theme.success}20`,
          color: theme.success,
          borderBottomColor: theme.success,
        }}>
          {successMessage}
        </div>
      )}

      {showError && errorMessage && (
        <div className="form_input_v3_error_message" style={{
          backgroundColor: `${theme.error}20`,
          color: theme.error,
          borderBottomColor: theme.error,
        }}>
          {errorMessage}
        </div>
      )}

      <button
        type="submit"
        disabled={loading || isSubmitting}
        className="form_input_v3_submit"
        style={{
          backgroundColor: theme.primary,
          color: '#ffffff',
          opacity: loading || isSubmitting ? 0.6 : 1,
        }}
      >
        {isSubmitting ? 'Submitting...' : submitText}
      </button>
    </form>
  );
};

export default FormInput;
