// Floating Labels Form
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-form',
  template: `<form class="floating-form"><div class="float-group" [class.filled]="name"><input type="text" [(ngModel)]="name" name="name" required><label>Full Name</label></div><div class="float-group" [class.filled]="email"><input type="email" [(ngModel)]="email" name="email" required><label>Email Address</label></div><div class="float-group" [class.filled]="message"><textarea [(ngModel)]="message" name="message" rows="4" required></textarea><label>Message</label></div><button type="submit">Send Message</button></form>`,
  styles: [`
  .floating-form { max-width: 500px; padding: 32px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 16px; }
  .float-group { position: relative; margin-bottom: 24px; }
  .float-group input, .float-group textarea { width: 100%; padding: 16px 12px 8px; border: none; border-bottom: 2px solid rgba(255, 255, 255, 0.5); background: rgba(255, 255, 255, 0.1); color: white; font-size: 15px; transition: all 0.3s; }
  .float-group input:focus, .float-group textarea:focus { outline: none; border-bottom-color: white; background: rgba(255, 255, 255, 0.15); }
  .float-group label { position: absolute; left: 12px; top: 16px; color: rgba(255, 255, 255, 0.7); pointer-events: none; transition: all 0.3s; }
  .float-group.filled label, .float-group input:focus + label, .float-group textarea:focus + label { top: 4px; font-size: 11px; color: white; }
  button { width: 100%; padding: 14px; background: white; color: #667eea; border: none; border-radius: 8px; font-weight: 700; cursor: pointer; transition: all 0.3s; }
  button:hover { transform: translateY(-2px); box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); }
  `]
})
export class FormComponent {
  name = ''; email = ''; message = '';
}
