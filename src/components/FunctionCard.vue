<template >
  <div class="flex flex-col items-center bg-primary md:bg-secondary lg:bg-primary rounded-[46px] pt-6 mt-3 p-2 pb-3 justify-between mr-5 lg:mx-5 shadow-md"> <!-- mx-5 md:mx-2 lg:mx-5 -->
    <i>
      <slot name="icon"></slot>
    </i>
    <br>
    <h2 class="font-nunito text-xl lg:text-3xl text-text-black font-bold -mb-6 -mt-4">
      <slot name="subheading"></slot>
    </h2>
    <br>
    <p class="font-nunito-sans font-medium lg:font-semibold text-text-black text-base lg:text-xl px-2 lg:px-12 mt-1 mb-4 text-center">
      <slot name="text"></slot>
    </p>
  </div>
</template>
