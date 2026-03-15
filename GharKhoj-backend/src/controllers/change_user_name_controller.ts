import { Request,Response } from "express"
import { changeUsernameService } from "../service/change_user_name_service";
export const changeUsernameController=async(req:Request,res:Response)=>{
    try{
        const {email,name}=req.body;
        await changeUsernameService(email,name);
        res.status(200).json({message:"Name changed successfully"})
    }
    catch(error:any){
        res.status(400).json({message:error.message})
    }
}