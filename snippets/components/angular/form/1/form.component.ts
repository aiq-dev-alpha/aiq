import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormGroup } from '@angular/forms';

interface FormTheme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  errorColor: string;
}

@Component({
  selector: 'app-form',
  template: `
    <form [formGroup]="formGroup" (ngSubmit)="onSubmit()" [ngStyle]="formStyles" class="form-container">
      <div *ngIf="title" class="form-header" [ngStyle]="headerStyles">
        <h2 class="form-title">{{ title }}</h2>
        <p *ngIf="description" class="form-description">{{ description }}</p>
      </div>

      <div class="form-body" [ngStyle]="bodyStyles">
        <ng-content></ng-content>
      </div>

      <div *ngIf="hasActions" class="form-actions" [ngStyle]="actionsStyles">
        <ng-content select="[actions]"></ng-content>
      </div>

      <div *ngIf="errorMessage" class="form-error" [ngStyle]="errorStyles">
        {{ errorMessage }}
      </div>
    </form>
  `,
  styles: [`
    .form-container {
      display: flex;
      flex-direction: column;
      gap: 24px;
    }
    .form-header {
      border-bottom: 2px solid;
      padding-bottom: 16px;
    }
    .form-title {
      margin: 0 0 8px 0;
      font-size: 24px;
      font-weight: 700;
    }
    .form-description {
      margin: 0;
      font-size: 14px;
      opacity: 0.7;
    }
    .form-body {
      display: flex;
      flex-direction: column;
      gap: 20px;
    }
    .form-actions {
      display: flex;
      gap: 12px;
      justify-content: flex-end;
      padding-top: 16px;
      border-top: 1px solid;
    }
    .form-error {
      padding: 12px 16px;
      border-radius: 8px;
      font-size: 14px;
      font-weight: 500;
    }
  
    
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }
    
    @keyframes slideIn {
      from { transform: translateX(-20px); opacity: 0; }
      to { transform: translateX(0); opacity: 1; }
    }
    
    @keyframes scaleIn {
      from { transform: scale(0.95); opacity: 0; }
      to { transform: scale(1); opacity: 1; }
    }
  `]
})
export class FormComponent {
  @Input() theme: Partial<FormTheme> = {};
  @Input() formGroup!: FormGroup;
  @Input() title?: string;
  @Input() description?: string;
  @Input() hasActions = false;
  @Input() errorMessage?: string;
  @Input() loading = false;
  @Output() submitted = new EventEmitter<any>();

  private defaultTheme: FormTheme = {
    primaryColor: '#3b82f6',
    backgroundColor: '#ffffff',
        backdropFilter: 'blur(10px)',
    textColor: '#0f172a',
    borderColor: '#e2e8f0',
    errorColor: '#ef4444'
  };

  get appliedTheme(): FormTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get formStyles() {
    const t = this.appliedTheme;
    return {
      backgroundColor: t.backgroundColor,
      color: t.textColor,
      padding: '32px',
      borderRadius: '16px',
      border: `1px solid ${t.borderColor}`
    };
  }

  get headerStyles() {
    const t = this.appliedTheme;
    return {
      borderColor: t.primaryColor
    };
  }

  get bodyStyles() {
    return {};
  }

  get actionsStyles() {
    const t = this.appliedTheme;
    return {
      borderColor: t.borderColor
    };
  }

  get errorStyles() {
    const t = this.appliedTheme;
    return {
      backgroundColor: `${t.errorColor}15`,
      color: t.errorColor,
      border: `1px solid ${t.errorColor}`
    };
  }

  onSubmit(): void {
    if (this.formGroup.valid && !this.loading) {
      this.submitted.emit(this.formGroup.value);
    }
  }
}
