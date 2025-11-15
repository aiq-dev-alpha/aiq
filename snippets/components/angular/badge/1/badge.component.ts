import { Component, Input } from '@angular/core';

interface ComponentTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
}

@Component({
  selector: 'app-component',
  template: `
  <div [ngStyle]="componentStyles">
  <ng-content></ng-content>
  </div>
  `
})
export class ComponentComponent {
  @Input() theme: Partial<ComponentTheme> = {};
  @Input() variant: 'default' | 'outlined' | 'filled' = 'default';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';

  private defaultTheme: ComponentTheme = {
  primaryColor: '#3b82f6',
  secondaryColor: '#8b5cf6',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  textColor: '#111827',
  borderColor: '#e5e7eb'
  };

  get appliedTheme(): ComponentTheme {
  return { ...this.defaultTheme, ...this.theme };
  }

  get componentStyles() {
  const sizeMap = {
  sm: { padding: '0.5rem 1rem', fontSize: '0.875rem' },
  md: { padding: '0.75rem 1.5rem', fontSize: '1rem' },
  lg: { padding: '1rem 2rem', fontSize: '1.125rem' }
  };

  const variantMap = {
  default: {
  backgroundColor: this.appliedTheme.backgroundColor,
  border: `1px solid ${this.appliedTheme.borderColor}`
  },
  outlined: {
  backgroundColor: 'transparent',
  backdropFilter: 'blur(10px)',
  border: `2px solid ${this.appliedTheme.primaryColor}`
  },
  filled: {
  backgroundColor: this.appliedTheme.primaryColor,
  color: '#ffffff'
  }
  };

  return {
  ...sizeMap[this.size],
  ...variantMap[this.variant],
  color: this.appliedTheme.textColor,
  borderRadius: '0.5rem',
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center'
  };
  }
}
