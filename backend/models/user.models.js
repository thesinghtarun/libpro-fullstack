const mongoose=require("mongoose")



const userSchema=new mongoose.Schema({
    
    name:{
        type:String,
        required:true,
    },
    email:{
        type:String,
        required:true,
        unique:true
    },
    password:{
        type:String,
        required:true,
    },
    role:{
        type:String,
    }
},{timestamps:true})


const USER=new mongoose.model("USER",userSchema)

module.exports=USER