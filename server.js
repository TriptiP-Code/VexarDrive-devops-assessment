// VexarDrive - Fleet Ping Service (minimal demo backend)
// NOTE: This is a deliberately trimmed-down module extracted from a larger monorepo
// for the purposes of this assessment. Treat it as inherited legacy code.

require("dotenv").config();

const express = require("express");
const { Pool } = require("pg");
const jwt = require("jsonwebtoken");

const app = express();
app.use(express.json());

// -------------------------------------------------------------------
// Database Configuration
// -------------------------------------------------------------------

const DB_CONFIG = {
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
};

// Create a single connection pool for the entire application
const pool = new Pool(DB_CONFIG);

const JWT_SECRET = process.env.JWT_SECRET;

// -------------------------------------------------------------------
// Routes
// -------------------------------------------------------------------

app.get("/", (req, res) => {
  res.send("VexarDrive Fleet Ping Service is running");
});

// Fleet vehicle ping ingestion
app.post("/api/fleet/ping", async (req, res) => {
  const { vehicleId, lat, lng, speed, timestamp } = req.body;

  try {
    await pool.query(
      `INSERT INTO fleet_pings (vehicle_id, lat, lng, speed, ts)
       VALUES ($1, $2, $3, $4, $5)`,
      [vehicleId, lat, lng, speed, timestamp]
    );

    res.json({ status: "ok" });
  } catch (err) {
    console.error("Fleet Ping Error:", err);
    res.status(500).json({ error: "Insert failed" });
  }
});

// Driver login
app.post("/api/auth/login", async (req, res) => {
  const { phone, otp } = req.body;

  try {
    const result = await pool.query(
  `SELECT * FROM drivers WHERE phone = $1`,
  [phone]
);

    if (result.rows.length === 0) {
      return res.status(401).json({ error: "Driver not found" });
    }

    const token = jwt.sign(
      { driverId: result.rows[0].id },
      JWT_SECRET,
      {
        expiresIn: "30d",
      }
    );

    res.json({ token });
  } catch (err) {
    console.error("Login Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// Admin endpoint
app.get("/api/admin/drivers", async (req, res) => {
  try {
    const result = await pool.query(`SELECT * FROM drivers`);
    res.json(result.rows);
  } catch (err) {
    console.error("Admin API Error:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "UP",
    service: "Fleet Ping Service",
    timestamp: new Date().toISOString(),
  });
});

app.get("/ready", async (req, res) => {
  try {
    await pool.query("SELECT 1");

    res.status(200).json({
      status: "READY",
      database: "Connected",
    });
  } catch (err) {
    res.status(503).json({
      status: "NOT_READY",
      database: "Unavailable",
    });
  }
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});

module.exports = app;