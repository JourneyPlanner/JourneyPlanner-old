<script lang="ts" setup>
import FileUpload from 'primevue/fileupload';
import Toast from 'primevue/toast';
import {useToast} from "primevue/usetoast";
import {useRoute} from "vue-router";
//@ts-ignore
import {supabase} from "@/lib/supabaseClient";

const toast = useToast();
const uuid = useRoute().params.uuid;

/**
 * upload all files in the upload box to supabase storage bucket
 * @param event
 * @returns {Promise<void>}
 */
async function onUpload(event: any) {
  const files = event.files;
  for (let i = 0; i < files.length; i++) {
    const file = files[i];
    const file_name_split = file.name.split(".");
    const storage_name = file_name_split[0].replace(/[^a-zA-Z0-9_-]/g, '') + '.' + file_name_split[1];

    if (file.size > 50000000) {
      toast.add({severity: 'error', summary: 'Fehler', detail: `${storage_name} ist zu groß`, life: 3000});
      continue;
    }

    toast.add({
      severity: 'info',
      summary: 'In Progress',
      detail: `${storage_name} wird hochgeladen. Dies kann einen Moment dauern.`,
      life: 1500
    });

    const {data, error} = await supabase.storage
        .from('upload')
        .upload(`${uuid}/${storage_name}`, file);

    if (error) {
      toast.add({
        severity: 'error',
        summary: 'Fehler',
        detail: `Fehler beim Hochladen von ${storage_name}`,
        life: 3000
      });
    } else {
      toast.add({
        severity: 'success',
        summary: 'Hochgeladen',
        detail: `${storage_name} wurde erfolgreich hochgeladen`,
        life: 3000
      });
    }
  }
}
</script>

<template>
  <div class="mt-8">
    <Toast/>
    <h3 class="font-nunito-sans text-xl font-bold text-text-black">Hochladen</h3>
    <FileUpload :custom-upload="true" :mode="'advanced'" :multiple="true" @uploader="onUpload($event)">

      <template #empty>
        <p class="pb-20 justify-center text-center font-nunito text-xl">
          Fotos, Videos, Dokumente mit Drag'n'Drop oder per Choose Button hinzufügen.
          <br>
          Max. 50MB pro Datei
        </p>
      </template>
    </FileUpload>
  </div>
</template>
