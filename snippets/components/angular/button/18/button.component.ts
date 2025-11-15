// Social Button - Social media branded buttons
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';

interface SocialButtonTheme {
  brandColor: string;
  hoverColor: string;
  textColor: string;
}

type SocialPlatform = 'facebook' | 'twitter' | 'google' | 'github' | 'linkedin' | 'instagram' | 'youtube' | 'tiktok' | 'discord';

@Component({
  standalone: true,
  imports: [CommonModule],
  selector: 'app-button',
  template: `
    <button
      class="social-btn"
      [ngStyle]="buttonStyles"
      [class.icon-only]="!showLabel"
      [class.rounded]="rounded"
      [disabled]="disabled"
      [attr.aria-label]="ariaLabel || platform"
      (click)="handleClick($event)">
      <span class="social-icon">{{ icon }}</span>
      <span *ngIf="showLabel" class="social-label">
        {{ label || ('Continue with ' + capitalizedPlatform) }}
      </span>
    </button>
  `,
  styles: [`
    .social-btn {
      border: none;
      cursor: pointer;
      font-family: inherit;
      font-weight: 600;
      font-size: 15px;
      padding: 12px 24px;
      border-radius: 8px;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      min-width: 200px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .social-btn.icon-only {
      min-width: auto;
      width: 48px;
      height: 48px;
      padding: 0;
      border-radius: 50%;
    }

    .social-btn.rounded {
      border-radius: 24px;
    }

    .social-btn:hover:not(:disabled) {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
      filter: brightness(1.05);
    }

    .social-btn:active:not(:disabled) {
      transform: translateY(0);
    }

    .social-btn:disabled {
      cursor: not-allowed;
      opacity: 0.6;
    }

    .social-icon {
      font-size: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .social-label {
      white-space: nowrap;
    }
  `]
})
export class ButtonComponent {
  @Input() platform: SocialPlatform = 'facebook';
  @Input() label?: string;
  @Input() showLabel = true;
  @Input() rounded = false;
  @Input() disabled = false;
  @Input() ariaLabel?: string;
  @Output() clicked = new EventEmitter<MouseEvent>();

  private platformConfig: Record<SocialPlatform, { icon: string; color: string; hover: string }> = {
    facebook: { icon: 'f', color: '#1877f2', hover: '#166fe5' },
    twitter: { icon: '𝕏', color: '#1da1f2', hover: '#1a8cd8' },
    google: { icon: 'G', color: '#4285f4', hover: '#357ae8' },
    github: { icon: '★', color: '#24292e', hover: '#1b1f23' },
    linkedin: { icon: 'in', color: '#0a66c2', hover: '#0958a5' },
    instagram: { icon: '📷', color: '#e4405f', hover: '#d62d50' },
    youtube: { icon: '▶', color: '#ff0000', hover: '#e60000' },
    tiktok: { icon: '♪', color: '#000000', hover: '#1a1a1a' },
    discord: { icon: '🎮', color: '#5865f2', hover: '#4752c4' }
  };

  get config() {
    return this.platformConfig[this.platform];
  }

  get icon() {
    return this.config.icon;
  }

  get capitalizedPlatform() {
    return this.platform.charAt(0).toUpperCase() + this.platform.slice(1);
  }

  get buttonStyles() {
    return {
      background: this.config.color,
      color: '#ffffff'
    };
  }

  handleClick(event: MouseEvent): void {
    if (!this.disabled) {
      this.clicked.emit(event);
    }
  }
}
