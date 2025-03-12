const mongoose = require("mongoose");

const addStudentSchema = new mongoose.Schema({
    email: { type: String, required: true, unique: true, ref: "USER" }, // Reference to User by email
    branch: { type: String, required: true },
    course: { type: String, required: true },
    sem: { type: String, required: true },
    div: { type: String, required: true },
    addedBy:{type: String, required: true}
}, { timestamps: true });

const STUDENT = mongoose.model("STUDENT", addStudentSchema);
module.exports = STUDENT;
