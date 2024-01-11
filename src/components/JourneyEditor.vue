<script lang="ts" setup>
import Toast from 'primevue/toast';
import {useToast} from "primevue/usetoast";
//@ts-ignore
import {supabase} from "@/lib/supabaseClient";
import {ref} from "vue";
import {useRoute} from "vue-router";

const toast = useToast();
const editorContent = ref("");
const editorTitle = ref("");
//uuid is the folder
const uuid = useRoute().params.uuid;

/**
 * save editor content to supabase storage bucket
 */
async function saveEditor() {
  const content = editorContent.value;
  if (content.trim() !== '') {
    const currentDate = new Date();
    const formattedTime = `${currentDate.getHours()}_${currentDate.getMinutes()}_${currentDate.getSeconds()}`;
    const formattedDate = `${currentDate.getDate()}_${currentDate.getMonth() + 1}_${currentDate.getFullYear()}`;

    let storage_name;
    const title: string = editorTitle.value;

    if (title.trim() !== '') {
      storage_name = editorTitle.value.replace(' ', '_');
      storage_name = storage_name.replace(/[^a-zA-Z0-9_-]/g, '_');
    } else {
      storage_name = "neues_dokument";
    }

    const {
      data,
      error
    } = await supabase.storage.from('upload').upload(`${uuid}/${storage_name}_${formattedDate}_${formattedTime}.txt`, editorContent.value);

    if (error) {
      toast.add({
        severity: 'error',
        summary: 'Fehler beim Speichern',
        detail: 'Es gab einen Fehler beim Speichern deiner Datei',
        life: 3000
      });
    } else {
      toast.add({
        severity: 'success',
        summary: 'Gespeichert',
        detail: 'Deine Datei wurde erfolgreich gespeichert',
        life: 3000
      });
      editorTitle.value = "";
      editorContent.value = "";
    }
  } else {
    toast.add({
      severity: 'info',
      summary: 'Schreibe zuerst etwas',
      detail: 'Schreibe zuerst etwas um dann deinen Text zu speichern',
      life: 3000
    });
  }
}
</script>

<template>
  <Toast/>
  <div>
    <h3 class="font-nunito-sans text-xl font-bold text-text-black">Neuen Text schreiben</h3>
    <div class="flex flex-row justify-between">
      <div>
        <label class="font-nunito text-xl text-text-black font-medium" for="editorTitle">Titel:</label>
        <input id="editorTitle" v-model="editorTitle"
               class="rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action pl-1.5 py-1.5 ml-3 mb-2 pr-15"
               placeholder="Neues Dokument"
               type="text">
        <span class="font-nunito-sans text-text-black">.txt</span>
      </div>
      <button :disabled="!editorContent.trim()"
              class="font-nunito text-base font-bold bg-call-to-action rounded-[38px] px-6 py-1 shadow-md disabled:opacity-80 hover:opacity-80 mb-2"
              @click="saveEditor" v-tooltip.bottom="{
               value: 'Text speichern',
                 style:{
                   width: '30vw'
                 }}">
        Speichern
      </button>
    </div>
    <textarea v-model="editorContent"
              class="border w-full h-36 rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action p-1.5"
              placeholder="Schreibe hier deinen Text. Was hast du erlebt? Was möchtest du festhalten?"></textarea>
    <span
        class="font-nunito-sans text-base text-text-black ml-0.5">Umlaute und Soderzeichen im Titel werden ersetzt</span>
  </div>
</template>
