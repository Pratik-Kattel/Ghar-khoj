import { Request,Response } from "express";
import { getUserDataService } from "../service/get_user_data_service";
export const getUserDataController=async(req:Request,res:Response)=>{
    try{
       console.log("Headers:", req.headers['content-type']);
    console.log("Full body:", req.body);
    const { email } = req.body;
    console.log("Email extracted:", email);
       const name= await getUserDataService({email});
       console.log(name);
        res.status(200).json({message:"User verified successfully",
            name:name
        })
    }
    catch(error:any){
        res.status(400).json({message:error.message})

    }

}