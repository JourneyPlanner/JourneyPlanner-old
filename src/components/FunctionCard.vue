<template >
  <div class="flex flex-col items-center bg-primary rounded-[46px] pt-6 mt-6 p-2 pb-3 justify-between">
    <i>
      <slot name="icon"></slot>
    </i>
    <br>
    <h2 class="font-nunito text-3xl text-text-black font-bold -mb-6 -mt-4 ">
      <slot name="subheading"></slot>
    </h2>
    <br>
    <p class="font-nunito-sans font-semibold text-text-black text-xl px-2 lg:px-12 mt-1 mb-4 text-center">
      <slot name="text"></slot>
    </p>
  </div>
</template>
