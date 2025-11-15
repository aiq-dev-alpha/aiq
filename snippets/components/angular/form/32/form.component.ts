import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormGroup } from '@angular/forms';

interface FieldTheme {
  colors: {
    primary: string;
    secondary: string;
    success: string;
    error: string;
    warning: string;
  };
  spacing: {
    field: string;
    input: string;
  };
  typography: {
    labelSize: string;
    inputSize: string;
    helperSize: string;
  };
  borders: {
    radius: string;
    width: string;
    style: string;
  };
}

type FormStyle = 'outlined' | 'filled' | 'underlined' | 'floating';

@Component({
  selector: 'app-form',
  template: `
    <form [formGroup]="formData" [ngStyle]="containerStyles" [ngClass]="styleClass" (ngSubmit)="onSubmit($event)">
      <header *ngIf="heading" class="form-heading">
        <h3 class="heading-text">{{ heading }}</h3>
        <p *ngIf="subheading" class="subheading-text">{{ subheading }}</p>
      </header>

      <div class="form-fields">
        <ng-content></ng-content>
      </div>

      <aside *ngIf="helpText" class="form-help">
        {{ helpText }}
      </aside>

      <div *ngIf="errorMessage" class="form-error-message" [ngStyle]="errorMessageStyles">
        <span class="error-icon">⚠</span>
        <span>{{ errorMessage }}</span>
      </div>

      <footer *ngIf="includeFooter" class="form-actions">
        <ng-content select="[formActions]"></ng-content>
      </footer>
    </form>
  `,
  styles: [`
    form {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      width: 100%;
    }
    .form-heading {
      margin-bottom: 2rem;
    }
    .heading-text {
      margin: 0;
      font-size: 1.5rem;
      font-weight: 700;
    }
    .subheading-text {
      margin: 0.5rem 0 0;
      font-size: 0.875rem;
      opacity: 0.7;
    }
    .form-fields {
      display: flex;
      flex-direction: column;
    }
    .form-help {
      margin-top: 1rem;
      padding: 0.75rem 1rem;
      background: rgba(59, 130, 246, 0.1);
      border-left: 3px solid #3b82f6;
      border-radius: 4px;
      font-size: 0.875rem;
      line-height: 1.5;
    }
    .form-error-message {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.75rem 1rem;
      border-radius: 8px;
      font-size: 0.875rem;
      font-weight: 500;
      margin-top: 1rem;
    }
    .error-icon {
      font-size: 1.125rem;
    }
    .form-actions {
      margin-top: 2rem;
      display: flex;
      gap: 1rem;
      justify-content: flex-end;
    }
    .outlined .form-fields {
      gap: 1.5rem;
    }
    .filled .form-fields {
      gap: 1.25rem;
    }
    .underlined .form-fields {
      gap: 2rem;
    }
    .floating .form-fields {
      gap: 1.75rem;
    }
  `]
})
export class FormComponent {
  @Input() formData!: FormGroup;
  @Input() formStyle: FormStyle = 'outlined';
  @Input() fieldTheme: Partial<FieldTheme> = {};
  @Input() heading?: string;
  @Input() subheading?: string;
  @Input() helpText?: string;
  @Input() errorMessage?: string;
  @Input() includeFooter = false;
  @Input() compact = false;
  @Output() submit = new EventEmitter<any>();
  @Output() formChange = new EventEmitter<any>();

  private defaultFieldTheme: FieldTheme = {
    colors: {
      primary: '#3b82f6',
      secondary: '#8b5cf6',
      success: '#10b981',
      error: '#ef4444',
      warning: '#f59e0b'
    },
    spacing: {
      field: '1.5rem',
      input: '0.875rem 1.125rem'
    },
    typography: {
      labelSize: '0.875rem',
      inputSize: '0.9375rem',
      helperSize: '0.8125rem'
    },
    borders: {
      radius: '10px',
      width: '1.5px',
      style: 'solid'
    }
  };

  get theme(): FieldTheme {
    return {
      colors: { ...this.defaultFieldTheme.colors, ...this.fieldTheme.colors },
      spacing: { ...this.defaultFieldTheme.spacing, ...this.fieldTheme.spacing },
      typography: { ...this.defaultFieldTheme.typography, ...this.fieldTheme.typography },
      borders: { ...this.defaultFieldTheme.borders, ...this.fieldTheme.borders }
    };
  }

  get styleClass(): string {
    return this.formStyle;
  }

  get containerStyles(): Record<string, string> {
    return {
      padding: this.compact ? '1rem' : '2rem',
      borderRadius: this.theme.borders.radius
    };
  }

  get errorMessageStyles(): Record<string, string> {
    return {
      backgroundColor: `${this.theme.colors.error}15`,
      color: this.theme.colors.error,
      border: `1px solid ${this.theme.colors.error}30`
    };
  }

  onSubmit(event: Event): void {
    event.preventDefault();
    if (this.formData.valid) {
      this.submit.emit(this.formData.value);
    }
  }
}
