// Ripple Wave Input
import { Component, Input, Output, EventEmitter, forwardRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-input',
  template: `<div class="ripple-input" (click)="triggerRipple($event)"><input [type]="type" [placeholder]="placeholder" [value]="value" (input)="handleInput($event)" class="ripple-field" /><span class="ripple" *ngIf="showRipple" [style.left.px]="rippleX" [style.top.px]="rippleY"></span></div>`,
  styles: [`
  .ripple-input { position: relative; background: #f7fafc; border: 2px solid #cbd5e1; border-radius: 10px; overflow: hidden; }
  .ripple-field { width: 100%; border: none; outline: none; background: transparent; padding: 12px 16px; font-size: 15px; color: #2d3748; position: relative; z-index: 1; }
  .ripple { position: absolute; width: 10px; height: 10px; background: rgba(99, 102, 241, 0.5); border-radius: 50%; transform: translate(-50%, -50%); animation: ripple-expand 0.8s ease-out forwards; pointer-events: none; }
  @keyframes ripple-expand { 0% { width: 10px; height: 10px; opacity: 0.8; } 100% { width: 200px; height: 200px; opacity: 0; } }
  `],
  providers: [{ provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => InputComponent), multi: true }]
})
export class InputComponent implements ControlValueAccessor {
  @Input() type = 'text'; @Input() placeholder = ''; @Output() valueChange = new EventEmitter<string>();
  value = ''; showRipple = false; rippleX = 0; rippleY = 0;
  private onChange: unknown = () => {}; private onTouched: unknown = () => {};
  handleInput(e: Event): void { this.value = (e.target as HTMLInputElement).value; this.onChange(this.value); this.valueChange.emit(this.value); }
  triggerRipple(e: MouseEvent): void { this.rippleX = e.offsetX; this.rippleY = e.offsetY; this.showRipple = true; setTimeout(() => this.showRipple = false, 800); }
  writeValue(v: string): void { this.value = v || ''; }
  registerOnChange(fn: unknown): void { this.onChange = fn; }
  registerOnTouched(fn: unknown): void { this.onTouched = fn; }
  setDisabledState(d: boolean): void {}
}
