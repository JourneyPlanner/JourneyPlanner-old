<script setup lang="ts">

import LoginButton from "@/components/buttons/LoginButton.vue";
import RegisterButton from "@/components/buttons/RegisterButton.vue";
</script>

<template>

  <div class="grid grid-cols-3 grid-rows-1 gap-5 mt-3 sticky top-0.5">
    <div class="col-start-2 bg-call-to-action
    text-text-black font-nunito-sans font-bold xl:text-xl sm:text-base md:text-base
    my-3 rounded-[68px] py-2 flex justify-evenly mx-8 shadow-md">
      <a href="#start" class="hover:opacity-80 hover:underline pt-0.5">Start</a>
      <a href="#functions" class="hover:opacity-80 hover:underline pt-0.5">Funktionen</a>
      <a href="#team" class="hover:opacity-80 hover:underline pt-0.5">Team</a>
    </div>

    <div class="col-start-3 flex ">
      <div class="grid grid-cols-3 grid-rows-1 gap-2 mt-3 ">
        <div class="col-start-2 row-start-1">
          <LoginButton />
        </div>
        <div class="col-start-3">
          <RegisterButton class="px-2"/>
        </div>
      </div>
    </div>
  </div>

</template>

<style scoped>

</style>
