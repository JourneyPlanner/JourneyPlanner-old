<script setup lang="ts">
import {ref} from "vue";
//@ts-ignore
import {supabase} from "@/lib/supabaseClient.js";
import {useRoute} from "vue-router";
import BackToDashboadIllustration from "@/components/illustrations/BackToDashboadIllustration.vue";
import MenuIllustration from "@/components/illustrations/MenuIllustration.vue";
import AddPeopleIllustration from "@/components/illustrations/AddPeopleIllustration.vue";

const journey = ref();
const sidebarWidth = ref(0);
const usernames = ref();

journey.value = useRoute().params.uuid;
const {data2, error2} = await supabase
    .from('journey')
    .select(`
    pk_journey_uuid,
    user(username)
    `).
    //.eq('pk_journey_uuid', journey);
console.log(error2);
console.log(data2 + "xxxx")
usernames.value = data2;


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
  journey.value = data;
}

function openNav() {
  sidebarWidth.value = 250;
}

function closeNav() {
  sidebarWidth.value = 0;
}
</script>

<template>
  <div>
    <div id="topInformation" class="w-[100%] h-[15vh] items-center justify-center flex flex-col bg-primary">
      <div class="grid grid-cols-4">
        <div class="col-span-2 w-[45vw]" v-tooltip.bottom="{
               value: journey[0].name,
                 style:{
                   width: '30vw'
                 }}">
          <h1 class="font-nunito text-4xl text-text-black font-medium overflow-hidden whitespace-nowrap overflow-ellipsis px-5">
            {{ journey[0].name }}</h1>
        </div>
        <div class="col-start-4 justify-center items-center grid grid-cols-6">
          <RouterLink to="/dashboard" class="col-start-3" v-if="journey[0].user_is_in[0].function === 'Reiseleiter/in'">
            <BackToDashboadIllustration class="px-3"/>
          </RouterLink>
          <RouterLink to="/dashboard" class="col-start-4" v-if="journey[0].user_is_in[0].function === 'Reisende/r'">
            <BackToDashboadIllustration class="px-3"/>
          </RouterLink>
          <RouterLink to="/" class="" v-if="journey[0].user_is_in[0].function === 'Reiseleiter/in'">
            <AddPeopleIllustration class="px-3"/>
          </RouterLink>
          <MenuIllustration class="px-3" @mouseover="openNav()"/>
        </div>
      </div>
      <div
          :class="'h-[100%] w-[' + sidebarWidth +'px] fixed z-10 top-0 right-0 bg-primary overflow-x-hidden transition duration-500'">
        <a href="javascript:void(0)" class="w-16 px-3" @mouseover="closeNav()">&times;</a>
        <p> {{ usernames[0] }}</p>
        <a href="#">Services</a>
        <a href="#">Clients</a>
        <a href="#">Contact</a>
      </div>
    </div>
    <p class="font-nunito text-2xl text-text-black font-medium overflow-hidden px-5 pt-2">
      {{ journey[0].from }} - {{ journey[0].to }}</p>
  </div>
</template>

<style scoped>

</style>