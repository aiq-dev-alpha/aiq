import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./features/home/home.component').then(c => c.HomeComponent),
    title: 'Home - Angular TypeScript Starter'
  },
  {
    path: 'about',
    loadComponent: () => import('./features/about/about.component').then(c => c.AboutComponent),
    title: 'About - Angular TypeScript Starter'
  },
  {
    path: 'contact',
    loadComponent: () => import('./features/contact/contact.component').then(c => c.ContactComponent),
    title: 'Contact - Angular TypeScript Starter'
  },
  {
    path: 'users',
    loadChildren: () => import('./features/users/users.routes').then(r => r.routes),
    title: 'Users - Angular TypeScript Starter'
  },
  {
    path: '**',
    loadComponent: () => import('./features/not-found/not-found.component').then(c => c.NotFoundComponent),
    title: 'Page Not Found - Angular TypeScript Starter'
  }
];