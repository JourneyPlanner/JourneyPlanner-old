<script setup>
import {ref} from "vue";
import {supabase} from "@/lib/supabaseClient.js";
import {useRoute} from "vue-router";
import BackToDashboadIllustration from "@/components/illustrations/BackToDashboadIllustration.vue";
import MenuIllustration from "@/components/illustrations/MenuIllustration.vue";
import AddPeopleIllustration from "@/components/illustrations/AddPeopleIllustration.vue";

const journey = ref();
const showSidebar = ref(false);
const usernames = ref();
const {data: {user}} = await supabase.auth.getUser();
const currentUser = user;
const currentUserIndex = ref();
const journeyID = useRoute().params.uuid;
const {data: usernamesData, error: usernamesError} = await supabase
    .from('journey')
    .select(`
    user(username),
    user_is_in(pk_user_uuid, function)
    `).eq('pk_journey_uuid', journeyID);
if (usernamesData) {
  usernamesData.forEach((row) => {
    for (let i = 0; i < row["user_is_in"].length; i++) {
      if (row["user_is_in"][i]["pk_user_uuid"] === currentUser.id) {
        currentUserIndex.value = i;
      }
      if (row["user_is_in"][i]["function"] === 0) {
        row["user_is_in"][i]["function"] = 'Reisende/r';
      } else if (row["user_is_in"][i]["function"] === 1) {
        row["user_is_in"][i]["function"] = 'Reiseleiter/in'
      } else {
        row["user_is_in"][i]["function"] = 'undefined';
      }
    }
  });
}
console.log(usernamesError);
usernames.value = usernamesData;

const {data, error} = await supabase
    .from('journey')
    .select(`
      pk_journey_uuid,
      name,
      from,
      to,
      user_is_in (function) as function
      `).eq('pk_journey_uuid', journeyID);
console.log(error)
if (data) {
  data.forEach((row) => {
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
    for (let i = 0; i < row["user_is_in"].length; i++) {
      if (row["user_is_in"][i]["function"] === 0) {
        row["user_is_in"][i]["function"] = 'Reisende/r';
      } else if (row["user_is_in"][i]["function"] === 1) {
        row["user_is_in"][i]["function"] = 'Reiseleiter/in'
      } else {
        row["user_is_in"][i]["function"] = 'undefined';
      }
    }

  });
  journey.value = data;

}

function openNav() {
  showSidebar.value = true;
}

function closeNav() {
  showSidebar.value = false;
}

/**
 * set user to tour guide
 *
 * @param user_uuid {string}
 * @param index {number}
 * @returns {Promise<void>}
 */
async function toTourGuide(user_uuid, index) {

  if (currentUser.id !== user_uuid) {
    const {error} = await supabase
        .from('user_is_in')
        .update({function: 1})
        .eq('pk_user_uuid', user_uuid)
        .eq('pk_journey_uuid', journeyID);
    location.reload();
  }
  console.log(error);

}

/**
 * set user to regular
 *
 * @param user_uuid {string}
 * @param index {number}
 * @returns {Promise<void>}
 */
async function toRegular(user_uuid, index) {

  if (currentUser.id !== user_uuid) {
    const {error} = await supabase
        .from('user_is_in')
        .update({function: 0})
        .eq('pk_user_uuid', user_uuid)
        .eq('pk_journey_uuid', journeyID);
    journey.value[0].user_is_in[index].function = 'Reisende/r';
    location.reload();

  }
  console.log(error);
}

</script>

<template>
  <div>
    <div id="topInformation" class="w-[100%] h-[15vh] items-center justify-center flex flex-col bg-primary">
      <div class="grid grid-cols-4">
        <div v-tooltip.bottom="{
               value: journey[0].name,
                 style:{
                   width: '30vw'
                 }}" class="col-span-2 w-[45vw]">
          <h1 class="font-nunito text-4xl text-text-black font-medium overflow-hidden whitespace-nowrap overflow-ellipsis px-5">
            {{ journey[0].name }}</h1>
        </div>
        <div v-if="currentUserIndex !== null" class="col-start-4 justify-center items-center grid grid-cols-6">
          <RouterLink v-if="journey[0].user_is_in[currentUserIndex].function === 'Reiseleiter/in'" class="col-start-3"
                      to="/dashboard">
            <BackToDashboadIllustration class="px-3"/>
          </RouterLink>
          <RouterLink v-if="journey[0].user_is_in[currentUserIndex].function === 'Reisende/r'" class="col-start-4"
                      to="/dashboard">
            <BackToDashboadIllustration class="px-3"/>
          </RouterLink>
          <RouterLink v-if="journey[0].user_is_in[currentUserIndex].function === 'Reiseleiter/in'" class="" to="/">
            <AddPeopleIllustration class="px-3"/>
          </RouterLink>
          <MenuIllustration class="px-3 cursor-pointer" @click="openNav()"/>
        </div>
      </div>
      <div v-if="showSidebar"
           class="h-[100%] fixed z-10 top-0 right-0 bg-secondary overflow-x-hidden transition duration-500">
        <a class="w-16 px-3 text-2xl" href="javascript:void(0)" @click="closeNav()">&times;</a>
        <div v-for="(index) in usernames[0].user.length"
             class="font-nunito text-2xl text-text-black font-semibold overflow-hidden whitespace-nowrap overflow-ellipsis px-5 text-right">
          <p class="font-semibold"> {{ usernames[0].user[index - 1].username }}</p>
          <p v-if="journey[0].user_is_in[currentUserIndex].function === 'Reisende/r'"
             class="text-base font-extrabold pb-3">
            {{ usernames[0].user_is_in[index - 1].function }}</p>
          <p v-else-if="currentUser.id === usernames[0].user_is_in[index - 1].pk_user_uuid"
             class="text-base font-extrabold pb-3">{{ usernames[0].user_is_in[index - 1].function }}</p>
          <div v-else class="flex text right justify-center text-center text-base pb-3 cursor-pointer">
            <p :class="usernames[0].user_is_in[index - 1].function === 'Reiseleiter/in' ? 'font-extrabold' : 'font-regular'"
               class="px-2" @click="toTourGuide(usernames[0].user_is_in[index - 1].pk_user_uuid, (index - 1))">
              Reiseleiter/in </p>
            <p :class="usernames[0].user_is_in[index - 1].function === 'Reisende/r' ? 'font-extrabold' : 'font-regular'"
               class="text-base pb-3" @click="toRegular(usernames[0].user_is_in[index - 1].pk_user_uuid, (index - 1))">
              Reisende/r </p>
          </div>
        </div>
      </div>
    </div>
    <p class="font-nunito text-2xl text-text-black font-medium overflow-hidden px-5 pt-2">
      {{ journey[0].from }} - {{ journey[0].to }}</p>
  </div>
</template>
