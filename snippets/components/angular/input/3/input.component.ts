import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

interface InputTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  glowColor: string;
}

@Component({
  selector: 'app-input',
  template: `
    <div class="input-wrapper" [ngStyle]="wrapperStyles">
      <div class="floating-label-container" [ngStyle]="containerStyles">
        <input
          [id]="inputId"
          [type]="type"
          [placeholder]="' '"
          [disabled]="disabled"
          [value]="value"
          [ngStyle]="inputStyles"
          (input)="onInput($event)"
          (focus)="onFocus()"
          (blur)="onBlur()"
          [attr.aria-label]="ariaLabel || label"
          class="input-field"
        />
        <label *ngIf="label" [for]="inputId" class="floating-label" [ngStyle]="labelStyles">
          {{ label }}
        </label>
        <div class="glow-effect"></div>
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
      gap: 6px;
      width: 100%;
    }
    .floating-label-container {
      position: relative;
      overflow: visible;
    }
    .input-field {
      width: 100%;
      border: none;
      outline: none;
      font-family: inherit;
      background: transparent;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .input-field:disabled {
      cursor: not-allowed;
      opacity: 0.5;
    }
    .floating-label {
      position: absolute;
      left: 14px;
      top: 50%;
      transform: translateY(-50%);
      pointer-events: none;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      font-weight: 400;
      background: white;
      padding: 0 4px;
    }
    .input-field:focus ~ .floating-label,
    .input-field:not(:placeholder-shown) ~ .floating-label {
      top: 0;
      font-size: 12px;
      font-weight: 600;
    }
    .glow-effect {
      position: absolute;
      bottom: -2px;
      left: 50%;
      transform: translateX(-50%) scaleX(0);
      width: 100%;
      height: 2px;
      border-radius: 2px;
      transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .input-field:focus ~ .glow-effect {
      transform: translateX(-50%) scaleX(1);
      box-shadow: 0 0 10px currentColor;
    }
    .helper-text {
      font-size: 12px;
      padding-left: 14px;
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
  @Input() helperText?: string;
  @Input() disabled = false;
  @Input() ariaLabel?: string;
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Output() valueChange = new EventEmitter<string>();

  value: string = '';
  isFocused = false;
  inputId = `input-${Math.random().toString(36).substr(2, 9)}`;

  private onChange: (value: string) => void = () => {};
  private onTouched: () => void = () => {};

  private defaultTheme: InputTheme = {
    primaryColor: '#10b981',
    secondaryColor: '#059669',
    backgroundColor: '#ffffff',
    textColor: '#064e3b',
    glowColor: '#10b981'
  };

  get appliedTheme(): InputTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get wrapperStyles() {
    return {
      fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
    };
  }

  get containerStyles() {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { height: '38px' },
      md: { height: '46px' },
      lg: { height: '54px' }
    };

    return {
      ...sizeMap[this.size],
      border: `2px solid ${t.primaryColor}30`,
      borderRadius: '12px',
      backgroundColor: t.backgroundColor
    };
  }

  get inputStyles() {
    const t = this.appliedTheme;
    const sizeMap = {
      sm: { padding: '8px 12px', fontSize: '13px' },
      md: { padding: '12px 14px', fontSize: '15px' },
      lg: { padding: '16px 16px', fontSize: '17px' }
    };

    return {
      ...sizeMap[this.size],
      color: t.textColor
    };
  }

  get labelStyles() {
    const t = this.appliedTheme;
    return {
      color: t.primaryColor,
      fontSize: '15px'
    };
  }

  get helperStyles() {
    const t = this.appliedTheme;
    return {
      color: `${t.textColor}99`
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
