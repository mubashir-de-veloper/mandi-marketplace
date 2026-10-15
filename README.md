# Mandi Marketplace — Direct Agriculture Marketplace

A Flutter-based Android application designed to help farmers, buyers, and produce traders compare mandi prices, report observed market prices, and connect through a direct agricultural marketplace.

## Problem Statement

Agricultural producers and buyers may lack a convenient way to compare official mandi rates with prices observed in local markets. Limited price visibility can make it harder to make informed selling and purchasing decisions.

## Solution

Mandi Marketplace brings mandi-rate information and community-reported street prices into one mobile application. It also provides account authentication and a foundation for direct agricultural trading.

## Key Features

- **Mandi rates:** Retrieve mandi-rate data through the deployed backend API.
- **Street-price reporting:** Signed-in users can submit observed commodity prices for a selected city, commodity, and unit.
- **Price reports:** View submitted reports and their verification status.
- **User authentication:** Register, log in, view account details, and sign out.
- **Marketplace interface:** Access the app's agricultural marketplace screens.
- **REST API:** Connect the Android application to a hosted backend and PostgreSQL database.

> Price reports are user-submitted observations. They should not be treated as official government rates unless independently verified against an authoritative source.

## Technology Stack

| Component | Technology |
|---|---|
| Mobile application | Flutter and Dart |
| UI | Flutter Material components |
| API | Node.js and Express |
| Hosting | Vercel |
| Database | Neon PostgreSQL |
| HTTP communication | REST API over HTTPS |
| Authentication | JWT bearer tokens |
| Secure token storage | Flutter Secure Storage |
| Source control | Git and GitHub |

## Architecture

The Android application communicates with the backend through HTTPS REST endpoints. The backend handles requests, authentication, and database operations. Mandi-rate data is obtained through the backend's configured data source.

See the architecture diagram below in this README or in the project's documentation.

![Alt text](mermaid-diagram.png)

## Live Links

- **GitHub repository:** https://github.com/mubashir-de-veloper/mandi-marketplace
- **Backend API:** https://mandi-marketplace-api.vercel.app/
- **Health check:** https://mandi-marketplace-api.vercel.app/api/health

The backend root URL confirms that the API is running. The health endpoint checks backend/database availability.

## Run the Android App Locally

### Prerequisites

- Flutter SDK
- Dart SDK (included with Flutter)
- Android Studio and an Android emulator, or a compatible Android device
- Git

### Setup

Clone the repository:

```bash
git clone https://github.com/mubashir-de-veloper/mandi-marketplace.git
cd mandi-marketplace/mobile
```

Install dependencies:

```bash
flutter pub get
```

Check the development environment:

```bash
flutter doctor
```

Run static analysis:

```bash
flutter analyze
```

Launch the app on a connected Android device or emulator:

```bash
flutter run
```

### Build a Release APK

```bash
flutter build apk --release
```

The generated APK is located at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Run the build command from the `mobile` directory.

## Backend

The deployed backend is hosted at:

```text
https://mandi-marketplace-api.vercel.app
```

The backend uses Node.js, Express, and PostgreSQL. Database credentials and authentication secrets should be configured through environment variables in the deployment platform. Never commit `.env` files, database passwords, JWT secrets, or other credentials to GitHub.

For local backend development, install dependencies in the `backend` directory and configure the required environment variables using the project's backend configuration.

## Testing and Validation

The following checks have been completed during development:

- Flutter static analysis completed with no issues.
- Release APK built successfully.
- Login and account profile display tested.
- Sign-out flow tested.
- Street-price report submission tested.
- Deployed backend health check and database connection confirmed.

These checks describe the tested development state; they do not imply that every feature has undergone independent production or security testing.

## Project Goals

The project aims to improve agricultural price visibility and support more direct connections between farmers, buyers, and produce traders.

Potential future improvements include stronger report-verification workflows, expanded marketplace transactions, offline data access, and synchronization when connectivity returns.

## Maintainer

Developed as a mobile application project using Flutter, Node.js, Express, and PostgreSQL.

# Mandi Rate & Direct Agriculture Marketplace

An Android application designed to help farmers, buyers, and sellers access official mandi rates, report actual market prices, compare prices, and trade agricultural products directly.

## Project Goals

* View official mandi rates.
* Report actual market prices.
* Compare agricultural prices across markets.
* Allow farmers and sellers to publish product listings.
* Help buyers connect directly with sellers.
* Support offline access and data synchronization.

## Technology Stack

| Component           | Technology             |
| ------------------- | ---------------------- |
| Android application | Flutter + Dart         |
| Backend API         | Node.js + Express      |
| Database            | PostgreSQL (planned)   |
| Authentication      | JWT (planned)          |
| Offline storage     | SQLite/Drift (planned) |
| API testing         | Postman                |
| Version control     | Git + GitHub           |

## Project Structure

```text
mandi-marketplace/
├── mobile/          # Flutter Android application
├── backend/         # Node.js REST API
├── database/        # Database scripts and schema
├── docs/            # Project documentation
├── .gitignore
└── README.md
```

## Requirements

* Flutter SDK
* Dart SDK (included with Flutter)
* Android SDK and an Android emulator or physical Android device
* Node.js and npm
* Git
* PostgreSQL (when database development begins)

## Run the Backend

Open a terminal:

```powershell
cd backend
npm install
npm run dev
```

The development server runs on port `5000` by default.

Health-check endpoint:

`http://localhost:5000/api/health`

Root endpoint:

`http://localhost:5000/`

## Run the Android App

Open another terminal:

```powershell
cd mobile
flutter pub get
flutter run
```

Start an Android emulator or connect an Android device with USB debugging enabled before running the app.

## Environment Configuration

The backend uses environment variables stored in `backend/.env`.

Example:

```env
PORT=5000
```

Never commit real secrets, passwords, API keys, or database credentials. Use `.env.example` to document the required variable names.

## Development Status

**Module 0 — Project Architecture & Setup:** Initial setup in progress.

Planned next stages include UI/UX design, database design, API development, authentication, mandi rates, price reporting, marketplace features, offline support, testing, and deployment.

## Platform Scope

The application is currently planned for **Android only**. iOS, web, and desktop builds are outside the current scope.
