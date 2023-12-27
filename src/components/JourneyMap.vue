<script setup lang="ts">
import {supabase} from "@/lib/supabaseClient";
import {useRoute} from "vue-router";
import L from "leaflet";
import 'leaflet/dist/leaflet.css';
import {onMounted, ref} from "vue";

const map = ref();
const mapContainer = ref();

//uuid is the folder
const uuid = useRoute().params.uuid;
const journeyPlace = ref();

onMounted(() => {
  getMapData()
})

async function getMapData() {
  if (!map.value) {
    setMap()
  }

  await getJourneyLocation();

  await getJourneyLocationCoordinates(journeyPlace.value);

  let activities = await getActivities();

  await handleActivites(activities);

}

function setMap() {
  map.value = L.map(mapContainer.value).setView([48.2083, 16.3731], 2);
  L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
    maxZoom: 19,
    attribution:
        '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
  }).addTo(map.value);
}

async function getJourneyLocation() {
  const {data: journey, error} = await supabase
      .from('journey')
      .select('place')
      .eq('pk_journey_uuid', uuid)

  journeyPlace.value = journey[0].place;
}

async function getJourneyLocationCoordinates(journeyPlace: string) {
  await fetch("https://nominatim.openstreetmap.org/search?q=" + journeyPlace + "&format=geojson").then(function (response) {
    return response.json();
  }).then(function (json) {
    let long = json.features[0].geometry.coordinates[0];
    let lat = json.features[0].geometry.coordinates[1];
    map.value.setView([lat, long], 11)
  })
}

async function getActivities(): Promise<any> {
  const {data: activities, error} = await supabase
      .from('activity')
      .select('pk_activity_uuid, name, address, added_to_calendar')
      .eq('fk_journey_uuid', uuid);

  return activities;
}

async function handleActivites(activities: any) {
  const greenIcon = new L.Icon({
    iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-green.png',
    shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41]
  })

  const redIcon = new L.Icon({
    iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-red.png',
    shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41]
  })

  for (const activity of activities) {
    //let url: string = "https://nominatim.openstreetmap.org/search?street=" + activity.address + "&amenity=" + activity.name + "&format=geojson";
    //let encodedUrl: string = url.replaceAll(" ", "+");

    let url: string = "https://nominatim.openstreetmap.org/search?q=" + activity.name + "+" + journeyPlace.value + "&format=geojson";
    let encodedUrl: string = url.replaceAll(" ", "+");
    console.log(encodedUrl)
    await fetch(encodedUrl).then(function (response) {
      return response.json();
    }).then(function (json) {
      let long = json.features[0].geometry.coordinates[0];
      let lat = json.features[0].geometry.coordinates[1];

      const icon = activity.added_to_calendar ? greenIcon : redIcon;

      L.marker([lat, long], {draggable: false, icon: icon})
          .addTo(map.value)
          .bindTooltip(activity.name)
    })

  }
}

</script>

<template>
  <div class="px-40 mt-10">
    <div class="bg-primary rounded-[58px]">
      <div class="flex flex-row justify-between">
        <h2 class="font-nunito font-semibold text-3xl pl-10 pt-5">Karte</h2>
      </div>
      <div class="px-10 pb-10">
        <div ref="mapContainer" class="rounded-md h-96"></div>
        <p class="font-nunito-sans text-base">
          <span class="">Grüner Aktivitäten hast du bereits deinem Plan hinzugefügt.</span>
          <br>
          <span>Rote Aktivitäten hast du noch nicht hinzugefügt.</span>
        </p>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>
