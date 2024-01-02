<script setup>
import {supabase} from "@/lib/supabaseClient";
import {useRoute} from "vue-router";
import L from "leaflet";
import 'leaflet/dist/leaflet.css';
import {onMounted, ref, watchEffect} from "vue";

const map = ref(null);
const mapContainer = ref(null);
const notFoundActivities = ref([]);
let markerGroup = null;

//uuid is the folder
const uuid = useRoute().params.uuid;
const journeyPlace = ref();

onMounted(async () => {
  await getMapData();
})

/**
 * setMap if not set and then fill with data
 */
async function getMapData() {
  console.log(map.value)
  if (!map.value) {
    await setMap()
    console.log(1)
  }

  if (map.value) {
    markerGroup.clearLayers();

    await getJourneyLocation();
    await getJourneyLocationCoordinates(journeyPlace.value);
    let activities = await getActivities();
    await handleActivites(activities);
  }

}

/**
 * set up leaflet map
 */
async function setMap() {
  map.value = L.map(mapContainer.value).setView([48.2083, 16.3731], 2);
  L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
    maxZoom: 19,
    attribution:
        '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
  }).addTo(map.value);

  markerGroup = L.layerGroup().addTo(map.value);

  //map.value.on("zoomend", updateMarkerPositions);
  //map.value.on("moveend", updateMarkerPositions);
}

/**
 * on scroll zoom update marker posittions (to kinda fix a bug)
 */
function updateMarkerPositions() {

    markerGroup.eachLayer((marker) => {
      const latLng = marker.getLatLng();
      const newLatLng = map.value.latLngToLayerPoint(latLng);
      marker.setLatLng(map.value.layerPointToLatLng(newLatLng));
    });

}


/**
 * get location of journey
 */
async function getJourneyLocation() {
  const {data: journey, error} = await supabase
      .from('journey')
      .select('place')
      .eq('pk_journey_uuid', uuid)

  journeyPlace.value = journey[0].place;
}

/**
 * get coordinates of journey location
 * @param journeyPlace in database stored location
 */
async function getJourneyLocationCoordinates(journeyPlace) {
  await fetch("https://nominatim.openstreetmap.org/search?q=" + journeyPlace + "&format=geojson").then(function (response) {
    return response.json();
  }).then(function (json) {
    if (json.features.length !== 0) {
      let long = json.features[0].geometry.coordinates[0];
      let lat = json.features[0].geometry.coordinates[1];
      map.value.setView([lat, long], 11);
    } else {
      //console.log('error finding place: ' + journeyPlace)
    }
  })
}

/**
 * get all activities from current journey
 */
async function getActivities() {
  const {data: activities, error} = await supabase
      .from('activity')
      .select('pk_activity_uuid, name, address, google_maps_link, added_to_calendar')
      .eq('fk_journey_uuid', uuid);
  return activities;
}

/**
 * foreach activity fetch location and display marker in map
 * @param activities all activities from a journey
 */
async function handleActivites(activities) {
  const notFoundArray = [];
  const greenIcon = new L.Icon({
    iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-green.png',
    shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41]
  })

  const redIcon = new L.Icon({
    iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
    shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41]
  })

  for (const activity of activities) {
    let activityName = activity.name;
    let activityAddress = activity.address;
    let activityMapsLink = activity.google_maps_link;
    //let url: string = "https://nominatim.openstreetmap.org/search?q=" + activityName + "+" + journeyPlace.value + "&format=geojson";
    let url = "https://nominatim.openstreetmap.org/search?q=" + activityAddress + "&format=geojson";

    let encodedUrl = url.replaceAll(" ", "+");

    //console.log(encodedUrl)

    await fetch(encodedUrl).then(function (response) {
      return response.json();
    }).then(function (json) {
      if (json.features.length !== 0) {
        let long = parseFloat(json.features[0].geometry.coordinates[0]);
        let lat = parseFloat(json.features[0].geometry.coordinates[1]);

        const icon = activity.added_to_calendar ? greenIcon : redIcon;

        L.marker([lat, long], {draggable: false, icon: icon})
            .addTo(markerGroup)
            .bindTooltip(activityName)
        //console.log('added marker: ' + activityName + ' at ' + lat + ' ' + long);
      } else {
        //console.log(activityName + " can't be found");

        notFoundArray.push({name: activityName, address: activityAddress, maps: activityMapsLink})
      }
    })
  }
  notFoundActivities.value = notFoundArray;
}

</script>

<template>
  <div class="w-[100%] flex flex-col items-center justify-center mt-8">
    <div class="w-[85%] rounded-2xl bg-primary p-6">
      <div class="grid grid-cols-6 pb-3 justify-center items-center">
        <h2 class="col-span-2 font-nunito text-2xl text-text-black font-semibold">Karte</h2>
         <button @click="getMapData"
                  class="font-nunito text-base text-text-black font-bold bg-background border-4 border-call-to-action rounded-[38px] px-6 py-1 shadow-md hover:opacity-80 mb-2 col-start-6">
            Aktualisieren
          </button>

      </div>
      <div>
        <div ref="mapContainer" class="rounded-md h-96"></div>
        <p class="font-nunito-sans text-base">
          <span class="">Grüne Aktivitäten sind bereits dem Plan hinzugefügt. </span>
          <span>Rote Aktivitäten sind noch nicht im Plan enthalten.</span>
        </p>
        <details class="font-nunito-sans" v-if="notFoundActivities">
          <summary class="font-bold">Nicht lokalisierbare Aktivitäten</summary>
          <p>
            Diese Aktivitäten konnten wir leider nicht eindeutig zuordnen. Sie sind daher nicht auf der Karte ersichtlich.
          </p>
          <table class="table-auto border-collapse border border-b-placeholder-gray">
            <tr>
              <th class="table-auto border-collapse border border-b-placeholder-gray bg-disabled-input">Aktivität</th>
              <th class="table-auto border-collapse border border-b-placeholder-gray bg-disabled-input">Adresse</th>
              <th class="table-auto border-collapse border border-b-placeholder-gray px-2 bg-disabled-input">
                Google-Maps
              </th>
            </tr>
            <tr v-for="activity in notFoundActivities">
              <td class="table-auto border-collapse border border-b-placeholder-gray p-1.5 bg-background">
                {{ activity.name }}
              </td>
              <td class="table-auto border-collapse border border-b-placeholder-gray p-1.5 bg-background">
                {{ activity.address }}
              </td>
              <td class="table-auto border-collapse border border-b-placeholder-gray p-1.5 underline bg-background"><a
                  v-if="activity.maps" target="_blank" :href="`${activity.maps}`">Link</a></td>
            </tr>
          </table>
        </details>
        <p class="font-nunito-sans text-base">Die Karte basiert auf Eingaben bei der Reiseerstellung & neuen
          Aktivitäten. Es kann daher zu falschen Darstellungen kommen.</p>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>
