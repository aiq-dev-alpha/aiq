import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

interface InputTheme {
  background: string;
  border: string;
  text: string;
  label: string;
  focus: string;
  error: string;
  success: string;
}

type InputVariant = 'outlined' | 'filled' | 'underlined' | 'floating';
type InputSize = 'sm' | 'md' | 'lg';

@Component({
  selector: 'app-input',
  template: `
    <div class="input-wrapper" [ngStyle]="wrapperStyles" [ngClass]="wrapperClasses">
      <label *ngIf="label && variant !== 'floating'" class="input-label" [ngStyle]="labelStyles">
        {{ label }}
        <span *ngIf="required" class="required-mark">*</span>
      </label>

      <div class="input-container" [ngStyle]="containerStyles">
        <span *ngIf="prefixIcon" class="input-prefix">{{ prefixIcon }}</span>

        <input
          #inputElement
          [type]="type"
          [value]="value"
          [placeholder]="variant === 'floating' ? ' ' : placeholder"
          [disabled]="disabled"
          [readonly]="readonly"
          [ngStyle]="inputStyles"
          (input)="onInput($event)"
          (blur)="onBlur()"
          (focus)="onFocus()"
          [attr.aria-label]="ariaLabel || label"
          [attr.aria-invalid]="hasError"
          class="input-field" />

        <label *ngIf="variant === 'floating' && label" class="floating-label" [ngStyle]="floatingLabelStyles">
          {{ label }}
          <span *ngIf="required" class="required-mark">*</span>
        </label>

        <span *ngIf="suffixIcon" class="input-suffix">{{ suffixIcon }}</span>
      </div>

      <div *ngIf="helperText && !hasError" class="helper-text" [ngStyle]="helperStyles">
        {{ helperText }}
      </div>

      <div *ngIf="errorMessage && hasError" class="error-text" [ngStyle]="errorStyles">
        {{ errorMessage }}
      </div>
    </div>
  `,
  styles: [`
    .input-wrapper {
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
      width: 100%;
    }
    .input-container {
      position: relative;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }
    .input-field {
      flex: 1;
      outline: none;
      font-family: inherit;
      transition: all 0.2s ease;
    }
    .input-field:focus {
      outline: none;
    }
    .input-label {
      font-weight: 600;
      font-size: 0.875rem;
      display: block;
    }
    .floating-label {
      position: absolute;
      left: 12px;
      transition: all 0.2s ease;
      pointer-events: none;
      font-size: 0.875rem;
    }
    .input-field:not(:placeholder-shown) ~ .floating-label,
    .input-field:focus ~ .floating-label {
      top: -10px;
      left: 8px;
      font-size: 0.75rem;
      padding: 0 4px;
    }
    .input-prefix,
    .input-suffix {
      display: flex;
      align-items: center;
      font-size: 1.125rem;
    }
    .required-mark {
      color: #ef4444;
      margin-left: 2px;
    }
    .helper-text,
    .error-text {
      font-size: 0.75rem;
      line-height: 1.4;
    }
  `],
  providers: [{
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => InputComponent),
    multi: true
  }]
})
export class InputComponent implements ControlValueAccessor {
  @Input() variant: InputVariant = 'outlined';
  @Input() size: InputSize = 'md';
  @Input() theme: Partial<InputTheme> = {};
  @Input() label?: string;
  @Input() placeholder = '';
  @Input() helperText?: string;
  @Input() errorMessage?: string;
  @Input() type = 'text';
  @Input() disabled = false;
  @Input() readonly = false;
  @Input() required = false;
  @Input() prefixIcon?: string;
  @Input() suffixIcon?: string;
  @Input() ariaLabel?: string;
  @Input() hasError = false;
  @Output() valueChange = new EventEmitter<string>();

  value = '';
  isFocused = false;

  private onChange: (value: string) => void = () => {};
  private onTouched: () => void = () => {};

  private defaultTheme: InputTheme = {
    background: '#ffffff',
    border: '#d1d5db',
    text: '#111827',
    label: '#374151',
    focus: '#3b82f6',
    error: '#ef4444',
    success: '#10b981'
  };

  get appliedTheme(): InputTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get wrapperClasses(): string[] {
    return [
      `variant-${this.variant}`,
      `size-${this.size}`,
      this.hasError ? 'has-error' : '',
      this.isFocused ? 'is-focused' : '',
      this.disabled ? 'is-disabled' : ''
    ].filter(Boolean);
  }

  get wrapperStyles(): Record<string, string> {
    return {
      opacity: this.disabled ? '0.6' : '1'
    };
  }

  get containerStyles(): Record<string, string> {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { minHeight: '36px' },
      md: { minHeight: '44px' },
      lg: { minHeight: '52px' }
    };

    const variantMap = {
      outlined: {
        border: `2px solid ${this.hasError ? t.error : this.isFocused ? t.focus : t.border}`,
        borderRadius: '8px',
        background: t.background
      },
      filled: {
        border: 'none',
        borderRadius: '8px 8px 0 0',
        background: `${t.border}40`,
        borderBottom: `2px solid ${this.hasError ? t.error : this.isFocused ? t.focus : t.border}`
      },
      underlined: {
        border: 'none',
        borderBottom: `2px solid ${this.hasError ? t.error : this.isFocused ? t.focus : t.border}`,
        borderRadius: '0',
        background: 'transparent'
      },
      floating: {
        border: `2px solid ${this.hasError ? t.error : this.isFocused ? t.focus : t.border}`,
        borderRadius: '8px',
        background: t.background
      }
    };

    return {
      ...sizeMap[this.size],
      ...variantMap[this.variant],
      padding: '0 12px'
    };
  }

  get inputStyles(): Record<string, string> {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { fontSize: '13px' },
      md: { fontSize: '14px' },
      lg: { fontSize: '16px' }
    };

    return {
      ...sizeMap[this.size],
      background: 'transparent',
      border: 'none',
      color: t.text,
      width: '100%'
    };
  }

  get labelStyles(): Record<string, string> {
    return {
      color: this.appliedTheme.label
    };
  }

  get floatingLabelStyles(): Record<string, string> {
    return {
      color: this.hasError ? this.appliedTheme.error : this.isFocused ? this.appliedTheme.focus : this.appliedTheme.label,
      background: this.appliedTheme.background,
      top: '50%',
      transform: 'translateY(-50%)'
    };
  }

  get helperStyles(): Record<string, string> {
    return {
      color: this.appliedTheme.label,
      opacity: '0.7'
    };
  }

  get errorStyles(): Record<string, string> {
    return {
      color: this.appliedTheme.error
    };
  }

  onInput(event: Event): void {
    const target = event.target as HTMLInputElement;
    this.value = target.value;
    this.onChange(this.value);
    this.valueChange.emit(this.value);
  }

  onFocus(): void {
    this.isFocused = true;
  }

  onBlur(): void {
    this.isFocused = false;
    this.onTouched();
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
