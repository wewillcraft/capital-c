import { JSX } from "preact";
import SignupForm from "../islands/auth/SignupForm.tsx";

export default function Signup(): JSX.Element {
  return (
    <div class="min-h-screen flex items-center justify-center bg-gradient-to-br from-slate-50 via-white to-slate-100 px-4">
      <div class="w-full max-w-md bg-white rounded-xl shadow-lg p-8 border border-slate-100">
        <h1 class="text-2xl font-bold text-slate-900 mb-6 text-center">
          Create your account
        </h1>
        <SignupForm />
        <div class="mt-6 text-center text-slate-600 text-sm">
          Already have an account?{" "}
          <a href="/login" class="text-orange-600 hover:underline font-medium">
            Sign in
          </a>
        </div>
      </div>
    </div>
  );
}
