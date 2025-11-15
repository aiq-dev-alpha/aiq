import { Component, Input, Output, EventEmitter } from '@angular/core';
interface ListItem {
  id: string;
  title: string;
  subtitle?: string;
  avatar?: string;
}
@Component({
  selector: 'app-list',
  template: `
  <div class="card-list">
  <div *ngFor="let item of items"
  class="list-card"
  (click)="onSelect(item)"
  (mouseenter)="hoveredId = item.id"
  (mouseleave)="hoveredId = null">
  <div *ngIf="item.avatar" class="avatar">
  <img [src]="item.avatar" alt="{{ item.title }}" />
  </div>
  <div class="content">
  <h4 class="title">{{ item.title }}</h4>
  <p *ngIf="item.subtitle" class="subtitle">{{ item.subtitle }}</p>
  </div>
  <svg *ngIf="hoveredId === item.id"
  class="arrow"
  fill="none"
  viewBox="0 0 24 24"
  stroke="currentColor">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
  </svg>
  </div>
  </div>
  `,
  styles: [`
  .card-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
  max-width: 600px;
  }
  .list-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  cursor: pointer;
  transition: all 200ms;
  }
  .list-card:hover {
  box-shadow: 0 8px 20px rgba(0,0,0,0.12);
  transform: translateX(4px);
  }
  .avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  overflow: hidden;
  }
  .avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  }
  .content {
  flex: 1;
  }
  .title {
  margin: 0 0 4px 0;
  font-size: 18px;
  font-weight: 700;
  color: #1f2937;
  }
  .subtitle {
  margin: 0;
  font-size: 14px;
  color: #6b7280;
  }
  .arrow {
  width: 20px;
  height: 20px;
  color: #3b82f6;
  animation: slideIn 200ms;
  }
  @keyframes slideIn {
  from { opacity: 0; transform: translateX(-8px); }
  to { opacity: 1; transform: translateX(0); }
  }
  `]
})
export class ListComponent {
  @Input() items: ListItem[] = [];
  @Output() select = new EventEmitter<ListItem>();
  hoveredId: string | null = null;
  onSelect(item: ListItem): void {
  this.select.emit(item);
  }
}
