import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-empty-state-screen',
  template: `
    <ion-content class="empty-state-container">
      <div class="content-wrapper">
        <!-- Icon -->
        <div class="icon-container">
          <ion-icon [name]="iconName || 'archive-outline'" class="empty-icon"></ion-icon>
        </div>

        <!-- Content -->
        <div class="content">
          <h2 class="title">{{ title || 'Nothing here yet' }}</h2>
          <p class="message">
            {{ message || "It looks like there's no content to show right now. Try refreshing or come back later." }}
          </p>
        </div>

        <!-- Action Button -->
        <div class="button-container" *ngIf="buttonText && onAction">
          <ion-button
            expand="block"
            fill="solid"
            color="primary"
            class="action-button"
            (click)="handleAction()"
          >
            {{ buttonText }}
          </ion-button>
        </div>
      </div>
    </ion-content>
  `,
  styles: [`
    .empty-state-container {
      --background: #ffffff;
    }

    .content-wrapper {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      padding: 32px;
      text-align: center;
    }

    .icon-container {
      margin-bottom: 32px;
    }

    .empty-icon {
      font-size: 60px;
      color: #9CA3AF;
      width: 120px;
      height: 120px;
      background: rgba(156, 163, 175, 0.1);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .content {
      margin-bottom: 32px;
      max-width: 280px;
    }

    .title {
      font-size: 24px;
      font-weight: 700;
      color: #1F2937;
      margin-bottom: 12px;
    }

    .message {
      font-size: 16px;
      color: #6B7280;
      line-height: 1.5;
    }

    .button-container {
      width: 100%;
      max-width: 280px;
    }

    .action-button {
      --border-radius: 12px;
      height: 48px;
      margin: 0;
      font-weight: 600;
    }
  `]
})
export class EmptyStateScreenComponent implements OnInit {
  @Input() title?: string;
  @Input() message?: string;
  @Input() iconName?: string;
  @Input() buttonText?: string;
  @Input() onAction?: () => void;

  ngOnInit() {}

  handleAction() {
    if (this.onAction) {
      this.onAction();
    }
  }
}