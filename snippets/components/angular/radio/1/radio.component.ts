// Modern Radio Button Group
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

@Component({
  selector: 'app-radio',
  template: `
    <div class="radio-group">
      <label class="radio-option" *ngFor="let option of options" [class.selected]="value === option.value">
        <input type="radio" [name]="name" [value]="option.value" [checked]="value === option.value" (change)="onChange(option.value)">
        <span class="radio-custom"></span>
        <span class="option-label">{{ option.label }}</span>
      </label>
    </div>
  `,
  styles: [`
    .radio-group { display: flex; flex-direction: column; gap: 12px; }
    .radio-option { display: flex; align-items: center; gap: 12px; padding: 14px 18px; border: 2px solid #e5e7eb; border-radius: 10px; cursor: pointer; transition: all 0.3s; position: relative; }
    .radio-option:hover { border-color: #667eea; background: #f9fafb; }
    .radio-option.selected { border-color: #667eea; background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1)); }
    .radio-option input { position: absolute; opacity: 0; }
    .radio-custom { width: 20px; height: 20px; border: 2px solid #cbd5e1; border-radius: 50%; position: relative; transition: all 0.3s; }
    .radio-custom::after { content: ''; position: absolute; top: 50%; left: 50%; width: 10px; height: 10px; border-radius: 50%; background: linear-gradient(135deg, #667eea, #764ba2); transform: translate(-50%, -50%) scale(0); transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55); }
    .radio-option.selected .radio-custom { border-color: #667eea; }
    .radio-option.selected .radio-custom::after { transform: translate(-50%, -50%) scale(1); }
    .option-label { font-size: 15px; color: #1f2937; font-weight: 500; }
  `],
  providers: [{
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => RadioComponent),
    multi: true
  }]
})
export class RadioComponent implements ControlValueAccessor {
  @Input() options: {label: string, value: any}[] = [];
  @Input() name = 'radio-group';
  @Output() valueChange = new EventEmitter<any>();
  
  value: any;
  private onChangeFn: any = () => {};
  private onTouchedFn: any = () => {};
  
  onChange(value: any): void {
    this.value = value;
    this.onChangeFn(value);
    this.valueChange.emit(value);
  }
  
  writeValue(value: any): void { this.value = value; }
  registerOnChange(fn: any): void { this.onChangeFn = fn; }
  registerOnTouched(fn: any): void { this.onTouchedFn = fn; }
  setDisabledState(isDisabled: boolean): void {}
}