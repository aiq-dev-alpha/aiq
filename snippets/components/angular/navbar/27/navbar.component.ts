// Magnetic Hover Items Navbar
import { Component } from '@angular/core';

@Component({
  selector: 'app-navbar',
  template: `<nav class="magnetic-nav"><div class="nav-items"><a class="nav-item" (mousemove)="onItemHover($event, i)" (mouseleave)="onItemLeave(i)" *ngFor="let item of items; let i = index" [style.transform]="transforms[i]"><ng-content></ng-content></a></div></nav>`,
  styles: [`
    .magnetic-nav { background: linear-gradient(135deg, #1e293b 0%, #334155 100%); padding: 16px 32px; }
    .nav-items { display: flex; gap: 16px; }
    .nav-item { color: white; text-decoration: none; padding: 8px 16px; border-radius: 8px; transition: transform 0.1s ease; cursor: pointer; }
  `]
})
export class NavbarComponent {
  items = [1, 2, 3, 4];
  transforms: string[] = ['', '', '', ''];
  onItemHover(e: MouseEvent, i: number): void {
    const rect = (e.target as HTMLElement).getBoundingClientRect();
    const x = (e.clientX - rect.left - rect.width / 2) / 5;
    const y = (e.clientY - rect.top - rect.height / 2) / 5;
    this.transforms[i] = `translate(${x}px, ${y}px)`;
  }
  onItemLeave(i: number): void { this.transforms[i] = ''; }
}