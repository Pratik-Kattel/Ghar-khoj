import { validateEmailService } from "../service/password_change_service";
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