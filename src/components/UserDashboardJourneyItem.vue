<script setup lang="ts">

</script>

<template>
  <div class="bg-primary rounded-[32px] overflow-hidden">
    <div class="font-nunito font-semibold text-3xl">
      <slot name="journey-name"></slot>
    </div>
    <div class="font-nunito text-2xl">
      <slot name="date-range"></slot>
    </div>
  </div>
</template>

<style scoped>

</style>