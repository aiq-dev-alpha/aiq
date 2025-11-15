// Inline Validation Form
import { Component } from '@angular/core';

@Component({
  selector: 'app-form',
  template: `<form class="inline-form"><div class="form-group"><label>Email</label><input type="email" [(ngModel)]="email" (blur)="validateEmail()" [class.error]="emailError" name="email"><span class="error-msg" *ngIf="emailError">{{ emailError }}</span></div><div class="form-group"><label>Password</label><input type="password" [(ngModel)]="password" (blur)="validatePassword()" [class.error]="passwordError" name="password"><span class="error-msg" *ngIf="passwordError">{{ passwordError }}</span></div><button type="submit">Submit</button></form>`,
  styles: [`
    .inline-form { max-width: 400px; padding: 24px; background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); }
    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; margin-bottom: 6px; font-weight: 600; }
    .form-group input { width: 100%; padding: 10px 14px; border: 2px solid #e5e7eb; border-radius: 6px; transition: all 0.2s; }
    .form-group input:focus { outline: none; border-color: #6366f1; box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1); }
    .form-group input.error { border-color: #ef4444; }
    .error-msg { display: block; margin-top: 4px; color: #ef4444; font-size: 13px; animation: shake 0.3s; }
    @keyframes shake { 0%, 100% { transform: translateX(0); } 25% { transform: translateX(-5px); } 75% { transform: translateX(5px); } }
    button { width: 100%; padding: 12px; background: #6366f1; color: white; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; }
  `]
})
export class FormComponent {
  email = ''; password = '';
  emailError = ''; passwordError = '';
  validateEmail() { this.emailError = !this.email.includes('@') ? 'Invalid email' : ''; }
  validatePassword() { this.passwordError = this.password.length < 8 ? 'Password too short' : ''; }
}