<script setup>

import VueGallery from 'vue-gallery';
import {ref} from "vue";
import {supabase} from "@/lib/supabaseClient";
import Toast from "primevue/toast";
import {useToast} from "primevue/usetoast";
import {useRoute} from "vue-router";

const toast = useToast();
const images = ref([]);
const index = ref();

const texts = ref([]);
const videos = ref([]);

//uuid is the folder
const uuid = useRoute().params.uuid;

await fetchMedia();

/**
 * fetch all media from bucket, handle file type and generate supabase links
 */
async function fetchMedia() {
  const {data: files, error} = await supabase.storage
      .from('upload')
      .list(uuid);

  if (error) {
    toast.add({
      severity: 'error',
      summary: 'Fehler beim Laden der Galerie',
      detail: `Es gab einen Fehler beim Laden der Galerie`,
      life: 3000
    });
  } else {
    const image_promises = [];
    const video_promises = [];
    const files_promises = [];

    files.forEach((file) => {
      if (file.name != '.emptyFolderPlaceholder') {
        if (file.metadata.mimetype.startsWith('image/')) {
          image_promises.push(
              supabase.storage.from('upload').createSignedUrl(`${uuid}/${file.name}`, 3600)
          );
        } else if (file.metadata.mimetype.startsWith('video/')) {
          video_promises.push(
              supabase.storage.from('upload').createSignedUrl(`${uuid}/${file.name}`, 3600)
          );
        } else if (file.metadata.mimetype.startsWith('text/')) {
          files_promises.push(supabase.storage.from('upload').createSignedUrl(`${uuid}/${file.name}`, 3600))
        }
      }
    });

    const image_links_array = [];
    let image_links = await Promise.all(image_promises);
    image_links.forEach((file) => {
      image_links_array.push(file.data.signedUrl);
    });

    const video_links_array = [];
    let video_links = await Promise.all(video_promises);
    video_links.forEach((file) => {
      video_links_array.push(file.data.signedUrl);
    });

    const file_contents = [];
    let file_links = await Promise.all(files_promises);
    for (const file of file_links) {
      const response = await fetch(file.data.signedUrl);
      const content = await response.text();
      file_contents.push(content);
    }

    images.value = image_links_array;
    videos.value = video_links_array;
    texts.value = file_contents;

  }
}
</script>

<template>
  <Toast/>
  <div class="my-8">
    <div class="grid grid-cols-6 pb-3 justify-center items-center">
      <h3 class="font-nunito-sans text-xl font-bold text-text-black col-span-2">Bilder | Videos | Texte</h3>
      <button @click="fetchMedia"
              class="font-nunito text-base text-text-black font-bold bg-background border-4 border-call-to-action rounded-[38px] px-6 py-1 shadow-md hover:opacity-80 mb-2 col-start-6" v-tooltip.bottom="{
               value: 'Erinnerungen aktualisieren',
                 style:{
                   width: '30vw'
                 }}">
        Aktualisieren
      </button>
    </div>

    <div class="bg-background rounded-md">
      <div v-if="images.length === 0 && videos.length === 0 && texts.length === 0" class="flex justify-center pb-4">
        <p class="font-nunito-sans text-base text-text-black pt-4">Noch keine Erinnerungen vorhanden</p>
      </div>

      <div v-else class="grid grid-cols-7 gap-2 pt-2 pb-2 px-2">
        <VueGallery v-if="images.length > 0" :images="images" :index="index" @close="index = null"/>
        <div
            v-for="(image, imageIndex) in images"
            v-if="images.length > 0"
            :key="`image-${imageIndex}`"
            :style="{ backgroundImage: 'url(' + image + ')', backgroundSize: 'cover' }"
            class="image relative bg-cover bg-center rounded-md w-40 h-40 shadow-md hover:shadow-xl cursor-zoom-in"
            @click="index = imageIndex"
        ></div>

        <div v-for="video in videos" :key="`video-${video}`">
          <iframe :src="video" class="w-40 h-40 rounded-md bg-center shadow-md"></iframe>
        </div>

        <div v-for="file in texts" :key="`text-${file}`">
          <p class="w-40 h-40 rounded-md bg-center shadow-md overflow-hidden no overflow-ellipsis font-nunito-sans p-2 mt-2">
            {{ file }}</p>
        </div>
      </div>
    </div>
  </div>
</template>
