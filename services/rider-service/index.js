require('dotenv').config();
const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3002;

app.use(cors());
app.use(express.json());

// Mock Data for Server-Driven UI
const HOME_CONFIG = {
    featureFlags: {
        sharedRidesEnabled: false,
        surgeBannerEnabled: true,
    },
    vehicleTypes: [
        {
            id: 'uber-x',
            name: 'UberX',
            etaMinutes: 3,
            baseFare: 12.50,
            surgeMultiplier: 1.0,
            iconUrl: 'https://raw.githubusercontent.com/google/material-design-icons/master/png/maps/directions_car/materialicons/24dp/1x/baseline_directions_car_black_24dp.png', // Placeholder
        },
        {
            id: 'uber-xl',
            name: 'UberXL',
            etaMinutes: 5,
            baseFare: 18.50,
            surgeMultiplier: 1.0,
            iconUrl: 'https://raw.githubusercontent.com/google/material-design-icons/master/png/maps/local_shipping/materialicons/24dp/1x/baseline_local_shipping_black_24dp.png', // Placeholder
        },
    ],
    actionCards: [
        {
            type: 'safety_banner',
            priority: 1,
            data: {
                title: 'Ride with confidence',
                subtitle: 'Verify your driver using PIN',
            },
        },
        {
            type: 'promo_banner',
            priority: 2,
            data: {
                code: 'SAVE20',
                discount: '20% off',
                expiry: '2025-12-31T23:59:59Z',
            },
        },
    ],
};

app.get('/api/v1/rider/home-config', (req, res) => {
    // In a real app, we'd check lat/lng from query params to determine available services
    res.json(HOME_CONFIG);
});

app.get('/api/v1/vehicles/nearby', (req, res) => {
    const { lat, lng } = req.query;
    const centerLat = parseFloat(lat) || 40.7128;
    const centerLng = parseFloat(lng) || -74.0060;

    // Generate random vehicles around the center
    const vehicles = [
        { id: 'v_1', lat: centerLat + 0.001, lng: centerLng + 0.001, heading: 45, type: 'uber-x', driverId: 'd_1' },
        { id: 'v_2', lat: centerLat - 0.002, lng: centerLng + 0.002, heading: 180, type: 'uber-x', driverId: 'd_2' },
        { id: 'v_3', lat: centerLat + 0.0015, lng: centerLng - 0.001, heading: 270, type: 'uber-xl', driverId: 'd_3' },
    ];
    res.json(vehicles);
});

const server = app.listen(PORT, () => {
    console.log(`Rider service running on port ${PORT}`);
});

// WebSocket Setup
const WebSocket = require('ws');
const wss = new WebSocket.Server({ server });

wss.on('connection', (ws) => {
    console.log('Client connected');
    ws.on('close', () => console.log('Client disconnected'));
});

// Simulate Vehicle Movement
const vehicles = [
    { id: 'v_1', lat: 40.7138, lng: -74.005, heading: 45, type: 'uber-x', driverId: 'd_1' },
    { id: 'v_2', lat: 40.7108, lng: -74.004, heading: 180, type: 'uber-x', driverId: 'd_2' },
    { id: 'v_3', lat: 40.7143, lng: -74.007, heading: 270, type: 'uber-xl', driverId: 'd_3' },
];

setInterval(() => {
    vehicles.forEach(v => {
        // Random small movement
        v.lat += (Math.random() - 0.5) * 0.0005;
        v.lng += (Math.random() - 0.5) * 0.0005;
        v.heading = (v.heading + (Math.random() - 0.5) * 10) % 360;
    });

    const data = JSON.stringify({ type: 'vehicle_update', vehicles });
    wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(data);
        }
    });
}, 3000); // Update every 3 seconds
