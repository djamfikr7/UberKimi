require('dotenv').config();
const { Client } = require('pg');

const dbName = process.env.DATABASE_URL.split('/').pop();
const connectionString = process.env.DATABASE_URL.replace(`/${dbName}`, '/postgres');

async function createDb() {
    const client = new Client({ connectionString });
    try {
        await client.connect();
        const res = await client.query(`SELECT 1 FROM pg_database WHERE datname = '${dbName}'`);
        if (res.rowCount === 0) {
            await client.query(`CREATE DATABASE "${dbName}"`);
            console.log(`Database ${dbName} created successfully`);
        } else {
            console.log(`Database ${dbName} already exists`);
        }
    } catch (err) {
        console.error('Error creating database:', err);
    } finally {
        await client.end();
    }
}

createDb();
