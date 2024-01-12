<script setup lang="ts">
import IconNewJourney from "@/components/icons/IconNewJourney.vue";
</script>

<template>
  <RouterLink to="/reise/neu" class="bg-call-to-action
  border-4 border-call-to-action rounded-[44px]
  text-text-black font-nunito font-bold sm:font-semibold text-base sm:text-xl lg:text-2xl
  flex justify-around my-20 mt-5 lg:my-10 lg:px-8">
    <IconNewJourney class="h-10 w-8 lg:w-10 mt-1.5 mr-2 fill-text-black"/>
    <span class="mt-3 lg:mt-0 mr-2">Neue Reise</span>
  </RouterLink>
</template>
