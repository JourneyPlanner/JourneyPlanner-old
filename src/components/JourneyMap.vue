<script setup>
import 'leaflet/dist/leaflet.css';

import {LMap, LMarker, LTileLayer, LPopup, LTooltip, LIcon} from "@vue-leaflet/vue-leaflet";
import {onMounted, ref} from "vue";
import {useRoute} from "vue-router";
import {supabase} from "@/lib/supabaseClient";

const zoom = ref(2);
const center = ref([48.2083, 16.3731]);
const markers = ref([]);
const notFoundActivities = ref([]);
const uuid = useRoute().params.uuid;
const journeyPlace = ref();

const greenIcon = {
  iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-green.png',
  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41]
};

const redIcon = {
  iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41]
};

onMounted(async () => {
  await getMapData();
});

/**
 * call to the different functions
 */
async function getMapData() {
  await getJourneyLocation();
  await getJourneyLocationCoordinates(journeyPlace.value);
  let activities = await getActivities();
  await handleActivities(activities);
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
      center.value = [lat, long];
      zoom.value = 11;
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
async function handleActivities(activities) {
  for (const activity of activities) {
    let activityName = activity.name;
    let activityAddress = activity.address;
    let activityMapsLink = activity.google_maps_link;
    let url = "https://nominatim.openstreetmap.org/search?q=" + activityAddress + "&format=geojson";

    let encodedUrl = url.replaceAll(" ", "+");

    await fetch(encodedUrl).then(function (response) {
      return response.json();
    }).then(function (json) {
      if (json.features.length !== 0) {
        let long = parseFloat(json.features[0].geometry.coordinates[0]);
        let lat = parseFloat(json.features[0].geometry.coordinates[1]);
        let icon = activity.added_to_calendar ? greenIcon : redIcon;

        markers.value.push({name: activityName, lat_long: [lat, long], icon: icon});
      } else {
        notFoundActivities.value.push({name: activityName, address: activityAddress, maps: activityMapsLink})
      }
    })
  }
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
        <div>
          <div class="rounded-md h-96">
            <l-map ref="map" v-model:zoom="zoom" v-model:center="center" :use-global-leaflet="false">
              <l-tile-layer
                  url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                  layer-type="base"
                  name="OpenStreetMap"
                  attribution="&copy; <a href='https://www.openstreetmap.org/copyright'>OpenStreetMap</a>"
              ></l-tile-layer>

              <l-marker v-for="marker in markers" :lat-lng="marker.lat_long">
                <l-icon :icon-url="marker.icon.iconUrl" :icon-size="marker.icon.iconSize"
                        :icon-anchor="marker.icon.iconAnchor" :shadow-size="marker.icon.shadowSize"
                        :shadow-url="marker.icon.shadowUrl" :popup-anchor="marker.icon.popupAnchor"/>
                <l-popup>{{ marker.name }}</l-popup>
                <l-tooltip>{{ marker.name }}</l-tooltip>
              </l-marker>

            </l-map>
          </div>

          <p class="font-nunito-sans text-base">
            <span class="">Grüne Aktivitäten sind bereits dem Plan hinzugefügt. </span>
            <span>Rote Aktivitäten sind noch nicht im Plan enthalten.</span>
          </p>
          <details class="font-nunito-sans" v-if="notFoundActivities.length > 0">
            <summary class="font-bold">Nicht lokalisierbare Aktivitäten</summary>
            <p>
              Diese Aktivitäten konnten wir leider nicht eindeutig zuordnen. Sie sind daher nicht auf der Karte
              ersichtlich.
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
  </div>
</template>
