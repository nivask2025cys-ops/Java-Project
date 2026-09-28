# RIDESHARELITE – OFFICE/COLLEGE CARPOOL MATCHING PLATFORM

A complete, beginner-friendly **Full-Stack Application** (Spring Boot REST API Backend + Modern Interactive Responsive Web Frontend) for an office and college carpooling platform built with **Java 17**, **Spring Boot 3.x**, and **MySQL**.

---

## 📌 Table of Contents
1. [Project Overview](#-project-overview)
2. [Problem Statement](#-problem-statement)
3. [Full-Stack Architecture & Features](#-full-stack-architecture--features)
4. [Technologies Used](#-technologies-used)
5. [Architecture](#-architecture)
6. [Database Design & Relationships](#-database-design--relationships)
7. [Business Rules](#-business-rules)
8. [MySQL Database Setup](#-mysql-database-setup)
9. [Application Configuration](#-application-configuration)
10. [How to Run the Application (Frontend + Backend)](#-how-to-run-the-application)
11. [Frontend User Interface Guide](#-frontend-user-interface-guide)
12. [REST API Endpoints](#-rest-api-endpoints)
13. [Complete Postman Testing Sequence](#-complete-postman-testing-sequence)
14. [Sample Requests & Responses](#-sample-requests--responses)

---

## 📖 Project Overview
**RideShareLite** is a complete, monolithic full-stack application designed to simplify daily commuting for office colleagues and college students:
- **Backend**: Spring Boot 3.x REST API with Spring Data JPA and MySQL database.
- **Frontend**: Clean, responsive, modern Single-Page Application (SPA) served directly by Spring Boot at `http://localhost:8080/`. Requires zero Node.js / React build steps, zero CORS setup, and runs immediately out of the box!

---

## 🎯 Problem Statement
Daily commuting between towns and colleges or workplaces causes high travel costs, traffic congestion, and carbon emissions. Public transit schedules often do not match commuting needs, and personal vehicle drivers frequently travel with empty seats. **RideShareLite** bridges this gap by providing an easy-to-use, transparent carpool matching service with strict business logic to prevent overbooking and invalid requests.

---

## ✨ Full-Stack Architecture & Features
- **Interactive Web UI**:
  - **Dashboard**: Real-time counter metrics (Users, Rides, Pending Requests, Approved Seats) and recent activity.
  - **Ride Search & Booking**: Real-time search by origin and destination, displaying available seats with an instant "Request Seat" modal.
  - **Publish Ride**: Intuitive form with datetime picker, driver selection, and seat capacity.
  - **Requests & Approval Console**: Status badges (`PENDING`, `APPROVED`, `REJECTED`) with 1-click **Approve** (automatically decrements seats) and **Reject** buttons.
  - **User History**: Dropdown selector to review driver rides and rider requests.
  - **User Management**: Register users, edit contact info, and delete accounts.
  - **Active Persona Switcher**: Switch active user with one click to easily test all 5 business rules.
- **Robust REST API Backend**:
  - Full CRUD operations for Users, Ride Offers, and Ride Requests.
  - Automatic seat decrement and status enforcement in the Service layer.
  - Centralized `@RestControllerAdvice` error handling returning clean JSON error responses.

---

## 🛠 Technologies Used
- **Java 17** (LTS)
- **Spring Boot 3.x**
- **Spring Web** (Spring MVC REST controllers)
- **Spring Data JPA** (Hibernate ORM)
- **MySQL 8.0+**
- **Jakarta Validation** (`@NotBlank`, `@Email`, `@Positive`, `@NotNull`)
- **Maven** (Dependency management and build tool)
- **H2 Database** (Used exclusively for automated tests without requiring live MySQL)

---

## 🏗 Architecture
The application follows standard 3-tier monolithic Spring architecture:

```
[ HTTP Requests / Postman / Client ]
                 ↓
     Controller Layer (@RestController)
        - UserController
        - RideOfferController
        - RideRequestController
                 ↓
      Service Layer (@Service)
        - UserService
        - RideOfferService
        - RideRequestService
                 ↓
    Repository Layer (@Repository)
        - UserRepository
        - RideOfferRepository
        - RideRequestRepository
                 ↓
           MySQL Database
        - users
        - ride_offers
        - ride_requests
```

### Folder Structure
```
src/
├── main/
│   ├── java/com/ridesharelite/
│   │   ├── RideShareLiteApplication.java
│   │   ├── controller/
│   │   │   ├── UserController.java
│   │   │   ├── RideOfferController.java
│   │   │   └── RideRequestController.java
│   │   ├── service/
│   │   │   ├── UserService.java
│   │   │   ├── RideOfferService.java
│   │   │   └── RideRequestService.java
│   │   ├── repository/
│   │   │   ├── UserRepository.java
│   │   │   ├── RideOfferRepository.java
│   │   │   └── RideRequestRepository.java
│   │   ├── entity/
│   │   │   ├── User.java
│   │   │   ├── RideOffer.java
│   │   │   ├── RideRequest.java
│   │   │   └── RequestStatus.java
│   │   ├── dto/
│   │   │   ├── UserDTO.java
│   │   │   ├── RideOfferDTO.java
│   │   │   ├── RideOfferResponseDTO.java
│   │   │   ├── RideRequestDTO.java
│   │   │   ├── RideRequestResponseDTO.java
│   │   │   ├── UserHistoryDTO.java
│   │   │   └── ErrorResponse.java
│   │   └── exception/
│   │       ├── ResourceNotFoundException.java
│   │       ├── BusinessException.java
│   │       └── GlobalExceptionHandler.java
│   └── resources/
│       └── application.properties
└── test/
    ├── java/com/ridesharelite/
    │   ├── RideShareLiteApplicationTests.java
    │   └── service/
    │       └── CarpoolBusinessRulesTest.java
    └── resources/
        └── application.properties
```

---

## 🗄 Database Design & Relationships

### Entity 1: User (`users`)
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique user ID |
| `name` | VARCHAR(255) | NOT NULL | User's full name |
| `email` | VARCHAR(255) | NOT NULL, UNIQUE | User's email address |
| `phone` | VARCHAR(255) | NOT NULL | User's phone number |

### Entity 2: RideOffer (`ride_offers`)
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique ride offer ID |
| `driver_id` | BIGINT | FOREIGN KEY (`users.id`), NOT NULL | Driver user ID |
| `origin` | VARCHAR(255) | NOT NULL | Starting point (e.g., Thanjavur) |
| `destination` | VARCHAR(255) | NOT NULL | End point (e.g., College) |
| `departure_time` | DATETIME | NOT NULL | Ride departure date and time |
| `available_seats` | INT | NOT NULL | Number of open seats available |

### Entity 3: RideRequest (`ride_requests`)
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique request ID |
| `rider_id` | BIGINT | FOREIGN KEY (`users.id`), NOT NULL | Requesting user ID |
| `ride_id` | BIGINT | FOREIGN KEY (`ride_offers.id`), NOT NULL | Requested ride ID |
| `status` | VARCHAR(50) | NOT NULL | Enum: `PENDING`, `APPROVED`, `REJECTED` |

### Relationships:
```
users (1) ───────< (Many) ride_offers (driver_id)
users (1) ───────< (Many) ride_requests (rider_id)
ride_offers (1) ──< (Many) ride_requests (ride_id)
```

---

## ⚖️ Business Rules

All business rules are strictly implemented in the **Service Layer**:

1. **Rule 1 - No Self-Booking**: A user cannot request a seat on their own ride.
   - *Error*: `400 BAD REQUEST`
   - *Message*: `"Driver cannot request a seat on their own ride."`
2. **Rule 2 - Seat Capacity Limit**: A request cannot be approved when available seats are zero (`availableSeats == 0`).
   - *Error*: `400 BAD REQUEST`
   - *Message*: `"Cannot approve request. No seats available."`
3. **Rule 3 - Seat Reduction on Approval**: When a request is approved, `availableSeats` decreases by 1.
4. **Rule 4 - Seat Preservation on Rejection**: When a request is rejected, `availableSeats` remains unchanged.
5. **Rule 5 - State Transition**: Only `PENDING` requests can be approved or rejected. Attempting to approve or reject an already approved/rejected request returns `400 BAD REQUEST` (`"Only PENDING requests can be approved or rejected."`).

---

## 🐬 MySQL Database Setup

1. Open MySQL command line client or MySQL Workbench:
```sql
mysql -u root -p
```
2. Create the database:
```sql
CREATE DATABASE ridesharelite;
```
3. Verify creation:
```sql
SHOW DATABASES;
```

---

## ⚙️ Application Configuration

Open `src/main/resources/application.properties`:

```properties
# Server Port
server.port=8080

# MySQL Database Configuration
# REPLACE 'YOUR_PASSWORD' with your actual MySQL root password!
spring.datasource.url=jdbc:mysql://localhost:3306/ridesharelite?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA / Hibernate Configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
```

> **IMPORTANT**:
> In `spring.datasource.password=YOUR_PASSWORD`, replace `YOUR_PASSWORD` with your actual MySQL password (for example: `root`, `admin123`, `mysql`, etc.).

---

## 🚀 How to Run the Application

### Option 1: Using Maven Command Line
In the root directory of the project:
```bash
mvn clean spring-boot:run
```

### Option 2: Build JAR and Run
```bash
mvn clean package -DskipTests
java -jar target/ridesharelite-1.0.0.jar
```

### Option 3: From IDE (IntelliJ IDEA / Eclipse / VS Code)
1. Open the project folder in your IDE.
2. Allow Maven to import dependencies.
3. Locate `src/main/java/com/ridesharelite/RideShareLiteApplication.java`.
4. Right-click and select **Run 'RideShareLiteApplication'**.
5. Server will start at `http://localhost:8080`.
6. Open your web browser and navigate to:
   👉 **`http://localhost:8080`**
   The complete carpool dashboard frontend will load immediately!

---

## 🖥️ Frontend User Interface Guide

The embedded frontend provides an intuitive web interface for all carpooling operations:

### 1. Dashboard (`/`)
- **Key Metrics Counters**: Displays live counts for registered users, rides published, pending requests, and approved seats.
- **Recent Activity**: Glance at currently open ride offers and the latest incoming requests.

### 2. Search & Book Rides
- Enter **Origin** and **Destination** (e.g., "Thanjavur" to "College").
- Filter results with positive available seats.
- Click **"Request Seat"** on any ride card to open the booking dialog.

### 3. Publish a Ride Offer
- Select the driver user.
- Enter origin, destination, departure datetime, and available seats.
- Submit to publish instantly.

### 4. Requests & Approval Console
- View all carpool requests with status badges (`PENDING`, `APPROVED`, `REJECTED`).
- Filter by status using the filter pills.
- **Approve Button (`✓`)**: Calls `PUT /api/requests/{id}/approve`, marks request as `APPROVED`, and decrements available seats by 1 in real time.
- **Reject Button (`✗`)**: Calls `PUT /api/requests/{id}/reject`, marks request as `REJECTED`, preserving available seats.

### 5. User Carpool History
- Choose any registered user from the dropdown.
- Compares **Rides Offered (Driver)** vs. **Seat Requests Made (Rider)** side-by-side.

### 6. Persona Switcher
- Use the **"Active Persona"** selector in the top navbar to switch users instantly when testing.
- Test Business Rule 1 by trying to request a seat on a ride published by your active persona!

---

## 📡 REST API Endpoints

### 1. User APIs
| Method | Endpoint | Description | Status Code |
|---|---|---|---|
| `POST` | `/api/users` | Register a new user | 201 Created |
| `GET` | `/api/users` | Retrieve all users | 200 OK |
| `GET` | `/api/users/{id}` | Retrieve user by ID | 200 OK |
| `PUT` | `/api/users/{id}` | Update user details | 200 OK |
| `DELETE` | `/api/users/{id}` | Delete user by ID | 200 OK |
| `GET` | `/api/users/{userId}/history` | Get carpool history for user | 200 OK |

### 2. Ride Offer APIs
| Method | Endpoint | Description | Status Code |
|---|---|---|---|
| `POST` | `/api/rides` | Publish a new ride offer | 201 Created |
| `GET` | `/api/rides` | Retrieve all ride offers | 200 OK |
| `GET` | `/api/rides/{id}` | Retrieve ride offer by ID | 200 OK |
| `PUT` | `/api/rides/{id}` | Update ride offer details | 200 OK |
| `DELETE` | `/api/rides/{id}` | Delete ride offer by ID | 200 OK |
| `GET` | `/api/rides/search` | Search rides by `origin` & `destination` | 200 OK |

### 3. Ride Request APIs
| Method | Endpoint | Description | Status Code |
|---|---|---|---|
| `POST` | `/api/requests` | Create a ride request (default `PENDING`) | 201 Created |
| `GET` | `/api/requests` | Retrieve all ride requests | 200 OK |
| `GET` | `/api/requests/{id}` | Retrieve ride request by ID | 200 OK |
| `PUT` | `/api/requests/{id}` | Update ride request | 200 OK |
| `DELETE` | `/api/requests/{id}` | Delete ride request by ID | 200 OK |
| `PUT` | `/api/requests/{id}/approve` | Approve request (decreases seats by 1) | 200 OK |
| `PUT` | `/api/requests/{id}/reject` | Reject request (seats unchanged) | 200 OK |

---

## 🧪 Complete Postman Testing Sequence

Follow this exact 22-step sequence to test all features and business rules:

### Step 1: Create User 1 (Driver: Arun)
- **Method**: `POST`
- **URL**: `http://localhost:8080/api/users`
- **Headers**: `Content-Type: application/json`
- **Request Body**:
```json
{
    "name": "Arun",
    "email": "arun@gmail.com",
    "phone": "9876543210"
}
```
- **Response**: `201 Created`
```json
{
    "id": 1,
    "name": "Arun",
    "email": "arun@gmail.com",
    "phone": "9876543210"
}
```

---

### Step 2: Create User 2 (Rider: Bala)
- **Method**: `POST`
- **URL**: `http://localhost:8080/api/users`
- **Headers**: `Content-Type: application/json`
- **Request Body**:
```json
{
    "name": "Bala",
    "email": "bala@gmail.com",
    "phone": "9876543211"
}
```
- **Response**: `201 Created` (ID: 2)

---

### Step 3: Create User 3 (Rider: Chitra)
- **Method**: `POST`
- **URL**: `http://localhost:8080/api/users`
- **Headers**: `Content-Type: application/json`
- **Request Body**:
```json
{
    "name": "Chitra",
    "email": "chitra@gmail.com",
    "phone": "9876543212"
}
```
- **Response**: `201 Created` (ID: 3)

---

### Step 4: Get All Users
- **Method**: `GET`
- **URL**: `http://localhost:8080/api/users`
- **Response**: `200 OK` (List containing Arun, Bala, and Chitra)

---

### Step 5: Create a Ride Using User 1 (Arun)
- **Method**: `POST`
- **URL**: `http://localhost:8080/api/rides`
- **Headers**: `Content-Type: application/json`
- **Request Body**:
```json
{
    "driverId": 1,
    "origin": "Thanjavur",
    "destination": "College",
    "departureTime": "2026-09-29T08:00:00",
    "availableSeats": 2
}
```
- **Response**: `201 Created`
```json
{
    "id": 1,
    "driverId": 1,
    "driverName": "Arun",
    "driverEmail": "arun@gmail.com",
    "driverPhone": "9876543210",
    "origin": "Thanjavur",
    "destination": "College",
    "departureTime": "2026-09-29T08:00:00",
    "availableSeats": 2
}
```

---

### Step 6: Get All Rides
- **Method**: `GET`
- **URL**: `http://localhost:8080/api/rides`
- **Response**: `200 OK` (Array with Ride ID 1)

---

### Step 7: Search Rides
- **Method**: `GET`
- **URL**: `http://localhost:8080/api/rides/search?origin=Thanjavur&destination=College`
- **Response**: `200 OK`
```json
[
    {
        "id": 1,
        "driverId": 1,
        "driverName": "Arun",
        "driverEmail": "arun@gmail.com",
        "driverPhone": "9876543210",
        "origin": "Thanjavur",
        "destination": "College",
        "departureTime": "2026-09-29T08:00:00",
        "availableSeats": 2
    }
]
```

---

### Step 8: User 2 (Bala) Creates a Ride Request
- **Method**: `POST`
- **URL**: `http://localhost:8080/api/requests`
- **Headers**: `Content-Type: application/json`
- **Request Body**:
```json
{
    "riderId": 2,
    "rideId": 1
}
```
- **Response**: `201 Created`
```json
{
    "id": 1,
    "riderId": 2,
    "riderName": "Bala",
    "riderPhone": "9876543211",
    "rideId": 1,
    "driverId": 1,
    "driverName": "Arun",
    "origin": "Thanjavur",
    "destination": "College",
    "departureTime": "2026-09-29T08:00:00",
    "status": "PENDING"
}
```

---

### Step 9: Get All Requests
- **Method**: `GET`
- **URL**: `http://localhost:8080/api/requests`
- **Response**: `200 OK` (Array showing Request 1 with status `PENDING`)

---

### Step 10: Approve Request 1
- **Method**: `PUT`
- **URL**: `http://localhost:8080/api/requests/1/approve`
- **Response**: `200 OK`
```json
{
    "id": 1,
    "riderId": 2,
    "riderName": "Bala",
    "riderPhone": "9876543211",
    "rideId": 1,
    "driverId": 1,
    "driverName": "Arun",
    "origin": "Thanjavur",
    "destination": "College",
    "departureTime": "2026-09-29T08:00:00",
    "status": "APPROVED"
}
```

---

### Step 11: Verify Available Seats Decreased
- **Method**: `GET`
- **URL**: `http://localhost:8080/api/rides/1`
- **Response**: `200 OK`
- Notice `availableSeats` has decreased from `2` to `1`:
```json
{
    "id": 1,
    "driverId": 1,
    "driverName": "Arun",
    "origin": "Thanjavur",
    "destination": "College",
    "departureTime": "2026-09-29T08:00:00",
    "availableSeats": 1
}
```

---

### Step 12: User 3 (Chitra) Creates Request and It Is Rejected
First create request:
- **Method**: `POST`
- **URL**: `http://localhost:8080/api/requests`
- **Request Body**:
```json
{
    "riderId": 3,
    "rideId": 1
}
```
- **Response**: `201 Created` (Request ID: 2)

Now reject request 2:
- **Method**: `PUT`
- **URL**: `http://localhost:8080/api/requests/2/reject`
- **Response**: `200 OK`
```json
{
    "id": 2,
    "riderId": 3,
    "riderName": "Chitra",
    "status": "REJECTED"
}
```

---

### Step 13: Verify Seats Did Not Decrease on Rejection
- **Method**: `GET`
- **URL**: `http://localhost:8080/api/rides/1`
- **Response**: `200 OK`
- `availableSeats` is still `1`.

---

### Step 14: Try Requesting Own Ride (Rule 1 Test)
User 1 (Arun) tries to request seat on Ride 1 (Arun's own ride):
- **Method**: `POST`
- **URL**: `http://localhost:8080/api/requests`
- **Request Body**:
```json
{
    "riderId": 1,
    "rideId": 1
}
```

---

### Step 15: Verify Business Rule Error
- **Response**: `400 Bad Request`
```json
{
    "status": 400,
    "message": "Driver cannot request a seat on their own ride."
}
```

---

### Step 16: Set Seats to Zero
Approve another request or update ride seats to 0:
- **Method**: `PUT`
- **URL**: `http://localhost:8080/api/rides/1`
- **Request Body**:
```json
{
    "driverId": 1,
    "origin": "Thanjavur",
    "destination": "College",
    "departureTime": "2026-09-29T08:00:00",
    "availableSeats": 0
}
```
*(Alternatively, create and approve another request so available seats reach 0 naturally)*

---

### Step 17: Try Approving a Request When Seats Are Zero
Create a new request for this ride and try to approve it:
- **Method**: `PUT`
- **URL**: `http://localhost:8080/api/requests/{id}/approve`

---

### Step 18: Verify "No seats available" Error
- **Response**: `400 Bad Request`
```json
{
    "status": 400,
    "message": "Cannot approve request. No seats available."
}
```

---

### Step 19: View User Carpool History
View history for User 1 (Arun):
- **Method**: `GET`
- **URL**: `http://localhost:8080/api/users/1/history`
- **Response**: `200 OK`
```json
{
    "driverRides": [
        {
            "id": 1,
            "driverId": 1,
            "driverName": "Arun",
            "driverEmail": "arun@gmail.com",
            "driverPhone": "9876543210",
            "origin": "Thanjavur",
            "destination": "College",
            "departureTime": "2026-09-29T08:00:00",
            "availableSeats": 1
        }
    ],
    "riderRequests": []
}
```

View history for User 2 (Bala):
- **Method**: `GET`
- **URL**: `http://localhost:8080/api/users/2/history`
- **Response**: `200 OK`
```json
{
    "driverRides": [],
    "riderRequests": [
        {
            "id": 1,
            "riderId": 2,
            "riderName": "Bala",
            "riderPhone": "9876543211",
            "rideId": 1,
            "driverId": 1,
            "driverName": "Arun",
            "origin": "Thanjavur",
            "destination": "College",
            "departureTime": "2026-09-29T08:00:00",
            "status": "APPROVED"
        }
    ]
}
```

---

### Step 20: Update a User
- **Method**: `PUT`
- **URL**: `http://localhost:8080/api/users/2`
- **Request Body**:
```json
{
    "name": "Bala Subramanian",
    "email": "bala.subramanian@gmail.com",
    "phone": "9876543299"
}
```
- **Response**: `200 OK` (User updated)

---

### Step 21: Update a Ride
- **Method**: `PUT`
- **URL**: `http://localhost:8080/api/rides/1`
- **Request Body**:
```json
{
    "driverId": 1,
    "origin": "Thanjavur Old Bus Stand",
    "destination": "College Main Gate",
    "departureTime": "2026-09-29T08:30:00",
    "availableSeats": 3
}
```
- **Response**: `200 OK` (Ride updated)

---

### Step 22: Delete User / Ride / Request
- **Delete Request**:
  - `DELETE http://localhost:8080/api/requests/2`
  - Response: `200 OK` (`"Ride request deleted successfully with id: 2"`)
- **Delete Ride**:
  - `DELETE http://localhost:8080/api/rides/1`
  - Response: `200 OK` (`"Ride deleted successfully with id: 1"`)
- **Delete User**:
  - `DELETE http://localhost:8080/api/users/3`
  - Response: `200 OK` (`"User deleted successfully with id: 3"`)

---

## 🛡 Exception Handling Format

All errors return clean, predictable JSON schemas:

### Resource Not Found (404)
```json
{
    "status": 404,
    "message": "User not found with id: 99"
}
```

### Business Rule Violation (400)
```json
{
    "status": 400,
    "message": "Cannot approve request. No seats available."
}
```

### Input Validation Error (400)
```json
{
    "status": 400,
    "message": "Email must be valid, Name cannot be empty"
}
```
