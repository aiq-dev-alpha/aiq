import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormGroup } from '@angular/forms';

interface FormTheme {
  inputBackground: string;
  inputBorder: string;
  inputText: string;
  labelColor: string;
  errorColor: string;
  focusColor: string;
}

type FormLayout = 'vertical' | 'horizontal' | 'inline';
type InputSize = 'sm' | 'md' | 'lg';

@Component({
  selector: 'app-form',
  template: `
    <form [formGroup]="formGroup" [ngStyle]="formStyles" [ngClass]="layoutClass" (ngSubmit)="handleSubmit()">
      <div class="form-header" *ngIf="formTitle || formDescription">
        <h2 *ngIf="formTitle" class="form-title">{{ formTitle }}</h2>
        <p *ngIf="formDescription" class="form-description">{{ formDescription }}</p>
      </div>

      <div class="form-body">
        <ng-content></ng-content>
      </div>

      <div class="form-footer" *ngIf="showFooter">
        <ng-content select="[formFooter]"></ng-content>
      </div>

      <div class="form-error" *ngIf="globalError" [ngStyle]="errorStyles">
        {{ globalError }}
      </div>
    </form>
  `,
  styles: [`
    form {
      font-family: system-ui, -apple-system, sans-serif;
    }
    .vertical {
      display: flex;
      flex-direction: column;
      gap: 1.5rem;
    }
    .horizontal .form-body {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 1.5rem;
    }
    .inline .form-body {
      display: flex;
      gap: 1rem;
      align-items: flex-end;
      flex-wrap: wrap;
    }
    .form-header {
      margin-bottom: 2rem;
    }
    .form-title {
      margin: 0;
      font-size: 1.75rem;
      font-weight: 700;
      line-height: 1.3;
    }
    .form-description {
      margin: 0.5rem 0 0;
      font-size: 0.875rem;
      opacity: 0.7;
      line-height: 1.6;
    }
    .form-body {
      margin-bottom: 1.5rem;
    }
    .form-footer {
      display: flex;
      gap: 1rem;
      justify-content: flex-end;
      align-items: center;
      padding-top: 1.5rem;
      border-top: 1px solid rgba(0, 0, 0, 0.1);
    }
    .form-error {
      padding: 1rem;
      border-radius: 8px;
      font-size: 0.875rem;
      margin-top: 1rem;
    }
  `]
})
export class FormComponent {
  @Input() formGroup!: FormGroup;
  @Input() layout: FormLayout = 'vertical';
  @Input() inputSize: InputSize = 'md';
  @Input() theme: Partial<FormTheme> = {};
  @Input() formTitle?: string;
  @Input() formDescription?: string;
  @Input() showFooter = false;
  @Input() globalError?: string;
  @Output() formSubmit = new EventEmitter<any>();

  private defaultTheme: FormTheme = {
    inputBackground: '#ffffff',
    inputBorder: '#d1d5db',
    inputText: '#0f172a',
    labelColor: '#334155',
    errorColor: '#ef4444',
    focusColor: '#3b82f6'
  };

  get appliedTheme(): FormTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get layoutClass(): string {
    return this.layout;
  }

  get formStyles(): Record<string, string> {
    const t = this.appliedTheme;
    return {
      color: t.inputText,
      width: '100%'
    };
  }

  get errorStyles(): Record<string, string> {
    const t = this.appliedTheme;
    return {
      backgroundColor: `${t.errorColor}15`,
      color: t.errorColor,
      border: `1px solid ${t.errorColor}30`
    };
  }

  handleSubmit(): void {
    if (this.formGroup.valid) {
      this.formSubmit.emit(this.formGroup.value);
    }
  }
}
