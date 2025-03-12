const mongoose=require("mongoose")


const addbookSchema=new mongoose.Schema({
    bookName:{
        type:String,
        required:true
    },
    bookCategory:{
        type:String,
        required:true
    },
    bookCount:{
        type:Number,
        required:true
    },
    bookPublisher:{
        type:String,
        required:true
    },
    bookEdition:{
        type:String,
        required:true
    },
    bookPrice:{
        type:Number,
        required:true
    },
    bookPublishedYear:{
        type:Number,
        required:true
    },
    addedBy:{
        type:String,
        required:true
    }

},{timestamps:true})

const BOOK=new mongoose.model("BOOK",addbookSchema)

module.exports=BOOK