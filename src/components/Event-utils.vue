<script>
import {supabase} from "@/lib/supabaseClient";
import {ref} from "vue";
import {useRoute} from "vue-router";

let eventGuid = 0
let todayStr = new Date().toISOString().replace(/T.*$/, '') // YYYY-MM-DD of today

export const INITIAL_EVENT = [
  {
    id: createEventId(),
    title: 'Timed event',
    start: todayStr + 'T12:00:00',
    end: todayStr + 'T15:00:00'
  }
]

export function createEventId() {
  return String(eventGuid++)
}
</script>