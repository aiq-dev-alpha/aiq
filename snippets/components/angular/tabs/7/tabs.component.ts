import { Component, Input, Output, EventEmitter } from '@angular/core';
import { trigger, transition, style, animate, keyframes } from '@angular/animations';

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
          role="tab">
          <span *ngIf="tab.icon" [ngStyle]="iconStyles">{{ tab.icon }}</span>
          <span>{{ tab.label }}</span>
          <div *ngIf="activeTab === i" [ngStyle]="indicatorStyles" @shimmer></div>
        </button>
      </div>
      <div [ngStyle]="contentStyles" role="tabpanel" [@rotateIn]="activeTab">
        {{ tabs[activeTab]?.content }}
      </div>
    </div>
  `,
  animations: [
    trigger('rotateIn', [
      transition('* => *', [
        style({ opacity: 0, transform: 'rotateX(-15deg)' }),
        animate('350ms ease-out', style({ opacity: 1, transform: 'rotateX(0)' }))
      ])
    ]),
    trigger('shimmer', [
      transition(':enter', [
        animate('600ms', keyframes([
          style({ opacity: 0.5, offset: 0 }),
          style({ opacity: 1, offset: 0.5 }),
          style({ opacity: 0.7, offset: 1 })
        ]))
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
    primaryColor: '#ef4444',
    backgroundColor: '#ffffff',
    textColor: '#6b7280',
    activeColor: '#dc2626',
    borderColor: '#fee2e2',
    indicatorColor: '#ef4444'
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
      gap: '0.25rem',
      borderBottom: `2px solid ${this.appliedTheme.borderColor}`,
      padding: '0 0.5rem'
    };
  }

  getTabStyles(index: number) {
    const isActive = this.activeTab === index;
    const isDisabled = this.tabs[index]?.disabled;

    return {
      position: 'relative',
      padding: '1rem 1.5rem',
      border: 'none',
      backgroundColor: 'transparent',
      color: isActive ? this.appliedTheme.activeColor : this.appliedTheme.textColor,
      cursor: isDisabled ? 'not-allowed' : 'pointer',
      fontSize: '0.95rem',
      fontWeight: isActive ? '700' : '500',
      opacity: isDisabled ? '0.45' : '1',
      transition: 'all 0.25s ease',
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
      left: '50%',
      transform: 'translateX(-50%)',
      width: '70%',
      height: '3px',
      backgroundColor: this.appliedTheme.indicatorColor,
      borderRadius: '3px 3px 0 0'
    };
  }

  get iconStyles() {
    return {
      fontSize: '1.1rem'
    };
  }

  get contentStyles() {
    return {
      padding: '2rem',
      backgroundColor: this.appliedTheme.backgroundColor,
      color: '#374151',
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
