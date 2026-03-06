import { Component } from '@angular/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonButton, IonInput, IonSelect, IonSelectOption, IonLabel, IonDatetime, IonModal, IonDatetimeButton, IonItem, IonText  } from '@ionic/angular/standalone';
import { Event } from '../../apptyping';
import { RouterLink } from '@angular/router';
import {FormGroup, FormControl, ReactiveFormsModule, Validators, FormBuilder} from '@angular/forms';

@Component({
  selector: 'app-events',
  templateUrl: 'events.page.html',
  styleUrls: ['events.page.scss'],
  imports: [IonHeader, IonToolbar, IonTitle, IonContent, RouterLink, IonInput, IonSelect, IonSelect, IonSelectOption, ReactiveFormsModule, IonLabel, IonDatetime,IonModal, IonDatetimeButton,]
})


export class EventsPage {
  public eventForm: FormGroup;

  isFormOpen: boolean = false;

  openEventForm() {
    this.isFormOpen = true;
  }
  constructor(public fb: FormBuilder) {
    this.eventForm = this.fb.group({
      name: ['', Validators.compose([Validators.required])],
      format: ['', Validators.compose([Validators.required])],
      game: ['', Validators.compose([Validators.required])],
      country: ['', Validators.compose([Validators.required])],
      datetime: ['', Validators.compose([Validators.required])]
    });
  }

  createEvent() {
    let uuid = crypto.randomUUID();
    console.log(uuid);
    this.events.push({
      id: uuid,
      name: this.eventForm.value['name'],
      format: this.eventForm.value['format'],
      game: this.eventForm.value['game'],
      country: this.eventForm.value['country'],
      company: 'Bushiroad',
      date: new Date().toDateString()
    });
    console.log(this.eventForm.value);

    this.isFormOpen = false;

  }

  public events: Event[] = [
    {
      id: '1234-abcd-3456-efgh',
      name: 'PancakeMash Cup 2024',
      date:  new Date().toDateString(),
      format: 'Standard',
      game: 'Cardfight!! Vanguard',
      country: 'USA',
      company: 'Bushiroad'
    },
    {
      id: '23jn-mn31-98mj-lk30',
      name: 'PancakeMash Open 2024',
      date: new Date().toDateString(),
      format: 'Premium',
      game: 'Cardfight!! Vanguard',
      country: 'USA',
      company: 'Bushiroad'
    },
    {
      id: 'gh87-kn89-lm09-tyuv',
      name: 'PancakeMash Invitational 2024',
      date: new Date().toDateString(),
      format: 'Standard',
      game: 'Cardfight!! Vanguard',
      country: 'USA',
      company: 'Bushiroad'
    }
    
  ];

  public formats: string[] = ['Standard', 'Premium', 'Legacy', 'Modern', 'Commander'];

  public games: string[] = ['Cardfight!! Vanguard', 'Weiss Schwarz', 'Hololive TCG', 'Shadowverse: Evolve'];

  public countries: string[] = ['USA', 'Japan', 'UK', 'Germany', 'France'];

}
