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
  <input
  [id]="field.name"
  [type]="field.type || 'text'"
  [formControlName]="field.name"
  [ngStyle]="getInputStyles(field.name)"
  [attr.aria-describedby]="field.name + '-error'"
  [attr.aria-invalid]="isFieldInvalid(field.name)"
  [placeholder]="field.placeholder || ''"
  />
  <div
  *ngIf="isFieldInvalid(field.name)"
  [id]="field.name + '-error'"
  role="alert"
  [ngStyle]="errorStyles"
  >
  {{ getErrorMessage(field.name) }}
  </div>
  </div>
  </div>

  <div *ngIf="showSuccess" [ngStyle]="successStyles" role="status">
  {{ successMessage }}
  </div>

  <div class="form-actions" [ngStyle]="actionsStyles">
  <button type="button" (click)="onReset()" [ngStyle]="resetButtonStyles">
  {{ resetButtonText }}
  </button>
  <button type="submit" [disabled]="isSubmitting || formGroup.invalid" [ngStyle]="submitButtonStyles">
  {{ isSubmitting ? 'Submitting...' : submitButtonText }}
  </button>
  </div>
  </form>
  `
})
export class FormComponent {
  @Input() theme: Partial<FormTheme> = {};
  @Input() title: string = 'Registration Form';
  @Input() description: string = 'Create your account';
  @Input() fields: any[] = [
  { name: 'username', label: 'Username', required: true, placeholder: 'Enter username' },
  { name: 'email', label: 'Email', type: 'email', required: true, placeholder: 'your@email.com' },
  { name: 'password', label: 'Password', type: 'password', required: true }
  ];
  @Input() submitButtonText: string = 'Register';
  @Input() resetButtonText: string = 'Clear';
  @Input() successMessage: string = 'Registration successful!';

  formGroup: FormGroup;
  isSubmitting: boolean = false;
  showSuccess: boolean = false;

  private defaultTheme: FormTheme = {
  primaryColor: '#10b981',
  secondaryColor: '#059669',
  backgroundColor: '#f9fafb',
  backdropFilter: 'blur(10px)',
  textColor: '#1f2937',
  borderColor: '#d1d5db',
  errorColor: '#dc2626',
  successColor: '#059669'
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
  if (field?.errors?.['required']) return 'Required field';
  if (field?.errors?.['email']) return 'Invalid email address';
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
  padding: '2.5rem',
  borderRadius: '0.75rem',
  border: `2px solid ${this.appliedTheme.borderColor}`,
  maxWidth: '600px',
  margin: '0 auto',
  boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)'
  };
  }

  get headerStyles() {
  return {
  marginBottom: '2rem',
  textAlign: 'left',
  borderBottom: `2px solid ${this.appliedTheme.primaryColor}`,
  paddingBottom: '1rem'
  };
  }

  get titleStyles() {
  return {
  color: this.appliedTheme.primaryColor,
  fontSize: '1.75rem',
  fontWeight: '700',
  margin: '0 0 0.5rem 0'
  };
  }

  get descriptionStyles() {
  return {
  color: this.appliedTheme.textColor,
  fontSize: '0.9375rem',
  margin: '0',
  opacity: '0.8'
  };
  }

  get fieldsContainerStyles() {
  return {
  display: 'flex',
  flexDirection: 'column',
  gap: '1.25rem'
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
  fontWeight: '600',
  textTransform: 'uppercase',
  letterSpacing: '0.025em'
  };
  }

  get requiredStyles() {
  return {
  color: this.appliedTheme.errorColor,
  marginLeft: '0.25rem'
  };
  }

  getInputStyles(fieldName: string) {
  const isInvalid = this.isFieldInvalid(fieldName);
  return {
  padding: '0.875rem',
  border: `2px solid ${isInvalid ? this.appliedTheme.errorColor : this.appliedTheme.borderColor}`,
  borderRadius: '0.5rem',
  fontSize: '1rem',
  color: this.appliedTheme.textColor,
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  outline: 'none',
  transition: 'all 0.2s',
  boxShadow: isInvalid ? `0 0 0 3px ${this.appliedTheme.errorColor}20` : 'none'
  };
  }

  get errorStyles() {
  return {
  color: this.appliedTheme.errorColor,
  fontSize: '0.8125rem',
  fontWeight: '500',
  display: 'flex',
  alignItems: 'center',
  gap: '0.25rem'
  };
  }

  get successStyles() {
  return {
  backgroundColor: this.appliedTheme.successColor,
  color: '#ffffff',
  padding: '1rem',
  borderRadius: '0.5rem',
  marginTop: '1.25rem',
  textAlign: 'center',
  fontSize: '0.9375rem',
  fontWeight: '500'
  };
  }

  get actionsStyles() {
  return {
  display: 'flex',
  gap: '1rem',
  marginTop: '2rem',
  justifyContent: 'flex-end'
  };
  }

  get submitButtonStyles() {
  return {
  padding: '0.875rem 2rem',
  backgroundColor: this.appliedTheme.primaryColor,
  color: '#ffffff',
  border: 'none',
  borderRadius: '0.5rem',
  fontSize: '1rem',
  fontWeight: '600',
  cursor: this.isSubmitting || this.formGroup.invalid ? 'not-allowed' : 'pointer',
  opacity: this.isSubmitting || this.formGroup.invalid ? '0.5' : '1',
  transition: 'all 0.2s',
  boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)'
  };
  }

  get resetButtonStyles() {
  return {
  padding: '0.875rem 2rem',
  backgroundColor: 'transparent',
  backdropFilter: 'blur(10px)',
  color: this.appliedTheme.textColor,
  border: `2px solid ${this.appliedTheme.borderColor}`,
  borderRadius: '0.5rem',
  fontSize: '1rem',
  fontWeight: '600',
  cursor: 'pointer',
  transition: 'all 0.2s'
  };
  }
}
