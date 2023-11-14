<script setup lang="ts">

</script>

<template >
  <div class="flex flex-col items-center bg-primary rounded-[35px] px-3 pt-5">
    <i>
      <slot name="icon"></slot>
    </i>
    <br>
    <h2 class="font-nunito text-xl text-text-black font-bold -mb-4">
      <slot name="name"></slot>
    </h2>
    <br>
    <p class="font-nunito font-medium text-text-black text-xl text-center pb-6">
      <slot name="position"></slot>
    </p>

  </div>
</template>

<style scoped>

</style>