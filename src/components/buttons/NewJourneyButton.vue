<script setup lang="ts">
import IconNewJourney from "@/components/icons/IconNewJourney.vue";
</script>

<template>
  <RouterLink to="/reise/neu" class="bg-call-to-action
  border-4 border-call-to-action rounded-[44px]
  text-text-black font-nunito font-semibold text-2xl
   flex justify-around my-10 pr-5 pl-3.5">
    <IconNewJourney class="h-10 w-10 mt-1.5 mr-2"/>
    Neue Reise
  </RouterLink>
</template>
