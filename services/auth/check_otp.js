require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
});

async function checkOtp() {
    try {
        const res = await pool.query("SELECT * FROM otps ORDER BY created_at DESC LIMIT 1");
        console.log('Latest OTP:', res.rows[0]);
    } catch (err) {
        console.error('DB Error:', err);
    } finally {
        pool.end();
    }
}

checkOtp();
