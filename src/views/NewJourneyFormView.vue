<script setup lang="ts">
import {ref} from "vue";
//@ts-ignore
import {supabase} from "@/lib/supabaseClient.js";
import {useRoute} from "vue-router";

const journeys = ref();
const journey = ref();
journey.value = useRoute().params.id;
console.log(journey.value);
const {data, error} = await supabase
    .from('journey')
    .select(`
      pk_journey_uuid,
      name,
      from,
      to,
      user_is_in (function) as function
      `).eq('pk_journey_uuid', useRoute().params.uuid);
console.log(error)
if (data) {
  data.forEach((row: any) => {
    let fromDate = new Date(row["from"]);
    let fromDateDay = fromDate.getDay();
    let fromDateMonth = fromDate.getMonth() + 1;
    let fromDateYear = fromDate.getFullYear();
    let toDate = new Date(row["to"]);
    let toDateDay = toDate.getDay();
    let toDateMonth = toDate.getMonth() + 1;
    let toDateYear = toDate.getFullYear();
    if (fromDateYear === toDateYear) {
      row["from"] = fromDateDay + '.' + fromDateMonth + '.';
      row["to"] = toDateDay + '.' + toDateMonth + '.' + toDateYear;
    } else {
      row["from"] = fromDateDay + '.' + fromDateMonth + '.' + fromDateYear;
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
  <div class="relative">
    <div class="bg-background flex">
      <div id="topInformation" class="w-[100%] h-[15vh] items-center justify-center flex flex-col bg-primary">
        <p>{{ journey}}</p>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>