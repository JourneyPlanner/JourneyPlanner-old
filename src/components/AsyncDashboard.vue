<script setup>
import UserDashboardJourneyItem from "@/components/UserDashboardJourneyItem.vue";
import {ref} from "vue";
import IconNewJourney from "@/components/icons/IconNewJourney.vue";

import {supabase} from "@/lib/supabaseClient.js";

const journeys = ref();

const { data: {user}} = await supabase.auth.getUser();

const {data} = await supabase
    .from('journey')
    .select(`
      pk_journey_uuid,
      name,
      from,
      to,
      user_is_in (pk_user_uuid, function)
      `)
    .eq('user_is_in.pk_user_uuid', user.id)
    .order('from', {ascending: true});

if (data) {
  data.forEach((row) => {
    let fromDate = new Date(row["from"]);
    let fromDateDay = fromDate.getDate();
    let fromDateMonth = fromDate.getMonth() + 1;
    let fromDateYear = fromDate.getFullYear();

    let toDate = new Date(row["to"]);
    let toDateDay = toDate.getDate();
    let toDateMonth = toDate.getMonth() + 1;
    let toDateYear = toDate.getFullYear();

    if (fromDateMonth === toDateMonth) {
      fromDateMonth = '';
    } else {
      fromDateMonth = fromDateMonth + '.';
    }

    if (fromDateYear === toDateYear) {
      row["from"] = fromDateDay + '.' + fromDateMonth;
      row["to"] = toDateDay + '.' + toDateMonth + '.' + toDateYear;
    } else {
      row["from"] = fromDateDay + '.' + fromDateMonth + fromDateYear;
      row["to"] = toDateDay + '.' + toDateMonth + '.' + toDateYear;
    }

    if (row["user_is_in"]["0"]["function"] === 0) {
      row["user_is_in"]["0"]["function"] = 'Reisende/r';
    } else if (row["user_is_in"]["0"]["function"] === 1) {
      row["user_is_in"]["0"]["function"] = 'Reiseleiter/in'
    } else {
      row["user_is_in"]["0"]["function"] = 'undefined';
    }
  });

  journeys.value = data;
}
</script>

<template>
  <div id="journeys" class="grid grid-cols-1 sm:grid-cols-3 lg:grid-cols-4 gap-2 lg:gap-4 mx-5 lg:ml-16 lg:mr-36">
    <RouterLink v-for="journey in journeys" :to="{ path: '/reise/'+ journey.pk_journey_uuid }"
                v-tooltip.top="journey.name">
      <UserDashboardJourneyItem>
        <template #journey-name>{{ journey.name }}</template>
        <template #date-range>{{ journey.from }} - {{ journey.to }}</template>
        <template #function>{{ journey.user_is_in[0].function }}</template>
      </UserDashboardJourneyItem>
    </RouterLink>

    <RouterLink to="/reise/neu" v-tooltip.top="'Neue Reise erstellen'">
      <div
          class="bg-call-to-action rounded-[32px] mt-1 flex items-center justify-center shadow-md hover:opacity-80 py-12 sm:h-56 lg:h-full">
        <IconNewJourney class="h-20 w-20 fill-text-black mb-2 mt-1.5"/>
      </div>
    </RouterLink>
  </div>
</template>
