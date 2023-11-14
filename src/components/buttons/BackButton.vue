<script setup lang="ts">

function hasHistory() {
  return window.history.length > 2
}
</script>

<template>
  <button @click="hasHistory() ? $router.back() : $router.push('/')"
          class="
          bg-call-to-action
          border border-call-to-action rounded-[48px]
          text-text-black font-nunito-sans font-bold xl:text-xl
          sm:text-base md:text-base
          mx-10 my-2
          "
  >
    Zurück
  </button>
</template>

<style scoped>

</style>