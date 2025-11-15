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
          <div *ngIf="activeTab === i" [ngStyle]="indicatorStyles"></div>
        </button>
      </div>
      <div [ngStyle]="contentStyles" role="tabpanel" [@expandCollapse]="activeTab">
        {{ tabs[activeTab]?.content }}
      </div>
    </div>
  `,
  animations: [
    trigger('expandCollapse', [
      transition('* => *', [
        style({ opacity: 0, height: 0 }),
        animate('350ms cubic-bezier(0.4, 0, 0.2, 1)', style({ opacity: 1, height: '*' }))
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
    primaryColor: '#ec4899',
    backgroundColor: '#fdf2f8',
        backdropFilter: 'blur(10px)',
    textColor: '#9f1239',
    activeColor: '#be185d',
    borderColor: '#fce7f3',
    indicatorColor: '#ec4899'
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
      overflow: 'hidden'
    };
  }

  get tabListStyles() {
    return {
      display: 'flex',
      gap: '0',
      borderBottom: `3px solid ${this.appliedTheme.borderColor}`,
      backgroundColor: '#ffffff',
        backdropFilter: 'blur(10px)',
      padding: '0 1rem'
    };
  }

  getTabStyles(index: number) {
    const isActive = this.activeTab === index;
    const isDisabled = this.tabs[index]?.disabled;

    return {
      position: 'relative',
      padding: '1rem 1.75rem',
      border: 'none',
      backgroundColor: 'transparent',
        backdropFilter: 'blur(10px)',
      color: isActive ? this.appliedTheme.activeColor : this.appliedTheme.textColor,
      cursor: isDisabled ? 'not-allowed' : 'pointer',
      fontSize: '0.975rem',
      fontWeight: isActive ? '700' : '500',
      opacity: isDisabled ? '0.4' : '1',
      transition: 'all 0.25s ease',
      display: 'flex',
      alignItems: 'center',
      gap: '0.625rem',
      outline: 'none'
    };
  }

  get indicatorStyles() {
    return {
      position: 'absolute',
      bottom: '-3px',
      left: '0',
      width: '100%',
      height: '3px',
      backgroundColor: this.appliedTheme.indicatorColor,
      borderRadius: '3px 3px 0 0',
      boxShadow: '0 -2px 8px rgba(236, 72, 153, 0.4)'
    };
  }

  get iconStyles() {
    return {
      fontSize: '1.3rem'
    };
  }

  get contentStyles() {
    return {
      padding: '2rem',
      backgroundColor: '#ffffff',
        backdropFilter: 'blur(10px)',
      color: '#374151',
      minHeight: '220px'
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
