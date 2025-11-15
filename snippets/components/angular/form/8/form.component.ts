// Multi-Step Wizard Form
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-form',
  template: `<div class="wizard-form"><div class="steps"><div class="step" *ngFor="let step of steps; let i = index" [class.active]="currentStep === i" [class.completed]="currentStep > i"><div class="step-number">{{ i + 1 }}</div><div class="step-label">{{ step }}</div></div></div><div class="form-content"><ng-content></ng-content></div><div class="form-actions"><button (click)="prevStep()" [disabled]="currentStep === 0">Previous</button><button (click)="nextStep()" [disabled]="currentStep === steps.length - 1">Next</button></div></div>`,
  styles: [`
  .wizard-form { max-width: 600px; margin: 0 auto; }
  .steps { display: flex; justify-content: space-between; margin-bottom: 32px; }
  .step { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 8px; position: relative; }
  .step::after { content: ''; position: absolute; top: 16px; left: 50%; width: 100%; height: 2px; background: #e5e7eb; z-index: -1; }
  .step:last-child::after { display: none; }
  .step-number { width: 32px; height: 32px; border-radius: 50%; background: #e5e7eb; display: flex; align-items: center; justify-content: center; font-weight: 600; transition: all 0.3s; }
  .step.active .step-number { background: #6366f1; color: white; }
  .step.completed .step-number { background: #10b981; color: white; }
  .form-content { background: white; border-radius: 8px; padding: 24px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); margin-bottom: 16px; }
  .form-actions { display: flex; justify-content: space-between; }
  .form-actions button { padding: 10px 24px; border: none; border-radius: 6px; background: #6366f1; color: white; cursor: pointer; }
  .form-actions button:disabled { background: #e5e7eb; color: #9ca3af; cursor: not-allowed; }
  `]
})
export class FormComponent {
  steps = ['Personal Info', 'Address', 'Confirmation'];
  currentStep = 0;
  nextStep() { if (this.currentStep < this.steps.length - 1) this.currentStep++; }
  prevStep() { if (this.currentStep > 0) this.currentStep--; }
}