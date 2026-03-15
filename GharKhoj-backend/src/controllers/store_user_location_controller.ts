import { Request,Response } from "express"
import { storeUserLocationService } from "../service/store_user_location_service";
export const storeUserLocationController=async(req:Request,res:Response)=>{
    try{
    const {email,longitude,latitude}=req.body;
    await storeUserLocationService(longitude,latitude,email);
    res.status(200).json({
        message:"Location saved"
    })
    }
    catch(error:any){
        res.status(400).json({message:error.message})
    }

}