<script setup lang="ts">
import HomeMarkerIcon from "../components/icons/IconHomeMarker.vue";
import SettingsIcon from "../components/icons/IconSettings.vue";
import UserDashboardJourneyItem from "../components/UserDashboardJourneyItem.vue";
</script>

<template>
  <header class="flex flex-row">
    <HomeMarkerIcon/>
    <h1 class="font-nunito font-semibold text-4xl">Deine Reisen</h1>

    <!-- Button noch, aber warten auf button folder -->

    <!-- besser noch zu nem komponenten machen -->
    <SettingsIcon />
  </header>

  <body>
  <div id="journeys" class="grid grid-cols-4 gap-20">
    <UserDashboardJourneyItem>
      <template #journey-name>Stockholm</template>
      <template #date-range>02.08. - 12.09.</template>
    </UserDashboardJourneyItem>

    <UserDashboardJourneyItem>
      <template #journey-name>Stockholm</template>
      <template #date-range>02.08. - 12.09.</template>
    </UserDashboardJourneyItem>

    <UserDashboardJourneyItem>
      <template #journey-name>Stockholm</template>
      <template #date-range>02.08. - 12.09.</template>
    </UserDashboardJourneyItem>

    <UserDashboardJourneyItem>
      <template #journey-name>Stockholm</template>
      <template #date-range>02.08. - 12.09.</template>
    </UserDashboardJourneyItem>
  </div>
  </body>
</template>

<style scoped>

</style>