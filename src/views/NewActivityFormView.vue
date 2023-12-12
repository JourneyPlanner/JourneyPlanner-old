<script setup lang="ts">
import ActivityLeftIllustration from "@/components/illustrations/ActivitySittingPeople.vue";
import ActivityRightIllustration from "@/components/illustrations/ActivitySunflowersIllustration.vue";
import Footer from "@/components/Footer.vue";
import Toast from 'primevue/toast';
import {useToast} from 'primevue/usetoast';
import {computed} from 'vue';
import {reactive} from 'vue';
import {useVuelidate} from '@vuelidate/core';
import {required} from '@vuelidate/validators';
//@ts-ignore
import {supabase} from "@/lib/supabaseClient";
import router from "@/router";
import {useRoute} from "vue-router";

const toast = useToast();
const journeyID = useRoute().params.uuid;

const form = reactive({
  name: '',
  place: '',
  from: '',
  to: '',
  beschreibung: '',
  adresse: '',
  kosten: '',
  dauer: '',
  oefnungszeiten: '',
  link: '',
  kontakt: ''
})

const rules = computed(() => {
      return {
        name: {required,},
        dauer: {required},
      }
    }
);

const v$ = useVuelidate(rules, form)

/**
 * custom sleep method to set timeout
 * @param ms milliseconds to wait
 */
function sleep(ms: number) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

/**
 * handle form submit
 * handle different errors and save data to database
 */
async function create() {
  const result = await v$.value.$validate()
  if (!result) {
    toast.add({
      severity: 'warn',
      summary: 'Felder ausfüllen',
      detail: 'Bitte fülle alle Felder richtig aus',
      life: 4000
    });
    return;
  } else {
    const {error} = await supabase
        .from('activity')
        .insert([
          {
            name: form.name,
            estimated_duration: form.dauer,
            opening_hours: form.oefnungszeiten,
            google_maps_link: form.link,
            contact: form.kontakt,
            address: form.adresse,
            cost: form.kosten,
            fk_journey_uuid: journeyID,
            description: form.beschreibung
          },
        ])
    if (error) {
      toast.add({
        severity: 'error',
        summary: 'Fehler beim Reise erstellen',
        detail: 'Es ist ein Fehler aufgetreteten. Probiere es noch einmal oder kontaktiere uns unter contact@journeyplanner.io',
        life: 3000
      });
    } else {
      toast.add({
        severity: 'success',
        summary: 'Reise erstellt',
        detail: 'Du wirst gleich weitergeleitet...',
        life: 1000
      });
      await sleep(1000);
      await router.push('/dashboard?created=true');
    }
  }
}
</script>

<style scoped>
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
input[type=number]{
  -moz-appearance: textfield;
}
</style>

<template>
  <Toast/>

  <div class="absolute overflow-x-hidden md:top-4 md:left-[-10%] hidden lg:block">
    <ActivityLeftIllustration class="h-[30vw]"/>
  </div>

  <div class="w-[23%] absolute overflow-x-hidden md:top-64 md:right-[0%] hidden lg:block">
    <ActivityRightIllustration class="h-[30vw] overflow-x-hidden"/>
  </div>
  <div class="flex flex-col min-h-screen">
    <div class="relative flex flex-col justify-center items-center mt-5">
      <h1 class="font-nunito text-2xl font-bold">Neue Aktivität erstellen</h1>
      <div class="bg-primary rounded-[58px] pl-6 pt-3 pr-10 pb-6 w-[33%]">
        <form class="flex flex-col font-nunito font-semibold text-xl" @submit.prevent="create">
          <label for="journey-name" class="pb-0.5 pt-2">Name deiner Aktivität*</label>
          <input id="journey-name" placeholder="Aktivitätenname" v-model="form.name" @blur="v$.name.$touch"
                 class="rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action pl-1.5">
          <p v-if="v$.name.$error" class="text-delete text-base font-nunito-sans font-bold">Bitte gib deiner Aktivität
            einen
            Namen</p>
          <div class="flex flex-row gap-5 grid grid-cols-2">
            <div class="">
              <div class="flex flex-col">
                <label for="journey-dauer" class="pt-2">Dauer*</label>
                <input id="journey-dauer" type="number" pattern="[0-9]{3}" v-model="form.dauer" @blur="v$.dauer.$touch"
                       placeholder="Dauer in Minuten"
                       class="rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action ">
                <p v-if="v$.dauer.$error" class="text-delete text-base font-nunito-sans font-bold">Bitte gib eine Dauer
                  an</p>
              </div>
              <div class="flex flex-col">
                <label for="journey-to" class="pt-2">Google-Maps</label>
                <input id="journey-to" type="text" placeholder="Link einfügen" v-model="form.link"
                       class="rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action">
              </div>
              <div class="flex flex-col">
                <label for="journey-to" class="pt-2">Kontakt</label>
                <input id="journey-to" type="text" placeholder="E-Mail/Telefon" v-model="form.kontakt"
                       class="rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action">
              </div>
            </div>
            <div class="">
              <div class="flex flex-col">
                <label for="journey-from" class="pt-2">Öffnungszeiten</label>
                <textarea id="journey-from" type="text" v-model="form.oefnungszeiten"
                          placeholder="Öffnungszeiten"
                          class="resize-none  pb-[52%] rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action ">
                </textarea>
              </div>
            </div>
          </div>
          <div class="flex flex-row gap-5 grid grid-cols-2">
            <div class="flex flex-col">
              <label for="journey-from" class="pt-2">Adresse</label>
              <input id="journey-from" type="text" v-model="form.adresse" placeholder="Adresse"
                     class="rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action ">
            </div>
            <div class="flex flex-col">
              <label for="journey-to" class="pt-2">Kosten</label>
              <input id="journey-to" type="text" inputmode="numeric" placeholder="Kosten" v-model="form.kosten"
                     class="rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action">
            </div>
          </div>
          <label for="journey-link" class="pt-2">Beschreibung</label>
          <div class="flex flex-row justify-between gap-2">
            <textarea id="journey-link" type="text" placeholder="Füge eine kleine Beschreibung oder Notiz hinzu"
                      v-model="form.beschreibung"
                      class="resize-none w-full bg-disabled-input rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action">
            </textarea>
          </div>
          <div class="pt-1">
            <p class="text-base font-medium">*Pflichtfelder</p>
          </div>
          <div class="pt-4 flex flex-row justify-between">
            <RouterLink to="/dashboard" class="bg-cancel rounded-[38px] px-3 py-1 shadow-md hover:opacity-80">
              Abbrechen
            </RouterLink>
            <button type="submit" @submit.prevent="create()"
                    class="bg-call-to-action rounded-[38px] px-6 py-1 shadow-md disabled:opacity-80 hover:opacity-80">
              Erstellen
            </button>
          </div>
        </form>
      </div>
    </div>

    <Footer class="mt-auto"/>
  </div>
</template>
