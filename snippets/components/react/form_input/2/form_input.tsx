import React, { useState } from 'react';
import './form_input.css';

// Version 2: Modern Two-Column Form with Purple/Gradient Theme and Floating Labels

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
  fullWidth?: boolean;
}

interface FormInputProps {
  onSubmit: (data: Record<string, any>) => void | Promise<void>;
  fields: FieldConfig[];
  loading?: boolean;
  submitText?: string;
  variant?: 'two-column' | 'grid';
  theme?: Partial<FormTheme>;
  successMessage?: string;
  errorMessage?: string;
}

const defaultTheme: FormTheme = {
  primary: '#9333ea',
  background: '#faf5ff',
  border: '#d8b4fe',
  text: '#581c87',
  error: '#e11d48',
  success: '#059669',
};

export const FormInput: React.FC<FormInputProps> = ({
  onSubmit,
  fields,
  loading = false,
  submitText = 'Submit',
  variant = 'two-column',
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
      return `${field.label} is required`;
    }
    if (field.validation) {
      return field.validation(value);
    }
    if (field.type === 'email' && value) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(value)) {
        return 'Invalid email address';
      }
    }
    if (field.type === 'password' && value && value.length < 8) {
      return 'Password must be at least 8 characters';
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
          <div key={field.name} className={`form_input_v2_field_group ${field.fullWidth ? 'full-width' : ''}`}>
            <div className={`form_input_v2_wrapper ${hasError ? 'error' : ''} ${isActive ? 'active' : ''}`}>
              <textarea
                id={fieldId}
                value={formData[field.name]}
                onChange={(e) => handleChange(field.name, e.target.value)}
                onFocus={() => handleFocus(field.name)}
                onBlur={() => handleBlur(field.name)}
                placeholder=" "
                disabled={loading || isSubmitting}
                className="form_input_v2_field form_input_v2_textarea"
                style={{
                  borderColor: hasError ? theme.error : isActive ? theme.primary : theme.border,
                  backgroundColor: theme.background,
                  color: theme.text,
                }}
                aria-required={field.required}
                aria-invalid={!!hasError}
                aria-describedby={hasError ? `${fieldId}-error` : undefined}
              />
              <label htmlFor={fieldId} className="form_input_v2_label" style={{ color: isActive ? theme.primary : theme.text }}>
                {field.label}
                {field.required && <span className="form_input_v2_required" style={{ color: theme.error }}>*</span>}
              </label>
            </div>
            {hasError && (
              <p id={`${fieldId}-error`} className="form_input_v2_error" style={{ color: theme.error }}>
                {errors[field.name]}
              </p>
            )}
          </div>
        );

      case 'select':
        return (
          <div key={field.name} className={`form_input_v2_field_group ${field.fullWidth ? 'full-width' : ''}`}>
            <div className={`form_input_v2_wrapper ${hasError ? 'error' : ''} ${isActive ? 'active' : ''}`}>
              <select
                id={fieldId}
                value={formData[field.name]}
                onChange={(e) => handleChange(field.name, e.target.value)}
                onFocus={() => handleFocus(field.name)}
                onBlur={() => handleBlur(field.name)}
                disabled={loading || isSubmitting}
                className="form_input_v2_field form_input_v2_select"
                style={{
                  borderColor: hasError ? theme.error : isActive ? theme.primary : theme.border,
                  backgroundColor: theme.background,
                  color: theme.text,
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
              <label htmlFor={fieldId} className="form_input_v2_label" style={{ color: isActive ? theme.primary : theme.text }}>
                {field.label}
                {field.required && <span className="form_input_v2_required" style={{ color: theme.error }}>*</span>}
              </label>
            </div>
            {hasError && (
              <p id={`${fieldId}-error`} className="form_input_v2_error" style={{ color: theme.error }}>
                {errors[field.name]}
              </p>
            )}
          </div>
        );

      case 'checkbox':
        return (
          <div key={field.name} className={`form_input_v2_checkbox_group ${field.fullWidth ? 'full-width' : ''}`}>
            <label className="form_input_v2_checkbox_label" style={{ color: theme.text }}>
              <input
                type="checkbox"
                checked={formData[field.name]}
                onChange={(e) => handleChange(field.name, e.target.checked)}
                onBlur={() => handleBlur(field.name)}
                disabled={loading || isSubmitting}
                className="form_input_v2_checkbox"
                style={{ accentColor: theme.primary }}
                aria-required={field.required}
              />
              <span className="form_input_v2_checkbox_text">
                {field.label}
                {field.required && <span className="form_input_v2_required" style={{ color: theme.error }}>*</span>}
              </span>
            </label>
            {hasError && (
              <p className="form_input_v2_error" style={{ color: theme.error }}>
                {errors[field.name]}
              </p>
            )}
          </div>
        );

      case 'radio':
        return (
          <div key={field.name} className={`form_input_v2_field_group ${field.fullWidth ? 'full-width' : ''}`}>
            <label className="form_input_v2_radio_title" style={{ color: theme.text }}>
              {field.label}
              {field.required && <span className="form_input_v2_required" style={{ color: theme.error }}>*</span>}
            </label>
            <div className="form_input_v2_radio_group">
              {field.options?.map(option => (
                <label key={option.value} className="form_input_v2_radio_label" style={{ color: theme.text }}>
                  <input
                    type="radio"
                    name={field.name}
                    value={option.value}
                    checked={formData[field.name] === option.value}
                    onChange={(e) => handleChange(field.name, e.target.value)}
                    onBlur={() => handleBlur(field.name)}
                    disabled={loading || isSubmitting}
                    className="form_input_v2_radio"
                    style={{ accentColor: theme.primary }}
                    aria-required={field.required}
                  />
                  <span>{option.label}</span>
                </label>
              ))}
            </div>
            {hasError && (
              <p className="form_input_v2_error" style={{ color: theme.error }}>
                {errors[field.name]}
              </p>
            )}
          </div>
        );

      default:
        return (
          <div key={field.name} className={`form_input_v2_field_group ${field.fullWidth ? 'full-width' : ''}`}>
            <div className={`form_input_v2_wrapper ${hasError ? 'error' : ''} ${isActive ? 'active' : ''}`}>
              <input
                id={fieldId}
                type={field.type}
                value={formData[field.name]}
                onChange={(e) => handleChange(field.name, e.target.value)}
                onFocus={() => handleFocus(field.name)}
                onBlur={() => handleBlur(field.name)}
                placeholder=" "
                disabled={loading || isSubmitting}
                className="form_input_v2_field"
                style={{
                  borderColor: hasError ? theme.error : isActive ? theme.primary : theme.border,
                  backgroundColor: theme.background,
                  color: theme.text,
                }}
                aria-required={field.required}
                aria-invalid={!!hasError}
                aria-describedby={hasError ? `${fieldId}-error` : undefined}
              />
              <label htmlFor={fieldId} className="form_input_v2_label" style={{ color: isActive ? theme.primary : theme.text }}>
                {field.label}
                {field.required && <span className="form_input_v2_required" style={{ color: theme.error }}>*</span>}
              </label>
            </div>
            {hasError && (
              <p id={`${fieldId}-error`} className="form_input_v2_error" style={{ color: theme.error }}>
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
      className={`form_input_v2 form_input_v2_${variant}`}
      style={{
        background: `linear-gradient(135deg, ${theme.background} 0%, #ffffff 100%)`,
      }}
      noValidate
    >
      <div className="form_input_v2_fields">
        {fields.map(renderField)}
      </div>

      {showSuccess && successMessage && (
        <div className="form_input_v2_success" style={{
          background: `linear-gradient(135deg, ${theme.success}20 0%, ${theme.success}10 100%)`,
          color: theme.success,
          borderColor: theme.success,
        }}>
          {successMessage}
        </div>
      )}

      {showError && errorMessage && (
        <div className="form_input_v2_error_message" style={{
          background: `linear-gradient(135deg, ${theme.error}20 0%, ${theme.error}10 100%)`,
          color: theme.error,
          borderColor: theme.error,
        }}>
          {errorMessage}
        </div>
      )}

      <button
        type="submit"
        disabled={loading || isSubmitting}
        className="form_input_v2_submit"
        style={{
          background: `linear-gradient(135deg, ${theme.primary} 0%, #7c3aed 100%)`,
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
