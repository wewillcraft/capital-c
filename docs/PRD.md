# Capital C - An Open Source Church Management System (ChMS)

### 1. Overview

#### Product Vision

Empower churches of all sizes to manage their people, content, and community
operations through a modular, modern, open-source, cloud-native platform.

#### Mission

To provide a sustainable, extensible, and church-first system for
non-commercial, ethical management of events, people, and custom data — while
avoiding invasive financial tracking.

#### Target Audience

- Churches seeking non-commercial, privacy-conscious digital infrastructure
- Administrators wanting a no-code/low-code interface to manage their community
  data
- Developers or volunteers seeking ethical, extensible tooling for faith
  communities

#### Problem Statement

Churches often rely on expensive, proprietary software or piece together
fragmented tools that don't align with their values, especially around money and
privacy.

#### Unique Value Proposition (UVP)

A free, ethical, privacy-first ChMS with multi-tenant architecture, headless-CMS
capabilities, and church-owned data control — built to evolve with local needs.

---

### 2. Goals & Success Metrics

#### Long-Term Vision

A decentralized, open-source ChurchOps platform with strong extensibility,
developer APIs, and ethical defaults that empower rather than monetize
communities.

#### MVP Scope Definition

Build core multi-tenant admin capabilities, custom data modeling (CMS-style),
events, and communications — without financial features.

#### Open Source Success Metrics

- 🧑‍🎓 100+ churches using it within 18 months
- 🛠️ 10+ active community contributors in 12 months
- 💬 Community hub with ongoing plugin contributions

#### Dev Constraints & Sustainable Roadmap Plan

- Solo developer, 10 hrs/week max
- Every module must be opt-in, composable
- Clear APIs + community plugin interface from day 1

---

### 3. MVP Feature Set

#### Multi-tenant Architecture

- **Purpose**: Data isolation and scalability
- **Priority**: Must-Have
- **User Story**: As a church admin, I want our data isolated from others to
  ensure privacy and simplicity.

#### Unified User Accounts

- **Purpose**: One login across many churches
- **Priority**: Must-Have
- **User Story**: As a user, I want to manage multiple churches from one account
  securely.

#### Role-Based Access Control (RBAC)

- **Purpose**: Define what users can access per church
- **Priority**: Must-Have
- **User Story**: As a pastor, I want to control who sees and edits data.

#### Schema Designer (Headless CMS Functionality)

- **Description**: Admin UI to define collections, fields, validations — similar
  to KeystoneJS/Directus.
- **Purpose**: Let churches model their own data (e.g., prayer requests, service
  notes, attendance logs).
- **Priority**: Must-Have
- **User Story**: As an admin, I want to create a "Baptism Tracker" collection
  with custom fields.

#### Member Directory & Profiles

- **Purpose**: Manage people and contact information
- **Priority**: Must-Have
- **User Story**: As a leader, I want to search and update member records.

#### Event Calendar with RSVP

- **Purpose**: Host and track events
- **Priority**: Must-Have
- **User Story**: As a user, I want to RSVP to upcoming church events.

#### Communication Tools (Email/SMS)

- **Purpose**: Contact groups or the whole church
- **Priority**: Should-Have
- **User Story**: As an admin, I want to message all volunteers before Sunday.

#### Reports & Dashboards

- **Purpose**: View attendance, engagement, or custom data
- **Priority**: Nice-to-Have
- **User Story**: As a staff member, I want to see how many people RSVP'd to
  past events.

#### Secure Authentication

- **Purpose**: Passwordless email login preferred
- **Priority**: Must-Have
- **User Story**: As a member, I want to log in quickly and securely.

---

### Post-MVP Features

| Feature                        | Description               | Priority     |
| ------------------------------ | ------------------------- | ------------ |
| Merch Store                    | Sell T-shirts, etc.       | Nice-to-Have |
| Event Tickets + QR             | Manage entry to events    | Should-Have  |
| Small Group Management         | Group coordination        | Should-Have  |
| Volunteer Scheduling           | Sunday team coordination  | Should-Have  |
| Worship Planning               | Service planning tool     | Nice-to-Have |
| Multi-campus Support           | Manage multiple locations | Should-Have  |
| Advanced Analytics             | Engagement insights       | Nice-to-Have |
| Mobile App / PWA               | Optimized mobile UX       | Should-Have  |
| 3rd-party Integrations         | Mailchimp, etc.           | Must-Have    |
| Church Config Settings         | Theme, roles, menus       | Should-Have  |
| In-app Messaging / Prayer Wall | Internal communications   | Should-Have  |

---

#### Newly Added Post-MVP Enhancements

- Workflow automation (e.g., "When RSVP confirmed, send SMS")
- Bulk messaging segmentation
- Advanced event filters (recurring, per group)
- Public schema-based form + microsite builder
- Developer APIs (REST/GraphQL, scoped keys)

---

### 4. UX & Design Requirements

- Mobile-first and fully responsive design is required for all frontend features
- TailwindCSS-first design system
- Mobile-first, lightweight interface
- Minimal UI chrome — content and context focused
- WCAG 2.1 accessibility compliance
- Per-tenant branding: logo, theme, name
- Consider users with varying technical skills

---

### 5. Technical Architecture

- **Stack**: Deno + Fresh (islands), SurrealDB (multi-model, real-time), Zod
  (validation), GraphQL (complex queries)
- **Multi-tenancy**: Tenant-scoped schema, data, and access
- **Auth**: Global users, JWT-based sessions, tenant-scoped permissions
- **RBAC**: Layered (global + church-specific) enforced on DB + API
- **CMS engine**: Schema stored in SurrealDB + rendered dynamically
- **Events & real-time**: Live RSVP updates, status tracking via GraphQL
  subscriptions
- **Validation**: Zod schemas for all data validation and type safety
- **API Design**: REST for simple CRUD, GraphQL for complex relationships
- **Hosting**: Deno Deploy (preferred), fallback to Vercel or Docker

---

### 6. Security & Privacy

- Tenant isolation at schema/query layer
- JWT tokens with short expiry + tenant claims
- Data minimization: No financial tracking or sensitive PII stored unless added
  manually
- Audit logs: Track access + data changes per user
- GDPR-ready: Data export, deletion, opt-in consent
- Implement tenant isolation at all layers
- Use secure authentication (passwordless preferred)

---

### 7. Development Plan

#### Release Strategy

- Alpha – Internal use + docs
- Beta – Invite-only onboarding for small churches
- Stable v1.0 – Public launch with schema builder, core CMS, and events

#### Community Onboarding

- CONTRIBUTING.md with testable issues
- Discord + GitHub Discussions
- CLI for spinning up test church instances

---

### 8. Appendix

#### Glossary

- Tenant: One church instance (isolated schema/data)
- Schema: Configurable structure for content collections
- RBAC: Role-Based Access Control
- CMS: Content Management System
- Fresh: Deno-native SSR framework
- Zod: TypeScript-first schema validation library
- GraphQL: Query language for APIs with real-time capabilities

#### Competitive Landscape

- KeystoneJS: Excellent CMS with dev-first approach
- Directus: Great UI + headless flexibility
- Planning Center: Feature-rich but commercial
- Breeze: Easy-to-use but closed source

#### Inspiration

- https://keystonejs.com/
- https://directus.io/
- https://tina.io/
- https://github.com/churchapps (ChurchOS)

### 9. Current Implementation Status

#### Completed

- [ ] Project setup with Deno Fresh
- [ ] Basic routing structure
- [ ] Tailwind CSS integration
- [ ] SurrealDB connection

#### In Progress

- [ ] Authentication system
- [ ] Multi-tenant architecture setup
- [ ] Basic UI components
- [ ] Zod validation schemas

#### Next Sprint

- [ ] Schema designer UI
- [ ] Member directory CRUD
- [ ] Event calendar foundation
- [ ] GraphQL API setup

### 10. Technical Decisions

#### Why Deno Fresh?

- Server-side rendering for SEO
- Islands architecture for interactivity
- Built-in TypeScript support
- Deploy anywhere with Deno Deploy

#### Why SurrealDB?

- Multi-model (document + graph + relational)
- Real-time subscriptions
- Built-in multi-tenancy support
- ACID transactions

#### Why Tailwind?

- Utility-first for rapid development
- Consistent design system
- Small bundle size
- Excellent developer experience

#### Why Zod?

- TypeScript-first validation
- Runtime type safety
- Excellent error messages
- Schema composition and inference

#### Why GraphQL?

- Complex data relationships
- Real-time subscriptions
- Type-safe queries
- Efficient data fetching

### 11. API Design Patterns

#### REST Endpoints

- `/api/tenants/{id}/members` - Member management
- `/api/tenants/{id}/events` - Event management
- `/api/tenants/{id}/schemas` - Schema management

#### GraphQL Schema

- Complex queries for member relationships
- Real-time subscriptions for live updates
- Type-safe mutations with Zod validation
- Tenant-scoped resolvers

#### Authentication Flow

- Email-based passwordless login
- JWT with tenant claims
- Refresh token rotation

### 12. Performance Requirements

- Optimize for church-scale usage (100-1000 users)
- Use Fresh's islands for interactive components
- Leverage SurrealDB's real-time capabilities
- Implement proper caching strategies
- Consider mobile performance for church staff
