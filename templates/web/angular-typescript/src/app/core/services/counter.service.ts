import { Injectable, signal, computed } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class CounterService {
  private _count = signal(0);

  // Public readonly signals
  count = this._count.asReadonly();
  doubleCount = computed(() => this._count() * 2);
  isEven = computed(() => this._count() % 2 === 0);

  increment(): void {
    this._count.update(value => value + 1);
  }

  decrement(): void {
    this._count.update(value => value - 1);
  }

  incrementBy(amount: number): void {
    this._count.update(value => value + amount);
  }

  reset(): void {
    this._count.set(0);
  }

  setValue(value: number): void {
    this._count.set(value);
  }
}