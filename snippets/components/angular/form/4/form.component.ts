import { Component, Input } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';

interface FormTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  errorColor: string;
  successColor: string;
}

@Component({
  selector: 'app-form',
  template: `
  <form [formGroup]="formGroup" (ngSubmit)="onSubmit()" [ngStyle]="formStyles">
  <div class="form-header" [ngStyle]="headerStyles">
  <h2 [ngStyle]="titleStyles">{{ title }}</h2>
  <p [ngStyle]="descriptionStyles">{{ description }}</p>
  </div>

  <div class="form-fields" [ngStyle]="fieldsContainerStyles">
  <div class="field-group" *ngFor="let field of fields" [ngStyle]="fieldGroupStyles">
  <label [for]="field.name" [ngStyle]="labelStyles">
  {{ field.label }}
  <span *ngIf="field.required" [ngStyle]="requiredStyles">*</span>
  </label>
  <div [ngStyle]="inputWrapperStyles">
  <input
  [id]="field.name"
  [type]="field.type || 'text'"
  [formControlName]="field.name"
  [ngStyle]="getInputStyles(field.name)"
  [attr.aria-describedby]="field.name + '-error'"
  [attr.aria-invalid]="isFieldInvalid(field.name)"
  />
  <div
  *ngIf="isFieldInvalid(field.name)"
  [id]="field.name + '-error'"
  role="alert"
  [ngStyle]="errorTooltipStyles"
  >
  {{ getErrorMessage(field.name) }}
  </div>
  </div>
  </div>
  </div>

  <div *ngIf="showSuccess" [ngStyle]="successStyles" role="status">
  {{ successMessage }}
  </div>

  <div class="form-actions" [ngStyle]="actionsStyles">
  <button type="submit" [disabled]="isSubmitting || formGroup.invalid" [ngStyle]="submitButtonStyles">
  {{ isSubmitting ? 'Processing...' : submitButtonText }}
  </button>
  <button type="button" (click)="onReset()" [ngStyle]="resetButtonStyles">
  {{ resetButtonText }}
  </button>
  </div>
  </form>
  `
})
export class FormComponent {
  @Input() theme: Partial<FormTheme> = {};
  @Input() title: string = 'Login Form';
  @Input() description: string = 'Sign in to your account';
  @Input() fields: any[] = [
  { name: 'email', label: 'Email Address', type: 'email', required: true },
  { name: 'password', label: 'Password', type: 'password', required: true }
  ];
  @Input() submitButtonText: string = 'Sign In';
  @Input() resetButtonText: string = 'Cancel';
  @Input() successMessage: string = 'Login successful!';

  formGroup: FormGroup;
  isSubmitting: boolean = false;
  showSuccess: boolean = false;

  private defaultTheme: FormTheme = {
  primaryColor: '#8b5cf6',
  secondaryColor: '#7c3aed',
  backgroundColor: '#faf5ff',
  backdropFilter: 'blur(10px)',
  textColor: '#1e1b4b',
  borderColor: '#c4b5fd',
  errorColor: '#f43f5e',
  successColor: '#22c55e'
  };

  constructor(private fb: FormBuilder) {
  this.formGroup = this.fb.group({});
  }

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
  group[field.name] = ['', validators];
  });
  this.formGroup = this.fb.group(group);
  }

  isFieldInvalid(fieldName: string): boolean {
  const field = this.formGroup.get(fieldName);
  return !!(field && field.invalid && field.touched);
  }

  getErrorMessage(fieldName: string): string {
  const field = this.formGroup.get(fieldName);
  if (field?.errors?.['required']) return 'This field is required';
  if (field?.errors?.['email']) return 'Invalid email format';
  return 'Invalid input';
  }

  onSubmit() {
  if (this.formGroup.valid) {
  this.isSubmitting = true;
  setTimeout(() => {
  this.isSubmitting = false;
  this.showSuccess = true;
  setTimeout(() => this.showSuccess = false, 3000);
  }, 1000);
  }
  }

  onReset() {
  this.formGroup.reset();
  this.showSuccess = false;
  }

  get formStyles() {
  return {
  backgroundColor: this.appliedTheme.backgroundColor,
  padding: '2rem',
  borderRadius: '1rem',
  border: 'none',
  maxWidth: '450px',
  margin: '0 auto',
  boxShadow: '0 10px 25px rgba(0, 0, 0, 0.15)'
  };
  }

  get headerStyles() {
  return {
  marginBottom: '2rem',
  textAlign: 'center'
  };
  }

  get titleStyles() {
  return {
  color: this.appliedTheme.primaryColor,
  fontSize: '2rem',
  fontWeight: '700',
  margin: '0 0 0.5rem 0'
  };
  }

  get descriptionStyles() {
  return {
  color: this.appliedTheme.textColor,
  fontSize: '0.875rem',
  margin: '0'
  };
  }

  get fieldsContainerStyles() {
  return {
  display: 'flex',
  flexDirection: 'column',
  gap: '1.5rem'
  };
  }

  get fieldGroupStyles() {
  return {
  display: 'flex',
  flexDirection: 'column',
  gap: '0.5rem'
  };
  }

  get labelStyles() {
  return {
  color: this.appliedTheme.textColor,
  fontSize: '0.875rem',
  fontWeight: '600'
  };
  }

  get requiredStyles() {
  return {
  color: this.appliedTheme.errorColor,
  marginLeft: '0.25rem'
  };
  }

  get inputWrapperStyles() {
  return {
  position: 'relative'
  };
  }

  getInputStyles(fieldName: string) {
  const isInvalid = this.isFieldInvalid(fieldName);
  return {
  width: '100%',
  padding: '0.875rem 1rem',
  border: `2px solid ${isInvalid ? this.appliedTheme.errorColor : this.appliedTheme.borderColor}`,
  borderRadius: '0.5rem',
  fontSize: '1rem',
  color: this.appliedTheme.textColor,
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  outline: 'none',
  transition: 'border-color 0.2s',
  boxSizing: 'border-box'
  };
  }

  get errorTooltipStyles() {
  return {
  position: 'absolute',
  top: '100%',
  left: '0',
  marginTop: '0.5rem',
  padding: '0.5rem 0.75rem',
  backgroundColor: this.appliedTheme.errorColor,
  color: '#ffffff',
  fontSize: '0.75rem',
  borderRadius: '0.375rem',
  boxShadow: '0 2px 8px rgba(0, 0, 0, 0.15)',
  zIndex: '10',
  whiteSpace: 'nowrap'
  };
  }

  get successStyles() {
  return {
  backgroundColor: `${this.appliedTheme.successColor}20`,
  color: this.appliedTheme.successColor,
  padding: '1rem',
  borderRadius: '0.5rem',
  marginTop: '1.5rem',
  textAlign: 'center',
  fontSize: '0.875rem',
  fontWeight: '600',
  border: `2px solid ${this.appliedTheme.successColor}`
  };
  }

  get actionsStyles() {
  return {
  display: 'flex',
  flexDirection: 'column',
  gap: '0.75rem',
  marginTop: '2rem'
  };
  }

  get submitButtonStyles() {
  return {
  width: '100%',
  padding: '1rem',
  backgroundColor: this.appliedTheme.primaryColor,
  color: '#ffffff',
  border: 'none',
  borderRadius: '0.5rem',
  fontSize: '1rem',
  fontWeight: '600',
  cursor: this.isSubmitting || this.formGroup.invalid ? 'not-allowed' : 'pointer',
  opacity: this.isSubmitting || this.formGroup.invalid ? '0.6' : '1',
  transition: 'opacity 0.2s'
  };
  }

  get resetButtonStyles() {
  return {
  width: '100%',
  padding: '1rem',
  backgroundColor: 'transparent',
  backdropFilter: 'blur(10px)',
  color: this.appliedTheme.primaryColor,
  border: `2px solid ${this.appliedTheme.primaryColor}`,
  borderRadius: '0.5rem',
  fontSize: '1rem',
  fontWeight: '600',
  cursor: 'pointer',
  transition: 'all 0.2s'
  };
  }
}
