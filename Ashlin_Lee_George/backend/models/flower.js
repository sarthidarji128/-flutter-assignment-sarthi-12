const mongoose=require('mongoose');


const flowerSchema={
    name:{
        type:String,
        required:true
    },
    description:{
        type:String,
        required:true

    },
    imageUrl:{
        type:String,
        required:true
    },
    pdfUrl:{
        type:String,
        required:true
    },

}


const Flower=new mongoose.model('Flower',flowerSchema);
module.exports=Flower;
