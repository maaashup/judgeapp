import { Component } from '@angular/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonButton } from '@ionic/angular/standalone';
import { Event } from '../../apptyping';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-events',
  templateUrl: 'events.page.html',
  styleUrls: ['events.page.scss'],
  imports: [IonHeader, IonToolbar, IonTitle, IonContent, RouterLink],
})


export class EventsPage {
  constructor() {}

  public events: Event[] = [
    {
      name: 'PancakeMash Cup 2024',
      date: '2024-07-15',
      format: 'Standard',
      game: 'Cardfight!! Vanguard',
      country: 'USA',
      company: 'Bushiroad'
    },
    {
      name: 'PancakeMash Open 2024',
      date: '2024-08-20',
      format: 'Premium',
      game: 'Cardfight!! Vanguard',
      country: 'USA',
      company: 'Bushiroad'
    },
    {
      name: 'PancakeMash Invitational 2024',
      date: '2024-09-10',
      format: 'Standard',
      game: 'Cardfight!! Vanguard',
      country: 'USA',
      company: 'Bushiroad'
    }
    
  ];

}
