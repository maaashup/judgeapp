import { Component } from '@angular/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonLabel, IonItem } from '@ionic/angular/standalone';
import { Event } from '../../apptyping';

@Component({
  selector: 'app-events',
  templateUrl: 'events.page.html',
  styleUrls: ['events.page.scss'],
  imports: [IonHeader, IonToolbar, IonTitle, IonContent, IonItem, IonLabel, IonList  ],
})


export class EventsPage {
  constructor() {}

  public events: Event[] = [
    
  ];

}
