<script setup>
import {ref} from "vue";
import {supabase} from "@/lib/supabaseClient.js";
import {useRoute} from "vue-router";
import BackToDashboadIllustration from "@/components/illustrations/BackToDashboadIllustration.vue";
import MenuIllustration from "@/components/illustrations/MenuIllustration.vue";
import AddPeopleIllustration from "@/components/illustrations/AddPeopleIllustration.vue";

import Toast from 'primevue/toast';
import {useToast} from 'primevue/usetoast';
import ConfirmDialog from 'primevue/confirmdialog';
import {useConfirm} from "primevue/useconfirm";
import IconDelete from "@/components/icons/IconDelete.vue";
import router from "@/router";

const confirm = useConfirm();
const toast = useToast();
const journey = ref();
const showSidebar = ref(false);
const usernames = ref();
const currentUserRole = ref();
let i = 0;

const journeyID = useRoute().params.uuid;

const {data: {user}} = await supabase.auth.getUser();
const {data: currentUserFunction, error: currentUserFunctionError} = await supabase
    .from('user_is_in')
    .select(`
          function
        `)
    .eq('pk_user_uuid', user.id)
    .eq('pk_journey_uuid', journeyID);
currentUserRole.value = currentUserFunction[0].function;

const currentUser = user;
const currentUserIndex = ref();

const {data: usernamesData, error: usernamesError} = await supabase
    .from('user_is_in')
    .select(`
    user(username),
    pk_user_uuid, function)
    `)
    .eq('pk_journey_uuid', journeyID)
    .order('function', {ascending: true});
if (usernamesData) {
  usernamesData.forEach((row) => {
      if (row["pk_user_uuid"] === currentUser.id) {
        currentUserIndex.value = i;
      }
      if (row["function"] === 0) {
        row["function"] = 'Reisende/r';
      } else if (row["function"] === 1) {
        row["function"] = 'Reiseleiter/in'
      } else {
        row["function"] = 'undefined';
      }
      i++;
  });
}
if (usernamesError) {
  console.log(usernamesError);
}
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
if (error) {
  console.log(error);
}
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
  if (error) {
    console.log(error);
  }
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
  if (error) {
    console.log(error);
  }
}

async function copyLink() {
  let link = await supabase
      .from('journey')
      .select('invite')
      .eq('pk_journey_uuid', journeyID);
  link = 'https://journeyplanner.io/beitreten/' + link.data[0].invite;
  await navigator.clipboard.writeText(link);
  toast.add({
    severity: 'info',
    summary: 'Link kopiert',
    detail: 'Der Link wurde in deine Zwischenablage kopiert',
    life: 3000
  });
}

/**
 * delete journey confirmation popup
 */
function deleteConfirmation() {
  confirm.require({
    message: 'Die Reise ist danach für niemanden mehr verfügbar und alle Daten in der Reise werden gelöscht (Aktivitäten, Kalender, Erinnerungen).',
    header: 'Möchtest du diese Reise wirklich löschen? ',
    icon: 'pi pi-exclamation-triangle',
    accept: () => {
      deleteJourney()
    },
    reject: () => {
    },
    acceptLabel: 'Ja',
    rejectLabel: 'Nein',
    acceptClass: 'bg-delete rounded-3xl font-nunito text-xl font-bold p-1 px-5',
    rejectClass: 'bg-call-to-action rounded-3xl font-nunito text-xl font-bold p-1 px-3 mr-3'
  });
}

/**
 * delete Journey
 * memories and then journey (cascade deletes activities)
 * @returns {Promise<void>}
 */
async function deleteJourney() {
  toast.add({
    severity: 'info',
    summary: 'Reise wird gelöscht',
    detail: 'Bitte warte einen Moment',
    life: 3000
  });

  const {data: list, errorList} = await supabase.storage.from('upload').list(`${journeyID}`);
  if (list.length > 0) {
    const filesToRemove = list.map((x) => `${journeyID}/${x.name}`);
    const {data, errorRemove} = await supabase.storage.from('upload').remove(filesToRemove);
  }

  const {error} = await supabase
      .from('journey')
      .delete()
      .eq('pk_journey_uuid', journeyID);

  await router.push("/dashboard");
}

</script>

<template>
  <Toast/>
  <div>
    <div id="topInformation" class="w-[100%] h-[15vh] items-center justify-center flex flex-col bg-primary">
      <div class="grid grid-cols-4">
        <div v-tooltip.bottom="{
               value: journey[0].name,
                 style:{
                   width: '30vw'
                 }}" class="col-span-3 w-[70vw]">
          <h1 class="font-nunito text-3xl text-text-black font-bold overflow-hidden whitespace-nowrap overflow-ellipsis px-5">
            {{ journey[0].name }}</h1>
        </div>
        <div v-if="currentUserIndex !== null" class="col-start-4 justify-center items-center grid grid-cols-6">
          <RouterLink v-if="journey[0].user_is_in[currentUserIndex].function === 'Reiseleiter/in'"
                      class="col-start-3 hover:opacity-80"
                      to="/dashboard" v-tooltip.bottom="{
               value: 'Zum Dashboard',
                 style:{
                   width: '30vw'
                 }}">
            <BackToDashboadIllustration class="px-3"/>
          </RouterLink>
          <RouterLink v-if="journey[0].user_is_in[currentUserIndex].function === 'Reisende/r'"
                      class="col-start-4 hover:opacity-80"
                      to="/dashboard" v-tooltip.bottom="{
               value: 'Zum Dashboard',
                 style:{
                   width: '30vw'
                 }}">
            <BackToDashboadIllustration class="px-3"/>
          </RouterLink>
          <button v-if="journey[0].user_is_in[currentUserIndex].function === 'Reiseleiter/in'" class="hover:opacity-80"
                  to="/" @click="copyLink" v-tooltip.bottom="{
               value: 'Einladungslink kopieren',
                 style:{
                   width: '30vw'
                 }}">
            <AddPeopleIllustration class="px-3"/>
          </button>
          <MenuIllustration class="px-3 cursor-pointer hover:opacity-80" @click="openNav()"/>
        </div>
      </div>
      <div v-if="showSidebar"
           class="h-[100%] fixed z-10 top-0 right-0 bg-secondary overflow-x-hidden transition duration-500">
        <div class="flex flex-row justify-between">
          <a class="w-16 px-3 text-2xl mt-1.5 hover:opacity-80" href="javascript:void(0)" @click="closeNav()"
             v-tooltip.bottom="{
               value: 'Schließen',
                 style:{
                   width: '30vw'
                 }}">&times;</a>
          <div class="mt-5">
            <ConfirmDialog :draggable="false" class="w-96"/>
            <button v-if="currentUserRole === 1"
                    class="bg-delete rounded-2xl px-2 py-1 mr-4 font-nunito text-base font-bold shadow-md flex flex-row hover:opacity-80"
                    severity="danger"
                    type="button"
                    @click="deleteConfirmation" v-tooltip.bottom="{
               value: 'Reise löschen',
                 style:{
                   width: '30vw'
                 }}">
              <IconDelete class="text-black"/>
              <span class="">Reise löschen</span>
            </button>
          </div>
        </div>
        <h2 class="font-nunito text-xl text-right font-bold mr-4 ml-4">Reisemitglieder</h2>
        <div v-for="(index) in usernames.length"
             class="font-nunito text-2xl text-text-black font-semibold overflow-hidden whitespace-nowrap overflow-ellipsis px-5 text-right w-[18vw]">
          <p class="font-semibold overflow-hidden whitespace-nowrap overflow-ellipsis" v-tooltip.left="{
               value: usernames[index - 1].user.username,
                 style:{
                   width: '30vw'
                 }}"> {{ usernames[index - 1].user.username }}</p>
          <p v-if="journey[0].user_is_in[currentUserIndex].function === 'Reisende/r'"
             class="text-base font-extrabold pb-3">
            {{ usernames[index - 1].function }}</p>
          <p v-else-if="currentUser.id === usernames[index - 1].pk_user_uuid"
             class="text-base font-extrabold pb-3">{{ usernames[index - 1].function }}</p>
          <div v-else class="flex text-right justify-end text-base pb-3 cursor-pointer" v-tooltip.top="{
               value: 'Rolle ändern',
                 style:{
                   width: '30vw'
                 }}">
            <p :class="usernames[index - 1].function === 'Reiseleiter/in' ? 'font-extrabold' : 'font-regular'"
               class="px-2" @click="toTourGuide(usernames[index - 1].pk_user_uuid, (index - 1))">
              Reiseleiter/in </p>
            <p :class="usernames[index - 1].function === 'Reisende/r' ? 'font-extrabold' : 'font-regular'"
               class="text-base pb-3" @click="toRegular(usernames[index - 1].pk_user_uuid, (index - 1))">
              Reisende/r </p>
          </div>
        </div>
      </div>
    </div>
    <p class="font-nunito text-2xl text-text-black font-medium overflow-hidden px-5 pt-2">
      {{ journey[0].from }} - {{ journey[0].to }}</p>
  </div>
</template>
