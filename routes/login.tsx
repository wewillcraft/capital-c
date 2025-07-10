import { JSX } from "preact";
import LoginForm from "../islands/auth/LoginForm.tsx";

export default function Login(): JSX.Element {
  return (
    <div class="min-h-screen flex items-center justify-center bg-gradient-to-br from-slate-50 via-white to-slate-100 px-4">
      <div class="w-full max-w-md bg-white rounded-xl shadow-lg p-8 border border-slate-100">
        <h1 class="text-2xl font-bold text-slate-900 mb-6 text-center">
          Sign in to your account
        </h1>
        <LoginForm />
        <div class="mt-6 text-center text-slate-600 text-sm">
          Don't have an account?{" "}
          <a href="/signup" class="text-orange-600 hover:underline font-medium">
            Sign up
          </a>
        </div>
      </div>
    </div>
  );
}
