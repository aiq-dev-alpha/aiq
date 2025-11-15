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
      <div [ngStyle]="contentStyles" role="tabpanel" [@bounceIn]="activeTab">
        {{ tabs[activeTab]?.content }}
      </div>
    </div>
  `,
  animations: [
    trigger('bounceIn', [
      transition('* => *', [
        style({ opacity: 0, transform: 'scale(0.9)' }),
        animate('400ms cubic-bezier(0.68, -0.55, 0.265, 1.55)', style({ opacity: 1, transform: 'scale(1)' }))
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
    primaryColor: '#06b6d4',
    backgroundColor: '#ecfeff',
    textColor: '#0e7490',
    activeColor: '#ffffff',
    borderColor: '#a5f3fc',
    indicatorColor: '#06b6d4'
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
      padding: '0.75rem',
      backgroundColor: this.appliedTheme.backgroundColor,
      borderRadius: '1rem'
    };
  }

  getTabStyles(index: number) {
    const isActive = this.activeTab === index;
    const isDisabled = this.tabs[index]?.disabled;

    return {
      padding: '0.75rem 1.5rem',
      border: 'none',
      backgroundColor: isActive ? this.appliedTheme.indicatorColor : 'transparent',
      color: isActive ? this.appliedTheme.activeColor : this.appliedTheme.textColor,
      cursor: isDisabled ? 'not-allowed' : 'pointer',
      fontSize: '0.9rem',
      fontWeight: isActive ? '700' : '500',
      opacity: isDisabled ? '0.4' : '1',
      transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
      borderRadius: '0.75rem',
      display: 'flex',
      alignItems: 'center',
      gap: '0.5rem',
      outline: 'none',
      boxShadow: isActive ? '0 4px 14px rgba(6, 182, 212, 0.4)' : 'none',
      transform: isActive ? 'translateY(-1px)' : 'translateY(0)'
    };
  }

  get iconStyles() {
    return {
      fontSize: '1.2rem'
    };
  }

  get contentStyles() {
    return {
      padding: '2rem',
      backgroundColor: '#ffffff',
      color: '#374151',
      minHeight: '200px',
      borderRadius: '0.75rem',
      marginTop: '1rem',
      border: `2px solid ${this.appliedTheme.borderColor}`
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
