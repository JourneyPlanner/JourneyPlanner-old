<script setup>
import FileUpload from 'primevue/fileupload';
import Toast from 'primevue/toast';
import {useToast} from "primevue/usetoast";
import {useRoute} from "vue-router";
import {supabase} from "@/lib/supabaseClient";

const toast = useToast();
const uuid = useRoute().params.uuid;

/**
 * upload all files in the upload box to supabase storage bucket
 * @param event
 * @returns {Promise<void>}
 */
async function onUpload (event) {
  const files = event.files;
  for (let i = 0; i < files.length; i++) {
    const file = files[i];
    const file_name_split = file.name.split(".");
    const storage_name = file_name_split[0].replace(/[^a-zA-Z0-9_-]/g, '') + '.' + file_name_split[1];

    toast.add({severity: 'info', summary: 'In Progress', detail: `${storage_name} wird hochgeladen...`, life: 1000});

    const {data, error} = await supabase.storage
        .from('upload')
        .upload(`${uuid}/${storage_name}`, file);

    if (error) {
      toast.add({severity: 'error', summary: 'Fehler', detail: `Fehler beim hochladen von ${storage_name}`, life: 3000});
    } else {
      toast.add({severity: 'success', summary: 'Hochgeladen', detail: `${storage_name} wurde erfolgreich hochgeladen`, life: 3000});
    }
  }
}
</script>

<template>
  <div class="">
    <Toast/>
    <FileUpload @uploader="onUpload($event)" :custom-upload="true" :multiple="true" :mode="'advanced'">

      <template #empty>
        <p>Drag and drop files to here to upload.</p>
      </template>
    </FileUpload>
  </div>
</template>
