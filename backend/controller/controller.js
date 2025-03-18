const chalk = require("chalk");
const bcrypt = require("bcryptjs");
const USER = require("../models/user.models");
const BOOK = require("../models/add_book.models");
const STUDENT=require("../models/add_student.models");
const REQBOOK = require("../models/req_book.models");



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
const getLibrarianEmailController = async (req, res) => {
  const { role, email } = req.body;
  const student = await STUDENT.findOne({email});
  
  if (!student) {
      return res.status(404).json({ message: "Student not found" });
  }
  if (role !== "Student") {
      return res.status(403).json({ message: "User role must be Student" });
  }
  res.json({ addedBy: student.addedBy });
};

//update book vailablity controller
const updateBookAvailablityController = async (req, res) => {
  const { _id, bookAvailablity } = req.body;

  try {
    if (!_id || bookAvailablity === undefined) {
      return res.status(400).json({ message: "Missing required fields" });
    }
    const updatedBook = await BOOK.findByIdAndUpdate(
      _id,
      { $set: { bookAvailablity: bookAvailablity } }, 
      { new: true } 
    );

    if (!updatedBook) {
      return res.status(404).json({ message: "Book not found" });
    }

    res.json({ message: "Book availability updated", updatedBook });
  } catch (error) {
    console.error("Error updating book:", error);
    res.status(500).json({ message: "Server error", error });
  }
};

//get book availablity controller
const getBookAvailabilityController = async (req, res) => {
  const { _id } = req.body;  // Read ID from request body
  try {
      const book = await BOOK.findById(_id);
      if (!book) { 
          return res.status(404).json({ message: "Book not found" });
      }
      res.status(200).json({msg:"Fetching done",bookAvailablity:book.bookAvailablity})
  } catch (error) {
      console.error("Error fetching book availability:", error);
      res.status(500).json({ message: "Server error", error });
  }
};

//request book controller
const reqBookController=async (req,res)=>{
  const {bookId,bookName,bookCategory,bookPublisher,bookEdition,bookPrice,bookPublishedYear,studentEmail,addedBy,days}=req.body
  try {
    const reqBook=await new REQBOOK({
      bookId,
      bookName,
      bookCategory,
      bookPublisher,
      bookEdition,
      bookPrice,
      bookPublishedYear,
      studentEmail,
      addedBy,
      days
    })
    const reqBookData=await reqBook.save()
    res.status(200).json({msg:"Request sent","reqBookData":reqBookData})
  } catch (error) {
    res.status(500).json({msg:error})
  }
}

//fetch all request controller
const showPendingBookReqController=async (req,res)=>{
  try {
    const {addedBy}=req.body
    const reqestedBook=await REQBOOK.find({
      addedBy:addedBy,
      status:"pending"})
    
    res.status(200).json({"requestedBook":reqestedBook})
  } catch (error) {
    res.status(500).json({"error":error})
  }
}

//fetch single req 
const showReqBookForStudent = async (req, res) => {
  try {
    const { studentEmail } = req.body;

    // ✅ Directly filter by studentEmail and pending status in a single query
    const requestedBook = await REQBOOK.find({
      studentEmail: studentEmail, 
      status: "pending"
    });

    res.status(200).json({ requestedBook });
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};




//accpt/deny request for book
const updateBookRequestStatus = async (req, res) => {
  const { requestId, status } = req.body; // Expecting requestId and status from frontend

  if (!["accepted", "rejected"].includes(status)) {
    return res.status(400).json({ msg: "Invalid status value" });
  }

  try {
    const updatedRequest = await REQBOOK.findByIdAndUpdate(
      requestId,
      { status: status },
      { new: true } // Return updated document
    );

    if (!updatedRequest) {
      return res.status(404).json({ msg: "Request not found" });
    }

    res.status(200).json({ msg: `Request ${status} successfully`, updatedRequest });
  } catch (error) {
    res.status(500).json({ msg: "Server error", error });
  }
};

//exporting
  module.exports={signUpController,loginController,addBookController,addStudentController,showAllBooksController,showAllStudentsController,getLibrarianEmailController,updateBookAvailablityController,getBookAvailabilityController ,reqBookController,showAllBookReqController: showPendingBookReqController,showReqBookForStudent,updateBookRequestStatus}