import React, { useState } from 'react';
import './form_input.css';

// Version 1: Classic Professional Form - Single Column Layout with Blue Theme

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
}

interface FormInputProps {
  onSubmit: (data: Record<string, any>) => void | Promise<void>;
  fields: FieldConfig[];
  loading?: boolean;
  submitText?: string;
  variant?: 'single' | 'compact';
  theme?: Partial<FormTheme>;
  successMessage?: string;
  errorMessage?: string;
}

const defaultTheme: FormTheme = {
  primary: '#2563eb',
  background: '#ffffff',
  border: '#d1d5db',
  text: '#1f2937',
  error: '#dc2626',
  success: '#16a34a',
};

export const FormInput: React.FC<FormInputProps> = ({
  onSubmit,
  fields,
  loading = false,
  submitText = 'Submit',
  variant = 'single',
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
    const field = fields.find(f => f.name === fieldName);
    if (field) {
      const error = validateField(field, formData[fieldName]);
      setErrors(prev => ({
        ...prev,
        [fieldName]: error || '',
      }));
    }
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
    const fieldId = `field-${field.name}`;

    switch (field.type) {
      case 'textarea':
        return (
          <div key={field.name} className="form_input_v1_field_group">
            <label htmlFor={fieldId} className="form_input_v1_label" style={{ color: theme.text }}>
              {field.label}
              {field.required && <span className="form_input_v1_required" style={{ color: theme.error }}>*</span>}
            </label>
            <textarea
              id={fieldId}
              value={formData[field.name]}
              onChange={(e) => handleChange(field.name, e.target.value)}
              onBlur={() => handleBlur(field.name)}
              placeholder={field.placeholder}
              disabled={loading || isSubmitting}
              className={`form_input_v1_field form_input_v1_textarea ${hasError ? 'error' : ''}`}
              style={{
                borderColor: hasError ? theme.error : theme.border,
                backgroundColor: theme.background,
                color: theme.text,
              }}
              aria-required={field.required}
              aria-invalid={!!hasError}
              aria-describedby={hasError ? `${fieldId}-error` : undefined}
            />
            {hasError && (
              <p id={`${fieldId}-error`} className="form_input_v1_error" style={{ color: theme.error }}>
                {errors[field.name]}
              </p>
            )}
          </div>
        );

      case 'select':
        return (
          <div key={field.name} className="form_input_v1_field_group">
            <label htmlFor={fieldId} className="form_input_v1_label" style={{ color: theme.text }}>
              {field.label}
              {field.required && <span className="form_input_v1_required" style={{ color: theme.error }}>*</span>}
            </label>
            <select
              id={fieldId}
              value={formData[field.name]}
              onChange={(e) => handleChange(field.name, e.target.value)}
              onBlur={() => handleBlur(field.name)}
              disabled={loading || isSubmitting}
              className={`form_input_v1_field form_input_v1_select ${hasError ? 'error' : ''}`}
              style={{
                borderColor: hasError ? theme.error : theme.border,
                backgroundColor: theme.background,
                color: theme.text,
              }}
              aria-required={field.required}
              aria-invalid={!!hasError}
              aria-describedby={hasError ? `${fieldId}-error` : undefined}
            >
              <option value="">Select {field.label}</option>
              {field.options?.map(option => (
                <option key={option.value} value={option.value}>
                  {option.label}
                </option>
              ))}
            </select>
            {hasError && (
              <p id={`${fieldId}-error`} className="form_input_v1_error" style={{ color: theme.error }}>
                {errors[field.name]}
              </p>
            )}
          </div>
        );

      case 'checkbox':
        return (
          <div key={field.name} className="form_input_v1_checkbox_group">
            <label className="form_input_v1_checkbox_label" style={{ color: theme.text }}>
              <input
                type="checkbox"
                checked={formData[field.name]}
                onChange={(e) => handleChange(field.name, e.target.checked)}
                onBlur={() => handleBlur(field.name)}
                disabled={loading || isSubmitting}
                className="form_input_v1_checkbox"
                style={{ accentColor: theme.primary }}
                aria-required={field.required}
              />
              <span>
                {field.label}
                {field.required && <span className="form_input_v1_required" style={{ color: theme.error }}>*</span>}
              </span>
            </label>
            {hasError && (
              <p className="form_input_v1_error" style={{ color: theme.error }}>
                {errors[field.name]}
              </p>
            )}
          </div>
        );

      case 'radio':
        return (
          <div key={field.name} className="form_input_v1_field_group">
            <label className="form_input_v1_label" style={{ color: theme.text }}>
              {field.label}
              {field.required && <span className="form_input_v1_required" style={{ color: theme.error }}>*</span>}
            </label>
            <div className="form_input_v1_radio_group">
              {field.options?.map(option => (
                <label key={option.value} className="form_input_v1_radio_label" style={{ color: theme.text }}>
                  <input
                    type="radio"
                    name={field.name}
                    value={option.value}
                    checked={formData[field.name] === option.value}
                    onChange={(e) => handleChange(field.name, e.target.value)}
                    onBlur={() => handleBlur(field.name)}
                    disabled={loading || isSubmitting}
                    className="form_input_v1_radio"
                    style={{ accentColor: theme.primary }}
                    aria-required={field.required}
                  />
                  <span>{option.label}</span>
                </label>
              ))}
            </div>
            {hasError && (
              <p className="form_input_v1_error" style={{ color: theme.error }}>
                {errors[field.name]}
              </p>
            )}
          </div>
        );

      default:
        return (
          <div key={field.name} className="form_input_v1_field_group">
            <label htmlFor={fieldId} className="form_input_v1_label" style={{ color: theme.text }}>
              {field.label}
              {field.required && <span className="form_input_v1_required" style={{ color: theme.error }}>*</span>}
            </label>
            <input
              id={fieldId}
              type={field.type}
              value={formData[field.name]}
              onChange={(e) => handleChange(field.name, e.target.value)}
              onBlur={() => handleBlur(field.name)}
              placeholder={field.placeholder}
              disabled={loading || isSubmitting}
              className={`form_input_v1_field ${hasError ? 'error' : ''}`}
              style={{
                borderColor: hasError ? theme.error : theme.border,
                backgroundColor: theme.background,
                color: theme.text,
              }}
              aria-required={field.required}
              aria-invalid={!!hasError}
              aria-describedby={hasError ? `${fieldId}-error` : undefined}
            />
            {hasError && (
              <p id={`${fieldId}-error`} className="form_input_v1_error" style={{ color: theme.error }}>
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
      className={`form_input_v1 form_input_v1_${variant}`}
      style={{ backgroundColor: theme.background }}
      noValidate
    >
      <div className="form_input_v1_fields">
        {fields.map(renderField)}
      </div>

      {showSuccess && successMessage && (
        <div className="form_input_v1_success" style={{ backgroundColor: `${theme.success}15`, color: theme.success, borderColor: theme.success }}>
          {successMessage}
        </div>
      )}

      {showError && errorMessage && (
        <div className="form_input_v1_error_message" style={{ backgroundColor: `${theme.error}15`, color: theme.error, borderColor: theme.error }}>
          {errorMessage}
        </div>
      )}

      <button
        type="submit"
        disabled={loading || isSubmitting}
        className="form_input_v1_submit"
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
