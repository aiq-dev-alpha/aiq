import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormGroup, FormBuilder, Validators, AbstractControl, ValidationErrors } from '@angular/forms';

interface FormField {
  name: string;
  label: string;
  type: 'text' | 'email' | 'password' | 'number' | 'tel' | 'url' | 'textarea' | 'select' | 'checkbox' | 'radio';
  placeholder?: string;
  required?: boolean;
  options?: Array<{ label: string; value: string | number }>;
  validation?: {
    minLength?: number;
    maxLength?: number;
    pattern?: string;
    min?: number;
    max?: number;
    custom?: (control: AbstractControl) => ValidationErrors | null;
  };
}

interface FormTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  errorColor: string;
  successColor: string;
  focusColor: string;
}

@Component({
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule],
  selector: 'app-form',
  template: `
  <div class="form-wrapper" [ngStyle]="wrapperStyles">
    <form [formGroup]="formGroup" (ngSubmit)="handleSubmit()" [ngStyle]="formStyles" class="wizard-form">
      <!-- Progress Bar -->
      <div *ngIf="showProgress" class="progress-bar" [ngStyle]="progressBarStyles">
        <div class="progress-fill" [ngStyle]="progressFillStyles"></div>
      </div>

      <!-- Header -->
      <div class="form-header" [ngStyle]="headerStyles">
        <div class="header-icon" [ngStyle]="iconStyles">
          <span class="icon-glyph">✨</span>
        </div>
        <h2 class="form-title" [ngStyle]="titleStyles">{{ title }}</h2>
        <p *ngIf="description" class="form-description" [ngStyle]="descriptionStyles">{{ description }}</p>
      </div>

      <!-- Fields Container -->
      <div class="fields-wrapper" [ngStyle]="fieldsWrapperStyles">
        <div *ngFor="let field of fields" class="field-container" [ngStyle]="fieldContainerStyles">
          <!-- Text/Email/Password/Number/Tel/URL -->
          <ng-container *ngIf="['text', 'email', 'password', 'number', 'tel', 'url'].includes(field.type)">
            <label [for]="field.name" class="field-label" [ngStyle]="labelStyles">
              {{ field.label }}
              <span *ngIf="field.required" class="required-mark" [ngStyle]="requiredMarkStyles">*</span>
            </label>
            <div class="input-wrapper" [ngStyle]="inputWrapperStyles">
              <input
                [id]="field.name"
                [type]="field.type"
                [formControlName]="field.name"
                [placeholder]="field.placeholder || ''"
                [ngStyle]="getInputStyles(field.name)"
                class="form-input"
                [attr.aria-invalid]="isFieldInvalid(field.name)"
                [attr.aria-describedby]="field.name + '-error'"
              />
              <span *ngIf="isFieldValid(field.name)" class="validity-icon success" [ngStyle]="validIconStyles">✓</span>
              <span *ngIf="isFieldInvalid(field.name)" class="validity-icon error" [ngStyle]="invalidIconStyles">✗</span>
            </div>
            <div
              *ngIf="isFieldInvalid(field.name)"
              [id]="field.name + '-error'"
              class="error-message"
              [ngStyle]="errorMessageStyles"
              role="alert"
            >
              {{ getErrorMessage(field.name, field) }}
            </div>
          </ng-container>

          <!-- Textarea -->
          <ng-container *ngIf="field.type === 'textarea'">
            <label [for]="field.name" class="field-label" [ngStyle]="labelStyles">
              {{ field.label }}
              <span *ngIf="field.required" class="required-mark" [ngStyle]="requiredMarkStyles">*</span>
            </label>
            <textarea
              [id]="field.name"
              [formControlName]="field.name"
              [placeholder]="field.placeholder || ''"
              [ngStyle]="getTextareaStyles(field.name)"
              class="form-textarea"
              rows="4"
              [attr.aria-invalid]="isFieldInvalid(field.name)"
              [attr.aria-describedby]="field.name + '-error'"
            ></textarea>
            <div
              *ngIf="isFieldInvalid(field.name)"
              [id]="field.name + '-error'"
              class="error-message"
              [ngStyle]="errorMessageStyles"
              role="alert"
            >
              {{ getErrorMessage(field.name, field) }}
            </div>
          </ng-container>

          <!-- Select -->
          <ng-container *ngIf="field.type === 'select'">
            <label [for]="field.name" class="field-label" [ngStyle]="labelStyles">
              {{ field.label }}
              <span *ngIf="field.required" class="required-mark" [ngStyle]="requiredMarkStyles">*</span>
            </label>
            <select
              [id]="field.name"
              [formControlName]="field.name"
              [ngStyle]="getSelectStyles(field.name)"
              class="form-select"
              [attr.aria-invalid]="isFieldInvalid(field.name)"
              [attr.aria-describedby]="field.name + '-error'"
            >
              <option value="">Select an option</option>
              <option *ngFor="let option of field.options" [value]="option.value">{{ option.label }}</option>
            </select>
            <div
              *ngIf="isFieldInvalid(field.name)"
              [id]="field.name + '-error'"
              class="error-message"
              [ngStyle]="errorMessageStyles"
              role="alert"
            >
              {{ getErrorMessage(field.name, field) }}
            </div>
          </ng-container>

          <!-- Checkbox -->
          <ng-container *ngIf="field.type === 'checkbox'">
            <label class="checkbox-label" [ngStyle]="checkboxLabelStyles">
              <input
                [id]="field.name"
                type="checkbox"
                [formControlName]="field.name"
                [ngStyle]="checkboxStyles"
                class="form-checkbox"
              />
              <span class="checkbox-text">{{ field.label }}</span>
              <span *ngIf="field.required" class="required-mark" [ngStyle]="requiredMarkStyles">*</span>
            </label>
          </ng-container>
        </div>
      </div>

      <!-- Success Message -->
      <div *ngIf="showSuccess" class="success-banner" [ngStyle]="successBannerStyles" role="status">
        <span class="success-icon">✓</span>
        {{ successMessage }}
      </div>

      <!-- Global Error Message -->
      <div *ngIf="globalError" class="error-banner" [ngStyle]="errorBannerStyles" role="alert">
        <span class="error-icon">⚠</span>
        {{ globalError }}
      </div>

      <!-- Actions -->
      <div class="form-actions" [ngStyle]="actionsStyles">
        <button
          type="button"
          (click)="handleReset()"
          [ngStyle]="resetButtonStyles"
          class="reset-button"
          [disabled]="isSubmitting"
        >
          Reset
        </button>
        <button
          type="submit"
          [ngStyle]="submitButtonStyles"
          class="submit-button"
          [disabled]="formGroup.invalid || isSubmitting"
        >
          <span *ngIf="!isSubmitting">{{ submitButtonText }}</span>
          <span *ngIf="isSubmitting" class="spinner" [ngStyle]="spinnerStyles"></span>
          <span *ngIf="isSubmitting">{{ submittingText }}</span>
        </button>
      </div>
    </form>
  </div>
  `,
  styles: [`
  .form-wrapper {
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    padding: 2rem;
  }
  .wizard-form {
    width: 100%;
    max-width: 600px;
    position: relative;
  }
  .progress-bar {
    height: 6px;
    border-radius: 10px;
    overflow: hidden;
    margin-bottom: 2rem;
  }
  .progress-fill {
    height: 100%;
    transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  }
  .form-header {
    text-align: center;
    margin-bottom: 2.5rem;
  }
  .header-icon {
    width: 70px;
    height: 70px;
    margin: 0 auto 1rem;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    animation: floatIcon 3s ease-in-out infinite;
  }
  @keyframes floatIcon {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-10px); }
  }
  .icon-glyph {
    font-size: 2rem;
  }
  .form-title {
    margin: 0 0 0.75rem 0;
    font-size: 2rem;
    font-weight: 800;
    line-height: 1.2;
  }
  .form-description {
    margin: 0;
    font-size: 1rem;
    opacity: 0.8;
    line-height: 1.6;
  }
  .fields-wrapper {
    display: flex;
    flex-direction: column;
  }
  .field-container {
    margin-bottom: 1.75rem;
  }
  .field-label {
    display: block;
    margin-bottom: 0.5rem;
    font-size: 0.95rem;
    font-weight: 600;
  }
  .required-mark {
    margin-left: 0.25rem;
  }
  .input-wrapper {
    position: relative;
  }
  .form-input,
  .form-textarea,
  .form-select {
    width: 100%;
    padding: 0.875rem 1rem;
    font-size: 1rem;
    font-family: inherit;
    border-radius: 10px;
    outline: none;
    transition: all 0.3s ease;
  }
  .form-input:focus,
  .form-textarea:focus,
  .form-select:focus {
    transform: translateY(-2px);
  }
  .form-textarea {
    resize: vertical;
    min-height: 100px;
  }
  .validity-icon {
    position: absolute;
    right: 1rem;
    top: 50%;
    transform: translateY(-50%);
    font-size: 1.25rem;
    font-weight: bold;
    animation: iconPop 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  }
  @keyframes iconPop {
    0% { transform: translateY(-50%) scale(0); }
    100% { transform: translateY(-50%) scale(1); }
  }
  .error-message {
    margin-top: 0.5rem;
    font-size: 0.875rem;
    font-weight: 500;
    animation: slideDown 0.3s ease;
  }
  @keyframes slideDown {
    from { opacity: 0; transform: translateY(-10px); }
    to { opacity: 1; transform: translateY(0); }
  }
  .checkbox-label {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    cursor: pointer;
    font-size: 1rem;
  }
  .form-checkbox {
    width: 1.25rem;
    height: 1.25rem;
    cursor: pointer;
  }
  .success-banner,
  .error-banner {
    padding: 1rem 1.25rem;
    border-radius: 10px;
    margin-bottom: 1.5rem;
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    animation: slideDown 0.3s ease;
  }
  .success-icon,
  .error-icon {
    font-size: 1.25rem;
    font-weight: bold;
  }
  .form-actions {
    display: flex;
    gap: 1rem;
    margin-top: 2rem;
  }
  .reset-button,
  .submit-button {
    flex: 1;
    padding: 1rem 1.5rem;
    font-size: 1rem;
    font-weight: 600;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
  }
  .submit-button:not(:disabled):hover {
    transform: translateY(-2px);
  }
  .reset-button:not(:disabled):hover {
    transform: translateY(-2px);
  }
  .submit-button:disabled,
  .reset-button:disabled {
    cursor: not-allowed;
    opacity: 0.6;
  }
  .spinner {
    width: 16px;
    height: 16px;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-top-color: #ffffff;
    border-radius: 50%;
    animation: spin 0.6s linear infinite;
  }
  @keyframes spin {
    to { transform: rotate(360deg); }
  }
  `]
})
export class FormComponent {
  @Input() theme: Partial<FormTheme> = {};
  @Input() title = 'Wizard Form';
  @Input() description = 'Fill in the details below to continue';
  @Input() fields: FormField[] = [];
  @Input() submitButtonText = 'Submit';
  @Input() submittingText = 'Submitting...';
  @Input() successMessage = 'Form submitted successfully!';
  @Input() showProgress = true;

  @Output() submitted = new EventEmitter<any>();
  @Output() resetted = new EventEmitter<void>();

  formGroup!: FormGroup;
  isSubmitting = false;
  showSuccess = false;
  globalError = '';

  private defaultTheme: FormTheme = {
    primaryColor: '#8b5cf6',
    secondaryColor: '#a78bfa',
    backgroundColor: '#ffffff',
    textColor: '#1f2937',
    borderColor: '#e5e7eb',
    errorColor: '#ef4444',
    successColor: '#10b981',
    focusColor: '#8b5cf6'
  };

  constructor(private fb: FormBuilder) {}

  ngOnInit() {
    this.initializeForm();
  }

  get appliedTheme(): FormTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  initializeForm() {
    const group: any = {};
    this.fields.forEach(field => {
      const validators = [];
      if (field.required) validators.push(Validators.required);
      if (field.type === 'email') validators.push(Validators.email);
      if (field.validation?.minLength) validators.push(Validators.minLength(field.validation.minLength));
      if (field.validation?.maxLength) validators.push(Validators.maxLength(field.validation.maxLength));
      if (field.validation?.pattern) validators.push(Validators.pattern(field.validation.pattern));
      if (field.validation?.min !== undefined) validators.push(Validators.min(field.validation.min));
      if (field.validation?.max !== undefined) validators.push(Validators.max(field.validation.max));
      if (field.validation?.custom) validators.push(field.validation.custom);

      group[field.name] = [field.type === 'checkbox' ? false : '', validators];
    });
    this.formGroup = this.fb.group(group);
  }

  isFieldValid(fieldName: string): boolean {
    const field = this.formGroup.get(fieldName);
    return !!(field && field.valid && field.touched && field.value);
  }

  isFieldInvalid(fieldName: string): boolean {
    const field = this.formGroup.get(fieldName);
    return !!(field && field.invalid && field.touched);
  }

  getErrorMessage(fieldName: string, field: FormField): string {
    const control = this.formGroup.get(fieldName);
    if (!control?.errors) return '';

    if (control.errors['required']) return `${field.label} is required`;
    if (control.errors['email']) return 'Please enter a valid email address';
    if (control.errors['minlength']) return `Minimum ${control.errors['minlength'].requiredLength} characters required`;
    if (control.errors['maxlength']) return `Maximum ${control.errors['maxlength'].requiredLength} characters allowed`;
    if (control.errors['min']) return `Minimum value is ${control.errors['min'].min}`;
    if (control.errors['max']) return `Maximum value is ${control.errors['max'].max}`;
    if (control.errors['pattern']) return 'Please enter a valid format';

    return 'Invalid input';
  }

  handleSubmit() {
    if (this.formGroup.valid && !this.isSubmitting) {
      this.isSubmitting = true;
      this.globalError = '';

      setTimeout(() => {
        this.isSubmitting = false;
        this.showSuccess = true;
        this.submitted.emit(this.formGroup.value);

        setTimeout(() => {
          this.showSuccess = false;
          this.formGroup.reset();
        }, 3000);
      }, 2000);
    } else {
      this.formGroup.markAllAsTouched();
      this.globalError = 'Please fix the errors above before submitting';
    }
  }

  handleReset() {
    this.formGroup.reset();
    this.showSuccess = false;
    this.globalError = '';
    this.resetted.emit();
  }

  get completionPercentage(): number {
    const totalFields = this.fields.length;
    const validFields = this.fields.filter(field => {
      const control = this.formGroup.get(field.name);
      return control && control.valid && control.value;
    }).length;
    return (validFields / totalFields) * 100;
  }

  get wrapperStyles() {
    const t = this.appliedTheme;
    return {
      background: `linear-gradient(135deg, ${t.primaryColor}10 0%, ${t.secondaryColor}15 100%)`,
      minHeight: '100vh'
    };
  }

  get formStyles() {
    const t = this.appliedTheme;
    return {
      backgroundColor: t.backgroundColor,
      padding: '2.5rem',
      borderRadius: '20px',
      boxShadow: `0 20px 60px rgba(139, 92, 246, 0.15)`,
      border: `1px solid ${t.borderColor}`
    };
  }

  get progressBarStyles() {
    const t = this.appliedTheme;
    return {
      backgroundColor: `${t.primaryColor}20`
    };
  }

  get progressFillStyles() {
    const t = this.appliedTheme;
    return {
      width: `${this.completionPercentage}%`,
      background: `linear-gradient(90deg, ${t.primaryColor}, ${t.secondaryColor})`
    };
  }

  get headerStyles() {
    return {};
  }

  get iconStyles() {
    const t = this.appliedTheme;
    return {
      background: `linear-gradient(135deg, ${t.primaryColor}, ${t.secondaryColor})`,
      boxShadow: `0 10px 30px ${t.primaryColor}40`
    };
  }

  get titleStyles() {
    const t = this.appliedTheme;
    return {
      color: t.textColor,
      background: `linear-gradient(135deg, ${t.primaryColor}, ${t.secondaryColor})`,
      WebkitBackgroundClip: 'text',
      WebkitTextFillColor: 'transparent',
      backgroundClip: 'text'
    };
  }

  get descriptionStyles() {
    const t = this.appliedTheme;
    return {
      color: t.textColor
    };
  }

  get fieldsWrapperStyles() {
    return {};
  }

  get fieldContainerStyles() {
    return {};
  }

  get labelStyles() {
    const t = this.appliedTheme;
    return {
      color: t.textColor
    };
  }

  get requiredMarkStyles() {
    const t = this.appliedTheme;
    return {
      color: t.errorColor
    };
  }

  get inputWrapperStyles() {
    return {};
  }

  getInputStyles(fieldName: string) {
    const t = this.appliedTheme;
    const isInvalid = this.isFieldInvalid(fieldName);
    const isValid = this.isFieldValid(fieldName);

    return {
      border: `2px solid ${isInvalid ? t.errorColor : isValid ? t.successColor : t.borderColor}`,
      backgroundColor: `${isInvalid ? t.errorColor : isValid ? t.successColor : t.primaryColor}05`,
      color: t.textColor,
      paddingRight: (isValid || isInvalid) ? '3rem' : '1rem'
    };
  }

  getTextareaStyles(fieldName: string) {
    const t = this.appliedTheme;
    const isInvalid = this.isFieldInvalid(fieldName);
    const isValid = this.isFieldValid(fieldName);

    return {
      border: `2px solid ${isInvalid ? t.errorColor : isValid ? t.successColor : t.borderColor}`,
      backgroundColor: `${isInvalid ? t.errorColor : isValid ? t.successColor : t.primaryColor}05`,
      color: t.textColor
    };
  }

  getSelectStyles(fieldName: string) {
    const t = this.appliedTheme;
    const isInvalid = this.isFieldInvalid(fieldName);

    return {
      border: `2px solid ${isInvalid ? t.errorColor : t.borderColor}`,
      backgroundColor: `${t.primaryColor}05`,
      color: t.textColor
    };
  }

  get checkboxLabelStyles() {
    const t = this.appliedTheme;
    return {
      color: t.textColor
    };
  }

  get checkboxStyles() {
    const t = this.appliedTheme;
    return {
      accentColor: t.primaryColor
    };
  }

  get validIconStyles() {
    const t = this.appliedTheme;
    return {
      color: t.successColor
    };
  }

  get invalidIconStyles() {
    const t = this.appliedTheme;
    return {
      color: t.errorColor
    };
  }

  get errorMessageStyles() {
    const t = this.appliedTheme;
    return {
      color: t.errorColor
    };
  }

  get successBannerStyles() {
    const t = this.appliedTheme;
    return {
      backgroundColor: `${t.successColor}15`,
      color: t.successColor,
      border: `1px solid ${t.successColor}30`
    };
  }

  get errorBannerStyles() {
    const t = this.appliedTheme;
    return {
      backgroundColor: `${t.errorColor}15`,
      color: t.errorColor,
      border: `1px solid ${t.errorColor}30`
    };
  }

  get actionsStyles() {
    return {};
  }

  get resetButtonStyles() {
    const t = this.appliedTheme;
    return {
      backgroundColor: 'transparent',
      color: t.textColor,
      border: `2px solid ${t.borderColor}`
    };
  }

  get submitButtonStyles() {
    const t = this.appliedTheme;
    return {
      background: `linear-gradient(135deg, ${t.primaryColor}, ${t.secondaryColor})`,
      color: '#ffffff',
      boxShadow: `0 10px 25px ${t.primaryColor}40`
    };
  }

  get spinnerStyles() {
    return {};
  }
}
