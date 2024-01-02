<script lang="ts" setup>
import CreateJourneyLeftIllustration from "@/components/illustrations/CreateJourneyLeftIllustration.vue";
import CreateJourneyRightIllustration from "@/components/illustrations/CreateJourneyRightIllustration.vue";

import InviteButton from "@/components/buttons/InviteButton.vue";
import Footer from "@/components/Footer.vue";

import Toast from 'primevue/toast';
import {useToast} from 'primevue/usetoast';

import {computed, reactive} from 'vue';
import {useVuelidate} from '@vuelidate/core';
import {required} from '@vuelidate/validators';
//@ts-ignore
import {supabase} from "@/lib/supabaseClient";
import router from "@/router";
import {v4 as uuidv4} from 'uuid';

const journeyInvite = uuidv4();

const toast = useToast();

const form = reactive({
  name: '',
  place: '',
  from: '',
  to: '',
  link: 'journeyplanner.io/beitreten/' + journeyInvite
})

const rules = computed(() => {
      return {
        name: {required,},
        place: {required},
        from: {required},
        to: {
          required,
          afterFromDate: (value: string) => {
            const fromDate = new Date(form.from);
            const toDate = new Date(value);
            return toDate >= fromDate;
          },
        },
      }
    }
);

const v$ = useVuelidate(rules, form)

/**
 * custom sleep method to set timeout
 * @param ms milliseconds to wait
 */
/*
function sleep(ms: number) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
*/

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
        .from('journey')
        .insert([
          {name: form.name, place: form.place, from: form.from, to: form.to, invite: journeyInvite},
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
      //await sleep(1000);
      await router.push('/dashboard?created=true');
    }
  }
}

function copyLink() {
  navigator.clipboard.writeText(form.link);
  toast.add({
    severity: 'info',
    summary: 'Link kopiert',
    detail: 'Der Link wurde in deine Zwischenablage kopiert',
    life: 3000
  });
}
</script>

<template>
  <Toast/>

  <div class="absolute overflow-x-hidden md:top-4 md:left-0 hidden lg:block">
    <CreateJourneyLeftIllustration/>
  </div>

  <div class="absolute overflow-x-hidden md:top-64 md:right-0 hidden lg:block">
    <CreateJourneyRightIllustration/>
  </div>
  <div class="flex flex-col min-h-screen">
    <div class="relative flex flex-col justify-center items-center mt-10">
      <h1 class="font-nunito text-2xl font-bold">Neue Reise erstellen</h1>
      <div class="bg-primary rounded-[58px] pl-6 pt-3 pr-10 pb-6">
        <form class="flex flex-col font-nunito font-semibold text-xl" @submit.prevent="create">
          <label class="pb-0.5 pt-2" for="journey-name">Name deiner Reise</label>
          <input id="journey-name" v-model="form.name" class="rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action pl-1.5" placeholder="Reisename" tabindex="1"
                 @blur="v$.name.$touch">
          <p v-if="v$.name.$error" class="text-delete text-base font-nunito-sans font-bold">Bitte gib deiner Reise einen
            Namen</p>
          <label class="pb-0.5 pt-2" for="journey-place">Stadt/Land</label>
          <input id="journey-place" v-model="form.place" class="rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action" placeholder="Stadt/Land/Gebiet"
                 tabindex="2"
                 @blur="v$.place.$touch">
          <p v-if="v$.place.$error" class="text-delete text-base font-nunito font-bold">Bitte gib dein Reiseziel ein</p>
          <div class="flex flex-row gap-5">
            <div class="flex flex-col">
              <label class="pt-2" for="journey-from">von</label>
              <input id="journey-from" v-model="form.from" class="rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action" tabindex="3" type="date"
                     @blur="v$.from.$touch">
              <p v-if="v$.from.$error" class="text-delete text-base font-nunito font-bold">Bitte gib ein Datum an</p>
            </div>
            <div class="flex flex-col">
              <label class="pt-2" for="journey-to">bis</label>
              <input id="journey-to" v-model="form.to" class="rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action" tabindex="4" type="date"
                     @blur="v$.to.$touch">
            </div>
          </div>
          <p v-if="v$.to.$error" class="text-delete text-base font-nunito font-bold">Enddatum muss mindestens am
            Startdatum
            liegen</p>
          <label class="pt-2" for="journey-link">Beitrittslink</label>
          <div class="flex flex-row justify-between gap-2">
            <input id="journey-link" v-model="form.link" class="w-full bg-disabled-input rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action"
                   disabled>
            <div class="" tabindex="5">
              <InviteButton class="p-1 hover:opacity-[85%]" @click="copyLink"/>
            </div>
          </div>
          <span
              class="font-nunito-sans text-base mt-1">Mit diesem Link kannst du andere zu deiner Reise einladen.</span>
          <div class="pt-4 flex flex-row justify-between">
            <RouterLink class="bg-cancel rounded-[38px] px-3 py-1 shadow-md hover:opacity-80" tabindex="7"
                        to="/dashboard">
              Abbrechen
            </RouterLink>
            <button class="bg-call-to-action rounded-[38px] px-6 py-1 shadow-md disabled:opacity-80 hover:opacity-80" tabindex="6"
                    type="submit"
                    @submit.prevent="create()">
              Erstellen
            </button>
          </div>
        </form>
      </div>
      <span class="font-nunito-sans text-base">Fülle bitte alle Felder aus.</span>
    </div>

    <Footer class="mt-auto"/>
  </div>
</template>
