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
  <div class="absolute overflow-x-hidden md:-top-24 xl:-top-36 md:right-0 ">
    <VespaIllustration/>
  </div>
  <div class="relative">
    <div id="start"/>
    <NavBar class="sticky top-0.5"/>

    <div class="ml-16 mt-10">
      <h1 class="font-nunito text-4xl text-text-black font-bold">
        JourneyPlanner
      </h1>
      <h2 class="font-nunito text-2xl text-text-black font-semibold">
        Reiseplannung leicht gemacht
      </h2>
      <p class="font-nunito-sans text-xl text-text-black  w-3/6 flex flex-wrap mt-3">
        Deine ultimative Plattform zur mühelosen Organisation von unvergesslichen Abenteuern!
        <br>
        Gestalte deine Reise, teile deinen Plan, und geht gemeinsam auf Entdeckungsreise.
        <br>
        Bereit für dein nächstes Abenteuer?
      </p>
      <div class="grid grid-cols-2 grid-rows-1 gap-4 w-1/4 mt-4 ">
        <div class="mr-5">
          <LoginButton/>
        </div>
        <div>
          <RegisterButton/>
        </div>
      </div>
    </div>
    <h1 id="functions" class="mb-56 mt-36"/>
    <h1 class="font-nunito font-bold text-3xl text-text-black ml-16 mt-20">
      Funktionen
    </h1>
    <div class="grid grid-cols-3 grid-rows-1 gap-12">

      <FunctionCard class="ml-20">
        <template #icon>
          <IconCalender/>
        </template>
        <template #subheading>
          Planen
        </template>
        <template #text>
          Erstelle deine nächste Reise,
          füge Aktivitäten
          hinzu & mach dir deinen eigenen Plan
        </template>
      </FunctionCard>

      <FunctionCard class="mx-10">
        <template #icon>
          <IconShare/>
        </template>
        <template #subheading>
          Teilen
        </template>
        <template #text>
          Füge Freunde hinzu, mach sie zu Reiseleitern & plant eure Reise gemeinsam
        </template>
      </FunctionCard>

      <FunctionCard class="mr-20">
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
    <h1 id="team" class="font-nunito font-bold text-3xl text-text-black ml-16 mt-24">
      Über das Team
    </h1>

    <div class="grid grid-cols-4 grid-rows-1 mb-24 mt-4 ">

      <MemberCard class="ml-16 mr-4">
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

      <MemberCard class="mx-8 ml-12">
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

      <MemberCard class="mx-8 mr-12">
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

      <MemberCard class="mr-16 ml-4">
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
    <Footer/>

  </div>
</template>

<style scoped>
</style>
