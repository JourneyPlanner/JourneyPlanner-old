<script lang="ts">
import {computed, reactive, ref} from "vue";
//@ts-ignore
import {supabase} from "@/lib/supabaseClient";
import {useVuelidate} from '@vuelidate/core'
import {required, email, sameAs, minLength} from '@vuelidate/validators'
import Footer from "@/components/Footer.vue";
import FliegerIllustration from "@/components/illustrations/FliegerIllustration.vue";
import BackToHomeButton from "@/components/buttons/BackToHomeButton.vue";

export default {
  components: {BackToHomeButton, FliegerIllustration, Footer},
  setup() {
    const state = reactive({
      accepted: false,
      password: '',
      passwordRepeat: '',
      username: '',
      contact: {
        email: ''
      }
    })
    const rules = {
      accepted: {checked: sameAs(true), $autoDirty: true},
      username: {required}, // Matches state.firstName
      password: {required, minlength: minLength(6)},
      passwordRepeat: {sameAsPassword: sameAs(computed(() => state.password))},
      contact: {
        email: {required, email: email} // Matches state.contact.email
      }
    }

    const v$ = useVuelidate(rules, state)

    async function signUp() {
      if (!state.accepted) {
        return;
      }
      const {user, error} = await supabase.auth.signUp(
          {
            email: state.contact.email,
            password: state.password,
            options: {
              data: {
                username: state.username,
              }
            }
          }
      )

      if (error) {
        console.log(error);
      } else {
        console.log(user);
      }
    }

    return {state, v$, signUp}
  }
}


</script>
<template>
  <div class="relative">
    <div class="about bg-background flex">
      <div id="firsHalf" class="xl:w-1/2 md:w-2/3 sm:w-[100%] items-center justify-center flex flex-col">
        <BackToHomeButton class="absolute top-[2%] left-[2%]"/>
        <div class="form xl:w-1/2 md:w-[80%] sm:w-[80%]">
          <h1 class="xl:text-3xl md:text-3xl sm:text-3xl pl-6.1538em font-nunito pt-[15%]">Registrierung</h1>
          <form class="bg-primary rounded-2xl xl:w-[25vw] md:w-[50vw] sm:w-[75vw]">
            <div class="inside items-center justify-center flex flex-col">
              <h2 class=" text-left text-xl font-nunito font-semibold">Benutzername</h2>
              <input v-model="v$.username.$model" class="font-nunito text-xl " placeholder="Benutzername eingeben">
              <p v-if="v$.username.$error" class="text-delete text-base font-nunito">Benutzername ist verpflichtend</p>
              <h2 class="text-xl font-nunito font-semibold">E-Mail</h2>
              <input v-model="v$.contact.email.$model" class="font-nunito text-xl" placeholder="E-Mail eingeben">
              <p v-if="v$.contact.email.$error" class="text-delete text-base font-nunito">Nicht das richtige Format</p>
              <h2 class="text-xl font-nunito font-semibold">Passwort</h2>
              <input v-model=v$.password.$model type="password" class="font-nunito text-xl"
                     placeholder="Passwort eingeben">
              <p v-if="v$.password.$error" class="text-delete text-base font-nunito">Muss zumindest 6 Character
                enthalten</p>
              <h2 class="text-xl font-nunito font-semibold">Passwort wiederholen</h2>
              <input v-model=v$.passwordRepeat.$model type="password" class="font-nunito text-xl"
                     placeholder="Passwort eingeben">
              <p v-if="v$.passwordRepeat.$error" class="text-delete text-base font-nunito">Nicht ident zu Passwort</p>
              <div class="check">
                <label class="font-nunito text-base">
                  <input type="checkbox" v-model="v$.accepted.$model">
                  Hiermit akzeptiere ich die
                  <RouterLink to="blob">
                    Datenschutzerklärung
                  </RouterLink>
                </label>
              </div>
              <div class="items-center justify-center flex p-3">
                <button :disabled="v$.$invalid" @mouseover="v$.$touch()" type="button"
                        class="registerButton bg-call-to-action rounded-3xl font-nunito text-xl font-bold p-1.5"
                        @click="signUp">Registrieren
                </button>
                <RouterLink class="font-nunito text-base font-bold px-2 break-after-all" to="login">Schon registriert?
                </RouterLink>
              </div>
              <p v-if="v$.accepted.$error" class="text-delete text-base font-nunito">Bitte akzeptieren Sie die
                Datenschutzerklärung</p>
            </div>
          </form>
        </div>

      </div>
      <div class="w-1/2 items-center justify-center overflow-x-hidden">
        <FliegerIllustration class="h-[85vh] ml-[1%]"/>
      </div>
    </div>
      <Footer class="mt-14"/>
  </div>
</template>

<style>
input:not([type="checkbox"]) {
  @apply flex w-[90%]
}

h2 {
  @apply pt-[3%] text-left
}

/*
.form {
  margin-left: 16.25vw;
  padding-top: 10.31vw;
  width: 25.94vw;

}

.inside {
  padding-left: 1.25vw;
}

input:not([type="checkbox"]) {
  width: 23.28vw;
}



.check {
  padding-top: 3.14vh;
}

.registerButton {
  width: 12.29vw;
  text-align: center;
}

.register {
  display: flex;
  align-items: center;
  padding-top: 1.2vw;
  padding-bottom: 1.41vw;
}
*/

</style>
