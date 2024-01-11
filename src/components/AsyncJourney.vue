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

const journeyID = useRoute().params.uuid;
let currentUser = null;


await getUsernameData();
await getJourneyData();

async function getUsernameData() {
  const {data: {user}} = await supabase.auth.getUser();
  currentUser = user;

  const {data: userFunctionsData, error: userFunctionsError} = await supabase
      .from('user_is_in')
      .select(`
      pk_user_uuid, function
      `)
      .eq('pk_journey_uuid', journeyID)
      .order('function', {ascending: false});

  if (userFunctionsError) {
    if (userFunctionsError.code === "22P02") {
      await router.push('/reise/nicht-gefunden');
    }
    console.log(userFunctionsError);
  }


  const {data: usernamesData, error: usernamesError} = await supabase
      .from('user')
      .select(`
      pk_uuid, username
      `).in('pk_uuid', userFunctionsData.map((x) => x.pk_user_uuid));

  if (usernamesError) {
    console.log(usernamesError);
  }

  const combinedUserData = usernamesData.map((x) => {
    return {
      user: x,
      function: userFunctionsData.find((y) => y.pk_user_uuid === x.pk_uuid).function
    }
  });

  currentUserRole.value = userFunctionsData.find((x) => x.pk_user_uuid === currentUser.id).function;
  usernames.value = combinedUserData;
}

async function getJourneyData() {
  const {data, error} = await supabase
      .from('journey')
      .select(`
      pk_journey_uuid,
      name,
      from,
      to
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

    });
    journey.value = data;
  }
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
 * @returns {Promise<void>}
 */
async function toTourGuide(user_uuid) {
  if (currentUser.id !== user_uuid) {
    const {error} = await supabase
        .from('user_is_in')
        .update({function: 1})
        .eq('pk_user_uuid', user_uuid)
        .eq('pk_journey_uuid', journeyID);
    if (error) {
      console.log(error);
    }

    await getUsernameData();
  }

}

/**
 * set user to regular
 *
 * @param user_uuid {string}
 * @returns {Promise<void>}
 */
async function toRegular(user_uuid) {
  if (currentUser.id !== user_uuid) {
    const {error} = await supabase
        .from('user_is_in')
        .update({function: 0})
        .eq('pk_user_uuid', user_uuid)
        .eq('pk_journey_uuid', journeyID);
    if (error) {
      console.log(error);
    }
    await getUsernameData();

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
        <div class="col-start-4 justify-center items-center grid grid-cols-6">
          <RouterLink v-if="currentUserRole === 1"
                      v-tooltip.bottom="{
               value: 'Zum Dashboard',
                 style:{
                   width: '30vw'
                 }}"
                      class="col-start-3 hover:opacity-80" to="/dashboard">
            <BackToDashboadIllustration class="px-3"/>
          </RouterLink>
          <RouterLink v-if="currentUserRole === 0"
                      v-tooltip.bottom="{
               value: 'Zum Dashboard',
                 style:{
                   width: '30vw'
                 }}"
                      class="col-start-4 hover:opacity-80" to="/dashboard">
            <BackToDashboadIllustration class="px-3"/>
          </RouterLink>
          <button v-if="currentUserRole === 1" v-tooltip.bottom="{
               value: 'Einladungslink kopieren',
                 style:{
                   width: '30vw'
                 }}"
                  class="hover:opacity-80" to="/" @click="copyLink">
            <AddPeopleIllustration class="px-3"/>
          </button>
          <MenuIllustration class="px-3 cursor-pointer hover:opacity-80" @click="openNav()"/>
        </div>
      </div>
      <div v-if="showSidebar"
           class="h-[100%] fixed z-10 top-0 right-0 bg-secondary overflow-x-hidden transition duration-500">
        <div class="flex flex-row justify-between">
          <a v-tooltip.bottom="{
               value: 'Schließen',
                 style:{
                   width: '30vw'
                 }}" class="w-16 px-3 text-2xl mt-1.5 hover:opacity-80" href="javascript:void(0)"
             @click="closeNav()">&times;</a>
          <div class="mt-5">
            <ConfirmDialog :draggable="false" class="w-96"/>
            <button v-if="currentUserRole === 1"
                    v-tooltip.bottom="{
               value: 'Reise löschen',
                 style:{
                   width: '30vw'
                 }}"
                    class="bg-delete rounded-2xl px-2 py-1 mr-4 font-nunito text-base font-bold shadow-md flex flex-row hover:opacity-80"
                    severity="danger"
                    type="button" @click="deleteConfirmation">
              <IconDelete class="text-black"/>
              <span class="">Reise löschen</span>
            </button>
          </div>
        </div>
        <h2 class="font-nunito text-xl text-right font-bold mr-4 ml-4">Reisemitglieder</h2>
        <div v-for="(index) in usernames.length"
             class="font-nunito text-2xl text-text-black font-semibold overflow-hidden whitespace-nowrap overflow-ellipsis px-5 text-right w-[18vw]">
          <!-- Username -->
          <p v-tooltip.left="{
               value: usernames[index - 1].user.username,
                 style:{
                   width: '30vw'
                 }}" class="font-semibold overflow-hidden whitespace-nowrap overflow-ellipsis">
            {{ usernames[index - 1].user.username }}</p>

          <!-- if current user is just member -->
          <div v-if="currentUserRole === 0">
            <p v-if="usernames[index - 1].function === 0"
               class="text-base font-extrabold pb-3">
              Reisende/r</p>
            <p v-else-if="usernames[index - 1].function === 1"
               class="text-base font-extrabold pb-3">Reiseleiter/in</p>
          </div>

          <!-- if current user is journey guide  -->
          <div v-if="currentUserRole === 1" class="flex text-right justify-end text-base pb-3">
            <!-- for all users except current user -->
            <div v-if="usernames[index - 1].user.pk_uuid !== currentUser.id" v-tooltip.top="{
               value: 'Rolle ändern',
                 style:{
                   width: '30vw'
                 }}" class="flex">

              <!-- Reiseleiter/in -->
              <!-- if user is currently Reiseleiter/in -->
              <p v-if="usernames[index - 1].function === 1"
                 class="font-extrabold px-2">
                Reiseleiter/in </p>
              <!-- if user is currently Reisende/r and could be promoted -->
              <p v-else
                 class="px-2 font-regular cursor-pointer" @click="toTourGuide(usernames[index - 1].user.pk_uuid)">
                Reiseleiter/in </p>


              <!-- Reisende/r -->
              <!-- if user is currently Reisende/r -->
              <p v-if="usernames[index - 1].function === 0" class="pb-3 font-extrabold">Reisende/r </p>
              <!-- if user is currently Reiseleiter/in and could be downgraded -->
              <p v-else class="pb-3 font-regular cursor-pointer" @click="toRegular(usernames[index - 1].user.pk_uuid)">
                Reisende/r </p>
            </div>

            <!-- for current user -->
            <div v-else>
              <p class="px-2 font-extrabold">Reiseleiter/in </p>
            </div>
          </div>
        </div>
      </div>
    </div>
    <p class="font-nunito text-2xl text-text-black font-medium overflow-hidden px-5 pt-2">
      {{ journey[0].from }} - {{ journey[0].to }}</p>
  </div>
</template>
