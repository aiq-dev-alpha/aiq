// Skeleton Button - Shows loading skeleton placeholder
import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';

interface SkeletonButtonTheme {
  baseColor: string;
  highlightColor: string;
  borderRadius: string;
}

@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-button',
  template: `
    <div class="skeleton-btn" [ngStyle]="skeletonStyles" [class.animated]="animated">
      <div class="skeleton-shimmer"></div>
    </div>
  `,
  styles: [`
    .skeleton-btn {
      position: relative;
      overflow: hidden;
      background: #e5e7eb;
      border-radius: 8px;
    }

    .skeleton-shimmer {
      position: absolute;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
      transform: translateX(-100%);
      background: linear-gradient(
        90deg,
        rgba(255, 255, 255, 0) 0%,
        rgba(255, 255, 255, 0.4) 50%,
        rgba(255, 255, 255, 0) 100%
      );
    }

    .skeleton-btn.animated .skeleton-shimmer {
      animation: shimmer 1.5s infinite;
    }

    @keyframes shimmer {
      100% {
        transform: translateX(100%);
      }
    }
  `]
})
export class ButtonComponent {
  @Input() theme: Partial<SkeletonButtonTheme> = {};
  @Input() width = '120px';
  @Input() height = '40px';
  @Input() animated = true;

  private defaultTheme: SkeletonButtonTheme = {
    baseColor: '#e5e7eb',
    highlightColor: 'rgba(255, 255, 255, 0.4)',
    borderRadius: '8px'
  };

  get appliedTheme(): SkeletonButtonTheme {
    return { ...this.defaultTheme, ...this.theme };
  }

  get skeletonStyles() {
    const t = this.appliedTheme;
    return {
      width: this.width,
      height: this.height,
      background: t.baseColor,
      borderRadius: t.borderRadius
    };
  }
}
