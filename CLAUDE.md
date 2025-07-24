# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Capital C is an open-source church management system built with Deno Fresh, featuring a multi-tenant SaaS architecture with complete data isolation between organizations. The project focuses on privacy, ethical data handling, and does not include financial tracking features.

## Development Commands

### Essential Commands
- `deno task start` - Start development server with file watching
- `deno task check` - Run full type checking, formatting, and linting
- `deno task build` - Build the application for production
- `deno task preview` - Preview production build locally

### Database Operations
- `docker compose up -d` - Start SurrealDB in background
- `deno task migrate apply global` - Apply global schema migrations
- `deno task tenants create <name> <display_name>` - Create new tenant
- `deno task users create` - Create tenant user interactively

### Utility Commands
- `deno task manifest` - Update Fresh manifest
- `deno task update` - Update Fresh framework
- `deno fmt` - Format code
- `deno lint` - Run linter

## Core Architecture

### Multi-Tenant Design
- **Tenant Isolation**: Each church/organization uses separate SurrealDB namespaces
- **Global vs Tenant Data**: Global namespace manages tenant registry; individual namespaces contain church-specific data
- **Migration Strategy**: Separate migration paths for global schema and tenant-specific schemas in `migrations/` directory

### Database Patterns
- **SurrealDB Multi-Model**: Combines relational and document patterns
- **Schema Flexibility**: Mix of `SCHEMAFULL` and `SCHEMALESS` tables
- **Relation Modeling**: Explicit relationships using `TYPE RELATION`
- **Permission System**: Database-level RBAC with `fn::has_permission` functions
- **Custom Definitions**: Flexible schema system allowing churches to extend data models

### Authentication Architecture
- **Better-Auth Integration**: Modern authentication with security best practices
- **Database Auth**: SurrealDB's built-in authentication with `SIGNUP`/`SIGNIN` access methods
- **Separated Concerns**: Authentication (`user` table) separate from profiles (`person` table)
- **Tenant Context**: JWT tokens include tenant claims for proper data scoping

### Fresh Framework Structure
- **File-Based Routing**: Routes in `/routes/` directory follow Fresh conventions
- **Islands Architecture**: Interactive components in `/islands/` for client-side functionality
- **Server-Side Rendering**: Default SSR with selective hydration
- **Preact Integration**: React-like patterns with lighter footprint

## Key File Structure

- `main.ts` / `dev.ts` - Application entry points
- `models.ts` - Core data model definitions and types
- `auth.ts` - Authentication configuration and handlers
- `routes/` - Server-side routes and API endpoints
- `islands/` - Client-side interactive components
- `migrations/` - Database schema migrations (global/, tenants/, others/)
- `scripts/` - Administrative CLI tools for tenant/user management
- `static/` - Static assets including favicons and styles

## Development Patterns

### Code Style
- Follow existing patterns in each file
- Use TypeScript strict mode with proper type definitions
- Implement mobile-first responsive design with Tailwind CSS
- Ensure WCAG 2.1 accessibility compliance
- Write meaningful comments for complex business logic only

### Database Development
- Always scope queries by tenant context
- Use SurrealDB's graph capabilities for relationships
- Implement proper indexes for performance
- Use transactions for multi-table operations
- Follow the permission system patterns for access control

### Security Considerations
- Implement tenant isolation at all application layers
- Use JWT with tenant claims for authentication
- Follow GDPR principles for data handling
- Minimize data collection and implement audit logging
- Use database-level assertions for data validation

### Testing Strategy
- Use Deno's built-in testing framework
- Test critical multi-tenant functionality
- Ensure tenant isolation in all tests
- Test permission system boundaries
- Include edge cases for church-specific scenarios

## Multi-Tenant Specific Patterns

### Tenant Management
- Create tenants using the CLI script: `deno task tenants create`
- Each tenant gets its own SurrealDB namespace
- Global tenant registry maintains tenant metadata
- Independent migration application per tenant

### Data Scoping
- All database queries must include tenant context
- Use database-level permissions for row-level security
- Implement proper RBAC with realm-based permissions
- Separate global operations from tenant-specific operations

### Permission System
- Hierarchical realm system with permission inheritance
- Custom SurrealDB functions for permission checking
- Separate `role`, `realm`, and `has_permission` relations
- Database-level enforcement of access control

## Development Setup Requirements

1. **Dependencies**: Deno (latest) and Docker must be installed
2. **Environment**: Copy `.env.example` to `.env` and configure
3. **Database**: Start SurrealDB with `docker compose up -d`
4. **Initialization**: Run global migrations and create first tenant
5. **Development**: Use `deno task start` for file-watching development server

## Domain-Specific Context

This is a church management system focusing on:
- Member management with privacy controls
- Event management and RSVP functionality
- Communication tools (email/SMS integration)
- Custom data modeling for church-specific needs
- Role-based access for church staff and volunteers
- No financial tracking (by design choice)