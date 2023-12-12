<script setup lang="ts">
import JourneyUpload from "@/components/JourneyUpload.vue";
import IconDownload from "@/components/icons/IconDownload.vue";
</script>

<template>
  <div class="px-40">
    <div class="bg-primary rounded-[58px]">
      <div class="flex flex-row justify-between">
        <h2 class="font-nunito font-semibold text-2xl pl-10 pt-2">Erinnerungen</h2>
        <IconDownload class="p-3 mr-2"/>
      </div>
      <JourneyUpload/>
    </div>
  </div>
</template>

<style scoped>

</style>
