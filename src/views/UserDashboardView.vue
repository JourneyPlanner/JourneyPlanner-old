<script setup lang="ts">
import HomeMarkerIcon from "../components/icons/IconHomeMarker.vue";
import SettingsIcon from "../components/icons/IconSettings.vue";
import UserDashboardJourneyItem from "../components/UserDashboardJourneyItem.vue";
import NewJourneyButton from "../components/buttons/NewJourneyButton.vue";
import Footer from "@/components/Footer.vue";

import {defineAsyncComponent} from "vue";

const AsyncDashboard = defineAsyncComponent(() =>
    import('@/components/AsyncDashboard.vue')
);

</script>

<template>
  <header class="flex flex-row">
    <div class="flex flex-row basis-1/2 ml-10">
      <HomeMarkerIcon class="mt-3 ml-7 mr-5"/>
      <h1 class="font-nunito font-medium text-4xl">Deine Reisen</h1>
    </div>

    <div class="flex flex-row basis-1/2 pl-80">
      <NewJourneyButton/>

      <RouterLink to="settings">
        <SettingsIcon class="mt-9 ml-5 w-14"/>
      </RouterLink>
    </div>
  </header>

  <body>
  <Suspense>
    <template #default>
      <AsyncDashboard/>
    </template>
    <template #fallback>
      <div class="flex text-center justify-center">
        <p class="text-3xl font-medium font-nunito">Lade...</p>
      </div>
    </template>
  </Suspense>
  </body>

  <Footer class="absolute inset-x-0 bottom-0"/>
</template>

<style scoped>

</style>