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
          role="tab">
          <span *ngIf="tab.icon" [ngStyle]="iconStyles">{{ tab.icon }}</span>
          <span>{{ tab.label }}</span>
        </button>
      </div>
      <div [ngStyle]="contentStyles" role="tabpanel" [@fadeScale]="activeTab">
        {{ tabs[activeTab]?.content }}
      </div>
    </div>
  `,
  animations: [
    trigger('fadeScale', [
      transition('* => *', [
        style({ opacity: 0, transform: 'scale(0.98)' }),
        animate('300ms cubic-bezier(0.4, 0, 0.2, 1)', style({ opacity: 1, transform: 'scale(1)' }))
      ])
    ])
  ]
})
export class TabsComponent {
  @Input() tabs: TabItem[] = [];
  @Input() theme: Partial<TabsTheme> = {};
  @Input() variant: 'default' | 'pills' | 'underline' | 'cards' | 'vertical' = 'cards';
  @Input() activeTab: number = 0;
  @Output() tabChanged = new EventEmitter<number>();

  private defaultTheme: TabsTheme = {
    primaryColor: '#14b8a6',
    backgroundColor: '#0f172a',
        backdropFilter: 'blur(10px)',
    textColor: '#94a3b8',
    activeColor: '#5eead4',
    borderColor: '#1e293b',
    indicatorColor: '#14b8a6'
  };

  get appliedTheme(): TabsTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get containerStyles() {
    return {
      width: '100%',
      fontFamily: 'system-ui, -apple-system, sans-serif',
      backgroundColor: this.appliedTheme.backgroundColor,
      padding: '1.5rem',
      borderRadius: '1rem'
    };
  }

  get tabListStyles() {
    return {
      display: 'flex',
      gap: '1rem',
      marginBottom: '1rem'
    };
  }

  getTabStyles(index: number) {
    const isActive = this.activeTab === index;
    const isDisabled = this.tabs[index]?.disabled;

    return {
      padding: '0.875rem 1.5rem',
      border: `2px solid ${isActive ? this.appliedTheme.indicatorColor : this.appliedTheme.borderColor}`,
      backgroundColor: isActive ? this.appliedTheme.borderColor : 'transparent',
      color: isActive ? this.appliedTheme.activeColor : this.appliedTheme.textColor,
      cursor: isDisabled ? 'not-allowed' : 'pointer',
      fontSize: '0.925rem',
      fontWeight: isActive ? '700' : '500',
      opacity: isDisabled ? '0.4' : '1',
      transition: 'all 0.3s ease',
      borderRadius: '0.625rem',
      display: 'flex',
      alignItems: 'center',
      gap: '0.5rem',
      outline: 'none',
      boxShadow: isActive ? `0 0 20px ${this.appliedTheme.indicatorColor}40` : 'none'
    };
  }

  get iconStyles() {
    return {
      fontSize: '1.15rem'
    };
  }

  get contentStyles() {
    return {
      padding: '2rem',
      backgroundColor: this.appliedTheme.borderColor,
      color: '#e2e8f0',
      minHeight: '220px',
      borderRadius: '0.75rem',
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
