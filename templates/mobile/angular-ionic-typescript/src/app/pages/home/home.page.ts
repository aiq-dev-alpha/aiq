import { Component, OnInit } from '@angular/core';
import { AlertController, LoadingController, ToastController } from '@ionic/angular';
import { ApiService } from '../../services/api.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.page.html',
  styleUrls: ['./home.page.scss'],
})
export class HomePage implements OnInit {
  items: any[] = [];
  isLoading = false;

  constructor(
    private alertController: AlertController,
    private loadingController: LoadingController,
    private toastController: ToastController,
    private apiService: ApiService
  ) {}

  ngOnInit() {
    this.loadData();
  }

  async loadData() {
    const loading = await this.loadingController.create({
      message: 'Loading...',
      spinner: 'circles'
    });
    await loading.present();

    try {
      // Simulated API call
      this.items = [
        { id: 1, title: 'Item 1', description: 'Description for item 1' },
        { id: 2, title: 'Item 2', description: 'Description for item 2' },
        { id: 3, title: 'Item 3', description: 'Description for item 3' }
      ];
    } catch (error) {
      this.showToast('Error loading data', 'danger');
    } finally {
      await loading.dismiss();
    }
  }

  async showAlert(item: any) {
    const alert = await this.alertController.create({
      header: item.title,
      message: item.description,
      buttons: ['OK']
    });

    await alert.present();
  }

  async showToast(message: string, color: string = 'success') {
    const toast = await this.toastController.create({
      message,
      duration: 2000,
      color,
      position: 'bottom'
    });
    await toast.present();
  }

  async doRefresh(event: any) {
    await this.loadData();
    event.target.complete();
  }
}