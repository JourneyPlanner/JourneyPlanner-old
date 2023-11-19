<script setup lang="ts">

/** check if there is a history to go back to **/
function hasHistory() {
  return window.history.length > 2
}
</script>

<template>
  <button @click="hasHistory() ? $router.back() : $router.push('/')"
          class=" bg-call-to-action border border-call-to-action rounded-[48px] text-text-black
          font-nunito-sans font-semibold text-base sm:text-base sm:font-bold md:text-xl">
    Zurück
  </button>
</template>

<style scoped>

</style>