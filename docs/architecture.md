# Project Architecture

## 1. Architecture Overview

The project follows a client-server architecture.

```text
Flutter Android App
        |
        | HTTP / JSON REST API
        v
Node.js + Express Backend
        |
        | Database queries
        v
PostgreSQL Database
```

## 2. Responsibilities

### Mobile App

* Android user interface.
* User input and validation.
* API requests and responses.
* Local storage for offline functionality (planned).

### Backend

* REST API endpoints.
* Business rules and input validation.
* Authentication and authorization (planned).
* Database communication.

### Database

* User accounts and roles.
* Mandi rates and market locations.
* Reported prices.
* Product listings and marketplace transactions.

## 3. Development Principles

* Keep mobile, backend, database, and documentation files organized separately.
* Never place database passwords or private keys in source code.
* Validate data on both the mobile app and backend.
* Use role-based access control for protected operations.
* Design offline synchronization carefully before implementing it.
* Test API endpoints before connecting them to the mobile app.

## 4. Current Scope

The first release targets Android only. The backend is developed and tested locally before deployment. PostgreSQL integration will be implemented during the database module.
