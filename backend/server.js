require("dotenv").config();
const mongoose = require("mongoose");
const chalk = require("chalk");
const bcrypt = require("bcryptjs");
const express = require("express");
const USER = require("./models/signIn.models");
const app = express();

const db = process.env.MONGODB;
const port = process.env.PORT;

app.use(express.json());

// MongoDB Connection
mongoose
  .connect(db, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log(chalk.blue("MongoDB connected")))
  .catch((e) => console.log(chalk.red("Error while connecting to DB:", e)));

// Port to Listen
app.listen(port, () => {
  console.log(chalk.blue("Listening on port", port));
});

// Sign In Route
app.post("/api/signIn", async (req, res) => {
  try {
    const { userName, email, password } = req.body;

    // Check if email or username already exists
    const existingEmail = await USER.findOne({ email });
    if (existingEmail) {
      return res.status(400).json({ msg: "Email already exists" });
    }

    const existingUserName = await USER.findOne({ userName });
    if (existingUserName) {
      return res.status(400).json({ msg: "Username already exists" });
    }

    // Hash the password before storing it
    if(typeof(password)!=="string"){
        return res.status(400).json({msg:"Password must be Alphabets"})
    }
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create and save new user
    const newUser = new USER({ userName, email, password:hashedPassword });
    await newUser.save();

    res.status(201).json({ msg: "User registered successfully", user: { userName, email } });
  } catch (e) {
    console.log(chalk.red("Something went wrong:", e));
    res.status(500).json({ msg: "Server error" });
  }
});
