import { email } from "zod";
import { userData } from "../types/user";
import pool from "../config/db";
import logger from "../config/logger";
import { sendEmail } from "../utils/mailer";

export const validateEmailService=async({email}:userData)=>{

    const emailValidate=await pool.query("SELECT * from users where email=$1",[email]);
    if(emailValidate.rows.length===0){
        logger.error("User with this email address doesn't exists");
        throw new Error("User with this email address doesn't exists");
    }
    const username=emailValidate.rows[0].name;
    const otp=Math.floor(100000+Math.random()*900000);
    await sendEmail(email,otp,username);

}