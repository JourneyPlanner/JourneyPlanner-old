<script setup lang="ts">
import VespaIllustration from "../components/illustrations/VespaIllustration.vue";
import NavBar from "../components/NavBar.vue";
import FunctionCard from "../components/FunctionCard.vue";
import IconCalender from "../components/icons/IconCalender.vue";
import IconShare from "../components/icons/IconShare.vue";
import IconExperience from "../components/icons/IconExperience.vue";
import MemberCard from "../components/MemberCard.vue";

import Raven from "../components/pictures/RavenPic.vue";
import Severin from "../components/pictures/SeverinPic.vue";
import Roman from "../components/pictures/RomanPic.vue";
import Stefi from "../components/pictures/StefiPic.vue";
import LoginButton from "../components/buttons/LoginButton.vue";
import RegisterButton from "../components/buttons/RegisterButton.vue";
import Footer from "../components/Footer.vue";
</script>

<template>
  <div class="absolute overflow-x-hidden md:-top-24 lg:-top-36 md:right-0 hidden lg:block">
    <VespaIllustration/>
  </div>
  <div class="relative">
    <div id="start"/>
    <NavBar class="lg:sticky lg:top-0.5"/>

    <div class="lg:ml-16 lg:mt-10">
      <div class="bg-primary lg:bg-opacity-0 rounded-b-3xl lg:rounded-none shadow-md lg:shadow-none -mt-3 lg:ml-6">
        <h1 class="font-nunito text-2xl text-center lg:text-left lg:text-4xl lg:text-text-black font-black lg:font-bold break-words">
          JourneyPlanner
        </h1>
        <h2 class="font-nunito text-xl lg:text-2xl text-center lg:text-left text-text-black font-bold lg:font-semibold">
          Reiseplanung leicht gemacht!
        </h2>
      </div>
      <p class="font-nunito-sans text-base lg:text-xl text-text-black md:w-3/6 flex flex-wrap mt-6 lg:mt-3 mr-5 text-left ml-6">
        Deine ultimative Plattform zur mühelosen Organisation von unvergesslichen Abenteuern!
        <br>
        Gestalte deine Reise, teile deinen Plan und gehe gemeinsam auf Entdeckungs
        <wbr>
        reise.
        <br><span class="text-left">
        Bereit für dein nächstes Abenteuer?
        </span>
      </p>
      <div class="grid grid-cols-2 grid-rows-1 gap-4 sm:w-1/4 mt-4 mr-5 ml-6">
        <div>
          <LoginButton/>
        </div>
        <div>
          <RegisterButton/>
        </div>
      </div>

    <div id="functions" class="lg:grid lg:grid-cols-3 lg:gap-12 mt-10 lg:mt-40 mx-5">
      <h1 class="font-nunito font-bold text-2xl lg:text-3xl text-text-black text-center lg:text-left mt-5 lg:mt-20">
        Funktionen
      </h1>
    </div>
    <div class="grid grid-cols-1 lg:grid-cols-3 grid-rows-3 lg:grid-rows-1 gap-1 lg:gap-8 px-6 lg:px-0 lg:pr-16">

      <FunctionCard class="row-start-1">
        <template #icon>
          <IconCalender/>
        </template>
        <template #subheading>
          Planen
        </template>
        <template #text>
          Erstelle deine nächste Reise,
          füge Aktivitäten
          hinzu & mache dir deinen eigenen Plan
        </template>
      </FunctionCard>

      <FunctionCard class="row-start-2 lg:row-start-1">
        <template #icon>
          <IconShare/>
        </template>
        <template #subheading>
          Teilen
        </template>
        <template #text>
          Füge Freunde hinzu, mache sie zu Reiseleitern & plant eure Reise gemeinsam
        </template>
      </FunctionCard>

      <FunctionCard class="row-start-3 lg:row-start-1">
        <template #icon>
          <IconExperience/>
        </template>
        <template #subheading>
          Erleben
        </template>
        <template #text>
          Genießt eure geplante Reise, erlebt Abenteuer und ladet Erinnerungen hoch
        </template>
      </FunctionCard>
    </div>
    <div id="team" class="lg:grid lg:grid-cols-3 lg:gap-12 lg:mt-10 mx-5">
      <h1 class="font-nunito font-bold text-2xl lg:text-3xl text-text-black text-center lg:text-left mt-5">
        Das Team
      </h1>
    </div>

    <div class="grid grid-cols-2 lg:grid-cols-4 grid-rows-2 lg:grid-rows-1 gap-5 lg:gap-4 px-5 lg:pl-6 lg:pr-20">

      <MemberCard class="">
        <template #icon>
          <Raven/>
        </template>
        <template #name>
          Raven Burkard
        </template>
        <template #position>
          Projektleiterin
        </template>
      </MemberCard>

      <MemberCard class="">
        <template #icon>
          <Roman/>
        </template>
        <template #name>
          Roman Krebs
        </template>
        <template #position>
          Stv. Projektleiter
        </template>
      </MemberCard>

      <MemberCard class="">
        <template #icon>
          <Stefi/>
        </template>
        <template #name>
          Stefania Manastirska
        </template>
        <template #position>
          Projektmitarbeiterin
        </template>
      </MemberCard>

      <MemberCard class="">
        <template #icon>
          <Severin/>
        </template>
        <template #name>
          Severin Rosner
        </template>
        <template #position>
          Projektmitarbeiter
        </template>
      </MemberCard>
    </div>
    </div>
    <Footer class="lg:pt-10"/>

  </div>
</template>

<style scoped>
</style>
