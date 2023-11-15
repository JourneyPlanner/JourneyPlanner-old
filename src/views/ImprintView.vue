<script setup lang="ts">
import BackButton from "@/components/buttons/BackButton.vue";
import Footer from "@/components/Footer.vue";
</script>

<template>
  <div class="grid grid-cols-2 grid-rows-1 sm:grid-cols-3">
    <h2 class=" font-nunito font-semibold text-xl ml-5 mt-5
              sm:font-bold sm:col-start-2 sm:text-xl md:text-2xl md:text-center">Impressum</h2>

    <div class="grid grid-cols-3 grid-rows-1 px-5">
      <BackButton class="col-start-3 mt-3 xl:col-start-2"/>
    </div>
  </div>
  <div class="ml-5 mt-10 mr-1 sm:ml-20 sm:mr-10 lg:mx-60">
    <p><b>Informationen und Offenlegung gemäß &sect;5 (1) ECG, &sect; 25 MedienG, &sect; 63 GewO und &sect; 14 UGB</b>
    </p>
    <p><b>Webseitenbetreiber:</b> Mattias Burkard</p>
    <p><b>Anschrift:</b> Krüklstraße 3, 2410 Hainburg an der Donau</p>
    <p><b>Kontaktdaten:</b> <br> Telefon: +43 681 20301077 <br> Email: raven.burkard@journeyplanner.io <br></p>

    <p><b>Anwendbare Rechtsvorschrift:</b> www.ris.bka.gv.at <br></p>
    <p><b>Online Streitbeilegung:</b> Verbraucher, welche in Österreich oder in einem sonstigen Vertragsstaat der
      ODR-VO
      niedergelassen sind, haben die Möglichkeit Probleme bezüglich dem entgeltlichen Kauf von Waren oder
      Dienstleistungen
      im Rahmen einer Online-Streitbeilegung (nach OS, AStG) zu lösen. Die Europäische Kommission stellt eine
      Plattform
      hierfür bereit: https://ec.europa.eu/consumers/odr</p>
    <p><b>Urheberrecht:</b> Die Inhalte dieser Webseite unterliegen, soweit dies rechtlich möglich ist, diversen
      Schutzrechten (z.B dem Urheberrecht). Jegliche Verwendung/Verbreitung von bereitgestelltem Material, welche
      urheberrechtlich untersagt ist, bedarf schriftlicher Zustimmung des Webseitenbetreibers.</p>
    <p><b>Haftungsausschluss:</b> Trotz sorgfältiger inhaltlicher Kontrolle übernimmt der Webseitenbetreiber dieser
      Webseite keine Haftung für die Inhalte externer Links. Für den Inhalt der verlinkten Seiten sind ausschließlich
      deren Betreiber verantwortlich. Sollten Sie dennoch auf ausgehende Links aufmerksam werden, welche auf eine
      Webseite
      mit rechtswidriger Tätigkeit/Information verweisen, ersuchen wir um dementsprechenden Hinweis, um diese nach §
      17
      Abs. 2 ECG umgehend zu entfernen.<br>Die Urheberrechte Dritter werden vom Betreiber dieser Webseite mit größter
      Sorgfalt beachtet. Sollten Sie trotzdem auf eine Urheberrechtsverletzung aufmerksam werden, bitten wir um einen
      entsprechenden Hinweis. Bei Bekanntwerden derartiger Rechtsverletzungen werden wir den betroffenen Inhalt
      umgehend
      entfernen.</p>
    <p><b>Blattlinie:</b> Tool für Reiseplanung</p>
    <p class="font-light mt-2">Quelle: <b><a href="https://www.rechtstexte-generator.at/dsgvo-generator-oesterreich/">Datenschutz
      DSGVO
      Generator</a></b> in Kooperation mit <b><a
        href="https://www.ortner-rechtsanwalt.at/rechtsanwalt-fuer-arbeitsrecht/">Rechtsanwalt Arbeitsrecht</a></b>
    </p>
  </div>
  <Footer class="bottom-0 w-full"/>
</template>
