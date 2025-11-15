// Progress Button - Button that shows download/upload progress
import { Component, Input, Output, EventEmitter, OnChanges } from '@angular/core';
import { CommonModule } from '@angular/common';

interface ProgressButtonTheme {
  primaryColor: string;
  secondaryColor: string;
  successColor: string;
  errorColor: string;
  textColor: string;
}

@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-button',
  template: `
    <button
      class="progress-btn"
      [ngStyle]="buttonStyles"
      [disabled]="disabled || isProcessing"
      [class.processing]="isProcessing"
      [class.success]="status === 'success'"
      [class.error]="status === 'error'"
      (click)="handleClick($event)">

      <div class="progress-fill" [ngStyle]="progressStyles"></div>

      <div class="btn-content">
        <span *ngIf="status === 'idle'" class="content-text">
          {{ label }}
        </span>
        <span *ngIf="status === 'processing'" class="content-text">
          {{ processingLabel || 'Processing...' }} {{ progress }}%
        </span>
        <span *ngIf="status === 'success'" class="content-text success-msg">
          {{ successLabel || 'Complete!' }} ✓
        </span>
        <span *ngIf="status === 'error'" class="content-text error-msg">
          {{ errorLabel || 'Failed' }} ✗
        </span>
      </div>
    </button>
  `,
  styles: [`
    .progress-btn {
      position: relative;
      border: none;
      cursor: pointer;
      font-family: inherit;
      font-weight: 600;
      font-size: 15px;
      padding: 14px 28px;
      border-radius: 10px;
      overflow: hidden;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      min-width: 180px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .progress-btn:disabled {
      cursor: not-allowed;
      opacity: 0.7;
    }

    .progress-btn:hover:not(:disabled):not(.processing) {
      transform: translateY(-2px);
      box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
    }

    .progress-fill {
      position: absolute;
      left: 0;
      top: 0;
      bottom: 0;
      width: 0;
      transition: width 0.3s ease-out, background 0.3s;
      z-index: 0;
    }

    .btn-content {
      position: relative;
      z-index: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
    }

    .content-text {
      transition: all 0.3s;
    }

    .success-msg {
      animation: successPulse 0.5s ease-out;
    }

    .error-msg {
      animation: shake 0.5s ease-out;
    }

    @keyframes successPulse {
      0%, 100% { transform: scale(1); }
      50% { transform: scale(1.1); }
    }

    @keyframes shake {
      0%, 100% { transform: translateX(0); }
      25% { transform: translateX(-5px); }
      75% { transform: translateX(5px); }
    }

    .progress-btn.processing {
      animation: processingPulse 1.5s ease-in-out infinite;
    }

    @keyframes processingPulse {
      0%, 100% { box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); }
      50% { box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2); }
    }
  `]
})
export class ButtonComponent implements OnChanges {
  @Input() theme: Partial<ProgressButtonTheme> = {};
  @Input() label = 'Start';
  @Input() processingLabel?: string;
  @Input() successLabel?: string;
  @Input() errorLabel?: string;
  @Input() progress = 0;
  @Input() status: 'idle' | 'processing' | 'success' | 'error' = 'idle';
  @Input() disabled = false;
  @Output() clicked = new EventEmitter<MouseEvent>();

  isProcessing = false;

  private defaultTheme: ProgressButtonTheme = {
    primaryColor: '#3b82f6',
    secondaryColor: '#2563eb',
    successColor: '#10b981',
    errorColor: '#ef4444',
    textColor: '#ffffff'
  };

  ngOnChanges() {
    this.isProcessing = this.status === 'processing';

    if (this.status === 'success' || this.status === 'error') {
      setTimeout(() => {
        if (this.status !== 'processing') {
          this.status = 'idle';
        }
      }, 2000);
    }
  }

  get appliedTheme(): ProgressButtonTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get buttonStyles() {
    const t = this.appliedTheme;
    let bgColor = `linear-gradient(135deg, ${t.primaryColor}, ${t.secondaryColor})`;

    if (this.status === 'success') {
      bgColor = t.successColor;
    } else if (this.status === 'error') {
      bgColor = t.errorColor;
    }

    return {
      background: bgColor,
      color: t.textColor
    };
  }

  get progressStyles() {
    const t = this.appliedTheme;
    const clampedProgress = Math.min(100, Math.max(0, this.progress));

    return {
      width: `${clampedProgress}%`,
      background: `linear-gradient(90deg, ${t.secondaryColor}, ${t.primaryColor})`
    };
  }

  handleClick(event: MouseEvent): void {
    if (!this.disabled && !this.isProcessing) {
      this.clicked.emit(event);
    }
  }
}
