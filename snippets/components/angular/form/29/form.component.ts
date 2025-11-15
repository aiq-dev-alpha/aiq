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
  @Input() title: string = 'Form Variant 29';
  @Input() description: string = 'Unique form design 29';
  @Input() fields: any[] = [
    { name: 'field1', label: 'Field One', required: true },
    { name: 'field2', label: 'Field Two', type: 'email', required: true }
  ];
  @Input() submitButtonText: string = 'Submit';
  @Input() resetButtonText: string = 'Reset';
  @Input() successMessage: string = 'Form submitted!';

  formGroup: FormGroup;
  isSubmitting: boolean = false;
  showSuccess: boolean = false;

  private defaultTheme: FormTheme = {
    primaryColor: '#0891b2',
    secondaryColor: '#0e7490',
    backgroundColor: '#ecfeff',
    textColor: '#164e63',
    borderColor: '#a5f3fc',
    errorColor: '#e11d48',
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
      borderRadius: '9999px',
      border: `2px solid ${this.appliedTheme.borderColor}`,
      maxWidth: '500px',
      margin: '0 auto',
      boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)'
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
      fontWeight: '700',
      margin: '0 0 0.5rem 0'
    };
  }

  get descriptionStyles() {
    return {
      color: this.appliedTheme.textColor,
      fontSize: '0.875rem',
      margin: '0',
      opacity: '0.8'
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
      borderRadius: '9999px',
      fontSize: '1rem',
      color: this.appliedTheme.textColor,
      backgroundColor: '#ffffff',
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
      backgroundColor: `${this.appliedTheme.successColor}20`,
      color: this.appliedTheme.successColor,
      padding: '0.875rem',
      borderRadius: '9999px',
      marginTop: '1rem',
      textAlign: 'center',
      fontSize: '0.875rem',
      fontWeight: '600',
      border: `2px solid ${this.appliedTheme.successColor}`
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
      padding: '0.875rem',
      backgroundColor: this.appliedTheme.primaryColor,
      color: '#ffffff',
      border: 'none',
      borderRadius: '9999px',
      fontSize: '1rem',
      fontWeight: '600',
      cursor: this.isSubmitting || this.formGroup.invalid ? 'not-allowed' : 'pointer',
      opacity: this.isSubmitting || this.formGroup.invalid ? '0.6' : '1',
      transition: 'opacity 0.2s'
    };
  }

  get resetButtonStyles() {
    return {
      flex: '1',
      padding: '0.875rem',
      backgroundColor: 'transparent',
      color: this.appliedTheme.textColor,
      border: `2px solid ${this.appliedTheme.borderColor}`,
      borderRadius: '9999px',
      fontSize: '1rem',
      fontWeight: '600',
      cursor: 'pointer',
      transition: 'all 0.2s'
    };
  }
}
