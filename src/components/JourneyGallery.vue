<script lang="ts" setup>

//@ts-ignore
import VueGallery from 'vue-gallery';
import {ref} from "vue";
//@ts-ignore
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
    const image_promises: any = [];
    const video_promises: any = [];
    const files_promises: any = [];

    files.forEach((file: any) => {
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

    const image_links_array: any = [];
    let image_links = await Promise.all(image_promises);
    image_links.forEach((file) => {
      image_links_array.push(file.data.signedUrl);
    });

    const video_links_array: any = [];
    let video_links = await Promise.all(video_promises);
    video_links.forEach((file) => {
      video_links_array.push(file.data.signedUrl);
    });

    const file_contents: any = [];
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
  <div class="px-10 pb-10">
    <h3 class="font-nunito-sans text-xl font-bold text-text-black">Bilder | Videos | Texte</h3>
    <div class="bg-background rounded-md">
      <div v-if="images.length === 0 && videos.length === 0 && texts.length === 0" class="flex justify-center pb-4">
        <p class="font-nunito-sans text-base text-text-black pt-4">Noch keine Erinnerungen vorhanden</p>
      </div>

      <div v-else class="grid grid-cols-5 gap-2 pt-2 pb-2 px-2">

        <VueGallery v-if="images.length > 0" :images="images" :index="index" @close="index = null"/>
        <div
            v-for="(image, imageIndex) in images"
            v-if="images.length > 0"
            :key="`image-${imageIndex}`"
            :style="{ backgroundImage: 'url(' + image + ')', backgroundSize: 'cover' }"
            class="image relative bg-cover bg-center rounded-md w-48 h-48 shadow-md"
            @click="index = imageIndex"
        ></div>

        <div v-for="video in videos" :key="`video-${video}`">
          <iframe :src="video" class="w-48 h-48 rounded-md bg-center shadow-md"></iframe>
        </div>

        <div v-for="file in texts" :key="`text-${file}`">
          <p class="w-48 h-48 rounded-md bg-center shadow-md overflow-hidden no overflow-ellipsis font-nunito-sans p-2 mt-2">
            {{ file }}</p>
        </div>
      </div>
    </div>
    <p class="font-nunito-sans text-text-black">Alle Bilder, Videos, die kompletten Texte und andere Dateien können ganz
      oben heruntergeladen werden.</p>
  </div>
</template>
