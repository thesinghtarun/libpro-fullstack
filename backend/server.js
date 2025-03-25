require("dotenv").config();
const mongoose = require("mongoose");
const chalk=require("chalk")
const cors=require("cors")
const express = require("express");
const { 
  signUpController,
  loginController,
  addBookController,
  addStudentController,
  showAllBooksController,
  showAllStudentsController,
  getLibrarianEmailController,
  updateBookAvailablityController,
  getBookAvailabilityController,
  reqBookController,
  showPendingBookReqController,
  showReqBookForStudent,
  updateBookRequestStatus,
  decreaseBookCount,
  fetchCategory,
  fetchBookBasedOnCategory,
  updatePasswordController,
  searchBookController,
  mostReqBookController,
  showALLReqController,
  showReportController
} = require("./controller/controller");
const app = express();

const db = process.env.MONGODB;
const port = process.env.PORT;

app.use(express.json());
app.use(cors())

// MongoDB Connection
mongoose
  .connect(db, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log(chalk.blue("MongoDB connected")))
  .catch((e) => console.log(chalk.red("Error while connecting to DB:", e)));

// Port to Listen
app.listen(port, () => {
  console.log(chalk.blue("Listening on port", port));
});

// Sign Up Route
app.post("/api/signUp", signUpController);

//Sign In Route
app.post("/api/login",loginController);

//Add Book Route
app.post("/api/addBook",addBookController);

//Add Student Route
app.post("/api/addStudent",addStudentController);

//show all books Route
app.post("/api/showAllBooks",showAllBooksController);

// show all students Route
app.post("/api/showAllStudents",showAllStudentsController);

//fetch librarian email Route
app.post("/api/fetchLibrarianEmail",getLibrarianEmailController);

//update book availablity Route
app.post("/api/updateBookavailablity",updateBookAvailablityController);

//fetch book availablity Route
app.post("/api/getBookAvailablity",getBookAvailabilityController);

//req to librarian for book Route
app.post("/api/requestBook",reqBookController);

// fetch all req book Route
app.post("/api/getPendingReqBook",showPendingBookReqController);

//to fetch and show req book to student Route
app.post("/api/getReqBookForStudent",showReqBookForStudent);

//to update status of req book Route
app.post("/api/updateBookRequestStatus",updateBookRequestStatus);

// to decrease book count when accepted Route
app.post("/api/decreaseBookCount",decreaseBookCount);

//to fetch all category of book Route
app.post("/api/fetchBookCategory",fetchCategory);

//to fetch all book based on same librarian and category Route
app.post("/api/fetchBookBasedOnCategory",fetchBookBasedOnCategory);

// to update password of a user Route
app.post("/api/updatePassword",updatePasswordController);

// to search book/s Route
app.post("/api/searchBookController",searchBookController);

//to add most req book to db Route
app.post("/api/mostReqBookController",mostReqBookController)

//to fetch all req made by student Route
app.post("/api/showALLReqController",showALLReqController);

//to fetch most req book Route
app.post("/api/showReportController",showReportController);
