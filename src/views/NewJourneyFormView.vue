<script setup lang="ts">
import CreateJourneyLeftIllustration from "@/components/illustrations/CreateJourneyLeftIllustration.vue";
import CreateJourneyRightIllustration from "@/components/illustrations/CreateJourneyRightIllustration.vue";

import InviteButton from "@/components/buttons/InviteButton.vue";
import Footer from "@/components/Footer.vue";

import Toast from 'primevue/toast';
import {useToast} from 'primevue/usetoast';

import {computed} from 'vue';
import {reactive} from 'vue';
import {useVuelidate} from '@vuelidate/core';
import {required} from '@vuelidate/validators';
import {supabase} from "@/lib/supabaseClient";
import router from "@/router";

const toast = useToast();

const form = reactive({
  name: '',
  place: '',
  from: '',
  to: '',
  link: 'journeyplanner.io/invite/xxxxx',
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
        .from('journey')
        .insert([
          {name: form.name, place: form.place, from: form.from, to: form.to},
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
          <label for="journey-name" class="pb-0.5 pt-2">Name deiner Reise</label>
          <input id="journey-name" placeholder="Reisename" v-model="form.name" @blur="v$.name.$touch" tabindex="1"
                 class="rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action pl-1.5">
          <p v-if="v$.name.$error" class="text-delete text-base font-nunito-sans font-bold">Bitte gib deiner Reise einen
            Namen</p>
          <label for="journey-place" class="pb-0.5 pt-2">Stadt/Land/Gebiet</label>
          <input id="journey-place" placeholder="Stadt/Land/Gebiet" v-model="form.place" @blur="v$.place.$touch"
                 tabindex="2"
                 class="rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action">
          <p v-if="v$.place.$error" class="text-delete text-base font-nunito font-bold">Bitte gib dein Reiseziel ein</p>
          <div class="flex flex-row gap-5">
            <div class="flex flex-col">
              <label for="journey-from" class="pt-2">von</label>
              <input id="journey-from" type="date" v-model="form.from" @blur="v$.from.$touch" tabindex="3"
                     class="rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action">
              <p v-if="v$.from.$error" class="text-delete text-base font-nunito font-bold">Bitte gib ein Datum an</p>
            </div>
            <div class="flex flex-col">
              <label for="journey-to" class="pt-2">bis</label>
              <input id="journey-to" type="date" v-model="form.to" @blur="v$.to.$touch" tabindex="4"
                     class="rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action">
            </div>
          </div>
          <p v-if="v$.to.$error" class="text-delete text-base font-nunito font-bold">Enddatum muss mindestens am
            Startdatum
            liegen</p>
          <label for="journey-link" class="pt-2">Beitrittslink</label>
          <div class="flex flex-row justify-between gap-2">
            <input id="journey-link" disabled v-model="form.link"
                   class="w-full bg-disabled-input rounded pl-1.5 border-none focus:outline-none focus:ring-2 focus:ring-call-to-action">
            <div class="" tabindex="5">
              <InviteButton class="p-1"/>
            </div>
          </div>
          <span
              class="font-nunito-sans text-base mt-1">Mit diesem Link kannst du andere zu deiner Reise einladen.</span>
          <div class="pt-4 flex flex-row justify-between">
            <RouterLink to="/dashboard" class="bg-cancel rounded-[38px] px-3 py-1 shadow-md hover:opacity-80"
                        tabindex="7">
              Abbrechen
            </RouterLink>
            <button type="submit" @submit.prevent="create()"
                    class="bg-call-to-action rounded-[38px] px-6 py-1 shadow-md disabled:opacity-80 hover:opacity-80"
                    tabindex="6">
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
