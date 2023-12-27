<script setup lang="ts">
import Footer from "@/components/Footer.vue";
import {defineAsyncComponent} from "vue";
import JourneyMemories from "@/components/JourneyMemories.vue";
const JourneyMap = defineAsyncComponent(() =>
    import('@/components/JourneyMap.vue')
);

const AsyncJourney = defineAsyncComponent(() =>
    import('@/components/AsyncJourney.vue')
);

const AsyncCalendar = defineAsyncComponent( () =>
    import('@/components/Calender.vue')
);

</script>

<template>
  <div class="relative">
    <div class="bg-background flex flex-col min-h-screen">
      <Suspense>
        <template #default>
          <AsyncJourney/>
        </template>
        <template #fallback>
          <div class="flex text-center justify-center">
            <p class="text-3xl font-medium font-nunito text-text-black">Lade...</p>
          </div>
        </template>
      </Suspense>
      <Suspense>
        <template #default>
          <AsyncCalendar/>
        </template>
        <template #fallback>
          <div class="flex text-center justify-center">
            <p class="text-3xl font-medium font-nunito text-text-black">Lade...</p>
          </div>
        </template>
      </Suspense>
      <Suspense>
        <template #default>
          <JourneyMap/>
        </template>
        <template #fallback>
          <div class="flex text-center justify-center">
            <p class="text-3xl font-medium font-nunito text-text-black">Lade Karte...</p>
          </div>
        </template>
      </Suspense>
      <JourneyMemories/>
      <Footer class="mt-auto"/>
    </div>
  </div>
</template>
