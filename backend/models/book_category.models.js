const mongoose=require("mongoose")


const bookCategorySchema=new mongoose.Schema({
    bookCategory: { type: String, required: true,  ref: "BOOK" },
    addedBy:{type:String,required:true , ref:"BOOK"},
})

const BOOKCATEGORY=mongoose.model("BOOKCATEGORY",bookCategorySchema)

module.exports=BOOKCATEGORY

