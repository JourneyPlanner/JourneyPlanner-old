<script lang="ts" setup>
// @ts-ignore
import {supabase} from "@/lib/supabaseClient";
import {useRoute} from "vue-router";
import router from "@/router";

const invite = useRoute().params.uuid;
const {data: {user}} = await supabase.auth.getUser();
if (!user) {
  await router.push('/login?redirect=/beitreten/' + invite);
}
const userId = user.id;
const {data: functionData, error: functionError} = await supabase.rpc('add_user_to_journey', {
  user_id: userId,
  invite_code: invite
});
if (functionError) {
  console.log(functionError);
  await router.push('/fehler')
} else {
  const {data: journeyData, error: journeyError} = await supabase
      .from('journey')
      .select('pk_journey_uuid')
      .eq('invite', invite);

  if (journeyError) {
    console.log(journeyError);
    await router.push('/dashboard')
  } else {
    await router.push('/reise/' + journeyData[0].pk_journey_uuid);
  }
}
</script>
