const mongoose=require("mongoose")

const reqBookSchema=new mongoose.Schema({
    bookId:{
        type:String,
        required:true
    },
    bookName:{
        type:String,
        required:true
    },
    bookCategory:{
        type:String,
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
    studentEmail:{
        type:String,
        required:true
    },
    addedBy:{
        type:String,
        required:true
    },
    status:{
        type: String,
        enum: ["pending", "accepted", "rejected"],
        default: "pending"
    },
    days:{
        type:Number,
        required:true
    }
},{timestamps:true})

const REQBOOK=mongoose.model("REQBOOK",reqBookSchema)
module.exports=REQBOOK