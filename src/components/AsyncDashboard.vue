<script setup lang="ts">

import UserDashboardJourneyItem from "@/components/UserDashboardJourneyItem.vue";
import {supabase} from "@/lib/supabaseClient";
import {ref} from "vue";

const journeys = ref();

console.log()

const { data, error } = await supabase
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

    <div class="bg-call-to-action rounded-[32px] overflow-hidden py-8">
      <div class="font-nunito font-medium text-2xl pl-3">
        <slot name="journey-name"></slot>
      </div>
      <div class="font-nunito text-xl pl-3">
        <slot name="date-range"></slot>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>