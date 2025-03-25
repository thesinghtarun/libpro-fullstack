const mongoose=require('mongoose')

const mostReqBookSchema=new mongoose.Schema({
    bookId:{type:String,required:true,ref:"REQBOOK"},
    bookName:{type:String,required:true,ref:"REQBOOK"},
    bookEdition:{type:String,required:true,ref:"REQBOOK"},
    count:{type:Number,default:1},
    addedBy:{type:String,required:true,ref:"REQBOOK"}
})

const MOSTREQBOOK=new mongoose.model("MOSTREQBOOK",mostReqBookSchema)

module.exports=MOSTREQBOOK