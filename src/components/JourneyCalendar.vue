<script>
import {supabase} from "@/lib/supabaseClient";
import {useRoute} from "vue-router";
import {reactive, ref, toRaw} from "vue";
import FullCalendar from '@fullcalendar/vue3'
import interactionPlugin, {Draggable} from "@fullcalendar/interaction";
import dayGridPlugin from '@fullcalendar/daygrid';
import TimeGridPlugin from '@fullcalendar/timegrid';
import AddActivityIllustration from "@/components/illustrations/AddActivityIllustration.vue";
import momentTimezonePlugin from '@fullcalendar/moment-timezone';
import IconDelete from "@/components/icons/IconDelete.vue";
import IconSave from "@/components/icons/IconSave.vue";
import IconRemoveFromCalender from "@/components/icons/IconRemoveFromCalender.vue";
import Toast from "primevue/toast";
import {useToast} from "primevue/usetoast";
import moment from "moment";

export default {
  beforeMount() {
    this.initializeJourneyID();
  },
  components: {
    Toast,
    IconRemoveFromCalender,
    IconSave,
    IconDelete,
    AddActivityIllustration,
    FullCalendar
  },
  data() {
    return {
      form: reactive({
        name: '',
        place: '',
        from: '',
        to: '',
        beschreibung: '',
        adresse: '',
        kosten: '',
        dauer: null,
        oefnungszeiten: '',
        link: '',
        kontakt: '',
        additionalLink: '',
        pk_activity_uuid: '',
        added_to_calendar: '',
        cal_from: '',
        cal_to: '',
        cal_date_start: '',
        cal_date_end: '',
      }),
      currentUserRole: ref(),
      toast: useToast(),
      eventCount: ref(0),
      noEvents: ref(true),
      activities: ref(),
      showDataBool: false,
      nothing_To_Render: null,
      index: 0,
      test: {},
      ausgewaehltesEvent: ref(""),
      startingDate: ref(""),
      INITIAL_EVENTS: [],
      calendarPlugins: [interactionPlugin, momentTimezonePlugin],
      calendarOptions: {
        plugins: [dayGridPlugin, interactionPlugin, TimeGridPlugin, momentTimezonePlugin],
        headerToolbar: {
          start: 'title prev,next today',
          center: '',
          end: 'timeGridWeek timeGridDay',
        },
        buttonText: {
          timeGridWeek: 'Woche',
          timeGridDay: 'Tag',
          today: 'Heute'
        },
        initialView: 'timeGridWeek',
        initialDate: '',
        initialEvents: [],
        locale: "de",
        height: "auto",
        eventReceive: this.initializeDrop,
        eventDrop: this.initializeDrop,
        eventResize: this.initializeDrop,
        eventClick: this.showData,
        slotDuration: "01:00:00",
        allDaySlot: false,
        timeZone: 'local'
      }
    }
  },
  async mounted() {
    this.setupDraggable();
  },
  methods: {
    showData(info) {
      let isActivityIndex = false;
      for (let i = 0; i < this.activities.length; i++) {
        if (typeof info === 'object') {
          if (this.activities[i].pk_activity_uuid === info.event.extendedProps.defId) {
            this.form.pk_activity_uuid = info.event.extendedProps.defId;
            isActivityIndex = true;
          }
        } else {
          if (this.activities[i].pk_activity_uuid === info) {
            this.form.pk_activity_uuid = info;
            isActivityIndex = true;
          }
        }
        if (isActivityIndex) {
          this.form.name = this.activities[i].name;
          this.form.dauer = (this.activities[i].estimated_duration / 60).toFixed(2);
          this.form.oeffnungszeiten = this.activities[i].opening_hours;

          if (this.activities[i].google_maps_link !== "") {
            if (!(this.activities[i].google_maps_link.substring(0, 4) === "http")) {
              this.activities[i].google_maps_link = "https://" + this.activities[i].google_maps_link;
            }
          }
          this.form.link = this.activities[i].google_maps_link;

          if (this.activities[i].link != null) {
            if (!(this.activities[i].link.substring(0, 4) === "http")) {
              this.activities[i].link = "https://" + this.activities[i].link;
            }
          }
          this.form.additionalLink = this.activities[i].link;
          this.form.kontakt = this.activities[i].contact;
          this.form.adresse = this.activities[i].address;
          this.form.kosten = this.activities[i].cost;
          this.form.beschreibung = this.activities[i].description;
          this.ausgewaehltesEvent = this.activities[i].pk_activity_uuid;
          this.added_to_calendar = this.activities[i].added_to_calendar;
          this.form.oefnungszeiten = this.activities[i].opening_hours;
          this.form.cal_from = this.activities[i].cal_from;
          this.form.cal_date_start = this.activities[i].cal_date_start;
          this.form.cal_to = this.activities[i].cal_to;
          this.form.cal_date_end = this.activities[i].cal_date_end;
          isActivityIndex = false;
        }
      }
      this.showDataBool = true;
    },
    setupDraggable() {
      new Draggable(document.getElementById("planned-tasks"), {
        itemSelector: ".fc-event",
      })
    },
    async initializeData() {
      this.calendarOptions.initialEvents = toRaw(this.INITIAL_EVENTS);
      this.calendarOptions.initialDate = this.startingDate;
    },
    async deleteFromCalendar(id) {
      const {error} = await supabase
          .from('activity')
          .update({
            added_to_calendar: false, cal_date_start: null, cal_date_end: null
            , cal_from: null, cal_to: null
          })
          .eq('pk_activity_uuid', id);
      if (error) {
        console.log(error);
      }
      this.showDataBool = false;
      location.reload();
    },
    async initializeDrop(event) {
      const startTime = event.event._instance.range.start.toISOString().split("T");
      startTime[1] = startTime[1].substring(0, 8);
      const endTime = event.event._instance.range.end.toISOString().split("T");
      endTime[1] = endTime[1].substring(0, 8);

      const {error} = await supabase
          .from('activity')
          .update({
            added_to_calendar: true, cal_date_start: startTime[0], cal_date_end: endTime[0]
            , cal_from: startTime[1], cal_to: endTime[1]
          })
          .eq('pk_activity_uuid', event.event._def.extendedProps.defId);
      if (error) {
        console.log(error);
      }
      event.draggedEl.parentNode.removeChild(event.draggedEl);
      this.eventCount--;
      if (this.eventCount <= 0) {
        this.noEvents = true;
      }
    },
    async initializeJourneyID() {
      const route = useRoute();
      this.journeyID = ref(route.params.uuid);
      await this.loadData();
    },
    async loadData() {
      await this.getUserRole();
      const {data, error} = await supabase
          .from('activity')
          .select(`
          pk_activity_uuid,
          estimated_duration,
          fk_journey_uuid,
          contact,
          address,
          cost,
          link,
          description,
          opening_hours,
          google_maps_link,
          name,
          added_to_calendar,
          cal_date_start,
          cal_date_end,
          cal_from,
          cal_to
        `)
          .eq('fk_journey_uuid', this.journeyID.value);

      if (error) {
        console.error(error);
        return;
      }

      const {data: data2, error: error2} = await supabase
          .from('journey')
          .select(`
          from,
          to
        `)
          .eq('pk_journey_uuid', this.journeyID.value);
      const currentDate = new Date();
      const journeyStartDate = new Date(data2[0].from);
      const journeyEndDate = new Date(data2[0].to);
      if (currentDate > journeyStartDate && currentDate < journeyEndDate) {
        this.startingDate = currentDate;
      } else {
        this.startingDate = data2[0].from;
      }

      if (error2) {
        console.error(error2);
        return;
      }

      if (data) {
        data.forEach((row) => {
          if (row.added_to_calendar) {
            if (this.currentUserRole === 1) {
              this.INITIAL_EVENTS[this.index] = {
                id: this.index,
                title: row.name,
                start: row.cal_date_start + 'T' + row.cal_from,
                end: row.cal_date_end + 'T' + row.cal_to,
                editable: true,
                timeZone: "local",
                defId: row.pk_activity_uuid
              };
            } else if (this.currentUserRole === 0) {
              this.INITIAL_EVENTS[this.index] = {
                id: this.index,
                title: row.name,
                start: row.cal_date_start + 'T' + row.cal_from,
                end: row.cal_date_end + 'T' + row.cal_to,
                editable: false,
                timeZone: "local",
                defId: row.pk_activity_uuid
              };
            }

            this.index++;
          } else {
            this.noEvents = false;
            this.eventCount++;
          }
        });
        if (this.INITIAL_EVENTS.length <= 0) {
          this.nothing_To_Render = true;
        }

        this.activities = data;
      }
      await this.initializeData();
    },
    async getUserRole() {
      const {data: {user}} = await supabase.auth.getUser();
      const {data, error} = await supabase
          .from('user_is_in')
          .select(`
          function
        `)
          .eq('pk_user_uuid', user.id)
          .eq('pk_journey_uuid', this.journeyID.value);

      if (error) {
        console.error(error);
      }
      this.currentUserRole = data[0].function;
      if (this.currentUserRole === 0) {
        document.getElementById("showDraggabeles").style.display = "none";
      }
    },
    async saveChanges() {
      if (this.form.dauer == null || this.form.dauer <= 0) {
        this.toast.add({
          severity: 'warn',
          summary: 'Felder ausfüllen',
          detail: 'Bitte fülle alle Felder richtig aus',
          life: 4000
        });
      } else {
        let durationIncrease = new Date(this.form.cal_date_start + "T" + this.form.cal_from);
        let newDate = moment(durationIncrease).add(this.form.dauer, 'h');
        let cal_date_end = newDate.get('year') + "-" + (newDate.get('month') + 1) + "-" + newDate.get('date');
        let cal_to = newDate.get('hour').toString().padStart(2, "0") + ":" + (newDate.get('minute')).toString().padStart(2, "0") + ":" + newDate.get('second').toString().padStart(2, "0");
        if (this.added_to_calendar) {
          const {error} = await supabase
              .from('activity')
              .update([
                {
                  name: this.form.name,
                  estimated_duration: this.form.dauer * 60,
                  opening_hours: this.form.oefnungszeiten,
                  google_maps_link: this.form.link,
                  contact: this.form.kontakt,
                  address: this.form.adresse,
                  cal_date_end: cal_date_end,
                  link: this.form.additionalLink,
                  cal_to: cal_to,
                  cost: this.form.kosten,
                  fk_journey_uuid: this.journeyID.value,
                  description: this.form.beschreibung
                },
              ])
              .eq('pk_activity_uuid', this.form.pk_activity_uuid)
          if (error) {
            this.toast.add({
              severity: 'error',
              summary: 'Fehler beim Aktivität erstellen',
              detail: 'Es ist ein Fehler aufgetreteten. Probiere es noch einmal oder kontaktiere uns unter contact@journeyplanner.io',
              life: 3000
            });
          } else {
            this.toast.add({
              severity: 'success',
              summary: 'Aktivität verändert',
              detail: 'Aktivität wurde erfolgreich verändert...',
              life: 1000
            });
          }
        } else {
          const {error} = await supabase
              .from('activity')
              .update([
                {
                  name: this.form.name,
                  estimated_duration: this.form.dauer * 60,
                  opening_hours: this.form.oefnungszeiten,
                  google_maps_link: this.form.link,
                  contact: this.form.kontakt,
                  link: this.form.additionalLink,
                  address: this.form.adresse,
                  cost: this.form.kosten,
                  fk_journey_uuid: this.journeyID.value,
                  description: this.form.beschreibung
                },
              ])
              .eq('pk_activity_uuid', this.form.pk_activity_uuid)
          if (error) {
            this.toast.add({
              severity: 'error',
              summary: 'Fehler beim Aktivität erstellen',
              detail: 'Es ist ein Fehler aufgetreteten. Probiere es noch einmal oder kontaktiere uns unter contact@journeyplanner.io',
              life: 3000
            });
          } else {
            this.toast.add({
              severity: 'success',
              summary: 'Aktivität verändert',
              detail: 'Aktivität wurde erfolgreich verändert...',
              life: 1000
            });
          }
        }
        location.reload();
      }
    },
    async deleteActivity() {
      const {error} = await supabase
          .from('activity')
          .delete()
          .eq('pk_activity_uuid', this.form.pk_activity_uuid);

      if (error) {
        this.toast.add({
          severity: 'error',
          summary: 'Fehler beim löschen',
          detail: 'Es ist ein Fehler aufgetreteten. Probiere es noch einmal oder kontaktiere uns unter contact@journeyplanner.io',
          life: 3000
        });
      } else {
        this.toast.add({
          severity: 'success',
          summary: 'Aktivität gelöscht',
          detail: 'Aktivität wurde erfolgreich gelöscht...',
          life: 1000
        });
      }
      location.reload();
    },
  },
  computed: {
    formatTime(decimalTime) {
      return (decimalTime) => {
        const hour = Math.floor(decimalTime);
        const minute = Math.round((decimalTime - hour) * 60);

        // Format the time as HH:mm
        return `${hour}:${minute < 10 ? '0' : ''}${minute}`;
      };
    },
    handleClose() {
      return () => {
        this.showDataBool = false;
      };
    },
  },
}
;


</script>

<template>
  <Toast/>

  <div>
    <section class="content mt-4">
      <div class="container-fluid">
        <Dialog :visible="showDataBool" :close-on-escape="true" :header="' '"
                :style="{ width: '60rem' }" @update:visible="handleClose()">
          <div class="relative flex flex-col justify-center items-center">
            <div class="flex flex-col justify-between">
              <h1 class="font-nunito text-center text-xl font-bold text-text-black mr-2 mb-3">{{ form.name }}</h1>
              <div class="flex items-center gap-5 justify-center class w-[100%] mb-3">
                <button v-if="currentUserRole === 1"
                        class="bg-call-to-action w-56 rounded-3xl font-nunito text-base items-center justify-center text-text-black font-bold py-1 px-2 shadow-md flex flex-row hover:opacity-80"
                        type="button"
                        @click="saveChanges">
                  <IconSave class="text-text-black"/>
                  <span>Speichern</span>
                </button>
                <button v-if="currentUserRole === 1 && added_to_calendar"
                        class="bg-delete w-56 rounded-3xl font-nunito text-base items-center justify-center text-text-black font-bold py-1 px-2 shadow-md flex flex-row hover:opacity-80"
                        severity="danger"
                        type="button"
                        @click="deleteFromCalendar(ausgewaehltesEvent)">
                  <IconRemoveFromCalender class="text-text-black"/>
                  <span>Aus Plan entfernen</span>
                </button>
                <button v-if="currentUserRole === 1"
                        class="bg-delete w-56 rounded-3xl font-nunito text-base items-center justify-center text-text-black font-bold py-1 px-2 shadow-md flex flex-row hover:opacity-80"
                        severity="danger"
                        type="button"
                        @click="deleteActivity">
                  <IconDelete class="text-text-black"/>
                  <span>Löschen</span>
                </button>
              </div>
            </div>
            <div class="bg-primary rounded-[58px] pl-6 pt-3 pr-10 pb-6 mt-2 w-[90%]">
              <form class="flex flex-col font-nunito font-semibold text-xl text-text-black">
                <div class=" gap-5 grid grid-cols-2">
                  <div>
                    <div class="flex flex-col">
                      <label for="journey-dauer" class="pt-2">Dauer (h)</label>
                      <input :disabled="currentUserRole !== 1"
                             v-model="form.dauer"
                             type="number"
                             class="rounded border-none pl-1.5 placeholder-text-black"
                             :class="currentUserRole === 1 ? '' : 'bg-disabled-input'"
                      >
                    </div>
                    <div class="flex flex-col">
                      <label for="journey-to" class="pt-2">Google-Maps</label>
                      <a :href=form.link target="_blank" v-if='form.link !== ""'>
                        <input :disabled="currentUserRole !== 1"
                               v-model="form.link"
                               class="w-[100%] rounded border-none cursor-pointer underline pl-1.5 placeholder-text-black"
                               :class="currentUserRole === 1 ? '' : 'bg-disabled-input'"
                        >
                      </a>
                      <input v-else :disabled="currentUserRole !== 1"
                             v-model="form.link"
                             class="w-[100%] rounded border-none pl-1.5 placeholder-text-black"
                             :class="currentUserRole === 1 ? '' : 'bg-disabled-input'"
                      >
                    </div>
                    <div class="flex flex-col">
                      <label for="journey-to" class="pt-2">Kontakt</label>
                      <input :disabled="currentUserRole !== 1"
                             v-model="form.kontakt"
                             class="rounded border-none pl-1.5 placeholder-text-black"
                             :class="currentUserRole === 1 ? '' : 'bg-disabled-input'">
                    </div>
                  </div>
                  <div class="">
                    <div class="flex flex-col">
                      <label for="journey-from" class="pt-2">Öffnungszeiten</label>
                      <textarea :disabled="currentUserRole !== 1" class="m-0 p-0 resize-none rounded
                      border-none pl-1.5 pb-[42%] pt-0 whitespace-normal"
                                v-model="form.oefnungszeiten"
                                :class="currentUserRole === 1 ? '' : 'bg-disabled-input'">
                        {{form.oeffnungszeiten}}
                      </textarea>
                    </div>
                  </div>
                </div>
                <div class="gap-5 grid grid-cols-2">
                  <div class="flex flex-col">
                    <label for="journey-from" class="pt-2">Link</label>
                    <a :href=form.additionalLink target="_blank" v-if='form.additionalLink != null'>
                      <input :disabled="currentUserRole !== 1"
                             v-model="form.additionalLink"
                             class="w-[100%] rounded border-none cursor-pointer underline pl-1.5 placeholder-text-black"
                             :class="currentUserRole === 1 ? '' : 'bg-disabled-input'"
                      >
                    </a>
                    <input v-else :disabled="currentUserRole !== 1"
                           v-model="form.additionalLink"
                           class="w-[100%] rounded border-none pl-1.5 placeholder-text-black"
                           :class="currentUserRole === 1 ? '' : 'bg-disabled-input'"
                    >
                  </div>
                  <div class="flex flex-col">
                    <label for="journey-to" class="pt-2">Kosten</label>
                    <input :disabled="currentUserRole !== 1"
                           v-model="form.kosten"
                           class="rounded border-none pl-1.5 placeholder-text-black"
                           :class="currentUserRole === 1 ? '' : 'bg-disabled-input'">
                  </div>
                </div>
                <div class="flex flex-col">
                  <label for="journey-from" class="pt-2">Adresse</label>
                  <input :disabled="currentUserRole !== 1"
                         v-model="form.adresse"
                         class="rounded border-none pl-1.5 placeholder-text-black"
                         :class="currentUserRole === 1 ? '' : 'bg-disabled-input'">
                </div>
                <label class="pt-2" for="journey-link">Beschreibung</label>
                <div class="flex flex-row justify-between gap-2">
                 <textarea :disabled="currentUserRole !== 1" id="journey-from" type="text"
                           v-model="form.beschreibung"
                           class="w-[100%] placeholder-text-black resize-none rounded pl-1.5
                           border-none focus:outline-none focus:ring-2 focus:ring-call-to-action whitespace-normal"
                           :class="currentUserRole === 1 ? '' : 'bg-disabled-input'">
                   {{form.beschreibung}}
                </textarea>
                </div>
              </form>
            </div>
          </div>
        </Dialog>
        <div class="card">
          <div class="w-[100%] flex flex-col items-center justify-center">
            <div id="showDraggabeles" class="w-[85%] rounded-2xl bg-primary p-6">
              <div class="grid grid-cols-6 pb-3 justify-center items-center">
                <h2 class="col-span-2 font-nunito text-2xl text-text-black font-semibold">Aktivitäten</h2>
                <RouterLink :to='$route.fullPath + "/aktivitaet/neu"' class="col-start-6 bg-call-to-action
                rounded-3xl flex text-text-black font-nunito text-center items-center justify-center text-xl font-bold shadow-md hover:opacity-80"
                            v-tooltip.bottom="{
               value: 'Aktivität erstellen',
                 style:{
                   width: '30vw'
                 }}">
                  <AddActivityIllustration class="m-2 w-[20%]"/>
                  Erstellen
                </RouterLink>
              </div>
              <div id="planned-tasks"
                   class="flex flex-wrap bg-background p-1 planned-tasks rounded-md">
                <div v-for="activity in activities" class="flex">
                  <div v-if=!activity.added_to_calendar :id=activity.pk_activity_uuid
                       :data-event="JSON.stringify({title:activity.name,duration:formatTime(activity.estimated_duration/60)
                       ,editable:true,defId:activity.pk_activity_uuid,timeZone: 'local'})"
                       class="fc-event bg-secondary flex flex-col px-3 py-2 rounded-2xl m-2 cursor-grab"
                       @click="showData(activity.pk_activity_uuid)">
                    <div class="font-semibold">{{ activity.name }}</div>
                    <div>{{ formatTime(activity.estimated_duration / 60) }}h</div>
                  </div>
                </div>
                <div v-if="noEvents" class="text-center justify-center w-[100%]">
                  <p class="font-nunito-sans text-base text-text-black py-3"> Keine Aktivitäten
                    vorhanden.</p>
                </div>
              </div>
              <p class="font-nunito text-base text-text-black font-semibold text-center pt-1"> Erstelle Aktivitäten
                und ziehe sie in deinen Plan, um deine Reise zu gestalten!</p>
            </div>
            <hr>
            <div class="w-[85%] rounded-2xl bg-primary p-6 mt-8">
              <div class="flex flex-row justify-between">
                <h2 class="font-nunito font-semibold text-2xl">Plan</h2>
              </div>
              <FullCalendar ref="fullCalendar" v-if="INITIAL_EVENTS.length > 0 || nothing_To_Render"
                            :options="calendarOptions"
                            class="px-4 bg-background rounded-md py-3"
              />
              <p class="font-nunito text-base text-text-black font-semibold text-center pt-1">Wird automatisch
                gespeichert! Aktivität anklicken, um alle Informationen zu sehen.</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.planned-tasks > div {
  margin-bottom: 0.5em;
}

 input::-webkit-outer-spin-button,
 input::-webkit-inner-spin-button {
   -webkit-appearance: none;
   margin: 0;
 }

input[type=number] {
  -moz-appearance: textfield;
}
</style>
