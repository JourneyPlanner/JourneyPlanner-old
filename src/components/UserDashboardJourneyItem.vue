<template>
  <div class="bg-primary rounded-[32px] overflow-hidden py-8 my-1 shadow-md hover:bg-secondary">
    <div class="font-nunito font-bold text-2xl text-text-black px-3 overflow-hidden whitespace-nowrap overflow-ellipsis">
      <slot name="journey-name"></slot>
    </div>
    <div class="font-nunito font-medium text-xl pl-3 text-text-black">
      <slot name="date-range"></slot>
    </div>
    <div class="font-nunito text-xl pl-3 text-text-black">
      <slot name="function"></slot>
    </div>
  </div>
</template>
