const chalk = require("chalk");
const bcrypt = require("bcryptjs");
const USER = require("../models/user.models");



//signUp controller
const signUpController=async (req, res) => 
    {
    try {
      const { name, email, password ,role} = req.body;
  
      // Check if name or email already exists
      
      const existingEmail = await USER.findOne({ email });
      if (existingEmail) {
        return res.status(400).json({ msg: "email already exists" });
      }
  
      // Hash the password before storing it
      if(typeof(password)!=="string"){
          return res.status(400).json({msg:"Password must be Alphabets"})
      }
      const salt = await bcrypt.genSalt(10);    
      const hashedPassword = await bcrypt.hash(password, salt);
  
      // Create and save new user
      const newUser = new USER({ name, email, password:hashedPassword,role});
      await newUser.save();
  
      console.log({name,email,password,role});
      
      res.status(201).json({ msg: "Registered successfully", user: { name, email } });
    } catch (e) {
      console.log(chalk.red("Something went wrong:", e));
      res.status(500).json({ msg: "Server error" });
    }
  }

//login Controller
const loginController=async (req,res)=>{
  try{
    const {email,password}=req.body
    console.log({email,password})
  const user=await USER.findOne({email})
  if(!user){
    return res.status(404).json({msg:"User not Found"})
    console.log(chalk.red("User not found with email",email))
  }
  const isMatch=await bcrypt.compare(password,user.password)
  if(!isMatch){
    return res.status(401).json({msg:"Incorrect Password"})
  }
  res.status(200).json({msg:"Log in Successfull",user})
  console.log(chalk.black(password,user.password))
  }catch(e){
    console.log(chalk.red("Something went wrong while finding User:",e))
  }
}


//exporting
  module.exports={signUpController,loginController}