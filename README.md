# Employee Timesheets Management App

## Description
This is a mobile application built with **Flutter** designed to manage employee check-in and check-out times. The app uses a **Google Sheet** as its backend for storing and retrieving timesheet data. The `UserSheetsApi` class, which leverages the `gsheets` package, handles all interactions with the spreadsheet, including initializing worksheets, reading employee names, and logging check-in/check-out times.

The app's main features include:
* **Time Tracking**: Employees can clock in and out, with times automatically recorded.
* **Google Sheets Integration**: Timesheet data is stored in a dynamic Google Sheet, with a new sheet created each month.
* **Employee Data Management**: Reads a list of employees from a designated "Employees" sheet.
* **Offline Support**: While the app relies on an internet connection to write to the spreadsheet, the `Employee` class holds state, suggesting a degree of local state management.
* **Dynamic Worksheets**: The app creates a new worksheet each month named after the current month and year (e.g., "Aug 2025") to keep timesheet data organized.

---

## Requirements

* **Flutter SDK**: The project is built with Flutter. Ensure you have the Flutter SDK installed on your machine.
* **Dart SDK**: Dart is the language used for Flutter development.
* **Google Sheets API**: To connect to Google Sheets, you need to set up the **Google Sheets API** and **Google Drive API** in the Google Cloud Console.

---

## Setup and Installation

### 1. Clone the repository
### 2. Install dependencies
Run the following command in your terminal to install the necessary packages: flutter pub get
### 3. Configure Google Sheets API

This project uses a service account to interact with your Google Sheet. Follow these steps to set up your backend:

1.  Create a new Google Sheet to store your employee data.
2.  Enable the **Google Sheets API** and **Google Drive API** in the Google Cloud Console for your project.
3.  Create a **Service Account** and generate a JSON key file.
4.  Share your Google Sheet with the email address of the service account you created.
5.  Copy the credentials from the JSON key file into the `_credentials` variable in `UserSheetsApi.dart`.
6.  Update the `_spreadsheetId` variable in `UserSheetsApi.dart` with the ID of your Google Sheet. The ID is the long string of letters and numbers in the URL between `/d/` and `/edit`.

---

## Usage
The app's main functionality is handled by the `UserSheetsApi` class. When the app starts, it initializes a connection to the specified Google Sheet. It then reads a list of employee names from the "Employees" worksheet and creates a new worksheet for the current month if one doesn't exist.

The UI (which is not included in the provided code) should allow users to select their name and a clock-in/clock-out button. When a button is pressed, the app records the current time and writes it to the appropriate row and column in the timesheet.

## Project Structure
The project is structured with a clear separation of concerns:
* `employee.dart`: Defines the data model for an `Employee` object.
* `UserSheetsApi.dart`: Manages all logic for reading from and writing to the Google Sheet.

---
