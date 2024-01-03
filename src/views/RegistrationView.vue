<script setup>
import {computed, onMounted, reactive} from "vue";
//@ts-ignore
import {supabase} from "@/lib/supabaseClient";
import {useVuelidate} from '@vuelidate/core'
import {email, minLength, required, sameAs} from '@vuelidate/validators'
import Footer from "@/components/Footer.vue";
import FliegerIllustration from "@/components/illustrations/FliegerIllustration.vue";
import BackToHomeButton from "@/components/buttons/BackToHomeButton.vue";
import router from "@/router";
import MicrosoftLoginIllustration from "@/components/illustrations/MicrosoftLoginIllustration.vue";

const state = reactive({
  accepted: false,
  password: '',
  passwordRepeat: '',
  username: '',
  contact: {
    email: ''
  }
});

const rules = {
  accepted: {checked: sameAs(true), $autoDirty: true},
  username: {required}, // Matches state.firstName
  password: {required, minlength: minLength(6)},
  passwordRepeat: {sameAsPassword: sameAs(computed(() => state.password))},
  contact: {
    email: {required, email: email} // Matches state.contact.email
  }
};

const v$ = useVuelidate(rules, state)

/**
 * handle sign up
 *
 * @returns {Promise<void>}
 */
async function signUp() {
  if (!state.accepted) {
    this.v$.$touch()
    console.log(v$.$error);
    return;
  }
  const {user, error} = await supabase.auth.signUp(
      {
        email: state.contact.email,
        password: state.password,
        options: {
          data: {
            username: state.username,
          },
          emailRedirectTo: 'https://journeyplanner.io/dashboard'
        }
      }
  )
  if (error) {
    console.log(error);
  } else {
    await router.push("/login" + "?registered=true");
  }
}

/**
 * handle sign in with Google
 *
 * @param response
 * @returns {Promise<void>}
 */
window.handleSignInWithGoogle = async function handleSignInWithGoogle(response) {
  const {data, error} = await supabase.auth.signInWithIdToken({
    provider: 'google',
    token: response.credential,
    options: {
      data: {
        username: 'temp',
      }
    }
  })
  if (error) {
    console.log(error);
  } else {
    await router.push("/dashboard");
  }
}

/**
 * handle sign in with Microsoft
 *
 * @returns {Promise<void>}
 */
async function handleSignInWithMicrosoft() {
  const {data, error} = await supabase.auth.signInWithOAuth({
    provider: 'azure',
    options: {
      scopes: 'email',
    },
  });
  if (error) {
    console.log(error);
  } else {
    await router.push("/dashboard");
  }
}

onMounted(() => {
  let recaptchaScript = document.createElement('script')
  recaptchaScript.setAttribute('src', 'https://accounts.google.com/gsi/client')
  document.head.appendChild(recaptchaScript)
})
</script>

<template>
  <div class="relative text-text-black">
    <div class="bg-background flex">
      <div id="firsHalf" class="xl:w-1/2 md:w-2/3 sm:w-[100%] items-center justify-center flex flex-col">
        <BackToHomeButton class="absolute top-[2%] left-[2%]"/>
        <div class="xl:w-1/2 md:w-[80%] sm:w-[80%]">
          <h1 class="xl:text-3xl md:text-3xl sm:text-3xl pl-6.1538em font-nunito pt-[15%]">Registrierung</h1>
          <form class="bg-primary rounded-2xl xl:w-[28vw] md:w-[55vw] sm:w-[80vw] ">
            <div class="inside flex flex-col pl-8 ">
              <h2 class="col-start-1 text-xl font-nunito font-semibold">Benutzername</h2>
              <input v-model="v$.username.$model"
                     class="font-nunito text-xl border rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action pl-1"
                     placeholder="Benutzername eingeben">
              <p v-if="v$.username.$error" class="text-delete text-base font-nunito">Benutzername ist verpflichtend</p>
              <h2 class="text-xl font-nunito font-semibold">E-Mail</h2>
              <input v-model="v$.contact.email.$model"
                     class="font-nunito text-xl border rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action pl-1"
                     placeholder="E-Mail eingeben">
              <p v-if="v$.contact.email.$error" class="text-delete text-base font-nunito">Nicht das richtige Format</p>
              <h2 class="text-xl font-nunito font-semibold">Passwort</h2>
              <input v-model=v$.password.$model
                     class="font-nunito text-xl border rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action pl-1"
                     placeholder="Passwort eingeben"
                     type="password">
              <p v-if="v$.password.$error" class="text-delete text-base font-nunito">Muss zumindest 6 Zeichen
                enthalten</p>
              <h2 class="text-xl font-nunito font-semibold">Passwort wiederholen</h2>
              <input v-model=v$.passwordRepeat.$model
                     class="font-nunito text-xl border rounded border-none focus:outline-none focus:ring-2 focus:ring-call-to-action pl-1"
                     placeholder="Passwort eingeben"
                     type="password" @keyup.enter="signUp">
              <p v-if="v$.passwordRepeat.$error" class="text-delete text-base font-nunito">Nicht ident zu Passwort</p>
              <div class="check">
                <label class="font-nunito text-base">
                  <input v-model="v$.accepted.$model" class="p-3" type="checkbox">
                  Hiermit akzeptiere ich die
                  <RouterLink :to="{ name: 'datenschutz'}" class="underline underline-offset-2 ml-4 lg:ml-0"
                              target="_blank">
                    Datenschutzerklärung
                  </RouterLink>
                </label>
              </div>
              <p v-if="v$.accepted.$error" class="text-delete text-base font-nunito">Bitte akzeptieren Sie die
                Datenschutzerklärung</p>
              <div class="my-3">
                <button :disabled="v$.$invalid"
                        class="disabled:opacity-50 registerButton bg-call-to-action rounded-3xl font-nunito text-xl font-bold p-1 px-2 hover:opacity-80"
                        type="button"
                        @click="signUp" @keyup.enter="signUp">Registrieren
                </button>
                <RouterLink
                    class="font-nunito text-base font-bold px-2 break-after-all underline underline-offset-2 lg:ml-4"
                    to="login">Schon registriert?
                </RouterLink>
              </div>
              <div class="max-w-72 mb-2">
                <div id="g_id_onload"
                     data-callback="handleSignInWithGoogle"
                     data-client_id="423199431986-u0servcgoperfqd07iaofml60qoeh3aa.apps.googleusercontent.com"
                     data-context="signin"
                     data-itp_support="true"
                     data-ux_mode="popup">
                </div>
                <div class="g_id_signin"
                     data-logo_alignment="left"
                     data-shape="pill"
                     data-size="large"
                     data-text="signin_with"
                     data-theme="outline"
                     data-type="standard">
                </div>
              </div>
              <div class="mb-4">
                <MicrosoftLoginIllustration @click="handleSignInWithMicrosoft()"/>
              </div>
            </div>
          </form>
        </div>

      </div>
      <div class="w-1/2 items-center justify-center overflow-x-hidden">
        <FliegerIllustration class="h-[85vh] ml-[1%]"/>
      </div>
    </div>
    <div class="xl:w-1/2 md:w-2/3 sm:w-[100%] items-center justify-center flex ml-5 -mr-0.5">
      <Footer class="bottom-0 w-full md:fixed"/>
    </div>
  </div>
</template>

<style scoped>
input:not([type="checkbox"]) {
  @apply flex w-[90%]
}

h2 {
  @apply pt-[3%] text-left
}
</style>
