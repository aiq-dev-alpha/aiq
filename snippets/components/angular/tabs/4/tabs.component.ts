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
  <div [ngStyle]="sidebarStyles" role="tablist">
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
  <div *ngIf="activeTab === i" [ngStyle]="indicatorStyles"></div>
  <span *ngIf="tab.icon" [ngStyle]="iconStyles">{{ tab.icon }}</span>
  <span>{{ tab.label }}</span>
  </button>
  </div>
  <div [ngStyle]="contentStyles" role="tabpanel" [@fadeSlide]="activeTab">
  {{ tabs[activeTab]?.content }}
  </div>
  </div>
  `,
  animations: [
  trigger('fadeSlide', [
  transition('* => *', [
  style({ opacity: 0, transform: 'translateX(20px)' }),
  animate('300ms ease-out', style({ opacity: 1, transform: 'translateX(0)' }))
  ])
  ])
  ]
})
export class TabsComponent {
  @Input() tabs: TabItem[] = [];
  @Input() theme: Partial<TabsTheme> = {};
  @Input() variant: 'default' | 'pills' | 'underline' | 'cards' | 'vertical' = 'vertical';
  @Input() activeTab: number = 0;
  @Output() tabChanged = new EventEmitter<number>();
  private defaultTheme: TabsTheme = {
  primaryColor: '#f59e0b',
  backgroundColor: '#fffbeb',
  backdropFilter: 'blur(10px)',
  textColor: '#92400e',
  activeColor: '#d97706',
  borderColor: '#fde68a',
  indicatorColor: '#f59e0b'
  };
  get appliedTheme(): TabsTheme {
  return { ...this.defaultTheme, ...this.theme };
  }
  get containerStyles() {
  return {
  display: 'flex',
  gap: '1rem',
  width: '100%',
  fontFamily: 'system-ui, -apple-system, sans-serif'
  };
  }
  get sidebarStyles() {
  return {
  display: 'flex',
  flexDirection: 'column',
  gap: '0.5rem',
  minWidth: '200px',
  padding: '1rem',
  backgroundColor: this.appliedTheme.backgroundColor,
  borderRadius: '0.5rem',
  border: `1px solid ${this.appliedTheme.borderColor}`
  };
  }
  getTabStyles(index: number) {
  const isActive = this.activeTab === index;
  const isDisabled = this.tabs[index]?.disabled;
  return {
  position: 'relative',
  padding: '0.75rem 1rem',
  border: 'none',
  backgroundColor: isActive ? '#ffffff' : 'transparent',
  color: isActive ? this.appliedTheme.activeColor : this.appliedTheme.textColor,
  cursor: isDisabled ? 'not-allowed' : 'pointer',
  fontSize: '0.95rem',
  fontWeight: isActive ? '600' : '500',
  opacity: isDisabled ? '0.5' : '1',
  transition: 'all 0.2s ease',
  borderRadius: '0.375rem',
  display: 'flex',
  alignItems: 'center',
  gap: '0.75rem',
  outline: 'none',
  textAlign: 'left',
  boxShadow: isActive ? '0 2px 4px rgba(245, 158, 11, 0.1)' : 'none'
  };
  }
  get indicatorStyles() {
  return {
  position: 'absolute',
  left: '0',
  top: '0',
  width: '4px',
  height: '100%',
  backgroundColor: this.appliedTheme.indicatorColor,
  borderRadius: '0 4px 4px 0'
  };
  }
  get iconStyles() {
  return {
  fontSize: '1.25rem'
  };
  }
  get contentStyles() {
  return {
  flex: 1,
  padding: '2rem',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  color: '#374151',
  minHeight: '300px',
  borderRadius: '0.5rem',
  border: `1px solid ${this.appliedTheme.borderColor}`
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
  case 'ArrowDown':
  newIndex = (currentIndex + 1) % this.tabs.length;
  break;
  case 'ArrowUp':
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
  newIndex = event.key === 'ArrowDown' || event.key === 'End'
  ? (newIndex + 1) % this.tabs.length
  : newIndex === 0 ? this.tabs.length - 1 : newIndex - 1;
  }
  this.selectTab(newIndex);
  }
}
