import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    loadChildren: () => import('./tabs/tabs.routes').then((m) => m.routes),
  },
  {
    path: 'events/event-page/:id',
    loadComponent: () => import('./event-page/event-page.page').then( m => m.EventPagePage)
  },
];
