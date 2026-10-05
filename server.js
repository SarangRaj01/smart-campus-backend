const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json()); // Parses incoming JSON data

// 1. Create Database Connection Pool
const db = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// 2. Test Connection
db.getConnection((err, connection) => {
    if (err) {
        console.error('❌ Database connection failed:', err.message);
    } else {
        console.log('✅ Connected to MySQL Database: smart_campus_db');
        connection.release();
    }
});

// 3. Test API Route
app.get('/api/test', (req, res) => {
    res.json({ message: 'Smart Campus Lost & Found Backend is Running!' });
});

// 4. Lost Items API Routes

// GET: Fetch all lost items with full details from joined tables
app.get('/api/lost-items', (req, res) => {
    const query = `
        SELECT 
            l.lost_id,
            u.full_name AS reported_by,
            c.category_name,
            loc.building_name,
            l.brand,
            l.primary_color,
            l.date_lost,
            l.time_lost,
            l.serial_number,
            l.description
        FROM LOST_ITEMS l
        JOIN USERS u ON l.user_id = u.user_id
        JOIN CATEGORIES c ON l.category_id = c.category_id
        JOIN LOCATIONS loc ON l.location_id = loc.location_id
        ORDER BY l.date_lost DESC;
    `;

    db.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching lost items:', err);
            return res.status(500).json({ error: 'Database query error' });
        }
        res.json(results);
    });
});

// POST: Report a new lost item
app.post('/api/lost-items', (req, res) => {
    const { user_id, category_id, location_id, brand, primary_color, date_lost, time_lost, serial_number, description } = req.body;

    const query = `
        INSERT INTO LOST_ITEMS 
        (user_id, category_id, location_id, brand, primary_color, date_lost, time_lost, serial_number, description)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    db.query(
        query, 
        [user_id, category_id, location_id, brand, primary_color, date_lost, time_lost, serial_number, description],
        (err, result) => {
            if (err) {
                console.error('Error inserting lost item:', err);
                return res.status(500).json({ error: 'Database insert error' });
            }
            res.status(201).json({ message: 'Lost item reported successfully!', insertId: result.insertId });
        }
    );
});

// 5. Start Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});