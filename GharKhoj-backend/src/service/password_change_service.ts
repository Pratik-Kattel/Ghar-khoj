import { email, number } from "zod";
import { userData } from "../types/user";
import cuid from 'cuid';
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
    const user_id=emailValidate.rows[0].user_id;
    const otp=Math.floor(100000+Math.random()*900000);
    await sendEmail(email,otp,username);
    const expires_at=new Date(Date.now()+5*60*1000);
    const otp_id=cuid();
    const expiry=await pool.query("Insert into otp_logs(otp_id,user_id,otp_code,purpose,expires_at,email) VALUES ($1,$2,$3,$4,$5,$6) RETURNING *",[otp_id,user_id,otp,"Password_change",expires_at,email]);
}

export const validateOTPService=async(email:String,otp:number)=>{
    const otpQuery=await pool.query("Select * from otp_logs where email=$1 AND otp_code=$2",[email,otp]);
    if(otpQuery.rows.length===0){
        throw new Error("Please enter valid otp number");
        
    }
    const otpData=otpQuery.rows[0];
    const OTP=otpData.otp_code;
    if(new Date()>otpData.expires_at){
        throw new Error("OTP expired please get another one.")
    }

    await pool.query("DELETE FROM otp_logs where email=$1 AND otp_code=$2",[email,otp]);
    return true;

}