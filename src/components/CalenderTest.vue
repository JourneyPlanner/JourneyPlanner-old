<script>
//@ts-ignore
import {supabase} from "@/lib/supabaseClient";
import {useRoute} from "vue-router";
import {ref, toRaw} from "vue";
import FullCalendar from '@fullcalendar/vue3'
import interactionPlugin, {Draggable} from "@fullcalendar/interaction";
import dayGridPlugin from '@fullcalendar/daygrid';
import TimeGridPlugin from '@fullcalendar/timegrid';
import AddActivityIllustration from "@/components/illustrations/AddActivityIllustration.vue";
import momentTimezonePlugin from '@fullcalendar/moment-timezone';


export default {
  beforeMount() {
    this.initializeJourneyID();
  },
  components: {
    AddActivityIllustration,
    FullCalendar
  },
  data() {
    return {
      currentUserRole: ref(),
      activities: ref(),
      showData: ref(false),
      nothing_To_Render: null,
      index: 0,
      test: {},
      name: ref(""),
      dauer: ref(""),
      oeffnungszeiten: ref(""),
      link: ref(""),
      kontakt: ref(""),
      adresse: ref(""),
      kosten: ref(""),
      beschreibung: ref(""),
      ausgewaeltesEvent: ref(""),
      INITIAL_EVENTS: [],
      calendarPlugins: [interactionPlugin, momentTimezonePlugin],
      calendarOptions: {
        plugins: [dayGridPlugin, interactionPlugin, TimeGridPlugin, momentTimezonePlugin],
        initialView: 'timeGridWeek',
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
    };
  },
  async mounted() {
    await this.initializeData();
    this.setupDraggable();
  },
  methods: {
    useRoute,
    showData(info) {
      for (let i = 0; i < this.activities.length; i++) {
        if (this.activities[i].pk_activity_uuid === info.event.extendedProps.defId) {
          this.name = this.activities[i].name;
          this.dauer = this.activities[i].estimated_duration / 60 + "h";
          this.oeffnungszeiten = this.activities[i].opening_hours;
          this.link = this.activities[i].google_maps_link;
          this.kontakt = this.activities[i].contact;
          this.adresse = this.activities[i].address;
          this.kosten = this.activities[i].cost;
          this.beschreibung = this.activities[i].description;
          this.ausgewaeltesEvent = this.activities[i].pk_activity_uuid
        }
      }
      this.showData = true;
    },
    setupDraggable() {
      new Draggable(document.getElementById("planned-tasks"), {
        itemSelector: ".fc-event"
      })
    },
    async initializeData() {
      this.calendarOptions.initialEvents = toRaw(this.INITIAL_EVENTS);
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
      this.showData = false;
      location.reload();
    }, async initializeDrop(event) {
      const startTime = event.event._instance.range.start.toISOString().split("T");
      startTime[1] = startTime[1].substring(0,8);
      const endTime = event.event._instance.range.end.toISOString().split("T");
      endTime[1] = endTime[1].substring(0,8);

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
          }
        });
        if (this.INITIAL_EVENTS.length <= 0) {
          this.nothing_To_Render = true;
        }

        this.activities = data;
      }
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
    }
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
        this.showData = false;
      };
    }
  },
}
;


</script>

<template>
  <div>
    <section class="content mt-4">
      <div class="container-fluid">
        <Dialog v-model:visible="showData" :header="name"
                :style="{ width: '60rem' }" @update:visible="handleClose()">
          <button v-if="currentUserRole === 1"
                  class="bg-delete rounded-3xl font-nunito text-xl font-bold p-1 px-2 shadow-md"
                  severity="danger"
                  type="button"
                  @click="deleteFromCalendar(ausgewaeltesEvent)"> Entfernen
          </button>
          <div class="relative flex flex-col justify-center items-center mt-5">
            <h1 class="font-nunito text-2xl font-bold"></h1>
            <div class="bg-primary rounded-[58px] pl-6 pt-3 pr-10 pb-6 w-[60%]">
              <form class="flex flex-col font-nunito font-semibold text-xl" @submit.prevent="create">
                <div class="flex flex-row gap-5 grid grid-cols-2">
                  <div>
                    <div class="flex flex-col">
                      <label for="journey-dauer" class="pt-2">Dauer</label>
                      <input disabled :placeholder=dauer
                             class="rounded border-none bg-background pl-1.5 placeholder-text-black">
                    </div>
                    <div class="flex flex-col">
                      <a :href=link>
                        <label for="journey-to" class="pt-2">Google-Maps</label>
                        <input disabled :value=link
                               class="w-[100%] rounded border-none bg-background pl-1.5 placeholder-text-black">
                      </a>
                    </div>
                    <div class="flex flex-col">
                      <label for="journey-to" class="pt-2">Kontakt</label>
                      <input disabled :placeholder=kontakt
                             class="rounded border-none bg-background pl-1.5 placeholder-text-black">
                    </div>
                  </div>
                  <div class="">
                    <div class="flex flex-col">
                      <label for="journey-from" class="pt-2">Öffnungszeiten</label>
                      <textarea disabled class="m-0 p-0 resize-none rounded
                      border-none bg-background pl-1.5 pb-[42%] pt-0 whitespace-normal">
                        {{oeffnungszeiten}}
                      </textarea>
                    </div>
                  </div>
                </div>
                <div class="flex flex-row gap-5 grid grid-cols-2">
                  <div class="flex flex-col">
                    <label for="journey-from" class="pt-2">Adresse</label>
                    <input disabled :placeholder=adresse
                           class="rounded border-none bg-background pl-1.5 placeholder-text-black">
                  </div>
                  <div class="flex flex-col">
                    <label for="journey-to" class="pt-2">Kosten</label>
                    <input disabled :placeholder=kosten
                           class="rounded border-none bg-background pl-1.5 placeholder-text-black">
                  </div>
                </div>
                <label for="journey-link" class="pt-2">Beschreibung</label>
                <div class="flex flex-row justify-between gap-2">
                 <textarea disabled id="journey-from" type="text"
                           class="bg-background w-[100%] placeholder-text-black resize-none rounded pl-1.5
                           border-none focus:outline-none focus:ring-2 focus:ring-call-to-action whitespace-normal">
                   {{beschreibung}}
                </textarea>
                </div>
              </form>
            </div>
          </div>
        </Dialog>
        <div class="card">
          <div class="w-[100%] flex flex-col items-center justify-center">
            <div id="showDraggabeles" class="w-[85%] rounded-2xl bg-primary p-6">
              <div class="grid grid-cols-6 py-3 justify-center items-center">
                <p class="col-span-2 font-nunito text-2xl text-text-black font-semibold"> Deine Aktivitäten</p>
                <RouterLink :to='$route.fullPath + "/aktivitaet/neu"' class="col-start-6 bg-call-to-action
                rounded-3xl flex text-text-black font-nunito text-center items-center justify-center text-xl font-bold">
                  <AddActivityIllustration class="m-2 w-[20%]"></AddActivityIllustration> Erstellen
                </RouterLink>
              </div>
              <div id="planned-tasks" class="flex bg-background p-1 planned-tasks min-w-32">
                <div v-for="activity in activities" class="flex">
                  <div :id=activity.pk_activity_uuid v-if=!activity.added_to_calendar
                       class="fc-event bg-secondary flex flex-col px-3 py-2 rounded-2xl m-3"
                       :data-event="JSON.stringify({title:activity.name,duration:formatTime(activity.estimated_duration/60)
                       ,editable:true,defId:activity.pk_activity_uuid,timeZone: 'local',})">
                    <div>{{ activity.name }}</div>
                    <div>{{ formatTime(activity.estimated_duration / 60) }}h</div>
                  </div>
                </div>
              </div>
              <p class="font-nunito text-base text-text-black font-semibold text-center"> Erstelle Aktivitäten
                und ziehe sie in deinen Kalender, um deinen eigenen Plan zu erstellen!</p>
            </div>
            <hr>
            <FullCalendar class="px-4"
                          v-if="INITIAL_EVENTS.length > 0 || nothing_To_Render"
                          :options="calendarOptions"
            />
          </div>
        </div>
      </div>
    </section>
  </div>
</template>


<style>
.planned-tasks > div {
  margin-bottom: 0.5em;
}
</style>