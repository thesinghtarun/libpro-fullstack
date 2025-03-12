const chalk = require("chalk");
const bcrypt = require("bcryptjs");
const USER = require("../models/user.models");
const BOOK = require("../models/add_book.models");
const STUDENT=require("../models/add_student.models");



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
    console.log(chalk.red("User not found with email",email))
    return res.status(404).json({msg:"User not Found"})
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

//addBook Controller
const addBookController=async (req,res)=>{
  try {
    const {bookName,bookCategory,bookCount,bookPublisher,bookEdition,bookPrice,bookPublishedYear,addedBy}=req.body
    const books=await new BOOK(
      {bookName,bookCategory,bookCount,bookPublisher,bookEdition,bookPrice,bookPublishedYear,addedBy}
    )
    await books.save()
    console.log(books)
    res.status(200).json({msg:"Book Added Successfully",books})
  } catch (error) {
    res.status(500).json({msg:error})
  }
}

//addStudent Controller
const addStudentController=async (req,res)=>{
  try {
    const {name,email,password,role,branch,course,sem,div,addedBy}=req.body
    const existingUser=await USER.findOne({email})
    if(existingUser){
      return res.status(400).json({msg:"Student already exists with email provided"})
    }
    const hashedPassword=await bcrypt.hash(password,10)
    //to save student credentials
    const newUser=new USER({name,email,password:hashedPassword,role})
    await newUser.save()
    //to save student other details
    const student=await new STUDENT({email,branch,course,sem,div,addedBy})
    await student.save()
    res.status(200).json({msg:"Student added Successfully",student})
  } catch (error) {
    console.log(chalk.red(error))
    res.status(500).json({msg:error})
  }
}

//to show all books from db
const showAllBooksController=async (req,res)=>{
  const {addedBy}=req.body
  try {
    
    var bookData=await BOOK.find({addedBy})
    
    console.log(chalk.green(bookData))
    res.status(200).send(bookData)
  } catch (error) {
    console.log(chalk.red("Something went wrong"))
    res.status(500).json({msg:error})
  }
}
const showAllStudentsController = async (req, res) => {
  try {
    const { addedBy } = req.body;

    // Get students whose addedBy matches the given email
    const studentDetails = await STUDENT.find({ addedBy });

    // Extract emails of students added by this admin
    const studentEmails = studentDetails.map(student => student.email);

    // Get users with role "Student" whose email is in studentEmails list
    const studentCredential = await USER.find({
      role: "Student",
      email: { $in: studentEmails }
    });

    // Merge user credentials and student details
    const mergedStudents = studentCredential.map(cred => {
      const details = studentDetails.find(det => det.email === cred.email);
      return {
        ...cred.toObject(), // Convert Mongoose document to plain object
        ...details?.toObject(), // Merge details if found
      };
    });

    res.status(200).json({ students: mergedStudents });
  } catch (error) {
    console.error("Error fetching students:", error);
    res.status(500).json({ msg: "Internal Server Error", error: error.message });
  }
};

//to get Librarian email
const getLibrarianEmailController=(req,res)=>{

}



//exporting
  module.exports={signUpController,loginController,addBookController,addStudentController,showAllBooksController,showAllStudentsController}