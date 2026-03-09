import { any } from "zod";
import { validateEmailService } from "../service/password_change_service";
import { Request, Response } from "express";

export const validateEmailController=async(req:Request,res:Response)=>{
    try{
        console.log(req.body);
const email=req.body;
const validityStatus=await validateEmailService(email);

res.status(200).json({message:"User verified successfully"});

    }
    catch(error:any){
        res.status(400).json({message:error.message})

    }
}