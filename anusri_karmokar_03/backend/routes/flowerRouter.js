const express = require('express');
const Flower = require('../models/Flower');

const router = express.Router();

router.get('/', async (request, response) => {
    const flowers = await Flower.find();
    response.status(200).json(flowers);
});

router.get('/:id', async (request, response) => {{
    try{
        const flower = await Flower.findById(request.params.id);
        if(!flower){
            return response.status(404).json({message: 'Flower not found'});
        }
        response.status(200).json(flower);
    } catch(error){
        response.status(500).json({message: error.message});
    }
}});

router.post('/', async (request, response) => {
    try{
        const {name, description, imageUrl, pdfUrl} = request.body;

        const newFlower = {
            name,
            description,
            imageUrl,
            pdfUrl
        };

        const flower = new Flower(newFlower);
        await flower.save();

        response.status(201).json({message: 'Flower added successfully'});    
    } catch(error){
    response.status(500).json({message: error.message});
}
});

router.put('/:id', async (request, response) => {
  try {
    const flower = await Flower.findByIdAndUpdate(
      request.params.id,
      request.body,
      { new: true }
    );

    if (!flower) {
      return response.status(404).json({ message: "Flower not found" });
    }

    response.status(200).json({ message: "Flower updated successfully" });
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

router.delete('/:id', async (request, response) => {
  try {
    const flower = await Flower.findByIdAndDelete(request.params.id);

    if (!flower) {
      return response.status(404).json({ message: "Flower not found" });
    }

    response.status(200).json({ message: "Flower deleted successfully" });
  } catch (error) {
    response.status(500).json({ message: error.message });
  }
});

module.exports = router;
