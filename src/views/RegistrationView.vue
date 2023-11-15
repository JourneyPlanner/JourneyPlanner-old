<script lang="ts">
import {computed, reactive, ref} from "vue";
//@ts-ignore
import {supabase} from "@/lib/supabaseClient";
import {useVuelidate} from '@vuelidate/core'
import {required, email, sameAs, minLength} from '@vuelidate/validators'

export default {
  setup() {
    const state = reactive({
      password: '',
      passwordRepeat: '',
      username: '',
      contact: {
        email: ''
      }
    })
    const rules = {
      username: {required}, // Matches state.firstName
      password: {required, minlength: minLength(6)},
      passwordRepeat: {sameAsPassword: sameAs(computed(() => state.password))},
      contact: {
        email: {required, email: email} // Matches state.contact.email
      }
    }

    const v$ = useVuelidate(rules, state)
    async function signUp() {
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
        window.location.href = "http://localhost:5173/dashboard"
      }
    }

    return {state, v$, signUp}
  }
}


</script>
<template>
  <div class="about bg-background">
    <div class="form">
      <h1 class="text-4xl pl-6.1538em font-nunito">Registrierung</h1>
      <form class="bg-primary rounded-2xl">
        <div class="inside">
          <h2 class="text-2xl font-nunito font-semibold">Benutzername</h2>
          <input v-model="v$.username.$model" class="font-nunito text-2xl" placeholder="Benutzername eingeben">
          <p v-if="v$.username.$error" class="text-delete text-xl font-nunito">Benutzername ist verpflichtend</p>
          <h2 class="text-2xl font-nunito font-semibold">E-Mail</h2>
          <input v-model="v$.contact.email.$model" class="font-nunito text-2xl" placeholder="E-Mail eingeben">
          <p v-if="v$.contact.email.$error" class="text-delete text-xl font-nunito">Nicht das richtige Format</p>
          <h2 class="text-2xl font-nunito font-semibold">Passwort</h2>
          <input v-model=v$.password.$model type="password" class="font-nunito text-2xl" placeholder="Passwort eingeben">
          <p v-if="v$.password.$error" class="text-delete text-xl font-nunito">Muss zumindest 6 Character enthalten</p>
          <h2 class="text-2xl font-nunito font-semibold">Passwort wiederholen</h2>
          <input v-model=v$.passwordRepeat.$model type="password" class="font-nunito text-2xl" placeholder="Passwort eingeben">
          <p v-if="v$.passwordRepeat.$error" class="text-delete text-xl font-nunito">Nicht ident zu Passwort</p>
          <div class="check">
            <label class="font-nunito text-base">
              <input type="checkbox">
              Hiermit stimmt du unserer <a class="underline" href=""> Datenschutzerklärung</a> zu
            </label>
          </div>
          <div class="register">
            <button type="button" class="registerButton bg-call-to-action rounded-3xl" @click="signUp">Sign up</button>
            <p class="font-nunito text-xl font-bold px-2">Schon registriert?</p>
          </div>
        </div>
      </form>
    </div>
  </div>
</template>

<style>

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

h2 {
  padding-top: 1.82vw;
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

</style>
