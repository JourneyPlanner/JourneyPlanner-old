<script lang="ts" setup>

import Footer from "@/components/Footer.vue";
import SettingsIcon from "@/components/icons/IconSettings.vue";
import SettingsIllustration from "@/components/illustrations/SettingsIllustration.vue";


function save() {

}

</script>

<template>
  <div class="flex flex-col min-h-screen">
    <header class="flex flex-row justify-between mb-4">
      <div class="flex flex-row ml-10 mt-3">
        <SettingsIcon class="mt-3.5 ml-6 mr-5"/>
        <h1 class="font-nunito font-medium text-4xl text-text-black -my-2">Einstellungen</h1>
      </div>
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
                  class="font-nunito text-xl border rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action pl-1"
                  placeholder="Benutzername eingeben">
              <label class="text-xl font-nunito font-semibold" for="email">E-Mail</label>
              <input
                  id="email"
                  class="font-nunito text-xl border rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action pl-1"
                  placeholder="E-Mail eingeben">
            </div>
            <div class="ml-auto">
              <label class="block text-xl font-nunito font-semibold" for="password">Passwort ändern:</label>
              <input
                  id="password"
                  class="font-nunito text-xl border rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action pl-1"
                  placeholder="Neues Passwort">
            </div>
          </div>

          <div class="inline-flex flex-col align-start">
            <div class="flex-shrink-0">
              <button class="grow-0 bg-call-to-action rounded-3xl font-nunito text-xl font-bold p-1 px-2 mt-3"
                      type="button"
                      @click="save()">Speichern
              </button>
            </div>
            <div class="my-3 flex flex-row justify-between ">
              <button class="bg-delete rounded-3xl font-nunito text-xl font-bold p-1 px-2"
                      type="button"
                      @click="save()">Abmelden
              </button>
              <button class="bg-delete rounded-3xl font-nunito text-xl font-bold p-1 px-2"
                      type="button"
                      @click="save()">Account löschen
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

<style scoped>

</style>