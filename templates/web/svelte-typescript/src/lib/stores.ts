import { writable, derived } from 'svelte/store';

// User store
export interface User {
  id: string;
  name: string;
  email: string;
}

export const user = writable<User | null>(null);

// Theme store
export type Theme = 'light' | 'dark';
export const theme = writable<Theme>('light');

// Cart store for e-commerce example
export interface CartItem {
  id: string;
  name: string;
  price: number;
  quantity: number;
}

export const cart = writable<CartItem[]>([]);

// Derived store for cart totals
export const cartTotal = derived(cart, ($cart) =>
  $cart.reduce((total, item) => total + item.price * item.quantity, 0)
);

export const cartCount = derived(cart, ($cart) =>
  $cart.reduce((count, item) => count + item.quantity, 0)
);

// Notification store
export interface Notification {
  id: string;
  type: 'info' | 'success' | 'warning' | 'error';
  message: string;
  timeout?: number;
}

function createNotificationStore() {
  const { subscribe, update } = writable<Notification[]>([]);

  return {
    subscribe,
    add: (notification: Omit<Notification, 'id'>) => {
      const id = Math.random().toString(36).substring(7);
      const newNotification = { ...notification, id };

      update((notifications) => [...notifications, newNotification]);

      if (notification.timeout) {
        setTimeout(() => {
          update((notifications) =>
            notifications.filter((n) => n.id !== id)
          );
        }, notification.timeout);
      }
    },
    remove: (id: string) => {
      update((notifications) =>
        notifications.filter((n) => n.id !== id)
      );
    },
    clear: () => {
      update(() => []);
    }
  };
}

export const notifications = createNotificationStore();