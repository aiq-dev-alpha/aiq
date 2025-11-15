import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

interface InputTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  accentColor: string;
}

@Component({
  selector: 'app-input',
  template: `
    <div class="input-wrapper" [ngStyle]="wrapperStyles">
      <label *ngIf="label" [for]="inputId" class="label" [ngStyle]="labelStyles">
        {{ label }}
        <span *ngIf="required" class="required">*</span>
      </label>
      <div class="input-container" [ngStyle]="containerStyles">
        <div class="floating-border"></div>
        <span *ngIf="prefixIcon" class="prefix-icon">{{ prefixIcon }}</span>
        <input
          [id]="inputId"
          [type]="type"
          [placeholder]="placeholder"
          [disabled]="disabled"
          [value]="value"
          [ngStyle]="inputStyles"
          (input)="onInput($event)"
          (focus)="onFocus()"
          (blur)="onBlur()"
          [attr.aria-label]="ariaLabel || label"
          class="input-field"
        />
        <span *ngIf="suffixIcon" class="suffix-icon">{{ suffixIcon }}</span>
      </div>
      <div *ngIf="helperText" class="helper-text" [ngStyle]="helperStyles">
        {{ helperText }}
      </div>
    </div>
  `,
  styles: [`
    .input-wrapper {
      display: flex;
      flex-direction: column;
      gap: 8px;
      width: 100%;
    }
    .label {
      font-weight: 500;
      font-size: 13px;
      letter-spacing: 0.5px;
      text-transform: uppercase;
    }
    .required {
      color: #f43f5e;
      margin-left: 3px;
    }
    .input-container {
      position: relative;
      overflow: hidden;
    }
    .floating-border {
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      height: 2px;
      background: linear-gradient(90deg, #6366f1, #8b5cf6, #ec4899);
      transform: scaleX(0);
      transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .input-container:focus-within .floating-border {
      transform: scaleX(1);
    }
    .input-field {
      width: 100%;
      border: none;
      outline: none;
      font-family: inherit;
      background: transparent;
      transition: all 0.2s ease;
    }
    .input-field::placeholder {
      opacity: 0.5;
    }
    .input-field:disabled {
      cursor: not-allowed;
      opacity: 0.5;
    }
    .prefix-icon, .suffix-icon {
      display: flex;
      align-items: center;
      opacity: 0.7;
      transition: opacity 0.2s;
    }
    .input-container:focus-within .prefix-icon,
    .input-container:focus-within .suffix-icon {
      opacity: 1;
    }
    .helper-text {
      font-size: 12px;
      opacity: 0.8;
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
  @Input() type: string = 'text';
  @Input() label?: string;
  @Input() placeholder: string = '';
  @Input() helperText?: string;
  @Input() disabled = false;
  @Input() required = false;
  @Input() prefixIcon?: string;
  @Input() suffixIcon?: string;
  @Input() ariaLabel?: string;
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Output() valueChange = new EventEmitter<string>();

  value: string = '';
  isFocused = false;
  inputId = `input-${Math.random().toString(36).substr(2, 9)}`;

  private onChange: (value: string) => void = () => {};
  private onTouched: () => void = () => {};

  private defaultTheme: InputTheme = {
    primaryColor: '#6366f1',
    secondaryColor: '#8b5cf6',
    backgroundColor: '#f8fafc',
    textColor: '#1e293b',
    borderColor: '#cbd5e1',
    accentColor: '#ec4899'
  };

  get appliedTheme(): InputTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get wrapperStyles() {
    return {
      fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
    };
  }

  get labelStyles() {
    const t = this.appliedTheme;
    return {
      color: t.primaryColor
    };
  }

  get containerStyles() {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { padding: '6px 10px', gap: '8px' },
      md: { padding: '10px 14px', gap: '10px' },
      lg: { padding: '14px 18px', gap: '12px' }
    };

    return {
      ...sizeMap[this.size],
      backgroundColor: t.backgroundColor,
      borderBottom: `1px solid ${t.borderColor}`,
      display: 'flex',
      alignItems: 'center',
      transition: 'all 0.2s ease'
    };
  }

  get inputStyles() {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { fontSize: '13px' },
      md: { fontSize: '15px' },
      lg: { fontSize: '17px' }
    };

    return {
      ...sizeMap[this.size],
      color: t.textColor
    };
  }

  get helperStyles() {
    const t = this.appliedTheme;
    return {
      color: t.textColor
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
