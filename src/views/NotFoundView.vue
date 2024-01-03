<script setup lang="ts">

import NotFoundIllustration from "@/components/illustrations/NotFoundIllustration.vue";
import BackButton from "@/components/buttons/BackButton.vue";
import Footer from "@/components/Footer.vue";

/** check if there is a history to go back to **/
function hasHistory() {
  return window.history.length > 2
}
</script>

<template>
  <div class="flex justify-center items-center mt-14">
    <div class="flex flex-col justify-center items-center text-center">
      <NotFoundIllustration class=""/>
      <h2 class="font-nunito font-bold text-text-black text-2xl">
        Diese Seite ist auf Reise und leider unauffindbar!
      </h2>
      <h3 class="font-nunito-sans text-text-black text-xl">Du glaubst das ist ein Fehler? Kontaktiere uns unter
        <a href="mailto:contact@journeyplanner.io" class="underline">contact@journeyplanner.io</a>!
      </h3>
      <div>
        <button @click="hasHistory() ? $router.back() : $router.push('/')"
                class="underline font-nunito text-xl font-medium mr-3 mt-5">Zurück
        </button>
        |
        <RouterLink to="/dashboard" class="underline font-nunito text-xl font-medium ml-3">Dashboard</RouterLink>
      </div>
    </div>
  </div>

  <Footer class="fixed bottom-0 w-full"/>

</template>
