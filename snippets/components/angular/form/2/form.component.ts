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
  <button type="submit" [disabled]="isSubmitting || formGroup.invalid" [ngStyle]="submitButtonStyles">
  {{ isSubmitting ? 'Submitting...' : submitButtonText }}
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
  @Input() title: string = 'Contact Form';
  @Input() description: string = 'Please fill out the form below';
  @Input() fields: any[] = [
  { name: 'name', label: 'Full Name', required: true },
  { name: 'email', label: 'Email Address', type: 'email', required: true },
  { name: 'message', label: 'Message', required: true }
  ];
  @Input() submitButtonText: string = 'Submit';
  @Input() resetButtonText: string = 'Reset';
  @Input() successMessage: string = 'Form submitted successfully!';
  formGroup: FormGroup;
  isSubmitting: boolean = false;
  showSuccess: boolean = false;
  private defaultTheme: FormTheme = {
  primaryColor: '#3b82f6',
  secondaryColor: '#8b5cf6',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  textColor: '#111827',
  borderColor: '#e5e7eb',
  errorColor: '#ef4444',
  successColor: '#10b981'
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
  if (field?.errors?.['email']) return 'Please enter a valid email';
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
  borderRadius: '0.5rem',
  border: `1px solid ${this.appliedTheme.borderColor}`,
  maxWidth: '500px',
  margin: '0 auto'
  };
  }
  get headerStyles() {
  return {
  marginBottom: '1.5rem',
  textAlign: 'center'
  };
  }
  get titleStyles() {
  return {
  color: this.appliedTheme.primaryColor,
  fontSize: '1.5rem',
  fontWeight: '600',
  margin: '0 0 0.5rem 0'
  };
  }
  get descriptionStyles() {
  return {
  color: this.appliedTheme.textColor,
  fontSize: '0.875rem',
  margin: '0',
  opacity: '0.7'
  };
  }
  get fieldsContainerStyles() {
  return {
  display: 'flex',
  flexDirection: 'column',
  gap: '1rem'
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
  fontWeight: '500'
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
  padding: '0.75rem',
  border: `1px solid ${isInvalid ? this.appliedTheme.errorColor : this.appliedTheme.borderColor}`,
  borderRadius: '0.375rem',
  fontSize: '1rem',
  color: this.appliedTheme.textColor,
  outline: 'none',
  transition: 'border-color 0.2s'
  };
  }
  get errorStyles() {
  return {
  color: this.appliedTheme.errorColor,
  fontSize: '0.75rem',
  marginTop: '0.25rem'
  };
  }
  get successStyles() {
  return {
  backgroundColor: `${this.appliedTheme.successColor}15`,
  color: this.appliedTheme.successColor,
  padding: '0.75rem',
  borderRadius: '0.375rem',
  marginTop: '1rem',
  textAlign: 'center',
  fontSize: '0.875rem'
  };
  }
  get actionsStyles() {
  return {
  display: 'flex',
  gap: '1rem',
  marginTop: '1.5rem'
  };
  }
  get submitButtonStyles() {
  return {
  flex: '1',
  padding: '0.75rem',
  backgroundColor: this.appliedTheme.primaryColor,
  color: '#ffffff',
  border: 'none',
  borderRadius: '0.375rem',
  fontSize: '1rem',
  fontWeight: '500',
  cursor: this.isSubmitting || this.formGroup.invalid ? 'not-allowed' : 'pointer',
  opacity: this.isSubmitting || this.formGroup.invalid ? '0.6' : '1',
  transition: 'opacity 0.2s'
  };
  }
  get resetButtonStyles() {
  return {
  flex: '1',
  padding: '0.75rem',
  backgroundColor: 'transparent',
  backdropFilter: 'blur(10px)',
  color: this.appliedTheme.textColor,
  border: `1px solid ${this.appliedTheme.borderColor}`,
  borderRadius: '0.375rem',
  fontSize: '1rem',
  fontWeight: '500',
  cursor: 'pointer',
  transition: 'background-color 0.2s'
  };
  }
}
