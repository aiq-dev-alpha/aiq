import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { AlertController, LoadingController, ModalController, ToastController } from '@ionic/angular';

@Component({
  selector: 'app-contact-form',
  templateUrl: './contact-form.page.html',
  styleUrls: ['./contact-form.page.scss'],
})
export class ContactFormPage implements OnInit {
  contactForm: FormGroup;
  isSubmitting = false;

  priorities = [
    { value: 'low', label: 'Low', color: 'success' },
    { value: 'medium', label: 'Medium', color: 'warning' },
    { value: 'high', label: 'High', color: 'danger' },
    { value: 'urgent', label: 'Urgent', color: 'dark' }
  ];

  constructor(
    private formBuilder: FormBuilder,
    private alertController: AlertController,
    private loadingController: LoadingController,
    private modalController: ModalController,
    private toastController: ToastController
  ) {
    this.contactForm = this.createForm();
  }

  ngOnInit() {}

  private createForm(): FormGroup {
    return this.formBuilder.group({
      name: ['', [Validators.required, Validators.minLength(2)]],
      email: ['', [Validators.required, Validators.email]],
      phone: ['', [Validators.pattern(/^[\+]?[\d\s\-\(\)]+$/)]],
      priority: ['medium', Validators.required],
      subject: ['', [Validators.required, Validators.minLength(5)]],
      message: ['', [Validators.required, Validators.minLength(10), Validators.maxLength(1000)]]
    });
  }

  get formControls() {
    return this.contactForm.controls;
  }

  getErrorMessage(fieldName: string): string {
    const field = this.formControls[fieldName];

    if (field.hasError('required')) {
      return `${this.getFieldLabel(fieldName)} is required`;
    }

    if (field.hasError('email')) {
      return 'Please enter a valid email address';
    }

    if (field.hasError('minlength')) {
      const minLength = field.errors?.['minlength'].requiredLength;
      return `${this.getFieldLabel(fieldName)} must be at least ${minLength} characters`;
    }

    if (field.hasError('maxlength')) {
      const maxLength = field.errors?.['maxlength'].requiredLength;
      return `${this.getFieldLabel(fieldName)} cannot exceed ${maxLength} characters`;
    }

    if (field.hasError('pattern')) {
      return 'Please enter a valid phone number';
    }

    return '';
  }

  private getFieldLabel(fieldName: string): string {
    const labels: { [key: string]: string } = {
      name: 'Name',
      email: 'Email',
      phone: 'Phone',
      subject: 'Subject',
      message: 'Message'
    };
    return labels[fieldName] || fieldName;
  }

  getPriorityColor(priority: string): string {
    const priorityObj = this.priorities.find(p => p.value === priority);
    return priorityObj ? priorityObj.color : 'medium';
  }

  async onSubmit() {
    if (this.contactForm.valid) {
      await this.submitForm();
    } else {
      await this.showValidationErrors();
    }
  }

  private async submitForm() {
    const loading = await this.loadingController.create({
      message: 'Sending message...',
      spinner: 'crescent'
    });

    await loading.present();
    this.isSubmitting = true;

    try {
      // Simulate API call
      await this.delay(2000);

      await loading.dismiss();
      await this.showSuccessMessage();
      this.clearForm();

    } catch (error) {
      await loading.dismiss();
      await this.showErrorMessage('Failed to send message. Please try again.');
    } finally {
      this.isSubmitting = false;
    }
  }

  private async showValidationErrors() {
    const alert = await this.alertController.create({
      header: 'Validation Error',
      message: 'Please fill in all required fields correctly.',
      buttons: ['OK']
    });

    await alert.present();
  }

  private async showSuccessMessage() {
    const alert = await this.alertController.create({
      header: 'Success!',
      message: 'Thank you for contacting us! We\'ll get back to you soon.',
      buttons: [
        {
          text: 'OK',
          handler: () => {
            this.dismiss();
          }
        }
      ]
    });

    await alert.present();
  }

  private async showErrorMessage(message: string) {
    const toast = await this.toastController.create({
      message: message,
      duration: 3000,
      color: 'danger',
      position: 'top'
    });

    await toast.present();
  }

  clearForm() {
    this.contactForm.reset({
      priority: 'medium'
    });
  }

  async dismiss() {
    await this.modalController.dismiss();
  }

  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  // Character count for message field
  getMessageCharacterCount(): string {
    const messageLength = this.formControls['message'].value?.length || 0;
    return `${messageLength}/1000`;
  }

  // Validation helper methods
  isFieldInvalid(fieldName: string): boolean {
    const field = this.formControls[fieldName];
    return field.invalid && (field.dirty || field.touched);
  }

  isFieldValid(fieldName: string): boolean {
    const field = this.formControls[fieldName];
    return field.valid && (field.dirty || field.touched);
  }
}