require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { WebSocketServer } = require('ws');

const app = express();
const PORT = process.env.PORT || 3003;

app.use(cors());
app.use(express.json());

// Mock Database for Trips
const trips = new Map();

app.get('/health', (req, res) => {
    res.json({ status: 'ok', service: 'trip-service' });
});

// 1. Estimate Fare
app.post('/api/v1/trip/estimate', (req, res) => {
    const { pickup, dropoff } = req.body;

    // Mock calculation: Random distance between 2-15 km
    const distanceKm = Math.floor(Math.random() * 13) + 2;
    const durationMin = Math.floor(distanceKm * 3.5); // Rough traffic est

    // Base rates
    const estimates = [
        {
            id: 'uber_x',
            name: 'UberX',
            price: (5 + (distanceKm * 1.5) + (durationMin * 0.2)).toFixed(2),
            currency: 'USD',
            eta: durationMin,
            image: 'assets/car_top_view.png'
        },
        {
            id: 'uber_xl',
            name: 'UberXL',
            price: (8 + (distanceKm * 2.5) + (durationMin * 0.3)).toFixed(2),
            currency: 'USD',
            eta: durationMin,
            image: 'assets/car_top_view_xl.png'
        }
    ];

    res.json({
        distanceKm,
        durationMin,
        estimates
    });
});

// 2. Request Trip
app.post('/api/v1/trip/request', (req, res) => {
    const { riderId, pickup, dropoff, serviceId, fare } = req.body;

    const tripId = `trip_${Date.now()}`;
    const trip = {
        id: tripId,
        riderId,
        pickup,
        dropoff,
        serviceId,
        fare,
        status: 'SEARCHING', // Initial status
        createdAt: new Date()
    };

    trips.set(tripId, trip);

    // Simulate Driver Matching (Mock) - REMOVED for Phase 3 Part 2 (Real Driver)
    // setTimeout(() => {
    //     updateTripStatus(tripId, 'DRIVER_ASSIGNED');
    // }, 5000); 

    // Broadcast to Online Drivers
    updateTripStatus(tripId, 'SEARCHING');

    res.json({ status: 'ok', tripId, message: 'Looking for drivers...' });
});

const server = app.listen(PORT, () => {
    console.log(`Trip service running on port ${PORT}`);
});

// WebSocket for Status Updates
const wss = new WebSocketServer({ server });

wss.on('connection', (ws) => {
    console.log('Client connected to Trip WebSocket');

    ws.on('message', (message) => {
        try {
            const data = JSON.parse(message);
            if (data.type === 'subscribe_trip') {
                ws.tripId = data.tripId;
                console.log(`Client subscribed to trip ${data.tripId}`);
            } else if (data.type === 'register_driver') {
                ws.driverId = data.driverId;
                ws.isDriver = true;
                console.log(`Driver ${data.driverId} registered and is ONLINE`);
            } else if (data.type === 'accept_trip') {
                console.log(`Driver ${data.driverId} accepted trip ${data.tripId}`);
                updateTripStatus(data.tripId, 'DRIVER_ASSIGNED');
            }
        } catch (e) {
            console.error('WS Error:', e);
        }
    });
});

function updateTripStatus(tripId, status) {
    const trip = trips.get(tripId);
    if (trip) {
        trip.status = status;
        console.log(`Trip ${tripId} status updated to ${status}`);

        // Broadcast to relevant clients
        wss.clients.forEach(client => {
            // Send to Rider (subscribed to trip)
            if (client.readyState === 1 && client.tripId === tripId) {
                client.send(JSON.stringify({
                    type: 'trip_update',
                    tripId,
                    status,
                    driver: status === 'DRIVER_ASSIGNED' ? {
                        name: 'John Doe',
                        rating: 4.9,
                        vehicle: 'Toyota Camry',
                        plate: 'ABC-1234'
                    } : null
                }));
            }

            // Send to Drivers (if searching)
            if (status === 'SEARCHING' && client.isDriver && client.readyState === 1) {
                console.log(`Broadcasting trip ${tripId} to driver ${client.driverId}`);
                client.send(JSON.stringify({
                    type: 'trip_request',
                    trip
                }));
            }
        });
    }
}
