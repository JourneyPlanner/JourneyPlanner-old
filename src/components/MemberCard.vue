<template>
  <div class="flex flex-col items-center bg-primary md:bg-secondary lg:bg-primary rounded-[35px] px-3 pt-6 mt-3 pb-6 shadow-md">
    <i>
      <slot name="icon"></slot>
    </i>
    <br>
    <h2 class="font-nunito text-base text-center lg:text-xl text-text-black font-bold -mt-2 lg:-mt-0 -mb-6 lg:-mb-4">
      <slot name="name"></slot>
    </h2>
    <br>
    <p class="font-nunito font-medium text-text-black text-base lg:text-xl text-center">
      <slot name="position"></slot>
    </p>
  </div>
</template>
