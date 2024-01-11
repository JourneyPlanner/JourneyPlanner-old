<script setup>

import Footer from "@/components/Footer.vue";
import SettingsIcon from "@/components/icons/IconSettings.vue";
import SettingsIllustration from "@/components/illustrations/SettingsIllustration.vue";
import ConfirmDialog from 'primevue/confirmdialog';

//@ts-ignore
import {supabase} from "@/lib/supabaseClient";
import router from "@/router";
import {useConfirm} from "primevue/useconfirm";
import {computed, ref} from "vue";
import {email, minLength, required} from "@vuelidate/validators";
import {useVuelidate} from "@vuelidate/core";
import BackToDashboadIllustration from "@/components/illustrations/BackToDashboadIllustration.vue";

const confirm = useConfirm();

const emailRef = ref('');
const username = ref('');
const password = ref('');

const rules = computed(() => ({
  emailRef: {
    required, email
  },
  username: {
    required
  },
  password: {
    minlength: minLength(6)
  }
}))

const v$ = useVuelidate(rules, {emailRef, username, password});

supabase.auth.getSession().then((user) => {
      supabase.from('user')
          .select('username')
          .eq('pk_uuid', user.data.session.user.id)
          .then((data, error) => {
            if (error) {
              console.log(error);
            } else {
              username.value = data.data[0].username;
            }
          });

      emailRef.value = user.data.session.user.email;
    }
);

async function save() {
  if (v$.value.$invalid) {
    return;
  }

  if (password.value != '') {
    const {error} = await supabase.auth.updateUser({
      password: password.value
    });
    if (error) {
      console.log(error);
    } else {
      await logout();
    }
  }

  const {data, error} = await supabase.auth.updateUser({
    email: emailRef.value,
    data: {
      username: username.value,
    }
  });

  if (error) {
    console.log(error);
  } else {
    await router.push("/dashboard");
  }
}

async function logout() {
  const {error} = await supabase.auth.signOut();
  if (error) {
    console.log(error);
  } else {
    await router.push("/login");
  }
}

function deleteConfirmation() {
  confirm.require({
    message: 'Möchtest du deinen Account wirklich löschen?',
    header: 'Account löschen',
    icon: 'pi pi-exclamation-triangle',
    accept: () => deleteUser(),
    reject: () => {
    },
    acceptLabel: 'Ja',
    rejectLabel: 'Nein',
    acceptClass: 'bg-delete rounded-3xl font-nunito text-xl font-bold p-1 px-5',
    rejectClass: 'bg-call-to-action rounded-3xl font-nunito text-xl font-bold p-1 px-3 mr-3'
  });
}

async function deleteUser() {
  const {error} = await supabase.rpc('delete_user');
  if (error) {
    console.log(error);
  } else {
    await logout();
  }
}

</script>

<template>
  <div class="flex flex-col min-h-screen">
    <header class="flex flex-row justify-between mb-4">
      <div class="flex flex-row ml-10 mt-3">
        <SettingsIcon class="mt-3.5 ml-6 mr-5"/>
        <h1 class="font-nunito font-medium text-4xl text-text-black -my-2">Einstellungen</h1>
      </div>
      <RouterLink class="mr-10 mt-6"
                  to="/dashboard">
        <BackToDashboadIllustration class="px-3"/>
      </RouterLink>
    </header>

    <div class="bg-background flex ml-16">
      <div class="xl:w-1/2 md:w-2/3 sm:w-[100%] flex flex-col">
        <h1 class="xl:text-3xl md:text-3xl sm:text-3xl pl-6em font-nunito">Kontodaten</h1>
        <form class="bg-primary rounded-2xl xl:w-[50vw] md:w-[75vw] sm:w-[100vw] flex flex-col p-5">
          <div class="flex flex-row">
            <div class="flex flex-col">
              <label class="text-xl font-nunito font-semibold" for="username">Benutzername</label>
              <input
                  id="username"
                  v-model="v$.username.$model"
                  class="font-nunito text-xl border rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action pl-1"
                  placeholder="Benutzername eingeben"
                  type="text">
              <p v-if="v$.username.$error" class="text-delete text-base font-nunito">Benutzername ist verpflichtend</p>
              <label class="text-xl font-nunito font-semibold mt-4" for="email">E-Mail</label>
              <input
                  id="email"
                  v-model="v$.emailRef.$model"
                  class="font-nunito text-xl border rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action pl-1"
                  placeholder="E-Mail eingeben"
                  type="email">
              <p v-if="v$.emailRef.$error" class="text-delete text-base font-nunito">Ungültige E-Mail-Adresse</p>
            </div>
            <div class="ml-auto">
              <label class="block text-xl font-nunito font-semibold" for="password">Passwort ändern:</label>
              <input
                  id="password"
                  v-model="v$.password.$model"
                  class="font-nunito text-xl border rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action pl-1"
                  placeholder="Neues Passwort"
                  type="password">
              <p v-if="v$.password.$error" class="text-delete text-base font-nunito">Mindestens 6 Zeichen</p>
            </div>
          </div>

          <div class="inline-flex flex-col align-start mt-4">
            <div class="flex-shrink-0">
              <button
                  :disabled="v$.$invalid"
                  class="grow-0 bg-call-to-action rounded-3xl font-nunito text-xl font-bold p-1 px-2 mt-3 shadow-md disabled:opacity-50"
                  type="button"
                  @click="save()">Speichern
              </button>
            </div>
            <div class="my-3 flex flex-row justify-between ">
              <button class="bg-delete rounded-3xl font-nunito text-xl font-bold p-1 px-2 shadow-md"
                      type="button"
                      @click="logout()">Abmelden
              </button>
              <ConfirmDialog></ConfirmDialog>
              <button class="bg-delete rounded-3xl font-nunito text-xl font-bold p-1 px-2 shadow-md"
                      severity="danger"
                      type="button"
                      @click="deleteConfirmation()">Account löschen
              </button>
            </div>
          </div>

        </form>
      </div>
    </div>
    <div class="absolute bottom-0 right-0 overflow-hidden">
      <SettingsIllustration class="h-[34vw] -mr-48 -mb-16"/>
    </div>
    <Footer class="mt-auto"/>
  </div>
</template>
