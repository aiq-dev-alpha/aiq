import { Component, Input, Output, EventEmitter, OnInit, OnDestroy, HostListener } from '@angular/core';
interface ModalTheme {
  primaryColor: string;
  secondaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  overlayColor: string;
}
type ModalSize = 'small' | 'medium' | 'large' | 'full';
type ModalPosition = 'center' | 'top' | 'bottom' | 'left' | 'right';
@Component({
  selector: 'app-modal',
  template: `
  <div class="modal-overlay"
  *ngIf="isOpen"
  [ngStyle]="overlayStyles"
  (click)="onOverlayClick()"
  role="presentation">
  <div class="modal-container"
  [ngStyle]="containerStyles"
  (click)="$event.stopPropagation()"
  role="dialog"
  aria-modal="true"
  [attr.aria-labelledby]="'modal-title-' + modalId"
  [attr.aria-describedby]="'modal-body-' + modalId">
  <div class="modal-header" [ngStyle]="headerStyles">
  <h2 [id]="'modal-title-' + modalId" [ngStyle]="titleStyles">{{ title }}</h2>
  <button class="close-button"
  [ngStyle]="closeButtonStyles"
  (click)="close()"
  aria-label="Close modal"
  type="button">
  <span aria-hidden="true">&times;</span>
  </button>
  </div>
  <div class="modal-body"
  [id]="'modal-body-' + modalId"
  [ngStyle]="bodyStyles">
  <ng-content></ng-content>
  </div>
  <div class="modal-footer" [ngStyle]="footerStyles" *ngIf="showFooter">
  <ng-content select="[footer]"></ng-content>
  </div>
  </div>
  </div>
  `,
  styles: [`
  .modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  z-index: 1000;
  overflow: auto;
  }
  .modal-container {
  margin: auto;
  display: flex;
  flex-direction: column;
  max-height: 90vh;
  animation: fadeIn 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  }
  .modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-shrink: 0;
  }
  .modal-body {
  flex: 1;
  overflow-y: auto;
  scrollbar-width: thin;
  }
  .modal-footer {
  flex-shrink: 0;
  }
  .close-button {
  background: none;
  border: none;
  font-size: 1.75rem;
  cursor: pointer;
  padding: 0.5rem;
  line-height: 1;
  border-radius: 0.375rem;
  transition: all 0.2s ease;
  }
  .close-button:hover {
  transform: scale(1.1);
  opacity: 1 !important;
  }
  .close-button:focus {
  outline: 2px solid currentColor;
  outline-offset: 2px;
  }
  @keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
  }
  @keyframes slideIn {
  from { transform: translateX(-20px); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
  }
  @keyframes scaleIn {
  from { transform: scale(0.95); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
  }
  `]
})
export class ModalComponent implements OnInit, OnDestroy {
  @Input() isOpen = false;
  @Input() title = 'Modal Title';
  @Input() size: ModalSize = 'medium';
  @Input() position: ModalPosition = 'center';
  @Input() closeOnOverlayClick = true;
  @Input() showFooter = true;
  @Input() theme: Partial<ModalTheme> = {};
  @Output() modalClose = new EventEmitter<void>();
  @Output() modalOpen = new EventEmitter<void>();
  modalId = `modal-${Math.random().toString(36).substr(2, 9)}`;
  private previouslyFocusedElement: HTMLElement | null = null;
  private defaultTheme: ModalTheme = {
  primaryColor: '#3b82f6',
  secondaryColor: '#8b5cf6',
  backgroundColor: '#ffffff',
  backdropFilter: 'blur(10px)',
  textColor: '#1f2937',
  borderColor: '#e5e7eb',
  overlayColor: 'rgba(0, 0, 0, 0.5)'
  };
  get appliedTheme(): ModalTheme {
  return { ...this.defaultTheme, ...this.theme };
  }
  get overlayStyles() {
  const positionMap = {
  center: { alignItems: 'center', justifyContent: 'center' },
  top: { alignItems: 'flex-start', justifyContent: 'center', paddingTop: '2rem' },
  bottom: { alignItems: 'flex-end', justifyContent: 'center', paddingBottom: '2rem' },
  left: { alignItems: 'center', justifyContent: 'flex-start', paddingLeft: '2rem' },
  right: { alignItems: 'center', justifyContent: 'flex-end', paddingRight: '2rem' }
  };
  return {
  backgroundColor: this.appliedTheme.overlayColor,
  backdropFilter: 'blur(2px)',
  ...positionMap[this.position],
  animation: 'fadeIn 0.25s ease-out'
  };
  }
  get containerStyles() {
  const sizeMap = {
  small: { width: '400px', maxWidth: '90vw' },
  medium: { width: '600px', maxWidth: '90vw' },
  large: { width: '800px', maxWidth: '90vw' },
  full: { width: '95vw', height: '95vh' }
  };
  return {
  ...sizeMap[this.size],
  backgroundColor: this.appliedTheme.backgroundColor,
  borderRadius: '0.75rem',
  boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.1)',
  border: `1px solid ${this.appliedTheme.primaryColor}`
  };
  }
  get headerStyles() {
  return {
  padding: '1.5rem',
  borderBottom: `2px solid ${this.appliedTheme.borderColor}`,
  background: `linear-gradient(135deg, ${this.appliedTheme.primaryColor}10, transparent)`
  };
  }
  get titleStyles() {
  return {
  margin: '0',
  fontSize: '1.5rem',
  fontWeight: '700',
  color: this.appliedTheme.primaryColor,
  letterSpacing: '-0.025em'
  };
  }
  get bodyStyles() {
  return {
  padding: '1.5rem',
  color: this.appliedTheme.textColor,
  lineHeight: '1.6'
  };
  }
  get footerStyles() {
  return {
  padding: '1rem 1.5rem',
  borderTop: `1px solid ${this.appliedTheme.borderColor}`,
  display: 'flex',
  justifyContent: 'flex-end',
  gap: '0.75rem',
  backgroundColor: '#f9fafb',
  backdropFilter: 'blur(10px)'
  };
  }
  get closeButtonStyles() {
  return {
  color: this.appliedTheme.primaryColor,
  opacity: '0.7'
  };
  }
  ngOnInit() {
  if (this.isOpen) {
  this.onOpen();
  }
  }
  ngOnDestroy() {
  this.restoreFocus();
  this.unlockBodyScroll();
  }
  ngOnChanges(changes: any) {
  if (changes.isOpen) {
  if (changes.isOpen.currentValue) {
  this.onOpen();
  } else {
  this.onClose();
  }
  }
  }
  @HostListener('document:keydown.escape')
  onEscapeKey() {
  if (this.isOpen) {
  this.close();
  }
  }
  onOverlayClick() {
  if (this.closeOnOverlayClick) {
  this.close();
  }
  }
  close() {
  this.isOpen = false;
  this.onClose();
  this.modalClose.emit();
  }
  open() {
  this.isOpen = true;
  this.onOpen();
  this.modalOpen.emit();
  }
  private onOpen() {
  this.saveFocus();
  this.lockBodyScroll();
  setTimeout(() => this.setFocusTrap(), 100);
  }
  private onClose() {
  this.restoreFocus();
  this.unlockBodyScroll();
  }
  private saveFocus() {
  this.previouslyFocusedElement = document.activeElement as HTMLElement;
  }
  private restoreFocus() {
  if (this.previouslyFocusedElement) {
  this.previouslyFocusedElement.focus();
  }
  }
  private lockBodyScroll() {
  document.body.style.overflow = 'hidden';
  }
  private unlockBodyScroll() {
  document.body.style.overflow = '';
  }
  private setFocusTrap() {
  const modalElement = document.querySelector(`[id="${this.modalId}"]`);
  if (modalElement) {
  const focusableElements = modalElement.querySelectorAll(
  'button:not([disabled]), [href], input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'
  );
  if (focusableElements.length > 0) {
  (focusableElements[0] as HTMLElement).focus();
  }
  }
  }
}
