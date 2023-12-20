<script lang="ts" setup>
import JourneyUpload from "@/components/JourneyUpload.vue";
import IconDownload from "@/components/icons/IconDownload.vue";
import Toast from 'primevue/toast';
import {useToast} from "primevue/usetoast";
import {useRoute} from "vue-router";
import JSZip from "jszip";
//@ts-ignore
import {supabase} from "@/lib/supabaseClient";
import JourneyEditor from "@/components/JourneyEditor.vue";
import {defineAsyncComponent} from "vue";

const JourneyGallery = defineAsyncComponent(() =>
    import('@/components/JourneyGallery.vue')
);


const toast = useToast();
//uuid is the folder
const uuid = useRoute().params.uuid;

/**
 * generate zip download of all memories
 */
async function download() {
  const {data: files, error} = await supabase.storage
      .from('upload')
      .list(uuid);

  if (error) {
    toast.add({
      severity: 'error',
      summary: 'Fehler beim Herunterladen',
      detail: `Es gab einen Fehler beim Herunterladen der Dateien`,
      life: 3000
    });
  } else {
    if (files.length) {
      toast.add({
        severity: 'info',
        summary: 'Starte Download',
        detail: `Der Download wird gestartet. Bitte warte einen Moment.`,
        life: 3000
      });
      const {data: journey, error} = await supabase
          .from('journey')
          .select(`name`).eq('pk_journey_uuid', uuid);

      const promises: any = [];
      const zip = new JSZip();

      files.forEach((file: any) => {
        if (file.name !== ".emptyFolderPlaceholder") {
          promises.push(
              supabase.storage.from('upload').createSignedUrl(`${uuid}/${file.name}`, 3600)
                  .then(async (signedUrlResponse: any) => {
                    const fileResponse = await fetch(signedUrlResponse.data.signedUrl);
                    zip.file(file.name, await fileResponse.blob());
                  })
          );
        }
      });

      Promise.all(promises)
          .then(() => {
            zip.generateAsync({type: 'blob'})
                .then((zipBlob) => {

                  const downloadUrl = URL.createObjectURL(zipBlob);
                  const currentDate = new Date();
                  const a = document.createElement('a');
                  a.href = downloadUrl;
                  a.download = `${journey[0].name}_Erinnerungen_${currentDate.getDate()}_${currentDate.getMonth() + 1}_${currentDate.getFullYear()}.zip`;
                  a.click();
                })
          });

    } else {
      toast.add({
        severity: 'info',
        summary: 'Keine Erinnerungen vorhanden',
        detail: `Es gibt noch keine Erinnerungen die heruntergeladen werden können.`,
        life: 3000
      });
    }
  }
}

</script>

<template>
  <Toast/>
  <div class="px-40 mt-10">
    <div class="bg-primary rounded-[58px]">
      <div class="flex flex-row justify-between">
        <h2 class="font-nunito font-semibold text-3xl pl-10 pt-5">Erinnerungen</h2>
        <button v-tooltip.top="'Alle Medien herunterladen'">
          <IconDownload class="p-3 mr-8 hover:opacity-80" @click="download"/>
        </button>
      </div>
      <JourneyEditor/>
      <JourneyUpload/>
      <Suspense>
        <template #default>
          <JourneyGallery/>
        </template>
        <template #fallback>
          <div class="flex text-center justify-center">
            <p class="text-3xl font-medium font-nunito text-text-black">Lade...</p>
          </div>
        </template>
      </Suspense>
    </div>
  </div>
</template>
