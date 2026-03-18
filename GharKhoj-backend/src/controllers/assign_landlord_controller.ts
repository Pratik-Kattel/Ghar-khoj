import { Request,Response } from "express"
import { changeLandlordService } from "../service/assign_landlord_service";

export const changeLandlordController=async(req:Request,res:Response)=>{
    const {email}=req.body;
    try{
        await changeLandlordService(email);
        res.status(200).json({message:"Role changed successfully"})
    }
    catch(error:any){
        res.status(400).json({message:error.message});

    }
    
}