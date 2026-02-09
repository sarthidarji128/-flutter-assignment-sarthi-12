const express = require('express');
const Flower = require('../models/Flower');
const router = express.Router();

router.get('/', async (req, res) => {
    const flowers = await Flower.find();
    res.status(200).json(flowers);
});

router.get('/:id', async (req, res) => {
    try {
        const flower = await Flower.findById(req.params.id);
        if (!flower) {
            return res.status(404).json({ message: 'Flower not found' });
        }
        res.status(200).json(flower);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.post('/', async (req, res) => {
    try {
        const { name, description, imageUrl, pdfUrl } = req.body;

        const newFlower = {
            name,
            description,
            imageUrl,
            pdfUrl
        };

        const flower = new Flower(newFlower);
        await flower.save();
        res.status(201).json({ message: 'Flower added successfully' });

    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.put('/:id', async (req, res) => {
    try {
        ;
        const flower = await Flower.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!flower) {
            return res.status(404).json({ message: 'Flower not found' });
        }
        res.status(200).json({ message: 'Flower updated successfully' });

    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.delete('/:id', async (req, res) => {
    try {
        const flower = await Flower.findByIdAndDelete(req.params.id);
        if (!flower) {
            return res.status(404).json({ message: 'Flower not found' });
        }
        res.status(200).json({ message: 'Flower deleted successfully' });

    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;