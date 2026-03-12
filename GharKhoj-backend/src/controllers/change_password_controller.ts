import { saveNewPasswordService, validateEmailService, validateOTPService } from "../service/password_change_service";
import { Request, Response } from "express";
import { sendEmail } from "../utils/mailer";
import pool from "../config/db";

export const validateEmailController=async(req:Request,res:Response)=>{
    try{
const email=req.body;
const validityStatus=await validateEmailService(email);
res.status(200).json({message:"User verified successfully"});

    }
    catch(error:any){
        console.log(error);
        res.status(400).json({message:error.message})

    }
}

export const validateOTPController=async(req:Request,res:Response)=>{
    try{
    const {email,otp}=req.body;
    console.log(req.body);
    const otpValidation=await validateOTPService(email,otp);
    res.status(200).json({message:"OTP verified successfully"});
    }
    catch(error:any){
        res.status(400).json({message:error.message});
    }
}

export const saveNewPasswordController=async(req:Request,res:Response)=>{
    const {password,email}=req.body;
    try{
        await saveNewPasswordService(password,email);
        res.status(200).json({message:"Password changed successfully"});

    }
    catch(error:any){
        res.status(400).json({message:error.message});
    }
}