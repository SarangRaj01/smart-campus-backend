# 🏫 Smart Campus Lost & Found System — Backend API

![NodeJS](https://img.shields.io/badge/Node.js-v18+-green?style=for-the-badge&logo=node.js)
![ExpressJS](https://img.shields.io/badge/Express.js-4.x-black?style=for-the-badge&logo=express)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=for-the-badge&logo=mysql)
![License](https://img.shields.io/badge/License-MIT-orange?style=for-the-badge)

A RESTful backend API built to automate and streamline campus-wide lost and found item tracking, matching, and ownership verifications.

---

## 📌 System Architecture

The system utilizes a 3-tier structure connected to a 3rd Normal Form (3NF) relational database:

- **Runtime & Framework:** Node.js with Express.js
- **Database:** MySQL (`mysql2` connection pooling)
- **Tooling:** Nodemon, Dotenv, MySQL Workbench

---

## 🗄️ Database Structure

| Table Name | Description |
| :--- | :--- |
| `USERS` | Stores student, staff, and admin accounts |
| `LOST_ITEMS` | Records lost item submissions linked to categories and locations |
| `FOUND_ITEMS` | Records found item reports turned in across campus |
| `CATEGORIES` | Item classifications (Electronics, Keys, Documents, etc.) |
| `LOCATIONS` | Campus buildings and physical zones |
| `MATCH_RECORDS` | System-generated potential matches between lost and found items |
| `CLAIM_VERIFICATIONS` | Tracks ownership claim proofs and approval statuses |

---

## 🚀 API Routes

### Health Check
- `GET /api/test` — Server status confirmation

### Lost & Found Operations
- `GET /api/lost-items` — Retrieve all lost items with JOINed category/location details
- `POST /api/lost-items` — Submit a lost item report
- `GET /api/found-items` — Retrieve all logged found items
- `POST /api/found-items` — Submit a found item report

### Lookup & Automated Matching
- `GET /api/categories` — Fetch categories for frontend dropdowns
- `GET /api/locations` — Fetch campus locations for frontend dropdowns
- `GET /api/matches` — Fetch auto-matched lost and found pairs

### Claims
- `GET /api/claims` — List claim requests and statuses
- `POST /api/claims` — Submit an ownership verification claim

---

## ⚡ Setup & Installation

### 1. Clone & Install
```bash
git clone [https://github.com/SarangRaj01/Smart-campus-backend.git](https://github.com/SarangRaj01/Smart-campus-backend.git)
cd Smart-campus-backend
npm install