import { Component, Input, Output, EventEmitter } from '@angular/core';
import { trigger, transition, style, animate } from '@angular/animations';
interface TabItem {
  id: string;
  label: string;
  icon?: string;
  content: string;
  disabled?: boolean;
}
interface TabsTheme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  activeColor: string;
  borderColor: string;
  indicatorColor: string;
}
@Component({
  selector: 'app-tabs',
  template: `
  <div [ngStyle]="containerStyles" class="tabs-container">
  <div [ngStyle]="tabListStyles" role="tablist">
  <button
  *ngFor="let tab of tabs; let i = index"
  [ngStyle]="getTabStyles(i)"
  [attr.aria-selected]="activeTab === i"
  [attr.aria-disabled]="tab.disabled"
  [disabled]="tab.disabled"
  (click)="selectTab(i)"
  (keydown)="onKeyDown($event, i)"
  role="tab"
  class="tab-button">
  <span *ngIf="tab.icon" [ngStyle]="iconStyles">{{ tab.icon }}</span>
  <span>{{ tab.label }}</span>
  </button>
  </div>
  <div [ngStyle]="contentStyles" role="tabpanel" [@fadeIn]="activeTab">
  {{ tabs[activeTab]?.content }}
  </div>
  </div>
  `,
  animations: [
  trigger('fadeIn', [
  transition('* => *', [
  style({ opacity: 0, transform: 'scale(0.95)' }),
  animate('250ms ease-out', style({ opacity: 1, transform: 'scale(1)' }))
  ])
  ])
  ]
})
export class TabsComponent {
  @Input() tabs: TabItem[] = [];
  @Input() theme: Partial<TabsTheme> = {};
  @Input() variant: 'default' | 'pills' | 'underline' | 'cards' | 'vertical' = 'pills';
  @Input() activeTab: number = 0;
  @Output() tabChanged = new EventEmitter<number>();
  private defaultTheme: TabsTheme = {
  primaryColor: '#8b5cf6',
  backgroundColor: '#f9fafb',
  backdropFilter: 'blur(10px)',
  textColor: '#6b7280',
  activeColor: '#ffffff',
  borderColor: '#e5e7eb',
  indicatorColor: '#8b5cf6'
  };
  get appliedTheme(): TabsTheme {
  return { ...this.defaultTheme, ...this.theme };
  }
  get containerStyles() {
  return {
  width: '100%',
  fontFamily: 'system-ui, -apple-system, sans-serif',
  backgroundColor: this.appliedTheme.backgroundColor,
  borderRadius: '0.75rem',
  padding: '1rem'
  };
  }
  get tabListStyles() {
  return {
  display: 'flex',
  gap: '0.75rem',
  padding: '0.5rem',
  backgroundColor: '#e5e7eb',
  backdropFilter: 'blur(10px)',
  borderRadius: '0.625rem'
  };
  }
  getTabStyles(index: number) {
  const isActive = this.activeTab === index;
  const isDisabled = this.tabs[index]?.disabled;
  return {
  padding: '0.625rem 1.25rem',
  border: 'none',
  backgroundColor: isActive ? this.appliedTheme.indicatorColor : 'transparent',
  color: isActive ? this.appliedTheme.activeColor : this.appliedTheme.textColor,
  cursor: isDisabled ? 'not-allowed' : 'pointer',
  fontSize: '0.9rem',
  fontWeight: isActive ? '600' : '500',
  opacity: isDisabled ? '0.4' : '1',
  transition: 'all 0.25s ease',
  borderRadius: '0.5rem',
  display: 'flex',
  alignItems: 'center',
  gap: '0.5rem',
  outline: 'none',
  boxShadow: isActive ? '0 2px 8px rgba(139, 92, 246, 0.3)' : 'none'
  };
  }
  get iconStyles() {
  return {
  fontSize: '1.1rem'
  };
  }
  get contentStyles() {
  return {
  padding: '1.5rem',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  color: '#374151',
  minHeight: '200px',
  borderRadius: '0.5rem',
  marginTop: '1rem',
  boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)'
  };
  }
  selectTab(index: number) {
  if (!this.tabs[index]?.disabled && index !== this.activeTab) {
  this.activeTab = index;
  this.tabChanged.emit(index);
  }
  }
  onKeyDown(event: KeyboardEvent, currentIndex: number) {
  let newIndex = currentIndex;
  switch (event.key) {
  case 'ArrowRight':
  newIndex = (currentIndex + 1) % this.tabs.length;
  break;
  case 'ArrowLeft':
  newIndex = currentIndex === 0 ? this.tabs.length - 1 : currentIndex - 1;
  break;
  case 'Home':
  newIndex = 0;
  break;
  case 'End':
  newIndex = this.tabs.length - 1;
  break;
  default:
  return;
  }
  event.preventDefault();
  while (this.tabs[newIndex]?.disabled && newIndex !== currentIndex) {
  newIndex = event.key === 'ArrowRight' || event.key === 'End'
  ? (newIndex + 1) % this.tabs.length
  : newIndex === 0 ? this.tabs.length - 1 : newIndex - 1;
  }
  this.selectTab(newIndex);
  }
}
