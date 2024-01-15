<script setup lang="ts">
import HomeMarkerIcon from "../components/icons/IconHomeMarker.vue";
import SettingsIcon from "../components/icons/IconSettings.vue";
import NewJourneyButton from "../components/buttons/NewJourneyButton.vue";
import Footer from "@/components/Footer.vue";

import {defineAsyncComponent} from "vue";

const AsyncDashboard = defineAsyncComponent(() =>
    import('@/components/AsyncDashboard.vue')
);
</script>

<template>
  <div class="flex flex-col min-h-screen">
    <header class="flex flex-col sm:flex-row justify-between ml-5 lg:ml-16">
      <div class="flex flex-row">
        <HomeMarkerIcon class="mt-3.5 mr-5"/>
        <h1 class="font-nunito font-medium text-2xl sm:text-3xl lg:text-4xl mt-4 lg:mt-0 text-text-black">Deine Reisen</h1>
      </div>

      <div class="flex flex-row h-24 justify-between sm:mt-4">
        <NewJourneyButton class="border-2 border-call-to-action hover:opacity-80 shadow-md"
                          v-tooltip.bottom="{
               value: 'Neue Reise erstellen',
               style:{
                   width: '30vw'
               }}"/>

        <RouterLink to="/einstellungen" v-tooltip.left="{
               value: 'Einstellungen',
                 style:{
                   width: '30vw'
                 }}">

          <SettingsIcon class="mt-3 lg:mt-5 mx-5 w-10 lg:w-14 hover:opacity-80 lg:mr-20 mb-4"/>
        </RouterLink>
      </div>
    </header>

    <main>
      <Suspense>
        <template #default>
          <AsyncDashboard/>
        </template>
        <template #fallback>
          <div class="flex text-center justify-center">
            <p class="text-3xl font-medium font-nunito text-text-black">Lade...</p>
          </div>
        </template>
      </Suspense>
    </main>

    <Footer class="mt-auto"/>
  </div>
</template>
