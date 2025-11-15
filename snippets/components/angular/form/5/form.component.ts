import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
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
  standalone: true,
  imports: [CommonModule],
  selector: 'app-form',
  template: `
  <form [formGroup]="formGroup" (ngSubmit)="onSubmit()" [ngStyle]="formStyles">
  <div class="form-header" [ngStyle]="headerStyles">
  <h2 [ngStyle]="titleStyles">{{ title }}</h2>
  <p [ngStyle]="descriptionStyles">{{ description }}</p>
  </div>
  <div *ngIf="showSuccess" [ngStyle]="successStyles" role="status">
  {{ successMessage }}
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
  <div class="form-actions" [ngStyle]="actionsStyles">
  <button type="submit" [disabled]="isSubmitting || formGroup.invalid" [ngStyle]="submitButtonStyles">
  {{ isSubmitting ? 'Loading...' : submitButtonText }}
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
  @Input() title: string = 'Feedback Form';
  @Input() description: string = 'Share your thoughts with us';
  @Input() fields: unknown[] = [
  { name: 'name', label: 'Name', required: true },
  { name: 'email', label: 'Email', type: 'email', required: true },
  { name: 'rating', label: 'Rating', type: 'number', required: true },
  { name: 'comments', label: 'Comments', required: false }
  ];
  @Input() submitButtonText: string = 'Send Feedback';
  @Input() resetButtonText: string = 'Clear Form';
  @Input() successMessage: string = 'Thank you for your feedback!';
  formGroup: FormGroup;
  isSubmitting: boolean = false;
  showSuccess: boolean = false;
  private defaultTheme: FormTheme = {
  primaryColor: '#f59e0b',
  secondaryColor: '#d97706',
  backgroundColor: '#fffbeb',
  backdropFilter: 'blur(10px)',
  textColor: '#78350f',
  borderColor: '#fde68a',
  errorColor: '#b91c1c',
  successColor: '#15803d'
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
  const group: unknown = {};
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
  if (field?.errors?.['required']) return 'Required';
  if (field?.errors?.['email']) return 'Invalid email';
  return 'Invalid';
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
  border: `3px solid ${this.appliedTheme.primaryColor}`,
  maxWidth: '550px',
  margin: '0 auto'
  };
  }
  get headerStyles() {
  return {
  marginBottom: '1.5rem',
  textAlign: 'center',
  backgroundColor: this.appliedTheme.primaryColor,
  padding: '1rem',
  margin: '-2rem -2rem 1.5rem -2rem',
  borderRadius: '0.5rem 0.5rem 0 0'
  };
  }
  get titleStyles() {
  return {
  color: '#ffffff',
  fontSize: '1.5rem',
  fontWeight: '700',
  margin: '0 0 0.25rem 0'
  };
  }
  get descriptionStyles() {
  return {
  color: '#ffffff',
  fontSize: '0.875rem',
  margin: '0',
  opacity: '0.9'
  };
  }
  get fieldsContainerStyles() {
  return {
  display: 'grid',
  gridTemplateColumns: '1fr 1fr',
  gap: '1rem'
  };
  }
  get fieldGroupStyles() {
  return {
  display: 'flex',
  flexDirection: 'column',
  gap: '0.5rem',
  gridColumn: 'span 2'
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
  getInputStyles(fieldName: string) {
  const isInvalid = this.isFieldInvalid(fieldName);
  return {
  padding: '0.75rem',
  border: `2px solid ${isInvalid ? this.appliedTheme.errorColor : this.appliedTheme.borderColor}`,
  borderRadius: '0.375rem',
  fontSize: '1rem',
  color: this.appliedTheme.textColor,
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  outline: 'none',
  transition: 'border-color 0.2s'
  };
  }
  get errorStyles() {
  return {
  color: this.appliedTheme.errorColor,
  fontSize: '0.75rem',
  fontWeight: '600'
  };
  }
  get successStyles() {
  return {
  backgroundColor: this.appliedTheme.successColor,
  color: '#ffffff',
  padding: '0.875rem',
  borderRadius: '0.375rem',
  marginBottom: '1rem',
  textAlign: 'center',
  fontSize: '0.875rem',
  fontWeight: '600'
  };
  }
  get actionsStyles() {
  return {
  display: 'flex',
  gap: '1rem',
  marginTop: '1.5rem',
  gridColumn: 'span 2'
  };
  }
  get submitButtonStyles() {
  return {
  flex: '2',
  padding: '0.875rem',
  backgroundColor: this.appliedTheme.primaryColor,
  color: '#ffffff',
  border: 'none',
  borderRadius: '0.375rem',
  fontSize: '1rem',
  fontWeight: '600',
  cursor: this.isSubmitting || this.formGroup.invalid ? 'not-allowed' : 'pointer',
  opacity: this.isSubmitting || this.formGroup.invalid ? '0.5' : '1',
  transition: 'opacity 0.2s'
  };
  }
  get resetButtonStyles() {
  return {
  flex: '1',
  padding: '0.875rem',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  color: this.appliedTheme.textColor,
  border: `2px solid ${this.appliedTheme.borderColor}`,
  borderRadius: '0.375rem',
  fontSize: '1rem',
  fontWeight: '600',
  cursor: 'pointer',
  transition: 'all 0.2s'
  };
  }
}
