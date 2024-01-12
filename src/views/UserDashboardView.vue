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
    <header class="grid grid-cols-2 grid-rows-1 justify-between mb-4">
      <div class="flex flex-row ml-10 mt-3">
        <HomeMarkerIcon class="mt-3.5 ml-7 mr-5"/>
        <h1 class="font-nunito font-medium text-2xl lg:text-4xl text-text-black">Deine Reisen</h1>
      </div>

      <div class="flex flex-row  mr-20">
        <NewJourneyButton class="border-2 border-call-to-action hover:opacity-80 shadow-md" v-tooltip.bottom="{
               value: 'Neue Reise erstellen',
                 style:{
                   width: '30vw'
                 }}"/>

        <RouterLink to="einstellungen" v-tooltip.left="{
               value: 'Einstellungen',
                 style:{
                   width: '30vw'
                 }}">
          <SettingsIcon class="mt-9 ml-5 w-14 hover:opacity-80"/>
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
