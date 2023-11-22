<script setup lang="ts">

import UserDashboardJourneyItem from "@/components/UserDashboardJourneyItem.vue";
import {supabase} from "@/lib/supabaseClient.js";
import {ref} from "vue";
import IconNewJourney from "@/components/icons/IconNewJourney.vue";

const journeys = ref();

const {data, error} = await supabase
    .from('journey')
    .select('*')

journeys.value = data;
console.log(journeys.value)
</script>

<template>
  <div id="journeys" class="grid grid-cols-4 gap-4 ml-20 mr-36">
    <UserDashboardJourneyItem v-for="journey in journeys">
      <template #journey-name>Stockholm</template>
      <template #date-range>02.08. - 12.09.</template>
    </UserDashboardJourneyItem>

    <RouterLink to="/reise/neu">
      <div class="bg-call-to-action rounded-[32px] py-12 flex items-center justify-center">
        <IconNewJourney class="h-20 w-20"/>
      </div>
    </RouterLink>
  </div>
</template>

<style scoped>

</style>