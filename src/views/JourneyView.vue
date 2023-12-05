<script setup lang="ts">
import HomeMarkerIcon from "../components/icons/IconHomeMarker.vue";
import Footer from "@/components/Footer.vue";
import {defineAsyncComponent, ref} from "vue";
//import JourneyMedia from "@/components/JourneyMedia.vue";

const AsyncDashboard = defineAsyncComponent(() =>
    import('@/components/AsyncJourney.vue')
);

</script>

<template>
  <div class="relative">
    <div class="bg-background flex flex-col min-h-screen">
      <Suspense>
        <template #default>
          <AsyncDashboard/>
        </template>
        <template #fallback>
          <div class="flex text-center justify-center">
            <p class="text-3xl font-medium font-nunito text-text-black">Lade...</p>
          </div>
        </template>
      </Suspense>
      <JourneyMedia/>
      <Footer class="mt-auto"/>
    </div>
  </div>
</template>
