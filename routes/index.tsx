import { JSX } from "preact";

const features = [
  {
    title: "Multi-Tenant Architecture",
    description:
      "Each church gets its own secure, isolated space. Manage multiple churches with one account.",
    icon: "🏛️",
  },
  {
    title: "Custom Data Modeling",
    description:
      "No-code/low-code schema designer lets you track anything: prayer requests, attendance, and more.",
    icon: "🛠️",
  },
  {
    title: "Event Calendar & RSVP",
    description:
      "Host, track, and RSVP to events. Keep your community connected and engaged.",
    icon: "📅",
  },
  {
    title: "Role-Based Access Control",
    description:
      "Granular permissions for staff, volunteers, and members. Privacy-first by design.",
    icon: "🔑",
  },
  {
    title: "Communication Tools",
    description:
      "Send emails and SMS to groups or your whole church. Keep everyone in the loop.",
    icon: "💬",
  },
  {
    title: "Reports & Dashboards",
    description:
      "Visualize attendance, engagement, and custom data. Make informed decisions.",
    icon: "📊",
  },
  {
    title: "Secure & Private",
    description:
      "No financial tracking. GDPR-ready. Data belongs to your church, not us.",
    icon: "🔒",
  },
  {
    title: "Accessible & Modern",
    description:
      "Mobile-first, WCAG 2.1 compliant, and easy for all ages to use.",
    icon: "🌈",
  },
];

export default function Home(): JSX.Element {
  return (
    <div class="bg-gradient-to-br from-slate-50 via-white to-slate-100 min-h-screen flex flex-col">
      {/* Navbar/Header */}
      <nav class="w-full bg-white/80 backdrop-blur border-b border-slate-200 shadow-sm sticky top-0 z-10">
        <div class="max-w-5xl mx-auto flex flex-col sm:flex-row items-center justify-between h-auto sm:h-16 px-4 gap-2 sm:gap-0 py-2 sm:py-0">
          <div class="flex items-center gap-3">
            <img
              src="/android-chrome-192x192.png"
              alt="Capital C Logo"
              class="w-10 h-10 rounded"
              style={{ imageRendering: "auto" }}
            />
            <a href="/" class="text-xl font-bold text-slate-900 tracking-tight">
              Capital C
            </a>
          </div>
          <a
            href="/signup"
            class="mt-2 sm:mt-0 inline-block bg-gradient-to-r from-orange-500 to-red-500 hover:from-orange-600 hover:to-red-600 text-white font-semibold px-6 py-2 rounded-lg shadow transition focus:outline-none focus:ring-2 focus:ring-orange-400 focus:ring-offset-2 w-full sm:w-auto text-center"
          >
            Get Started
          </a>
        </div>
      </nav>

      {/* Main Content */}
      <main class="flex-1 flex flex-col">
        {/* Features Section */}
        <section class="py-16 px-4" id="features">
          <div class="max-w-5xl mx-auto">
            <h2 class="text-3xl font-bold text-center text-slate-900 mb-10">
              Features
            </h2>
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-8">
              {features.map((f) => (
                <div
                  class="bg-white rounded-xl shadow p-6 flex flex-col items-center text-center border border-slate-100 hover:shadow-lg transition"
                  key={f.title}
                >
                  <div class="text-4xl mb-3">{f.icon}</div>
                  <h3 class="font-semibold text-lg text-slate-800 mb-2">
                    {f.title}
                  </h3>
                  <p class="text-slate-600 text-sm">{f.description}</p>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* How It Works Section */}
        <section class="py-16 px-4 bg-slate-50 border-t border-slate-100">
          <div class="max-w-4xl mx-auto text-center">
            <h2 class="text-2xl font-bold text-slate-900 mb-6">How It Works</h2>
            <ol class="flex flex-col md:flex-row justify-center items-center gap-8 md:gap-12">
              <li class="flex-1">
                <div class="text-3xl mb-2">📝</div>
                <div class="font-semibold text-slate-800">Sign Up</div>
                <div class="text-slate-600 text-sm">
                  Create your church's account in minutes.
                </div>
              </li>
              <li class="flex-1">
                <div class="text-3xl mb-2">⚙️</div>
                <div class="font-semibold text-slate-800">Customize</div>
                <div class="text-slate-600 text-sm">
                  Model your data, invite your team, and set up events.
                </div>
              </li>
              <li class="flex-1">
                <div class="text-3xl mb-2">🚀</div>
                <div class="font-semibold text-slate-800">Engage</div>
                <div class="text-slate-600 text-sm">
                  Connect with your community and grow together.
                </div>
              </li>
            </ol>
          </div>
        </section>

        {/* Security & Privacy Section */}
        <section class="py-16 px-4">
          <div class="max-w-3xl mx-auto text-center">
            <h2 class="text-2xl font-bold text-slate-900 mb-4">
              Security & Privacy
            </h2>
            <p class="text-slate-700 mb-4">
              Your data belongs to your church. We never track finances, sell
              data, or compromise privacy. All information is isolated per
              church, protected by modern authentication, and exportable at any
              time.
            </p>
            <ul class="flex flex-wrap justify-center gap-6 text-slate-800 font-medium">
              <li class="flex items-center gap-2">
                <span class="text-lg">🔒</span> Tenant Isolation
              </li>
              <li class="flex items-center gap-2">
                <span class="text-lg">🛡️</span> GDPR-Ready
              </li>
              <li class="flex items-center gap-2">
                <span class="text-lg">📜</span> Audit Logs
              </li>
              <li class="flex items-center gap-2">
                <span class="text-lg">🔑</span> Passwordless Auth
              </li>
            </ul>
          </div>
        </section>

        {/* Call to Action Section */}
        <section
          class="py-16 px-4 bg-gradient-to-r from-orange-50 to-red-50 border-t border-slate-100"
          id="get-started"
        >
          <div class="max-w-2xl mx-auto text-center">
            <h2 class="text-2xl font-bold text-slate-900 mb-4">
              Ready to empower your church?
            </h2>
            <p class="text-slate-800 mb-6">
              Start for free, no credit card required. Open source, forever.
            </p>
            <a
              href="/signup"
              class="inline-block bg-gradient-to-r from-orange-500 to-red-500 hover:from-orange-600 hover:to-red-600 text-white font-semibold px-8 py-3 rounded-lg shadow transition focus:outline-none focus:ring-2 focus:ring-orange-400 focus:ring-offset-2"
            >
              Get Started
            </a>
          </div>
        </section>
      </main>

      {/* Footer */}
      <footer class="mt-auto py-12 px-4 bg-slate-900 text-slate-100 text-center text-sm flex flex-col items-center">
        <div class="text-2xl font-bold mb-2 tracking-tight">
          Capital C
        </div>
        <div class="text-slate-300 mb-4">
          &copy; {new Date().getFullYear()}{" "}
          &mdash; Built with Deno Fresh, SurrealDB, Tailwind, and love.
        </div>
        <div class="w-full max-w-xs mx-auto border-t border-slate-700 my-4">
        </div>
        <a
          href="https://github.com/wewillcraft/capital-c"
          target="_blank"
          rel="noopener noreferrer"
          class="inline-block text-slate-300 hover:text-orange-400 underline transition text-base font-medium py-2"
        >
          View on GitHub
        </a>
      </footer>
    </div>
  );
}
