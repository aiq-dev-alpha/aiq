// Animated Modern Checkbox
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

@Component({
  selector: 'app-checkbox',
  template: `
  <label class="checkbox-container">
  <input type="checkbox" [checked]="checked" (change)="onChange($event)" [disabled]="disabled">
  <span class="checkmark"></span>
  <span class="label-text" *ngIf="label">{{ label }}</span>
  </label>
  `,
  styles: [`
  .checkbox-container { display: inline-flex; align-items: center; gap: 12px; cursor: pointer; position: relative; user-select: none; }
  .checkbox-container input { position: absolute; opacity: 0; cursor: pointer; }
  .checkmark { width: 22px; height: 22px; border: 2px solid #cbd5e1; border-radius: 6px; background: white; transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55); position: relative; }
  .checkmark::after { content: ''; position: absolute; display: none; left: 6px; top: 2px; width: 5px; height: 10px; border: solid white; border-width: 0 2px 2px 0; transform: rotate(45deg); }
  .checkbox-container input:checked ~ .checkmark { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-color: #667eea; transform: scale(1.1); }
  .checkbox-container input:checked ~ .checkmark::after { display: block; animation: checkmark-pop 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55); }
  @keyframes checkmark-pop { 0% { transform: rotate(45deg) scale(0); } 50% { transform: rotate(45deg) scale(1.2); } 100% { transform: rotate(45deg) scale(1); } }
  .checkbox-container:hover .checkmark { border-color: #667eea; }
  .label-text { font-size: 15px; color: #1f2937; }
  `],
  providers: [{
  provide: NG_VALUE_ACCESSOR,
  useExisting: forwardRef(() => CheckboxComponent),
  multi: true
  }]
})
export class CheckboxComponent implements ControlValueAccessor {
  @Input() label?: string;
  @Input() disabled = false;
  @Output() checkedChange = new EventEmitter<boolean>();
  
  checked = false;
  private onChangeFn: any = () => {};
  private onTouchedFn: any = () => {};
  
  onChange(event: Event): void {
  this.checked = (event.target as HTMLInputElement).checked;
  this.onChangeFn(this.checked);
  this.checkedChange.emit(this.checked);
  }
  
  writeValue(value: boolean): void { this.checked = value; }
  registerOnChange(fn: any): void { this.onChangeFn = fn; }
  registerOnTouched(fn: any): void { this.onTouchedFn = fn; }
  setDisabledState(isDisabled: boolean): void { this.disabled = isDisabled; }
}