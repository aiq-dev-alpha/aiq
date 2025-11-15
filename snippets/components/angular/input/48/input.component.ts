import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR, FormControl } from '@angular/forms';

interface InputTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  accentColor: string;
  errorColor: string;
  successColor: string;
}

@Component({
  selector: 'app-input',
  template: `
    <div class="input-wrapper" [ngStyle]="wrapperStyles">
      <label *ngIf="label" [for]="inputId" class="label" [ngStyle]="labelStyles" [class.floated]="isFocused || value">
        {{ label }}
        <span *ngIf="required" class="required">*</span>
      </label>
      <div class="input-container" [ngStyle]="containerStyles" [class.focused]="isFocused" [class.error]="hasError" [class.success]="showSuccess">
        <div class="animated-border"></div>
        <span *ngIf="leftIcon" class="left-icon" [ngStyle]="iconStyles">{{ leftIcon }}</span>
        <input
          #inputElement
          [id]="inputId"
          [type]="inputType"
          [placeholder]="placeholder"
          [disabled]="disabled"
          [readonly]="readonly"
          [value]="value"
          [maxlength]="maxLength"
          [ngStyle]="inputStyles"
          (input)="onInput($event)"
          (focus)="onFocus()"
          (blur)="onBlur()"
          [attr.aria-label]="ariaLabel || label"
          [attr.aria-invalid]="hasError"
          [attr.aria-describedby]="helperTextId"
          [attr.aria-required]="required"
          class="input-field"
        />
        <span *ngIf="rightIcon" class="right-icon" [ngStyle]="iconStyles">{{ rightIcon }}</span>
        <button *ngIf="showClearButton && value && !disabled && !readonly" type="button" class="clear-button" (click)="clearInput()" [ngStyle]="clearButtonStyles" aria-label="Clear input">
          ✕
        </button>
        <span *ngIf="showCharCounter && maxLength" class="char-counter" [ngStyle]="charCounterStyles">
          {{ value.length }}/{{ maxLength }}
        </span>
      </div>
      <div *ngIf="helperText && !hasError" [id]="helperTextId" class="helper-text" [ngStyle]="helperStyles">
        {{ helperText }}
      </div>
      <div *ngIf="hasError && errorMessage" [id]="helperTextId" class="error-text" [ngStyle]="errorStyles">
        {{ errorMessage }}
      </div>
      <div *ngIf="showSuccess && successMessage" class="success-text" [ngStyle]="successStyles">
        {{ successMessage }}
      </div>
    </div>
  `,
  styles: [`
    .input-wrapper {
      display: flex;
      flex-direction: column;
      gap: 8px;
      width: 100%;
      position: relative;
    }
    .label {
      font-weight: 400;
      font-size: 12px;
      letter-spacing: 0.5px;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      transform-origin: left top;
    }
    .label.floated {
      transform: translateY(-8px) scale(0.85);
      font-weight: 600;
    }
    .required {
      color: #e74c3c;
      margin-left: 3px;
    }
    .input-container {
      position: relative;
      overflow: visible;
      border-radius: 0px;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .animated-border {
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      height: 2px;
      background: linear-gradient(90deg, #f39c12, #e67e22);
      transform: scaleX(0);
      transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      border-radius: 0px;
    }
    .input-container.focused .animated-border {
      transform: scaleX(1);
      animation: pulse 1.5s ease-in-out infinite;
    }
    .input-container.error .animated-border {
      background: linear-gradient(90deg, #e74c3c, #e74c3cdd);
      transform: scaleX(1);
    }
    .input-container.success .animated-border {
      background: linear-gradient(90deg, #27ae60, #27ae60dd);
      transform: scaleX(1);
    }
    .input-field {
      width: 100%;
      border: none;
      outline: none;
      font-family: inherit;
      background: transparent;
      transition: all 0.3s ease;
      font-weight: 400;
    }
    .input-field::placeholder {
      opacity: 0.5;
      transition: opacity 0.3s;
    }
    .input-field:focus::placeholder {
      opacity: 0.7;
    }
    .input-field:disabled {
      cursor: not-allowed;
      opacity: 0.5;
    }
    .input-field:read-only {
      cursor: default;
      opacity: 0.8;
      background: rgba(0, 0, 0, 0.02);
    }
    .left-icon, .right-icon {
      display: flex;
      align-items: center;
      opacity: 0.6;
      transition: all 0.3s;
      flex-shrink: 0;
      font-size: 16px;
    }
    .input-container.focused .left-icon,
    .input-container.focused .right-icon {
      opacity: 1;
      transform: scale(1.15);
    }
    .clear-button {
      display: flex;
      align-items: center;
      justify-content: center;
      border: none;
      background: transparent;
      cursor: pointer;
      opacity: 0.5;
      transition: all 0.2s;
      padding: 4px;
      border-radius: 50%;
      flex-shrink: 0;
      width: 20px;
      height: 20px;
    }
    .clear-button:hover {
      opacity: 1;
      background: rgba(0, 0, 0, 0.08);
      transform: rotate(90deg);
    }
    .char-counter {
      font-size: 11px;
      opacity: 0.6;
      white-space: nowrap;
      flex-shrink: 0;
      font-weight: 500;
    }
    .helper-text, .error-text, .success-text {
      font-size: 12px;
      opacity: 0.9;
      transition: all 0.2s;
      padding-left: 4px;
    }
    .error-text {
      animation: shake 0.4s;
    }
    .success-text {
      animation: slideIn 0.3s;
    }
    @keyframes pulse {
      0%, 100% { opacity: 1; transform: scaleX(1); }
      50% { opacity: 0.8; transform: scaleX(1.02); }
    }
    @keyframes shake {
      0%, 100% { transform: translateX(0); }
      25% { transform: translateX(-5px); }
      75% { transform: translateX(5px); }
    }
    @keyframes slideIn {
      from { opacity: 0; transform: translateY(-4px); }
      to { opacity: 0.9; transform: translateY(0); }
    }
  `],
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: forwardRef(() => InputComponent),
      multi: true
    }
  ]
})
export class InputComponent implements ControlValueAccessor {
  @Input() theme: Partial<InputTheme> = {};
  @Input() type: 'text' | 'email' | 'password' | 'number' | 'tel' | 'url' = 'text';
  @Input() variant: 'default' | 'filled' | 'outlined' | 'underlined' = 'default';
  @Input() label?: string;
  @Input() placeholder: string = '';
  @Input() helperText?: string;
  @Input() errorMessage?: string;
  @Input() successMessage?: string;
  @Input() disabled = false;
  @Input() readonly = false;
  @Input() required = false;
  @Input() leftIcon?: string;
  @Input() rightIcon?: string;
  @Input() ariaLabel?: string;
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() showClearButton = true;
  @Input() showCharCounter = false;
  @Input() maxLength?: number;
  @Input() formControl?: FormControl;
  @Output() valueChange = new EventEmitter<string>();
  @Output() focus = new EventEmitter<void>();
  @Output() blur = new EventEmitter<void>();
  @Output() clear = new EventEmitter<void>();

  value: string = '';
  isFocused = false;
  inputId = `input-${Math.random().toString(36).substr(2, 9)}`;
  helperTextId = `helper-${this.inputId}`;
  inputType: string = this.type;

  private onChange: (value: string) => void = () => {};
  private onTouched: () => void = () => {};

  private defaultTheme: InputTheme = {
    primaryColor: '#f39c12',
    secondaryColor: '#e67e22',
    backgroundColor: '#fffbf0',
    textColor: '#744210',
    borderColor: '#ffd89b',
    accentColor: '#fdcb6e',
    errorColor: '#e74c3c',
    successColor: '#27ae60'
  };

  get appliedTheme(): InputTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get hasError(): boolean {
    return !!this.errorMessage || (this.formControl ? this.formControl.invalid && this.formControl.touched : false);
  }

  get showSuccess(): boolean {
    return !!this.successMessage || (this.formControl ? this.formControl.valid && this.formControl.touched && !!this.value : false);
  }

  get wrapperStyles() {
    return {
      fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif'
    };
  }

  get labelStyles() {
    const t = this.appliedTheme;
    return {
      color: this.hasError ? t.errorColor : this.isFocused ? t.primaryColor : t.textColor
    };
  }

  get containerStyles() {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { padding: '6px 10px', gap: '6px' },
      md: { padding: '10px 14px', gap: '10px' },
      lg: { padding: '14px 18px', gap: '14px' }
    };

    const variantStyles = {
      default: {
        backgroundColor: t.backgroundColor,
        borderBottom: `2px solid ${this.hasError ? t.errorColor : this.showSuccess ? t.successColor : t.borderColor}`,
      },
      filled: {
        backgroundColor: t.backgroundColor,
        border: `1px solid ${this.hasError ? t.errorColor : this.showSuccess ? t.successColor : t.borderColor}`,
        borderRadius: '0px'
      },
      outlined: {
        backgroundColor: 'transparent',
        border: `2px solid ${this.hasError ? t.errorColor : this.showSuccess ? t.successColor : t.borderColor}`,
        borderRadius: '0px'
      },
      underlined: {
        backgroundColor: 'transparent',
        borderBottom: `2px solid ${this.hasError ? t.errorColor : this.showSuccess ? t.successColor : t.borderColor}`,
        borderRadius: '0'
      }
    };

    return {
      ...sizeMap[this.size],
      ...variantStyles[this.variant],
      display: 'flex',
      alignItems: 'center',
      transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
      boxShadow: this.isFocused ? '0 0 0 3px #f39c1220' : 'none'
    };
  }

  get inputStyles() {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { fontSize: '12px' },
      md: { fontSize: '14px' },
      lg: { fontSize: '16px' }
    };

    return {
      ...sizeMap[this.size],
      color: t.textColor
    };
  }

  get iconStyles() {
    const t = this.appliedTheme;
    return {
      color: this.hasError ? t.errorColor : this.showSuccess ? t.successColor : t.primaryColor
    };
  }

  get helperStyles() {
    const t = this.appliedTheme;
    return {
      color: t.textColor
    };
  }

  get errorStyles() {
    const t = this.appliedTheme;
    return {
      color: t.errorColor,
      fontWeight: '500'
    };
  }

  get successStyles() {
    const t = this.appliedTheme;
    return {
      color: t.successColor,
      fontWeight: '500'
    };
  }

  get clearButtonStyles() {
    const t = this.appliedTheme;
    return {
      color: t.textColor
    };
  }

  get charCounterStyles() {
    const t = this.appliedTheme;
    const isAtLimit = this.maxLength && this.value.length === this.maxLength;
    return {
      color: isAtLimit ? t.errorColor : t.textColor,
      fontWeight: isAtLimit ? '600' : '400'
    };
  }

  onInput(event: Event): void {
    const value = (event.target as HTMLInputElement).value;
    this.value = value;
    this.onChange(value);
    this.valueChange.emit(value);
  }

  onFocus(): void {
    this.isFocused = true;
    this.focus.emit();
  }

  onBlur(): void {
    this.isFocused = false;
    this.onTouched();
    this.blur.emit();
  }

  clearInput(): void {
    this.value = '';
    this.onChange('');
    this.valueChange.emit('');
    this.clear.emit();
  }

  writeValue(value: string): void {
    this.value = value || '';
  }

  registerOnChange(fn: (value: string) => void): void {
    this.onChange = fn;
  }

  registerOnTouched(fn: () => void): void {
    this.onTouched = fn;
  }

  setDisabledState(isDisabled: boolean): void {
    this.disabled = isDisabled;
  }
}
