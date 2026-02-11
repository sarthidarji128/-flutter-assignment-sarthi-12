const mongoose = require('mongoose');

const flowerSchema = {
    name: {
        type: String,
        required: true
    },
    description: {
        type: String,
        required: true
    },
    imageUrl: {
        type: String,
        required: false
    },
    pdfUrl: {
        type: String,
        required: false
    }
}

const Flower = new mongoose.model('Flower', flowerSchema);
module.exports = Flower;