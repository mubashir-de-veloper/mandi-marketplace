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
