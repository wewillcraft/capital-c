import { JSX } from "preact";
import { useState } from "preact/hooks";

export default function SignupForm(): JSX.Element {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");

  return (
    <form class="flex flex-col gap-4">
      <label class="flex flex-col gap-1">
        <span class="text-slate-700 font-medium">Email</span>
        <input
          type="email"
          class="px-4 py-2 rounded border border-slate-200 focus:outline-none focus:ring-2 focus:ring-orange-400"
          placeholder="you@example.com"
          value={email}
          onInput={(e) => setEmail((e.target as HTMLInputElement).value)}
          required
        />
      </label>
      <label class="flex flex-col gap-1">
        <span class="text-slate-700 font-medium">Password</span>
        <input
          type="password"
          class="px-4 py-2 rounded border border-slate-200 focus:outline-none focus:ring-2 focus:ring-orange-400"
          placeholder="••••••••"
          value={password}
          onInput={(e) => setPassword((e.target as HTMLInputElement).value)}
          required
        />
      </label>
      <label class="flex flex-col gap-1">
        <span class="text-slate-700 font-medium">Confirm Password</span>
        <input
          type="password"
          class="px-4 py-2 rounded border border-slate-200 focus:outline-none focus:ring-2 focus:ring-orange-400"
          placeholder="••••••••"
          value={confirm}
          onInput={(e) => setConfirm((e.target as HTMLInputElement).value)}
          required
        />
      </label>
      <button
        type="submit"
        class="mt-2 bg-gradient-to-r from-orange-500 to-red-500 hover:from-orange-600 hover:to-red-600 text-white font-semibold py-2 rounded-lg shadow transition focus:outline-none focus:ring-2 focus:ring-orange-400 focus:ring-offset-2"
      >
        Sign Up
      </button>
    </form>
  );
}
