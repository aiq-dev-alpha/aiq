import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, BehaviorSubject, map, catchError, of } from 'rxjs';
import { environment } from '@environments/environment';

export interface User {
  id: number;
  name: string;
  username: string;
  email: string;
  phone: string;
  website: string;
  company: {
    name: string;
    catchPhrase: string;
    bs: string;
  };
  address: {
    street: string;
    suite: string;
    city: string;
    zipcode: string;
  };
}

@Injectable({
  providedIn: 'root'
})
export class UserService {
  private http = inject(HttpClient);
  private usersSubject = new BehaviorSubject<User[]>([]);
  private loadingSubject = new BehaviorSubject<boolean>(false);
  private errorSubject = new BehaviorSubject<string | null>(null);

  public users$ = this.usersSubject.asObservable();
  public loading$ = this.loadingSubject.asObservable();
  public error$ = this.errorSubject.asObservable();

  getUsers(): Observable<User[]> {
    this.loadingSubject.next(true);
    this.errorSubject.next(null);

    return this.http.get<User[]>('https://jsonplaceholder.typicode.com/users').pipe(
      map((users) => {
        this.usersSubject.next(users);
        this.loadingSubject.next(false);
        return users;
      }),
      catchError((error) => {
        this.errorSubject.next('Failed to load users');
        this.loadingSubject.next(false);
        return of([]);
      })
    );
  }

  getUserById(id: number): Observable<User | null> {
    this.loadingSubject.next(true);
    this.errorSubject.next(null);

    return this.http.get<User>(`https://jsonplaceholder.typicode.com/users/${id}`).pipe(
      map((user) => {
        this.loadingSubject.next(false);
        return user;
      }),
      catchError((error) => {
        this.errorSubject.next('Failed to load user');
        this.loadingSubject.next(false);
        return of(null);
      })
    );
  }

  createUser(user: Partial<User>): Observable<User | null> {
    this.loadingSubject.next(true);
    this.errorSubject.next(null);

    return this.http.post<User>('https://jsonplaceholder.typicode.com/users', user).pipe(
      map((newUser) => {
        const currentUsers = this.usersSubject.value;
        this.usersSubject.next([...currentUsers, newUser]);
        this.loadingSubject.next(false);
        return newUser;
      }),
      catchError((error) => {
        this.errorSubject.next('Failed to create user');
        this.loadingSubject.next(false);
        return of(null);
      })
    );
  }

  updateUser(id: number, user: Partial<User>): Observable<User | null> {
    this.loadingSubject.next(true);
    this.errorSubject.next(null);

    return this.http.put<User>(`https://jsonplaceholder.typicode.com/users/${id}`, user).pipe(
      map((updatedUser) => {
        const currentUsers = this.usersSubject.value;
        const updatedUsers = currentUsers.map(u => u.id === id ? { ...u, ...updatedUser } : u);
        this.usersSubject.next(updatedUsers);
        this.loadingSubject.next(false);
        return updatedUser;
      }),
      catchError((error) => {
        this.errorSubject.next('Failed to update user');
        this.loadingSubject.next(false);
        return of(null);
      })
    );
  }

  deleteUser(id: number): Observable<boolean> {
    this.loadingSubject.next(true);
    this.errorSubject.next(null);

    return this.http.delete(`https://jsonplaceholder.typicode.com/users/${id}`).pipe(
      map(() => {
        const currentUsers = this.usersSubject.value;
        const filteredUsers = currentUsers.filter(u => u.id !== id);
        this.usersSubject.next(filteredUsers);
        this.loadingSubject.next(false);
        return true;
      }),
      catchError((error) => {
        this.errorSubject.next('Failed to delete user');
        this.loadingSubject.next(false);
        return of(false);
      })
    );
  }

  clearError(): void {
    this.errorSubject.next(null);
  }
}