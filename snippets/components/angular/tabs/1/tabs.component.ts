import { Component, Input, Output, EventEmitter, HostListener } from '@angular/core';
import { trigger, state, style, transition, animate } from '@angular/animations';

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
  <div [ngStyle]="tabListStyles" role="tablist" class="tab-list">
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
  <div *ngIf="activeTab === i" [ngStyle]="indicatorStyles" @slideIn></div>
  </button>
  </div>
  <div [ngStyle]="contentStyles" role="tabpanel" [@fadeSlide]="activeTab" class="tab-content">
  {{ tabs[activeTab]?.content }}
  </div>
  </div>
  `,
  animations: [
  trigger('fadeSlide', [
  transition('* => *', [
  style({ opacity: 0, transform: 'translateX(-10px)' }),
  animate('300ms ease-out', style({ opacity: 1, transform: 'translateX(0)' }))
  ])
  ]),
  trigger('slideIn', [
  transition(':enter', [
  style({ width: 0 }),
  animate('200ms ease-out', style({ width: '100%' }))
  ])
  ])
  ]
})
export class TabsComponent {
  @Input() tabs: TabItem[] = [];
  @Input() theme: Partial<TabsTheme> = {};
  @Input() variant: 'default' | 'pills' | 'underline' | 'cards' | 'vertical' = 'underline';
  @Input() activeTab: number = 0;
  @Output() tabChanged = new EventEmitter<number>();

  private defaultTheme: TabsTheme = {
  primaryColor: '#3b82f6',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  textColor: '#64748b',
  activeColor: '#1e40af',
  borderColor: '#e2e8f0',
  indicatorColor: '#3b82f6'
  };

  get appliedTheme(): TabsTheme {
  return { ...this.defaultTheme, ...this.theme };
  }

  get containerStyles() {
  return {
  width: '100%',
  fontFamily: 'system-ui, -apple-system, sans-serif'
  };
  }

  get tabListStyles() {
  return {
  display: 'flex',
  gap: '0.5rem',
  borderBottom: `2px solid ${this.appliedTheme.borderColor}`,
  backgroundColor: this.appliedTheme.backgroundColor,
  padding: '0.5rem'
  };
  }

  getTabStyles(index: number) {
  const isActive = this.activeTab === index;
  const isDisabled = this.tabs[index]?.disabled;

  return {
  position: 'relative',
  padding: '0.75rem 1.5rem',
  border: 'none',
  backgroundColor: 'transparent',
  backdropFilter: 'blur(10px)',
  color: isActive ? this.appliedTheme.activeColor : this.appliedTheme.textColor,
  cursor: isDisabled ? 'not-allowed' : 'pointer',
  fontSize: '0.95rem',
  fontWeight: isActive ? '600' : '500',
  opacity: isDisabled ? '0.5' : '1',
  transition: 'all 0.2s ease',
  display: 'flex',
  alignItems: 'center',
  gap: '0.5rem',
  outline: 'none'
  };
  }

  get indicatorStyles() {
  return {
  position: 'absolute',
  bottom: '-2px',
  left: '0',
  height: '3px',
  backgroundColor: this.appliedTheme.indicatorColor,
  borderRadius: '2px 2px 0 0'
  };
  }

  get iconStyles() {
  return {
  fontSize: '1.2rem'
  };
  }

  get contentStyles() {
  return {
  padding: '1.5rem',
  backgroundColor: this.appliedTheme.backgroundColor,
  color: this.appliedTheme.textColor,
  minHeight: '200px',
  borderRadius: '0 0 0.5rem 0.5rem'
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
