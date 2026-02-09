const mongoose = require('mongoose');

mongoose.connect('mongodb+srv://jeevan04:{MyPasswordHideduetoSecurityreasons}@cluster0.vlk2gka.mongodb.net/flower_app?retryWrites=true&w=majority&appName=Cluster0');

const db = mongoose.connection;

db.on('connected', () => {
    console.log('MongoDB connected successfully');
})

db.on('disconnected', () => {
    console.log('MongoDB disconnected');
})

db.on('error', (error) => {
    console.error('MongoDB connection error:', error);
});

module.exports = db;